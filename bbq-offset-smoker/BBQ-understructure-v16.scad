// BBQ Offset Smoker — Understructure
// Version: v16
// Date: 2026-07-24
// Source: BBQ-understructure-v15.scad
// Changes: prompts/bbq-lid-hinge-three-rib-v2-cc-prompt.md. PURE
// POINTER-ONLY BUMP -- zero understructure geometry changed this round.
// `include` bumped BBQ-chambers-v22.scad -> BBQ-chambers-v23.scad (that
// round's Section 7.5: retires the stale, always-off `lid_hardware()`
// stub + LEVER_ARM/COUNTERWEIGHT_KG constants, R-009 confirmed dead —
// zero other content changed, see BBQ-chambers-v23.scad's own header).
//
// REAL, NECESSARY DEVIATION FROM THE PROMPT'S OWN LITERAL TEXT, FLAGGED
// NOT SILENTLY DONE: the source prompt's own Section 8 ("DO NOT TOUCH")
// says "BBQ-understructure-v15.scad -- no changes at all" and its
// Section 12.5 only lists bumping the base file and chambers to v23 --
// it does not mention this file. But BBQ-understructure-v15.scad's own
// `include` line points directly at BBQ-chambers-v22.scad (confirmed via
// grep) -- if BBQ-offset-smoker-base-v6.scad included v15 unchanged, the
// real render chain would still pull in v22 (stub intact), and v23 would
// never actually enter the assembly -- the SAME "two disconnected valid
// pieces, never merged" failure class this project's own history
// (bbq-base-chain-recalibration, 2026-07-22) already found and fixed
// once. Resolution: v15 itself is NOT edited (kept byte-identical, on
// record, exactly as the prompt requires) -- this is a NEW file, v16,
// using this project's own already-established "pure pointer-only bump"
// pattern (identical in kind to BBQ-understructure-v13.scad's own bump
// to chambers-v21, and to every base-v3/v4/v5 pointer bump). R-009 real
// consumed-datum check (grep, not assumed): every real chambers-file
// identifier this file actually references (DATUM_Y_CENTER,
// DATUM_Z_RIDGE, FIREBOX_H, FIREBOX_W, GRATE_Z, APEX_A_Z, chamber_L,
// chamber_W, chamber_floor_z, chamfer, firebox_floor_z, firebox_x0/x1,
// firebox_y0/y1, wall_t) has the IDENTICAL declaration line, byte-for-
// byte, in v23 as in v22 -- zero-consequence pointer bump, no fender/
// track-width/wheel position moves. BBQ-offset-smoker-base-v6.scad
// includes THIS file (v16), not v15, to keep the real chain connected.
//
// v15's own original header follows, UNCHANGED, kept as real history:
//
// BBQ Offset Smoker — Understructure
// Version: v15
// Date: 2026-07-22
// Source: BBQ-understructure-v14.scad
// Changes: prompts/bbq-rear-fender-arch-redesign-cc-prompt.md. Real
// profile redesign of `rear_fender()` -- NOT a linkage/datum change.
// Replaces the v10/v12 flat-rectangular-plate-with-10%-curve-down-zone
// cross-section with a real wheel-arch shape (flat roof + two straight
// sloped shoulders), solved directly from `WHEEL_R` via a real numeric
// bisection -- see rules-bbq-fab.md's new "Wheel-Radius-Derived Fender
// Arch Convention" (TASK 2) for the full, reusable, parametric
// derivation. The 300mm outward extension (world Y) and 1.5mm weld
// overlap are UNCHANGED, per this round's own explicit DO NOT TOUCH.
//
// MANDATORY FIRST CHECK, confirmed live: `WHEEL_R`=228.6mm,
// `REAR_AXLE_Z`=228.6mm (=WHEEL_R, world Z=0 convention). Old
// `rear_fender()` (v14, being replaced): `fender_slab()`-based flat
// plate at `fender_z`=472.2mm, 548.64mm long (X), with 15mm droop at
// each 54.864mm (10%) end via `hull()`.
//
// Step 1 real solve (bisection, 40 iterations over [5,45]deg, sign-based
// -- `fender_arch_gap()` confirmed monotonically increasing over this
// range via echo before implementing): FENDER_ARCH_THETA converges to
// 24.3358deg at WHEEL_R=228.6mm -- SELF-CHECK CONFIRMED against the
// prompt's own expected theta~=24.3deg before proceeding.
// Step 2 real computed values at the current live WHEEL_R (confirmed
// via echo): roof_z=328.6mm, roof_half_w=148.616mm, R_tip=360.645mm,
// arch_end_x=203.419mm, arch_end_z=297.801mm.
//
// TASK 1 real construction: ONE closed 2D polygon (top arch path +
// the same path shifted -FENDER_T in Z, a real, stated uniform-vertical-
// thickness simplification -- not a true perpendicular offset, flagged),
// extruded along world Y via `linear_extrude()` + `rotate([-90,0,0])`
// (this file's own established Y-extrusion idiom, see
// `rear_axle_line()`) -- a PLAIN extrusion, no `hull()`-loft needed since
// the cross-section is now uniform along the whole 300mm reach (verified
// visually via a local render prototype before writing this into the
// shipped file, per SKILL_local_render.md discipline).
//
// REAL, FLAGGED FINDING -- the true minimum clearance's own real
// LOCATION does not match this prompt's own stated expectation ("expect
// real margin near the A/B slope ends"): a live CGAL bisection (radius-
// scanned test cylinder at the wheel's own real position, margin swept
// from 0 to 100mm in the fender vs tire probe) found the TRUE global
// minimum clearance is EXACTLY 96.0mm (95.9mm confirmed EMPTY, 96.0mm
// confirmed real contact) -- and it occurs at the FLAT ROOF's own
// UNDERSIDE center (X=0, directly above the wheel's own real top point),
// NOT near the shoulder ends. Real explanation, confirmed via direct
// computation: the roof's TOP surface sits at
// FENDER_ARCH_TOP_CLEARANCE(100mm) above the wheel's own top by
// construction, but the panel's own real thickness (FENDER_T=4mm) means
// the roof's UNDERSIDE (the surface that actually faces the tire) sits
// 4mm closer -- real margin = 100-4 = 96mm exactly, confirmed via CGAL,
// not assumed from the nominal clearance constant alone. The shoulders
// (built at R_tip=360.645mm radius from wheel center, well beyond the
// roof's own 328.6mm) carry FAR more real clearance than the roof center
// -- the solve/build-swing relationship (theta vs theta+10deg) governs a
// DIFFERENT real quantity (how far the shoulder's own endpoint pulls back
// from the wheel's vertical tangent line X=WHEEL_R, a real 25.181mm
// X-position margin, confirmed via `WHEEL_R(228.6) -
// arch_end_x(203.419)`) -- a real, legitimate, SEPARATE number, not the
// same thing as the profile's own overall closest-approach margin. Both
// numbers are real and stated explicitly, not conflated.
//
// v14 kept unchanged, on record (BBQ-understructure-v14.scad).
//
// v14's own original header follows, UNCHANGED, kept as real history:
//
// BBQ Offset Smoker — Understructure
// Version: v14
// Date: 2026-07-22
// Source: BBQ-understructure-v13.scad
// Changes: prompts/bbq-understructure-level-drop-companion-cc-prompt.md.
// Companion round to bbq-chambers-grate-master-datum-restore-and-level-
// drop (BBQ-chambers-v22.scad) -- the chamber+firebox assembly dropped a
// real -100mm in world Z (grate 1000->900, apex A 950->850, restored
// master-datum chain). `include` bumped BBQ-chambers-v21.scad ->
// BBQ-chambers-v22.scad.
//
// MANDATORY FIRST CHECK: confirmed BBQ-chambers-v22.scad real, its own
// live GRATE_Z/APEX_A_Z = 900/850 (confirmed via echo). Real current
// pole/T-bar formulas, confirmed via grep -- ALL already live formulas,
// zero hardcoded literals found: `REAR_BRACKET_H = firebox_floor_z -
// REAR_AXLE_Z`, `LEG_DROP = chamber_floor_z - firebox_floor_z`,
// `CASTER_PLATE_BOTTOM_Z` (derived from chamber_floor_z/LEG_DROP),
// `FRONT_SPACER_LEN = CASTER_PLATE_BOTTOM_Z - FRONT_AXLE_Z`, `TBAR_LEN =
// DATUM_Z_RIDGE - WHEEL_R - TBAR_BRACKET_THICKNESS`.
//
// TASK 1 -- confirmed via live echo, wheels/axles fixed to true ground
// Z=0 as designed (REAR_AXLE_Z/FRONT_AXLE_Z=228.6, UNCHANGED,
// independent of the chamber): REAR_BRACKET_H 191.4->91.4mm (-100, real
// rear strut/beam height shrinks), FRONT_SPACER_LEN 185.4->85.4mm (-100,
// real front swivel-caster post shrinks), TBAR_LEN 1102.735->1002.735mm
// (-100, real T-bar upright shrinks) -- all THREE support members absorb
// the full 100mm, confirmed via live measurement not assumed from the
// formula chain alone. REAL, STATED FINDING (not silently absorbed):
// `LEG_DROP` itself stays UNCHANGED (351.335mm, identical to v13) --
// this is CORRECT, not a missed consumer: `LEG_DROP` measures the
// vertical span between `chamber_floor_z` and `firebox_floor_z`, and
// BOTH of those drop by the identical -100mm together, so their own
// real difference (the front bracket LEG's own physical length) is
// invariant -- the leg itself doesn't shrink, it simply sits 100mm
// lower as a rigid unit (confirmed via the same live echo). Real
// mount-point CGAL contact checks (NOT assumed from the formula chain):
// `front_bracket()` vs `chamber_shell()` NON-EMPTY (94 real facets, the
// leg's own top edge genuinely flush against the chamber's real octagon
// material at the new elevation); `rear_axle_bracket()` (struts/beam)
// vs `firebox()` NON-EMPTY (378 real facets, genuine weld contact at
// the new firebox position). Full standalone render Simple:yes (4317
// facets, 6 volumes -- identical counts to v13, confirming a pure rigid
// re-position, zero shape change).
// REAL, INCIDENTAL FINDING (flagged in the companion chambers round,
// resolved here without any code change): this file's own
// `GRATE_HEIGHT_ABOVE_GROUND = GRATE_Z` (declared at line ~354, zero
// real consumers of its own, confirmed dead via grep) previously read a
// chambers-file `GRATE_Z` that actually meant apex A (950mm, a real
// mislabeling) -- BBQ-chambers-v22.scad's own TASK 1 rename means this
// SAME unmodified line now correctly reads the real grate height above
// ground (900mm, confirmed via echo) -- a genuine accidental correction,
// not a fix applied here, stated for the record since this file itself
// was not edited to cause it.
//
// TASK 2 -- fender Z position and its 15mm-above-tire formula
// (`fender_z = REAR_AXLE_Z + WHEEL_R + FENDER_DROP` = 472.2mm) left
// completely UNCHANGED, per Janis's own confirmed clearance-priority
// decision -- neither the fender nor the wheels moved. Real live CGAL
// checks, each with its specific probe: fender vs `outer_shell()` (the
// firebox, now 100mm lower, real Z-range [320,900] was [420,1000]) --
// NON-EMPTY (378 real facets), genuine weld contact PRESERVED at the new
// relative position (real margin INCREASED, not decreased: the fender's
// own Z=472.2mm now sits 152.2mm above the shell's new bottom edge, was
// 52.2mm above the old one -- the shell extended further down, not
// away from the fender). Fender vs tire: EMPTY, real bisected margin
// re-confirmed EXACTLY 15mm (14.9mm lift clean, 15.0mm exact tangency/
// non-manifold, 15.1mm real overlap -- byte-identical result to the
// original fender round). Fender vs rear axle/struts: EMPTY.
//
// v13 kept unchanged, on record (BBQ-understructure-v13.scad). Companion
// round: BBQ-chambers-v22.scad (chamber/firebox -100mm drop, see that
// file's own header for the full real datum-restore derivation).
//
// v13's own original header follows, UNCHANGED, kept as real history:
//
// BBQ Offset Smoker — Understructure
// Version: v13
// Date: 2026-07-22
// Source: BBQ-understructure-v12.scad
// Changes: prompts/bbq-base-chain-recalibration-cc-prompt.md, TASK 1.
// PURE POINTER-ONLY BUMP -- zero understructure geometry changed this
// round. `include` bumped BBQ-chambers-v20.scad -> BBQ-chambers-v21.scad
// (that round's own real fix: lid/fixed parting line shifted +50mm on the
// Y=0 side; new fixed band at world Z=[950,1000], hinge mount Z=980mm --
// see BBQ-chambers-v21.scad's own header for full detail). This fixes a
// real linkage gap left by PR #143: understructure-v12 never had its own
// include bumped past v20, so the full assembly chain (base-v1 ->
// understructure -> chambers) never actually rendered v21's real fixed-
// band/parting-line-shift geometry -- base-v2 worked around this by
// including chambers-v21 DIRECTLY (bypassing understructure/wheels
// entirely), which is the separate defect this same round's TASK 2 fixes.
//
// R-009 real consumed-datum check, confirmed via grep (not assumed from
// v21's own header claim alone): every real chambers-file identifier this
// file actually references -- DATUM_Y_CENTER, DATUM_Z_RIDGE, FIREBOX_H,
// FIREBOX_W, GRATE_Z, chamber_L, chamber_W, chamber_floor_z, chamfer,
// firebox_floor_z, firebox_x0, firebox_x1, firebox_y0, firebox_y1, wall_t
// -- has the IDENTICAL real value/formula in v21 as in v20 (byte-for-byte
// diff of each declaration line, not just a value spot-check). Confirms
// this really is a zero-consequence pointer bump for this file's own
// geometry -- no fender/track-width/wheel position moves.
//
// v12's own original header follows, UNCHANGED, kept as real history:
//
// MANDATORY FIRST CHECK, real live values confirmed before writing any
// code (per R-014, stated not assumed): FIREBOX_W=580mm ✓ (expected),
// WHEEL_D/WHEEL_R=457.2/228.6mm ✓, TREAD_W=200mm ✓,
// TRACK_WIDTH_FIREBOX_GAP=100mm ✓ (about to change per TASK 3),
// `prep_shelf()`/`prep_shelves()`'s real current callers: exactly ONE
// each -- `prep_shelves()` is called only from this file's own ASSEMBLY
// line (`if (show_shelves) ... prep_shelves(shelf_deployed)`), and
// `prep_shelf()` is called only from within `prep_shelves()` itself (2x).
// `tray_mount_bracket()` is called only from `tray_mount_brackets()`,
// which is called only from `prep_shelves()`. Zero external consumers of
// any of the four confirmed via grep across this file (the only file that
// defines them) -- clean to remove entirely.
//
// TASK 1 -- PREP TRAY REMOVED ENTIRELY (relocating to a separate
// accessories file in the bbq-chamber-parting-shift-and-tray-init round,
// NOT this prompt's job to build the replacement). Modules deleted:
// `prep_shelf()`, `prep_shelves()`, `tray_mount_bracket()`,
// `tray_mount_brackets()`. R-009 real check on the 4 named constants
// (CASTER_CLEARANCE/LEG_INSET/SHELF_D/SHELF_T), confirmed via grep across
// this file, not assumed from the v11 header's own claim:
//   - SHELF_D, SHELF_T: each had exactly ONE real consumer, `prep_shelf()`'s
//     own `cube([SHELF_L, SHELF_D, SHELF_T])` -- zero remaining callers
//     once the tray is gone. REMOVED.
//   - LEG_INSET: ONE real consumer, `TRAY_MOUNT_X = LEG_INSET` (itself
//     tray-exclusive) -- zero remaining callers. REMOVED.
//   - CASTER_CLEARANCE: REAL FINDING, flagged not silently absorbed -- the
//     v11 header's own inherited claim ("still real consumers via
//     prep_shelf(), DO NOT TOUCH") does NOT match this file's actual
//     content: `CASTER_CLEARANCE`'s only real consumer is `leg_h`
//     (`leg_h = chamber_floor_z - CASTER_CLEARANCE`), and `leg_h` ITSELF
//     already carried its own "unused elsewhere in this file (carried
//     over, not a new consumer)" comment BEFORE this round -- i.e.
//     `CASTER_CLEARANCE`/`leg_h` were already fully orphaned, unrelated to
//     the tray, the inherited claim was stale. Both REMOVED (R-009, zero
//     real callers, confirmed via grep, not a tray-removal side effect).
// Also removed (tray-exclusive, no separate ask needed): `TRAY_MOUNT_X`,
// `TRAY_MOUNT_Z`, `TRAY_BRACKET_W/H/T`, `TRAY_BRACKET_COUNT`, `SHELF_L`,
// `show_shelves`, `shelf_deployed`, and the ASSEMBLY line that called
// `prep_shelves()`.
// Toggle-Completeness recount (real, stated): 3 top-level ASSEMBLY-called
// modules remain in this file (`rear_axle()`, `rear_fenders()`,
// `front_wheel_support()`), ALL 3 toggled (was 4 modules/4 toggles,
// `show_shelves` removed with its module) -- 0 gaps.
//
// TASK 2 -- REAR FENDER REBUILT to Janis's own precise real spec (rear
// wheels ONLY -- confirmed explicitly below, no front fender exists or is
// added). v7-v11's wraparound-hood construction (`fender_wedge_2d()`/
// `fender_arc_2d()`/the old `rear_fender()`) RETIRED entirely -- a
// genuinely different real shape this round: a flat rectangular deck
// plate (300mm real outward extension from the firebox's own outer-shell
// wall, FIXED LITERAL per spec, NOT re-derived from a formula -- covers
// the new 50mm firebox-to-wheel gap (TASK 3) + 200mm tire width + 50mm
// real margin, confirmed via live Y-extent check below, not assumed),
// 548.64mm long (X, `WHEEL_D*1.2`, centered on `REAR_AXLE_X`), with the
// front/rear 10% (54.864mm each) tapering 15mm down via `hull()` between
// the flat-level cross-section and the dropped-level cross-section (same
// shape both ends, a straight prismatic taper -- no RULE 2 multi-step
// loft needed, per that rule's own "identical cross-sections" exception).
// Real live `fender_z` (flat mid-section underside) = REAR_AXLE_Z(228.6)
// + WHEEL_R(228.6) + 15 = 472.2mm, matches the prompt's own expected
// value exactly. `FENDER_WELD_OVERLAP`(1.5mm, UNCHANGED value from v7-v11)
// pushes the fender's inner edge 1.5mm into the firebox outer shell's own
// wall_t(3mm) material for genuine weld contact, not just a coincident
// face -- same real discipline as every prior fender round.
// Real hand-verified geometry (re-confirmed via live OpenSCAD CGAL probes
// below, not trusted from arithmetic alone, per R-008): the wheel's own
// tallest point (Z=457.2mm) sits at X=REAR_AXLE_X exactly, dead center of
// the fender's FLAT mid-section (which spans ±219.456mm from center,
// well inside the ±274.32mm total half-length) -- so the minimum real
// clearance (15mm, by construction) occurs under the flat section, not
// at the drooped ends where the wheel's own curvature has already fallen
// well below 457.2mm. Confirmed no front-wheel fender exists or was
// added -- `front_wheel_support()`/`tow_triangle()` (a real structural
// tow-hitch plate, not a fender) UNCHANGED.
//
// TASK 3 -- TRACK WIDTH RECOMPUTE. `TRACK_WIDTH_FIREBOX_GAP`: 100->50mm
// (Janis's own real spec update). Real live recompute:
// `TRACK_WIDTH = FIREBOX_W(580) + 2*50 + TREAD_W(200) = 880mm` (was
// 980mm), applied to BOTH front and rear via the SAME shared constant
// (UNCHANGED convention, every prior round). Real wheel Y-positions:
// `DATUM_Y_CENTER(305) ∓ TRACK_WIDTH/2(440) = -135mm / 745mm`, matches
// the prompt's own expected `∓440mm` exactly.
// REAL, RE-VERIFIED COLLISION CHECK (front-wheel vs front-bracket), NOT
// assumed resolved just because a prior round resolved it at a WIDER
// (980mm) track -- this round moves the wheels NARROWER (toward center,
// the opposite direction from the v5 fix that originally resolved this
// collision), a genuine re-risk, checked fresh via a real OpenSCAD CGAL
// `intersection()` probe (see cc_chat_log.md for the real, live result at
// this specific 880mm width, not carried forward from 980mm).
//
// v11 kept unchanged, on record (BBQ-understructure-v11.scad).
// BBQ-offset-smoker-base-v1.scad's own `include` updated v11->v12.
//
// v11's own original header follows, UNCHANGED, kept as real history:
//
// Changes: PURE POINTER BUMP ONLY -- zero understructure geometry changed
// this round. `include` bumped to BBQ-chambers-v19.scad (that round's own
// 2 real fixes: fire_cylinder_end_cap_2d() rebuilt via the Dual End-Cap
// Footprint Pattern to close a real remaining hole Janis found by looking
// inside the built cylinder -- same failure class as v16's original
// mistake, just never checked on this specific end cap until now; and
// ash_tray() RETIRED entirely per Janis's own explicit, direct
// instruction -- see BBQ-chambers-v19.scad's own header for full detail).
// None of this file's own real consumed datums changed value.
//
// v9's own original header follows, UNCHANGED, kept as real history:
//
// Changes: PURE POINTER BUMP ONLY -- v8's own real fix (prep_shelves()
// mirror() bug, see that fix's own inline comment further down, kept
// UNCHANGED this round) already shipped; this version exists solely to
// bump the `include` to BBQ-chambers-v18.scad (that round's own real fix:
// outer_shell_flange_footprint_2d() rebuilt to actually satisfy
// rules-bbq-fab.md's new Dual End-Cap Independence Convention Rule 1 --
// see BBQ-chambers-v18.scad's own header for the full detail). None of
// v18's own real datums that this file consumes (firebox_floor_z,
// FIREBOX_W, firebox_y0/y1, FLANGE_LEN) changed value this round -- only
// the flange's own internal 2D construction changed, zero consequence for
// this file's own formulas, reconfirmed via grep not assumed.
//
// v7's own original header follows, UNCHANGED, kept as real history:
//
// Changes: Janis's own DIRECT feedback on v6 (not a new CC prompt round).
// Pointer bumped to BBQ-chambers-v16.scad (this same round's real firebox
// fixes -- FLANGE_LEN 20->50mm, real passage/end-cap/flange rebuilds; none
// of v16's own real datums that this file consumes (firebox_floor_z,
// FIREBOX_W, firebox_y0/y1) changed value, only FLANGE_LEN did, and this
// file has zero FLANGE_LEN consumers -- reconfirmed via grep, not assumed).
//
// v7 TASK — REAR FENDER REBUILT AGAIN (Janis: "The fender or mudguard is
// wrong shape - see image", after v6's own full rebuild was ALSO wrong).
// Real root cause, found this round by going back to the ORIGINAL v5
// prompt's own written spec (prompts/archive/bbq-understructure-v5-...md),
// not by re-guessing from a screenshot description alone: "flat steel
// panel, welded to the firebox's own OUTER SHELL, straight off the firebox
// side (viewed from the back), curving down after clearing the wheel's
// outer edge, ~150mm gap above the wheel." That is a FLAT plate over MOST
// of the run (from the firebox wall out to above the wheel), curving down
// ONLY at the outboard end -- v5 built roughly that but with too long/flat
// a run (Janis's own v6-round complaint); v6 overcorrected into a FULL
// semicircular arc starting almost immediately at the firebox wall (zero
// real flat run) -- neither matches the spec's own literal words. FIX:
// rebuilt with a real flat plate from the firebox wall to DIRECTLY ABOVE
// the wheel's own center (the one point where a flat plane is geometrically
// TANGENT to the curve, so the two pieces meet without a kink -- not a
// judgment call, forced by the tangent-continuity requirement), then a
// curved flare from that point down past the wheel's own outboard tangent
// edge (UNCHANGED FENDER_ARC_PAST_EDGE=25deg convention). Real, live
// tangent height: REAR_AXLE_Z + FENDER_R_IN = 228.6+378.6 = 607.2mm --
// matches the spec's own "~150mm gap above the wheel" read as clearance
// above the wheel's OWN TOP point (150mm radial gap + WHEEL_R = vertical
// gap above the tire's topmost point when directly overhead), not a
// coincidence -- confirms this reading of the spec is internally
// consistent, not an arbitrary re-interpretation.
//
// MANDATORY FIRST CHECK (both real things, per prompt, done before writing
// any code below):
// 1. BBQ-chambers-v15.scad — real, live, present in this session's own
//    working tree (built and real-CGAL-verified earlier in THIS session;
//    PR not yet merged on GitHub at the time of this round, but the file
//    itself is real and verified — proceeding on that basis, per explicit
//    instruction to do both rounds in sequence). Real live values
//    reconfirmed via echo: firebox_floor_z=420mm ✓ (matches expected),
//    FIREBOX_H=580mm ✓, FIREBOX_W=580mm (unchanged) ✓, chamber_floor_z=
//    771.335mm (unchanged) ✓. REAL DISCREPANCY FLAGGED, not silently
//    reconciled: cylinder diameter is actually 456mm (CYL_D, built exactly
//    per v15's own explicit "580-2×62=456mm" spec, real-CGAL-verified) —
//    NOT the ≈489.3mm this prompt's own preamble estimated. Since the
//    other 3 values match exactly and v15's own file is unambiguous about
//    its real 456mm construction, this is Claude Web's own pre-estimate
//    being off (not a real problem with v15), not a reason to stop.
// 2. BBQ-understructure-v5.scad's real current state — confirmed live
//    (this same session wrote and merged it): `include` points at
//    BBQ-chambers-v14.2.scad, TRACK_WIDTH=1080mm (TRACK_WIDTH_FIREBOX_GAP=
//    150mm/side), front bracket tip already round (150mm dia hull()),
//    T-bar default already 90deg (fixed last round). v5 IS real, committed,
//    and merged (PR #135) — this round starts from its own real content,
//    not from the v5 prompt's original intent re-interpreted.
//
// TASK 0 — POINTER BUMP: v14.2 -> v15.
// Real effect: chamber_floor_z/chamfer/chamber_W all UNCHANGED by v15
// (chamber body itself untouched) — front_bracket_leg()'s own flush-fit
// against true_octagon_profile() is therefore a re-CONFIRMATION, not a
// rebuild (re-verified live via CGAL below, not assumed still true just
// because the datum didn't move). Real effect that DOES change: LEG_DROP/
// REAR_BRACKET_H/CASTER_PLATE_BOTTOM_Z/FRONT_SPACER_LEN all recompute
// AUTOMATICALLY via their own existing live formulas (chamber_floor_z-
// firebox_floor_z / firebox_floor_z-REAR_AXLE_Z etc.) the instant this
// pointer moves — zero additional code change needed for TASK 4/5 below,
// confirmed via echo not assumed (see those tasks).
//
// TASK 1 — PREP SHELF: MULTI-POINT FLUSH MOUNT.
// Real finding (Janis's live review): `prep_shelf()`'s own kinematic
// rotation was ALREADY correct (rotate([deg,0,0]) about the X-axis is
// already a rotation around the real hinge LINE at [apex_y,TRAY_MOUNT_Z],
// not just a point — true for every X value along the shelf). The real
// problem is PHYSICAL SUPPORT: only ONE `tray_mount_bracket()` existed
// near the shelf's own near end (X=30) while the shelf itself spans
// chamber_L*0.35≈320mm — a real ~290mm cantilevered, unsupported far end.
// FIX: `tray_mount_bracket()` now takes an X position, called
// TRAY_BRACKET_COUNT(3, real judgment call, flagged) times, evenly spread
// across the shelf's own real X span (30mm / ~193mm / ~356mm) — same
// hinge LINE, now with real distributed weld support along it, so it
// sits level/flush when folded down instead of drooping under its own
// cantilever.
//
// TASK 2 — TRACK WIDTH: RECOMPUTE FOR 100mm WHEEL-TO-FIREBOX GAP.
// TRACK_WIDTH_FIREBOX_GAP: 150mm -> 100mm (real spec change from Janis —
// firebox is insulated, wheel can sit closer). Real live recompute:
// TRACK_WIDTH = FIREBOX_W(580)+2*100+TREAD_W(200) = 980mm (was 1080mm),
// applied to both front AND rear via the SAME shared constant, unchanged
// convention from v5's own TASK 1.
//
// TASK 3 — FENDER: REBUILT AS A SHORT FLARED WING.
// Real finding (Janis's live review vs Taylor Made Custom Fabrication
// reference photos): v5's own fender read as "a long straight panel" —
// real cause, found via direct computation, not assumed: the FLAT
// mounting portion spanned the ENTIRE distance from the firebox's own
// wall all the way to the wheel's own vertical centerline (250mm flat
// run under v5) before the curve even began. FIX: the flat portion is now
// a real, SHORT weld tab only (FENDER_WELD_OVERLAP, unchanged 1.5mm real
// overlap into the firebox wall) — the arc itself now starts almost
// immediately, at the REAL angle where the arc's own inner radius
// (FENDER_R_IN, unchanged 378.6mm/150mm gap spec) naturally reaches the
// firebox's own wall Y-position (a_start = acos(d/FENDER_R_IN), where d
// is the real signed Y-distance from the wheel's own center to the
// firebox edge — live-computed, not hardcoded, works symmetrically for
// both sides via acos()'s own [0,180] range). Real live values (TASK 2's
// new 980mm track): d=200mm both sides (symmetric), a_start=58.11°(left)/
// 121.89°(right) — real arc sweep now ~147° (was 115° under v5), i.e.
// MORE of the panel is real curve hugging the tire, MUCH LESS is flat
// panel — matches "short flared wing" directly, not by shrinking FENDER_W
// (the X/rolling-direction length, already reasonably short at 240mm
// under v5 and left unchanged) but by fixing the real flat-vs-arc balance
// in the Y-Z cross-section, which is what actually read as "long."
//
// TASK 4 — REAR AXLE/STRUT: RECOMPUTE FOR NEW firebox_floor_z(420mm).
// REAR_BRACKET_H = firebox_floor_z(420, v15) - REAR_AXLE_Z(228.6,
// UNCHANGED) = 191.4mm (was 342.8mm) — real, live, automatic consequence
// of TASK 0's pointer bump alone (formula itself untouched, R-009).
// rear_strut()'s own real height (unchanged construction/code, DO NOT
// TOUCH) recomputes to match automatically (197.4mm incl. weld overlap,
// was 347.8mm) — confirmed via echo below, not assumed. Axle center
// still = WHEEL_R above ground (world Z=0 anchor, UNCHANGED convention).
//
// TASK 5 — FRONT U-BRACKET DROP LENGTH: RECOMPUTE FOR firebox_floor_z(420).
// LEG_DROP = chamber_floor_z(771.335, UNCHANGED) - firebox_floor_z(420,
// v15) = 351.335mm (was 199.935mm) — real, live, automatic consequence of
// TASK 0's pointer bump alone (formula itself untouched from v5, R-009).
// Bracket leg's own bottom edge still lands EXACTLY at world
// Z=firebox_floor_z (420mm, confirmed via echo: chamber_floor_z-LEG_DROP=
// 420 exact). Flush-fit at the TOP edge (h=MID_H, unaffected by LEG_DROP)
// re-verified live via CGAL (TASK 0, unchanged datum, real confirmation).
//
// TASK 6 — T-BAR BRACKET: MOUNT AT AXLE PLANE, NOT FLOATING ABOVE IT.
// Real finding (Janis's annotated screenshot): `tow_triangle()` sat at
// TRIANGLE_Z=FRONT_AXLE_Z+100 (floating 100mm above the front axle's own
// real plane, a v3-era carryover never revisited). FIX: TRIANGLE_Z =
// FRONT_AXLE_Z directly (real, was +100) — the triangle plate now sits
// coplanar with `front_stub_axle()`'s own real Z, genuine weld-plane
// contact instead of floating. NEW `tow_bracket_gusset()`: a real curved
// fillet (GUSSET_R=30mm, judgment call, flagged — no reference photo
// directly available to this session, per Janis's own annotation
// description) bridging the flat triangle plate's own underside to the
// round stub axle's own surface at their shared mounting point
// (CASTER_X, DATUM_Y_CENTER, FRONT_AXLE_Z) via `hull()` of two spheres —
// a smooth structural curve, not the sharp right-angle joint the two
// parts would otherwise meet at now they're coplanar. Real CGAL: genuine
// volume overlap vs both the triangle plate and the stub axle, confirmed
// (not just a touching face).
//
// TASK 7 — T-BAR LENGTH: RE-VERIFIED, UNAFFECTED.
// TBAR_LEN = DATUM_Z_RIDGE(1381.335, UNCHANGED — v15 does not touch the
// chamber body) - WHEEL_R(228.6, UNCHANGED) - TBAR_BRACKET_THICKNESS(50,
// UNCHANGED literal) = 1102.735mm — real, live-recomputed, IDENTICAL to
// v5's own value (confirmed via echo, not assumed just because nothing
// looked different). REAL, FLAGGED CONSEQUENCE OF TASK 6, NOT SILENTLY
// ABSORBED: since TRIANGLE_Z is now FRONT_AXLE_Z (228.6, was 328.6), the
// T-bar's own real tip Z at the 90deg default is now TRIANGLE_Z+TBAR_LEN
// = 228.6+1102.735 = 1331.335mm — 50mm BELOW DATUM_Z_RIDGE(1381.335mm)
// this time (was 50mm ABOVE under v5) — TASK 6's own real fitment fix
// happens to also resolve v5's own flagged roof-clearance variance as a
// side effect, confirmed via echo, not the goal of TASK 6 but a real
// welcome consequence.
//
// TASK 8 — REAL COLLISION RE-CHECK (both old defects, at the new,
// further-changed geometry — NOT assumed resolved because the numbers
// moved in the right direction).
// Front wheels vs front_bracket()/front_caster_plate()/tow_triangle():
// real CGAL `intersection()` probe at TASK 2's new 980mm track width +
// TASK 5's new 351.335mm LEG_DROP + TASK 6's new TRIANGLE_Z — confirmed
// EMPTY, see cc_chat_log.md for the real result (not assumed from v5's
// own prior resolution carrying forward unchanged).
//
// v5 kept unchanged, on record (BBQ-understructure-v5.scad).
// BBQ-offset-smoker-base-v1.scad's own `include` updated v5->v6.
//
// SKELETON — Parent: BBQ-chambers-v15.scad's own DATUM_*/chamber_*/
// firebox_* constants, read directly (R-009 pattern). Local origin still
// MASTER ORIGIN (0,0,0 at floor, front-left), real-CGAL-confirmed to
// coincide with the wheel's own ground-contact point (unchanged since v4).

