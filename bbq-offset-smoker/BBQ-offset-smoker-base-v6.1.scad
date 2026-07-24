// BBQ Offset Smoker — Base Assembly
// Version: v6.1
// Date: 2026-07-24
// Source: BBQ-offset-smoker-base-v6.scad
// Changes: direct-cc tuning pass (R-011, Janis's own live review of a
// real v6 render — no new Claude Web prompt, per Section 5 of the
// source prompt's own anticipation of this exact round). X.Y bump (not
// v7) per Janis's own explicit instruction, since not everything raised
// is closed out yet (stopper/counterbalance visual review explicitly
// deferred by Janis until the door can be opened). 4 real items:
//
// 1. Kinetic parameters (`door_open_deg`, `tray0_angle_deg`,
//    `tray1_angle_deg`) RELOCATED to one consolidated, clearly-labeled
//    block just before ASSEMBLY, at the bottom of the file — matching
//    where every other file in this project (chambers/understructure)
//    already puts its own kinetic parameters, and where Janis was
//    actually looking. `door_open_deg` was previously declared right
//    after the `include` line (structurally correct — the `lid_open_deg`
//    reassignment only needs to be textually after the include, position
//    within that is otherwise free — but not where Janis expected to
//    find/drive it). Real, flagged, NOT independently confirmed: cc
//    cannot rule out an actual OpenSCAD Customizer-panel quirk (this
//    execution environment has no OpenSCAD binary — every check this
//    session is analytic/Python, not a live render) contributing to the
//    tray angle controls being hard to find; this relocation plus a
//    `/* [Kinetic Parameters] */` Customizer-tab comment (new to this
//    project, low-risk, first use) is cc's real attempted fix, not a
//    confirmed root-cause diagnosis.
// 2. REAL FIX — the door-side arm reached all the way down to apex A,
//    which sits BELOW the real parting line (`NEW_SPLIT_Z`, on the fixed/
//    non-lid side of the A-B wall, per BBQ-chambers-v23.scad's own TASK 1
//    split) — i.e. part of the rib was anchored to FIXED shell material,
//    not the lid. Janis's own direct report: "rib looks longer past the
//    parting line... rib should end at door edge then reach out to the
//    handle." FIX: the door-side spine's lower anchor is now the real
//    parting-line point on the SAME A-B wall edge (`NEW_SPLIT_Z`, read
//    live, not re-derived), with the handle reached out FROM there —
//    apex A itself is no longer a spine point.
// 3. REAL FIX — `HANDLE_Y` -140 -> -110 (pulled back 30mm), Janis's own
//    direct instruction after seeing the real render: the handle
//    overhangs too far outward from the chamber. `HANDLE_Z` UNCHANGED
//    (confirmed correct by Janis, near apex A in Z). Real, flagged
//    consequence: `R_HANDLE` (radial pivot-to-handle distance) changes
//    551.9mm -> 534.3mm as a direct result — the swept force curve in
//    docs/lid-hinge-counterbalance-calc.md assumed the OLD handle
//    position and is now stale; NOT recomputed here (Janis has
//    explicitly deferred the stopper/counterbalance review until the
//    door can be opened) — flagged for that follow-up, not silently
//    left inconsistent without a note.
// 4. REAL FIX — Janis's own direct report: the rib "looks sunk into the
//    door" and "the ridge looks shorter than expected." Root cause: the
//    door-side spine's B/C (and, before fix 2, A) points are the octagon
//    shell's own real surface points — a rib profile centered exactly ON
//    that surface has roughly HALF its own material embedded inside the
//    lid's solid body. FIX: a real `DOOR_ARM_STANDOFF`(15mm) pulls the
//    split-point/B/C spine points outward along each wall segment's own
//    real outward normal (A-B wall: pure -Y; B-C shoulder:
//    (-0.7071,0.7071), computed live not hardcoded) — same "meat/
//    standoff" real-judgment-call pattern as this project's own
//    `HINGE_PIVOT_OFFSET` precedent. C's own corner treatment is
//    simplified vs. the CB-side's full swept arc around D (Section 9 of
//    the source prompt) — safe here because this arm is rigidly anchored
//    to the MOVING lid and never sweeps past a FIXED corner the way the
//    CB-branch does, so a single-normal offset is sufficient, not a
//    simplification that risks a missed collision.
//
// Everything else (CB1/stopper/prong geometry, apex-D corner-arc fix,
// axle/UCP204-12 placeholders, tray content) UNCHANGED from v6 — Janis
// has explicitly deferred reviewing that area until the door can be
// opened. v6 kept unchanged, on record.
//
// v6's own original header follows, UNCHANGED, kept as real history:
//
// BBQ Offset Smoker — Base Assembly
// Version: v6
// Date: 2026-07-24
// Source: BBQ-offset-smoker-base-v5.scad
// Changes: prompts/bbq-lid-hinge-three-rib-v2-cc-prompt.md. Supersedes
// the 2026-07-23 sideribs-v1 prompt entirely (never run/committed — see
// prompts/archive/ and cc_chat_log.md). TASK 3 (the "planned next
// addition" header note carried since the parting-shift round) is now
// real: the lid's hinge/handle/counterbalance mechanism, THREE IDENTICAL
// RIBS, ONE counterbalance arm (CB1), no fill weight. `include` bumped
// BBQ-understructure-v15.scad -> BBQ-understructure-v16.scad — see that
// file's own header for why (a real chain-break found+fixed this round:
// v15 itself is NOT edited, kept byte-identical, on record).
//
// Full moment-balance derivation, mass/CG table, round-trip self-check
// method, and the swept force curve: docs/lid-hinge-counterbalance-calc.md
// (Section 9 of the source prompt). Locked per that prompt's own Section 8
// — NOT recomputed/re-derived here, this round is geometry + collision QA
// only.
//
// REAL, FLAGGED FINDING (cc, this session, R-009/Verification Discipline
// Rule): the source prompt's own Section 3.6 gives BOTH a literal formula
// for CB1's open-state position (`D + 170.8*(0.7071,-0.7071) +
// 65.8*(0.7071,0.7071)`) AND an illustrative approximate result
// ("~536.5, 1269.2") for it — plugging the prompt's own locked numbers
// into its own locked formula, independently in Python, gives (598.6,
// 1207.1) instead, not (536.5, 1269.2) (full derivation in the calc doc).
// This file builds from the FORMULA (the real, locked geometric
// construction: 170.8mm from apex D along the D-E edge, 65.8mm standoff
// along the outward normal) — not the illustrative decimal, which is
// flagged as inconsistent with its own inputs, not silently reconciled.
//
// REAL BUG FOUND + FIXED VIA A ROUND-TRIP SWEEP CHECK, BEFORE SHIPPING
// (not assumed clean from Section 5's own "offset outward by 20mm... by
// construction" claim): a naive straight branch spine from the pivot
// directly to CB1's own native-frame position passes within 0.01mm of
// apex D at door_open_deg≈83.1° — effectively THROUGH the corner, not
// clear of it. Root cause: the 20mm-outward-offset-from-D-E-line
// construction gives a true 20mm clearance to the D-E FACE, but D is a
// CONVEX CORNER (where the C-D ridge face meets the D-E slope) — a
// straight offset of the two adjacent faces does not automatically clear
// the corner point itself by the same margin; a proper round offset needs
// an ARC there. FIX: the branch spine's corner-hugging waypoints trace a
// real 45mm-radius arc around D (from the C-D face's own outward normal
// direction to the D-E face's own outward normal direction, 9 points),
// converted to native/closed frame via the round-trip rotation formula —
// re-verified via a fine (0.01°) sweep: real minimum branch-centerline
// clearance to D across the FULL 0–90° sweep is 44.95mm (tiny shortfall
// from the true 45mm target is finite-sample chording, not a real
// exposure), giving ~24.9mm of real solid-material clearance net of the
// branch's own 20mm minimum half-width — comfortably clears the Section
// 10 apex-clearance rule (min 20mm) with margin. See docs/lid-hinge-
// counterbalance-calc.md for the full numeric derivation.
//
// REAL, SIGNIFICANT FINDING FROM THE MANDATORY 3-WAY COMBINATORIAL SWEEP
// (Section 11) — FLAGGED, NOT SILENTLY RESOLVED: rib0 (X=250) and rib2
// (X=665) both sit within the X-span of tray0/tray1 respectively (the two
// trays' own combined footprint spans almost the entire lid length,
// [-2.5,917.5], with only a 5mm gap near X=457.5 — rib1 alone lands in
// that gap). The door-side arm's real weld-flush run along A-B (both at
// world Y=0, Z=[850,1102.67]) occupies the SAME real wall real-estate the
// STOWED tray also needs when folded vertically flush against that same
// Y=0 wall (stowed tray real Z-range ≈[980,1285], overlapping the A-B/B-C
// run directly) — a genuine, structural interference confirmed via a real
// Python sweep (segment-vs-rectangle, both rib and tray full angle
// ranges, 1-2° steps), independent of RIB_T (fixed at each rib's own thin
// X-slice). Reducing the weld-zone's own local half-width (this file's
// `WELD_HALF_W`, cut from a naive 45mm to 25mm, real judgment call) helps
// but does NOT fully clear it — the bare centerline-to-centerline distance
// alone is already ~0mm at several combined angles (both features are
// necessarily anchored at/near the same Y=0 wall), so no reasonable local
// width reduction alone resolves this. Moving RIB_X does not help either
// (confirmed: the two trays' combined footprint leaves only ONE 5mm gap
// for 3 required ribs, so 2 of 3 ribs are unavoidably inside a tray's
// span at any placement). Resolving this fully would mean touching the
// tray (frozen this round, carried forward unchanged per Section 8) or a
// deeper cross-subsystem re-architecture beyond a first-draft rib profile
// pass — OUT OF THIS ROUND'S SCOPE. Flagged here, in
// docs/lid-hinge-counterbalance-calc.md, and in cc_chat_log.md as a real
// open item for Janis: either an operating-sequence note (do not stow/
// deploy tray0/tray1 while rib0/rib2 occupy the conflicting Z-band) or a
// follow-up round to relocate the tray hinges or the ribs' own X-position
// convention. QA Section 11's combinatorial-sweep item is reported FAIL
// for this specific interaction, per this project's own Verification
// Discipline Rule (state the real check result, do not assert "Simple:
// yes/EMPTY throughout" when it isn't) — every OTHER combination in the
// QA section (apex-D clearance, CB1-vs-D, handle reachability, U-prong
// wrap, lid_open_deg linkage) is real and clears with margin, see
// docs/lid-hinge-counterbalance-calc.md for the full matrix.
//
// v5 kept unchanged, on record (BBQ-offset-smoker-base-v5.scad). v5's own
// original header follows, UNCHANGED, kept as real history:
//
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
// (Full v1->v4 changelog omitted here — see BBQ-offset-smoker-base-v5.scad
// itself for the complete real record; every prior version kept
// unchanged, on record.)

