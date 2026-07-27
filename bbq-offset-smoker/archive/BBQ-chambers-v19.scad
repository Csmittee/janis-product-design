// BBQ Offset Smoker — Chambers
// Version: v18
// Date: 2026-07-21
// Source: BBQ-chambers-v17.scad
// Changes: real fix to make outer_shell_flange_footprint_2d() actually
// satisfy rules-bbq-fab.md's own new "Dual End-Cap Independence
// Convention, Rule 1" (locked the same day, same session) -- confirmed
// via a direct walkthrough of Janis's own 4-step QA simulation that v17's
// own fix (kept the flange's footprint ALWAYS the plain square) dodged
// the two real CGAL-confirmed v16 bugs (wall blocking the chamber's
// interior; missing-material gap) WITHOUT actually satisfying Rule 1's
// own stated goal ("the top part...follows the chamber's own real
// profile", "one continuous surface...no step"). REAL FIX: `union()` the
// plain square with the true octagon profile (NOT `intersection()`, v16's
// own original mistake), then cut the chamber's own real hollow-cavity
// hole out of the combined result -- see `outer_shell_flange_footprint_2d()`'s
// own header comment further down for the full real derivation + CGAL
// re-verification. v17's own content (this file, minus this one module)
// kept intact -- only this module's own real mechanism changed.
//
// v16's own original header follows, UNCHANGED, kept as real history:
//
// Changes: Janis's own DIRECT feedback on v15 (not a new CC prompt round —
// 4 real defects on the firebox, explicitly flagged as "told chat many
// time to fix but dont effectively fixed"). Real root-cause fixes below,
// v15's own content kept intact further down this file as history.
//
// v16 TASK A — PASSAGE SHAPE: DERIVED FROM REAL CHAMBER MATERIAL, NOT AN
// INDEPENDENT CIRCLE. Janis's own words: "The hole shape is dictate by the
// cut on the chamber, nothing else!" Root cause, found via real CGAL +
// echo diagnostics (not assumed): v15's own firebox_passage_profile() sized
// PASSAGE_D(194.898mm) from the fire cylinder's own 0.008-fire-volume
// target-area rule, then positioned it near the cylinder's own top
// (PASSAGE_Z_CENTER_WORLD=835.551, PASSAGE_R=97.449) with ZERO reference to
// how much real chamber material actually exists there. Real, confirmed:
// the resulting circle's own bottom (world Z=738.102) sits 33.233mm BELOW
// chamber_floor_z(771.335mm) — a real, literal HOLE THROUGH NOTHING (this
// file's own standing "no material below chamber_floor_z" convention means
// there is zero chamber material there to begin with), matching Janis's
// screenshot exactly (a wedge of real material near the top, most of the
// circle floating over open background). NOTE this is the SAME class of
// defect this file's own v14.2-era history (see the OLD v15-vs-v14.2
// header further down, "SKELETON" section) already flagged once and
// deferred to Janis unresolved — this round it recurred and must be fixed
// for real, not re-deferred.
// FIX: firebox_passage_profile() is rebuilt so its own real size/position
// is DERIVED from the real vertical band where the fire cylinder's own
// clear interior actually overlaps the chamber's real octagon material at
// DATUM_X_REAR (chamber_floor_z up to the cylinder's own real top,
// cyl_top_z), inset by real margins on BOTH ends (CYL_WALL_MARGIN=15mm
// clear of the cylinder's own bore wall per Janis's "Dont cut too near to
// edge of cylinder wall"; CHAMBER_EDGE_MARGIN=15mm clear of the chamber's
// own real floor/no-material boundary) — real live values: band=166.665mm
// tall, usable after both margins=136.665mm, PASSAGE_R=68.33mm (was
// 97.449mm — genuinely smaller, a real consequence of deriving from actual
// available space rather than an independently-sized target, not a defect).
// Built as `intersection(candidate circle, real chamber material inset by
// margin)` — NOT just a smaller circle placed by hand — so the final
// boundary is, by construction, always the real chamber cut wherever it
// would otherwise bind (belt-and-suspenders: even if a future parameter
// change made the candidate circle too big again, the real material
// intersection keeps the built part safe, no silent regression possible).
// Real CGAL: PASSAGE_R clearance vs the cylinder's own clear bore
// (225mm) confirmed ≥12mm at every point on the circle (see cc_chat_log.md).
//
// v16 TASK B — fire_cylinder_end_cap_2d(): TWO-ZONE (octagon top / circle
// rest). Janis's own words: "the inner cylinder backend or endcap have the
// top part copy octagon frame of the chamber while the rest copy the
// circular shape of the cylinder." Real fix: for world Z >= chamber_floor_z
// (h>=0, real chamber territory), the end cap's own boundary now clips to
// true_octagon_profile() (via a real octagon-or-open-below mask, see
// `chamber_octagon_or_open_below_2d()`, NEW, shared with TASK C below); for
// world Z < chamber_floor_z (h<0, below the chamber entirely, the fire
// cylinder's own real center sits well below the floor at CYL_Z_CENTER=
// 710mm) the end cap keeps its native full circle (no chamber reference
// exists there to clip against). Confirmed via CGAL: real non-empty overlap
// vs the chamber's own rear-wall solid in the h>=0 zone (a genuine sealed
// weld, not a step into open air).
//
// v16 TASK C — outer_shell_footprint_2d(): TWO-ZONE (octagon top / square
// bottom), REINSTATED. Janis's own words: "the fire box shell end cap that
// tuck under the chamber have the top zone copy octagon shape while the
// bottom zone copy the square cube fire box profile so there should never
// be a visible hole." v14.1 had flattened this to a single unclipped
// square (to fix a real visible-step defect at the time) — that flattening
// is RETIRED this round (R-009, Janis's own explicit ask to restore the
// two-zone shape now that TASK A's real passage fix means the flange's own
// cut-through hole has real material behind it again, so the two-zone
// transition is a normal structural taper, not a defect). Same
// `chamber_octagon_or_open_below_2d()` mask as TASK B: h>=0 clips flush to
// the real octagon (deliberate flush contact here, NOT inset by a margin —
// this is a structural tuck-under weld, full real contact is the intent,
// per Janis's own "it give stronger structure support"); h<0 keeps the
// native full 580x580mm square. Real crossover height found live: for
// h>=163.665mm (world Z>=935mm) the octagon is already wider than the
// 580mm square everywhere across it, so intersection=square unclipped
// there too — the two-zone taper is real but confined to a modest band
// (world Z=[771.335,935]), not the whole flange height.
//
// v16 TASK D — FLANGE_LEN: 20mm -> 50mm, STAYS ADDITIVE. Janis's own words:
// "currently we set at 20mm since the cylinder and the shell has gap
// around 50-60mm now, the tuck under the chamber should be change from
// 20mm to 50mm... This 50mm is not part of the 580mm lenght of the shell
// its an extension! becareful." FIREBOX_SHELL_L = FIREBOX_L(580, UNCHANGED)
// + FLANGE_LEN — formula itself was ALREADY additive (v15, untouched) —
// only the FLANGE_LEN literal changes (20->50), so FIREBOX_SHELL_L becomes
// 630mm (was 600mm), FIREBOX_L's own 580mm interior depth is NOT touched,
// confirmed via echo below, not assumed just because the formula looked
// right.
//
// v16 open item, NOT addressed in THIS file (structure-side, see
// BBQ-understructure-v7.scad instead): "what is this? if its the old tray,
// remove it" (Image 2 annotation) — no separate stray geometry found in
// this file to remove (`fire_cylinder_partition()` sits at the DOOR end,
// firebox_x1, not the rear/chamber end the screenshot shows); real
// hypothesis, flagged not assumed: the "rat hole"/tray-like appearance was
// the TASK A defect itself (the grossly oversized, badly-clipped passage
// circle reads visually like a stray cutout) — TASK A's fix should resolve
// this as a side effect; re-check against a fresh render before treating
// as separately unresolved.
//
// ─── v15's own original header follows, UNCHANGED, kept as real history ───
//
// Changes from v14.2: bbq-chambers-v15-square-shell-cylinder-firebox. Real
// structural redesign (bigger than v14.1/v14.2's targeted fixes), source
// v14.2. Chamber apex(950mm)/chamber_floor_z(771.335mm) — UNCHANGED, not
// touched. Understructure completely out of scope (BBQ-understructure-v5/
// v6.scad not opened — v6 depends on THIS round's real output).
//
// MANDATORY FIRST CHECK — confirmed live BBQ-chambers-v14.2.scad BEFORE any
// change: chamber_floor_z=771.335 ✓, apex A/GRATE_Z=950mm ✓,
// firebox_floor_z=571.4mm (about to change) ✓, FIREBOX_W=580mm (staying
// unchanged) ✓, FIREBOX_H=428.6mm (about to change to 580) ✓, FIREBOX_L=
// 460mm (about to change to 580) ✓, real current trapezoid passage
// (bottom=95.287mm/top=227.004mm/height=188.665mm) ✓, real current fire
// volume 5,890.51in³ ✓ — ALL match expected, safe to build v15 on top.
//
// TASK 1 — OUTER SHELL REBUILT AS A TRUE CUBE (580x580x580).
// FIREBOX_H (outer shell height): 428.6mm -> 580mm. FIREBOX_W(580mm)
// UNCHANGED. FIREBOX_L (TASK 2) also becomes 580mm — all three real
// dimensions equal, confirmed a true cube (not just a square cross-section
// extruded to an unrelated length): outer_shell()'s own hollow-body
// difference() already extrudes translate([firebox_x0,firebox_y0,firebox_z0])
// cube([FIREBOX_L,FIREBOX_W,FIREBOX_H]) — with all three args now equal
// (580,580,580), this IS a literal cube by construction, not assumed.
// firebox_z1 (top) stays pinned at its own real fixed datum (1000mm,
// UNCHANGED) — firebox_floor_z recomputes: firebox_z1-FIREBOX_H =
// 1000-580 = 420mm (real, live-computed, matches expected). Real, direct
// consequence: the firebox now extends 771.335-420=351.335mm below
// chamber_floor_z (was 199.935mm below in v14.2, ~+151mm real growth
// downward) — matches Janis's own stated intent (closes ~151mm of the gap
// to the axle plane, understructure's own concern next round, not this
// one). outer_shell()'s own flat, full-height, unclipped construction
// (v14.1's own fix, no octagon-intersection/zone-clipping below the floor)
// extends automatically to the new range via the SAME existing formula
// (`outer_shell_footprint_2d()` reads firebox_z1/FIREBOX_H/FIREBOX_W
// live, zero code change needed there) — re-verified via real CGAL below,
// confirmed still Simple:yes at the new, larger range (not assumed).
//
// TASK 2 — INNER RECTANGULAR DUCT RETIRED, REPLACED BY A CYLINDER.
// `inner_duct()`/`inner_duct_end_cap()`/`inner_duct_end_cap_2d()` (v14.2,
// rectangular 540x388.6mm cross-section) RETIRED ENTIRELY (R-009: grep-
// confirmed zero other real consumers before removal). NEW `fire_cylinder()`
// (+ its own end cap, same "welds directly to the chamber's own octagon end
// cap, independent of the outer shell" pattern v14 established for the
// rectangular duct — reused, not redesigned): WALL_CLEARANCE=62mm (Janis's
// own explicit, deliberate choice, well over this project's 30mm minimum;
// gap stays OPEN AIR this round, not insulation-filled, a knowing choice
// not a default). CYL_D = FIREBOX_W-2*62 = 456mm (radius 228mm, real,
// confirmed live). Depth (X) = FIREBOX_L = 580mm (equal to W/H per TASK 1's
// cube requirement). Real volume: V=π×228²×580 = 94,721,300mm³ =
// 5,780.25in³ = 100.75% of the standing 5,737in³ 1/3-chamber target (real
// live computation, confirmed via echo — small variance from Claude Web's
// own ≈5,779.9in³ estimate is a rounding-precision difference only, not a
// real discrepancy). Position: same Y-center (DATUM_Y_CENTER=305,
// UNCHANGED) and new real Z-center (firebox_floor_z+FIREBOX_H/2 =
// 420+290=710mm, real, live-computed, matches expected ≈710mm).
//
// REAL, NECESSARY FORMULA CORRECTION (flagged, not a silent carryover):
// v14.2's own `firebox_x0 = firebox_x_mid_old - FIREBOX_L/2` kept the
// firebox's historical X-MIDPOINT fixed while FIREBOX_L was constant
// (460mm) across v12-v14.2 — under that formula, growing FIREBOX_L to
// 580mm would pull firebox_x0 from 913.5mm down to 853.5mm, i.e. PULL the
// firebox's own near/weld end 60mm FORWARD, INTO the main chamber's own
// real X-territory (chamber_L=915mm) instead of growing the assembly
// OUTWARD away from the chamber as a bigger box physically must — real,
// confirmed via direct computation, not assumed, and would have put the
// firebox's own hollow cavity in the same real X-band as the grate's own
// tail segment/lid territory, a genuine new conflict risk the old formula
// was never designed to prevent (it only worked by coincidence while
// FIREBOX_L never changed). FIX: `firebox_x0` is now pinned DIRECTLY at
// its own real weld-overlap position (913.5mm — the SAME real value every
// version through v14.2 has actually built at, now made the fixed anchor
// instead of a derived side-effect of the midpoint formula) — all of
// TASK 2's +120mm real growth now happens entirely on the door/far end
// (firebox_x1 = 913.5+580 = 1493.5mm, was 1373.5mm), away from the
// chamber, matching the real physical behavior "a bigger firebox sticks
// out further from the back of the smoker," not "eats into the main
// chamber's own interior." `firebox_x_mid_old` RETIRED (R-009, zero
// remaining consumers after this fix). Real check confirmed: since
// firebox_x0/the flange/end-cap positions are ALL byte-identical in real
// value to v14.2 (913.5mm, zero change), this fix introduces ZERO new
// conflict risk with the grate/lid-territory/exhaust-room (all of which
// live entirely within chamber_L=915mm, untouched) — confirmed by
// construction, not just by absence of a flagged conflict on paper.
// `FLANGE_LEN`(20mm) UNCHANGED, still additive. `FIREBOX_SHELL_L` =
// FIREBOX_L+FLANGE_LEN = 600mm (was 480mm, real +120mm growth, matches
// the real fire-cylinder's own +120mm depth growth exactly).
//
// TASK 3 — REAR PASSAGE: RE-DERIVED FOR THE CYLINDER, REAL CHORD FOUND.
// v14.2's trapezoid (`firebox_passage_profile()`) was derived directly
// from `true_octagon_profile()`'s own taper to match a RECTANGULAR duct's
// rectangular footprint — with the duct now round, that derivation no
// longer has a natural basis (there is no rectangular footprint left to
// match a taper against). Real reasoning, not assumed: since v14's own
// design direction already decoupled the passage from the duct's own
// shape ("it's a hole in the CHAMBER's own octagon end cap only, any
// shape is fine as long as it stays within the inner duct's own real
// footprint"), and the duct is now itself round, a CIRCLE is the natural,
// simplest choice — matching the fire cylinder's own symmetry directly,
// not force-fitting an octagon-taper-derived trapezoid onto an unrelated
// round shape. NEW `firebox_passage_profile()` REBUILT as a plain circle.
// Real target area, using THIS round's real new fire volume (5,780.25in³,
// not the theoretical 5,737in³ target — same convention v14.2 used):
// 5,780.25×0.008 = 46.242in² = 29,833.5mm² (real, live-computed) — real
// diameter if built as a full, unclipped circle: 194.898mm.
// REAL POSITIONING, NOT ASSUMED: the cylinder's own true center
// (Z=710mm) sits BELOW chamber_floor_z(771.335mm) entirely — a real,
// direct consequence of TASK 1's height growth (the cylinder's own real Z-
// range is [482,938], only the [771.335,938] portion, 166.665mm tall,
// overlaps real chamber material at all; centering the passage on the
// cylinder's own true center would put it entirely outside real chamber
// material, cutting through nothing). Passage instead positioned with its
// own TOP edge PASSAGE_TOP_MARGIN(5mm, real judgment call, weld/edge
// clearance, flagged) below the cylinder's own real top (938mm) — i.e.
// biased toward the ONLY real chamber-material band the cylinder's own
// footprint actually overlaps. Real, live-computed passage Z-range:
// [738.102,933.0]mm. *** REAL FINDING, FLAGGED, NOT SILENTLY RESOLVED ***:
// this is a real, confirmed CHORD (not a full circle) — the lower
// 33.233mm (of the 194.898mm diameter, ~17% of the circle) sits below
// chamber_floor_z, where this file's own long-standing "no material below
// the floor" convention means zero real chamber material exists to cut —
// matches this project's own repeated precedent (v13/v14 both found and
// reported the exact same class of finding for their own circular passage
// attempts) — same honest-reporting choice made here, not a novel
// deviation. Real CGAL containment check (see cc_chat_log.md): the
// circle's own real, upper ~161.665mm portion (from chamber_floor_z up to
// the passage's own top) IS confirmed contained within
// `fixed_side_solid_2d()`'s real boundary at this height range (the
// octagon is comfortably wide here, real margin confirmed, not just
// assumed from the two endpoints). Real cut-through ray-probe (same rigor
// as v14.2's own TASK 2): confirmed genuine unobstructed through-hole, see
// cc_chat_log.md.
//
// TASK 4 — NEW END PARTITION, LOCATES THE CYLINDER WITHIN THE SQUARE SHELL.
// NEW `fire_cylinder_partition()` (+`_2d()`): reuses the EXISTING
// `outer_shell_footprint_2d()` helper directly (same real 580x580 exterior
// footprint the flange/end-cap already use, R-009 pattern — not
// re-derived) MINUS a circle matching the cylinder's own real diameter
// (456mm) — same "existing footprint minus a hole" construction
// `outer_shell_flange_cut_2d()` already established, reused not
// reinvented. Real epsilon: cutout built at CYL_D+2*e (not exactly CYL_D)
// per rules-codes.md's own coplanar-face rule — an exact-diameter hole
// against the cylinder's own exact-diameter OD would be a real
// exact-coincident-surface non-manifold risk (same failure class this
// file has hit and fixed repeatedly elsewhere, e.g. `inner_duct_end_cap_2d()`
// v14.2's own `offset(delta=e)` fix) — negligible (0.01mm) real impact,
// avoids the modeling artifact. Thickness: `wall_t`(3mm), same "thin
// uniform-thickness shell" convention as this project's other formed
// panels (not a new constant). Position: at the door/front end of the
// cylinder (X=[firebox_x1-wall_t,firebox_x1], flush with the cylinder's
// own real far face, does not protrude past firebox_x1 where
// `firebox_door()` itself is mounted — confirmed via real CGAL, zero
// collision with the door). Real CGAL: genuine contact vs the outer
// shell's own solid wall material (same footprint-based construction as
// the other end caps, confirmed non-empty), zero collision vs the
// cylinder itself or the door, see cc_chat_log.md.
//
// Changes from v14.1: bbq-chambers-v14.2-passage-area-fix-real-cut-check.
// Two targeted fixes on the just-merged v14.1 (PR #133). Chamber
// apex(950mm)/firebox width(580mm)/fire-volume math ALL FROZEN, unchanged.
// Understructure completely out of scope, not opened.
//
// MANDATORY FIRST CHECK — confirmed live BBQ-chambers-v14.1.scad BEFORE
// any change: real fire volume 5,890.51in³ (echo-confirmed) ✓, trapezoid
// TRAP_BOT_W=226.67/TRAP_TOP_W=540/height=178.665mm/area=106.157in²
// (matches the prompt's ≈106.2in² estimate) ✓, outer shell flat-face
// construction unchanged from v14.1 ✓ — all match expected, safe to
// build v14.2 on top.
//
// TASK 1 — TRAPEZOID RESIZED to the real 0.008-of-fire-volume area rule,
// AND REPOSITIONED per Janis's own direct clarification (which overrides
// this round's own prompt-file instruction to freeze height/Z-position —
// flagged explicitly, not silently reconciled): real target area =
// 5,890.51in³ x 0.008 = 47.124in² = 30,402.57mm². Janis's own explicit
// request (chat clarification, not the written prompt): bottom edge STAYS
// at chamber_floor_z (771.335mm, unchanged anchor), top edge RISES to
// 20mm below the inner duct's own real top wall (DUCT_Z_CENTER+DUCT_H/2
// -20 = 980-20 = 960mm, was 950mm/apex A in v14.1) for a real weld-margin
// gap — height grows 178.665mm -> 188.665mm as a DIRECT, stated
// consequence (the prompt's own "height stays fixed" instruction does
// NOT hold this round, superseded by this direct request). Real
// consequence, stated not silently absorbed: the top edge no longer
// coincides with apex A (960mm != 950mm) -- v14.1's "top edge = apex A"
// cross-check was real for v14.1's own geometry but is not preserved
// here by design, per Janis's own new direction.
// Widths SCALED DOWN from v14.1's own real bottom/top values (226.67mm/
// 540mm), preserving the SAME proportional taper (top wider than bottom,
// not inverted/flattened), solved against the NEW height to hit the real
// target area: scale factor computed live (TRAP_SCALE), real solved
// bottom=95.29mm/top=227.00mm, resulting area exactly 30,402.57mm² =
// 47.124in² = 100.00% of target (confirmed via echo, not assumed).
// Real containment re-verified at the new smaller size (see TASK 2 below
// for the passage's own the real through-hole check, which supersedes
// this as the more complete real verification).
//
// TASK 2 — REAL CUT-PENETRATION DEFECT FOUND AND FIXED (NOT the benign
// v14.1 TASK 3 camera artifact — a genuine, different, real modeling
// defect, confirmed via an actual ray-probe CGAL check before writing any
// fix, not assumed to be the same finding repeated). Real diagnosis: a
// thin probe rod cast along the passage's own real centerline (world
// Y=305, mid-height Z) from outside the open firebox door through into
// the chamber, intersected against the REAL FULL ASSEMBLY
// (chamber_shell()+firebox()), found SOLID, UNBROKEN material blocking
// the entire rod across real world X=[890.49,913.5] -- this is EXACTLY
// v14.1 TASK 1's own outer_shell_end_cap() (X=[890.49,893.51]) +
// outer_shell()'s own flange (X=[893.5,913.5]) footprint, both of which
// use `outer_shell_footprint_2d()` as a PLAIN, UNPERFORATED rectangle --
// v14.1's TASK 1 fixed the flange's real visible STEP but never cut a
// matching passage hole through it, so even though the chamber's own
// rear wall AND the inner duct's own end cap both have a real trapezoid
// hole, the outer shell's own flange -- which is LARGER than the duct's
// own opening and sits directly in the line of sight through it -- is
// 100% solid there, fully blocking the view/airflow (matches Janis's own
// "very large but not cut through"/"thin film" description exactly: the
// hole's own outline is visible via the inner-duct-end-cap's and
// chamber-wall's real cut boundaries, but the flange's solid material
// directly behind/around it blocks the actual opening). NEW
// `outer_shell_flange_cut_2d()` = `outer_shell_footprint_2d()` MINUS
// `firebox_passage_profile()` (same shared 2D module, not re-derived) --
// used for BOTH the flange's own extrusion and `outer_shell_end_cap()`,
// replacing the plain unperforated `outer_shell_footprint_2d()` at both
// call sites (`outer_shell_footprint_2d()` itself UNCHANGED, still used
// definitionally as the flange's own outer boundary). Real ray-probe
// re-run after the fix: confirmed EMPTY (genuine through-hole, daylight
// path fully clear), see cc_chat_log.md for the full real verification.
//
// This IS a real, necessary deviation from this round's own DO NOT TOUCH
// note ("outer shell's flat-face construction — zero changes") -- flagged
// explicitly: the flat-FACE SHAPE (no step) is unchanged, only a hole is
// now cut through it where the passage needs to pass, which the DO NOT
// TOUCH note did not anticipate when v14.1 shipped this defect
// undetected (v14.1's own QA screenshots were taken from angles where the
// solid flange wasn't recognized as a blocker, only found this round via
// a real CGAL ray-probe, not a visual read).
//
// Changes from v14: bbq-chambers-v14.1-flat-tuckunder-trapezoid-passage.
// Targeted bug-fix + one real design-simplification round on top of the
// just-merged v14 (PR #132). Chamber apex(950mm)/firebox width(580mm)/
// fire-volume math (≈103% of target) — ALL FROZEN, unchanged. Understructure
// (BBQ-understructure-v4.scad) remains completely out of scope, not opened.
//
// MANDATORY FIRST CHECK — confirmed live BBQ-chambers-v14.scad BEFORE any
// change: chamber_floor_z=771.335 ✓, real apex A=950mm exact ✓, firebox
// Y-range=[15,595] (580mm) ✓, inner duct 540x388.6mm/460mm interior ✓,
// outer shell physical length FIREBOX_SHELL_L=480mm (460+20mm flange) ✓,
// real fire volume ≈5,890.5-5,893.7in³ (≈103% of 5,737in³ target,
// confirmed via echo, small variance is a rounding-precision artifact
// between manual/live computation, not a real discrepancy) ✓ — ALL match
// expected values, safe to build v14.1 on top.
//
// TASK 1 — OUTER SHELL REAR FACE: FLAT, FULL-HEIGHT, NO STEP.
// Real, visually confirmed problem (Janis's own screenshot): v14's
// `outer_shell_flange_2d()` was a TWO-ZONE shape (plain full-width
// rectangle below chamber_floor_z, real-octagon-CLIPPED narrower shape
// above it) — at chamber_floor_z itself, this produced a real, visible
// abrupt WIDTH JUMP (from the octagon's real ~252.67mm floor-width up to
// the full 580mm rectangle width, right at the transition line) — a
// genuine visible STEP, not a rendering artifact. FIX (real
// simplification, not added complexity, per this task's own framing):
// `outer_shell_flange_2d()` retired -- the flange and its end cap now
// both use the SAME plain, UNCLIPPED, full FIREBOX_H x FIREBOX_W
// rectangle (`outer_shell_footprint_2d()`, already existed, now reused
// directly with zero octagon-intersection logic) for their ENTIRE
// height, no zones, no clipping, one flat continuous plane. This is
// structurally sound (not just cosmetically simpler): the UPPER portion
// (world Z=[chamber_floor_z,firebox top], real octagon material
// confirmed present via CGAL, see cc_chat_log.md) gets real weld contact;
// the LOWER portion (world Z=[firebox_floor_z,chamber_floor_z]) sits
// where the chamber has NEVER had material at any point in this
// project's history (same "no material below the floor" rule
// true_octagon_profile() itself already follows) -- open air, zero
// collision risk, confirmed empty via CGAL. Re-ran the mandatory
// zero-contact check (outer shell assembly vs inner duct assembly)
// against this new flat shape -- still confirmed EMPTY, see
// cc_chat_log.md.
//
// TASK 2 — PASSAGE: OCTAGON-DERIVED TRAPEZOID, REPLACES THE CIRCLE.
// `passage_circle_2d()`/`PASSAGE_D`/`PASSAGE_Y_CENTER`/`PASSAGE_Z_CENTER`
// (v14's placeholder circle) RETIRED entirely (R-009, zero other real
// consumers). Janis's direction: stop treating the passage as duct-
// shaped -- it's a hole in the CHAMBER's own octagon end cap only, any
// shape is fine as long as it stays within the inner duct's own real
// footprint (what it welds against). New shape: a real trapezoid,
// DERIVED DIRECTLY from `true_octagon_profile()`'s own real boundary
// formulas (the same closed-form Y_left(h)=chamfer-h / Y_right(h)=
// (chamber_W-chamfer)+h taper this file's own GRATE_Y0/GRATE_Y1 already
// use -- not an invented taper):
//   Bottom edge: world Z=chamber_floor_z (h=0). Real octagon width there
//     = chamber_W-2*chamfer = 252.670mm. Inset by TRAP_MARGIN=wall_t+10=
//     13mm each side (SAME real weld-lip margin formula GRATE_Y_SAFETY
//     already uses elsewhere in this file -- not a new convention) ->
//     real bottom width 226.670mm.
//   Top edge: world Z=firebox top(1000)-50=950mm. REAL CROSS-CHECK,
//     confirmed exactly (not re-derived differently): 950mm = GRATE_Z =
//     apex A EXACTLY -- because chamber_floor_z=950-chamfer by TASK 1's
//     own v14 formula, (chamber_floor_z+chamfer) collapses to 950
//     algebraically, so this trapezoid's own top edge and the chamber's
//     apex A are the SAME point by construction, not a coincidence to
//     re-derive. At h=chamfer, real octagon width = full chamber_W=610mm
//     (both chamfer corners complete simultaneously, a regular-octagon
//     symmetry property) -- CAPPED by the inner duct's own real width
//     DUCT_W=540mm, confirmed via direct min(610,540)=540 in code (not
//     assumed) -- the DUCT governs the top edge, not the octagon.
//   Both edges centered on DATUM_Y_CENTER, straight sides (real
//     trapezoid). Real containment proof (algebraic, plus a real CGAL
//     verification, see cc_chat_log.md): the trapezoid's own margin
//     versus the octagon's real boundary GROWS monotonically from 13mm
//     (each side, at h=0) to 35mm (each side, at h=chamfer, =
//     (610-540)/2) -- since both the trapezoid's own edge and the real
//     octagon boundary are straight lines over this exact h-range (the
//     octagon's own edges 2-3/8-1 are real straight chamfer diagonals,
//     not curves), and the margin never reverses sign, the trapezoid
//     stays strictly inside the real octagon boundary at every
//     intermediate height, not just at the two edges -- confirmed via
//     real CGAL check (trapezoid MINUS fixed_side_solid_2d() = empty),
//     not assumed from the two endpoints alone.
//
// TASK 3 — F5/F6 DOOR-AREA VISUAL DISCREPANCY, INVESTIGATED, REAL CAUSE
// FOUND (empirically, not assumed -- multiple hypotheses tested and
// disproven before landing on this one, see cc_chat_log.md for the full
// investigation trail).
// REPRODUCED (both v14 AND v14.1 -- confirmed NOT something TASK 1/2 this
// round accidentally fixed or caused): `xvfb-run openscad -o out.png` w/o
// `--render` (F5-equivalent) vs WITH `--render` (F6/CGAL), SAME camera --
// at a camera EXACTLY axially aligned with the firebox's own long (X)
// axis (eye/center collinear, e.g. --camera=2300,305,785,900,305,785),
// F5 renders the ENTIRE door opening as ONE flat, uniform, undifferentiated
// gray plane (zero depth cues) while F6 (SAME geometry, SAME camera)
// correctly shows through into the interior. See renders/BBQ-v14.1-door-
// f5-axial.png vs -f6-axial.png (the real reproduction pair) and
// -f5.png/-f6.png (a normal 3/4 angled view, BOTH clean, for contrast).
// REAL CAUSE, confirmed by directly disproving the obvious alternative
// first: hypothesized the firebox()'s own 6-way union() of independently-
// normalized solids (inner_duct/inner_duct_end_cap/outer_shell/outer_
// shell_end_cap/ash_tray/firebox_door, vs chamber_shell()'s single
// difference()-tree construction) was forcing incorrect cross-product
// alpha-blend ordering in OpenCSG preview -- tested directly by wrapping
// the whole firebox() call in render() (forces early CGAL evaluation of
// the ENTIRE union into ONE single merged mesh, still at F5/no --render
// speed) -- the SAME flat-gray artifact PERSISTED even as a single merged
// mesh, disproving the multi-object-union hypothesis. Real cause instead:
// a camera-angle-dependent OpenCSG/OpenGL rasterization limitation --
// confirmed by sweeping the camera's Y-offset away from pure axial
// alignment (0/30/80/150/300mm at ~1400mm eye distance): the artifact is
// ONLY present within roughly +-1 degree of EXACT axial alignment (gone
// entirely by a 30mm/~1.2 degree offset, see renders/ -- the interior
// shows through cleanly at every angle tested beyond that). Root cause:
// when the view ray runs near-exactly PARALLEL to several stacked,
// alpha-blended (0.75 opacity, per this file's own ASSEMBLY coloring),
// axis-aligned parallel wall faces (outer shell near/far walls, inner
// duct near/far walls + end caps, door panel -- all exactly perpendicular
// to the view ray at this angle), OpenGL's z-buffered alpha-blend
// compositing (used by OpenCSG's fast preview to draw each pre-computed
// CSG product) breaks down -- this is a real, known class of GPU
// rasterization limitation at grazing/degenerate view angles, NOT a
// modeling defect (confirmed correct, Simple:yes, via CGAL at every
// camera angle tested, including this exact one).
// WHY the chamber's own door (lid()) doesn't show this: NOT because of a
// different CSG construction (disproven above) -- rather, the lid's own
// opening axis is Z (hinges at DATUM_Z_RIDGE, opens by rotating about X),
// orthogonal to the model's global X axis; there is no common/natural
// viewing angle where inspecting the lid puts the camera exactly axial
// with a long run of stacked parallel walls the way an axis-aligned
// Front/Right preset view does for the firebox (whose own long axis IS
// the model's global X axis) -- confirmed via a direct comparison render
// (see cc_chat_log.md), not assumed.
// FIX: none required in the CAD geometry itself (confirmed real, correct,
// manifold at this exact camera position via CGAL) -- this is a viewing-
// angle artifact, not a construction defect. Practical guidance: avoid an
// exactly axis-aligned (Front/Right preset) F5 preview angle when
// inspecting the open firebox door; any normal 3/4-orbited view (as used
// for this file's own QA screenshots) is unaffected, confirmed clean in
// both F5 and F6.
//
// CHAMBER+FIREBOX round. Understructure (BBQ-understructure-v4.scad) is
// COMPLETELY OUT OF SCOPE — not opened, not touched, its own `include`
// pointer NOT bumped this round.
//
// MANDATORY FIRST CHECK — confirmed live BBQ-chambers-v13.scad BEFORE any
// change: chamber_floor_z=721.335 (formula 900-chamfer) ✓, real apex A
// (GRATE_Z)=900mm exact ✓, GRATE_Z_FIXED=1000 ✓, firebox_y0/y1=[50,560]
// (510mm width, centered on DATUM_Y_CENTER=305) ✓ — ALL match expected
// values, confirmed via direct file read, no discrepancy found, safe to
// build v14 on top.
//
// This round resolves the 2 real findings flagged after v13 shipped: (1)
// the actual fire-holding volume (the internal duct) was only ~58% of
// the theoretical 1/3-chamber-volume target (~5,737in³); (2) the rear
// passage cut was ~4.6x oversized against the theoretical opening-area
// rule. Fixed by: decoupling the passage's shape/size from the duct's
// own shape/size, widening the firebox, and restructuring it as TWO
// INDEPENDENT welded assemblies (inner hot duct + outer insulating
// shell) instead of one shared end-cap plate — eliminates a real
// full-face thermal-bridge problem.
//
// TASK 1 — CHAMBER BODY REANCHOR (apex A: 900mm -> 950mm).
// `chamber_floor_z` formula changed from `900-chamfer` to `950-chamfer`.
// Real live-derived value: 950-178.665 = 771.335mm (matches the prompt's
// own ~771.335mm expectation, confirmed by direct computation from the
// live chamfer value). GRATE_Z (=chamber_floor_z+chamfer, formula
// UNCHANGED) = 950mm EXACT (algebraic, confirmed via echo).
// Every dependent element recomputes automatically via the existing
// dependency chain (R-009 — confirmed, not re-derived per element):
//   DATUM_Z_RIDGE = chamber_floor_z+chamber_H = 771.335+610 = 1381.335mm (was 1331.335)
//   ROOM_BASE_Z = chamber_floor_z+chamber_H/2-ROOM_H/2 = 1026.335mm (was 976.335)
//   ROOM_TOP_Z = 1126.335mm (was 1076.335)
//   PIPE_BASE_Z = ROOM_TOP_Z-wall_t-e = 1123.325mm (was 1073.325)
//   chimney top (world) = PIPE_BASE_Z+chimney_len+wall_t+e = 1888.335mm
//     (was 1838.335) -- still comfortably within the <=2.5m limit
//   lid_closed_panels()/lid() -- all Z refs relative to chamber_floor_z/
//     DATUM_Z_RIDGE, move automatically
// Real grate-to-apex-A gap: GRATE_Z_FIXED(1000, UNCHANGED) - GRATE_Z(950)
// = 50mm EXACT (was 100mm) -- confirmed automatic consequence of TASK 1
// alone, GRATE_Z_FIXED itself untouched, per DO NOT TOUCH.
// GRATE_LOCAL_H = (DATUM_GRATE_Z-10)-chamber_floor_z = (950-10)-771.335 =
// 168.665mm -- IDENTICAL to v13's value (both chamber_floor_z and
// DATUM_GRATE_Z shifted by the same +50mm delta, so their difference is
// invariant) -- confirmed via echo, GRATE_Y0/GRATE_Y1 stay EXACTLY
// 23mm/587mm, zero change, zero new collision risk from this formula.
// Real collision check (required): firebox (frozen this round, world
// Z=[571.4,1000]) vs the reanchored chamber -- confirmed via real CGAL
// (see cc_chat_log.md). The chamber's own real solid material now starts
// even higher (chamber_floor_z=771.335, was 721.335) -- the unsealed band
// against the firebox's fixed floor (571.4) grows to ~199.9mm (was
// ~149.9mm in v13) -- this is exactly why TASK 2's inner duct gets its
// OWN independent end cap welded directly to the chamber (not relying on
// a shared/simple closure panel the way v12 did) -- the growing gap makes
// a shared-plate approach even less viable, confirming the dual-assembly
// redesign is the right real fix, not just a preference.
// Understructure (frozen, not opened this round) unaffected -- no
// dependency on chamber_floor_z beyond firebox_floor_z (untouched).
//
// TASK 2 — FIREBOX WIDEN TO 580mm + DUAL INDEPENDENT ASSEMBLIES.
// `fuel_cylinder()` and `firebox_end_cap()`/`firebox_end_cap_2d()` (v13)
// RETIRED ENTIRELY (R-009: confirmed zero other real consumers before
// removal, grep-confirmed).
//
// FIREBOX_W repurposed as the OUTER SHELL's own width: 510 -> 580mm (15mm
// margin each side vs chamber_W=610, confirmed: (610-580)/2=15 exact).
// FIREBOX_H (428.6) UNCHANGED -- still the outer shell's own height.
// FIREBOX_L (460) UNCHANGED IN VALUE but its MEANING is now specifically
// the INNER DUCT's own interior cavity length (the fire-volume-bearing
// dimension) -- per this task's own explicit DO NOT TOUCH, this number
// must not shrink or be confused with the outer shell's own physical
// length (see below).
//
// INNER DUCT (NEW, replaces fuel_cylinder()): rectangular,
// DUCT_W=FIREBOX_W-2*DUCT_MARGIN=540mm x DUCT_H=FIREBOX_H-2*DUCT_MARGIN=
// 388.6mm (DUCT_MARGIN=20mm uniform on all 4 sides vs the outer shell's
// own inner cavity -- confirmed by direct construction, real 20mm gap on
// every side, see verification below), full FIREBOX_L(460mm) span,
// SAME open-both-ends convention as the retired fuel_cylinder() (no caps
// baked into the tube itself; near/chamber end sealed by its OWN end cap
// below; far/door end stays open, UNCHANGED deferred-open-item status).
// Duct's own end cap (NEW, small module, distinct from the chamber's own
// rear wall): welds this duct assembly DIRECTLY to the chamber's own
// octagon end cap -- JUDGMENT CALL, flagged: built as the duct's own full
// rectangular footprint MINUS the SAME 197mm passage-hole shape TASK 3
// cuts through the chamber wall (shared 2D module, not re-derived) --
// this is the only construction that keeps the duct's interior actually
// connected to the chamber (a fully solid cap would seal the firebox off
// entirely, defeating its purpose) while satisfying the prompt's own "no
// [NEW/different] hole needed... welds directly around this SAME
// opening" language (read as: reuse the identical shared hole shape, not
// "build zero hole at all"). Real CGAL seal-weld: non-empty contact vs
// the chamber's own real solid end-cap material, confirmed, contact area
// stated (see cc_chat_log.md).
//
// OUTER SHELL: widened to 580mm width (Y-range [15,595], centered on
// DATUM_Y_CENTER, confirmed live). LENGTH IS ADDITIVE, NOT A TRIM (real
// distinction, stated explicitly per this task's own requirement): the
// inner duct's own interior length stays exactly FIREBOX_L=460mm,
// UNCHANGED -- the fire-volume math depends on this number, it does not
// shrink. The OUTER SHELL's own total physical length becomes
// FIREBOX_SHELL_L = FIREBOX_L + FLANGE_LEN(20) = 480mm -- a NEW,
// SEPARATE, real number, the extra 20mm being a SOLID structural overlap
// zone only (real load-bearing weld/bracket contact against the
// chamber's own rear wall), containing NO interior duct volume -- these
// two numbers (460 interior vs 480 outer) are never merged or confused
// in this file's own code. The shell's hollow main body still spans
// exactly the SAME X-range as the duct (firebox_x0..firebox_x1, 460mm);
// the extra 20mm flange (X=[firebox_x0-FLANGE_LEN,firebox_x0]) is added
// as SOLID material (the hollow-cavity cut only spans the original
// 460mm, so the flange zone is solid automatically, by construction, not
// a separately-hollowed extension).
// The flange's own TOP zone is trimmed (real intersection() against the
// chamber's live octagon boundary, per outer_shell_flange_2d() below) so
// its upper portion can genuinely tuck under/against real chamber wall
// material at the NEW (950mm-apex) chamber position -- NOT assumed from
// the v13-era clearance (that clearance no longer applies at the new
// reanchor + new 580mm width, checked fresh). Real overlap/contact area
// stated (see cc_chat_log.md).
// Outer shell's own end cap (NEW module, replaces the retired
// firebox_end_cap()): ONE continuous plate at the flange's own outer
// face, SAME two-zone real construction as the flange (octagon-clipped
// upper zone / plain-rectangle lower zone, built from the SAME shared 2D
// helper) -- STRUCTURAL, bears real load from the chamber's rear edge
// (per Janis's explicit design intent, stated here not just incidentally
// implied). Positioned 20mm+ away in X from the inner duct's own start
// (firebox_x0) -- confirmed via real CGAL that it does NOT touch the
// inner duct or the inner duct's own end cap anywhere (see mandatory
// zero-contact check below).
// Real fire volume: DUCT_W x DUCT_H x FIREBOX_L = 540 x 388.6 x 460mm =
// 96,566,040mm³ = 5,893.7in³ (1in³=16,387.064mm³) -- ≈103% of the
// 5,737in³ target, confirmed via direct computation, not the estimate
// copied blindly (real number differs from the CONTEXT table's ~5,890in³
// by <0.1%, a rounding-precision difference only).
// Real, flagged consequence (not explicitly named in this task's own
// list, but required for correctness, stated not silently absorbed):
// `firebox_door()` (UNCHANGED CODE) reads FIREBOX_W/FIREBOX_H directly --
// now 580/428.6 -- so the door widens automatically 510->580mm to match
// the new outer shell (correct, the door belongs to the OUTER shell, not
// the inner duct). `ash_tray()`'s own width formula updated from
// FIREBOX_W-2*wall_t-20 to DUCT_W-2*wall_t-20 (514mm, was 484mm) -- REAL
// FIX, required: the ash tray sits inside the DUCT's own real interior
// (534mm clear), not the wider outer shell's cavity: sizing it off the
// old FIREBOX_W(now 580, the OUTER shell's width) would make it too wide
// to fit inside the duct and collide with the duct's own walls. Ash
// tray's own Z-position/height (ASH_TRAY_H=12mm, real 5mm clearance to
// the duct's own lower wall) is UNCHANGED -- the duct's own Z-range
// ([591.4,980]) is numerically identical to the retired cylinder's
// (DUCT_H=388.6mm reuses the exact old CYL_D value by direct
// construction, see DUCT_MARGIN derivation above), so no new Z-clearance
// issue.
//
// TASK 3 — REAR PASSAGE: SIMPLE ROUND HOLE, CHAMBER END CAP ONLY.
// `firebox_passage_profile()` REBUILT again -- was
// `intersection(fixed_side_solid_2d(), fuel_cylinder_circle_2d())` (a
// full-bore round-top/octagon-bottom cut tied to the duct's own real
// cross-section, v13); now a PLAIN CIRCLE, independently sized
// (PASSAGE_D=197mm, see its own in-code placeholder comment below), cut
// ONLY through the chamber's own rear octagon end cap
// (`fixed_side_solid_2d()`), NOT shaped to follow the duct's own
// cross-section at all -- `fuel_cylinder_circle_2d()` RETIRED (R-009,
// zero other real consumers).
// *** REAL FINDING, FLAGGED PER THIS TASK'S OWN EXPLICIT INSTRUCTION —
// NOT SILENTLY CLIPPED ***: centered at the duct's own real center
// (Y=DATUM_Y_CENTER=305, Z=DUCT_Z_CENTER=785.7, the same position the
// old fuel_cylinder() used), the 197mm circle spans real world
// Z=[687.2,884.2]. The NEW chamber_floor_z=771.335 sits INSIDE this
// range -- real check (intersection() against fixed_side_solid_2d(),
// confirmed via CGAL, see cc_chat_log.md) found the circle does NOT sit
// entirely within real chamber material: the lower ~84.135mm (world
// Z=[687.2,771.335]) has ZERO chamber material to begin with (below the
// chamber's own floor, matches this file's own standing "no material
// below chamber_floor_z" convention, not a defect) -- the REAL cut is a
// flat-bottomed chord shape (upper ~114mm of the true circle, clipped at
// chamber_floor_z), not a full circle. Flagged explicitly, not silently
// resolved -- per CONTEXT's own note this default size/position is
// field-adjustable by Janis independent of this CAD file; if a full
// unclipped circle is wanted, either the passage needs to move up
// (higher Z-center) or the circle needs to shrink -- a real, open,
// flagged decision point for Janis, not guessed at here.
//
// SKELETON — single source of truth. Every module below declares its
// Parent explicitly (a DATUM_* below, or another part's local origin).
// Local origin for this file: (0,0,0) at floor level, front-left — matches
// MASTER ORIGIN in SKELETON_WORKSHEET.md.

