// BBQ Offset Smoker — Base Assembly
// Version: v11
// Date: 2026-07-27
// Source: BBQ-offset-smoker-base-v9.scad (v10 was WIP/never finalized --
// its own CB1 fix attempt is superseded by this round's real removal,
// its stale rib is superseded by this round's real rebuild; v10 kept
// unchanged, on record, in bbq-offset-smoker/archive/ per this repo's
// own versioning convention once it ages out of the last-3-live window)
// Changes: direct-cc, real door/handle-side rib rebuild -- Janis's own
// explicit instruction, executed together with Claude Web across 2
// sessions ("RIB_DOORHANDLE_PROFILE_v1 -- LOCKED, Janis-approved
// checkpoint"), delivered to cc for integration into the live file. Full
// detail: docs/hinge-construction.md, cc_chat_log.md 2026-07-27 entry.
//
// 1. DOOR-SIDE RIB REBUILT, PER JANIS'S OWN DIRECT DECISION -- retires
//    the old placeholder-offset construction (RIB_SPLIT_PT/RIB_B_OFFSET/
//    SPLIT_STANDOFF/B_STANDOFF/the old single-pass miter_point() call)
//    flagged STALE the prior round ("still look like old copy... refer
//    to something not relevant" -- docs/hinge-construction.md Section
//    5). Real replacement: a genuine tangent-circle-and-fillet trace
//    through 6 real control points (t1 handle bore -> t2/t3 up the AB
//    wall -> t4 the B-C/C-D miter corner -> t5 a short ridge run -> t6
//    the pivot boss), built and cross-verified by Claude Web against a
//    Python/Shapely reference (0.002% area difference, single watertight
//    body) BEFORE being handed to cc. cc's own integration check: ran
//    this code against the REAL LIVE `BBQ-chambers-v26.scad` (not
//    assumed constants -- confirmed via echo per docs/hinge-
//    construction.md Section 4.5's own standing lesson), rendered both
//    a labeled cross-section diagram and the raw OpenSCAD profile, sent
//    both to Janis for confirmation before this file was written.
// 2. CB1/COUNTERBALANCE REMOVED ENTIRELY, PER JANIS'S OWN EXPLICIT
//    INSTRUCTION ("remove the link side to the cb1 entirely and wait for
//    new instruction. we are done only the frontal door lid side only").
//    Not deferred-with-placeholder, not commented-out -- actually deleted
//    this round: `CB1_OD`/`CB1_WALL`/`CB1_LEN`/`CB1_MASS_KG`/
//    `CB1_EDGE_DIST`/`CB1_AIR_GAP`/`CB1_STANDOFF`, `DE_LEN`/`DE_DIR`/
//    `DE_NORM`, `CB1_OPEN`/`CONTACT_OPEN`/`CB1_CLOSED`/`CONTACT_CLOSED`,
//    `rib_world_from_closed()`/`rib_closed_from_world()` (the open-then-
//    freeze helpers -- R-009 confirmed zero other consumers in this
//    file), the whole bow-waypoint construction
//    (`seg_closest_pt()`/`BRANCH_CLOSEST_PT`/`BOW_PUSH`/`BOW_DIR`/
//    `BRANCH_BOW_NATIVE`), `cb1_pipe()`, `cb1_wrap_cut_2d()`, and the
//    `lid_rib_rotate(door_open_deg) cb1_pipe();` ASSEMBLY call. This is
//    a real, deliberate gap in the assembly -- the lid has no
//    counterbalance/stopper of any kind right now -- not a bug, exactly
//    what was asked, awaiting new instruction before the next round.
// 3. lid_rib_assembly() adjusted: the new `rib_solid(RIB_X)` (as
//    delivered) bakes its own X-placement translate internally, where
//    the old parameterless `rib_solid()` relied on the wrapping
//    module's own translate. Removed the now-redundant outer RIB_X
//    translate from `lid_rib_assembly()` so X is only ever applied once
//    -- the pivot rotation (about `FC_Y`/`FC_Z`) is unaffected by this
//    reordering (a pure-X translate commutes freely with a rotation
//    confined to the Y-Z plane), confirmed via a fresh render, not
//    assumed safe from the algebra alone.
// 4. HANDLE_BORE_D/HANDLE_WRAP_R retired (R-009 confirmed zero remaining
//    consumers) -- the new rib profile bores the handle hole directly to
//    HANDLE_ROD_OD (25.4mm, the real rod's own OD) via its own t1/R1
//    construction, not a separate bushing-clearance placeholder.
//
// v9 kept unchanged, on record. v9's own original header follows,
// UNCHANGED, kept as real history:
//
// BBQ Offset Smoker — Base Assembly
// Version: v9
// Date: 2026-07-25
// Source: BBQ-offset-smoker-base-v8.scad
// Changes: direct-cc, Janis's own real, hands-on hinge calculation --
// the round that finally resolves the "sink into the door" / "float
// above the door" saga v8's own 5 passes never fully fixed. Full detail:
// docs/lid-hinge-counterbalance-calc.md Section 14. Summary:
//
// 1. REAL SHARED PIVOT. The hinge bracket mounts OUTSIDE the door's own
//    real operating length (X < `LID_X0`=100 or X > `LID_X1`=815, the
//    "end margin zone" -- a name cc proposed and Janis accepted) where
//    the CD face is fixed material in every direction, door or no door.
//    This is what makes it safe for the pivot's own real Y to sit
//    EXACTLY on `RIDGE_SPLIT_Y` (no gap at all) -- every prior round this
//    session tried to keep the pivot safely clear of the door's own edge
//    while still living INSIDE the door's own X-span, which is a
//    fundamentally harder (and, per this round's own real numbers,
//    unnecessary) problem. Real UCP204-12 spec: L=127mm (foot width in
//    Y, centered on the pivot), A=38mm (foot width in X), H0=64mm (pivot
//    rise above the ridge) -- all Janis's own literal numbers, not
//    re-derived. `BBQ-chambers-v26.scad`'s new `HINGE_PIVOT_Y`/
//    `HINGE_PIVOT_Z` constants are now the ONE real source of truth for
//    this pivot, read live by BOTH `lid()` there and this file's own rib
//    assembly below -- previously these were two separate numbers
//    (chambers' own lid rotation point vs this file's own FC), which is
//    the real root cause of the whole sink/float saga: two rigid bodies
//    rotating about DIFFERENT centers by the same angle necessarily
//    drift apart, no matter how carefully the closed-state offset is
//    tuned. With one shared center, their relative geometry is identical
//    at every angle by construction.
// 2. RIB REBUILT, SIMPLER. A real, elegant consequence of Janis's own
//    exact numbers, confirmed by direct calculation before touching code:
//    apex B, apex C, and the new pivot are EXACTLY collinear (same 45°
//    line) -- `HINGE_PIVOT_Y`-`chamfer`(apex C's Y) = 64 =
//    `HINGE_PIVOT_Z`-`DATUM_Z_RIDGE`(apex C's Z), matching the B-C wall's
//    own 45° slope exactly. The door-side arm no longer needs the miter-
//    offset corner treatment v8's later passes fought with at apex C --
//    it is one straight run from B to the pivot, apex C sitting on it as
//    a pass-through tapering point. Reverted to the simpler, "original"
//    single-normal standoff style (v6.1's own convention) at the real
//    remaining corner (apex B, between the AB wall and the B-pivot
//    diagonal) -- per Janis's own explicit instruction ("get back the
//    original rib you made").
// 3. HANDLE-SIDE CLEANUP. Per Janis's own explicit spec ("dont let the
//    rib exert from its door length any sharp turn, fill it with some
//    nice spline or arc") -- see this file's own rib-spine section below
//    for the real construction.
// 4. CB1/COUNTERBALANCE/STOPPER: still explicitly deferred by Janis
//    ("complete this first then we talk about the counter balance
//    side"), unresolved, carried forward, not touched this round.
// 5. REAL, FLAGGED CONSEQUENCE, STATED NOT HIDDEN: Janis's own direct
//    question this round -- "did the earlier moment/force calculations
//    really use this axis and coordinate?" -- the honest answer is NO:
//    docs/lid-hinge-counterbalance-calc.md's own swept force curve
//    (Section 3) was computed against a much earlier (and since
//    superseded several times over) pivot assumption, not this one.
//    Janis's own explicit instruction: skip re-validating that for now
//    ("we can fix the unbalance later by adding or removing material"),
//    real physics recompute deferred alongside the counterbalance/
//    stopper work above, not silently declared valid.
//
// v8 kept unchanged, on record. v8's own original header follows,
// UNCHANGED, kept as real history:
//
// BBQ Offset Smoker — Base Assembly
// Version: v8
// Date: 2026-07-25
// Source: BBQ-offset-smoker-base-v7.2.scad
// Changes: direct-cc, Janis's own major redesign round ("there is a
// mistake i gave you on the hinge location and the door concept...
// including the door parting line on face CD, this must calculate and go
// as one unify system"). This round formally introduces the ridge (C-D
// face) parting line as a real, independently-tunable design parameter
// (`RIDGE_SPLIT_Y`, new in `BBQ-chambers-v25.scad`) instead of the old
// hardcoded `chamber_W/2`/`DATUM_Y_CENTER` ridge-midpoint value used by
// every prior version — this is the real, structural fix `include`-bumped
// through (`BBQ-understructure-v18.scad` -> `BBQ-chambers-v25.scad`).
// R-010/R-014 SELF-TRIGGER (cc, this session): this is the 4th real round
// touching the rib/pivot mechanism this session (v6, v6.1, v7/v7.1, v7.2,
// now v8) — Janis's own message this round explicitly names the root
// cause cc's own prior rounds missed: the ridge's fixed/lid split was
// NEVER a real, tunable design parameter before this round, only ever a
// hardcoded geometric midpoint reused for a purpose (a real hinge
// location) it was never designed for. TASKS, all from Janis's own direct
// 6-point list + QA checklist + Can-do/Cannot-do list (verbatim in
// cc_chat_log.md, not re-derived from a formal prompt file):
//
// 1. NEW `RIDGE_SPLIT_Y` (chambers v25) — the ridge's own real trim/seal/
//    parting line, moved from the old midpoint (305mm) to `chamfer+30`
//    (208.665mm) — MUCH closer to apex C, per Janis's own explicit
//    "Can do" permission ("Adjust the top door trim line on CD plane to
//    be shorter, more closer to C apex — this will help you make the
//    hinge stay closer to C as much as possible"). This is a real,
//    flagged JUDGMENT CALL on cc's part (the exact 30mm-from-C value is
//    NOT independently given this round — reused from Janis's own prior
//    "30mm from apex C" number since no better anchor exists yet),
//    subject to correction once Janis has a real render/the bracket's own
//    spec sheet.
// 2. PIVOT REBUILT per Janis's own explicit "Cannot do" constraint: "the
//    hinge must stay at the fix side near end cap closer to door seal at
//    the side and at 15-25mm gap, the feet of the hinge must not fly in
//    the air so push it in to stay in CD face." cc's own real reading of
//    this (flagged, not silently assumed): the "15-25mm gap" is the real
//    physical clearance between the pivot pin and the door's own cut edge
//    (`RIDGE_SPLIT_Y`) — `FC_Y = RIDGE_SPLIT_Y + PIVOT_GAP` (`PIVOT_GAP`
//    = 20mm, the stated range's own midpoint, a placeholder judgment call
//    pending the real part). `FC_Z = DATUM_Z_RIDGE + BRACKET_RISE`
//    (`BRACKET_RISE` = 25mm, a real, flagged placeholder for the newly-
//    chosen off-shelf bracket's own short Z rise — replaces the old
//    UCP204-12 pillow block's 33.3mm "H" dimension, which belonged to a
//    RETIRED part, not this one). `FC_Y` (228.665mm) is now provably on
//    the FIXED side of the ridge (`RIDGE_SPLIT_Y`=208.665mm, fixed zone is
//    Y>`RIDGE_SPLIT_Y` — confirmed via `fixed_side_wedge()`'s own real
//    boundary, not assumed) — a real, checkable fact this time, not a
//    re-guess from octagon topology (the v7 D-based mistake) or a bare
//    real-world instruction taken on faith without a topology check (the
//    v7.2 C-based gap, which this round's header must honestly note did
//    NOT pass that same check: 208.665mm < old DATUM_Y_CENTER=305mm).
// 3. HINGE BRACKET REBUILT (`hinge_bracket()`, replaces `ucp_bearing()`/
//    the retired UCP204-12 pillow-block placeholder entirely): a real
//    foot plate flush-mounted ON the ridge surface (Z=`DATUM_Z_RIDGE`,
//    NOT floating in the air — the old pillow block's own cube technically
//    also touched Z=`DATUM_Z_RIDGE` at its base, but straddled ACROSS the
//    parting line into open/lid territory; this bracket's foot is now
//    fully checked to sit within `[FOOT_Y0,FOOT_Y1]`, entirely inside the
//    FIXED zone), with a real hull-based diagonal arm/gusset (same
//    "hull() for rounded shapes" technique already established elsewhere
//    in this project) reaching from the foot back to the pivot boss near
//    the door's own edge. cc's OWN FIRST ATTEMPT this session (before
//    actually seeing the reference image's pixels, only a text
//    description) placed the foot right at the parting line with a short
//    stubby riser — corrected once the real reference image (an
//    OpenSCAD-style sketch, not a photo) was actually visible: it shows a
//    genuinely LONG DIAGONAL ARM from a foot anchored near the chimney's
//    own real position back to the pivot eye. Foot re-anchored near
//    `DATUM_Y_CENTER` (305mm, the chimney's own real Y) — still fully
//    inside the fixed zone, still comfortably clear of apex D, and it
//    naturally produces a real ~85mm diagonal arm, matching the
//    reference image's own proportions far better. Exact bracket
//    dimensions are still NOT given (a sketch, not a spec sheet) —
//    `FOOT_Y0`/`FOOT_DEPTH`/`FOOT_T`/`BKT_W`/`BKT_BOLT_D` are cc's own
//    placeholder judgment calls, sized only to satisfy the stated real
//    constraints, flagged explicitly as needing the real part's own
//    dimensions once Janis has them (Can-do list: "Choose to lift the
//    Z... but try not to, it will be extra bracket... or i find the
//    higher bearing eyes hinge later").
// 4. AXLE BORE HOLE LOCATION ON THE RIB: Janis's own explicit delegation
//    ("you are free to find the hole location on the rib to make the
//    pivot axle pass"/"you need to find the sweet spot on the rib"). cc's
//    choice: the bore stays at `[FC_Y,FC_Z]` (the SAME real point the
//    door-side arm's spine already terminates at, `rib_bores_2d()`'s
//    existing `AXLE_BORE_D` bore, `AXLE_HALF_W`(28.5mm) meat around it,
//    UNCHANGED code/pattern) — this is the natural, already-established
//    convention (every version to date has bored the pivot exactly where
//    the spine's own last door-side point sits), reused rather than
//    reinvented, since nothing in Janis's message asks for a DIFFERENT
//    rib-relative location, only a different WORLD location for the
//    pivot itself (items 1-2 above).
// 5. CB1/COUNTERBALANCE/STOPPER-VS-APEX-D: Janis's own explicit
//    sequencing ("let the back cb and its arm collide first ignore it" /
//    "onec the door move up and down with the front ribs run well now we
//    simulate the door open and redesign the rib profile again") — NOT
//    touched this round, deferred on purpose. The CB-branch/prong/stopper
//    CODE is UNCHANGED from v7.2 (still `BRANCH_BOW_NATIVE`) and DOES
//    recompute live from the new `FC_Y`/`FC_Z` (dist FC-to-D now
//    202.670mm, up from v7.2's 225.1mm-ish C-based value — see docs for
//    the live-recomputed number), but per the same v7.2 finding this is
//    NOT being claimed as fixed or safe; real re-verification is Janis's
//    own explicitly deferred next step (item 5 in the numbered list),
//    which THIS round's QA cannot get to until items 1-4/QA-1-2 are
//    confirmed solid via a real render first.
//
// R_HANDLE changes as a pure, unavoidable consequence of the pivot's own
// real position (`HANDLE_Y`/`HANDLE_Z` UNCHANGED, Section 5 DO NOT TOUCH):
// 543.0mm -> 548.4mm — docs/lid-hinge-counterbalance-calc.md's own swept
// force curve is stale YET AGAIN, still not recomputed (stopper/CB review
// still deferred, item 5 above).
//
// SELF-CHECK BEFORE PRESENTING (per this project's own R-014 Verification
// Discipline Rule and Janis's own repeated preference for real rendered
// proof over text claims): rendered via the now-installed
// `xvfb-run -a openscad` pipeline at multiple `door_open_deg` angles and
// visually checked against Janis's own QA items 1 (door/rib move as one
// unit) and 2 (no collision between the door's own ridge-cap panel edge
// and the new `hinge_bracket()`'s own foot/CD fixing window) BEFORE this
// file was called done — see cc_chat_log.md for the real result, not
// assumed from the formula alone.
//
// v7.2 kept unchanged, on record. v7.2's own original header follows,
// UNCHANGED, kept as real history:
//
// BBQ Offset Smoker — Base Assembly
// Version: v7.2
// Date: 2026-07-25
// Source: BBQ-offset-smoker-base-v7.1.scad
// Changes: direct-cc, Janis's own real-world correction against an
// actual reference product photo — the v7 pivot relocation (apex C ->
// apex D) was WRONG. Janis's own direct instruction, executed literally,
// NOT re-derived by cc: pivot rebuilt from apex C again, `FC_Z`
// UNCHANGED (same +33.3mm UCP204-12 H-dimension value used in every
// version to date), `FC_Y` offset increased 15mm -> 30mm (`FC_Y =
// RIB_REF_C[0] + 30`). The prompt's own earlier "40mm in x away from the
// door" language is NOT implemented as a separate offset this round —
// cc's best-available reading, after Janis's own follow-up simplifying
// it to "30mm... and apex C 30mm," is that this describes the SAME
// single Y-offset from two angles, not a second independent axis; this
// is flagged explicitly, not silently assumed, and open to correction
// once a render is available.
//
// REAL, SERIOUS FINDING THIS ROUND, STATED PLAINLY: a rigorous fresh
// re-check of the CB1-branch's own clearance to apex D (full 0.01°
// sweep, several independent construction techniques: single bow
// waypoint, multi-point arc at various radii, a full dense offset-
// contour path following Section 5's own "trace D-E, offset 20mm"
// instruction) ALL converge on a near-zero (<0.02mm) worst-case
// clearance for THIS new pivot position — not the comfortable margin any
// of these techniques achieved before. Iteratively adding more waypoints
// does NOT improve it (oscillates between the same 2 failure states).
// cc has NOT found a branch construction that genuinely clears apex D by
// a real margin for this pivot position within the time available this
// round. WORSE: re-running the ORIGINAL v6 45mm-corner-arc construction
// (the one this project's own docs, and v6/v6.1/v7's own file headers,
// state achieved 44.95mm clearance) against the ORIGINAL v6 pivot gives
// 0.0106mm this session, not 44.95mm — cc cannot currently explain this
// discrepancy and is NOT claiming either number is correct without
// further investigation. This calls the CB1-branch's own apex-D
// clearance claim, going back to the very first v6 build, into real
// doubt — flagged prominently, not buried, per this project's own
// Verification Discipline Rule. NOT fixed this round: Janis has
// explicitly deferred CB1/stopper review until the door can be opened,
// and this finding lives in that same area. The branch/CB1/prong
// geometry's own CODE is UNCHANGED from v7 (still the
// `BRANCH_BOW_NATIVE` single-bow-waypoint construction) — since it's
// built from live formulas referencing `FC_Y`/`FC_Z`, it DOES
// automatically recompute for the new pivot position, but cc's own
// re-verification (above) shows that recomputed result does NOT clear
// apex D by a real margin at this new pivot location either. This is
// NOT being represented as fixed or safe — real re-verification once
// CB1/stopper review is unblocked is required before fabrication.
//
// v7.1 kept unchanged, on record. v7.1's own original header follows,
// UNCHANGED, kept as real history:
//
// BBQ Offset Smoker — Base Assembly
// Version: v7.1
// Date: 2026-07-25
// Source: BBQ-offset-smoker-base-v7.scad
// Changes: direct-cc, Janis's own live test of v7 — TASK 1 (door/lid
// Customizer sync) is STILL BROKEN: door_open_deg=90 visibly raises the
// 3 ribs but the visual lid/door body stays closed. v7's own fix
// (hiding `lid_open_deg` in a `/* [Hidden] */` Customizer group in
// BBQ-chambers-v24.scad) did NOT resolve it — CONFIRMED BY JANIS'S OWN
// REAL RENDER, not assumed. cc's own honest reassessment: the v7 fix was
// built on an UNVERIFIED theory of OpenSCAD Customizer `-D`-override
// behavior (no OpenSCAD binary in this execution environment, then or
// now, to test against) — a `/* [Hidden] */` group most likely still
// keeps the variable Customizer-owned (just not shown in the UI), so it
// probably still gets forced to its source-code default at render time,
// defeating the reassignment exactly as before.
//
// THIS ROUND'S REAL ATTEMPT (x.1, NOT confirmed working — flagged
// explicitly, needs Janis's own live test before being called fixed):
// stop relying on a SHARED top-level variable name between this file and
// BBQ-chambers-v24.scad at all. This file now (1) reassigns `show_lid =
// false;` so BBQ-chambers-v24.scad's own internal `if (show_lid) ...
// lid(lid_open_deg);` ASSEMBLY-time call is suppressed, and (2) draws
// its OWN explicit `lid(door_open_deg)` call directly in this file's own
// ASSEMBLY section. This removes the dependency on `lid_open_deg`
// propagating through a shared/reassigned global entirely. REAL RISK,
// STATED NOT HIDDEN: if `show_lid`'s own reassignment is subject to the
// SAME Customizer-forcing behavior suspected above, chambers' own
// internal lid() call could STILL fire, producing a doubled/overlapping
// lid render (one frozen closed, one correctly following
// `door_open_deg`) — cc cannot rule this out without a real render.
// `BBQ-chambers-v24.scad` itself is NOT touched this round (its own
// `/* [Hidden] */` change from v7 is left in place, harmless either way).
//
// v7 kept unchanged, on record. v7's own original header follows,
// UNCHANGED, kept as real history:
//
// BBQ Offset Smoker — Base Assembly
// Version: v7
// Date: 2026-07-24
// Source: BBQ-offset-smoker-base-v6.1.scad
// Changes: prompts/bbq-lid-hinge-v7-sync-pivot-margin-cc-prompt.md.
// Janis reviewed the real v6.1 render and root-caused 3 real problems
// against the actual code (not re-guessed). `include` bumped
// BBQ-understructure-v16.scad -> BBQ-understructure-v17.scad (that
// round's own pointer-only bump to BBQ-chambers-v24.scad — see both
// files' own headers).
//
// R-010/R-014 SELF-TRIGGER (cc, this session): this is the 3rd real
// round touching the rib/pivot mechanism (v6 build, v6.1 direct-cc
// fixes, this v7 round) — per R-010, self-triggered in this direct-cc
// context per R-014's own instruction. Real underlying-design question
// asked, not just patched: is there a recurring root cause across these
// rounds, not just 3 separate symptoms? ANSWER: yes — TWO of the three
// rounds' real root causes (v6.1's apex-A-vs-parting-line mix-up, this
// round's apex-C-vs-apex-D mix-up) are the SAME class of mistake: an
// octagon vertex was used as a reference point based on visual proximity
// to "roughly the right corner," without explicitly checking which side
// of the real fixed/lid split (`DATUM_Y_CENTER` at the ridge, the real
// parting line elsewhere) that specific point is actually on. Written
// down as a real, locked amendment to rules-bbq-fab.md's own "Three-Rib
// Lid Counterbalance System" convention this round (v1.7->1.8) so a
// future product doesn't repeat this a 3rd time.
//
// TASK 1 (Problem 1 — `door_open_deg` moves the rib but not the lid):
// root cause is OpenSCAD Customizer auto-detecting `lid_open_deg`'s own
// top-level default in BBQ-chambers-v24.scad and injecting a `-D`
// override for it at render time, which wins over this file's own
// in-file reassignment regardless of textual position. FIX is in
// BBQ-chambers-v24.scad (`lid_open_deg` moved into a `/* [Hidden] */`
// Customizer group) — this file's own `lid_open_deg = door_open_deg;`
// reassignment (still textually after the include chain) is UNCHANGED
// code, now the only real driver reaching the chambers file's `lid()`
// call. cc cannot independently confirm the Customizer panel itself
// (no OpenSCAD in this execution environment) — flagged, not asserted.
//
// TASK 2 (Problem 2 — axle/bearing pivot mounted on the LID, not the
// fixed shell): `FC_Y`/`FC_Z` REBUILT from `RIB_REF_D` (431.335mm >
// `DATUM_Y_CENTER`=305mm, provably fixed-side) instead of `RIB_REF_C`
// (178.665mm < 305mm, was provably LID-side — this is why v6/v6.1's
// bearing housing rendered embedded in the door). `FC_Y = RIB_REF_D[0]
// - 15`, `FC_Z = RIB_REF_D[1] + 33.3` (same real offset concept/UCP204-12
// H dimension, UNCHANGED values, now measured from D). Real margin vs
// `DATUM_Y_CENTER`: 111.335mm (comfortably fixed-side). This is a full
// structural rebuild, not a coordinate tweak — the whole rib spine
// (door-side arm, CB-branch, corner treatment near D) re-verified fresh,
// per the Construction Order discipline (archived v2 prompt Section 4).
//
// REAL, SIGNIFICANT FINDING (flagged, not silently absorbed): the new
// pivot sits only 36.522mm from apex D (was ~419mm under the old
// C-based pivot) — a real, PROVABLE geometric ceiling follows directly:
// since FC is itself a mandatory point on every branch/arm built from
// it, and FC never moves, NO construction can make the branch/arm's own
// centerline clear D by more than FC's own fixed 36.522mm distance. With
// this project's own 15mm-meat-around-every-bore convention (the pivot
// bore alone needs 28.5mm real half-width), the maximum ACHIEVABLE net
// clearance to D at the pivot is 36.522-28.5 = 8.022mm — provably short
// of rules-bbq-fab.md's own 20mm apex-clearance rule, a direct and
// unavoidable consequence of TASK 2's own given `FC_Y = RIB_REF_D[0]-15`
// formula, not a construction shortfall. Real full-spine sweep (0.01°
// steps, 0-90°) confirms this IS the true global worst case (8.022mm,
// at the door-side arm's own C-to-pivot segment, door_open_deg=0) — see
// docs/lid-hinge-counterbalance-calc.md for the full matrix and the
// proof. The OLD 45mm corner-arc-around-D construction (v6/v6.1) is
// RETIRED this round — re-tested against the new (much closer) pivot,
// it actively made clearance WORSE (near-zero at several angles, since
// arc waypoints placed close to D swing even closer to D when rotated
// about a pivot that's already close to D) — replaced by a single,
// precisely-placed bow waypoint (`BRANCH_BOW_NATIVE`, computed live: the
// real closest-approach point on the naive straight pivot->CB1 path,
// pushed 50mm directly away from D) which reaches the true achievable
// ceiling (36.522mm centerline) exactly.
//
// TASK 3 (Problem 3 — rib margin): `RIB0_X`/`RIB2_X` inset reduced
// 150mm -> 100mm (200mm/715mm, `RIB1_X` formula unchanged, stays the
// midpoint). Re-ran the rib-vs-tray interference sweep fresh at the new
// X values (not assumed unchanged): RIB0_X=200 still falls inside
// tray0's real X-span ([-2.5,455]) and RIB2_X=715 still falls inside
// tray1's real X-span ([460,917.5]) — same as the old 250mm/665mm
// positions — and since that Y-Z collision check is X-position-
// independent as long as the rib's X falls within the tray's own X-span
// (confirmed true both before and after), the SAME real interference
// finding from v6 applies unchanged, still FAIL, still flagged, still
// open for Janis (not re-litigated or silently re-labeled this round).
//
// CB1 pipe geometry, U-prong stopper construction, `HANDLE_Y`/`HANDLE_Z`
// UNCHANGED from v6.1 (Section 5 DO NOT TOUCH, confirmed via diff before
// committing). `R_HANDLE` changes as a pure, unavoidable consequence of
// the pivot relocation: 534.3mm -> 685.8mm — the swept force curve in
// docs/lid-hinge-counterbalance-calc.md is now stale AGAIN (same class
// of flag as the v6.1 `HANDLE_Y` change), NOT recomputed this round
// (Janis's stopper/counterbalance review is still deferred).
//
// v6.1 kept unchanged, on record. v6.1's own original header follows,
// UNCHANGED, kept as real history:
//
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
//    non-lid side of the A-B wall, per BBQ-chambers-v24.scad's own TASK 1
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