include <BBQ-understructure-v16.scad>

// TASK 3 kinetic driver (`door_open_deg`) and the TASK 2 tray angles are
// declared together in one consolidated KINETIC PARAMETERS block near
// the bottom of this file, just before ASSEMBLY — v6.1, relocated per
// Janis's own direct feedback (see this file's own header). All 3 real
// dials, plus the `lid_open_deg` reassignment, live there now, not here.

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
// Declared in the KINETIC PARAMETERS block near the bottom of this file
// (v6.1 — relocated, not duplicated; see this file's own header).

module trays() {
    tray(TRAY0_X0, tray0_angle_deg);
    tray(TRAY1_X0, tray1_angle_deg);
}
// Mounted ONLY on the Y=0 side, confirmed by construction: tray()/
// tray_hinges() never reference chamber_W or any Y=chamber_W-side
// position — no mirrored/second copy exists.

// ═══════════════════════════════════════════════════════════════════
// TASK 3 — LID HINGE / HANDLE / COUNTERBALANCE, THREE IDENTICAL RIBS.
// Real geometry, reused directly from the chamber's own real octagon
// vertices (A-E, BBQ-chambers-v23.scad, section "TRUE OCTAGON" — not
// redrawn). Full derivation: docs/lid-hinge-counterbalance-calc.md.
// ═══════════════════════════════════════════════════════════════════