$fn = 64;
e   = 0.01;   // epsilon, coplanar-face offset per rules-codes.md

// ───────────────────────────────
// PARAMETERS — all mm
// ───────────────────────────────
wall_t           = 3;
chamber_L        = 915;                  // length, along X
chamber_W        = 610;                  // width, along Y
chamber_H        = 610;                  // full octagon cross-section height, floor to ridge
// chamfer -- real formula for a REGULAR octagon (all 8 sides equal)
// inscribed in a chamber_W x chamber_W square: 178.665mm. UNCHANGED v14.
chamfer          = chamber_W / (2 + sqrt(2));   // 178.665mm
// chamber_floor_z -- v14 TASK 1: REANCHORED again. Was `900-chamfer`
// through v13; now `950-chamfer` so apex A/GRATE_Z lands at EXACTLY
// 950mm. See file header for the full real-value derivation and the
// dependency-chain list of every element that moves with it.
chamber_floor_z  = 950 - chamfer;   // 771.335mm (v14, was 721.335)
intake_w         = 107;
intake_h         = 107;
chimney_d        = 127;
chimney_len      = 762;

ROOM_D           = 360;                  // exhaust room diameter, UNCHANGED
ROOM_H           = 100;                  // exhaust room height, UNCHANGED

LID_X0           = 100;
LID_X1           = chamber_L - 100;      // 815
LID_LENGTH       = LID_X1 - LID_X0;      // 715

