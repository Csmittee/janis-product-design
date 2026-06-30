// PR-01-base-v6.scad
// Janis Product Design — Pilates Reformer with Full Tower
// Version: v6
// Date: 2026-06-30
// Focus: Frame structure + joints only. No slider, no spring, no strap.
// Rules: rules-pr.md, rules-dimensions.md, .claude/rules-codes.md
// Changes from v5 (pole taper spec redo per Janis direct instruction):
//   - pole_body() taper redefined by FLAT-FACE WIDTH, not diameter: flat_w_base=100mm
//     at z=0, tapers to flat_w_top=60mm by z=transition_h(400mm) — "horn" curve
//     (fast taper near base, flattening out approaching the top width), modeled as
//     an 8-segment hull loft using a logarithmic width function (smooth, not a hard
//     cone). From transition_h to pole_h, flat width holds constant at 60mm.
//   - Round portion of the D now scales off flat width via pole_r_from_flat() —
//     same circular relationship used previously (r = flat_w / (2*sqrt(1-0.7^2)))
//   - r_base ~70mm, r_top ~42mm (was r_base=23mm, r_top_taper=18mm in v5 — v5 used
//     diameter directly as a much smaller stand-in; this version is the actual spec)
//   - Bore (33mm = grip_od+1) re-verified against r_top=42mm: cut plane at
//     x=0.7*42=29.4mm, bore radius 16.5mm → min wall ~12.9mm — adequate (rules-dimensions.md
//     global min clearance is 2mm)
//   - bore_z, tooth_zone_z0/z1 repositioned to clear the wider/differently-shaped taper
//   - pole_base_bushing() resized off new (larger) r_base instead of old pole_base_d
//   - pole_top_collar() remains removed (per v5); bar passes through bore at pole top

// ── Global ────────────────────────────────────────────────────────────
e           = 0.01;   // epsilon — z-fight prevention
$fn         = 32;     // default resolution (use 64 for final render)

// ── Bed dimensions ────────────────────────────────────────────────────
bed_l       = 2300;   // total bed length (longitudinal) — PENDING Janis confirm
bed_w       = 670;    // total bed width — PENDING Janis confirm
bed_h       = 500;    // floor to top of bed surface — PENDING Janis confirm
leg_w       = 180;    // bed leg width — increased 50% for structural proportion
leg_t       = 120;    // bed leg depth — increased 50% for structural proportion
frame_rail_t = 60;    // bed rail thickness (wood) — PENDING
frame_rail_h = 120;   // bed rail height — PENDING

// ── Pole dimensions ───────────────────────────────────────────────────
pole_od     = 48;     // pole outer diameter — PENDING Janis lock
pole_wall   = 3;      // pole wall thickness (hollow tube)
pole_id     = pole_od - 2*pole_wall;
pole_h      = 1600;   // exposed pole height above bed surface — PENDING
socket_depth = 150;   // how deep socket inserts into bed leg — PENDING
total_pole_l = pole_h + socket_depth;

// ── Pole D-profile shape (single continuous piece — base to top) ──────
// Taper defined by FLAT-FACE WIDTH (per Janis spec) — round portion derives from it.
flat_w_base   = 100;          // flat-face width at base (z=0)
flat_w_top    = 60;           // flat-face width from transition_h to pole_h (constant)
transition_h  = 400;          // taper zone height — horn curve from base to top width
taper_steps   = 8;            // hull-loft segment count — moderate, avoids lattice artifact
function pole_r_from_flat(fw) = fw / (2 * sqrt(1 - pow(0.7, 2))); // r ≈ fw * 0.70013
r_base        = pole_r_from_flat(flat_w_base);   // ~70.0mm
r_top         = pole_r_from_flat(flat_w_top);    // ~42.0mm
// Horn curve: fast taper near base, flattening out near top — logarithmic blend
function pole_flat_w(z) = flat_w_top + (flat_w_base - flat_w_top)
                            * (1 - ln(1 + z / transition_h) / ln(2));
tooth_zone_z0 = transition_h + 20;  // tooth (rack) zone start — clear of taper
tooth_zone_z1 = pole_h - 90;        // tooth zone end — clear of bore/dome zone
tooth_depth   = 3;                  // groove recess depth — placeholder, no teeth yet
bore_z        = pole_h - 60;        // bar insert hole — near top, clear of dome cap (r_top)
bushing_od    = 2 * r_base + 12;    // base bushing outer diameter — scales off new r_base
bushing_h     = 25;                 // base bushing height