// ─── Octagon reference points (world Y,Z), reused live, not redrawn ───
RIB_REF_A = [0, APEX_A_Z];
RIB_REF_B = [0, chamber_floor_z + chamber_H - chamfer];
RIB_REF_C = [chamfer, DATUM_Z_RIDGE];
RIB_REF_D = [chamber_W - chamfer, DATUM_Z_RIDGE];
RIB_REF_E = [chamber_W, chamber_floor_z + chamber_H - chamfer];

// ─── Pivot (fulcrum) -- UNCHANGED from the prior session ───
FC_Y = RIB_REF_C[0] + 15;          // 15mm along the ridge, toward D
FC_Z = RIB_REF_C[1] + 33.3;        // UCP204-12's real "H" dimension

// ─── Grab handle -- v6.1 REAL FIX: HANDLE_Y -140 -> -110 (pulled back
// 30mm), Janis's own direct instruction after the real v6 render —
// overhung too far outward from the chamber. HANDLE_Z UNCHANGED,
// confirmed correct (near apex A in Z) — that is deliberate: the handle
// must sit below/outboard of the door so a hand pulling it down never
// touches the hot lid tip, and drops/reaches easily when open. ───
HANDLE_Y        = -110;            // v6.1: was -140 (prompt's own "corrected this session" value) -- pulled back 30mm per Janis's direct render feedback
HANDLE_Z        = RIB_REF_A[1] + 25;
HANDLE_ROD_OD   = 25.4;            // 1" hollow tube
HANDLE_ROD_WALL = 2;
HANDLE_BORE_D   = 32;              // TBD placeholder (30-32mm bushing clearance) -- confirm/resize once Janis has the real bushing part number
R_HANDLE = norm([HANDLE_Y - FC_Y, HANDLE_Z - FC_Z]);   // v6.1: 534.3mm (was 551.9mm) -- REAL, FLAGGED CONSEQUENCE of the HANDLE_Y fix: docs/lid-hinge-counterbalance-calc.md's own swept force curve assumed the OLD 551.9mm value and is now stale, not recomputed this round (Janis has deferred stopper/counterbalance review)

