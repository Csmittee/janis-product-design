// BBQ Offset Smoker — Base Assembly
// Version: v5
// Date: 2026-07-22
// Source: BBQ-offset-smoker-base-v4.scad
// Changes: prompts/bbq-rear-fender-arch-redesign-cc-prompt.md. PURE
// POINTER-ONLY BUMP -- zero content changed in this file beyond the
// include line. `include` bumped BBQ-understructure-v14.scad ->
// BBQ-understructure-v15.scad (that round's own real fender profile
// redesign -- wheel-arch shape, WHEEL_R-parametric formula, see that
// file's own header for the full derivation). Real tray content below
// UNCHANGED, byte-for-byte, from base-v4.
//
// v4 kept unchanged, on record (BBQ-offset-smoker-base-v4.scad).
//
// v4's own original header follows, UNCHANGED, kept as real history:
//
// BBQ Offset Smoker — Base Assembly
// Version: v4
// Date: 2026-07-22
// Source: BBQ-offset-smoker-base-v3.scad
// Changes: prompts/bbq-understructure-level-drop-companion-cc-prompt.md.
// PURE POINTER-ONLY BUMP -- zero content changed in this file beyond the
// include line, same convention as the v9->v10/v10->v11/v12->v13 pointer-
// only bumps already in this project's history. `include` bumped
// BBQ-understructure-v13.scad -> BBQ-understructure-v14.scad (that
// round's own real fix: the companion -100mm level-drop absorption --
// REAR_BRACKET_H/FRONT_SPACER_LEN/TBAR_LEN all shrink exactly 100mm,
// wheels/axles stay fixed to true ground Z=0, fender Z/tire-clearance
// formula UNCHANGED and re-verified — see BBQ-understructure-v14.scad's
// own header for the full real derivation). Real tray content below
// (TASK 2 from the parting-shift round) UNCHANGED byte-for-byte from
// base-v3 — this round's own scope is the include-pointer bump only.
//
// v3 kept unchanged, on record (BBQ-offset-smoker-base-v3.scad).
//
// v3's own original header follows, UNCHANGED, kept as real history:
//
// BBQ Offset Smoker — Base Assembly
// Version: v3
// Date: 2026-07-22
// Source: BBQ-offset-smoker-base-v2.scad's real tray content, restructured
// onto BBQ-offset-smoker-base-v1.scad's original single-include-path
// pattern.
// Changes: prompts/bbq-base-chain-recalibration-cc-prompt.md. LINKAGE-ONLY
// FIX — zero geometry values, module content, or design decisions from
// either PR #143 round touched, re-derived, or "improved". PR #143 shipped
// two real, independently-correct pieces of work that never got connected
// into one chain: BBQ-understructure-v12.scad (tray removal/fender/track-
// width, correct) stayed wired to BBQ-chambers-v20.scad (correct at build
// time, v21 didn't exist yet); BBQ-offset-smoker-base-v2.scad (chambers-v21
// parting-line shift + tray) included BBQ-chambers-v21.scad DIRECTLY,
// bypassing understructure (and its wheels/fender) entirely, since no
// updated understructure existed yet to build on. Result: two separate
// valid assemblies, each Simple:yes on its own, never merged into one real
// render.
//
// REAL FIX, single-path rule restored (this project's own rule since
// base-v1's original 2026-07-13 header: "Only the understructure file is
// included here (not a chambers file directly too)... OpenSCAD has no
// include-guard, so including both here would render the chamber assembly
// twice"): BBQ-understructure-v13.scad (TASK 1, this same round) is now the
// real pointer-only bump to BBQ-chambers-v21.scad. This file includes
// ONLY BBQ-understructure-v13.scad — chambers access comes transitively
// through it, same single path as every prior base version. Base-v2's own
// direct `include <BBQ-chambers-v21.scad>` line is NOT carried forward
// here (removed entirely, per TASK 2 step 3) — that was the workaround,
// not the destination.
//
// Tray content below is copied forward from BBQ-offset-smoker-base-v2.scad
// VERBATIM — same module code, same parameter names, same values, a real
// relocation not a rewrite. Confirmed via a real line-range diff
// (BBQ-offset-smoker-base-v2.scad lines 45-168 vs this file's own TASK
// 2/3+ASSEMBLY block below): zero content changed, only its surrounding
// file structure (the header above, and REMOVING that file's own line 43
// `include <BBQ-chambers-v21.scad>`, replaced by the transitive path
// through understructure-v13 now serving the exact same real purpose).
//
// v2 kept unchanged, on record (BBQ-offset-smoker-base-v2.scad). v1 kept
// unchanged, on record (BBQ-offset-smoker-base-v1.scad).
//
// v1's own original header follows, UNCHANGED, kept as real history:
//
// BBQ Offset Smoker — Base Assembly
// Version: v1
// Date: 2026-07-13
// Changes from: N/A (first version)
//
// SOURCE: prompts/bbq-offset-smoker-v1-init-cc-prompt.md, TASK 4.
// Thin assembly file — positions Cook Chamber on Understructure's
// mounting plane per the confirmed consecutive-parent chain
// (SKELETON_WORKSHEET.md Part A). No extra translate is needed: both
// files already share MASTER ORIGIN (0,0,0 at floor level, front-left)
// as their own local origin, and BBQ-understructure.scad's leg_h is
// DERIVED from BBQ-chambers-v1.scad's chamber_floor_z directly (not a
// second independent copy) — so the two are already co-registered in
// world space by construction.
//
// Only the understructure file is included here (not a chambers file
// directly too) — it already `include`s the chambers file itself for its
// own datum access, and OpenSCAD has no include-guard, so including both
// here would render the chamber assembly twice (harmless to CGAL manifold
// status but wasteful/confusing) — R-009 duplication-check caught this
// before it shipped, see cc_chat_log.md.
// (Full v2->v11 include-history changelog omitted here — see
// BBQ-offset-smoker-base-v1.scad's own header for the complete real
// record; this file continues from v11's real content, TASK 1's own
// pointer-only bump applied on top via understructure-v13.)