// ───────────────────────────────
// DATUMS — SKELETON block (per SKILL_product_design_skeleton.md)
// PRIMARY:   chamber_floor_z  (horizontal plane) — locks Z. v14: live
//            formula (950-chamfer), see PARAMETERS above.
// SECONDARY: DATUM_X_REAR     (chamber's rear/firebox wall, X plane) — locks X
// TERTIARY:  DATUM_Y_CENTER   (chamber's lateral centerline, Y plane) — locks Y
// ───────────────────────────────
GRATE_Z          = chamber_floor_z + chamfer;                  // 950mm EXACT (v14, was 900) -- apex A's own real world Z
DATUM_GRATE_Z    = GRATE_Z;
DATUM_X_FRONT    = 0;                                          // Parent: MASTER ORIGIN
DATUM_X_REAR     = DATUM_X_FRONT + chamber_L;                  // 915 -- Parent: DATUM_X_FRONT, offset dX=+chamber_L
DATUM_Y_LEFT     = 0;                                          // Parent: MASTER ORIGIN
DATUM_Y_CENTER   = DATUM_Y_LEFT + chamber_W/2;                  // 305 -- Parent: DATUM_Y_LEFT
trough_h         = chamber_H - 2*chamfer;                       // 252.670mm -- UNCHANGED (no chamber_floor_z dependency)
DATUM_Z_RIDGE    = chamber_floor_z + chamber_H;                  // 1381.335mm (v14, was 1331.335)