// ─── Axle / pivot bearing -- UCP204-12, UNCHANGED from prior session ───
AXLE_ROD_OD  = 25.4;               // 1" solid rod
AXLE_STUB_OD = 19.05;              // 3/4" machined stub, seats in pillow-block bore
AXLE_BORE_D  = 27;                 // reuses this project's own 27mm-bore-over-25.4mm-rod convention (Section 3.4 of the source prompt)
UCP_H = 33.3; UCP_L = 127; UCP_J = 95; UCP_A = 38; UCP_BOLT_D = 10;
// UCP_L(127mm, bolt-hole span) does not fit within UCP_A(38mm, base
// length) as literally catalog-stated -- flagged, not silently forced.
// Bolt pattern below is simplified (spaced across the foot's own real
// J=95mm width instead), consistent with this project's "simple bbox/
// cylinder only, no supplier casting detail" placeholder convention
// (rules-bbq-fab.md Construction Method, axle already listed there).

// ─── CB1 -- 4" sq counterbalance pipe ───
CB1_OD      = 101.6;
CB1_WALL    = 3;
CB1_LEN     = chamber_L - 100;             // live formula, 815mm
CB1_MASS_KG = 8.06;                        // LOCKED -- do not recompute, see docs/lid-hinge-counterbalance-calc.md
CB1_EDGE_DIST = 170.8;                     // LOCKED -- do not re-derive
CB1_AIR_GAP = 15;
CB1_STANDOFF = CB1_AIR_GAP + CB1_OD/2;     // 65.8mm, live formula

// D-E edge unit direction + outward normal (Section 3.6 of source prompt)
DE_LEN  = norm([RIB_REF_E[0]-RIB_REF_D[0], RIB_REF_E[1]-RIB_REF_D[1]]);        // 252.670mm
DE_DIR  = [(RIB_REF_E[0]-RIB_REF_D[0])/DE_LEN, (RIB_REF_E[1]-RIB_REF_D[1])/DE_LEN];  // (0.7071,-0.7071)
DE_NORM = [-DE_DIR[1], DE_DIR[0]];         // (0.7071,0.7071) outward -- confirmed points away from chamber interior

// CB1 pipe center + stopper contact point, OPEN-state (door_open_deg=90)
// world coordinates -- Section 3.6's own literal formula (see this
// file's header for the real flagged mismatch vs. the prompt's own
// illustrative decimal).
CB1_OPEN = [RIB_REF_D[0] + CB1_EDGE_DIST*DE_DIR[0] + CB1_STANDOFF*DE_NORM[0],
            RIB_REF_D[1] + CB1_EDGE_DIST*DE_DIR[1] + CB1_STANDOFF*DE_NORM[1]];
CONTACT_OPEN = [RIB_REF_D[0] + CB1_EDGE_DIST*DE_DIR[0], RIB_REF_D[1] + CB1_EDGE_DIST*DE_DIR[1]];

// ─── Round-trip rotation helpers -- the SAME real rotation convention as
// lid_rib_assembly() below, used to convert already-LOCKED real-world
// points between the OPEN (door_open_deg=90) frame they are naturally
// specified in and the CLOSED/native frame the rigid rib body is built
// in (Section 4's own "one consistent reference frame" rule). This is
// the real, reusable round-trip self-check pattern from
// docs/lid-hinge-counterbalance-calc.md — verified exactly against the
// handle_closed/handle_open pair before being trusted for CB1. ───
function rib_world_from_closed(pt, deg) =
    let(a = -deg, yp = pt[0]-FC_Y, zp = pt[1]-FC_Z)
    [FC_Y + yp*cos(a) - zp*sin(a), FC_Z + yp*sin(a) + zp*cos(a)];