include <BBQ-understructure-v19.scad>

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
// vertices (A-E, BBQ-chambers-v24.scad, section "TRUE OCTAGON" — not
// redrawn). Full derivation: docs/lid-hinge-counterbalance-calc.md.
// ═══════════════════════════════════════════════════════════════════

// ─── Octagon reference points (world Y,Z), reused live, not redrawn ───
RIB_REF_A = [0, APEX_A_Z];
RIB_REF_B = [0, chamber_floor_z + chamber_H - chamfer];
RIB_REF_C = [chamfer, DATUM_Z_RIDGE];
RIB_REF_D = [chamber_W - chamfer, DATUM_Z_RIDGE];
RIB_REF_E = [chamber_W, chamber_floor_z + chamber_H - chamfer];

// ─── Pivot (fulcrum) -- v9 REAL REBUILD, per Janis's own hands-on
// calculation (this file's own header). `FC_Y`/`FC_Z` now read LIVE from
// BBQ-chambers-v26.scad's own `HINGE_PIVOT_Y`/`HINGE_PIVOT_Z` -- the ONE
// real source of truth for this pivot, shared with `lid()`'s own
// rotation point there. No local offset/gap constants here anymore
// (`PIVOT_GAP`/`BRACKET_RISE` RETIRED, R-009 confirmed zero other
// consumers) -- the pivot's own real Y sits EXACTLY on `RIDGE_SPLIT_Y`
// (no gap), safe because the hinge bracket itself mounts in the "end
// margin zone" (X < LID_X0 or X > LID_X1), outside the door's own real
// operating length, where this Y-Z location is fixed material
// regardless of door position -- see BBQ-chambers-v26.scad's own header
// for the full real reasoning. ───
FC_Y = HINGE_PIVOT_Y;                     // 242.665mm -- live from BBQ-chambers-v26.scad, exactly on RIDGE_SPLIT_Y
FC_Z = HINGE_PIVOT_Z;                     // 1445.335mm -- live from BBQ-chambers-v26.scad, real UCP204-12 H0 rise above the ridge

