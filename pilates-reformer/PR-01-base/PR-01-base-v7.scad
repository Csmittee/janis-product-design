// PR-01-base-v7.scad
// Janis Product Design — Pilates Reformer with Full Tower
// Version: v7 — Stage 1 of 2 (4-Part Split Architecture)
// Date: 2026-06-30
// Focus: Frame structure + joints only. No slider, no spring, no strap.
// Rules: rules-pr.md, rules-dimensions.md, .claude/rules-codes.md
//
// CONTEXT: v6 (one-piece continuous pole + taper) rejected by Janis (owner).
// New direction: pole splits into 4 SEPARATE physical components for
// self-assembly — TOP (crossbar lock/latch junction), BODY (constant-diameter
// D-profile shaft, no taper), BASE COLLAR (insert pin to wood socket),
// WOOD SOCKET (plain cylindrical insert in drilled hole).
//
// ⚠ Stage 1 of 2 — architecture and resizing only. Detailed top latch,
// teeth-gear adjustment, and detailed base collar/pin fit are Stage 2
// (separate future prompt). All such geometry here is placeholder only.
// ⚠ REGRESSION CHECK: no lattice/truss/wireframe geometry anywhere — body
// is a solid D-profile only (v4 removed it, v6 mistakenly reintroduced it).
// Foldable hinge geometry explicitly deferred — not built here.

// ── Global ────────────────────────────────────────────────────────────
e           = 0.01;   // epsilon — z-fight prevention
$fn         = 32;     // default resolution (use 64 for final render)

// ── Bed dimensions ────────────────────────────────────────────────────
bed_l       = 2300;   // total bed length (longitudinal) — PENDING Janis confirm
bed_w       = 670;    // total bed width — PENDING Janis confirm
bed_h       = 500;    // floor to top of bed surface — PENDING Janis confirm
leg_w       = 180;    // bed leg width — unchanged from v6
leg_t       = 120;    // bed leg depth — unchanged from v6
frame_rail_t = 60;    // bed rail thickness (wood) — PENDING
frame_rail_h = 120;   // bed rail height — PENDING

// ── Pole body — constant D-profile, NO TAPER (rules-dimensions.md v6, PR-01) ──
pole_d        = 50;   // body diameter — constant top to bottom — Janis-confirmed
pole_r        = pole_d / 2;
pole_h        = 1600;  // exposed pole height above bed surface — PENDING

// ── Pole TOP — placeholder smooth junction (Stage 2 builds functional latch) ──
top_boss_h    = 70;    // placeholder top boss height
top_boss_d    = pole_d + 20;  // slightly larger than body — visual junction collar

// ── Pole BASE COLLAR — placeholder boss + insert pin (Stage 2 = precision fit) ──
collar_h      = 50;            // placeholder base collar height
collar_d      = pole_d + 20;   // slightly larger than body — visual junction collar
pin_d         = 16;            // TBD — placeholder parametric value, see cc_chat_log
pin_h         = 35;            // TBD — placeholder parametric value, see cc_chat_log

// ── Pole WOOD SOCKET — plain cylindrical insert (rules-dimensions.md v6, PR-01) ──
socket_od     = 60;    // ~60mm fixed-version OD — Janis-confirmed
socket_depth  = 80;     // TBD — placeholder parametric depth, see cc_chat_log
socket_bore_d = pin_d + 0.5;  // bore clearance for base collar pin — M-PR-1, never exact pin_d

// ── Grip bar (crossbar) ───────────────────────────────────────────────
grip_od     = 32;     // OWNER-LOCKED — do not change without Janis approval
grip_l      = bed_l;  // crossbar length = bed length (X-axis) = 2300mm
grip_offset = 0;       // lateral offset from pole centerline — TBD

// ── Debug toggles ─────────────────────────────────────────────────────
show_bed           = true;
show_pole_tops     = true;
show_pole_bodies   = true;
show_base_collars  = true;
show_wood_sockets  = true;
show_crossbars     = true;

// ── Derived ───────────────────────────────────────────────────────────
surface_t   = 30;     // bed surface platform thickness

// Pole corner X positions — [front-left, front-right, rear-left, rear-right]
pole_cx = [leg_w/2, bed_l - leg_w/2, leg_w/2, bed_l - leg_w/2];
// Pole corner Y positions
pole_cy = [leg_t/2, leg_t/2, bed_w - leg_t/2, bed_w - leg_t/2];

// Crossbar Y positions — front row / rear row
xbar_y_front = pole_cy[0];
xbar_y_rear  = pole_cy[2];

// Crossbar Z — seats at pole_top() junction only (does NOT bore through pole_body())
xbar_z = bed_h + pole_h + top_boss_h * 0.5;

// ═════════════════════════════════════════════════════════════════════
// MODULES — BED
// ═════════════════════════════════════════════════════════════════════

