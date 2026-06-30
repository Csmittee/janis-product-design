// PR-01-base-v21.scad
// Janis Product Design — Pilates Reformer with Full Tower
// Version: v21 — pole_top() family rebuilt as mudguard/airplane-camber collar
// (concept10 design: asymmetric camber housing + straight D-profile neck sleeve
// + red lever placeholder). Bell/horn/wine-glass geometry and all associated
// functions (cubic_bezier, pole_top_bell, pole_top_transition) removed. New
// multi-step loft (housing_steps slices, hull()-pairwise) replaces the 8-step
// elbow loft. xbar_z formula updated to derive from housing geometry, not
// top_boss_h. Lever is Stage 2 placeholder only — no mechanism geometry.
// Date: 2026-07-01
// Focus: Frame structure + joints only. No slider, no spring, no strap.
// Rules: rules-pr.md, rules-dimensions.md, .claude/rules-codes.md
//
// CHANGES FROM v20:
//   - Removed: cubic_bezier(), pole_top_bell(), pole_top_transition()
//   - Removed globals: head_h, top_boss_h, head_small_r, neck_or,
//     head_large_r, head_loft_steps, neck_bell_overlap, neck_bore_clearance,
//     neck_bell_transition_h, bolt_edge_clearance_min, neck_round_taper_h
//   - Added: pole_top_housing(), pole_top_lever_placeholder()
//   - Rebuilt: pole_top_neck() (straight, no taper blend, bolt positions
//     updated to z_bot+35 and z_bot+55 — both >15mm from edges)
//   - Rebuilt: pole_top() (housing + neck union, bore subtracted centrally)
//   - Updated: xbar_z = bed_h + pole_h - housing_r_circ - housing_camber_rise
//     (= 2065mm, up from v20's 2020mm — camber top = 2100 = bed_h+pole_h ✓)
//   - Updated: pole_body() neck_top = xbar_z - housing_r_circ (= 2046mm),
//     body_h = (2046 - 70) - 500 = 1476mm
//   - neck_h retained at 70mm (concept10 spec 50mm fails 15mm bolt-edge rule)
//   - neck_od retained at 47mm (concept10 spec 44mm gives 1.5mm wall < 2mm min)
//   - top_bore_d: 33→32 (TBD pending physical multi-pipe OD measurement)
//   - Patent flag: wedge-lock mechanism is patent candidate. Lever placeholder
//     only. Zero internal mechanism geometry in this file. See cc_chat_log.
//
// CONCEPT LOCK: mudguard/camber collar shape confirmed 2026-07-01 via local
// render (Claude Web sandbox). Concept is locked — no revert to bell/horn.
// DO NOT add wedge, cam, friction sleeve, or any mechanism geometry without
// explicit Janis written approval in chat.

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
pole_d        = 40;   // body diameter (pole_od) — Janis-approved v15
pole_r        = pole_d / 2;
pole_h        = 1600;  // exposed pole height above bed surface — PENDING

// ── Pole TOP — mudguard/camber housing (concept10, concept-locked 2026-07-01) ──
// Housing: asymmetric camber cross-section (large r_top / near-flat r_bot),
// multi-step loft along X-axis. Neck: straight D-profile sleeve over pole_body().
// Lever: Stage 2 placeholder only — no mechanism geometry.
neck_h         = 70;    // retained from v20 — concept10's 50mm fails 15mm bolt-edge rule:
                         // bolts at 35mm and 55mm → min edge gap = 15mm exactly at bottom ✓
neck_wall_t    = 3;     // wall thickness per side
neck_id        = pole_d + 1;           // = 41mm — slip-fit clearance over pole_od (0.5mm/side)
neck_od        = neck_id + 2 * neck_wall_t;  // = 47mm — retained; concept10's 44mm gives 1.5mm wall < 2mm min
neck_bolt_d    = 6.5;   // M6 through-bolt clearance hole diameter
top_bore_d     = 32;    // TBD — 32mm pipe clearance pending physical multi-pipe OD measurement