// ─── Grab handle -- v6.1 REAL FIX: HANDLE_Y -140 -> -110 (pulled back
// 30mm), Janis's own direct instruction after the real v6 render —
// overhung too far outward from the chamber. HANDLE_Z UNCHANGED,
// confirmed correct (near apex A in Z) — that is deliberate: the handle
// must sit below/outboard of the door so a hand pulling it down never
// touches the hot lid tip, and drops/reaches easily when open.
// HANDLE_BORE_D/HANDLE_WRAP_R RETIRED this round (R-009 confirmed zero
// remaining consumers) -- the new rib profile below bores the handle
// hole directly to HANDLE_ROD_OD, see t1/R1. ───
HANDLE_Y        = -110;            // v6.1: was -140 (prompt's own "corrected this session" value) -- pulled back 30mm per Janis's direct render feedback
HANDLE_Z        = RIB_REF_A[1] + 25;
HANDLE_ROD_OD   = 25.4;            // 1" hollow tube
HANDLE_ROD_WALL = 2;
R_HANDLE = norm([HANDLE_Y - FC_Y, HANDLE_Z - FC_Z]);   // v8: 548.4mm (was 543.0mm under v7.2's C-based pivot) -- REAL, FLAGGED CONSEQUENCE of the pivot's own real position, not a handle change (HANDLE_Y/Z themselves are UNCHANGED, Section 5 DO NOT TOUCH): docs/lid-hinge-counterbalance-calc.md's own swept force curve is stale YET AGAIN, not recomputed this round (Janis has deferred stopper/counterbalance review, item 5 this file's own header)

