// PR-01-base-v9.scad
// Janis Product Design — Pilates Reformer with Full Tower
// Version: v9 — Split-Clamp Base Collar + Full-Height Uniform Body
// Date: 2026-06-30
// Focus: Frame structure + joints only. No slider, no spring, no strap.
// Rules: rules-pr.md, rules-dimensions.md, .claude/rules-codes.md
//
// CONTEXT: v6 (one-piece continuous pole + taper) rejected by Janis (owner).
// v7 split pole into 4 SEPARATE physical components for self-assembly —
// TOP (crossbar lock/latch junction), BODY (constant-diameter D-profile
// shaft, no taper), BASE COLLAR (split-clamp sleeve to wood leg), WOOD
// SOCKET (shallow registration insert in drilled hole).
// v8 fixed crossbar seating gap + pole overshoot (unchanged this version).
//
// Changes from v8 (Janis-confirmed new direction, explicit Q&A this session):
//   - pole_body() now runs the FULL exposed pole height as one uniform
//     constant-50mm D-profile — no separate base-zone offset (collar_h
//     height offset removed). Single uniform-profile extrusion.
//   - pole_base_collar() redesigned as an external split-clamp sleeve:
//     wraps BOTH the lower pole_body() and the top of the wood leg
//     (spans across the bed_h surface line), split into 2 halves joined
//     by 3 bolt bosses per split face (6 total) — like a pipe clamp.
//     Carries the holding force; the registration pin is alignment-only.
//   - pole_wood_socket() depth reduced to a shallow registration depth
//     (not a deep structural socket — the clamp now carries the load).
//
// ⚠ Stage 1 of 2 — architecture and resizing only. Detailed top latch,
// teeth-gear adjustment, and precision split-clamp/pin fit are Stage 2
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

// ── Pole BASE COLLAR — split-clamp sleeve (Stage 2 = precision fit) ────
// Wraps BOTH the lower pole_body() and the top of the wood leg, spanning
// across the bed_h surface line. Split into 2 halves (front/back, cut along
// the Y centerline), joined by 3 bolt bosses per split face (6 total).
// Clamp carries the holding force — the registration pin below is
// alignment-only, not load-bearing. All values TBD — see cc_chat_log.
collar_wrap_h       = 120;            // TBD — total wrap height, split evenly above/below bed_h
collar_wall_t       = 8;              // TBD — wrap wall thickness
collar_bolt_d       = 4;              // TBD — bolt clearance hole diameter
collar_bolt_boss_d  = 10;             // TBD — boss diameter around each bolt hole
collar_id           = pole_d + 1;     // inner clearance around pole_body (0.5mm/side)
collar_od           = collar_id + 2 * collar_wall_t;
collar_z0           = bed_h - collar_wrap_h / 2;  // split roughly evenly above/below bed_h line
pin_d               = 16;             // unchanged — registration pin diameter
pin_h               = 18;             // TBD — reduced for new shallow socket, must be <= socket_depth

// ── Pole WOOD SOCKET — shallow registration insert (rules-dimensions.md v6, PR-01) ──
// Registration/alignment only — NOT load-bearing (split-clamp collar carries the holding force).
socket_od     = 60;    // ~60mm fixed-version OD — Janis-confirmed, unchanged
socket_depth  = 20;     // TBD — shallow registration depth, see cc_chat_log
socket_bore_d = pin_d + 0.5;  // bore clearance for registration pin — M-PR-1, never exact pin_d

// ── Grip bar (crossbar) ───────────────────────────────────────────────
grip_od     = 32;     // OWNER-LOCKED — do not change without Janis approval
grip_l      = bed_l - leg_w;  // pole-center to pole-center (X-axis), not bed edge to edge
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

// Crossbar Z — seats mid-height inside the pole_top() boss (does NOT bore through pole_body())
xbar_z = bed_h + pole_h - top_boss_h * 0.5;

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
            cylinder(h = socket_depth, d = socket_od, $fn = 64);
}

// pole_base_collar_half() — one half of the split-clamp sleeve (front or back).
// side = +1 → back half (y >= cy seam), -1 → front half (y <= cy seam).
// Wraps both pole_body() and the wood leg top, spanning across bed_h. 3 bolt
// bosses on this half's split face — mating half carries the other 3 (6 total).
module pole_base_collar_half(cx, cy, side) {
    half_h = collar_wrap_h;
    color("#2C3E50", 1.0)
        translate([cx, cy, collar_z0])
            difference() {
                union() {
                    difference() {
                        cylinder(h = half_h, d = collar_od, $fn = 64);
                        translate([0, 0, -e])
                            cylinder(h = half_h + 2 * e, d = collar_id, $fn = 64);
                    }
                    // 3 bolt bosses along the split (seam) face, evenly spaced in height
                    for (bz = [half_h * 0.2, half_h * 0.5, half_h * 0.8])
                        translate([0, side * (collar_bolt_boss_d / 2 - e), bz])
                            rotate([90, 0, 0])
                                cylinder(h = collar_bolt_boss_d, d = collar_bolt_boss_d, $fn = 32, center = true);
                }
                // keep only this half — cut away material on the far side of the seam plane
                translate([-collar_od, side > 0 ? -collar_od : 0, -e])
                    cube([collar_od * 2, collar_od, half_h + 2 * e]);
                // bolt through-holes at the same 3 heights
                for (bz = [half_h * 0.2, half_h * 0.5, half_h * 0.8])
                    translate([0, 0, bz])
                        rotate([90, 0, 0])
                            cylinder(h = collar_bolt_boss_d * 2, d = collar_bolt_d, $fn = 32, center = true);
            }
}

// pole_base_collar() — split-clamp sleeve: 2 visually separate halves (not unioned,
// consistent with how the other pole components are kept logically separate) +
// a single registration pin protruding into the shallow pole_wood_socket().
module pole_base_collar(cx, cy) {
    pole_base_collar_half(cx, cy, 1);   // back half
    pole_base_collar_half(cx, cy, -1);  // front half
    color("#2C3E50", 1.0)
        translate([cx, cy, bed_h - pin_h])
            cylinder(h = pin_h + e, d = pin_d, $fn = 64);
}

// pole_body() — D-profile shaft, constant 50mm diameter, FULL exposed pole height
// (single uniform extrusion, no base-zone offset). No bar-insert bore — crossbar
// no longer passes through the body (that is pole_top()'s job).
// dir: front pole flat faces +X (rear); rear pole flat faces -X (front) — rules-pr.md
module pole_body(cx, cy) {
    dir = (cx < bed_l / 2) ? 1 : -1;
    cut_x0 = dir > 0 ? 0.7 * pole_r : -(pole_r + 1);
    color("#CCCCCC", 1.0)
        translate([cx, cy, bed_h])
            difference() {
                cylinder(h = pole_h - top_boss_h, r = pole_r, $fn = 64);
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
        translate([leg_w/2, y_pos, xbar_z])
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
        crossbar_end_cap(pole_cx[0], xbar_y_front);
        crossbar_end_cap(pole_cx[1], xbar_y_front);
        crossbar_end_cap(pole_cx[2], xbar_y_rear);
        crossbar_end_cap(pole_cx[3], xbar_y_rear);
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
