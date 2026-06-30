// PR-01-base-v5.scad
// Janis Product Design — Pilates Reformer with Full Tower
// Version: v5
// Date: 2026-06-30
// Focus: Frame structure + joints only. No slider, no spring, no strap.
// Rules: rules-pr.md, rules-dimensions.md, .claude/rules-codes.md
// Changes from v4 (pole redesign per Janis hand-sketch "Pilates_full_tower_design"):
//   - pole_top_collar() REMOVED entirely — pole top itself now acts as the collar
//   - pole_body() redesigned as ONE continuous D-profile piece: blocky base (0-15%
//     pole_h) → smooth taper zone (15-85%) → narrowing rounded top (85-100%)
//   - D-flat face normal now points along X (front-to-rear), not Y — flat plane
//     lies in the Y-Z plane per coordinate standard. Front pole pair flat faces
//     toward rear (+X); rear pole pair flat faces toward front (-X)
//   - Tooth zone groove recess added on flat face (40-88% of pole_h) — placeholder,
//     no teeth modeled yet
//   - Bar insert hole drilled through pole near top (bore axis X) — crossbar now
//     passes directly through the pole, not a separate collar
//   - New pole_base_bushing() — small separate component at wood/pole interface

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
pole_base_d   = 46;          // diameter at base (widest, blocky zone)
pole_top_d    = 36;          // diameter at end of taper zone (85% pole_h)
r_base        = pole_base_d / 2;   // 23mm
r_top_taper   = pole_top_d  / 2;   // 18mm
r_top_final   = r_top_taper * 0.9; // slight further narrowing at the very top
pole_base_h   = pole_h * 0.15;     // blocky base zone height
pole_taper_z1 = pole_h * 0.85;     // taper zone end (z rel. to bed_h)
pole_top_h    = pole_h - pole_taper_z1; // narrowing/rounded top zone height
tooth_zone_z0 = pole_h * 0.40;     // tooth (rack) zone start
tooth_zone_z1 = pole_h * 0.88;     // tooth zone end — clear of bore zone
tooth_depth   = 3;                 // groove recess depth — placeholder, no teeth yet
bore_z        = pole_h * 0.96;     // bar insert hole, centred in last 8% of pole_h
bushing_od    = pole_base_d + 12;  // base bushing outer diameter
bushing_h     = 25;                // base bushing height

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

// Continuous solid: blocky base + smooth taper + narrowing top — single D-profile, no seams
module pole_solid(dir) {
    pole_d_section(r_base, pole_base_h, dir);
    translate([0, 0, pole_base_h])
        hull() {
            pole_d_section(r_base, e, dir);
            translate([0, 0, pole_taper_z1 - pole_base_h])
                pole_d_section(r_top_taper, e, dir);
        }
    translate([0, 0, pole_taper_z1])
        hull() {
            pole_d_section(r_top_taper, e, dir);
            translate([0, 0, pole_top_h])
                pole_d_section(r_top_final, e, dir);
        }
}

// Very top — rounded/domed, not flat cut. Overlaps body by e for manifold-safe union.
module pole_top_dome() {
    translate([0, 0, pole_h - e])
        intersection() {
            sphere(r = r_top_final, $fn = 64);
            translate([-r_top_final, -r_top_final, 0])
                cube([r_top_final * 2, r_top_final * 2, r_top_final]);
        }
}

// Bar insert hole — bore axis along X (longitudinal), crossbar passes through here
module pole_bore_cut() {
    translate([0, 0, bore_z])
        rotate([0, 90, 0])
            cylinder(h = pole_base_d + 4, d = bore_d, center = true);
}

// Tooth zone (rack gear mounting strip) — shallow recess on flat face, placeholder only
module pole_tooth_groove_cut(dir) {
    flat_w   = 2 * sqrt(pow(r_top_taper, 2) - pow(0.7 * r_top_taper, 2));
    groove_w = flat_w * 0.6;
    groove_h = tooth_zone_z1 - tooth_zone_z0;
    cut_x0   = dir > 0 ? 0.7 * r_top_taper - tooth_depth : -0.7 * r_top_taper - e;
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
                    cylinder(h = bushing_h + 2 * e, d = pole_base_d + 1, $fn = 64);
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
