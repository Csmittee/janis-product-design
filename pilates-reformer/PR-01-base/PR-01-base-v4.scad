// PR-01-base-v4.scad
// Janis Product Design — Pilates Reformer with Full Tower
// Version: v4
// Date: 2026-06-30
// Focus: Frame structure + joints only. No slider, no spring, no strap.
// Rules: rules-pr.md, rules-dimensions.md, .claude/rules-codes.md
// Changes from v3:
//   Fix 1: pole_body() lattice/truss removed — was a 12-step hull() loft producing
//           visible facet seams. Replaced with single hull() between two D-section
//           cross-sections (base r=23 @ z=0, taper r=18 @ z=taper_h) — one smooth
//           solid surface, no internal ribs.
//   Fix 2: D-cut direction (dir) now computed per-pole from cy vs bed_w/2, so the
//           flat face always points toward the bed's lateral (Y) centerline.
//   Confirmed: pole_top_collar() bore and crossbar_body() remain X-axis (longitudinal)
//           — unchanged from v3, re-verified correct against coordinate standard.

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

// ── Pole D-profile shape ──────────────────────────────────────────────
pole_base_d   = 46;          // effective diameter at base (fat end)
pole_top_d    = 36;          // diameter at taper end + upper section
r_base        = pole_base_d / 2;   // 23mm
r_top_taper   = pole_top_d  / 2;   // 18mm

// ── Grip bar (crossbar) ───────────────────────────────────────────────
grip_od     = 32;     // OWNER-LOCKED — do not change without Janis approval
grip_l      = bed_l;  // crossbar length = bed length (X-axis) = 2300mm
grip_offset = 0;      // lateral offset from pole centerline — TBD

// ── Clamp / collar ────────────────────────────────────────────────────
clamp_h     = 80;     // mid clamp body height
clamp_od    = pole_od + 30; // clamp outer diameter
collar_h    = 60;     // top collar height
collar_od   = pole_od + 25; // top collar outer diameter — 73mm
lever_l     = 40;     // lock lever length

// ── Top collar detail ─────────────────────────────────────────────────
cam_od      = 20;     // cam lock body outer diameter
cam_h       = 15;     // cam lock body height (protrudes from collar side)
ring_h      = 8;      // knurled grip ring height
ridge_count = 24;     // number of ridges around knurled ring

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
show_top_collars  = true;
show_base_sockets = true;
show_fold_joints  = false;  // foldable variant — off by default in Classic Std

// ── Derived ───────────────────────────────────────────────────────────
surface_t   = 30;                         // bed surface platform thickness
pole_top_z  = bed_h + pole_h;            // 2100mm — top of poles
socket_od   = pole_od + 14;              // socket body outer diameter
socket_bore = pole_od + 0.5;            // bore clearance — M-PR-1: never exact pole_od
bore_d      = grip_od + 1;              // 33mm — crossbar bore clearance (0.5mm/side)
ring_od     = collar_od + 4;            // 77mm — knurled ring outer diameter

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

// Crossbar Z — centre of top collar (crossbar passes through mid-height of collar)
xbar_z = pole_top_z - collar_h/2;      // 2070mm

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

// D-shaped cross-section: circle with a flat cut on the inward side (dir = +1 cuts +Y, -1 cuts -Y)
module pole_d_section(r, h, dir) {
    cut_y0 = dir > 0 ? 0.7 * r : -(r + 1);
    difference() {
        cylinder(h = h, r = r, $fn = 64);
        translate([-r - 1, cut_y0, -e]) cube([r * 2 + 2, 0.3 * r + 1, h + 2 * e]);
    }
}

// Single smooth hull loft from r_base (floor) to r_top_taper (40% height) — no internal seams
module pole_lower_taper(taper_h, dir) {
    hull() {
        pole_d_section(r_base, e, dir);
        translate([0, 0, taper_h]) pole_d_section(r_top_taper, e, dir);
    }
}

module pole_body(cx, cy) {
    // Solid D-profile: tapered lower 40% (single hull loft) + circular upper 60%; brushed steel
    taper_h = pole_h * 0.4;   // 640mm
    dir = (cy < bed_w / 2) ? 1 : -1;   // flat face points toward bed lateral centerline
    color("#CCCCCC", 1.0) {
        translate([cx, cy, bed_h])
            pole_lower_taper(taper_h, dir);
        translate([cx, cy, bed_h + taper_h])
            cylinder(h = pole_h * 0.6, d = pole_top_d, $fn = 64);
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

// ─────────────────────────────────────────────────────────────────────
// POLE TOP COLLAR — detailed geometry
// Crossbar bore X-axis (side-to-side) = longitudinal along bed length.
// Cam lock on +Y side (perpendicular to crossbar bore). Knurled ring at base.
// ─────────────────────────────────────────────────────────────────────

module pole_top_collar(cx, cy) {
    collar_base_z = pole_top_z - collar_h;
    color("#2C3E50", 1.0)
        translate([cx, cy, collar_base_z])
            difference() {
                cylinder(h = collar_h, d = collar_od);
                // X-axis bore: center=true cuts side-to-side through collar
                // Contact receipt: bore d=33mm, centred at collar mid-height ✓
                translate([0, 0, collar_h/2])
                    rotate([0, 90, 0])
                        cylinder(h = collar_od + 2, d = bore_d, center = true);
            }
    // Cam lock body — +Y side, 2mm overlap into collar for manifold-safe union
    // Contact receipt: cam base at cy + collar_od/2 - 2 = cy + 34.5mm ✓
    color("#2C3E50", 1.0)
        translate([cx, cy + collar_od/2 - 2, collar_base_z + collar_h * 0.6])
            rotate([-90, 0, 0])
                cylinder(h = cam_h, d = cam_od);
    // Red accent button — 1mm overlap into cam for manifold-safe union ✓
    color("#C0392B", 1.0)
        translate([cx, cy + collar_od/2 - 2 + cam_h - 1, collar_base_z + collar_h * 0.6])
            rotate([-90, 0, 0])
                cylinder(h = 6, d = cam_od - 4);
    // Knurled ring — wider, shorter cylinder at collar base
    color("#AAAAAA", 1.0)
        translate([cx, cy, collar_base_z])
            cylinder(h = ring_h, d = ring_od);
    // Vertical ridges around ring — 24 evenly spaced thin fins
    for (a = [0 : 360/ridge_count : 359])
        color("#888888", 1.0)
            translate([cx, cy, collar_base_z]) rotate([0, 0, a])
                translate([ring_od/2 - 3, -1, 0])
                    cube([4, 2, ring_h]);
}

// ═════════════════════════════════════════════════════════════════════
// MODULES — CROSSBAR (X-axis: longitudinal along bed length)
// ═════════════════════════════════════════════════════════════════════

module crossbar_body(y_pos) {
    // X-axis grip bar — passes through front (or rear) pair of top collars at xbar_z
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
    if (show_base_sockets) pole_base_socket(cx, cy);
    if (show_poles)        pole_body(cx, cy);
    if (show_mid_clamps)   pole_mid_clamp(cx, cy);
    if (show_top_collars)  pole_top_collar(cx, cy);
    if (show_fold_joints)  pole_fold_joint(cx, cy);
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