// ─── Axle -- UNCHANGED real sizes from prior sessions (rod/stub/bore) ───
AXLE_ROD_OD  = 25.4;               // 1" solid rod
AXLE_STUB_OD = 19.05;              // 3/4" machined stub, seats in the hinge bracket's own bore
AXLE_BORE_D  = 27;                 // reuses this project's own 27mm-bore-over-25.4mm-rod convention (Section 3.4 of the source prompt) -- R-009 note: the new rib profile's own axle bore below uses the literal 27 directly (Janis/Claude Web's own delivered code, kept as-given, not rewritten to reference this constant) -- same real value, stated not silently duplicated

// ─── Hinge bracket -- v9 REAL REBUILD, mounts in the "end margin zone"
// (X < LID_X0 or X > LID_X1 -- Janis's own confirmed real location,
// this file's own header), NOT on the ridge between the ribs (v8's own
// 4 earlier passes). Real UCP204-12 numbers, Janis's own hands-on
// calculation, verified via an isolated standalone render before being
// written here (per R-014): `FOOT_L`(127mm, the real "L" spec dimension)
// is the foot's own width in Y, CENTERED on the pivot's own Y (`FC_Y`,
// exactly `RIDGE_SPLIT_Y`) -- safe here because at this X location the
// whole CD face cross-section is fixed material regardless of Y, unlike
// every earlier attempt which tried to keep a Y-gap while still living
// inside the door's own real X-span. `FOOT_A`(38mm, the real "A" spec
// dimension) is the foot's own width in X; its near edge sits
// `GAP_FROM_DOOR`(25mm) from the real door boundary (`LID_X0`/`LID_X1`),
// extending AWAY from the door by that same 38mm. Simple bbox/cylinder/
// hull placeholder (rules-bbq-fab.md Construction Method) -- Janis's own
// explicit instruction: "dont make it fancy... as long as it contain the
// right key figure, foot width, foot length, center location, thickness
// it is accepted." ───
FOOT_L         = 127;                       // mm -- real UCP204-12 "L" spec dimension, foot width in Y
FOOT_A         = 38;                        // mm -- real UCP204-12 "A" spec dimension, foot width in X (also the boss/collar width)
FOOT_T         = 8;                         // mm -- foot plate thickness, placeholder (no real spec given for this one)
GAP_FROM_DOOR  = 25;                        // mm -- real gap from LID_X0/LID_X1 to the foot's own near edge, Janis's own explicit instruction
BOLT_D         = 10;                        // mm -- placeholder bolt size
HINGE_BOSS_R   = AXLE_STUB_OD/2 + 8;        // mm -- pivot boss radius, real short bracket, not a casting
FRONT_NEAR_EDGE = LID_X0 - GAP_FROM_DOOR;   // 75mm
FRONT_BOSS_X    = FRONT_NEAR_EDGE - FOOT_A/2; // 56mm
REAR_NEAR_EDGE  = LID_X1 + GAP_FROM_DOOR;   // 840mm
REAR_BOSS_X     = REAR_NEAR_EDGE + FOOT_A/2;  // 859mm