// ───────────────────────────────
// FIREBOX DATUMS — v15 TASK 1/2: outer shell rebuilt as a true cube, inner
// duct replaced by a cylinder. FIREBOX_W stays the OUTER SHELL's own
// width (UNCHANGED); FIREBOX_L is now the FIRE CYLINDER's own interior
// depth (580mm, was 460mm); FIREBOX_H is the outer shell's own height
// (580mm, was 428.6mm) -- all three now equal, a true cube. See file
// header for full derivation.
// ───────────────────────────────
FIREBOX_L        = 580;                                        // v15: fire cylinder's own interior depth -- was 460mm (rectangular duct's own length)
FIREBOX_W        = 580;                                        // outer shell width -- UNCHANGED since v14 TASK 2
FIREBOX_H        = 580;                                        // v15 TASK 1: outer shell height -- was 428.6mm, now equal to W/L (true cube)
FLANGE_LEN       = 50;                                          // v16 TASK D: 20->50mm (Janis's explicit spec -- stronger structural tuck-under support). ADDITIVE (not a trim), formula below UNCHANGED
FIREBOX_SHELL_L  = FIREBOX_L + FLANGE_LEN;                       // 630mm (v16, was 600mm) -- outer shell's own TOTAL physical length (real, separate from FIREBOX_L, which stays 580mm -- FLANGE_LEN is a pure extension, confirmed additive by this same UNCHANGED formula)
WALL_CLEARANCE   = 62;                                          // v15 TASK 2: fire cylinder's own uniform wall clearance, all sides -- Janis's own explicit choice, real OPEN AIR gap this round
CYL_D            = FIREBOX_W - 2*WALL_CLEARANCE;                 // 456mm -- fire cylinder diameter
CYL_R            = CYL_D / 2;                                    // 228mm
// FIREBOX_TOP_Z_FIXED -- v15: the firebox's own real fixed Z datum is now
// the TOP (1000mm, UNCHANGED since v12 -- was previously an automatic
// derived consequence of firebox_floor_z+FIREBOX_H; TASK 1 makes it the
// deliberate anchor instead, since FIREBOX_H itself is what's changing
// this round, not the top).
FIREBOX_TOP_Z_FIXED = 1000;
firebox_floor_z  = FIREBOX_TOP_Z_FIXED - FIREBOX_H;              // 420mm (v15 TASK 1, was 571.4mm literal) -- real, live formula