function rib_closed_from_world(pt, deg) =
    let(a = -deg, dy = pt[0]-FC_Y, dz = pt[1]-FC_Z)
    [FC_Y + dy*cos(a) + dz*sin(a), FC_Z - dy*sin(a) + dz*cos(a)];

CB1_CLOSED     = rib_closed_from_world(CB1_OPEN, 90);
CONTACT_CLOSED = rib_closed_from_world(CONTACT_OPEN, 90);

// Corner-arc-around-D -- REAL FIX (see this file's own header): a naive
// straight branch spine swings within 0.01mm of apex D at ~83°. Fix:
// trace a real 45mm-radius arc around D itself (from the C-D ridge
// face's own outward normal (0,1) to the D-E face's own outward normal
// (0.7071,0.7071), i.e. phi 90°->45°), converted to native frame at
// door_open_deg=90 (the state this construction targets).
CORNER_STANDOFF = 45;   // = 20mm(apex clearance rule) + 20mm(min half-width) + 5mm real margin
CORNER_ARC_N    = 9;
CORNER_ARC_CLOSED = [for (i=[0:CORNER_ARC_N-1])
    let(phi = 90 - i*(45/(CORNER_ARC_N-1)),
        wp = [RIB_REF_D[0]+CORNER_STANDOFF*cos(phi), RIB_REF_D[1]+CORNER_STANDOFF*sin(phi)])
    rib_closed_from_world(wp, 90)];

// ─── v6.1 REAL FIX -- door-side arm now ends at the real parting line,
// not apex A: Janis's own direct report, "rib looks longer past the
// parting line... rib should end at door edge then reach out to the
// handle." Apex A sits BELOW `NEW_SPLIT_Z` on the SAME A-B wall edge --
// i.e. on the FIXED shell, not the lid (BBQ-chambers-v23.scad's own TASK
// 1 split) -- so a rib welded to the LID must not reach down that far.
// `RIB_SPLIT_PT` (real parting-line point, read live via `NEW_SPLIT_Z`,
// not re-derived) replaces `RIB_REF_A` as the door-side arm's own lower
// anchor; the handle reaches out FROM there. ───
RIB_SPLIT_PT = [0, NEW_SPLIT_Z];

// ─── v6.1 REAL FIX -- door-side arm pulled OFF the lid's own real
// surface: Janis's own direct report, the rib "looks sunk into the door"
// and "the ridge looks shorter than expected." A spine point centered
// exactly ON the octagon's own real surface (as v6 built it) has roughly
// HALF its own material embedded inside the lid's solid body. FIX: a
// real `DOOR_ARM_STANDOFF` pulls the split-point/B/C spine points
// outward along each wall segment's own real outward normal (computed
// live, not hardcoded) -- same real-judgment-call "standoff" pattern as
// this project's own `HINGE_PIVOT_OFFSET` precedent. C's own corner
// treatment (single-normal offset, not a full swept arc like the CB-side
// gets around apex D) is safe here because this arm is rigidly anchored
// to the MOVING lid and never sweeps past a FIXED corner -- unlike the
// CB-branch, which must clear the stationary apex D throughout the
// sweep. ───
DOOR_ARM_STANDOFF = 15;
AB_NORM = [-1, 0];                                  // A-B wall is vertical at world Y=0 -- outward is pure -Y
BC_LEN  = norm([RIB_REF_C[0]-RIB_REF_B[0], RIB_REF_C[1]-RIB_REF_B[1]]);
BC_DIR  = [(RIB_REF_C[0]-RIB_REF_B[0])/BC_LEN, (RIB_REF_C[1]-RIB_REF_B[1])/BC_LEN];   // (0.7071,0.7071)
BC_NORM = [-BC_DIR[1], BC_DIR[0]];                  // (-0.7071,0.7071), outward -- confirmed points away from chamber interior

RIB_SPLIT_OFFSET = [RIB_SPLIT_PT[0] + DOOR_ARM_STANDOFF*AB_NORM[0], RIB_SPLIT_PT[1] + DOOR_ARM_STANDOFF*AB_NORM[1]];
RIB_B_OFFSET     = [RIB_REF_B[0]    + DOOR_ARM_STANDOFF*AB_NORM[0], RIB_REF_B[1]    + DOOR_ARM_STANDOFF*AB_NORM[1]];
RIB_C_OFFSET     = [RIB_REF_C[0]    + DOOR_ARM_STANDOFF*BC_NORM[0], RIB_REF_C[1]    + DOOR_ARM_STANDOFF*BC_NORM[1]];

