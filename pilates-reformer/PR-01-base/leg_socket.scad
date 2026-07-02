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
        translate([cx - leg_w / 2 - pad_overhang, cy - leg_t / 2 - pad_overhang, 0])
            cube([leg_w + 2 * pad_overhang, leg_t + 2 * pad_overhang, pad_t]);
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
    leg_socket(ghost_cx, ghost_cy);
    color("gray", 0.3)
        translate([ghost_cx, ghost_cy, leg_h])
            cylinder(h = 200, d = pole_d, $fn = 32);
}