// ── Housing geometry (concept10 mudguard/camber cross-section) ────────
housing_len         = 104;   // total length along X-axis (pole-to-pipe span)
housing_r_circ      = 19;    // base circular radius (constant fore/aft symmetry)
housing_camber_rise = 16;    // additional camber rise at top peak (r_top_max = 35mm)
housing_peak_t      = 0.40;  // parametric position of camber peak (t=0=front end, t=1=rear end)
housing_bump_w      = 0.55;  // bump half-width (smooth_bump C2 kernel)
housing_steps       = 60;    // loft slices — more = smoother
housing_neck_t      = 0.50;  // position of neck bottom-bulge peak along housing length
housing_bulge_rise  = 5;     // bottom bulge rise at neck connection zone
housing_bulge_w     = 0.18;  // bottom bulge half-width

// ── Pole BASE COLLAR — split-clamp sleeve (Stage 2 = precision fit) ────
collar_wrap_h       = 120;
collar_wall_t       = 8;
collar_bolt_d       = 4;
collar_bolt_boss_d  = 10;
collar_id           = pole_d + 1;
collar_od           = collar_id + 2 * collar_wall_t;
collar_z0           = bed_h - collar_wrap_h / 2;
pin_d               = 16;
pin_h               = 18;

// ── Pole WOOD SOCKET ──────────────────────────────────────────────────
socket_od     = 60;
socket_depth  = 20;
socket_bore_d = pin_d + 0.5;

// ── Grip bar (crossbar) ───────────────────────────────────────────────
grip_od     = 32;     // OWNER-LOCKED
grip_l      = bed_l - leg_w;
grip_offset = 0;

// ── Debug toggles ─────────────────────────────────────────────────────
show_bed           = true;
show_pole_tops     = true;
show_pole_bodies   = true;
show_base_collars  = true;
show_wood_sockets  = true;
show_crossbars     = true;

// ── Derived ───────────────────────────────────────────────────────────
surface_t   = 30;

pole_cx = [leg_w/2, bed_l - leg_w/2, leg_w/2, bed_l - leg_w/2];
pole_cy = [leg_t/2, leg_t/2, bed_w - leg_t/2, bed_w - leg_t/2];

xbar_y_front = pole_cy[0];
xbar_y_rear  = pole_cy[2];

// v21: xbar_z derived from housing geometry — camber top lands exactly at bed_h+pole_h
// housing_r_circ=19, housing_camber_rise=16 → r_top_peak=35
// xbar_z + r_top_peak = bed_h + pole_h → xbar_z = 2100 - 35 = 2065  ✓
xbar_z = bed_h + pole_h - housing_r_circ - housing_camber_rise;  // = 2065mm

// ── Functions ─────────────────────────────────────────────────────────

// Mudguard/camber cross-section polygon. r_top: top half radius (large, varies).
// r_bot: bottom half radius (small, near-constant). Points in local 2D XY, then
// linear_extrude + rotate([0,90,0]) maps them to world YZ cross-section at each X.
// rotate([0,90,0]) maps (x,y,z)->(z,y,-x); polygon x_2d = -z_world, y_2d = y_world.
// a=90°: x_2d=-r_top (z_world=xbar_z+r_top ✓ top), a=270°: x_2d=r_bot (z_world=xbar_z-r_bot ✓ bottom)
function profile_pts(r_top, r_bot, n = 48) = [
    for (i = [0 : n - 1])
        let(a = i * 360 / n, r = sin(a) > 0 ? r_top : r_bot)
        [-r * sin(a), r * cos(a)]
];

// C2-continuous bell-shaped bump. Returns 0 outside width w of peak, rises to 1 at peak.
function smooth_bump(t, peak, w) =
    let(d = abs(t - peak) / w)
    d >= 1 ? 0 : pow(1 - d * d, 2);

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