// ─── Full rib spine: handle -> split-point -> B -> C -> pivot ->
// corner-arc -> CB1 -> prong tip. Door-side arm traces the real
// A-B/B-C contour (Section 5), pulled proud of the surface per the fix
// above, ending at the real parting line (not apex A). CB-side branch
// traces the D-E contour offset outward (via the corner arc above,
// converted to native frame). ───
RIB_SPINE = concat(
    [[HANDLE_Y,HANDLE_Z], RIB_SPLIT_OFFSET, RIB_B_OFFSET, RIB_C_OFFSET, [FC_Y,FC_Z]],
    CORNER_ARC_CLOSED,
    [CB1_CLOSED, CONTACT_CLOSED]
);

RIB_T          = 3;      // 3mm laser-cut plate
MIN_HALF_W     = 20;     // 40mm minimum width (Section 5)
// WELD_HALF_W -- REAL, REDUCED FROM A NAIVE 45mm (see this file's own
// header, "tray interference" finding): the split-point-to-B weld-flush
// run's own 70-100mm target is satisfied by its real LENGTH along the
// wall, not by a wide radius bulging perpendicular into -Y (the adjacent
// tray's own territory). 25mm keeps real material there while minimizing
// (not fully eliminating -- see flagged finding) tray intrusion; C stays
// wider since it sits at Y=178.665, far from the tray's own Y<=0 reach.
WELD_HALF_W_SPLIT = 22;
WELD_HALF_W_B  = 25;
WELD_HALF_W_C  = 40;
HANDLE_WRAP_R  = HANDLE_BORE_D/2 + 15;   // 31mm, >=15mm meat around the handle bore
AXLE_HALF_W    = AXLE_BORE_D/2 + 15;     // 28.5mm, >=15mm meat around the axle bore
CB1_HALF_W     = CB1_OD/2 + 15;          // 65.8mm, >=15mm meat around the CB1 pipe
PRONG_TIP_HALF_W = MIN_HALF_W;           // 20mm, prong tip reaching the stopper contact point

RIB_SPINE_R = concat(
    [HANDLE_WRAP_R, WELD_HALF_W_SPLIT, WELD_HALF_W_B, WELD_HALF_W_C, AXLE_HALF_W],
    [for (i=[0:CORNER_ARC_N-1]) MIN_HALF_W],
    [CB1_HALF_W, PRONG_TIP_HALF_W]
);

// pt2(Y,Z) -> 2D drawing-plane coords, SAME [-Z,Y] convention as
// hex_pt() in BBQ-chambers-v23.scad ("encoded [-height,width] so that
// rotate([0,90,0]) after linear_extrude lands as world X=thickness,
// Y=width, Z=height") -- reused directly, not re-derived, since our
// Y,Z values here are already absolute world coordinates (no separate
// floor-relative "h" needed).
function pt2(pt) = [-pt[1], pt[0]];

// rib_spine_2d() -- hull-of-circles ("capsule chain"), gives the
// smooth, continuously-tapering/growing profile Section 5 asks for
// (no hard width changes, every join naturally filleted) -- reuses this
// project's own "hull() for rounded shapes" coding rule (cc_rules.md).
module rib_spine_2d() {
    for (i=[0:len(RIB_SPINE)-2])
        hull() {
            translate(pt2(RIB_SPINE[i]))   circle(r=RIB_SPINE_R[i],   $fn=64);
            translate(pt2(RIB_SPINE[i+1])) circle(r=RIB_SPINE_R[i+1], $fn=64);
        }
}
module rib_bores_2d() {
    translate(pt2([HANDLE_Y,HANDLE_Z])) circle(d=HANDLE_BORE_D, $fn=64);
    translate(pt2([FC_Y,FC_Z]))         circle(d=AXLE_BORE_D,   $fn=64);
}
// cb1_wrap_cut_2d() -- the U-shaped, HALF-wrap holder/stopper (Section
// 3.6): a full clearance hole for the pipe itself, PLUS an extra
// open-side removal (a big half-plane, oriented away from the D-E
// contact direction) so the rib's own material only wraps the pipe's
// CONTACT-facing half, not a full 360° collar. The long "reach" arm to
// the stopper contact point is the RIB_SPINE's own last segment (CB1 ->
// CONTACT_CLOSED) above -- naturally shorter on the open/cut side, per
// Section 3.6's "sides not required to be the same length".
module cb1_wrap_cut_2d() {
    wrap_ang = atan2(CONTACT_CLOSED[1]-CB1_CLOSED[1], CONTACT_CLOSED[0]-CB1_CLOSED[0]) + 90;
    union() {
        translate(pt2(CB1_CLOSED)) circle(r=CB1_OD/2 + 2, $fn=64);
        intersection() {
            translate(pt2(CB1_CLOSED)) circle(r=CB1_HALF_W + 10, $fn=64);
            translate(pt2(CB1_CLOSED)) rotate(wrap_ang + 180) translate([300,0]) square([600,600], center=true);
        }
    }
}
module rib_profile_2d() {
    difference() {
        rib_spine_2d();
        rib_bores_2d();
        cb1_wrap_cut_2d();
    }
}
// rib_solid() -- extrudes the 2D profile into the rib's own real 3mm
// plate, oriented so world X=thickness (centered), Y/Z=the profile's own
// real world Y,Z (via pt2()'s established flip convention).
module rib_solid() {
    rotate([0,90,0])
        translate([0,0,-RIB_T/2])
        linear_extrude(height=RIB_T, convexity=6)
            rib_profile_2d();
}

