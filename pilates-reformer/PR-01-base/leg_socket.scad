// leg_socket.scad
// Janis Product Design — Pilates Reformer PR-01-base — module file
// NOT individually versioned (same flat-file exception as pole_top.scad —
// see PR-01-multifile-split-v25 Task A note, PR-01-flatten-modules-v26).
// History tracked by git commit + the version number of whichever
// PR-01-assembly-vXX.scad includes it.
//
// New 2026-07-02 (pole-base-bell-collar-socket-build): embedded leg +
// deep pass-through socket sleeve. First-time CONFIRMED via Customizer
// screenshot (pole_top_housing_customizer leg/bed panel) — replaces the
// old shallow bonded pocket concept. NOTE: pole_wood_socket() (in
// pole_top.scad, socket_depth=20mm placeholder) remains actively called
// alongside this new leg_socket() — this prompt only added the new
// component, it did not retire the old shallow-socket call site (only
// the split-clamp collar retirement was explicitly requested). Flagging
// this as a likely redundancy for Claude Web/Janis to resolve, not
// silently reconciling it here.
//
// NAMING: this file's socket parameters are named leg_socket_od /
// leg_socket_wall_t / leg_socket_depth — deliberately NOT socket_od /
// socket_depth, which already exist as PR-01-assembly globals (60mm/20mm,
// used by pole_wood_socket()). Reusing those names would silently
// override pole_wood_socket()'s values via OpenSCAD's "last declaration
// wins" duplicate-variable behavior (rules-codes.md) — the exact class of
// invisible bug already chased twice this project (v27 ghost-leak,
// fix-pole-cx-cy-override-bug). Renamed to avoid it outright.

function ghost_mode() = is_undef($is_assembly) || !$is_assembly;

// ── Standalone-safe defaults ──────────────────────────────────────────
// Same is_undef() self-guard convention as pole_top.scad's existing
// block — dormant-but-functional pattern (NOT the fully collision-proof
// local-fallback pattern used for pole_cx/pole_cy specifically, which was
// only necessary because that one had actually diverged — see
// fix-pole-cx-cy-override-bug cc_chat_log entry, 2026-07-02). This is a
// known, already-flagged, project-wide standing risk (correct today
// because fallback values are kept in sync with the assembly's real
// values), not a new defect introduced here.
leg_w              = is_undef(leg_w)              ? 180  : leg_w;   // shared global, also used by bed_frame()/pole_top.scad
leg_t              = is_undef(leg_t)              ? 120  : leg_t;   // shared global
pole_d             = is_undef(pole_d)             ? 40   : pole_d;  // shared global, LOCKED
e                  = is_undef(e)                  ? 0.01 : e;       // shared global, epsilon
leg_h              = is_undef(leg_h)              ? 600  : leg_h;
pad_t              = is_undef(pad_t)              ? 20   : pad_t;
pad_overhang       = is_undef(pad_overhang)       ? 50   : pad_overhang;
leg_socket_od      = is_undef(leg_socket_od)      ? 46   : leg_socket_od;
leg_socket_wall_t  = is_undef(leg_socket_wall_t)  ? 2.5  : leg_socket_wall_t;
leg_socket_depth   = is_undef(leg_socket_depth)   ? 400  : leg_socket_depth;

// Bell collar standalone defaults — added base-file-consolidation,
// 2026-07-03, alongside the module move. Previously these had NO
// standalone fallback anywhere, because bell_lock_collar() was never
// called from any file's own ghost stanza. Values match the CONFIRMED
// rules-dimensions.md table exactly (dome profile via Customizer
// 2026-07-02; thread/bayonet are ENGINEER-PROPOSED, not physically
// validated — same caveat applies here as in the real assembly).
r_base                      = is_undef(r_base)                      ? 51   : r_base;
r_top                       = is_undef(r_top)                       ? 25   : r_top;
foot_h                      = is_undef(foot_h)                      ? 8    : foot_h;
dome_h                      = is_undef(dome_h)                      ? 35   : dome_h;
dome_steps                  = is_undef(dome_steps)                  ? 16   : dome_steps;
curve_power                 = is_undef(curve_power)                 ? 2.2  : curve_power;
cap_h                       = is_undef(cap_h)                       ? 12   : cap_h;
cap_knurl_count              = is_undef(cap_knurl_count)              ? 45   : cap_knurl_count;
washer_h                    = is_undef(washer_h)                    ? 5    : washer_h;
washer_overhang             = is_undef(washer_overhang)             ? 4    : washer_overhang;
thread_pitch                = is_undef(thread_pitch)                ? 3    : thread_pitch;
thread_depth                = is_undef(thread_depth)                ? 1.5  : thread_depth;
thread_engagement_l         = is_undef(thread_engagement_l)         ? 8    : thread_engagement_l;
bayonet_lug_w                = is_undef(bayonet_lug_w)                ? 5    : bayonet_lug_w;
bayonet_engagement_depth    = is_undef(bayonet_engagement_depth)    ? 3    : bayonet_engagement_depth;
bayonet_lug_count            = is_undef(bayonet_lug_count)            ? 3    : bayonet_lug_count;