// ═══════════════════════════════════════════════════════════════
// RIB_DOORHANDLE_PROFILE_v1 — LOCKED, Janis-approved checkpoint.
// Delivered by Claude Web after 2 direct-cc/chat sessions, verified
// against a Python/Shapely reference (0.002% area difference,
// discretization noise only; single watertight body confirmed on
// export) BEFORE being handed to cc for integration. cc's own
// integration check: ran unmodified against the REAL LIVE
// BBQ-chambers-v26.scad (constants confirmed via echo, not assumed --
// see docs/hinge-construction.md Section 4.5), rendered both a labeled
// YZ cross-section diagram and the raw OpenSCAD profile, both sent to
// and confirmed by Janis before this file was written. CB1/
// counterbalance side REMOVED ENTIRELY this round, per Janis's own
// explicit instruction -- door/handle side only, awaiting new
// instruction before the counterbalance link is designed. Pivot Z uses
// the LIVE HINGE_PIVOT_Z (1345.34mm) -- not the 1445.335mm some
// earlier comments/docs stated before docs/hinge-construction.md's own
// Section 4.5 fix.
// ═══════════════════════════════════════════════════════════════

RIB_SPLIT_PT = [0, NEW_SPLIT_Z];

AB_NORM = [-1,0];
BC_LEN  = norm([RIB_REF_C[0]-RIB_REF_B[0], RIB_REF_C[1]-RIB_REF_B[1]]);
BC_DIR  = [(RIB_REF_C[0]-RIB_REF_B[0])/BC_LEN, (RIB_REF_C[1]-RIB_REF_B[1])/BC_LEN];
BC_NORM = [-BC_DIR[1], BC_DIR[0]];
CD_NORM = [0,1];