include <BBQ-chambers-v23.scad>

// ───────────────────────────────
// PARAMETERS — carried over from v4, UNCHANGED formulas (real values move
// automatically with chamber_floor_z's new v14.2 value).
// v12 TASK 1: CASTER_CLEARANCE/LEG_INSET/SHELF_D/SHELF_T REMOVED (R-009,
// zero remaining real callers, see file header) -- `leg_h` removed with
// CASTER_CLEARANCE (its only real consumer had already fallen to zero,
// unrelated to the tray, see header finding).
// ───────────────────────────────

// ═══════════════════════════════════════════════════════════════════
// TASK 1 — SHARED TRACK WIDTH. Single source, both front and rear.
// ═══════════════════════════════════════════════════════════════════
WHEEL_D = 457.2;   // 18" -- UNCHANGED, locked since v4
WHEEL_R = 228.6;
TREAD_W = 200;      // this file's real name for the prompt's "TIRE_W"

TRACK_WIDTH_FIREBOX_GAP = 50;   // TASK 3, v12: 100->50mm (Janis's own real spec update)
TRACK_WIDTH = FIREBOX_W + 2*TRACK_WIDTH_FIREBOX_GAP + TREAD_W;   // 880mm (v12, was 980mm) -- shared, front AND rear

// REAR_AXLE_Z -- UNCHANGED from v4/v5 (direct construction, wheel bottom = world Z=0)
REAR_AXLE_Z         = WHEEL_R;                                 // 228.6mm
GRATE_HEIGHT_ABOVE_GROUND = GRATE_Z;                            // 950mm (unchanged, chamber body untouched by v15) -- direct, world Z=0 is ground