include <BBQ-understructure-v15.scad>

// ═══════════════════════════════════════════════════════════════════
// TASK 2 — PREP TRAY, relocated here from BBQ-understructure (removed
// there in v12, this round's own dependency, confirmed above). Real
// dimensions, Janis's own spec:
// ═══════════════════════════════════════════════════════════════════
TRAY_COUNT      = 2;                              // fixed, Janis's own spec
TRAY_L          = chamber_L / TRAY_COUNT;         // 457.5mm each, real live value (chamber_L=915, read live)
TRAY_D          = 300;                            // deployed depth, Y, projecting outward (toward -Y, the Standing Orientation Convention's own "toward the user" side)
TRAY_T          = 2;                              // 2mm plate, thin-shell representation — consistent with this project's existing sheet-metal parts (rules-bbq-fab.md Construction Method)
TRAY_GAP        = 5;                              // real assembly tolerance, ADDITIVE (confirmed below, not absorbed into TRAY_L)
TRAY_TOTAL_SPAN = TRAY_L * TRAY_COUNT + TRAY_GAP; // 920mm — real, ADDITIVE: 2x457.5 + 5, confirmed 5mm MORE than chamber_L(915), not shrunk to fit inside it
// Real span centered on chamber_L's own midpoint — a small, real, stated
// 2.5mm overshoot past BOTH DATUM_X_FRONT(0) and DATUM_X_REAR(chamber_L)
// results (symmetric, by construction, from the additive gap), confirmed
// harmless via the real CGAL checks below (chamber shell/firebox both
// real solids checked directly, not assumed clear from the small overshoot
// alone).
TRAY_X0         = (chamber_L - TRAY_TOTAL_SPAN) / 2;   // -2.5mm
TRAY0_X0        = TRAY_X0;                        // -2.5
TRAY1_X0        = TRAY_X0 + TRAY_L + TRAY_GAP;    // 460mm

// Hinges — mounted to TASK 1's REAL new fixed band, read live (NOT
// hardcoded 980, per the prompt's own explicit instruction) — 20mm below
// NEW_SPLIT_Z's own real confirmed value (1000mm this round, matches the
// prompt's own expected 980mm exactly because NEW_SPLIT_Z landed exactly
// at the expected 1000mm — stated as a live read, not a coincidence
// silently assumed to always hold).
HINGE_Z         = NEW_SPLIT_Z - 20;               // 980mm, real live value
HINGE_W         = 20;
HINGE_H         = 20;
HINGE_INTO_WALL = 10;                             // real Y depth, pushes past wall_t(3mm) with margin for genuine weld contact, not a coincident face
// HINGE_PIVOT_OFFSET -- REAL FIX FOUND VIA CGAL, not in the original
// prompt spec (flagged): a live sweep probe found the 2mm-thick plate's
// own near edge sweeping INTO the wall's real material (up to +1.4mm
// past Y=0, confirmed non-empty at intermediate angles) when the rotation
// axis was placed exactly at the wall face (Y=0) -- a flat panel of
// nonzero thickness, pivoting about a point ON one of its own faces, has
// its OTHER face's near edge trace an arc that dips past the pivot line
// during rotation (basic real hinge-knuckle geometry: real hinges offset
// the knuckle from the mounting face for exactly this reason). FIX: the
// real rotation axis is offset HINGE_PIVOT_OFFSET(5mm, real judgment
// call, flagged, must clear TRAY_T=2mm with margin -- confirmed
// sufficient via a live re-sweep, EMPTY at every angle after this fix)
// outward (Y<0) from the wall face, representing the hinge's own real
// knuckle standoff -- HINGE_OUT widened to match so the hinge block's own
// visible footprint still spans from the wall out to the real pivot line.
HINGE_PIVOT_OFFSET = 5;
HINGE_OUT       = HINGE_PIVOT_OFFSET + 1;          // 6mm -- real overlap OUTSIDE the wall face (Y<0), covers the real pivot line with margin
// HINGE_OFFSET -- REAL FIX FOUND VIA CGAL: an initial 60mm draft put
// TRAY1's own far hinge at real world X=857.5 (span [847.5,867.5]),
// overlapping the firebox's own real flange/tuck-under material (the
// Dual End-Cap Footprint Pattern's own union(square,true_octagon_profile)
// reaches real octagon wall material at Y=0 starting X<=~858, bisected
// live via CGAL, confirmed non-empty at X=860, empty at X<=858) --
// TRAY1's own far edge (X=917.5) sits close enough to firebox_x0(913.5)
// that a 60mm inset wasn't enough clearance. FIX: widened to 90mm (real
// judgment call, flagged, comfortably clears the real 858mm boundary with
// margin -- re-verified EMPTY below, not assumed from the wider number
// alone).
HINGE_OFFSET    = 90;