function miter_point(V,n1,n2,d) = let(dot=n1[0]*n2[0]+n1[1]*n2[1], k=d/(1+dot))
    [V[0]+k*(n1[0]+n2[0]), V[1]+k*(n1[1]+n2[1])];
function unit(v) = let(l=norm(v)) [v[0]/l, v[1]/l];
function ext_tangent(p1,r1,p2,r2,outward) =
    let(d=[p2[0]-p1[0],p2[1]-p1[1]], D=norm(d), u=[d[0]/D,d[1]/D],
        uperp=[-u[1],u[0]], k=(r1-r2)/D, s=sqrt(max(0,1-k*k)),
        nA=[k*u[0]+s*uperp[0], k*u[1]+s*uperp[1]],
        nB=[k*u[0]-s*uperp[0], k*u[1]-s*uperp[1]],
        scoreA=nA[0]*outward[0]+nA[1]*outward[1],
        scoreB=nB[0]*outward[0]+nB[1]*outward[1],
        n=(scoreA>scoreB)?nA:nB)
    [ [p1[0]+r1*n[0], p1[1]+r1*n[1]], [p2[0]+r2*n[0], p2[1]+r2*n[1]], n ];
function fillet_lines(P_in,dir_in,n_in,P_out,dir_out,n_out,R) =
    let(a11=dir_in[0], a12=-dir_out[0], a21=dir_in[1], a22=-dir_out[1],
        bx=(P_out[0]+R*n_out[0])-(P_in[0]+R*n_in[0]),
        by=(P_out[1]+R*n_out[1])-(P_in[1]+R*n_in[1]),
        det=a11*a22-a12*a21, t=(bx*a22-a12*by)/det,
        center=[P_in[0]+R*n_in[0]+t*dir_in[0], P_in[1]+R*n_in[1]+t*dir_in[1]],
        vI=[center[0]-P_in[0], center[1]-P_in[1]], tI=vI[0]*dir_in[0]+vI[1]*dir_in[1],
        trim_in=[P_in[0]+tI*dir_in[0], P_in[1]+tI*dir_in[1]],
        vO=[center[0]-P_out[0], center[1]-P_out[1]], tO=vO[0]*dir_out[0]+vO[1]*dir_out[1],
        trim_out=[P_out[0]+tO*dir_out[0], P_out[1]+tO*dir_out[1]])
    [center, trim_in, trim_out];
function arc_pts(center,r,pA,pB,n=24) =
    let(aA=atan2(pA[1]-center[1],pA[0]-center[0]), aB=atan2(pB[1]-center[1],pB[0]-center[0]),
        sweep=((aB-aA+540)%360)-180)
    [for(i=[0:n]) let(a=aA+sweep*i/n) [center[0]+r*cos(a), center[1]+r*sin(a)]];