leg_socket_id = leg_socket_od - 2 * leg_socket_wall_t;  // 41mm
// Radial clearance vs pole_d(40mm) = (leg_socket_id - pole_d)/2 = 0.5mm —
// tight tolerance, not a blocker, but flagged for print/fit tolerance
// awareness (stated explicitly in cc_chat_log per prompt instruction).

// leg_socket(cx, cy) — wood leg + foot pad + embedded pass-through
// socket sleeve. Leg spans floor (Z=0) to leg_h (600mm) — INTERPRETATION
// FLAG: leg_h was not reconciled against bed_h(500mm)/the existing
// bed_frame() leg height (bed_h-surface_t=470mm) anywhere in the prompt;
// this file treats leg_h as this component's own independent full height,
// extending ~100mm above bed_h so the pole continues upward from a
// bell_lock_collar() flush with THIS leg's own top face (matching "pole
// pushes directly into embedded leg socket"). Deliberate, documented
// interpretation — not a confirmed architectural decision, flagged for
// Claude Web/Janis review on the next render pass.
// Socket bore: open at leg top (world Z=leg_h), extends DOWN
// leg_socket_depth(400mm) — leaves 200mm solid wood below the bore for
// structural support (leg_h - leg_socket_depth = 200mm).
module leg_socket(cx, cy) {
    color("#C8A96E", 1.0) {
        translate([cx - leg_w / 2, cy - leg_t / 2, 0])
            cube([leg_w, leg_t, leg_h]);
        // Foot pad removed — Janis-confirmed 2026-07-02, was never part of the
        // intended design, only surfaced on first visual render. pad_t/
        // pad_overhang variables kept (unused) for history; do not resurrect
        // this call without Janis re-confirming.
        // translate([cx - leg_w / 2 - pad_overhang, cy - leg_t / 2 - pad_overhang, 0])
        //     cube([leg_w + 2 * pad_overhang, leg_t + 2 * pad_overhang, pad_t]);
    }
    color("#888888", 1.0)
        translate([cx, cy, leg_h - leg_socket_depth])
            difference() {
                cylinder(h = leg_socket_depth, d = leg_socket_od, $fn = 64);
                translate([0, 0, -e])
                    cylinder(h = leg_socket_depth + 2 * e, d = leg_socket_id, $fn = 64);
            }
}

// ═════════════════════════════════════════════════════════════════════
// BELL LOCK COLLAR — pole-base bell/mushroom collar + quick-release cap
// Moved here from pole_top.scad (base-file-consolidation, 2026-07-03) —
// this module belongs to the base/leg system per the original
// PR-01-multifile-split-v25 plan (one base file: bell cover + socket +
// pole holder, independently reviewable with ghost leg + ghost pole).
// It was misplaced in pole_top.scad during the 2026-07-02
// bell-collar-socket-build and had no standalone preview anywhere as a
// result — this fixes both the location and that gap. Pole pushes
// directly into leg_socket()'s embedded sleeve above; this collar is the
// visible dome+cap that sits flush at the wood surface where pole meets
// leg. Dome profile REVISED CONFIRMED via Customizer screenshot
// 2026-07-02 (r_top=25/curve_power=2.2). All r_base/r_top/foot_h/dome_h/
// dome_steps/curve_power/cap_h/cap_knurl_count/washer_h/washer_overhang/
// leg_h globals are supplied by the assembly file and referenced
// directly (not reassigned here) — same no-reassignment discipline as
// the fix-pole-cx-cy-override-bug / bed_h fixes.
// ═════════════════════════════════════════════════════════════════════

// Dome profile: solid-of-revolution from r_base (foot) to r_top (neck).
// curve_power exponent: 1=straight cone, >1=convex bulge, <1=concave
// converge (matches rules-dimensions.md note).
function bell_dome_pts(r_b, r_t, h, steps, power) = concat(
    [[0, 0]],
    [for (i = [0 : steps])
        let(t = i / steps, y = t * h, r = r_t + (r_b - r_t) * pow(1 - t, power))
        [r, y]],
    [[0, h]]
);

module bell_dome(r_b, r_t, h, steps, power) {
    rotate_extrude($fn = 64)
        polygon(bell_dome_pts(r_b, r_t, h, steps, power));
}