// REAR_AXLE_X -- formula UNCHANGED, but real value SHIFTS this round:
// v15's own firebox_x0 stayed pinned (913.5, unchanged) but firebox_x1
// grew to 1493.5 (was 1373.5, TASK 2 of the v15 round) -- real, flagged,
// automatic consequence, not silently absorbed: midpoint moves +60mm
// (1143.5 -> 1203.5).
REAR_AXLE_X         = (firebox_x0 + firebox_x1) / 2;            // 1203.5mm (v6, was 1143.5mm)
REAR_WHEEL_Y_LEFT   = DATUM_Y_CENTER - TRACK_WIDTH/2;           // -185mm (v6, was -235mm) -- TASK 2, real 100mm gap to firebox edge (file header)
REAR_WHEEL_Y_RIGHT  = DATUM_Y_CENTER + TRACK_WIDTH/2;           // 795mm (v6, was 845mm)
REAR_BRACKET_H      = firebox_floor_z - REAR_AXLE_Z;            // 420-228.6=191.4mm (v6, was 342.8mm) -- TASK 4, automatic via v15's new firebox_floor_z

FRONT_AXLE_Z = REAR_AXLE_Z;   // 228.6 -- SAME shared anchor, keeps the vehicle stance level; front wheel bottom = 0mm, confirmed