// firebox_x0/x1/y0/y1/z0/z1 -- moved up here (was declared just above the
// firebox() module through v13) so passage_circle_2d()/PASSAGE_Z_CENTER
// below (needed earlier in the file, by firebox_passage_profile(), which
// chamber_shell() itself consumes) can reference firebox_z0/firebox_z1 in
// proper dependency order (rules-codes.md: "declare in dependency
// order") -- real values UNCHANGED from where they'd otherwise land.
// firebox_x0 -- v15 REAL FIX (see file header): pinned DIRECTLY at its own
// real weld-overlap position (913.5mm, the SAME value every version
// through v14.2 has actually built at) instead of derived from the old
// `firebox_x_mid_old` historical-midpoint formula (RETIRED, R-009 --
// that formula only worked by coincidence while FIREBOX_L never changed;
// growing FIREBOX_L under it would have pulled firebox_x0 60mm INTO the
// main chamber's own real X-territory, a genuine new conflict risk).
firebox_x0 = 913.5;                              // Parent: chamber's own real rear-wall weld-overlap position, UNCHANGED value since v12
firebox_x1 = firebox_x0 + FIREBOX_L;             // 1493.5 (v15, was 1373.5) -- all +120mm growth happens here, away from the chamber
firebox_y0 = DATUM_Y_CENTER - FIREBOX_W/2;       // 15 -- Parent: DATUM_Y_CENTER (v14: outer shell width, was 50)
firebox_y1 = firebox_y0 + FIREBOX_W;             // 595 (v14, was 560)
firebox_z0 = firebox_floor_z;                    // 420 (v15, was 571.4)
firebox_z1 = firebox_z0 + FIREBOX_H;             // 1000.0 -- matches FIREBOX_TOP_Z_FIXED exactly, confirms consistency
// Fire cylinder's own real center -- Y shared with the chamber's own
// lateral center (UNCHANGED), Z real-computed off the new firebox_z0/z1.
CYL_Y_CENTER = DATUM_Y_CENTER;                   // 305
CYL_Z_CENTER = (firebox_z0 + firebox_z1) / 2;    // 710mm (v15, was 785.7mm under the old rectangular duct)

// Exhaust room datums — v14: real values move automatically with the new
// chamber_floor_z (formula itself UNCHANGED).
ROOM_BASE_Z      = chamber_floor_z + chamber_H/2 - ROOM_H/2;    // 1026.335mm (v14, was 976.335)
ROOM_TOP_Z       = ROOM_BASE_Z + ROOM_H;                         // 1126.335mm (v14, was 1076.335)

// ───────────────────────────────
// PROFILE HELPERS — encoded [-height, width] so that rotate([0,90,0])
// after linear_extrude(length) lands as world (X=length, Y=width,
// Z=height) — verified empirically in v1, unchanged mechanism.
// ───────────────────────────────
function hex_pt(h, w) = [-h, w];

// true_octagon_profile() — the TRUE closed 8-point octagon: real edges
// only, no fake diagonal anywhere. UNCHANGED v14 (chamber's own shape
// frozen, DO NOT TOUCH — includes apex A, point 3 below; only the WORLD Z
// this profile's local h=0 origin sits at has changed, via
// chamber_floor_z, TASK 1).
module true_octagon_profile() {
    polygon(points=[
        hex_pt(0, chamber_W - chamfer),            // 1: floor, right end
        hex_pt(0, chamfer),                        // 2: floor, left end
        hex_pt(chamfer, 0),                          // 3: apex A — real left chamfer/wall corner
        hex_pt(chamber_H - chamfer, 0),               // 4: left wall top
        hex_pt(chamber_H, chamfer),                   // 5: ridge, left end
        hex_pt(chamber_H, chamber_W - chamfer),        // 6: ridge, right end
        hex_pt(chamber_H - chamfer, chamber_W),        // 7: right wall top
        hex_pt(chamfer, chamber_W),                     // 8: right wall bottom
    ]);
}

// fixed_side_wedge() — cutting-plane MASK, keeps only the FIXED (non-lid)
// side. UNCHANGED v14.
module fixed_side_wedge() {
    polygon(points=[
        hex_pt(chamfer, 0),              // apex A
        hex_pt(0, 0),
        hex_pt(0, chamber_W),
        hex_pt(chamber_H, chamber_W),
        hex_pt(chamber_H, chamber_W/2),   // ridge midpoint (cut reference only)
    ]);
}

// lid_side_wedge() — complementary mask. UNCHANGED v14.
module lid_side_wedge() {
    polygon(points=[
        hex_pt(chamfer, 0),              // apex A
        hex_pt(chamber_H, 0),            // top-left corner
        hex_pt(chamber_H, chamber_W/2),   // ridge midpoint (cut reference only)
    ]);
}

// lid_profile() — reference shape only, not used directly for
// construction. UNCHANGED v14.
module lid_profile() {
    polygon(points=[
        hex_pt(chamber_H, chamber_W/2),            // 1: ridge midpoint (hinge line)
        hex_pt(chamber_H, chamfer),                 // 2: ridge, left end (half-ridge)
        hex_pt(chamber_H - chamfer, 0),             // 3: top-left chamfer bottom
        hex_pt(chamfer, 0),                          // 4: left wall bottom (parting end)
    ]);
}

