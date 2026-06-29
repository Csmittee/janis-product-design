// PR-01-base-v2.scad
// Janis Product Design — Pilates Reformer with Full Tower
// Version: v2
// Date: 2026-06-30
// Focus: Frame structure + joints only. No slider, no spring, no strap.
// Rules: rules-pr.md, rules-dimensions.md, .claude/rules-codes.md
// Changes from v2 (2026-06-29):
//   Fix 1: pole_top_collar() — crossbar bore reoriented to Y-axis (rotate [90,0,0], center=true)
//   Fix 2: leg_w 120→180, leg_t 80→120 (50% increase for structural proportion)
//   Fix 3: pole_body() — D-profile logarithmic taper lower 40%, circular upper 60%

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

// ── Pole D-profile shape (v2 fix) ─────────────────────────────────────
pole_base_d   = 46;          // effective diameter at base (fat end)
pole_top_d    = 36;          // diameter at taper end + upper section
r_base        = pole_base_d / 2;   // 23mm
r_top_taper   = pole_top_d  / 2;   // 18mm
taper_steps   = 12;          // hull() loft steps for logarithmic taper

// ── Grip bar (crossbar) ───────────────────────────────────────────────
grip_od     = 32;     // OWNER-LOCKED — do not change without Janis approval
grip_l      = bed_l;  // X-axis crossbar length (unused in current Y-axis design — keep for ref)
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
pole_cx = [leg_w/2, bed_l - leg_w/2, leg_w/2, bed_l - leg_w/2];
// Pole corner Y positions
pole_cy = [leg_t/2, leg_t/2, bed_w - leg_t/2, bed_w - leg_t/2];

// Crossbar X centrelines — left and right pole columns (Y-axis bars)
xbar_x_left  = leg_w/2;           // left column: x = 90mm
xbar_x_right = bed_l - leg_w/2;   // right column: x = 2210mm

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
    // Contact receipt: socket Z: bed_h-socket_depth to bed_h — gap to any face >= 2mm (M-2)
    color("#888888", 1.0)
        translate([cx, cy, bed_h - socket_depth])
            cylinder(h = socket_depth, d = socket_od);
}

// D-shaped cross-section slice: circle minus -X flat face (15% depth cut)
module d_slice(r, h) {
    intersection() {
        cylinder(h = h, r = r, $fn = 64);
        translate([-r * 0.85, -r, 0]) cube([r * 2, r * 2, h]);
    }
}

// Logarithmic taper D-profile loft from base (r_base) to top (r_top_taper)
module pole_lower_taper(taper_h, steps) {
    step_h = taper_h / steps;
    for (s = [0 : steps - 1]) {
        z0 = s * step_h;
        z1 = (s + 1) * step_h;
        r0 = r_top_taper + (r_base - r_top_taper) * (1 - ln(1 + z0/taper_h) / ln(2));
        r1 = r_top_taper + (r_base - r_top_taper) * (1 - ln(1 + z1/taper_h) / ln(2));
        hull() {
            translate([0, 0, z0]) d_slice(r0, e);
            translate([0, 0, z1]) d_slice(r1, e);
        }
    }
}

module pole_body(cx, cy) {
    // D-profile tapered lower 40% + circular upper 60%; color: brushed steel
    taper_h = pole_h * 0.4;   // 640mm
    color("#CCCCCC", 1.0) {
        translate([cx, cy, bed_h])
            pole_lower_taper(taper_h, taper_steps);
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
// Crossbar bore now Y-axis (front-to-back). Cam lock on +X side.
// ─────────────────────────────────────────────────────────────────────

module pole_top_collar(cx, cy) {
    collar_base_z = pole_top_z - collar_h;
    color("#2C3E50", 1.0)
        translate([cx, cy, collar_base_z])
            difference() {
                cylinder(h = collar_h, d = collar_od);
                // Y-axis bore: center=true cuts front-to-back through collar
                translate([0, 0, collar_h/2])
                    rotate([90, 0, 0])
                        cylinder(h = collar_od + 2, d = bore_d, center = true);
            }
    // Cam lock body — +X side, 2mm overlap into collar for manifold-safe union
    // Contact receipt: cam base at cx + collar_od/2 - 2 = cx + 34.5mm ✓
    color("#2C3E50", 1.0)
        translate([cx + collar_od/2 - 2, cy, collar_base_z + collar_h * 0.6])
            rotate([0, 90, 0])
                cylinder(h = cam_h, d = cam_od);
    // Red accent button — 1mm overlap into cam for manifold-safe union ✓
    color("#C0392B", 1.0)
        translate([cx + collar_od/2 - 2 + cam_h - 1, cy, collar_base_z + collar_h * 0.6])
            rotate([0, 90, 0])
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
// MODULES — CROSSBAR (Y-axis: front-to-back through collar)
// ═════════════════════════════════════════════════════════════════════

module crossbar_body(x_pos) {
    // Y-axis grip bar — passes through front and rear top collars at xbar_z
    // Contact receipt: at x_pos, runs y=0 to y=bed_w=670mm ✓
    color("#DDDDDD", 1.0)
        translate([x_pos, 0, xbar_z])
            rotate([-90, 0, 0])
                cylinder(h = bed_w, d = grip_od);
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
        // Two Y-axis bars — left column (x=xbar_x_left) and right column (x=xbar_x_right)
        crossbar_body(xbar_x_left);
        crossbar_body(xbar_x_right);
        // End caps — 2 bars × 2 ends = 4 caps (front y=0, rear y=bed_w)
        crossbar_end_cap(xbar_x_left,  0);
        crossbar_end_cap(xbar_x_left,  bed_w);
        crossbar_end_cap(xbar_x_right, 0);
        crossbar_end_cap(xbar_x_right, bed_w);
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
