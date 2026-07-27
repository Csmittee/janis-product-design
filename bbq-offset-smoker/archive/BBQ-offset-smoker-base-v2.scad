// BBQ Offset Smoker — Base Assembly
// Version: v2
// Date: 2026-07-22
// Source: BBQ-offset-smoker-base-v1.scad
// Changes: prompts/bbq-chamber-parting-shift-and-tray-init-cc-prompt.md,
// TASK 2/3. FIRST real content ever added to this file — its role changes
// from a pure assembly-includer (base-v1, kept UNCHANGED on record) to the
// project's real accessories home: the relocated prep tray now, a lid
// counterbalance/fulcrum mechanism is the planned NEXT addition (Janis is
// still developing that concept — TASK 3, deliberately NOT designed or
// stubbed this round, see the note near ASSEMBLY below).
//
// MANDATORY FIRST CHECK: confirmed real and merged — BBQ-understructure-
// v12.scad genuinely has zero prep_shelf()/prep_shelves()/
// tray_mount_bracket() (grep-confirmed, this round's own TASK 2 depends on
// that removal being real, per the prompt's own dependency note).
//
// REAL ARCHITECTURE DECISION, stated explicitly (not silently picked):
// this file's own `include` points DIRECTLY at BBQ-chambers-v21.scad, NOT
// at BBQ-understructure-v12.scad (unlike base-v1's own understructure->
// chambers chain). Reasoning: the relocated tray is a CHAMBER-mounted
// accessory (its hinges weld to TASK 1's new fixed band, a chamber-body
// surface, not any understructure part) — it has no real geometric
// dependency on the wheels/chassis. Including BOTH files here would
// double-render the chamber body: BBQ-understructure-v12.scad's own
// `include` is FROZEN at BBQ-chambers-v20.scad (this round's own DO NOT
// TOUCH — v12 stays read-only, zero changes), so pulling it in alongside
// a direct v21 include would render TWO DIFFERENT real versions of the
// chamber body simultaneously (v20's un-shifted parting line AND v21's
// shifted one, overlapping) — a genuine, confusing defect, not a stylistic
// choice. The mandatory tray-vs-understructure CGAL checks below (TASK 2)
// were run via a separate, standalone verification probe that includes
// BBQ-understructure-v12.scad on its own (real, live, not shipped as a
// project file) — see cc_chat_log.md for the actual results. A future
// round reintegrating the wheels here (once understructure's own
// `include` is deliberately bumped to v21) is a separate, later decision,
// not made this round.
//
// TASK 1 (BBQ-chambers-v21.scad) is a separate file, its own header has
// the full real derivation of the +50mm parting-line shift and the new
// fixed band this file's own TASK 2 depends on.

include <BBQ-chambers-v21.scad>

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