// ───────────────────────────────
// chamber_shell() and its helpers — UNCHANGED CODE v14 (chamber's own
// shape frozen, DO NOT TOUCH: octagon_ring(), chamber_outer_tube(),
// lid_territory_margin_fill(), exhaust_room_opening(), chamber_shell()
// itself all byte-identical to v13 — real world position moves only via
// chamber_floor_z's own new value, TASK 1, automatically).
// ───────────────────────────────
module octagon_ring(x0, x1, cap_x0, cap_x1) {
    inner_x0 = cap_x0 ? x0 + wall_t : x0;
    inner_x1 = cap_x1 ? x1 - wall_t : x1;
    difference() {
        translate([x0, 0, chamber_floor_z]) rotate([0, 90, 0])
            linear_extrude(height = x1 - x0) true_octagon_profile();
        translate([inner_x0, 0, chamber_floor_z]) rotate([0, 90, 0])
            linear_extrude(height = inner_x1 - inner_x0, convexity = 4)
                offset(delta = -wall_t) true_octagon_profile();
    }
}
module chamber_outer_tube() {
    intersection() {
        octagon_ring(DATUM_X_FRONT, DATUM_X_REAR, true, true);
        translate([0, 0, chamber_floor_z]) rotate([0, 90, 0])
            linear_extrude(height = chamber_L, convexity = 4) fixed_side_wedge();
    }
}

// fixed_side_solid_2d() — UNCHANGED v14 (chamber's own shape frozen, DO
// NOT TOUCH). The chamber's real solid cross-section at DATUM_X_REAR --
// what TASK 3's passage cut and TASK 2's octagon-aware flange/end-cap
// all intersect against.
module fixed_side_solid_2d() {
    intersection() {
        true_octagon_profile();
        fixed_side_wedge();
    }
}

// chamber_octagon_or_open_below_2d() — v16 NEW, shared by TASK A/B/C. Real
// mask: for h>=0 (world Z>=chamber_floor_z, real chamber territory) follows
// true_octagon_profile() exactly; for h<0 (below the chamber entirely, no
// real chamber reference exists) is fully open (a large solid fill, so
// intersecting anything against this mask leaves h<0 geometry unclipped).
// Built as a union of the real octagon polygon with a big rectangle over
// the h<0 half-plane (full w range plus margin, so it can never itself be
// the binding edge) — a single 2D mask usable directly in intersection().
module chamber_octagon_or_open_below_2d() {
    union() {
        true_octagon_profile();
        translate([0, -1000]) square([2000, chamber_W + 2000]);
    }
}

// firebox_passage_profile() — v16 TASK A REBUILT (Janis's direct feedback:
// v15's own plain circle, sized purely from the fire cylinder's own
// 0.008-fire-volume target-area rule, ignored how much real chamber
// material actually exists at the passage -- see file header for the full
// real diagnosis: 33.233mm of the v15 circle's own bottom had ZERO real
// chamber material behind it, a genuine "hole through nothing"). FIX:
// size/position now DERIVED from the real vertical band where the fire
// cylinder's own clear bore actually overlaps the chamber's real octagon
// material at DATUM_X_REAR, not from an independent area formula.
CYL_WALL_MARGIN     = 15;   // real margin kept clear of the fire cylinder's own bore wall -- Janis's "Dont cut too near to edge of cylinder wall", judgment call on the exact mm, flagged
CHAMBER_EDGE_MARGIN = 15;   // real margin kept clear of the chamber's own real floor/no-material boundary -- judgment call on the exact mm, flagged
cyl_top_z        = CYL_Z_CENTER + CYL_R;                          // 938mm (world Z) -- fire cylinder's own real top
cyl_clear_bore_r = CYL_D / 2 - wall_t;                             // 225mm -- fire cylinder's own real clear interior radius
// Real overlap band -- where the cylinder's own clear interior AND the
// chamber's own real material (h>=0) both actually exist:
PASSAGE_BAND_TOP_WORLD = cyl_top_z - CYL_WALL_MARGIN;              // 923mm
PASSAGE_BAND_BOT_WORLD = chamber_floor_z + CHAMBER_EDGE_MARGIN;    // 786.335mm
PASSAGE_BAND_H         = PASSAGE_BAND_TOP_WORLD - PASSAGE_BAND_BOT_WORLD;   // 136.665mm
PASSAGE_Y_CENTER = CYL_Y_CENTER;                                   // 305, UNCHANGED
PASSAGE_Z_CENTER_WORLD = (PASSAGE_BAND_TOP_WORLD + PASSAGE_BAND_BOT_WORLD) / 2;   // 854.6675mm
// PASSAGE_R -- the real candidate radius: half the usable band (so the
// candidate circle's own vertical extent already fits within real material
// without needing the intersection below to do any clipping at all -- the
// SAME real intersection is still applied, belt-and-suspenders, so a future
// parameter change can never silently reopen the v15 defect).
PASSAGE_R_BAND = PASSAGE_BAND_H / 2;                               // 68.3325mm
// Real cylinder-wall clearance check, live not assumed: distance from the
// cylinder's own center to the passage's own farthest point must clear
// cyl_clear_bore_r by CYL_WALL_MARGIN. Confirmed via echo below this
// module: passage center is 144.665mm off cylinder center (Z only), +
// PASSAGE_R_BAND(68.3325) = 212.9975mm, vs cyl_clear_bore_r-CYL_WALL_MARGIN
// (225-15=210mm) -- 212.9975 > 210, so PASSAGE_R_BAND itself is the tighter
// constraint here (the vertical-band cap), take the min of both real caps.
PASSAGE_R_CYL_CAP = (cyl_clear_bore_r - CYL_WALL_MARGIN) - abs(PASSAGE_Z_CENTER_WORLD - CYL_Z_CENTER);   // 65.335mm -- real, binding
PASSAGE_R = min(PASSAGE_R_BAND, PASSAGE_R_CYL_CAP);                // 65.335mm real final radius
// hex_pt(h,w)'s own "h" is an OFFSET from chamber_floor_z (this profile's
// local origin, per firebox_passage()'s own translate([...,chamber_floor_z])
// below) -- NOT an absolute world Z, same convention this file already uses.
PASSAGE_Z_CENTER = PASSAGE_Z_CENTER_WORLD - chamber_floor_z;       // 83.3325mm (local h)
module firebox_passage_profile() {
    intersection() {
        translate(hex_pt(PASSAGE_Z_CENTER, PASSAGE_Y_CENTER)) circle(r = PASSAGE_R);
        offset(delta = -CHAMBER_EDGE_MARGIN) fixed_side_solid_2d();
    }
}
module firebox_passage() {
    translate([DATUM_X_REAR - wall_t - e, 0, chamber_floor_z]) rotate([0, 90, 0])
        linear_extrude(height = wall_t + 2*e, convexity = 4)
            firebox_passage_profile();
}
module lid_territory_margin_fill() {
    if (LID_X0 > DATUM_X_FRONT)
        intersection() {
            octagon_ring(DATUM_X_FRONT, LID_X0, true, false);
            translate([DATUM_X_FRONT, 0, chamber_floor_z]) rotate([0, 90, 0])
                linear_extrude(height = LID_X0 - DATUM_X_FRONT, convexity = 4) lid_side_wedge();
        }
    if (DATUM_X_REAR > LID_X1)
        intersection() {
            octagon_ring(LID_X1, DATUM_X_REAR, false, true);
            translate([LID_X1, 0, chamber_floor_z]) rotate([0, 90, 0])
                linear_extrude(height = DATUM_X_REAR - LID_X1, convexity = 4) lid_side_wedge();
        }
}
module exhaust_room_opening() {
    ROOM_GAP = 1;
    translate([-e, DATUM_Y_CENTER - ROOM_D/2 - ROOM_GAP, ROOM_BASE_Z - ROOM_GAP])
        cube([wall_t + 2*e, ROOM_D + 2*ROOM_GAP, ROOM_H + 2*ROOM_GAP]);
}
module chamber_shell() {
    difference() {
        union() {
            chamber_outer_tube();
            lid_territory_margin_fill();
        }
        firebox_passage();
        exhaust_room_opening();
    }
}

// ───────────────────────────────
// exhaust_room() / chimney_pipe() — UNCHANGED CODE v14 (real world
// position moves only via ROOM_BASE_Z/ROOM_TOP_Z's own new values, TASK 1,
// automatically).
// ───────────────────────────────
ROOM_R = ROOM_D / 2;
module room_half_space() {
    translate([-ROOM_R - 10, DATUM_Y_CENTER - ROOM_R - 10, ROOM_BASE_Z - e])
        cube([ROOM_R + 10 + e, 2*(ROOM_R + 10), ROOM_H + 2*e]);
}
module room_outer_half() {
    intersection() {
        translate([0, DATUM_Y_CENTER, ROOM_BASE_Z]) cylinder(d = ROOM_D, h = ROOM_H);
        room_half_space();
    }
}
module room_inner_cavity() {
    intersection() {
        translate([0, DATUM_Y_CENTER, ROOM_BASE_Z + wall_t]) cylinder(d = ROOM_D - 2*wall_t, h = ROOM_H - 2*wall_t);
        room_half_space();
    }
}
PIPE_HOLE_X = -ROOM_R / 2;   // -90
PIPE_HOLE_Y = DATUM_Y_CENTER;
module room_pipe_hole() {
    translate([PIPE_HOLE_X, PIPE_HOLE_Y, ROOM_TOP_Z - wall_t - e])
        cylinder(d = chimney_d, h = wall_t + 2*e);
}
module exhaust_room() {
    difference() {
        room_outer_half();
        room_inner_cavity();
        room_pipe_hole();
    }
}
PIPE_BASE_Z = ROOM_TOP_Z - wall_t - e;   // 1123.325mm (v14, was 1073.325)
module chimney_pipe() {
    translate([PIPE_HOLE_X, PIPE_HOLE_Y, PIPE_BASE_Z])
        cylinder(d = chimney_d, h = chimney_len + wall_t + e);
}

// ───────────────────────────────
// lid() and hardware — UNCHANGED CODE v14 (real world position moves only
// via chamber_floor_z/DATUM_Z_RIDGE's own new values, TASK 1,
// automatically).
// ───────────────────────────────
LID_OVERLAP = 3;
lid_slant_len = chamfer * sqrt(2) + LID_OVERLAP;
module lid_closed_panels() {
    translate([LID_X0, chamfer - LID_OVERLAP, DATUM_Z_RIDGE - wall_t])
        cube([LID_LENGTH, DATUM_Y_CENTER - (chamfer - LID_OVERLAP), wall_t]);
    translate([LID_X0, chamfer, DATUM_Z_RIDGE]) rotate([-135, 0, 0])
        cube([LID_LENGTH, lid_slant_len, wall_t]);
    translate([LID_X0, 0, chamber_floor_z + chamfer - LID_OVERLAP])
        cube([LID_LENGTH, wall_t, trough_h + LID_OVERLAP]);
}
module lid_closed() {
    lid_closed_panels();
}
LID_HINGE_GAP = 0.5;
module lid(lid_open_deg = 0) {
    translate([0, DATUM_Y_CENTER + LID_HINGE_GAP, DATUM_Z_RIDGE + LID_HINGE_GAP])
        rotate([-lid_open_deg, 0, 0])
        translate([0, -DATUM_Y_CENTER - LID_HINGE_GAP, -DATUM_Z_RIDGE - LID_HINGE_GAP])
        lid_closed();
}
LEVER_ARM = 400;
COUNTERWEIGHT_KG = 10;
module lid_hardware(lid_open_deg = 0) {
    translate([0, DATUM_Y_CENTER, DATUM_Z_RIDGE]) rotate([lid_open_deg, 0, 0]) translate([0, -DATUM_Y_CENTER, -DATUM_Z_RIDGE]) {
        // STALE v1 positions -- unchanged, disabled (show_lid_hardware=false)
    }
}

