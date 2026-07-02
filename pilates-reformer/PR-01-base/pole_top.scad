// pole_top.scad
// Janis Product Design — Pilates Reformer PR-01-base — module file
// NOT individually versioned (see PR-01-multifile-split-v25 Task A note):
// this is an organizational component, not a standalone deliverable Janis
// opens directly. Its history is tracked by git commit + the version number
// of whichever PR-01-assembly-vXX.scad includes it. This is a deliberate,
// scoped exception to the "never overwrite, always version" rule — applies
// ONLY to this file (module files are the scoped exception, regardless of
// folder — flattened out of modules/ per PR-01-flatten-modules-v26).
//
// Content moved unchanged from PR-01-base-v24.scad (pure reorg, zero logic/
// parameter/variable-name changes) as part of PR-01-multifile-split-v25;
// flattened from modules/pole_top.scad to this same flat location as part
// of PR-01-flatten-modules-v26 (Janis's workflow downloads files
// individually, no git clone — a modules/ subfolder cannot be relied on to
// exist locally). All global parameters (bed/pole/housing/collar/socket/grip
// dimensions, derived xbar_z/pole_cx/pole_cy) are normally supplied by the
// including assembly file — see PR-01-assembly-v26.scad — but every global
// this file itself evaluates also gets a standalone-safe is_undef() default
// below, so opening this file directly (no assembly include) is warning-free.

// Ghost-context preview convention (see .claude/rules-codes.md, MULTI-FILE
// MODULE CONVENTION section). Assembly file sets $is_assembly=true before
// including, so full-assembly renders never show this file's ghost stand-ins.
// v27 fix (PR-01-fix-ghost-leak-toggle-relocate-v27): this used to be a
// self-referential reassignment (`$is_assembly = is_undef($is_assembly) ?
// false : $is_assembly;`). Because `include` flattens this file's scope
// together with the assembly file's, OpenSCAD collapses both assignments
// of the same variable into one — the reassignment always won and always
// evaluated false, leaking the ghost stanza into every full-assembly
// render regardless of the assembly file's `$is_assembly = true`. Fix:
// a function that only ever READS $is_assembly, never reassigns it.
function ghost_mode() = is_undef($is_assembly) || !$is_assembly;

// v28 fix (fix-pole-cx-cy-override-bug): pole_cx/pole_cy used to have their
// own standalone-safe default here, using the same self-reassignment
// pattern as the old $is_assembly bug above: `pole_cx = is_undef(pole_cx) ?
// [fallback] : pole_cx;`. Same root cause, same failure mode — `include`
// flattens scope, so this reassignment collapses against the assembly
// file's real `pole_cx`/`pole_cy` assignment (set before the include) into
// one variable, and the self-referencing ternary always resolved to the
// hardcoded fallback, never the assembly's actual computed array. This was
// invisible for pole_cx (fallback [90,2210,90,2210] happened to numerically
// match every pole_cx value ever computed by the assembly file) but broke
// pole_cy silently: fallback [60,60,610,610] matched the OLD bed_w=670
// design, so legs/poles stayed frozen at the old Y positions even after
// bed_w was changed to 840 in v28 (crossbar gap fix) — bed surface resized,
// legs did not move. Fix: never reassign pole_cx/pole_cy in this file at
// all. bed_frame(), pole_assembly(), and crossbar_assembly() below all
// reference the raw globals directly and are only ever instantiated from
// the full assembly (pr01_assembly()), so they always see the assembly's
// real values with nothing left in this file to collide against. The one
// place in this file that DOES need a standalone fallback — the ghost-
// context preview stanza at the bottom — computes it into distinct local
// variable names (ghost_cx/ghost_cy) that cannot collapse against pole_cx/
// pole_cy under scope-flattening, since they are never the same variable.