// ENGINEER-PROPOSED lock mechanism (thread + bayonet), Claude Web,
// market-standard practice for hand-assembled quick-release fittings at
// this scale. Lock mechanism dimensions are engineering estimates based
// on standard quick-release fitting practice — NOT physically validated,
// NOT production-ready. Requires prototype fit-test before tooling.
// Simplified representative geometry (visual single-start helix / lug
// bumps, not a literal mating female thread/slot cut into the cap) —
// avoids first-pass manifold risk on an unvalidated spec; revisit with
// real thread/bayonet geometry after physical fit-test.
module bell_thread(r_neck, pitch, depth, length) {
    turns = length / pitch;
    linear_extrude(height = length, twist = -360 * turns, slices = 64, convexity = 10)
        translate([r_neck, 0])
            polygon([[0, -depth / 2], [depth, 0], [0, depth / 2]]);
}

module bell_bayonet(r_neck, lug_w, lug_depth, lug_count) {
    for (i = [0 : lug_count - 1])
        rotate([0, 0, i * 360 / lug_count])
            translate([r_neck, -lug_w / 2, 0])
                cube([lug_depth, lug_w, lug_w]);
}

module bell_cap(r, h, knurl_count) {
    difference() {
        cylinder(h = h, r = r, $fn = 64);
        for (i = [0 : knurl_count - 1])
            rotate([0, 0, i * 360 / knurl_count])
                translate([r - 0.5, 0, -e])
                    cylinder(h = h + 2 * e, d = 1.2, $fn = 8);
    }
}

// bell_lock_collar(cx, cy) — foot ring + dome + washer reveal + thread/
// bayonet zone + knurled cap, unioned, single central bore subtracted
// once (Rule M-1 — never per-piece). Foot ring flush at wood surface
// (leg_socket.scad's leg top, world Z=leg_h). Bore = pole_d+1 (0.5mm/side
// slip-fit clearance, same convention as pole_top_neck()'s neck_id).
module bell_lock_collar(cx, cy) {
    lock_z0 = foot_h + dome_h + washer_h;  // thread/bayonet/cap start Z (local)
    color("#B08D57", 1.0)
        translate([cx, cy, leg_h])
            difference() {
                union() {
                    cylinder(h = foot_h, r = r_base, $fn = 64);
                    translate([0, 0, foot_h])
                        bell_dome(r_base, r_top, dome_h, dome_steps, curve_power);
                    translate([0, 0, foot_h + dome_h])
                        cylinder(h = washer_h, r = r_top + washer_overhang, $fn = 64);
                    translate([0, 0, lock_z0])
                        bell_thread(r_top, thread_pitch, thread_depth, thread_engagement_l);
                    translate([0, 0, lock_z0])
                        bell_bayonet(r_top, bayonet_lug_w, bayonet_engagement_depth, bayonet_lug_count);
                    translate([0, 0, lock_z0])
                        bell_cap(r_top, cap_h, cap_knurl_count);
                }
                translate([0, 0, -e])
                    cylinder(h = lock_z0 + cap_h + 2 * e, d = pole_d + 1, $fn = 48);
            }
}

// ═════════════════════════════════════════════════════════════════════
// GHOST-CONTEXT PREVIEW — standalone/isolated iteration only
// Suppressed in full assembly ($is_assembly=true set by the assembly
// file before the include). Shows leg_socket()'s real geometry plus a
// gray (30% opacity) simple stand-in for the mating pole stub it does
// not itself contain — positioned above the socket, diameter pole_d.
// ghost_cx/ghost_cy use distinct LOCAL names with their own is_undef()
// fallback — mirrors pole_top.scad's post-fix pattern exactly; pole_cx/
// pole_cy themselves are never reassigned here (same reasoning as the
// fix-pole-cx-cy-override-bug fix — reassigning a global the assembly
// also assigns collapses to the fallback under include scope-flattening).
// ═════════════════════════════════════════════════════════════════════

if (ghost_mode()) {
    ghost_cx = is_undef(pole_cx) ? 90 : pole_cx[0];
    ghost_cy = is_undef(pole_cy) ? 60 : pole_cy[0];
    // Cutaway — standalone-preview only (bed-height-pad-cutaway-fix,
    // 2026-07-02): reveals the embedded socket bore, otherwise fully
    // hidden inside the solid wood leg. Applies only inside ghost_mode();
    // full-assembly render calls leg_socket() directly (unchanged) via
    // PR-01-assembly-vXX.scad's per-pole loop, never this stanza.
    difference() {
        leg_socket(ghost_cx, ghost_cy);
        translate([ghost_cx - leg_w, ghost_cy, -e])
            cube([leg_w * 2, leg_t, leg_h + 2 * e]);
    }
    // Real bell_lock_collar() geometry (base-file-consolidation,
    // 2026-07-03) — was previously invisible in any standalone preview
    // since the module lived in pole_top.scad with no ghost call of its
    // own. Solid, not cut — matches its appearance in full assembly.
    bell_lock_collar(ghost_cx, ghost_cy);
    color("gray", 0.3)
        translate([ghost_cx, ghost_cy, leg_h])
            cylinder(h = 200, d = pole_d, $fn = 32);
}