// ── Grip bar (crossbar) ───────────────────────────────────────────────
grip_od     = 32;     // OWNER-LOCKED — do not change without Janis approval
grip_l      = bed_l;  // crossbar length = bed length (X-axis) = 2300mm
grip_offset = 0;      // lateral offset from pole centerline — TBD

// ── Clamp ─────────────────────────────────────────────────────────────
clamp_h     = 80;     // mid clamp body height
clamp_od    = pole_od + 30; // clamp outer diameter
lever_l     = 40;     // lock lever length

// ── Fold joint ────────────────────────────────────────────────────────
fold_z      = bed_h;  // fold hinge height = bed surface height
cone_base_d = 120;    // fold cone base diameter — PENDING
cone_top_d  = pole_od + 10; // cone top diameter (accepts pole)
cone_h      = 80;     // cone height
fold_angle  = 0;      // 0 = upright, 90 = folded flat on bed

// ── Debug toggles ─────────────────────────────────────────────────────
show_bed          = true;
show_poles        = true;
show_crossbars    = true;
show_mid_clamps   = true;
show_base_sockets = true;
show_base_bushings = true;
show_fold_joints  = false;  // foldable variant — off by default in Classic Std

// ── Derived ───────────────────────────────────────────────────────────
surface_t   = 30;                         // bed surface platform thickness
socket_od   = pole_od + 14;              // socket body outer diameter
socket_bore = pole_od + 0.5;            // bore clearance — M-PR-1: never exact pole_od
bore_d      = grip_od + 1;              // 33mm — bar insert hole clearance (0.5mm/side)

// Pole corner X positions — [front-left, front-right, rear-left, rear-right]
// Spans 0 to bed_l along X — confirms bed length is X-axis
pole_cx = [leg_w/2, bed_l - leg_w/2, leg_w/2, bed_l - leg_w/2];
// Pole corner Y positions — spans 0 to bed_w along Y
pole_cy = [leg_t/2, leg_t/2, bed_w - leg_t/2, bed_w - leg_t/2];

// Crossbar Y positions — front row at pole_cy[0], rear row at pole_cy[2]
// Crossbars run X-axis (longitudinal = bed length direction)
xbar_y_front = pole_cy[0];   // 60mm — front pole row Y position
xbar_y_rear  = pole_cy[2];   // 610mm — rear pole row Y position

// Mid-clamp Z — 40% up exposed pole height (placeholder; adjustable in v4+)
clamp_mid_z  = bed_h + pole_h * 0.4;   // 1140mm

// Crossbar Z — passes through the bar insert hole drilled in the pole top (no separate collar)
xbar_z = bed_h + bore_z;               // 2036mm

// ═════════════════════════════════════════════════════════════════════
// MODULES — BED
// ═════════════════════════════════════════════════════════════════════

module bed_frame() {
    // Wood box frame: 4 corner legs + longitudinal rails + end crossmembers
    color("#C8A96E", 1.0) {
        for (i = [0:3]) {
            translate([pole_cx[i] - leg_w/2, pole_cy[i] - leg_t/2, 0])
                cube([leg_w, leg_t, bed_h - surface_t]);
        }
        // longitudinal rails — front and rear
        translate([0, 0, bed_h - surface_t - frame_rail_h])
            cube([bed_l, frame_rail_t, frame_rail_h]);
        translate([0, bed_w - frame_rail_t, bed_h - surface_t - frame_rail_h])
            cube([bed_l, frame_rail_t, frame_rail_h]);
        // end crossmembers — foot end and head end
        translate([0, 0, bed_h - surface_t - frame_rail_h])
            cube([frame_rail_t, bed_w, frame_rail_h]);
        translate([bed_l - frame_rail_t, 0, bed_h - surface_t - frame_rail_h])
            cube([frame_rail_t, bed_w, frame_rail_h]);
    }
}

module bed_surface() {
    // Platform top — dark leather placeholder
    color("#222222", 1.0)
        translate([0, 0, bed_h - surface_t])
            cube([bed_l, bed_w, surface_t]);
}

// ═════════════════════════════════════════════════════════════════════
// MODULES — POLE COMPONENTS
// ═════════════════════════════════════════════════════════════════════