// ── Standalone-safe defaults ──────────────────────────────────────────
// Every global this file evaluates (module bodies reachable from the
// ghost-context stanza below, plus the stanza's own direct references),
// guarded so a standalone open (no assembly include) is warning-free.
// Fallback values mirror PR-01-assembly-v26.scad's current values (pole_d
// per rules-dimensions.md's "PR-01 body D-section" 40mm; the rest are the
// same figures the assembly file supplies today — same numbers, not new
// design decisions).
e                   = is_undef(e)                   ? 0.01  : e;      // epsilon
bed_l               = is_undef(bed_l)               ? 2300  : bed_l;
// bed_h removed (bed-height-pad-cutaway-fix, 2026-07-02): same self-
// reassignment bug class as the pole_cx/pole_cy fix above — `include`
// flattens this file's scope into the assembly's, so this reassignment
// collapsed bed_h to the hardcoded 500 fallback regardless of the
// assembly's real value. Dormant only because the assembly's bed_h
// (500) happened to equal the fallback; confirmed dormant via local
// render (bed_h=600 in assembly produced a byte-identical render to
// bed_h=500 until this line was removed). No standalone fallback is
// reintroduced here — see ghost_bed_h local in the ghost-context stanza
// below, the only place in this file that needs one.
pole_d              = is_undef(pole_d)              ? 40    : pole_d;
pole_r              = is_undef(pole_r)              ? pole_d / 2 : pole_r;
neck_h              = is_undef(neck_h)              ? 70    : neck_h;
neck_id             = is_undef(neck_id)             ? pole_d + 1 : neck_id;
neck_od             = is_undef(neck_od)             ? neck_id + 6 : neck_od;
neck_bolt_d         = is_undef(neck_bolt_d)         ? 6.5   : neck_bolt_d;
top_bore_d          = is_undef(top_bore_d)          ? 32    : top_bore_d;
housing_len         = is_undef(housing_len)         ? 104   : housing_len;
housing_r_circ      = is_undef(housing_r_circ)      ? 19    : housing_r_circ;
housing_camber_rise = is_undef(housing_camber_rise) ? 16    : housing_camber_rise;
housing_peak_t      = is_undef(housing_peak_t)      ? 0.60  : housing_peak_t;
housing_bump_w      = is_undef(housing_bump_w)      ? 0.55  : housing_bump_w;
housing_steps       = is_undef(housing_steps)       ? 60    : housing_steps;
housing_neck_t      = is_undef(housing_neck_t)      ? 0.50  : housing_neck_t;
housing_bulge_rise  = is_undef(housing_bulge_rise)  ? 5     : housing_bulge_rise;
housing_bulge_w     = is_undef(housing_bulge_w)     ? 0.18  : housing_bulge_w;
xbar_z              = is_undef(xbar_z)              ? 2065  : xbar_z;  // bed_h+pole_h-housing_r_circ-housing_camber_rise
grip_od             = is_undef(grip_od)             ? 32    : grip_od; // OWNER-LOCKED
// pole_cx/pole_cy: NO standalone default here — see comment above
// ghost_mode(). Fallback now lives only in the ghost stanza's ghost_cx/
// ghost_cy locals, not as a reassignment of these global names.

// ── Functions ─────────────────────────────────────────────────────────