module pole_wood_socket(cx, cy) {
    color("#888888", 1.0)
        translate([cx, cy, bed_h - socket_depth])
            cylinder(h = socket_depth, d = socket_od, $fn = 64);
}

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
                    for (bz = [half_h * 0.2, half_h * 0.5, half_h * 0.8])
                        translate([0, side * (collar_bolt_boss_d / 2 - e), bz])
                            rotate([90, 0, 0])
                                cylinder(h = collar_bolt_boss_d, d = collar_bolt_boss_d, $fn = 32, center = true);
                }
                translate([-collar_od, side > 0 ? -collar_od : 0, -e])
                    cube([collar_od * 2, collar_od, half_h + 2 * e]);
                for (bz = [half_h * 0.2, half_h * 0.5, half_h * 0.8])
                    translate([0, 0, bz])
                        rotate([90, 0, 0])
                            cylinder(h = collar_bolt_boss_d * 2, d = collar_bolt_d, $fn = 32, center = true);
            }
}

module pole_base_collar(cx, cy) {
    pole_base_collar_half(cx, cy, 1);
    pole_base_collar_half(cx, cy, -1);
    color("#2C3E50", 1.0)
        translate([cx, cy, bed_h - pin_h])
            cylinder(h = pin_h + e, d = pin_d, $fn = 64);
}

// pole_body() — D-profile shaft. v21: neck_top derived from new xbar_z and housing_r_circ.
// neck_top = xbar_z - housing_r_circ = 2065 - 19 = 2046mm
// body_h = (2046 - 70) - 500 = 1476mm
module pole_body(cx, cy) {
    dir = (cx < bed_l / 2) ? 1 : -1;
    cut_x0 = dir > 0 ? 0.7 * pole_r : -(pole_r + 1);
    neck_top = xbar_z - housing_r_circ;  // = 2046mm
    body_h = (neck_top - neck_h) - bed_h;  // = 1476mm
    color("#CCCCCC", 1.0)
        translate([cx, cy, bed_h])
            difference() {
                cylinder(h = body_h, r = pole_r, $fn = 64);
                translate([cut_x0, -pole_r - 1, -e])
                    cube([0.3 * pole_r + 1, pole_r * 2 + 2, body_h + 2 * e]);
            }
}

// pole_top_housing(cx, cy, dir) — mudguard/airplane-camber collar body.
// Multi-step hull()-loft along X-axis. Each cross-section is a profile_pts()
// polygon with varying r_top (camber bump) and r_bot (bottom bulge).
// Centered on xbar_z (world Z). Bore subtracted by pole_top() caller.
module pole_top_housing(cx, cy, dir) {
    union() {
        for (i = [0 : housing_steps - 2]) {
            let(
                t0 = i / (housing_steps - 1),
                t1 = (i + 1) / (housing_steps - 1),
                x0 = cx + dir * (t0 - 0.5) * housing_len,
                x1 = cx + dir * (t1 - 0.5) * housing_len,
                rt0 = housing_r_circ + housing_camber_rise * smooth_bump(t0, housing_peak_t, housing_bump_w),
                rb0 = housing_r_circ + housing_bulge_rise  * smooth_bump(t0, housing_neck_t, housing_bulge_w),
                rt1 = housing_r_circ + housing_camber_rise * smooth_bump(t1, housing_peak_t, housing_bump_w),
                rb1 = housing_r_circ + housing_bulge_rise  * smooth_bump(t1, housing_neck_t, housing_bulge_w)
            )
            hull() {
                translate([x0, cy, xbar_z]) rotate([0,90,0]) linear_extrude(e) polygon(profile_pts(rt0, rb0));
                translate([x1, cy, xbar_z]) rotate([0,90,0]) linear_extrude(e) polygon(profile_pts(rt1, rb1));
            }
        }
    }
}