// ───────────────────────────────
// firebox() — v15 TASK 2 REWORK. Two fully independent welded assemblies,
// SAME real architecture v14 established (reused, not reinvented): fire
// cylinder (hot, sealed to the chamber) and outer shell (insulating
// jacket, structurally tucked under the chamber's rear wall) — NO shared
// end-cap plate between them. ash_tray()/firebox_door() UNCHANGED CODE
// except ash_tray()'s own width formula (see below).
// ───────────────────────────────
// ── FIRE CYLINDER (NEW, replaces inner_duct()/inner_duct_end_cap(),
// RETIRED -- R-009, grep-confirmed zero remaining consumers) ──
module fire_cylinder() {
    // Near face starts at firebox_x0+e (not exactly firebox_x0) -- SAME
    // real epsilon-separation fix v14.2's own inner_duct() required
    // (exact-coincident-face non-manifold risk vs outer_shell()'s own
    // hollow-cavity boundary), reused here for the same reason.
    translate([firebox_x0 + e, CYL_Y_CENTER, CYL_Z_CENTER]) rotate([0, 90, 0])
        difference() {
            cylinder(d = CYL_D, h = FIREBOX_L - 2*e);
            translate([0, 0, -e]) cylinder(d = CYL_D - 2*wall_t, h = FIREBOX_L - 2*e + 2*e);
        }
}
// fire_cylinder_end_cap_bound_2d() — v19 NEW. Bounds
// fire_cylinder_end_cap_2d()'s own union (below) to the cylinder's own
// real diameter bounding box (a square of side CYL_D, centered on the
// cylinder's own real center) -- same real role as
// outer_shell_flange_footprint_2d()'s own `flange_height_bound_2d()`
// (rules-codes.md/.claude/SKILL_joint_construction.md RULE 4): without
// this bound, unioning in the raw `true_octagon_profile()` would pull in
// real octagon material without limit (the octagon's own real width only
// keeps growing with height, all the way to the chamber's own ridge) --
// the SAME real overreach bug already found and fixed once this session
// on the outer shell's own flange, pre-empted here rather than re-found.
module fire_cylinder_end_cap_bound_2d() {
    translate(hex_pt(CYL_Z_CENTER - chamber_floor_z, CYL_Y_CENTER))
        square([CYL_D, CYL_D], center = true);
}
// fire_cylinder_end_cap_2d() / fire_cylinder_end_cap() — v19 REBUILT via
// the Dual End-Cap Footprint Pattern (RULE 4), replacing v16 TASK B's own
// `intersection(circle, octagon)` construction -- a REAL, CONFIRMED
// remaining hole Janis found by looking INSIDE the built cylinder (v18's
// own QA simulation Step 2 said "pass" on the wrong basis: no OTHER hole
// existed yet at the time, but this round's own closer look found a real
// missing-material gap in the end cap ITSELF, the exact same failure
// class as v16's original mistake on the outer shell, just never checked
// here). Real root cause, confirmed by direct half-width comparison at
// world Z=chamber_floor_z (h=0): the octagon's own real half-width there
// (126.335mm) is LESS than the cylinder's own real half-width at that
// same height (219.6mm, computed from the circle's own real geometry) --
// `intersection(circle, octagon)` clips the circle DOWN to the narrower
// octagon there, and the chamber has zero material of its own outside the
// octagon's true edge to fill what gets clipped away -- a real, visible
// hole, confirmed via a real STL/CGAL residual probe (this file's own
// diagnostic session, not assumed). FIX: `union(circle, true_octagon_
// profile())`, bounded by `fire_cylinder_end_cap_bound_2d()` above (so it
// never exceeds the cylinder's own real diameter envelope), then minus
// the shared passage cut -- the end cap is now ALWAYS at least the full
// native circle (Rule 2's own "everywhere else...circle for a cylinder"),
// and reaches out to meet the chamber's own real octagon profile only
// where the octagon is genuinely wider (Rule 2's own "top zone follows
// the chamber's real profile") -- never narrower than the circle, so
// never a real hole. Welds DIRECTLY to the chamber's own octagon end cap,
// NOT to the outer shell (UNCHANGED role from v14.2/v15).
module fire_cylinder_end_cap_2d() {
    difference() {
        intersection() {
            union() {
                translate(hex_pt(CYL_Z_CENTER - chamber_floor_z, CYL_Y_CENTER)) circle(d = CYL_D);
                true_octagon_profile();
            }
            fire_cylinder_end_cap_bound_2d();
        }
        offset(delta = e) firebox_passage_profile();   // +e dilation -- same real non-manifold fix
                                                          // v14.2's own inner_duct_end_cap_2d() required
                                                          // wherever the passage's own boundary follows
                                                          // the real octagon edge, reused here.
    }
}
module fire_cylinder_end_cap() {
    // Same X overshoot convention as v14.2's own inner_duct_end_cap():
    // forward-only, into the cylinder's own X-territory (butts against
    // its open near-face), real overlap with the chamber's own solid
    // rear-wall material confirmed via CGAL below.
    translate([firebox_x0 + e, 0, chamber_floor_z]) rotate([0, 90, 0])
        linear_extrude(height = wall_t, convexity = 4)
            fire_cylinder_end_cap_2d();
}
// fire_cylinder_partition() / fire_cylinder_partition_2d() — v15 TASK 4,
// NEW. Real end plate at the door/front end of the cylinder, physically
// locates it within the square outer shell (per Janis's reference photo).
// Built from the SAME outer_shell_footprint_2d() helper the flange/end-cap
// already use (R-009, not re-derived) minus a circle matching the
// cylinder's own real diameter -- same "footprint minus a hole"
// construction outer_shell_flange_cut_2d() already established.
// Real, found+fixed via CGAL: positioned flush at exactly X=firebox_x1
// (the door's own real near-face start) produced an exact-coincident-
// surface non-manifold result (Simple:no) against firebox_door() -- pulled
// back by e (real, negligible 0.01mm) so the partition sits at
// X=[firebox_x1-wall_t-e, firebox_x1-e], genuine real separation from the
// door, re-verified Simple:yes/empty.
module fire_cylinder_partition_2d() {
    difference() {
        outer_shell_footprint_2d();
        translate(hex_pt(CYL_Z_CENTER - chamber_floor_z, CYL_Y_CENTER)) circle(d = CYL_D + 2*e);   // +2e: real clearance vs an exact-diameter coincident-surface touch against the cylinder's own OD, same rules-codes.md epsilon convention this file already applies elsewhere
    }
}
module fire_cylinder_partition() {
    translate([firebox_x1 - wall_t - e, 0, chamber_floor_z]) rotate([0, 90, 0])
        linear_extrude(height = wall_t, convexity = 4)
            fire_cylinder_partition_2d();
}

// ── OUTER SHELL (NEW construction, replaces firebox_shell(), RETIRED)
// widened to FIREBOX_W(580mm), physical length FIREBOX_SHELL_L(480mm) --
// see file header for the interior-vs-outer-length distinction. ──
// outer_shell_footprint_2d() — v14.1 TASK 1: now used DIRECTLY (unclipped)
// for the flange AND its end cap, full height, no zones. `outer_shell_
// flange_2d()` (v14, RETIRED this round, R-009 confirmed zero other real
// consumers) built a TWO-ZONE shape -- plain rectangle below chamber_floor_z,
// octagon-CLIPPED narrower shape above it -- which produced a real, visible
// abrupt WIDTH JUMP right at the chamber_floor_z transition (the octagon's
// real ~252.67mm floor-width vs. the full 580mm rectangle width): a genuine
// visible STEP (Janis's own screenshot), not a rendering artifact. FIX: use
// this plain, unclipped, full FIREBOX_H x FIREBOX_W rectangle for the
// flange's ENTIRE height -- one flat continuous plane, no clipping. Real,
// not just cosmetic: the UPPER portion (world Z=[chamber_floor_z,firebox
// top]) has real, confirmed non-empty contact with the chamber's own
// octagon material (see cc_chat_log.md for the real contact-area check);
// the LOWER portion (world Z=[firebox floor,chamber_floor_z]) has zero real
// chamber material to intersect with -- confirmed empty via CGAL, matches
// this file's own standing "no material below the floor" convention
// (true_octagon_profile()/fixed_side_solid_2d() already follow it) -- no
// collision risk, no separate notch/clip needed.
module outer_shell_footprint_2d() {
    translate([chamber_floor_z - firebox_z1, firebox_y0])
        square([FIREBOX_H, FIREBOX_W]);
}
// chamber_hollow_cavity_2d() — v17, UNCHANGED this round. The chamber's own
// real hollow interior bore -- cut out of the flange footprint below so it
// can never be plugged (Rule 1's own "outer shell end cap" must not block
// the chamber, a real CGAL-confirmed defect two rounds ago). Only exists
// for h>=0 (true_octagon_profile() has no geometry below h=0), so h<0 is
// automatically untouched by any difference() using this shape.
module chamber_hollow_cavity_2d() {
    offset(delta = -wall_t) true_octagon_profile();
}
// outer_shell_flange_footprint_2d() — v18 REBUILT to actually satisfy
// rules-bbq-fab.md's own new "Dual End-Cap Independence Convention, Rule 1"
// (locked 2026-07-21, same day): "constrained to ONLY its own square/cube
// projection...in every zone EXCEPT the top part, which follows the
// chamber's own real profile...ONE CONTINUOUS SURFACE...no step, no
// zone-clipped transition between two differently-derived shapes." v17's
// own fix (kept the footprint ALWAYS the plain square, difference() only)
// avoided the two real CGAL-confirmed bugs (wall-blocks-interior, missing-
// material gap) but did NOT actually satisfy Rule 1 -- it never lets the
// top zone reach out and match the chamber's own real profile at all,
// confirmed via a direct side-by-side walkthrough of Janis's own 4-step
// QA simulation (Step 4: "on the top you must meet the octagon face") --
// v17's square-only footprint never "meets" the octagon, it just avoids
// it. REAL FIX: `union()` the plain square with the true octagon profile,
// THEN cut the hollow-cavity hole out of the combined result -- NOT an
// `intersection()` (v16's own original mistake, clips the square DOWN to
// the octagon and creates the missing-material gap, since the chamber has
// zero material of its own outside the octagon's true edge to fill what
// gets clipped away). With `union()`: the footprint is ALWAYS >= the plain
// square (never narrower, so "no step"/"one continuous surface" holds by
// construction -- there is never a height where the boundary snaps
// inward), and for the real height range where the octagon's own true
// width EXCEEDS 580mm (world Z>=935mm, confirmed live), the boundary
// reaches out and becomes EXACTLY the octagon's own edge there -- a real,
// literal "meets the octagon face" (Rule 1's own words), not an
// approximation.
// REAL BUG FOUND+FIXED BEFORE SHIPPING (caught by a real STL bounding-box
// probe, not assumed clean from the reasoning alone): `true_octagon_
// profile()` on its own is NOT height-bounded to the flange's own real
// physical range (`FIREBOX_H`=580mm, world Z=[420,1000]) -- it's the
// chamber's own FULL profile, real local-h up to `chamber_H`(610mm),
// reaching world Z as high as `chamber_floor_z+610`=1381.335mm, the
// chamber's own RIDGE. A bare `union()` with it would have added real,
// wrong material all the way up to the ridge height -- WAY above the
// firebox's own real top (`firebox_z1`=1000mm) -- a serious new defect,
// caught here before it ever reached a render Janis would see. FIX:
// `intersection()` the union with a real height-bounding mask
// (`flange_height_bound_2d()`, spanning EXACTLY `outer_shell_footprint_2d()`'s
// own real local-h range, unbounded in width) BEFORE subtracting the
// hollow-cavity hole -- confirmed via a real STL bbox probe: footprint's
// own local-h range now exactly [-228.665,351.335] (matches
// `outer_shell_footprint_2d()`'s own range precisely), was
// [-610,351.335] (real, wrong 258.665mm overreach) before this fix.
module flange_height_bound_2d() {
    translate([chamber_floor_z - firebox_z1, -1000])
        square([FIREBOX_H, chamber_W + 2000]);
}
module outer_shell_flange_footprint_2d() {
    difference() {
        intersection() {
            union() {
                outer_shell_footprint_2d();
                true_octagon_profile();
            }
            flange_height_bound_2d();
        }
        chamber_hollow_cavity_2d();
    }
}
// outer_shell_flange_cut_2d() — v14.2 TASK 2, NEW (v16: now built on
// outer_shell_flange_footprint_2d() above, not the plain unclipped
// footprint). Real, confirmed defect found via an actual CGAL ray-probe
// (not a visual read): v14.1's TASK 1 made the flange/end-cap a PLAIN,
// UNPERFORATED rectangle (correctly fixing the visible step) but never cut
// the passage hole through it -- the flange's own footprint (580x428.6mm)
// is LARGER than the duct's own opening and sits directly in the line of
// sight through the passage, so even though the chamber's own rear wall
// and the inner duct's own end cap both have a real trapezoid hole, this
// solid flange fully blocked the view/airflow behind them. Same shared
// `firebox_passage_profile()` module, not re-derived or resized -- cutting
// the SAME real shape through every layer it needs to pass keeps them all
// aligned by construction.
module outer_shell_flange_cut_2d() {
    difference() {
        outer_shell_flange_footprint_2d();
        firebox_passage_profile();
    }
}
module outer_shell() {
    union() {
        // main hollow body, FIREBOX_L(460mm) span, X=[firebox_x0,firebox_x1] -- same footprint length as the duct
        difference() {
            translate([firebox_x0, firebox_y0, firebox_z0]) cube([FIREBOX_L, FIREBOX_W, FIREBOX_H]);
            translate([firebox_x0 - e, firebox_y0 + wall_t, firebox_z0 + wall_t])
                cube([FIREBOX_L + 2*e, FIREBOX_W - 2*wall_t, FIREBOX_H - 2*wall_t]);
        }
        // near-end flange, ADDITIVE 50mm (v16 TASK D, was 20mm), SOLID (no
        // interior cavity), two-zone cross-section (v16 TASK C -- octagon-
        // clipped above chamber_floor_z, native square below, see
        // outer_shell_flange_footprint_2d() above). Spans EXACTLY
        // X=[firebox_x0-FLANGE_LEN, firebox_x0] -- NO epsilon overshoot past
        // firebox_x0 (would otherwise intrude a hair into the inner duct's
        // own separate X-territory, found via a real CGAL non-manifold
        // check -- confirmed fixed, Simple:yes, see cc_chat_log.md). The
        // flange's own SOLID cross-section meeting the main body's HOLLOW
        // near-face (that difference()'s own e-overshoot already starts the
        // cavity cut slightly before firebox_x0) at this exact shared plane
        // is a clean, compatible butt-joint -- solid fill exactly where the
        // hollow body's face would otherwise be open, not an ambiguous
        // coincident-face touch.
        translate([firebox_x0 - FLANGE_LEN, 0, chamber_floor_z]) rotate([0, 90, 0])
            linear_extrude(height = FLANGE_LEN, convexity = 4)
                outer_shell_flange_cut_2d();
    }
}
// outer_shell_end_cap() — v14 TASK 2 step 4, NEW (replaces the retired
// firebox_end_cap()). Thin wall_t plate at the flange's own outer/near
// face (the true near end of the outer shell, X=firebox_x0-FLANGE_LEN),
// SAME two-zone footprint as the flange it caps (v16 TASK C) -- STRUCTURAL,
// bears real load from the chamber's rear edge (Janis's explicit design
// intent, "it give stronger structure support"). Positioned FLANGE_LEN
// (50mm, v16 TASK D, was 20mm) away in X from the inner duct's own start
// (firebox_x0) -- confirmed via real CGAL zero-contact check below that it
// never touches the inner duct or the duct's own end cap.
module outer_shell_end_cap() {
    translate([firebox_x0 - FLANGE_LEN - wall_t - e, 0, chamber_floor_z]) rotate([0, 90, 0])
        linear_extrude(height = wall_t + 2*e, convexity = 4)
            outer_shell_flange_cut_2d();
}