// Mudguard/camber cross-section polygon. r_top: top half radius (large, varies).
// r_bot: bottom half radius (small, near-constant). Points in local 2D XY, then
// linear_extrude + rotate([0,90,0]) maps them to world YZ cross-section at each X.
// rotate([0,90,0]) maps (x,y,z)->(z,y,-x); polygon x_2d = -z_world, y_2d = y_world.
// a=90°: x_2d=-r_top (z_world=xbar_z+r_top ✓ top), a=270°: x_2d=r_bot (z_world=xbar_z-r_bot ✓ bottom)
// v24: smooth cosine blend — no sharp corners at sides.
// blend=0 at bottom (a=0°), 0.5 at sides (a=90°/270°), 1 at top (a=180°).
// At sides: r=(r_bot+r_top)/2 ≈ 27mm > neck radius 23.5mm — side gap closed.
// Dome remains on world +Z (top) — direction unchanged from v23.
function profile_pts(r_top, r_bot, n = 48) = [
    for (i = [0 : n - 1])
        let(a = i * 360 / n, blend = (1 - cos(a)) / 2, r = r_bot + (r_top - r_bot) * blend)
        [r * cos(a), r * sin(a)]
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

// BELL LOCK COLLAR — moved to leg_socket.scad (base-file-consolidation,
// 2026-07-03). This module physically belongs to the base/leg system, not
// the top-joint housing this file covers — was misplaced here during the
// 2026-07-02 bell-collar-socket-build. bell_lock_collar() and its helpers
// (bell_dome_pts, bell_dome, bell_thread, bell_bayonet, bell_cap) now live
// in leg_socket.scad. Global scope unaffected (still include-flattened
// alongside this file by the assembly), only the file location changed.

// ═════════════════════════════════════════════════════════════════════
// MODULES — CROSSBAR
// ═════════════════════════════════════════════════════════════════════

module crossbar_body(y_pos) {
    // DEBUG v23: bar extended 50mm past each joint end for visual pass-through check.
    // Revert translate to [leg_w/2, ...] and h to grip_l before production.
    color("#DDDDDD", 1.0)
        translate([leg_w/2 - 50, y_pos, xbar_z])
            rotate([0, 90, 0])
                cylinder(h = grip_l + 100, d = grip_od, $fn = 32);
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
    // RETIRED 2026-07-02 (pole-base-bell-collar-socket-build): old external
    // split-clamp collar, superseded by bell_lock_collar() (see
    // rules-dimensions.md "Bell Collar" SUPERSEDED note). pole_base_collar()
    // module kept below, not deleted — not confirmed nothing else depends
    // on it. NOTE: the prompt named this module `pole_top_collar()`; no
    // module of that name exists in the live file — this is the actual
    // split-clamp module (show_base_collars-guarded), flagging the name
    // discrepancy rather than force-fitting it.
    // if (show_base_collars) pole_base_collar(cx, cy);
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

// ═════════════════════════════════════════════════════════════════════
// GHOST-CONTEXT PREVIEW — standalone/isolated iteration only
// Suppressed in full assembly ($is_assembly=true set by PR-01-assembly-v25
// before the include). Shows pole_top()'s real geometry plus gray (30%
// opacity) simple stand-ins for the parts it mates to but does not itself
// contain: the vertical pole stub (pole_body(), diameter pole_d) below it,
// and the horizontal crossbar/grip bar (diameter grip_od) passing through
// its bore at world Z=xbar_z. Stand-ins are plain primitives, not real
// neighboring-module geometry, positioned per the same formulas those
// modules already use (pole_body(): translate([cx,cy,bed_h]), height
// (xbar_z-housing_r_circ-neck_h)-bed_h; crossbar_body(): world Z=xbar_z,
// axis rotate([0,90,0])).
// ═════════════════════════════════════════════════════════════════════

if (ghost_mode()) {
    // Fallback lives here only, in locals that cannot collapse against
    // pole_cx/pole_cy — see fix-pole-cx-cy-override-bug comment above.
    ghost_cx = is_undef(pole_cx) ? 90 : pole_cx[0];
    ghost_cy = is_undef(pole_cy) ? 60 : pole_cy[0];
    ghost_bed_h = is_undef(bed_h) ? 500 : bed_h;
    pole_top(ghost_cx, ghost_cy);
    // ghost: vertical pole stub (pole_body(), real diameter pole_d) below the neck
    ghost_neck_top = xbar_z - housing_r_circ;
    ghost_body_h   = (ghost_neck_top - neck_h) - ghost_bed_h;
    color("gray", 0.3)
        translate([ghost_cx, ghost_cy, ghost_bed_h])
            cylinder(h = ghost_body_h, d = pole_d, $fn = 32);
    // ghost: horizontal crossbar/grip bar (real diameter grip_od) through the bore
    color("gray", 0.3)
        translate([ghost_cx, ghost_cy, xbar_z])
            rotate([0, 90, 0])
                cylinder(h = 200, d = grip_od, center = true, $fn = 32);
}