// ───────────────────────────────
// Rear strut/beam -- construction UNCHANGED (DO NOT TOUCH). Real strut
// HEIGHT shortens automatically (TASK 4, ~197.4mm incl. weld overlap, was
// ~347.8mm) via firebox_floor_z's own new v15 value; real spacer LENGTHS
// change automatically too from the new REAR_WHEEL_Y_LEFT/RIGHT (TASK 2's
// narrower 980mm track) -- both flagged, not silently absorbed, real
// values stated live via echo, see cc_chat_log.md.
// ───────────────────────────────
REAR_STRUT          = 40;
REAR_STRUT_Y_OFFSET = 150;      // struts at Y=[155,455] -- UNCHANGED v4, DO NOT TOUCH
REAR_WELD_OVERLAP   = 3;

module rear_strut(y) {
    translate([REAR_AXLE_X - REAR_STRUT/2, y - REAR_STRUT/2, REAR_AXLE_Z - REAR_WELD_OVERLAP])
        cube([REAR_STRUT, REAR_STRUT, (firebox_floor_z + REAR_WELD_OVERLAP) - (REAR_AXLE_Z - REAR_WELD_OVERLAP)]);
}
module rear_struts() {
    rear_strut(DATUM_Y_CENTER - REAR_STRUT_Y_OFFSET);   // 155
    rear_strut(DATUM_Y_CENTER + REAR_STRUT_Y_OFFSET);   // 455
}

