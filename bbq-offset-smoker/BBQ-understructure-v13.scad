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

include <BBQ-chambers-v21.scad>

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
// TASK 2 (v12) — REAR FENDER REBUILT to Janis's own precise real spec
// (rear wheels ONLY, see file header for full reasoning). v7-v11's
// wraparound-hood construction (fender_wedge_2d()/fender_arc_2d()/the old
// rear_fender(), all above) RETIRED entirely (R-009) — a flat rectangular
// deck plate, drooping 15mm at each end (X, rolling direction) via
// hull()-bridged transitions between two IDENTICAL rectangular cross-
// sections (no RULE 2 multi-step loft needed — same shape both ends, per
// that rule's own "simple coaxial stacking of identical cross-sections"
// exception; per rules-codes.md's own "hull() for rounded shapes"
// preference, and matching the prompt's own explicit suggested
// technique).
// ═══════════════════════════════════════════════════════════════════
FENDER_Y_EXT     = 300;                          // real FIXED LITERAL per spec (covers 50mm firebox-wheel gap + 200mm tire + 50mm real margin, confirmed below, NOT re-derived from a formula), measured from the firebox outer shell's real side wall
FENDER_X_LEN     = WHEEL_D * 1.2;                 // 548.64mm, centered on REAR_AXLE_X
FENDER_END_FRAC  = 0.10;                          // front/rear curve-down zone, each end
FENDER_END_LEN   = FENDER_X_LEN * FENDER_END_FRAC;    // 54.864mm
FENDER_DROP      = 15;                            // curve-down zone drop, mm -- UNCHANGED spec, same real number as the elevation margin below
FENDER_T         = 4;                             // panel thickness -- judgment call, UNCHANGED from every prior fender round (not respecified this round)
FENDER_WELD_OVERLAP = 1.5;   // real overlap into firebox outer-shell wall_t(3mm) band -- UNCHANGED value from v7-v11, re-verified via CGAL below
fender_z         = REAR_AXLE_Z + WHEEL_R + FENDER_DROP;   // 228.6+228.6+15 = 472.2mm -- real live value, flat mid-section's UNDERSIDE, matches the prompt's own expected value exactly

// fender_slab() -- one flat rectangular cross-section, real X span
// [x0,x1], real Y span between wall_y (inner, at/into the firebox wall)
// and wall_y+outward_sign*FENDER_Y_EXT (outer, over the wheel), at a
// given underside height z_bottom, panel thickness FENDER_T.
module fender_slab(x0, x1, wall_y, outward_sign, z_bottom) {
    y_far = wall_y + outward_sign * FENDER_Y_EXT;
    translate([x0, min(wall_y, y_far), z_bottom])
        cube([x1 - x0, abs(y_far - wall_y), FENDER_T]);
}
// rear_fender() -- v12 REBUILT (see file header). wall_y = the firebox
// outer shell's real side-wall world-Y position nearest this wheel
// (firebox_y0 left / firebox_y1 right); outward_sign: -1 left (extends
// toward -Y), +1 right (extends toward +Y). weld_wall_y is pushed
// FENDER_WELD_OVERLAP into the firebox's own real wall_t(3mm) material for
// genuine weld contact (not a coincident face) -- the nominal 300mm
// FENDER_Y_EXT itself stays measured from the real wall_y, per spec.
module rear_fender(wall_y, outward_sign) {
    weld_wall_y = wall_y - outward_sign * FENDER_WELD_OVERLAP;
    xc          = REAR_AXLE_X;
    x0          = xc - FENDER_X_LEN/2;
    x1          = xc + FENDER_X_LEN/2;
    x_front_flat = x0 + FENDER_END_LEN;
    x_rear_flat  = x1 - FENDER_END_LEN;
    // flat mid-section -- real minimum clearance to the tire occurs here
    // (15mm, by construction, at X=REAR_AXLE_X exactly -- see file header)
    fender_slab(x_front_flat, x_rear_flat, weld_wall_y, outward_sign, fender_z);
    // front droop zone -- hull() between the flat-level cross-section and
    // the FENDER_DROP-lower end cross-section (real e overlap into the
    // flat mid-section, avoids a coincident face there)
    hull() {
        fender_slab(x_front_flat, x_front_flat + e, weld_wall_y, outward_sign, fender_z);
        fender_slab(x0, x0 + e, weld_wall_y, outward_sign, fender_z - FENDER_DROP);
    }
    // rear droop zone -- same, mirrored
    hull() {
        fender_slab(x_rear_flat - e, x_rear_flat, weld_wall_y, outward_sign, fender_z);
        fender_slab(x1 - e, x1, weld_wall_y, outward_sign, fender_z - FENDER_DROP);
    }
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
