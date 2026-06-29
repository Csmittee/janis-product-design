// PR-01-base-v2.scad
// Janis Product Design — Pilates Reformer with Full Tower
// Version: v2
// Date: 2026-06-29
// Focus: Frame structure + joints only. No slider, no spring, no strap.
// Rules: rules-pr.md, rules-dimensions.md, .claude/rules-codes.md
// Changes from v1:
//   Fix 1: pole_top_collar() — replaced stub with detailed geometry:
//           main body + horizontal crossbar bore + cam lock + knurled ring + ridges
//   Fix 2: Added top collar detail params (cam_od, cam_h, ring_h, ridge_count)

// ── Global ────────────────────────────────────────────────────────────
e           = 0.01;   // epsilon — z-fight prevention
$fn         = 32;     // default resolution (use 64 for final render)

// ── Bed dimensions ────────────────────────────────────────────────────
bed_l       = 2300;   // total bed length (longitudinal) — PENDING Janis confirm
bed_w       = 670;    // total bed width — PENDING Janis confirm
bed_h       = 500;    // floor to top of bed surface — PENDING Janis confirm
leg_w       = 120;    // bed leg width (square) — PENDING
leg_t       = 80;     // bed leg depth — PENDING
frame_rail_t = 60;    // bed rail thickness (wood) — PENDING
frame_rail_h = 120;   // bed rail height — PENDING

// ── Pole dimensions ───────────────────────────────────────────────────
pole_od     = 48;     // pole outer diameter — PENDING Janis lock
pole_wall   = 3;      // pole wall thickness (hollow tube)
pole_id     = pole_od - 2*pole_wall;
pole_h      = 1600;   // exposed pole height above bed surface — PENDING
socket_depth = 150;   // how deep socket inserts into bed leg — PENDING
total_pole_l = pole_h + socket_depth;

// ── Grip bar (crossbar) ───────────────────────────────────────────────
grip_od     = 32;     // OWNER-LOCKED — do not change without Janis approval
grip_l      = bed_l;  // crossbar length = bed length
grip_offset = 0;      // lateral offset from pole centerline — TBD

// ── Clamp / collar ────────────────────────────────────────────────────
clamp_h     = 80;     // mid clamp body height
clamp_od    = pole_od + 30; // clamp outer diameter
collar_h    = 60;     // top collar height
collar_od   = pole_od + 25; // top collar outer diameter — 73mm
lever_l     = 40;     // lock lever length

// ── Top collar detail (v2) ────────────────────────────────────────────
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
pole_cx = [leg_w/2, bed_l - leg_w/2, leg_w/2, bed_l - leg_w/2];
// Pole corner Y positions
pole_cy = [leg_t/2, leg_t/2, bed_w - leg_t/2, bed_w - leg_t/2];

// Crossbar Y centrelines — front and rear pole rows
xbar_y_front = leg_t/2;              // front pair
xbar_y_rear  = bed_w - leg_t/2;     // rear pair

// Mid-clamp Z — 40% up exposed pole height (placeholder; adjustable in v3+)
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
    // socket_bore: cx,cy, Z: bed_h-socket_depth to bed_h — gap to any face >= 2mm (M-2)
    color("#888888", 1.0)
        translate([cx, cy, bed_h - socket_depth])
            cylinder(h = socket_depth, d = socket_od);
}

module pole_body(cx, cy) {
    // Structural tube — placeholder solid cylinder; hollow in v3+
    color("#CCCCCC", 1.0)
        translate([cx, cy, bed_h])
            cylinder(h = pole_h, d = pole_od);
}

module pole_mid_clamp(cx, cy) {
    // Adjustable collar clamp at clamp_mid_z — stub cylinder + lever accent
    color("#2C3E50", 1.0)
        translate([cx, cy, clamp_mid_z - clamp_h/2])
            cylinder(h = clamp_h, d = clamp_od);
    // Contact receipt: lever inner edge at cx + clamp_od/2 - 4, overlaps 4mm into body ✓
    color("#C0392B", 1.0)
        translate([cx + clamp_od/2 - 4, cy - 4, clamp_mid_z - 4])
            cube([lever_l + 4, 8, 8]);
}

// ─────────────────────────────────────────────────────────────────────
// POLE TOP COLLAR — detailed geometry (v2)
// Collar sits at pole top. Crossbar slides through horizontal bore along X.
// Cam lock protrudes from +X side. Knurled ring at collar base.
// ─────────────────────────────────────────────────────────────────────

module pole_top_collar(cx, cy) {
    collar_base_z = pole_top_z - collar_h;   // 2040mm — collar bottom Z

    // (1) Main body + (2) horizontal crossbar bore subtracted
    // Bore along X: length = collar_od + 2 for clean cut; centred at collar mid-height
    // Contact receipt: bore d=33mm, centre at collar_h/2=30mm local Z ✓
    color("#2C3E50", 1.0)
        translate([cx, cy, collar_base_z])
            difference() {
                cylinder(h = collar_h, d = collar_od);
                translate([-(collar_od/2 + 1), 0, collar_h/2])
                    rotate([0, 90, 0])
                        cylinder(h = collar_od + 2, d = bore_d);
            }

    // (3) Cam lock body — protrudes from collar +X side, 2mm overlap into body for union ✓
    // Contact receipt: cam base at cx + collar_od/2 - 2 = cx + 34.5mm (2mm inside collar radius)
    color("#2C3E50", 1.0)
        translate([cx + collar_od/2 - 2, cy, collar_base_z + collar_h * 0.6])
            rotate([0, 90, 0])
                cylinder(h = cam_h, d = cam_od);
    // Red accent button — 1mm overlap into cam tip for manifold-safe union ✓
    color("#C0392B", 1.0)
        translate([cx + collar_od/2 - 2 + cam_h - 1, cy, collar_base_z + collar_h * 0.6])
            rotate([0, 90, 0])
                cylinder(h = 6, d = cam_od - 4);

    // (4) Knurled ring — wider, shorter cylinder at collar base
    color("#AAAAAA", 1.0)
        translate([cx, cy, collar_base_z])
            cylinder(h = ring_h, d = ring_od);
    // Vertical ridges around ring circumference — thin fins, 24 evenly spaced
    for (a = [0 : 360/ridge_count : 359])
        color("#888888", 1.0)
            translate([cx, cy, collar_base_z]) rotate([0, 0, a])
                translate([ring_od/2 - 3, -1, 0])
                    cube([4, 2, ring_h]);
}

// ═════════════════════════════════════════════════════════════════════
// MODULES — CROSSBAR
// ═════════════════════════════════════════════════════════════════════

module crossbar_body(y_pos) {
    // Longitudinal grip bar — passes through all pole top collars at xbar_z
    color("#DDDDDD", 1.0)
        translate([0, y_pos, xbar_z])
            rotate([0, 90, 0])
                cylinder(h = grip_l, d = grip_od);
}

module crossbar_end_cap(x_pos, y_pos) {
    // Decorative + safety end cap — sphere, overlaps bar end for union volume
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
    // Contact receipt: hinge at Z=bed_h+cone_h+30 (inside bracket 580–640mm range) ✓
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
        crossbar_body(xbar_y_front);
        crossbar_body(xbar_y_rear);
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