// REAR SPACERS -- construction UNCHANGED from v4 (DO NOT TOUCH), values
// recompute automatically from the new REAR_WHEEL_Y_LEFT/RIGHT above.
REAR_BEAM_D = 50;
REAR_SPACER_OVERLAP = 3;
module rear_axle_line(y0, y1) {
    translate([REAR_AXLE_X, y0, REAR_AXLE_Z]) rotate([-90, 0, 0])
        cylinder(d = REAR_BEAM_D, h = y1 - y0);
}
module rear_center_beam() {
    rear_axle_line(DATUM_Y_CENTER - REAR_STRUT_Y_OFFSET - REAR_SPACER_OVERLAP,
                    DATUM_Y_CENTER + REAR_STRUT_Y_OFFSET + REAR_SPACER_OVERLAP);
}
module rear_spacers() {
    rear_axle_line(REAR_WHEEL_Y_LEFT, DATUM_Y_CENTER - REAR_STRUT_Y_OFFSET + REAR_SPACER_OVERLAP);
    rear_axle_line(DATUM_Y_CENTER + REAR_STRUT_Y_OFFSET - REAR_SPACER_OVERLAP, REAR_WHEEL_Y_RIGHT);
}
module rear_axle_bracket() {
    rear_struts();
    rear_center_beam();
    rear_spacers();
}
module rear_wheel(y) {
    translate([REAR_AXLE_X, y - TREAD_W/2, REAR_AXLE_Z]) rotate([-90, 0, 0])
        cylinder(d = WHEEL_D, h = TREAD_W);
}
module rear_wheels() {
    rear_wheel(REAR_WHEEL_Y_LEFT);
    rear_wheel(REAR_WHEEL_Y_RIGHT);
}
module rear_axle() {
    color("#AAAAAA", 1.0) rear_axle_bracket();
    color("#333333", 1.0) rear_wheels();
}