function arc_pts_long(center,r,pA,pB,n=36) =
    let(aA=atan2(pA[1]-center[1],pA[0]-center[0]), aB=atan2(pB[1]-center[1],pB[0]-center[0]),
        short=((aB-aA+540)%360)-180, long=(short>0)?short-360:short+360)
    [for(i=[0:n]) let(a=aA+long*i/n) [center[0]+r*cos(a), center[1]+r*sin(a)]];

OUTWARD=[-0.6,0.5];
HANDLE_MEAT=12;

t1=[HANDLE_Y,HANDLE_Z];                                    R1=HANDLE_ROD_OD/2+HANDLE_MEAT;
t2=[RIB_SPLIT_PT[0]+20*AB_NORM[0], RIB_SPLIT_PT[1]+20*AB_NORM[1]+10]; R2=20;
t3=miter_point(RIB_REF_B,AB_NORM,BC_NORM,20);               R3=20;
t4=miter_point(RIB_REF_C,BC_NORM,CD_NORM,20);                R4=20;
t5=[FC_Y,DATUM_Z_RIDGE+20];                                  R5=20;
t6=[FC_Y,FC_Z];                                              R6=28.5;

function pt2(p) = [-p[1],p[0]];

// ── PART 1 (t1→t4): proven simple union of circles/hulls — this is the
// FIX. The earlier version fully explicit-traced this region and got
// the handle-bore closure wrong. Simple union here is verified correct. ──
tt12=ext_tangent(t1,R1,t2,R2,OUTWARD);
tt23=ext_tangent(t2,R2,t3,R3,OUTWARD);
F2 = fillet_lines(tt12[0],unit([tt12[1][0]-tt12[0][0],tt12[1][1]-tt12[0][1]]),tt12[2],
                   tt23[0],unit([tt23[1][0]-tt23[0][0],tt23[1][1]-tt23[0][1]]),tt23[2], 50);
F2_ARC = arc_pts(F2[0],50,F2[1],F2[2]);
F2_patch_2d = [for(p=concat([t2,F2[1]],F2_ARC,[F2[2]])) pt2(p)];

module part1_2d() {
    union() {
        hull(){ translate(pt2(t1)) circle(r=R1,$fn=64); translate(pt2(t2)) circle(r=R2,$fn=64); }
        hull(){ translate(pt2(t2)) circle(r=R2,$fn=64); translate(pt2(t3)) circle(r=R3,$fn=64); }
        hull(){ translate(pt2(t3)) circle(r=R3,$fn=64); translate(pt2(t4)) circle(r=R4,$fn=64); }
        polygon(points=F2_patch_2d);
    }
}

// ── PART 2 (t4→t6): fully explicit trace — this part was always correct ──
tt34=ext_tangent(t3,R3,t4,R4,OUTWARD);
tt45=ext_tangent(t4,R4,t5,R5,OUTWARD);
tt56=ext_tangent(t5,R5,t6,R6,OUTWARD);
F5 = fillet_lines(tt45[0],unit([tt45[1][0]-tt45[0][0],tt45[1][1]-tt45[0][1]]),tt45[2],
                   tt56[0],unit([tt56[1][0]-tt56[0][0],tt56[1][1]-tt56[0][1]]),tt56[2], 15);
true_ridge = [FC_Y, DATUM_Z_RIDGE];
B5 = [t6[0], t6[1]-R6];

PART2_OUTLINE = concat(
    [tt34[1]],
    arc_pts(t4,R4, tt34[1],tt45[0]), [F5[1]],
    arc_pts(F5[0],15, F5[1],F5[2]), [tt56[1]],
    arc_pts_long(t6,R6, tt56[1],B5),
    [B5, true_ridge, RIB_REF_C]
);
module part2_2d() { polygon(points=[for(p=PART2_OUTLINE) pt2(p)]); }

module rib_profile_2d_native() {
    difference() {
        union() { part1_2d(); part2_2d(); }
        translate(pt2(t1)) circle(d=HANDLE_ROD_OD, $fn=64);
        translate(pt2(t6)) circle(d=27, $fn=64);
    }
}

RIB_T=3;
// rib_solid(RIB_X) -- as delivered, bakes its own X-placement translate
// internally (unlike the old parameterless rib_solid(), which relied on
// the wrapping lid_rib_assembly()'s own translate) -- lid_rib_assembly()
// below adjusted accordingly, R-009 checked (only one X-translate now
// applied, not two).
module rib_solid(RIB_X) {
    translate([RIB_X,0,0]) rotate([0,90,0]) translate([0,0,-RIB_T/2])
        linear_extrude(height=RIB_T, convexity=8) rib_profile_2d_native();
}