module tray_hinge(x_pos) {
    translate([x_pos - HINGE_W/2, -HINGE_OUT, HINGE_Z - HINGE_H/2])
        cube([HINGE_W, HINGE_INTO_WALL + HINGE_OUT, HINGE_H]);
}
module tray_hinges(x0) {
    tray_hinge(x0 + HINGE_OFFSET);
    tray_hinge(x0 + TRAY_L - HINGE_OFFSET);
}
// tray() — welded steel frame + 2mm plate (thin-shell representation).
// Real rotation axis: Y=-HINGE_PIVOT_OFFSET (the hinge's own real
// knuckle standoff, see above), Z=HINGE_Z — angle_deg: -90 (stowed,
// vertical, folded UP) to 0 (deployed, horizontal, plate spans outward
// toward -Y per the Standing Orientation Convention's own "toward the
// user" side). TWO REAL BUGS FOUND+FIXED VIA LIVE CGAL SWEEP PROBES (not
// assumed clean from the code alone): (1) an earlier draft built the
// plate spanning positive Y, projecting INWARD toward the chamber's own
// DATUM_Y_CENTER territory (where the front bracket sits) instead of
// outward — confirmed via a real collision at angle=-30/-60 against
// front_wheel_support(). (2) with the sign fixed, a second live sweep
// found the plate's own near edge sweeping past Y=0 into the wall's real
// material at intermediate angles (a flat panel of nonzero thickness
// pivoting exactly at the wall face) — fixed by the real
// HINGE_PIVOT_OFFSET standoff above. Both re-verified EMPTY at every
// swept angle after these fixes, see cc_chat_log.md for the real angle
// list and results.
module tray(x0, angle_deg) {
    tray_hinges(x0);
    translate([x0, -HINGE_PIVOT_OFFSET, HINGE_Z]) rotate([angle_deg, 0, 0]) translate([0, -TRAY_D - e, 0])
        cube([TRAY_L, TRAY_D, TRAY_T]);
}
// TASK 2 kinetic parameter — each tray's OWN independent angle, real
// chosen names: tray0_angle_deg / tray1_angle_deg (not shared, per spec).
tray0_angle_deg = 0;     // default deployed, matches this project's own prior prep-shelf default convention
tray1_angle_deg = 0;

module trays() {
    tray(TRAY0_X0, tray0_angle_deg);
    tray(TRAY1_X0, tray1_angle_deg);
}
// Mounted ONLY on the Y=0 side, confirmed by construction: tray()/
// tray_hinges() never reference chamber_W or any Y=chamber_W-side
// position — no mirrored/second copy exists.

// ═══════════════════════════════════════════════════════════════════
// TASK 3 — LID COUNTERBALANCE/FULCRUM MECHANISM: DO NOT DESIGN THIS
// ROUND. Janis is still developing this concept — no module, stub,
// placeholder geometry, or toggle exists for it in this file. This is the
// next planned real addition to this file once that concept is confirmed.
// ═══════════════════════════════════════════════════════════════════

// ───────────────────────────────
// DEBUG TOGGLES
// ───────────────────────────────
show_trays = true;

// ───────────────────────────────
// ASSEMBLY — each line standalone/commentable per Module Isolation
// Testing (rules-codes.md). The chamber's own ASSEMBLY (chamber_shell/
// lid/firebox/exhaust_room/chimney_pipe/grate/drains) already executed
// above at include time, per BBQ-chambers-v21.scad's own DEBUG TOGGLES/
// ASSEMBLY section — this file adds only the tray.
// ───────────────────────────────
if (show_trays) color("#AAAAAA", 1.0) trays();