// ═══════════════════════════════════════════════════════════════════
// TASK 1 (v15) — REAR FENDER PROFILE REBUILT as a real wheel-arch shape
// (flat roof + two straight sloped shoulders), solved directly from
// WHEEL_R -- see rules-bbq-fab.md's new "Wheel-Radius-Derived Fender
// Arch Convention" for the full, reusable, parametric derivation this
// module implements. v10/v12's own flat-rectangular-plate-with-10%-
// curve-down-zone cross-section (fender_slab()/the old rear_fender(),
// hull()-lofted) RETIRED entirely (R-009) -- this is a genuine profile
// redesign, not a linkage/datum change. FENDER_Y_EXT(300mm, world Y,
// outward extension from the firebox shell)/FENDER_WELD_OVERLAP(1.5mm)
// UNCHANGED, per this round's own explicit DO NOT TOUCH.
// ═══════════════════════════════════════════════════════════════════
FENDER_Y_EXT     = 300;                          // real FIXED LITERAL per spec (covers 50mm firebox-wheel gap + 200mm tire + 50mm real margin, confirmed in the prior round), measured from the firebox outer shell's real side wall -- UNCHANGED this round
FENDER_T         = 4;                             // panel thickness -- judgment call, UNCHANGED from every prior fender round (not respecified this round)
FENDER_WELD_OVERLAP = 1.5;   // real overlap into firebox outer-shell wall_t(3mm) band -- UNCHANGED value from v7-v11, re-verified via CGAL below

// Fixed tuning constants (named top-level constants per the prompt's own
// instruction, not inline literals) -- see rules-bbq-fab.md's own named
// convention for the full real derivation/reasoning behind each.
FENDER_ARCH_TOP_CLEARANCE   = 100;   // mm, how far above wheel center the flat roof sits
FENDER_ARCH_SOLVE_SWING_DEG = 15;    // reference swing angle used ONLY to solve theta (Step 1) -- not the built angle
FENDER_ARCH_BUILD_SWING_DEG = 10;    // the REAL swing angle the A/B slopes are built at -- Janis's own confirmed working value, pulls the real edge back from the SOLVE_SWING tangent reference for margin

// Step 1 -- real numeric solve for the roof half-angle theta (bisection,
// no closed form, per the prompt's own explicit instruction). Real
// equation: (WHEEL_R+CLEARANCE)*sin(theta+SOLVE_SWING)/cos(theta) =
// WHEEL_R -- equivalent to "at the SOLVE_SWING angle, the arm's own real
// endpoint X-coordinate lands exactly on the wheel's own vertical tangent
// line X=WHEEL_R" (confirmed algebraically: the LHS's own
// R_tip*sin(theta+SOLVE_SWING) term, where R_tip=(WHEEL_R+CLEARANCE)/
// cos(theta), is exactly that endpoint's real X-coordinate). fender_arch_gap()
// is monotonically increasing in theta over the real search range
// (confirmed via echo before implementing: negative at theta=5, positive
// at theta=45), so a simple sign-based bisection converges reliably.
function fender_arch_gap(theta) =
    (WHEEL_R + FENDER_ARCH_TOP_CLEARANCE) * sin(theta + FENDER_ARCH_SOLVE_SWING_DEG) / cos(theta) - WHEEL_R;
function fender_arch_theta(lo=5, hi=45, iter=40) =
    iter == 0 ? (lo + hi) / 2 :
    (fender_arch_gap((lo + hi) / 2) < 0
        ? fender_arch_theta((lo + hi) / 2, hi, iter - 1)
        : fender_arch_theta(lo, (lo + hi) / 2, iter - 1));
// Real solved value, live-computed off WHEEL_R (not hardcoded) -- 40
// bisection iterations over a 40deg initial range converges to
// far better than 0.01deg (well beyond the prompt's own minimum
// requirement). SELF-CHECK, confirmed via echo before proceeding:
// at WHEEL_R=228.6mm this converges to 24.3358deg, matching the
// prompt's own expected theta~=24.3deg exactly.
FENDER_ARCH_THETA = fender_arch_theta();

// Step 2 -- construct the profile from the solved theta. Real live
// values at WHEEL_R=228.6mm, confirmed via echo: roof_z=328.6mm,
// roof_half_w=148.616mm, R_tip=360.645mm, arch_end_x=203.419mm,
// arch_end_z=297.801mm. Real margin this proves (Step 1's own solved
// reference, not yet the CGAL-confirmed final number -- see TASK 1's
// mandatory checks below for the authoritative live-measured value):
// WHEEL_R(228.6) - arch_end_x(203.419) = 25.181mm, the built A/B slope's
// own endpoint sits this far inside the wheel's own vertical tangent
// line, a direct, real consequence of BUILD_SWING(10deg) < SOLVE_SWING
// (15deg).
fender_arch_roof_z      = WHEEL_R + FENDER_ARCH_TOP_CLEARANCE;                              // 328.6mm
fender_arch_roof_half_w = fender_arch_roof_z * tan(FENDER_ARCH_THETA);                       // 148.616mm
fender_arch_R_tip       = fender_arch_roof_z / cos(FENDER_ARCH_THETA);                       // 360.645mm
fender_arch_end_x       = fender_arch_R_tip * sin(FENDER_ARCH_THETA + FENDER_ARCH_BUILD_SWING_DEG);   // 203.419mm
fender_arch_end_z       = fender_arch_R_tip * cos(FENDER_ARCH_THETA + FENDER_ARCH_BUILD_SWING_DEG);   // 297.801mm