module pole_base_socket(cx, cy) {
    // Metal collar pressed into drilled hole in bed leg — stub cylinder
    // Contact receipt: socket Z: bed_h-socket_depth to bed_h — gap to any face >= 2mm (M-2)
    color("#888888", 1.0)
        translate([cx, cy, bed_h - socket_depth])
            cylinder(h = socket_depth, d = socket_od);
}

// D-shaped cross-section: flat face normal along X (flat plane lies in Y-Z plane)
// dir = +1 cuts material on +X side (flat faces +X); dir = -1 cuts -X side (flat faces -X)
module pole_d_section(r, h, dir) {
    cut_x0 = dir > 0 ? 0.7 * r : -(r + 1);
    difference() {
        cylinder(h = h, r = r, $fn = 64);
        translate([cut_x0, -r - 1, -e]) cube([0.3 * r + 1, r * 2 + 2, h + 2 * e]);
    }
}

// Horn-curve taper loft: flat_w_base at z=0 → flat_w_top at z=transition_h, smooth
// logarithmic curve (fast taper near base, flattening near top) via stepped hull segments.
module pole_taper_loft(dir, steps) {
    for (i = [0 : steps - 1]) {
        z0 = transition_h * i / steps;
        z1 = transition_h * (i + 1) / steps;
        hull() {
            translate([0, 0, z0]) pole_d_section(pole_r_from_flat(pole_flat_w(z0)), e, dir);
            translate([0, 0, z1]) pole_d_section(pole_r_from_flat(pole_flat_w(z1)), e, dir);
        }
    }
}

// Continuous solid: horn-curve taper (0-transition_h) + constant-width top zone — no seams
module pole_solid(dir) {
    pole_taper_loft(dir, taper_steps);
    translate([0, 0, transition_h])
        pole_d_section(r_top, pole_h - transition_h, dir);
}

// Very top — rounded/domed, not flat cut. Overlaps body by e for manifold-safe union.
module pole_top_dome() {
    translate([0, 0, pole_h - e])
        intersection() {
            sphere(r = r_top, $fn = 64);
            translate([-r_top, -r_top, 0])
                cube([r_top * 2, r_top * 2, r_top]);
        }
}

// Bar insert hole — bore axis along X (longitudinal), crossbar passes through here
// Wall-thickness check: at bore_z, flat width = flat_w_top(60mm) -> r_top(~42mm),
// cut plane at x=0.7*r_top=29.4mm, bore radius=16.5mm -> min wall ~12.9mm (>> 2mm min, R-002)
module pole_bore_cut() {
    translate([0, 0, bore_z])
        rotate([0, 90, 0])
            cylinder(h = 2 * r_base + 4, d = bore_d, center = true);
}

// Tooth zone (rack gear mounting strip) — shallow recess on flat face, placeholder only
module pole_tooth_groove_cut(dir) {
    groove_w = flat_w_top * 0.6;
    groove_h = tooth_zone_z1 - tooth_zone_z0;
    cut_x0   = dir > 0 ? 0.7 * r_top - tooth_depth : -0.7 * r_top - e;
    translate([cut_x0, -groove_w / 2, tooth_zone_z0])
        cube([tooth_depth + e, groove_w, groove_h]);
}

module pole_body(cx, cy) {
    // Single continuous D-profile: blocky base → smooth taper → narrowing rounded top.
    // Pole top itself is the collar — bar insert hole replaces the old top_collar module.
    // dir: front pole flat faces +X (rear); rear pole flat faces -X (front) — see rules-pr.md
    dir = (cx < bed_l / 2) ? 1 : -1;
    color("#CCCCCC", 1.0)
        translate([cx, cy, bed_h])
            difference() {
                union() {
                    pole_solid(dir);
                    pole_top_dome();
                }
                pole_tooth_groove_cut(dir);
                pole_bore_cut();
            }
}

module pole_base_bushing(cx, cy) {
    // Small separate bushing at wood/pole interface — ring around pole base, flush on leg top
    // Bore clearance keeps it a separate contact-touching part, not an overlapping solid (M-2)
    color("#2C3E50", 1.0)
        translate([cx, cy, bed_h])
            difference() {
                cylinder(h = bushing_h, d = bushing_od, $fn = 64);
                translate([0, 0, -e])
                    cylinder(h = bushing_h + 2 * e, d = 2 * r_base + 1, $fn = 64);
            }
}