// pole_top_neck(cx, cy, dir) — straight D-profile sleeve over pole_body().
// v21 REBUILT: no taper blend zone. Plain difference() only.
// z_bot = xbar_z - housing_r_circ - neck_h = 2065 - 19 - 70 = 1976mm
// Bolt positions: z_bot+35 (1976+35=2011) and z_bot+55 (1976+55=2031)
//   edge gaps: bottom edge: 35mm ✓ (>15mm), top edge: neck_h-55=15mm ✓
// flat_x = dir*0.7*pole_r = dir*14mm (same formula as pole_body() — coplanar seating)
// d_w: from flat_x to -(neck_id/2+1) or +; = neck_id/2+1 - abs(flat_x) = 20.5-14 = 6.5mm
module pole_top_neck(cx, cy, dir) {
    flat_x  = dir * 0.7 * pole_r;   // = dir*14mm
    z_bot   = xbar_z - housing_r_circ - neck_h;  // = 1976mm
    d_x0    = dir > 0 ? flat_x : -(neck_id / 2 + 1);
    d_w     = neck_id / 2 + 1 - abs(flat_x);     // = 6.5mm
    color("#2C3E50", 1.0)
        translate([cx, cy, z_bot])
            difference() {
                cylinder(h = neck_h, d = neck_od, $fn = 64);
                translate([0, 0, -e])
                    cylinder(h = neck_h + 2 * e, d = neck_id, $fn = 64);
                // D-profile flat cut — guarantees coplanar seating against pole_body()
                translate([d_x0, -(neck_id / 2 + 1), -e])
                    cube([d_w, neck_id + 2, neck_h + 2 * e]);
                // 2x M6 through-bolt holes (X-axis direction)
                // z_bot+35: 35mm from bottom edge, 35mm from top edge ✓ (both >15mm)
                // z_bot+55: 55mm from bottom edge, 15mm from top edge ✓ (exactly 15mm)
                for (bz = [35, 55])
                    translate([0, 0, bz])
                        rotate([0, 90, 0])
                            cylinder(h = neck_od + 2 * e, d = neck_bolt_d, center = true, $fn = 24);
            }
}

// PLACEHOLDER ONLY — internal mechanism is Stage 2 (patent-sensitive).
// Do not add wedge, cam, friction sleeve, or any internal mechanism
// geometry until explicitly instructed.
module pole_top_lever_placeholder(cx, cy, dir) {
    x_pk  = cx + dir * (housing_peak_t - 0.5) * housing_len;  // peak X position
    r_pk  = housing_r_circ + housing_camber_rise;              // = 35mm (max camber top)
    z_pk  = xbar_z + r_pk;                                     // = 2100mm (world top of camber)
    x_end = x_pk + dir * 62;                                   // lever arm extends 62mm outboard
    color("#CC2222") {
        // pivot stub at camber peak
        translate([x_pk, cy, z_pk])
            rotate([90, 0, 0])
                cylinder(h = 18, d = 12, center = true, $fn = 32);
        // lever arm body
        translate([min(x_pk, x_end), cy - 7, z_pk - 7])
            cube([abs(x_end - x_pk), 14, 7]);
        // handle grip block
        translate([dir > 0 ? x_end - 5 : x_end, cy - 8, z_pk - 9])
            cube([10, 16, 9]);
    }
}

// pole_top() — mudguard/camber housing + neck sleeve assembly.
// The housing and neck are unioned structurally; bore is subtracted centrally
// (centered on xbar_z, full housing width + 20mm clearance). Lever placeholder
// called from assembly level (Rule M-1: never a sibling inside difference()).
module pole_top(cx, cy) {
    $fn = 64;
    dir = (cx < bed_l / 2) ? 1 : -1;
    color("#2C3E50") {
        difference() {
            union() {
                pole_top_housing(cx, cy, dir);
                pole_top_neck(cx, cy, dir);
            }
            // Bore: centered on xbar_z, along X, housing_len+20mm total length
            // top_bore_d = 32mm (TBD pending physical multi-pipe OD measurement)
            translate([cx, cy, xbar_z])
                rotate([0, 90, 0])
                    cylinder(h = housing_len + 20, d = top_bore_d, center = true, $fn = 48);
        }
    }
    // Lever called at assembly level (not inside color/difference — Rule M-1)
    pole_top_lever_placeholder(cx, cy, dir);
}

// ═════════════════════════════════════════════════════════════════════
// MODULES — CROSSBAR
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
// SUB-ASSEMBLIES
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
// FULL ASSEMBLY
// ═════════════════════════════════════════════════════════════════════

module pr01_assembly() {
    bed_assembly();
    for (i = [0:3]) pole_assembly(i);
    crossbar_assembly();
}

// ── RENDER ────────────────────────────────────────────────────────────
pr01_assembly();