// fender_arch_profile() -- the real C/A/B profile (Zone C: flat roof;
// Zone A/B: straight sloped shoulders), relative to the wheel's own
// center (0,0 = REAR_AXLE_X, REAR_AXLE_Z locally). Built as ONE closed
// 2D polygon: the top surface path (shoulder-end -> roof-tip -> roof-tip
// -> shoulder-end) then the SAME path shifted down by FENDER_T (uniform
// vertical thickness -- a real, stated simplification, consistent with
// this project's own general sheet-metal representation convention;
// NOT a true perpendicular offset, so the sloped shoulders read a hair
// thicker measured perpendicular-to-slope than FENDER_T nominally,
// flagged not silently absorbed). `fpt()` pre-negates the Z coordinate
// so that, combined with `rotate([-90,0,0])` below (this project's own
// established Y-extrusion idiom, see rear_axle_line()), the final world
// Z comes out with the correct sign -- confirmed via a real local render
// prototype before writing this into the shipped file (per
// SKILL_local_render.md discipline).
function fpt(x, z) = [x, -z];
module fender_arch_profile() {
    polygon(points=[
        fpt(-fender_arch_end_x, fender_arch_end_z),
        fpt(-fender_arch_roof_half_w, fender_arch_roof_z),
        fpt(fender_arch_roof_half_w, fender_arch_roof_z),
        fpt(fender_arch_end_x, fender_arch_end_z),
        fpt(fender_arch_end_x, fender_arch_end_z - FENDER_T),
        fpt(fender_arch_roof_half_w, fender_arch_roof_z - FENDER_T),
        fpt(-fender_arch_roof_half_w, fender_arch_roof_z - FENDER_T),
        fpt(-fender_arch_end_x, fender_arch_end_z - FENDER_T),
    ]);
}
// rear_fender() -- v15 REBUILT profile (see above). wall_y = the firebox
// outer shell's real side-wall world-Y position nearest this wheel
// (firebox_y0 left / firebox_y1 right); outward_sign: -1 left (extends
// toward -Y), +1 right (extends toward +Y). weld_wall_y is pushed
// FENDER_WELD_OVERLAP into the firebox's own real wall_t(3mm) material for
// genuine weld contact (not a coincident face, UNCHANGED convention) --
// the profile itself is UNIFORM along the whole Y extrusion (a plain
// linear_extrude, not a hull()-loft -- the cross-section does not change
// shape along Y, only the flat-plate droop-zone design needed that
// technique).
module rear_fender(wall_y, outward_sign) {
    weld_wall_y = wall_y - outward_sign * FENDER_WELD_OVERLAP;
    y_far       = weld_wall_y + outward_sign * FENDER_Y_EXT;
    translate([REAR_AXLE_X, min(weld_wall_y, y_far), REAR_AXLE_Z])
        rotate([-90, 0, 0])
        linear_extrude(height = abs(y_far - weld_wall_y), convexity = 4)
            fender_arch_profile();
}
module rear_fenders() {
    rear_fender(firebox_y0, -1);
    rear_fender(firebox_y1, 1);
}

// ───────────────────────────────
// Front bracket -- MAIN SHAPE UNCHANGED (DO NOT TOUCH: MID_H/TOP_W/BOT_W,
// the 2-trapezoid-leg + bottom-plate construction). LEG_DROP's own
// FORMULA is UNCHANGED from v5 (TASK 5 this round: automatic real value
// recompute via v15's new firebox_floor_z, zero code change needed).
// ───────────────────────────────
MID_H   = chamfer / 2;                                    // 89.332mm -- UNCHANGED
TOP_W   = (chamber_W - 2*chamfer) + 2*MID_H;               // 431.335mm -- UNCHANGED
BOT_W   = chamber_W - 2*chamfer;                            // 252.670mm -- UNCHANGED
LEG_GAP  = 250;    // UNCHANGED
// LEG_DROP -- formula UNCHANGED from v5. TASK 5, v6: real value
// recomputes automatically via v15's new firebox_floor_z(420, was
// 571.4mm) -- confirmed via echo: chamber_floor_z-LEG_DROP =
// 771.335-351.335 = 420 exact, matches firebox_floor_z exactly.
LEG_DROP = chamber_floor_z - firebox_floor_z;    // 351.335mm (v6, was 199.935mm)
t        = 6;      // UNCHANGED
FRONT_X = 300;      // UNCHANGED

BOT_OVERLAP = 3;

module front_bracket_leg_profile() {
    polygon(points=[
        hex_pt(MID_H, DATUM_Y_CENTER - TOP_W/2),
        hex_pt(MID_H, DATUM_Y_CENTER + TOP_W/2),
        hex_pt(-LEG_DROP, DATUM_Y_CENTER + BOT_W/2),
        hex_pt(-LEG_DROP, DATUM_Y_CENTER - BOT_W/2),
    ]);
}
module front_bracket_leg(xc) {
    translate([xc - t/2, 0, chamber_floor_z]) rotate([0, 90, 0])
        linear_extrude(height = t, convexity = 4) front_bracket_leg_profile();
}
module front_bracket_bottom() {
    translate([FRONT_X - LEG_GAP, DATUM_Y_CENTER - BOT_W/2, (chamber_floor_z - LEG_DROP - t) + BOT_OVERLAP])
        cube([LEG_GAP, BOT_W, t]);
}
module front_bracket() {
    front_bracket_leg(FRONT_X);
    front_bracket_leg(FRONT_X - LEG_GAP);
    front_bracket_bottom();
}
// Fixed caster top-plate -- UNCHANGED position/size formula from v4, real
// Z value recomputes automatically via the new LEG_DROP.
CASTER_X          = FRONT_X - LEG_GAP/2;   // 175 -- UNCHANGED
CASTER_PLATE_SIZE = 100;
CASTER_PLATE_T    = 6;
CASTER_OVERLAP    = 3;
CASTER_PLATE_BOTTOM_Z = (((chamber_floor_z - LEG_DROP - t) + BOT_OVERLAP) + CASTER_OVERLAP) - CASTER_PLATE_T;   // 414mm (v6, was 565.4mm)
module front_caster_plate() {
    top_z = ((chamber_floor_z - LEG_DROP - t) + BOT_OVERLAP) + CASTER_OVERLAP;   // 420mm (v6, was 571.4mm)
    translate([CASTER_X - CASTER_PLATE_SIZE/2, DATUM_Y_CENTER - CASTER_PLATE_SIZE/2, top_z - CASTER_PLATE_T])
        cube([CASTER_PLATE_SIZE, CASTER_PLATE_SIZE, CASTER_PLATE_T]);
}

// FRONT SPACER -- construction UNCHANGED (DO NOT TOUCH). Real LENGTH
// recomputes automatically (TASK 5's own LEG_DROP change flows through
// CASTER_PLATE_BOTTOM_Z) -- real, stated, positive, confirmed via echo
// below. This IS the swivel fork/stem, rotates with steer_deg.
FRONT_SPACER_D = 40;
FRONT_SPACER_LEN = CASTER_PLATE_BOTTOM_Z - FRONT_AXLE_Z;   // 185.4mm (v6, was 336.8mm)
module front_spacer() {
    translate([CASTER_X, DATUM_Y_CENTER, FRONT_AXLE_Z])
        cylinder(d = FRONT_SPACER_D, h = FRONT_SPACER_LEN + e);
}
// front_stub_axle()/front_wheels() -- TASK 1/5: respan from the retired
// DUAL_WHEEL_OFFSET(110mm) to TRACK_WIDTH/2(540mm), same single-rigid-
// structure mechanism (UNCHANGED CODE PATTERN, only the span constant
// changes) -- re-verified via CGAL steer_deg sweep, see file header.
module front_stub_axle() {
    translate([CASTER_X, DATUM_Y_CENTER - TRACK_WIDTH/2 - TREAD_W/2, FRONT_AXLE_Z]) rotate([-90, 0, 0])
        cylinder(d = FRONT_SPACER_D, h = TRACK_WIDTH + TREAD_W);
}
module front_wheel(y) {
    translate([CASTER_X, y - TREAD_W/2, FRONT_AXLE_Z]) rotate([-90, 0, 0])
        cylinder(d = WHEEL_D, h = TREAD_W);
}
module front_wheels() {
    front_wheel(DATUM_Y_CENTER - TRACK_WIDTH/2);
    front_wheel(DATUM_Y_CENTER + TRACK_WIDTH/2);
}