module pole_mid_clamp(cx, cy) {
    // Adjustable collar clamp at clamp_mid_z — stub cylinder + lever accent
    color("#2C3E50", 1.0)
        translate([cx, cy, clamp_mid_z - clamp_h/2])
            cylinder(h = clamp_h, d = clamp_od);
    // Contact receipt: lever inner edge overlaps 4mm into body ✓
    color("#C0392B", 1.0)
        translate([cx + clamp_od/2 - 4, cy - 4, clamp_mid_z - 4])
            cube([lever_l + 4, 8, 8]);
}

// ═════════════════════════════════════════════════════════════════════
// MODULES — CROSSBAR (X-axis: longitudinal along bed length)
// ═════════════════════════════════════════════════════════════════════

module crossbar_body(y_pos) {
    // X-axis grip bar — passes through the bar insert hole in each pole at xbar_z
    // Contact receipt: starts x=0, runs to x=grip_l=2300mm, at y=y_pos, z=xbar_z ✓
    color("#DDDDDD", 1.0)
        translate([0, y_pos, xbar_z])
            rotate([0, 90, 0])
                cylinder(h = grip_l, d = grip_od);
}

module crossbar_end_cap(x_pos, y_pos) {
    // Decorative + safety end cap — sphere overlaps bar end for union volume
    color("#AAAAAA", 1.0)
        translate([x_pos, y_pos, xbar_z])
            sphere(d = grip_od + 4);
}

// ═════════════════════════════════════════════════════════════════════
// MODULES — FOLD JOINT (foldable variant — show_fold_joints = false)
// ═════════════════════════════════════════════════════════════════════

module fold_cone_base(cx, cy) {
    color("#555555", 1.0)
        translate([cx, cy, bed_h])
            cylinder(h = cone_h, d1 = cone_base_d, d2 = cone_top_d);
}

module fold_u_bracket(cx, cy) {
    // Contact receipt: bracket base at bed_h + cone_h - e, overlaps cone by e ✓
    bracket_h = 60;
    color("#888888", 1.0)
        translate([cx - 20, cy - 10, bed_h + cone_h - e])
            cube([40, 20, bracket_h]);
}

module fold_hinge(cx, cy) {
    // Contact receipt: hinge at Z=bed_h+cone_h+30 (inside bracket range) ✓
    color("#AAAAAA", 1.0)
        translate([cx, cy, bed_h + cone_h + 30])
            rotate([90, 0, 0])
                cylinder(h = 60, d = 20, center = true);
}

module pole_fold_joint(cx, cy) {
    fold_cone_base(cx, cy);
    fold_u_bracket(cx, cy);
    fold_hinge(cx, cy);
}

// ═════════════════════════════════════════════════════════════════════
// SUB-ASSEMBLIES
// ═════════════════════════════════════════════════════════════════════

module bed_assembly() {
    if (show_bed) {
        bed_frame();
        bed_surface();
    }
}

module pole_assembly(i) {
    // One pole corner — called 4x from pr01_assembly
    cx = pole_cx[i];
    cy = pole_cy[i];
    if (show_base_sockets)  pole_base_socket(cx, cy);
    if (show_base_bushings) pole_base_bushing(cx, cy);
    if (show_poles)         pole_body(cx, cy);
    if (show_mid_clamps)    pole_mid_clamp(cx, cy);
    if (show_fold_joints)   pole_fold_joint(cx, cy);
}

module crossbar_assembly() {
    if (show_crossbars) {
        // Two X-axis bars — front row (y=xbar_y_front) and rear row (y=xbar_y_rear)
        crossbar_body(xbar_y_front);
        crossbar_body(xbar_y_rear);
        // End caps — 2 bars × 2 ends = 4 caps (x=0 and x=grip_l at each Y row)
        crossbar_end_cap(0,      xbar_y_front);
        crossbar_end_cap(grip_l, xbar_y_front);
        crossbar_end_cap(0,      xbar_y_rear);
        crossbar_end_cap(grip_l, xbar_y_rear);
    }
}

// ═════════════════════════════════════════════════════════════════════
// FULL ASSEMBLY
// ═════════════════════════════════════════════════════════════════════

module pr01_assembly() {
    bed_assembly();
    for (i = [0:3]) pole_assembly(i);
    crossbar_assembly();
}

// ── RENDER ────────────────────────────────────────────────────────────
pr01_assembly();