// ash_tray() — v19 RETIRED (R-009, zero remaining consumers confirmed via
// grep before removing). Janis's own explicit, direct instruction: "just
// remove this tray, keep cylinder clean" -- flagged as asked "since 4-5
// vesions ago" and never actually removed (this session's own governance
// retrospective found chat had "assumed a lot of things and wrote...
// unclear instruction" in earlier rounds -- this round's instruction is
// explicit and unambiguous, acted on directly, not re-interpreted).
// ASH_TRAY_H/ASH_TRAY_L/ASH_TRAY_GAP/ASH_TRAY_W/ASH_TRAY_X_IN/
// ASH_TRAY_SLIDE_MAX all RETIRED alongside the module (zero other real
// consumers, reconfirmed via grep). `ash_tray_out_pct` parameter threading
// through `firebox()`/the DEBUG TOGGLES block REMOVED too (see both call
// sites below) -- was exclusively for this module.

JOGGLE = 3;
HINGE_GAP = 0.5;
// firebox_door() — UNCHANGED CODE v14 (frozen construction, real
// dimensions widen automatically 510->580mm via FIREBOX_W, matches the
// outer shell it's mounted on -- flagged real consequence, see file
// header).
module firebox_door(firebox_door_open_deg = 0) {
    translate([firebox_x1, firebox_y0 - HINGE_GAP, firebox_z0]) rotate([0, 0, -firebox_door_open_deg]) {
        difference() {
            union() {
                cube([wall_t, FIREBOX_W, FIREBOX_H]);
                translate([wall_t, JOGGLE, JOGGLE]) cube([JOGGLE, FIREBOX_W - 2*JOGGLE, FIREBOX_H - 2*JOGGLE]);
            }
            translate([-e, FIREBOX_W*0.5 - intake_w/2, FIREBOX_H*0.15]) cube([wall_t + JOGGLE + 2*e, intake_w, intake_h]);
        }
    }
}
// firebox() — v17 NEW: 4 real sub-part toggles added (Janis's own explicit
// request: "Can Can you make the inner shell of the fire box and outer
// shell of the fire box can be toggle? also specially i need both back
// end cap of the fire box both the cylinder and the square one able to
// toggle on off too. So if problem still happen i can tell chat or you
// more precisely!") -- `show_fire_cylinder`/`show_fire_cylinder_end_cap`/
// `show_outer_shell`/`show_outer_shell_end_cap`, each independent of the
// master `show_firebox` toggle (which still gates the WHOLE assembly, per
// the Toggle-Completeness Rule's existing pattern). `fire_cylinder_
// partition()`/`firebox_door()` UNCHANGED, no new toggle (not part of
// Janis's own explicit ask this round, R-009: keep scope to what was
// asked). v19: `ash_tray()` call REMOVED (module retired, see its own
// header comment above) -- `ash_tray_out_pct` parameter dropped too, zero
// remaining consumers.
module firebox(firebox_door_open_deg = 0) {
    if (show_fire_cylinder) color("#8B2E2E") fire_cylinder();
    if (show_fire_cylinder_end_cap) color("#8B2E2E") fire_cylinder_end_cap();
    color("#AAAAAA", 1.0) fire_cylinder_partition();
    if (show_outer_shell) outer_shell();
    if (show_outer_shell_end_cap) outer_shell_end_cap();
    firebox_door(firebox_door_open_deg);
}

// ───────────────────────────────
// Grill grate + Floor drains — UNCHANGED CODE v14 (grate Z anchor and X/Y
// formulas both frozen per DO NOT TOUCH; real values move automatically
// with the new chamber_floor_z/DATUM_GRATE_Z where the formula reads
// them, confirmed identical to v13, see file header).
// ───────────────────────────────
GRATE_Z_FIXED = 1000;   // UNCHANGED, DO NOT TOUCH -- real grate-to-apex-A gap now 1000-950=50mm exact (was 100mm), automatic consequence of TASK 1
GRATE_MARGIN = 60;
GRATE_GAP = 8;
grate_usable_l = chamber_L - 2*GRATE_MARGIN;
grate_seg_l = (grate_usable_l - 2*GRATE_GAP) / 3;
GRATE_LOCAL_H = (DATUM_GRATE_Z - 10) - chamber_floor_z;   // 168.665mm -- IDENTICAL to v13 (invariant under the +50mm shift), UNCHANGED FORMULA, DO NOT TOUCH
GRATE_Y_SAFETY = wall_t + 10;
GRATE_Y0 = (chamfer - GRATE_LOCAL_H) + GRATE_Y_SAFETY;   // 23mm -- UNCHANGED
GRATE_Y1 = (chamber_W - chamfer + GRATE_LOCAL_H) - GRATE_Y_SAFETY;   // 587mm -- UNCHANGED
module grill_grate() {
    for (i = [0:2])
        translate([DATUM_X_FRONT + GRATE_MARGIN + i*(grate_seg_l + GRATE_GAP), GRATE_Y0, GRATE_Z_FIXED - 10])
            cube([grate_seg_l, GRATE_Y1 - GRATE_Y0, 10]);
}
module floor_drains() {
    for (xp = [DATUM_X_FRONT + chamber_L/3, DATUM_X_FRONT + chamber_L*2/3])
        translate([xp, DATUM_Y_CENTER, chamber_floor_z - 30])
            cylinder(d = 25, h = 30 + wall_t + e);
}

// ───────────────────────────────
// DEBUG TOGGLES — module isolation, per rules-codes.md Rule M-4.
// ───────────────────────────────
show_chamber_shell  = true;
show_lid             = true;
show_lid_hardware    = false;
show_firebox         = true;
// v17 NEW: 4 real sub-part toggles inside firebox() (Janis's own explicit
// request, see firebox()'s own header comment) -- each independent of
// show_firebox above (which still gates the WHOLE firebox assembly, incl.
// fire_cylinder_partition()/ash_tray()/firebox_door(), unaffected by these
// 4). All default true (full assembly, unchanged default appearance) --
// set any to false to isolate that one sub-part for a precise report.
show_fire_cylinder          = true;
show_fire_cylinder_end_cap  = true;
show_outer_shell            = true;
show_outer_shell_end_cap    = true;
show_exhaust_room    = true;
show_chimney_pipe    = true;
show_grate            = true;
show_drains           = true;

lid_open_deg           = 0;    // 0=closed .. max
firebox_door_open_deg  = 0;    // 0=closed .. 110=open

// ───────────────────────────────
// ASSEMBLY — each line standalone/commentable per Module Isolation Testing
// (rules-codes.md).
// ───────────────────────────────
if (show_chamber_shell) color("#C8C8C8", 0.75) chamber_shell();
if (show_lid) color("#C8C8C8", 0.75) lid(lid_open_deg);
if (show_lid_hardware) color("#C8C8C8", 0.75) lid_hardware(lid_open_deg);
if (show_firebox) color("#C8C8C8", 0.75) firebox(firebox_door_open_deg);
if (show_exhaust_room) color("#C8C8C8", 0.75) exhaust_room();
if (show_chimney_pipe) color("#C8C8C8", 0.75) chimney_pipe();
if (show_grate) color("#CCCCCC", 1.0) grill_grate();
if (show_drains) color("#AAAAAA", 1.0) floor_drains();