// ═══════════════════════════════════════════════════════════════════
// TOW HANDLE / T-BAR -- TASK 2 (tip reshape, v5, unchanged) + TASK 6
// (v6: mount at axle plane + curved gusset) + TASK 7 (length re-verify).
// ═══════════════════════════════════════════════════════════════════
TRIANGLE_BASE_X  = CASTER_X + 25;    // 200 -- UNCHANGED
TRIANGLE_LENGTH  = 500;               // UNCHANGED
TRIANGLE_APEX_X  = TRIANGLE_BASE_X - TRIANGLE_LENGTH;   // -300 -- UNCHANGED, real forward reach preserved
TRIANGLE_BASE_W  = 200;
TRIANGLE_T       = 6;
// TRIANGLE_Z -- v6 TASK 6 REAL FIX: was FRONT_AXLE_Z+100 (floating above
// the axle's own real plane, a v3-era carryover, Janis's own finding).
// Now mounts directly AT the axle plane.
TRIANGLE_Z       = FRONT_AXLE_Z;   // 228.6mm (v6, was 328.6mm)

// TASK 2 -- round tip, UNCHANGED from v5. TIP_D=150mm, tip's forward-most
// extent held at the SAME TRIANGLE_APEX_X the old sharp point used.
TIP_D = 150;
TIP_R = TIP_D / 2;                                  // 75mm
TIP_CENTER_X = TRIANGLE_APEX_X + TIP_R;              // -225

HINGE_INSET = 20;
HINGE_X     = TRIANGLE_APEX_X + HINGE_INSET;   // -280 -- UNCHANGED formula

HANDLE_CROSSBAR_LEN = 300;   // UNCHANGED
HANDLE_CROSSBAR_D   = 25;
HANDLE_UPRIGHT_D    = 25;

// TASK 7 -- T-bar upright length, re-verified UNAFFECTED by this round
// (DATUM_Z_RIDGE/WHEEL_R both untouched by v15). See file header for the
// real, flagged consequence of TASK 6 on the roof-clearance question.
TBAR_BRACKET_THICKNESS = 50;   // UNCHANGED literal
TBAR_LEN = DATUM_Z_RIDGE - WHEEL_R - TBAR_BRACKET_THICKNESS;   // 1381.335-228.6-50 = 1102.735mm (IDENTICAL to v5)

module tow_triangle_profile() {
    hull() {
        translate([TIP_CENTER_X, DATUM_Y_CENTER]) circle(d = TIP_D);
        translate([TRIANGLE_BASE_X, DATUM_Y_CENTER - TRIANGLE_BASE_W/2]) circle(r = 0.01);
        translate([TRIANGLE_BASE_X, DATUM_Y_CENTER + TRIANGLE_BASE_W/2]) circle(r = 0.01);
    }
}
module tow_triangle() {
    translate([0, 0, TRIANGLE_Z]) linear_extrude(height = TRIANGLE_T, convexity = 2) tow_triangle_profile();
}
// tow_bracket_gusset() -- v6 TASK 6, NEW. Real curved fillet bridging the
// flat triangle plate's own underside to the round stub axle's own
// surface at their shared mounting point (CASTER_X, DATUM_Y_CENTER,
// FRONT_AXLE_Z) -- now that both sit at the SAME real Z plane (TASK 6's
// own fix), a smooth structural curve is needed instead of the sharp
// right-angle joint they'd otherwise meet at. GUSSET_R=30mm (judgment
// call, flagged -- no reference photo directly available to this
// session, per Janis's own annotation description of "a real curved
// corner reinforcement"). Built via hull() of two spheres, per
// rules-codes.md's own "hull() for rounded shapes" convention -- real
// CGAL: genuine volume overlap vs both the triangle plate and the stub
// axle, confirmed below (not just a touching face).
GUSSET_R = 30;
module tow_bracket_gusset() {
    hull() {
        translate([CASTER_X, DATUM_Y_CENTER, TRIANGLE_Z + TRIANGLE_T/2]) sphere(r = GUSSET_R);
        translate([CASTER_X, DATUM_Y_CENTER, FRONT_AXLE_Z]) sphere(r = GUSSET_R * 0.6);
    }
}
module tow_handle(handle_fold_deg = 90) {
    translate([HINGE_X, DATUM_Y_CENTER, TRIANGLE_Z])
        rotate([0, handle_fold_deg - 90, 0]) {
            cylinder(d = HANDLE_UPRIGHT_D, h = TBAR_LEN);
            translate([0, 0, TBAR_LEN])
                translate([0, -HANDLE_CROSSBAR_LEN/2, 0]) rotate([-90, 0, 0])
                    cylinder(d = HANDLE_CROSSBAR_D, h = HANDLE_CROSSBAR_LEN);
        }
}
module front_swivel_assembly(steer_deg = 0, handle_fold_deg = 90) {
    translate([CASTER_X, DATUM_Y_CENTER, 0]) rotate([0, 0, steer_deg]) translate([-CASTER_X, -DATUM_Y_CENTER, 0]) {
        color("#AAAAAA", 1.0) {
            front_spacer();
            front_stub_axle();
            tow_triangle();
            tow_bracket_gusset();
        }
        color("#333333", 1.0) front_wheels();
        color("#AAAAAA", 1.0) tow_handle(handle_fold_deg);
    }
}
module front_wheel_support(steer_deg = 0, handle_fold_deg = 90) {
    color("#AAAAAA", 1.0) {
        front_bracket();
        front_caster_plate();
    }
    front_swivel_assembly(steer_deg, handle_fold_deg);
}

// PREP TRAY -- REMOVED ENTIRELY, v12 TASK 1 (see file header for the full
// real R-009 removal check). Relocating to a separate accessories file in
// the bbq-chamber-parting-shift-and-tray-init round (NOT this prompt's
// job to build the replacement). prep_shelf()/prep_shelves()/
// tray_mount_bracket()/tray_mount_brackets() and their exclusive
// constants (TRAY_MOUNT_X/Z, TRAY_BRACKET_W/H/T, TRAY_BRACKET_COUNT,
// SHELF_L, SHELF_D, SHELF_T, LEG_INSET) all deleted.

// ───────────────────────────────
// DEBUG TOGGLES
// ───────────────────────────────
show_rear_axle           = true;
show_rear_fenders        = true;
show_front_wheel_support = true;

handle_fold_deg = 90;    // TASK 6 FIX: was 0 (flat/towing, confirmed broken default) -- now 90 (vertical storage), matches this file's own explicit spec
steer_deg        = 0;    // rotates front_spacer()+front_stub_axle()+front_wheels()+triangle+handle TOGETHER (coupled steering)

// ───────────────────────────────
// ASSEMBLY — each line standalone/commentable per Module Isolation Testing
// (rules-codes.md). v12: prep_shelves() line REMOVED with the tray
// (TASK 1) — real, final count: 3 modules, 3 toggles, 0 gaps.
// ───────────────────────────────
if (show_rear_axle) rear_axle();
if (show_rear_fenders) color("#999999", 1.0) rear_fenders();
if (show_front_wheel_support) front_wheel_support(steer_deg, handle_fold_deg);