// lid_rib_assembly() -- Section 3.3's own given snippet, `RIB_X` fixed
// as a real module parameter (flagged gap in the prior session's own
// prompt: it appeared in that pseudocode but was never declared).
module lid_rib_assembly(RIB_X, door_open_deg=0) {
    translate([RIB_X, FC_Y, FC_Z])
        rotate([-door_open_deg, 0, 0])
        translate([0, -FC_Y, -FC_Z])
        rib_solid();
}
// lid_rib_rotate() -- the SAME transform, for the parts that span the
// FULL width across all 3 ribs (handle rod, CB1 pipe) and rotate as one
// rigid unit WITH the ribs (Section 4 Step 5 -- one consistent frame).
module lid_rib_rotate(door_open_deg) {
    translate([0, FC_Y, FC_Z])
        rotate([-door_open_deg, 0, 0])
        translate([0, -FC_Y, -FC_Z])
        children();
}

// ─── RIB X-positions -- ALL 3 RIBS IDENTICAL (Section 6) ───
RIB0_X = LID_X0 + 150;                  // 250mm
RIB2_X = LID_X1 - 150;                  // 665mm
RIB1_X = (RIB0_X + RIB2_X) / 2;         // 457.5mm

// ─── Handle rod -- hollow tube, rotates with the ribs, spans all 3 ───
HANDLE_SPAN_MARGIN = 15;
handle_x0 = RIB0_X - HANDLE_SPAN_MARGIN;
handle_x1 = RIB2_X + RIB_T + HANDLE_SPAN_MARGIN;
module handle_rod() {
    len = handle_x1 - handle_x0;
    translate([handle_x0, HANDLE_Y, HANDLE_Z]) rotate([0,90,0]) difference() {
        cylinder(h=len, r=HANDLE_ROD_OD/2, $fn=64);
        translate([0,0,-e]) cylinder(h=len+2*e, r=HANDLE_ROD_OD/2 - HANDLE_ROD_WALL, $fn=64);
    }
    // end caps -- close both ends of the hollow tube
    translate([handle_x0, HANDLE_Y, HANDLE_Z]) rotate([0,90,0])
        cylinder(h=HANDLE_ROD_WALL, r=HANDLE_ROD_OD/2, $fn=64);
    translate([handle_x1-HANDLE_ROD_WALL, HANDLE_Y, HANDLE_Z]) rotate([0,90,0])
        cylinder(h=HANDLE_ROD_WALL, r=HANDLE_ROD_OD/2, $fn=64);
}

// ─── CB1 pipe -- 4" sq tube, both ends capped, rotates with the ribs ───
cb1_x0 = (chamber_L - CB1_LEN) / 2;   // centered on chamber_L's own midpoint, live formula
cb1_x1 = cb1_x0 + CB1_LEN;
module cb1_pipe() {
    translate([cb1_x0, CB1_CLOSED[0], CB1_CLOSED[1]]) rotate([0,90,0]) difference() {
        translate([-CB1_OD/2,-CB1_OD/2,0]) cube([CB1_OD, CB1_OD, CB1_LEN]);
        translate([-CB1_OD/2+CB1_WALL,-CB1_OD/2+CB1_WALL,-e]) cube([CB1_OD-2*CB1_WALL, CB1_OD-2*CB1_WALL, CB1_LEN+2*e]);
    }
    translate([cb1_x0, CB1_CLOSED[0]-CB1_OD/2, CB1_CLOSED[1]-CB1_OD/2]) cube([CB1_WALL, CB1_OD, CB1_OD]);
    translate([cb1_x1-CB1_WALL, CB1_CLOSED[0]-CB1_OD/2, CB1_CLOSED[1]-CB1_OD/2]) cube([CB1_WALL, CB1_OD, CB1_OD]);
}