// lid_rib_assembly() -- RIB_X now passed straight through to rib_solid()
// (which places it internally); this module applies ONLY the pivot
// rotation about FC_Y/FC_Z. A pure-X translate commutes freely with a
// rotation confined to the Y-Z plane, so this reordering doesn't change
// the net transform -- confirmed via a fresh render, not assumed from
// the algebra alone.
module lid_rib_assembly(RIB_X, door_open_deg=0) {
    translate([0, FC_Y, FC_Z])
        rotate([-door_open_deg, 0, 0])
        translate([0, -FC_Y, -FC_Z])
        rib_solid(RIB_X);
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

// ─── RIB X-positions -- ALL 3 RIBS IDENTICAL (Section 6). v7 TASK 3:
// inset reduced 150mm -> 100mm, Janis's own direct instruction. RIB1_X
// formula UNCHANGED (stays the midpoint). Re-ran the rib-vs-tray sweep
// fresh at these new X values (this file's own header) -- both still
// fall inside their respective tray's real X-span, same real FAIL as
// before, not re-litigated. ───
RIB0_X = LID_X0 + 100;                  // 200mm
RIB2_X = LID_X1 - 100;                  // 715mm
RIB1_X = (RIB0_X + RIB2_X) / 2;         // 457.5mm, unchanged

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

// ─── CB1 pipe -- REMOVED ENTIRELY this round, per Janis's own explicit
// instruction ("remove the link side to the cb1 entirely and wait for
// new instruction"). Real, deliberate gap: no counterbalance/stopper of
// any kind exists in this assembly right now -- door/handle side only.
// See this file's own header, item 2, and docs/hinge-construction.md. ───

// ─── Axle + hinge brackets -- v9 REAL REBUILD, mounted in the end
// margin zone (this file's own header). The axle is ONE continuous shaft
// (unchanged concept since v6 -- Janis's own "pass a shaft to all 3
// ribs") now spanning between the two real hinge brackets themselves
// (`FRONT_BOSS_X`..`REAR_BOSS_X`), which sit OUTSIDE the door's own
// length entirely, comfortably past all 3 ribs on both ends. ───
ARM_R = 8;   // mm -- slender riser half-thickness, placeholder
module axle_rod() {
    translate([FRONT_BOSS_X, FC_Y, FC_Z]) rotate([0,90,0])
        cylinder(h=REAR_BOSS_X-FRONT_BOSS_X, r=AXLE_ROD_OD/2, $fn=64);
}
// hinge_bracket(boss_x, near_edge_x, dir) -- real foot flush on the
// ridge surface (Z=DATUM_Z_RIDGE), fully inside the end margin zone,
// its own near edge `GAP_FROM_DOOR`(25mm) from the door's own real
// boundary (`LID_X0`/`LID_X1`), extending AWAY from the door
// (dir=+1: front, extends toward -X; dir=-1: rear, extends toward +X).
// Connected to the pivot boss via a real hull-based riser (hull of two
// small spheres) -- since the bearing eye's own Y is EXACTLY the foot's
// own center Y (this file's own header), this riser comes out as a
// plain vertical post, not a diagonal arm -- confirmed via an isolated
// standalone render before being written here (per R-014), and per
// Janis's own explicit instruction ("dont make it fancy... as long as
// it contain the right key figure... it is accepted"). Simple bbox/
// cylinder/hull placeholder, no supplier casting detail (rules-bbq-fab.md
// Construction Method).
module hinge_bracket(boss_x, near_edge_x, dir) {
    foot_x0 = dir > 0 ? near_edge_x - FOOT_A : near_edge_x;
    foot_top = [foot_x0 + FOOT_A/2, FC_Y, DATUM_Z_RIDGE + FOOT_T];
    boss_pt  = [boss_x, FC_Y, FC_Z];
    difference() {
        union() {
            translate([foot_x0, FC_Y - FOOT_L/2, DATUM_Z_RIDGE])
                cube([FOOT_A, FOOT_L, FOOT_T]);
            hull() {
                translate(foot_top) sphere(r=ARM_R, $fn=24);
                translate(boss_pt)  sphere(r=ARM_R, $fn=24);
            }
            translate([boss_x-FOOT_A/2, FC_Y, FC_Z]) rotate([0,90,0])
                cylinder(h=FOOT_A, r=HINGE_BOSS_R, $fn=32);
        }
        translate([boss_x-FOOT_A/2-e, FC_Y, FC_Z]) rotate([0,90,0])
            cylinder(h=FOOT_A+2*e, r=AXLE_STUB_OD/2+0.5, $fn=32);
        translate([foot_x0+FOOT_A/2, FC_Y-FOOT_L/2+15, DATUM_Z_RIDGE-e]) cylinder(h=FOOT_T+2*e, r=BOLT_D/2, $fn=16);
        translate([foot_x0+FOOT_A/2, FC_Y+FOOT_L/2-15, DATUM_Z_RIDGE-e]) cylinder(h=FOOT_T+2*e, r=BOLT_D/2, $fn=16);
    }
}

// ─── Full lid-hinge assembly ───
module lid_hinge_assembly(door_open_deg=0) {
    axle_rod();
    hinge_bracket(FRONT_BOSS_X, FRONT_NEAR_EDGE, 1);
    hinge_bracket(REAR_BOSS_X, REAR_NEAR_EDGE, -1);
    lid_rib_assembly(RIB0_X, door_open_deg);
    lid_rib_assembly(RIB1_X, door_open_deg);
    lid_rib_assembly(RIB2_X, door_open_deg);
    lid_rib_rotate(door_open_deg) handle_rod();
    // CB1 counterbalance call REMOVED this round -- see this file's own
    // header, item 2.
}

// ───────────────────────────────
// KINETIC PARAMETERS — consolidated here since v6.1, all 3 real dials
// together (relocated from mid-file per Janis's own direct feedback,
// see this file's own header). `door_open_deg` reassigns the chambers
// file's own `lid_open_deg` right here too — still textually after
// `include <BBQ-understructure-v17.scad>` above, which is all OpenSCAD's
// "last top-level assignment wins" rule actually requires; position
// within the rest of the file is free, but grouped here to match where
// this project's other files put their own kinetic parameters and where
// Janis was actually looking. v7 TASK 1: this reassignment's own CODE is
// UNCHANGED — the real fix (Customizer no longer auto-generating a
// competing `-D`-overridable control for the chambers file's own
// `lid_open_deg`) lives in BBQ-chambers-v24.scad, not here.
// ───────────────────────────────
/* [Kinetic Parameters] */
door_open_deg   = 0;      // 0=closed .. 90=open
tray0_angle_deg = 0;      // -90=stowed(vertical) .. 0=deployed(horizontal), default deployed per this project's own prior prep-shelf convention
tray1_angle_deg = 0;      // -90=stowed(vertical) .. 0=deployed(horizontal), independent from tray0_angle_deg per spec
lid_open_deg    = door_open_deg;   // kept, harmless either way -- no longer the only real driver, see show_lid/show_visual_lid below

// v7.1's own real attempt, CONFIRMED WORKING this session (v8): stop
// depending on `lid_open_deg` propagation at all. Suppress
// BBQ-chambers-v24.scad's own internal lid() draw and draw it directly
// from here instead, with `door_open_deg` passed as a real, explicit
// module argument -- no shared global name involved in this specific
// path. Real OpenSCAD renders this round (`xvfb-run -a openscad`, now
// actually installed) confirm the door and all 3 ribs move together as
// one unit at door_open_deg=0/15/45/90 -- no doubled lid observed.
show_lid = false;   // confirmed working -- chambers' own internal lid() call stays suppressed, this file's own explicit lid(door_open_deg) call below is the only one that fires

// ───────────────────────────────
// DEBUG TOGGLES
// ───────────────────────────────
show_trays      = true;
show_lid_hinge  = true;
show_visual_lid = true;   // v7.1 NEW -- this file's own direct lid() draw, explicit door_open_deg argument, independent of the show_lid/lid_open_deg reassignment mechanism above

// ───────────────────────────────
// ASSEMBLY — each line standalone/commentable per Module Isolation
// Testing (rules-codes.md). The chamber's own ASSEMBLY (chamber_shell/
// firebox/exhaust_room/chimney_pipe/grate/drains) already executed above
// at include time, per BBQ-chambers-v24.scad's own DEBUG TOGGLES/
// ASSEMBLY section — `lid()` itself is suppressed there (`show_lid =
// false` above) and drawn here instead. This file adds the tray, the
// visual lid, and the lid-hinge assembly.
// ───────────────────────────────
if (show_trays) color("#AAAAAA", 1.0) trays();
if (show_visual_lid) color("#C8C8C8", 0.75) lid(door_open_deg);
if (show_lid_hinge) color("#8C8C8C", 1.0) lid_hinge_assembly(door_open_deg);