module bed_frame() {
    color("#C8A96E", 1.0) {
        for (i = [0:3]) {
            translate([pole_cx[i] - leg_w/2, pole_cy[i] - leg_t/2, 0])
                cube([leg_w, leg_t, bed_h - surface_t]);
        }
        translate([0, 0, bed_h - surface_t - frame_rail_h])
            cube([bed_l, frame_rail_t, frame_rail_h]);
        translate([0, bed_w - frame_rail_t, bed_h - surface_t - frame_rail_h])
            cube([bed_l, frame_rail_t, frame_rail_h]);
        translate([0, 0, bed_h - surface_t - frame_rail_h])
            cube([frame_rail_t, bed_w, frame_rail_h]);
        translate([bed_l - frame_rail_t, 0, bed_h - surface_t - frame_rail_h])
            cube([frame_rail_t, bed_w, frame_rail_h]);
    }
}

module bed_surface() {
    color("#222222", 1.0)
        translate([0, 0, bed_h - surface_t])
            cube([bed_l, bed_w, surface_t]);
}

// ═════════════════════════════════════════════════════════════════════
// MODULES — POLE COMPONENTS (4 separate, logically distinct solids)
// ═════════════════════════════════════════════════════════════════════

// pole_wood_socket() — plain cylindrical insert pushed through drilled hole in wood leg.
// Sits inside the bed leg, below pole_base_collar(). Plain cylinder, no taper, no thread.
module pole_wood_socket(cx, cy) {
    color("#888888", 1.0)
        translate([cx, cy, bed_h - socket_depth])
            cylinder(h = socket_depth, d = socket_od);
}

// pole_base_collar() — placeholder boss connecting body to wood socket via insert pin.
// Pin protrudes from underside into pole_wood_socket() bore. Precision pin/socket fit
// is Stage 2 — this is a reasonable parametric placeholder only (flagged TBD).
module pole_base_collar(cx, cy) {
    color("#2C3E50", 1.0) {
        translate([cx, cy, bed_h])
            cylinder(h = collar_h, d = collar_d);
        // placeholder insert pin — protrudes downward into wood socket
        translate([cx, cy, bed_h - pin_h])
            cylinder(h = pin_h + e, d = pin_d);
    }
}

// pole_body() — D-profile shaft, constant 50mm diameter top to bottom. No taper logic.
// No bar-insert bore — crossbar no longer passes through the body (that is pole_top()'s job).
// dir: front pole flat faces +X (rear); rear pole flat faces -X (front) — rules-pr.md
module pole_body(cx, cy) {
    dir = (cx < bed_l / 2) ? 1 : -1;
    cut_x0 = dir > 0 ? 0.7 * pole_r : -(pole_r + 1);
    color("#CCCCCC", 1.0)
        translate([cx, cy, bed_h + collar_h])
            difference() {
                cylinder(h = pole_h - collar_h - top_boss_h, r = pole_r, $fn = 64);
                translate([cut_x0, -pole_r - 1, -e])
                    cube([0.3 * pole_r + 1, pole_r * 2 + 2, pole_h + 2 * e]);
            }
}

// pole_top() — placeholder smooth boss/junction where crossbar will eventually lock in.
// No functional latch geometry yet (Stage 2). Crossbar seats against this part only.
module pole_top(cx, cy) {
    color("#2C3E50", 1.0)
        translate([cx, cy, bed_h + pole_h - top_boss_h])
            cylinder(h = top_boss_h, d1 = pole_d, d2 = top_boss_d, $fn = 64);
}

// ═════════════════════════════════════════════════════════════════════
// MODULES — CROSSBAR (X-axis: longitudinal along bed length)
// Seats against pole_top() junctions only — does not pass through pole_body().
// ═════════════════════════════════════════════════════════════════════

module crossbar_body(y_pos) {
    color("#DDDDDD", 1.0)
        translate([0, y_pos, xbar_z])
            rotate([0, 90, 0])
                cylinder(h = grip_l, d = grip_od);
}

module crossbar_end_cap(x_pos, y_pos) {
    color("#AAAAAA", 1.0)
        translate([x_pos, y_pos, xbar_z])
            sphere(d = grip_od + 4);
}

// ═════════════════════════════════════════════════════════════════════
// SUB-ASSEMBLIES — 4 pole parts kept logically separate (not unioned)
// ═════════════════════════════════════════════════════════════════════

module bed_assembly() {
    if (show_bed) {
        bed_frame();
        bed_surface();
    }
}

module pole_assembly(i) {
    cx = pole_cx[i];
    cy = pole_cy[i];
    if (show_wood_sockets) pole_wood_socket(cx, cy);
    if (show_base_collars) pole_base_collar(cx, cy);
    if (show_pole_bodies)  pole_body(cx, cy);
    if (show_pole_tops)    pole_top(cx, cy);
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
// FULL ASSEMBLY (combined preview render — components visually aligned,
// logically separate solids, NOT unioned into one continuous pole)
// ═════════════════════════════════════════════════════════════════════

module pr01_assembly() {
    bed_assembly();
    for (i = [0:3]) pole_assembly(i);
    crossbar_assembly();
}

// ── RENDER ────────────────────────────────────────────────────────────
pr01_assembly();