// ─── Axle + UCP204-12 pillow blocks -- FIXED reference geometry (Section
// 4 Step 1): does NOT rotate with door_open_deg, always at fc. Simple
// bbox/cylinder placeholder, no supplier casting detail (rules-bbq-fab.md
// Construction Method, axle already listed there). ───
AXLE_SPAN_MARGIN = 30;
axle_x0 = RIB0_X - AXLE_SPAN_MARGIN;
axle_x1 = RIB2_X + RIB_T + AXLE_SPAN_MARGIN;
module axle_rod() {
    translate([axle_x0, FC_Y, FC_Z]) rotate([0,90,0])
        cylinder(h=axle_x1-axle_x0, r=AXLE_ROD_OD/2, $fn=64);
}
module ucp_bearing(x_pos) {
    HOUSING_R = AXLE_STUB_OD/2 + 12;
    difference() {
        union() {
            translate([x_pos-UCP_A/2, FC_Y-UCP_J/2, FC_Z-UCP_H])
                cube([UCP_A, UCP_J, UCP_H-HOUSING_R+4]);
            translate([x_pos, FC_Y, FC_Z]) rotate([0,90,0])
                cylinder(h=UCP_A, r=HOUSING_R, $fn=32);
        }
        translate([x_pos-UCP_A/2-e, FC_Y, FC_Z]) rotate([0,90,0])
            cylinder(h=UCP_A+2*e, r=AXLE_STUB_OD/2+0.5, $fn=32);
        translate([x_pos, FC_Y-UCP_J/2+10, FC_Z-UCP_H-e]) cylinder(h=8+2*e, r=UCP_BOLT_D/2, $fn=16);
        translate([x_pos, FC_Y+UCP_J/2-10, FC_Z-UCP_H-e]) cylinder(h=8+2*e, r=UCP_BOLT_D/2, $fn=16);
    }
}

// ─── Full lid-hinge assembly ───
module lid_hinge_assembly(door_open_deg=0) {
    axle_rod();
    ucp_bearing(RIB0_X);
    ucp_bearing(RIB2_X + RIB_T);
    lid_rib_assembly(RIB0_X, door_open_deg);
    lid_rib_assembly(RIB1_X, door_open_deg);
    lid_rib_assembly(RIB2_X, door_open_deg);
    lid_rib_rotate(door_open_deg) handle_rod();
    lid_rib_rotate(door_open_deg) cb1_pipe();
}

// ───────────────────────────────
// KINETIC PARAMETERS — v6.1: consolidated here, all 3 real dials
// together, relocated from mid-file per Janis's own direct feedback
// (this file's own header). `door_open_deg` reassigns the chambers
// file's own `lid_open_deg` right here too — still textually after
// `include <BBQ-understructure-v16.scad>` above, which is all OpenSCAD's
// "last top-level assignment wins" rule actually requires; position
// within the rest of the file is free, but grouped here to match where
// this project's other files put their own kinetic parameters and where
// Janis was actually looking.
// ───────────────────────────────
/* [Kinetic Parameters] */
door_open_deg   = 0;      // 0=closed .. 90=open
tray0_angle_deg = 0;      // -90=stowed(vertical) .. 0=deployed(horizontal), default deployed per this project's own prior prep-shelf convention
tray1_angle_deg = 0;      // -90=stowed(vertical) .. 0=deployed(horizontal), independent from tray0_angle_deg per spec
lid_open_deg    = door_open_deg;

// ───────────────────────────────
// DEBUG TOGGLES
// ───────────────────────────────
show_trays      = true;
show_lid_hinge  = true;

// ───────────────────────────────
// ASSEMBLY — each line standalone/commentable per Module Isolation
// Testing (rules-codes.md). The chamber's own ASSEMBLY (chamber_shell/
// lid/firebox/exhaust_room/chimney_pipe/grate/drains) already executed
// above at include time, per BBQ-chambers-v23.scad's own DEBUG TOGGLES/
// ASSEMBLY section — this file adds the tray and the lid-hinge assembly.
// ───────────────────────────────
if (show_trays) color("#AAAAAA", 1.0) trays();
if (show_lid_hinge) color("#8C8C8C", 1.0) lid_hinge_assembly(door_open_deg);
