# SKELETON_WORKSHEET.md — BBQ Offset Smoker
> Version 1.24 — 2026-07-21
> Changes: Janis toggled `show_outer_shell_end_cap` off and still saw a
> wall — real cause: `outer_shell()`'s own flange (50mm tuck-under) was
> built as a SOLID block since v14, never questioned, creating two
> redundant wall-like surfaces instead of one real cap. Fixed: flange
> rebuilt HOLLOW (wall_t thick, same technique as the main hollow body).
> `rules-bbq-fab.md` Rule 1 amended to require this explicitly for future
> rounds. This file's own `include` bumped v19->BBQ-chambers-v20.scad,
> source-of-truth pointer bumped v10->BBQ-understructure-v11.scad (pure
> pointer bump). No DATUM/anchor values moved — see PART_MANIFEST.md/
> BBQ-chambers-v20.scad's own header for full geometric detail.
> Previous: 1.23 — 2026-07-21
> Changes: Janis's own closer visual inspection of v18 (looking INSIDE the
> built cylinder) found a real remaining hole in `fire_cylinder_end_cap_2d()`
> — same failure class as the outer shell's own Rule 1 defect, just never
> checked on this specific end cap. Fixed by directly reusing the Dual
> End-Cap Footprint Pattern (RULE 4) already written this session — no
> re-derivation needed, confirming the standardization work paid off
> same-day. `ash_tray()` also RETIRED entirely per Janis's own explicit
> instruction. This file's own `include` bumped v18->BBQ-chambers-v19.scad,
> source-of-truth pointer bumped v9->BBQ-understructure-v10.scad (pure
> pointer bump, zero geometry change). No DATUM/anchor values moved this
> round — see PART_MANIFEST.md/BBQ-chambers-v19.scad's own header for the
> full geometric detail (out of this file's own datum/skeleton scope).
> Previous: 1.22 — 2026-07-21
> Changes: Janis ran their own 4-step QA simulation against unmerged PR
> #138 (v17), alongside the new rules-bbq-fab.md "Dual End-Cap
> Independence Convention" (locked same session) — found v17's
> `outer_shell_flange_footprint_2d()` (always-plain-square) dodged the 2
> known bugs without satisfying Rule 1's own "meets the octagon face"
> requirement. This file's own `include` bumped v17->BBQ-chambers-v18.scad,
> source-of-truth pointer bumped v8->BBQ-understructure-v9.scad (pure
> pointer bump, zero geometry change). REAL FIX (out of this file's own
> datum/skeleton scope, see PART_MANIFEST.md/BBQ-chambers-v18.scad's own
> header for the full geometric detail): footprint now
> `union(square, true_octagon_profile())` minus the chamber's own real
> hollow-cavity hole, bounded by a real height mask (a real bug caught
> before shipping: a bare union pulled octagon material to the chamber's
> own ridge height) — real, confirmed `outer_shell()` world-Z range now
> exactly [420,1000], no ridge overreach. No DATUM/anchor values moved this round
> (chamber_floor_z/firebox_floor_z/DATUM_X_REAR etc. all untouched) — 2
> real SHAPE-DERIVATION fixes only. Part B's Firebox section: the
> outer shell's own flange/end-cap footprint mechanism REBUILT again —
> the prior round's real octagon-clip (v16 TASK C) was found, via CGAL
> and re-rendering before this round shipped, to have 2 real defects: (1)
> it solid-filled ~48.5mm of the chamber's own real hollow interior bore
> (a genuine wall blocking the chamber's interior, Janis: "i didnt ask for
> this wall!", confirmed via a real non-empty CGAL probe against the
> chamber's own hollow-cavity solid); (2) it also carved a real hole with
> NO material from either part wherever the firebox's own 580mm square
> exceeds the octagon's real width (the chamber has zero material outside
> its own true boundary) — matching Janis's own separate "missing...end
> cap that should stretch to fuse with the chamber shell" finding. Both
> fixed by one redesign: the flange's own outer boundary is now always the
> full continuous 580mm square (flush with the main body everywhere, zero
> notches), with only the chamber's own real hollow-bore shape cut out of
> it — real CGAL: EMPTY vs the chamber's own hollow cavity (2mm real
> margin), NON-EMPTY vs the chamber's own real wall material. Also new:
> 4 real firebox sub-part toggles, Janis's own explicit request, so future
> issues can be isolated and reported precisely (out of this file's own
> datum/skeleton scope — see PART_MANIFEST.md for the toggle list).
> Part A's Prep shelves entry: real pre-existing bug found+fixed —
> `prep_shelves()`'s own right-side shelf applied `mirror()` after an
> already-applied `translate()`, landing both shelves on the same side
> (Janis: "bad tray stack in each other") — fixed via a direct
> `translate([0,chamber_W,0])`, no mirror needed; real, confirmed via an
> STL vertex-extent probe. Rear fender: re-investigated (Janis's own
> screenshot showed a "coiled" look) — CODE UNCHANGED, a real matching-
> angle F6 render reproduces the same clean shape, strong evidence of an
> F5 Preview rendering artifact, flagged for Janis to re-check via F6.
> Previous: 1.20 — 2026-07-21
> Changes: Janis's own DIRECT feedback round (not a new CC prompt) on 7
> real defects, explicitly flagged "told chat many time to fix but dont
> effectively fixed". This file's own `include` bumped v15->
> BBQ-chambers-v16.scad, source-of-truth pointer bumped v6->
> BBQ-understructure-v7.scad. Part B's Firebox section: FLANGE_LEN
> 20->50mm (Janis's explicit spec change, stronger structural tuck-under
> support) — STAYS ADDITIVE, FIREBOX_SHELL_L=FIREBOX_L(580mm interior
> depth, untouched)+FLANGE_LEN=630mm (was 600mm), confirmed via echo not
> assumed. The passage/end-cap/flange datums themselves (chamber_floor_z,
> firebox_floor_z, DATUM_X_REAR etc.) did NOT move this round — only the
> SHAPE-DERIVATION logic changed (passage now sized from real available
> octagon material via a new real vertical-band calc, not an independent
> area formula; end-cap/flange footprints now real two-zone octagon-top/
> native-shape-bottom constructions) — see BBQ-chambers-v16.scad's own
> header + PART_MANIFEST.md for the full geometric detail (out of this
> file's own datum/skeleton scope). Part A's Rear fender entry: real
> shape rebuilt again (flat plate tangent to a curved flare, replacing
> v6's full-arc-from-the-wall design) — grounded in the ORIGINAL v5
> prompt's own written spec text, not a re-guess. 3 items from the same
> feedback round explicitly NOT addressed this version (flagged, pending
> a reference image/clarification): prep tray/shelf location, front wheel
> axle center bracket ("T bar puller") shape.
> Previous: 1.19 — 2026-07-20
> Changes: bbq-understructure-v6-fitment-fixes. TASK 0 bumps this file's
> own `include` to BBQ-chambers-v15.scad, wiring v15's real square-shell/
> cylinder firebox redesign into the full assembly chain for the first
> time. 4 real fitment fixes from Janis's live OpenSCAD-desktop review of
> v5: Part A's Prep shelves entry REBUILT (3 real distributed mounting
> brackets, was 1 cantilevered — kinematics already correct, real fix is
> physical support). TRACK_WIDTH recomputed to 980mm (100mm wheel-to-
> firebox gap, was 1080mm/150mm). Rear fender rebuilt as a real short
> flared wing (was a long straight panel — real cause: the flat mounting
> portion spanned to the wheel's own centerline before curving; fixed by
> starting the arc almost immediately at the real angle where it reaches
> the firebox wall, live-computed via acos()). T-bar bracket now mounts
> directly at the front axle's own real plane with a new curved gusset
> (was floating 100mm above it). REAR_BRACKET_H/LEG_DROP recompute
> automatically via v15's new firebox_floor_z (191.4mm/351.335mm, were
> 342.8mm/199.935mm) — zero code change beyond the pointer bump. TBAR_LEN
> unaffected (1102.735mm) — the v5-flagged 50mm roof-overshoot flips to a
> genuine 50mm real clearance margin as a side effect of the gusset fix.
> Front-wheel/bracket collision re-check at the new geometry: still
> resolved (EMPTY), confirmed not assumed. REAL BUG FOUND+FIXED VIA CGAL
> DURING THE BUILD: the fender's own wider 147deg arc sweep broke the
> inherited 3-point wedge-mask technique (the chord between its 2 far
> points cut INSIDE the ring at this wider angle, producing disconnected
> slivers instead of a band, confirmed via real render) — fixed with a
> real multi-point fan mask, robust to any sweep angle, re-verified as a
> clean continuous band via CGAL.
> Previous: 1.18 — 2026-07-20
> Changes: bbq-chambers-v15-square-shell-cylinder-firebox. Real structural
> firebox redesign, source v14.2 (understructure v5 completely out of
> scope, not opened — a separate, already-prepared v6 round depends on
> this round's own real output). Part B's Firebox section REBUILT: outer
> shell rebuilt as a true 580x580x580 cube (FIREBOX_H 428.6->580mm, "dice"
> proportions per Janis's own explicit direction); firebox_floor_z now a
> live formula (420mm, was 571.4mm literal, top pinned at 1000mm instead) —
> firebox now extends 351.335mm below chamber_floor_z (was 199.935mm).
> REAL, NECESSARY FORMULA CORRECTION found before shipping: firebox_x0
> repinned directly at its own real weld position (913.5mm, unchanged
> value) instead of a historical-midpoint formula that would have pulled
> it 60mm into the chamber's own real territory as FIREBOX_L grew
> (460->580mm) — confirmed via direct computation, not assumed; all +120mm
> of growth now happens on the door/far end only. Rectangular inner duct
> RETIRED, replaced by a real 456mm-dia fire cylinder (62mm wall
> clearance, Janis's own explicit choice) — real volume 5,780.25in³ =
> 100.75% of the 5,737in³ target. Rear passage rebuilt as a circle
> (194.898mm dia, target-area-sized) — real finding: the cylinder's own
> true center now sits BELOW chamber_floor_z (a direct consequence of the
> height growth), passage biased to the cylinder's own real top; real CGAL
> measurement (STL volume, not estimated): 88.7% of the circle's own area
> is genuinely cut through real chamber material, ~11.3% a real confirmed
> chord (matches this project's own v13/v14 precedent for circular-passage
> findings). NEW fire_cylinder_partition() end plate locates the cylinder
> within the square shell. TWO REAL BUGS FOUND+FIXED VIA CGAL DURING THE
> BUILD: (1) the ash tray's own real safe width was derived checking the
> WRONG corner (top, not the farther-from-center bottom face) — a real,
> substantial 49,100mm³ overlap with the cylinder's own solid wall found
> via CGAL, fixed 150->80mm, re-verified empty. (2) the new partition sat
> exactly coincident with firebox_door()'s own face (Simple:no) — pulled
> back by a real e=0.01mm epsilon, re-verified Simple:yes. SEPARATE,
> REAL, PRE-EXISTING FINDING (flagged, not fixed, chambers frozen no
> further touching this round): firebox_door() is still real, CGAL-
> confirmed non-manifold above ~90-95deg open — same defect flagged in the
> prior (understructure v5) round, reproduced identically here, confirming
> it is NOT a v15 regression.
> Previous: 1.17 — 2026-07-20
> Changes: bbq-understructure-v5-trackwidth-fender-tbar. Full understructure
> rebuild, first round since v4 (2026-07-17) — TASK 0 (not optional
> preamble) finally bumps this file's own `include` past v13 to
> BBQ-chambers-v14.2.scad (three chamber rounds landed since v4 without
> this pointer moving), re-verifies the front bracket leg is still flush
> against the chamber's real octagon boundary at the new +50mm
> chamber_floor_z. Part A's Understructure tree REBUILT: ONE shared
> TRACK_WIDTH=1080mm now drives both front AND rear wheel Y-position
> (retires REAR_TRACK_WIDTH's own formula and the front caster's
> DUAL_WHEEL_OFFSET spacing) — real, CGAL-confirmed: this resolves the
> standing ~6mm front-wheel/bracket collision flagged every round since v4
> (not just wider-by-assumption, confirmed EMPTY via a real intersection()
> probe). NEW rear fender (150mm real radial clearance, welds to the
> firebox's own outer shell). Front bracket tip (tow_triangle()) rebuilt
> round (150mm dia boss, was a sharp point). Front U-bracket LEG_DROP now a
> live formula landing exactly at firebox_floor_z (was a 150mm literal).
> Part C's Kinetic table: T-bar length now a live formula (1102.735mm, was
> 400mm) and its default angle FIXED 0->90 (vertical storage — was
> shipping flat, a standing v12/v4 QA defect). REAL, FLAGGED, NOT SILENTLY
> ABSORBED: at the new 90deg default, the T-bar's own numeric tip-Z exceeds
> roof height by 50mm (the length formula assumes a wheel-height pivot,
> this file's real hinge sits 100mm higher) — a real CGAL check confirms
> NO actual collision (T-bar sits outside the chamber's own X-footprint at
> that height), but the margin itself is negative, flagged for the record.
> SEPARATE REAL FINDING, unrelated to this round's own scope, found
> incidentally during this round's own mandatory kinetic sweep: the
> firebox door (frozen chambers code, UNCHANGED) is real, CGAL-confirmed
> non-manifold above ~90-95deg open, reproduced identically on standalone
> v14/v14.1/v14.2 with zero understructure geometry present — pre-existing,
> NOT introduced this round, NOT fixed (chambers frozen/DO NOT TOUCH this
> round), flagged for a future chambers-scoped round.
> Previous: 1.16 — 2026-07-20
> Changes: bbq-chambers-v14.2-passage-area-fix-real-cut-check. Two
> targeted fixes on the just-merged v14.1 — chamber apex(950mm)/firebox
> width(580mm)/fire-volume math ALL FROZEN, unchanged. Understructure (v4)
> COMPLETELY untouched. Part B's Firebox Passage (Inner duct end-cap row):
> trapezoid RESIZED to the real 0.008-of-fire-volume opening-area target
> (47.124in²=30,402.6mm², was 2.25x oversized at 106.2in²) — bottom=
> 95.29mm/top=227.00mm, same taper preserved. Per Janis's own direct
> clarification (real, flagged deviation from this round's own prompt-file
> "height frozen" instruction): bottom stays at chamber_floor_z, top rises
> to 20mm below the inner duct's own real top wall (960mm, was 950mm=apex
> A) for a real weld-clearance margin — height grows 178.665mm->188.665mm;
> the "top edge=apex A" coincidence does NOT carry over from v14.1. Part
> A/B's Outer shell + outer shell end-cap row: REAL cut-penetration defect
> found via an actual CGAL ray-probe (NOT the benign v14.1 axial-camera
> artifact — a genuinely different bug): v14.1's own flange/end-cap
> simplification left them PLAIN unperforated rectangles, sealing the
> passage shut even though the chamber wall and duct end cap both had a
> real hole (matches Janis's own "very large but not cut through"/"thin
> film" report exactly) — fixed via new `outer_shell_flange_cut_2d()`,
> ray-probe re-run confirmed a genuine unobstructed through-hole. Detail/
> content update within the SAME 3-part structure, not a new artifact —
> X.Y bump.
> Previous: 1.15 — 2026-07-20
> Changes: bbq-chambers-v14.1-flat-tuckunder-trapezoid-passage. Targeted
> bug-fix + simplification round on the just-merged v14 (outer shell flat-
> face fix, trapezoid passage replacing v14's circle).
> Previous: 1.14 — 2026-07-18
> Changes: bbq-chambers-v14-apex950-firebox-widen-dual-endcap.
> CHAMBER+FIREBOX round — understructure (v4) COMPLETELY untouched, not
> opened, its own `include` still points at v13 (bumping it is a later,
> separate round).
> Previous: 1.13 — 2026-07-17
> Changes: bbq-chambers-v13-reanchor-grate-decouple-rear-passage.
> CHAMBER-ONLY round (firebox v12, understructure v4 both frozen — v4's
> own `include` pointer-bumped to v13, zero real construction change).
> Part A's PRIMARY DATUM row updated: `chamber_floor_z` is now a live
> formula (900-chamfer=721.335mm, was a 600mm literal) so apex A/GRATE_Z
> lands at EXACTLY 900mm — the real, algebraic fix for last round's own
> honestly-flagged finding (apex A was really 778.665mm, not the 900mm a
> prior prompt mistakenly assumed, traced to a v3 GROUND_OFFSET constant
> that was computed on paper but never wired into real geometry). Grill
> Grate row DECOUPLED from the chamber body — *** TEMPORARY *** fixed at
> `GRATE_Z_FIXED`=1000mm, a real 100mm unsupported air gap above apex A,
> expected, NOT a defect — intended to be re-merged once a future
> reinforcement-frame+shorter-door task exists (flagged in the module
> itself, not just here). Part B's Firebox subtree: Firebox Passage
> REBUILT (real cylinder∩octagon `intersection()`, replaces the old
> rectangular cut) and Firebox near-wall-closure/upper-wall-seal RETIRED,
> REPLACED by one new `firebox_end_cap()` plate (real, aligned hole,
> full-face seal). Detail/content update within the SAME 3-part structure,
> not a new artifact — X.Y bump.
> Previous: 1.12 — 2026-07-17
> Changes: bbq-chambers-v12-firebox-rebuild-understructure-v4-wheel. Part
> A's Firebox/Understructure rows and Part B's BOM tree REBUILT again —
> source now BBQ-chambers-v12.scad + BBQ-understructure-v4.scad. Firebox
> rebuilt to independent FIREBOX_L/W/H=460/510/428.6mm (was a uniform
> 457mm cube), world Z=[571.4,1000] (LOCKED spec — real mismatch found vs
> the prompt's own "apex A=900mm" claim, real live value 778.665mm,
> chamber frozen/unchanged, flagged not silently resolved). New internal
> `fuel_cylinder()` (388.6mm dia hollow tube, replaces `fire_grate()`,
> REMOVED entirely). Wheel size corrected to 457.2/228.6/200mm (18",
> FINAL). World-Z anchor: mandatory real check confirmed the v3 wheel's
> real bottom sat at raw Z=-150mm, NOT world Z=0 as Janis suspected — real
> offset found and corrected via direct construction (`REAR_AXLE_Z=WHEEL_R`,
> `GROUND_OFFSET`'s subtractive role retired). REAL, FLAGGED CONSEQUENCE:
> this direct fix, combined with the chamber staying frozen (DO NOT TOUCH),
> drops the real grate-height-above-ground from v3's 928.665mm to
> 778.665mm — below the standing 900-1000mm Envelope target — a genuine,
> unresolved conflict between this round's own explicit anchor instruction
> and the standing target, not silently picked either way. REAL,
> CGAL-CONFIRMED, UNRESOLVED COLLISION found (NEW): the bigger/higher-
> anchored front wheels now intersect the front bracket legs/caster
> plate/tow triangle (~6mm each) — all explicitly DO-NOT-TOUCH/deferred
> this round, blocking real fabrication until a follow-up prompt reworks
> the front bracket. See both .scad files' own headers and cc_chat_log.md
> for the full verification record. Detail/content update within the SAME
> 3-part structure, not a new artifact — X.Y bump.
> Previous: 1.11 — 2026-07-17
> Changes: bbq-understructure-v3-wheel-height-tray-handle. Understructure
> branch of Part B's BOM tree REBUILT again: (1) WHEEL_D/WHEEL_R
> 609.6/304.8 -> 400/200, single source both axles, front caster ONE wheel
> -> TWO (same pivot). (2) PRIMARY DATUM chain gets a NEW ground reference:
> true ground moves to local Z=-GROUND_OFFSET(150mm) — chamber_floor_z/
> GRATE_Z themselves UNCHANGED (BBQ-chambers-v11.scad completely locked),
> real grate height above true ground now 928.665mm (was ~700mm),
> superseding the old design_scope_of_work_rule.md target. REAR_AXLE_Z/
> REAR_BRACKET_H recomputed (50mm/350mm); new spacer brackets (front x1
> 394mm, rear x2 278.5mm each) absorb the resulting gaps — front bracket's
> own MID_H/TOP_W/BOT_W/LEG_GAP/LEG_DROP/FRONT_X and rear's own
> REAR_AXLE_X/REAR_TRACK_WIDTH confirmed ZERO diff from v2. (3) Prep trays
> re-hinged at real octagon "apex A" (world Y=0/610, Z=GRATE_Z=778.665 —
> the lid's own parting-line reference point), real CGAL contact confirmed
> (were floating in v2). (4) Tow handle now RIGIDLY WELDED to the front
> axle/caster yoke (v2's "entirely independent" design was WRONG, corrected
> via Janis's own reference photo) — `steer_deg` now coupled-rotates the
> front wheel pair too; handle is now a real T-shaped crossbar,
> `handle_fold_deg` (renamed from v2's `handle_tilt_deg`). Part A's
> Understructure row, Part B's BOM tree, and Part C's Kinetic table all
> updated below. Detail/content update within the SAME 3-part structure,
> not a new artifact — X.Y bump, per this file's own standing convention.
> Previous: 1.10 — 2026-07-17
> Changes: bbq-understructure-v2-axles-swivel-handle. Understructure branch
> of Part B's BOM tree REBUILT: v1's placeholder `legs()`/`casters()`/
> `tow_handle()` REPLACED by 3 real, mutually-independent mechanisms —
> `rear_axle()` (TASK 1, fixed non-swivel, 2 wheels under the firebox,
> REAR_TRACK_WIDTH=857mm real-derived), `front_wheel_support()` (TASK 2,
> REWRITTEN this round against a real Janis sketch — ONE bent-sheet
> bracket, real trapezoid MID_H/TOP_W/BOT_W derived from the chamber's own
> chamfer/chamber_W, CGAL-confirmed flush against `true_octagon_profile()`
> at h=MID_H, single swivel caster reusing TASK 1's own wheel spec),
> `tow_handle_assembly()` (TASK 3, top-view triangle + hinged handle,
> `handle_tilt_deg`/`steer_deg` kinetic, CGAL-confirmed clear of
> `exhaust_room()` at full-vertical tilt by a real 137.5mm/155mm margin).
> Part A's Understructure row and Part C's Kinetic table both updated
> below. `prep_shelves()` UNCHANGED (DO NOT TOUCH) — real intersection
> probe vs the new `front_wheel_support()` confirmed EMPTY (no conflict).
> Detail/content update within the SAME 3-part structure (this file's own
> Part A/B/C), not a new artifact — X.Y bump, per this file's own standing
> versioning convention.
> Previous: 1.9 — 2026-07-17
> Changes: bbq-chambers-v11-firebox-wall-seal. THE REAL FIX for the
> "triangle leak" (1.8's entry below left it KT-exhausted/unexplained).
> Root cause found by Janis directly, independently confirmed by Claude
> via a real local render before any code was written: the octagon
> narrows near the floor (bottom two chamfers); the firebox is a plain
> square — above `chamber_floor_z` the square sticks out past the true
> octagon boundary on both sides, and no part ever closed that region
> (`firebox_near_wall_closure()` only ever covered BELOW `chamber_floor_z`).
> New `firebox_upper_wall_seal()` closes exactly that region, built from
> the real `firebox_square_2d()`/`fixed_side_solid_2d()` boolean (both
> unchanged). Verified: real CGAL probe confirms the two former-gap
> triangles now solid; full kinetic sweep 0-120° and the full assembly
> chain both `Simple: yes`; both panels 5218.8436mm² each, confirmed
> mirror-symmetric. New "Firebox upper wall seal" bullet added to Part B's
> skeleton tree below; Toggle-Completeness count updated.
> Previous: 1.8 — 2026-07-16
> Changes: bbq-chambers-v9-firebox-passage-true-profile. DOES NOT FIX THE
> "TRIANGLE LEAK" — the source prompt theorized `firebox_passage_profile()`'s
> use of `fixed_shell_profile()` (fake diagonal) was the cause; a real
> geometric XOR test proved `fixed_shell_profile()` and the proposed
> replacement (`true_octagon_profile()` ∩ `fixed_side_wedge()`) are
> IDENTICAL shapes, so the rebuild changes zero geometry (passage area
> unchanged, 88209.549116mm² exact match to v8). Still implemented as a
> real cleanup: new `fixed_side_solid_2d()` 2D helper, `fixed_shell_profile()`
> DELETED (zero remaining callers). Part B's Firebox Passage entry
> corrected below to state this plainly — the "triangle leak" symptom is
> UNEXPLAINED after 3 real investigation rounds (PR #121 x2, this
> session), KT-exhausted per this project's own protocol, needs Janis's
> direct input rather than a 4th guess. Detail correction, not a new
> artifact — X.Y bump.
> Previous: 1.7 — 2026-07-16
> Changes: bbq-chambers-v8-regular-octagon-continuous-channel. Two related
> fixes. (1) `chamfer` corrected 150mm->178.665mm (real
> `chamber_W/(2+sqrt(2))` regular-octagon formula — see rules-bbq-fab.md's
> new "Regular Octagon Requirement" section). This forced Part A's PRIMARY
> DATUM to FLIP: `chamber_floor_z` is now the fixed/independent anchor
> (was derived FROM `DATUM_GRATE_Z`); `GRATE_Z` is now DERIVED
> (`chamber_floor_z + chamfer` = 778.665mm, was hardcoded 750mm) —
> `GRATE_Z = chamber_floor_z + chamfer` is circular otherwise, since the
> old chain derived chamber_floor_z FROM GRATE_Z. `grate_clearance`
> RETIRED (its only consumer was the old, now-reversed, chamber_floor_z
> formula). (2) `lid_territory_end_caps()` (PR #121/v6) REMOVED, folded
> into new `lid_territory_margin_fill()` — Part B's Chamber Shell sub-tree
> updated: both the fixed-side tube and the lid-side margin fill are now
> built from the SAME shared `true_octagon_profile()`+`octagon_ring()`
> construction (were two independently-profiled shapes in v7, meeting at
> a seam) — real CGAL boundary probe confirms no closing wall at
> LID_X0/LID_X1 (cross-section area ~5096mm² at the boundary, consistent
> with thin wall_t ring material, not the ~308258mm² a solid closing panel
> would show). Detail correction/addition within the SAME 3-part
> structure, not a new artifact — X.Y bump.
> Previous: 1.6 — 2026-07-15
> Changes: bbq-chambers-v7-fixed-shell-open-channel-rebuild (R-111 territory,
> 3 prior real-but-wrong-module fixes: PR #119 color/opacity, v5's own
> end-cap gap, PR #121's lid_territory_end_caps() hollow rebuild). REAL
> root cause: `fixed_shell_profile()`'s own PARTING-line closing edge (apex
> A to ridge midpoint) was never a real octagon edge -- extruding it the
> full chamber_L length turned that seam into a permanent spanning panel.
> Fixed via `true_octagon_profile()` (real 8-point octagon, no fake edge)
> + `fixed_side_wedge()` (cutting-plane mask applied to an already-hollow
> ring, not baked into the profile). Part B's Chamber Shell entry CORRECTED
> below -- it claimed "TRUE octagon closure" since v3, which was never
> actually true until this version; now accurate. `fixed_shell_profile()`
> KEPT (R-009 duplication check found a 3rd real caller,
> `firebox_passage_profile()`, an explicit separate open item) but no
> longer used by `chamber_outer_tube()`/`chamber_inner_cavity()`. Detail
> correction within the SAME 3-part structure, not a new artifact — X.Y bump.
> Previous: 1.5 — 2026-07-14
> Changes: direct-cc fix (R-011, no prompt file) — Janis's live OpenSCAD-
> desktop review of v5 found the "reads solid, not hollow" complaint STILL
> unresolved (2nd loop on this symptom), plus 3 more concrete items, all
> investigated first via real CGAL checks (R-008). RE-DIAGNOSIS:
> `lid_territory_end_caps()` (v5's own Finding-1 fix) was a SOLID fill
> sitting exactly in an open-lid viewer's sightline — a real design gap in
> the v5 fix itself, not a repeat of PR #119's color/opacity root cause.
> REBUILT as a proper hollow shell. Part A's Lid row updated (margin
> widened 10mm->100mm each end — LID_X0=100/LID_X1=815). Part B's Firebox
> Passage entry updated (inset 10mm->15mm, "triangle gap" investigated —
> no CGAL-provable defect found, real wall material confirmed present).
> Grill Grate entry updated (GRATE_Z repositioned 700->750, aligned to the
> lid parting line, chamber_floor_z unaffected). Detail/content update
> within the SAME 3-part structure, not a new artifact — X.Y bump.
> Previous: 1.4 — 2026-07-14 (direct-cc fix, R-011, no prompt file — 3
> findings from Janis's annotated OpenSCAD-desktop screenshots of the v4
> build): Part B's BOM tree gets 2 new `chamber_shell()` sub-parts:
> `lid_territory_end_caps()` (closes a CGAL-confirmed real gap at both
> lid-territory end margins) and `firebox_passage()` (replaces
> `window_hole()`). Grill Grate entry updated (Y-range CGAL-confirmed
> collision-fixed against the fixed shell's own bottom chamfers).
> Previous: 1.3 — 2026-07-14 (bbq-chambers-v3-closure-exhaust-resize-lid-
> mirror): Part A's Lid row updated (mirrored to Y=0 side, per the new
> Standing Orientation Convention in rules-bbq-fab.md) and Exhaust Room row
> updated (resized 200/200->360/100). Part B's BOM tree gets a new
> Firebox-near-wall-closure sub-part (closes a real gap below
> chamber_floor_z). Part C's Lid kinetic row updated (rotation sign
> flipped, real CGAL-verified, not assumed from mirror symmetry).

## ⚠️ GOVERNANCE FLAG — same as design_scope_of_work_rule.md

The original prompt states these 3 parts are "exactly as confirmed this
session... Copy verbatim from chat log" — a Claude Web chat log cc has no
access to. The `bbq-offset-smoker-v1-init-ADDENDUM-cc-prompt.md` follow-up
confirmed the correct handling for each part:

- **Part A (datum chain)** — fully specified directly in the original
  prompt's own TASK 2 (GLOBAL PARAMS + DATUMS + module descriptions are
  literal, not log-referenced), GROUNDED IN THE REAL BUILT FILE
  (BBQ-chambers-v1.scad, real CGAL-verified — see cc_chat_log.md). The
  addendum's own Section 3b restates Part A using the original prompt's
  pre-correction "Y=chamber_L" notation — this file uses the CORRECTED
  axis (X=chamber_L) throughout, matching the actually-built file and
  rules-dimensions.md's locked all-models coordinate standard (see
  BBQ-chambers-v1.scad's header for the full correction rationale).
- **Parts B/C (BOM tree, Kinetic table)** — the addendum confirms these
  were never a verbatim Janis-confirmed source to begin with, and
  instructs deriving them mechanically from the module list already
  locked in Task 2/3 — exactly what this file already did. Confirmed
  correct, not rewritten. Per the addendum's own instruction: stated
  explicitly here that Parts B/C are CC-DERIVED from the geometry spec,
  not copied from a prior Janis confirmation — still requires Janis's
  review, not silently presented as pre-confirmed.

---

## PART A — Skeleton Definition Worksheet

```
MASTER ORIGIN: (0, 0, 0) at floor level, front-left corner of the product
  footprint (chimney/tow-handle end = front, firebox end = rear) — matches
  rules-dimensions.md's global "front-left at floor" convention.

PRIMARY DATUM:   chamber_floor_z (horizontal plane — v13: now a LIVE
                 FORMULA, `900 - chamfer` = 721.335mm real, was a
                 hardcoded 600mm literal through v12) — locks Z. Chosen
                 specifically so GRATE_Z (`= chamber_floor_z + chamfer`,
                 formula itself UNCHANGED since v8) lands at EXACTLY
                 900mm by algebraic cancellation — the real fix for the
                 v12 session's own honestly-flagged finding that apex A
                 was really 778.665mm, not the 900mm a prior prompt
                 mistakenly assumed. GRATE_Z remains the chamber body's
                 own real apex-A reference; the GRILL GRATE part itself is
                 now a SEPARATE, TEMPORARILY-DECOUPLED thing (see Part B/C
                 below) — do not confuse `GRATE_Z`/`DATUM_GRATE_Z` (the
                 chamber's own apex-A datum, 900mm) with `GRATE_Z_FIXED`
                 (the physical grill grate part's own independent Z,
                 1000mm). firebox_floor_z's own direction
                 off chamber_floor_z is UNCHANGED either way.
SECONDARY DATUM: DATUM_X_REAR (chamber's rear/firebox wall, X=915mm) —
                 locks X. Firebox is Parent: DATUM_X_REAR, not an
                 independently-set X position.
TERTIARY DATUM:  DATUM_Y_CENTER (chamber's lateral centerline, Y=305mm) —
                 locks Y. Firebox and chimney are both Parent:
                 DATUM_Y_CENTER (centered on the chamber's own width).

MAJOR SUB-ASSEMBLIES:
  Grill Grate      — Parent: DATUM_GRATE_Z (now itself Parent: chamber_floor_z) — offset: (0,0,0), fixed
  Cook Chamber      — Parent: chamber_floor_z              — offset: (0,0,0), fixed (v8 — chamber_floor_z is now the direct anchor, was dZ=-100 off DATUM_GRATE_Z)
  Lid               — Parent: Cook Chamber's ridge midpoint — offset: length-wise hinge at (-, DATUM_Y_CENTER, DATUM_Z_RIDGE); opens toward Y=0 (v3 mirror, was Y=chamber_W in v2) per the Standing Orientation Convention (rules-bbq-fab.md); margin widened v6 (LID_X0=100/LID_X1=815, was 10/905)
  Firebox           — Parent: Cook Chamber's rear wall (chamber's own real weld-overlap position, X=913.5mm — v15: REPINNED as a direct fixed anchor, was a derived side-effect of a historical-midpoint formula that would have drifted with FIREBOX_L, see file header) — offset: v15 REDESIGN, TWO independent welded assemblies, no shared Parent chain between them. Fire cylinder (REPLACES Inner duct/rectangular design entirely, RETIRED) — Parent: chamber's own octagon end cap (welds DIRECTLY, own end cap module, real CIRCULAR hole matching the passage — v15 TASK 3: passage rebuilt as a circle, 194.898mm dia, target-area-sized, real CGAL: 88.7% of its area genuinely cut through real material, ~11.3% a real confirmed chord since the cylinder's own true center now sits below chamber_floor_z), 456mm dia (62mm wall clearance), FIREBOX_L=580mm interior (was 460mm, TASK 2). Outer shell — Parent: chamber's rear wall via a 20mm additive structural flange (UNCHANGED construction/code), v15 TASK 1: rebuilt as a true 580x580x580 CUBE (FIREBOX_H 428.6->580mm, all 3 dims equal), firebox_floor_z now 420mm (was 571.4mm, top pinned at 1000mm instead). NEW fire_cylinder_partition() end plate locates the cylinder within the shell (Parent: outer_shell_footprint_2d()'s own real exterior boundary, reused). The two assemblies share NO Parent/contact point with each other (real, mandatory CGAL zero-contact RE-CONFIRMED at the new cube/cylinder geometry) — same architecture v14 established, reused not redesigned
  Exhaust room      — Parent: Cook Chamber's front end-cap (DATUM_X_FRONT) — offset: welded flush at X=0; RESIZED v3 (360mm dia x 100mm height, was 200/200 v2)
  Chimney pipe      — Parent: Exhaust room's own top plate — offset: coaxial with the room's pipe-mounting hole; RE-POSITIONED v3 (real clearance now, not a forced overhang)
  Understructure     — Parent: Cook Chamber's chamber_floor_z / firebox_* / DATUM_Y_CENTER / GRATE_Z. v4 TASK 3: GROUND_OFFSET's indirect subtractive role RETIRED — REAR_AXLE_Z is now DIRECT CONSTRUCTION (`=WHEEL_R`=228.6), real-CGAL-confirmed wheel bottom at literal world Z=0 for BOTH axles (mandatory check found the v3 wheel's real bottom at raw Z=-150, confirmed NOT zero — "this is the anchor everything else in future prompts will be checked against"). REAL FLAGGED CONFLICT: this direct anchor, with the chamber staying frozen, drops real grate-height-above-ground to 778.665mm, below the standing 900-1000mm Envelope target — unresolved, not silently picked either way. rear_axle() Parent: firebox_floor_z(now 571.4)/firebox_x0/y0/y1 (offset: down to REAR_AXLE_Z=228.6, REAR_BRACKET_H=342.8mm); front_wheel_support(steer_deg,handle_fold_deg) Parent: chamber_floor_z/chamfer/chamber_W/DATUM_Y_CENTER (offset: down to chamber_floor_z-LEG_DROP, then front_spacer, now 215.4mm, down to the shared FRONT_AXLE_Z=228.6) — REAL, CGAL-CONFIRMED, UNRESOLVED COLLISION (NEW): front wheels now intersect front_bracket()/front_caster_plate()/tow_triangle() (~6mm each), all DO-NOT-TOUCH/deferred this round, flagged not fixed; prep_shelves() Parent: octagon "apex A" (world Y=0/610, Z=GRATE_Z=778.665, UNCHANGED, chamber frozen)
```

## PART B — BOM Subassembly Tree

```
BBQ Offset Smoker V9 (top assembly)
├── Cook Chamber
│   ├── Chamber shell (fixed side only: floor+RIGHT wall+right chamfer+
│   │   half ridge, wall_t hollow — v7 REBUILT from a real 8-point
│   │   `true_octagon_profile()` [real edges only] clipped to the fixed
│   │   side via a `fixed_side_wedge()` cutting-plane mask applied AFTER
│   │   hollowing, not before; this is the first version where "TRUE
│   │   octagon closure" is actually true — v3-v6 used
│   │   `fixed_shell_profile()`'s own fake diagonal closing edge instead,
│   │   which is what caused the "reads solid, flat panel across the
│   │   opening" defect. v3 MIRRORED, was left-side in v2. v8: octagon is
│   │   now genuinely REGULAR — chamfer corrected 150->178.665mm, real
│   │   `chamber_W/(2+sqrt(2))` formula, all 8 sides confirmed 252.670mm)
│   │   ├── Lid-territory margin fill (v8 — REPLACES `lid_territory_end_caps()`,
│   │   │   PR #121/v6, folded into a new construction: same shared
│   │   │   `true_octagon_profile()`+`octagon_ring()` helper the fixed-side
│   │   │   tube itself uses [was a DIFFERENT profile, `lid_profile()`, in
│   │   │   v6/v7 — two independently-modeled shapes meeting at a seam,
│   │   │   which is what Janis was seeing as a visible wall at the
│   │   │   X=LID_X0/LID_X1 boundary]. Real wall_t end cap ONLY at the true
│   │   │   outer end (X=0 or X=915), fully OPEN at LID_X0/LID_X1 — no
│   │   │   separate closing face. Real CGAL boundary probe confirms
│   │   │   continuous wall_t-only material through the boundary (~5096mm²
│   │   │   cross-section, not the ~308258mm² a solid closing panel would
│   │   │   show). Same X-range as before: X=0-100 and X=815-915)
│   │   └── Firebox passage (v13 REBUILT — real `intersection()` of the
│   │       ALREADY-BUILT v12 fuel cylinder's own 388.6mm circular
│   │       cross-section against the live octagon boundary
│   │       [`fixed_side_solid_2d()`, UNCHANGED], REPLACES the old
│   │       rectangular/inset firebox-footprint cut. `PASSAGE_INSET`
│   │       retired. Real result: round on the ridge-ward side, real
│   │       octagon-clipped boundary on the floor-ward side [h clamped
│   │       exactly to [0,258.665], zero material below chamber_floor_z,
│   │       confirmed numerically] — matches Janis's "look through the
│   │       door" description, see BBQ-chambers-v13.scad header for the
│   │       full verification record)
│   │   └── NEW fixed band (v21 TASK 1 — real lid/fixed parting-line
│   │       shift +50mm, Y=0 side only: `fixed_side_wedge()`'s own shared
│   │       vertex moved from apex A to a new real point on the SAME
│   │       octagon wall edge [world Z=1000mm, was 950mm] — reuses the
│   │       LOCKED `chamber_outer_tube()` construction directly, R-014,
│   │       not a new insert. Real, live-confirmed final band: world
│   │       Z=[950,1000], full chamber_L length, genuinely FIXED [never
│   │       moves with the lid] — real structural weld base for the
│   │       relocated tray's hinges below. Real CGAL: NON-EMPTY vs the
│   │       existing fixed shell [genuine structural continuity])
│   ├── Lid (ridge-hinged, 3 flat panels: half-ridge+chamfer+wall — v3
│   │   MIRRORED to Y=0 side, was Y=chamber_W side in v2; v6: margin
│   │   widened to 100mm each end, LID_LENGTH=715, was 895; v21 TASK 1:
│   │   own vertical Y=0 panel shortened by exactly 50mm to match the new
│   │   fixed band above — top edge [real octagon top-left corner]
│   │   UNCHANGED, real live CGAL: lid[closed] vs the new band NON-EMPTY
│   │   [intentional ~3mm weld overlap, confirms zero gap at the seam],
│   │   lid's real swept volume vs the band EMPTY at 9 angles checked
│   │   [0.5°/1°/5°/15°/30°/45°/60°/90°/120°])
│   │   ├── Lift handle rail (2 standoff posts) — still DISABLED, stale positions
│   │   ├── Toggle-clamp latches x2 (BUY, off-shelf placeholder) — still DISABLED
│   │   ├── Dome thermometer (BUY, off-shelf placeholder) — still DISABLED
│   │   └── Counterbalance lever + weight — still DISABLED
│   ├── Grill grate (v13 TASK 2: Z-anchor DECOUPLED from the chamber
│   │   body — *** TEMPORARY *** fixed at GRATE_Z_FIXED=1000mm (mandatory
│   │   comment at its own declaration), real 100mm unsupported air gap
│   │   above the reanchored apex A (GRATE_Z=900mm exact, TASK 1),
│   │   expected, intended to be re-merged once a future reinforcement-
│   │   frame+shorter-door task exists. X/Y placement formulas UNCHANGED
│   │   CODE per explicit DO NOT TOUCH — still keyed to DATUM_GRATE_Z
│   │   [900], NOT GRATE_Z_FIXED [1000], real flagged consequence: grate
│   │   built narrower [564mm] than geometrically available at its real
│   │   height, safe/non-colliding [re-verified vs lid 0-120°/chimney/
│   │   exhaust room], just not width-optimal)
│   └── Floor drain valves x2 (BUY, off-shelf placeholder)
├── Firebox (v15 REDESIGN — TWO fully independent welded assemblies, NO
│   │   shared end-cap plate [SAME real architecture v14 established,
│   │   reused not reinvented]. FIREBOX_L=580mm [fire cylinder's own
│   │   interior depth, UNCHANGED] vs FIREBOX_SHELL_L=630mm [outer shell's
│   │   own physical length, v16: was 600mm, +50mm additive flange, Janis's
│   │   explicit spec change from +20mm — the 50mm is a pure EXTENSION,
│   │   FIREBOX_L's own 580mm interior depth is NOT touched by it] — two
│   │   separate, never-confused numbers. REAL, NECESSARY FORMULA
│   │   CORRECTION found before shipping: firebox_x0 repinned directly at
│   │   its own real weld position [913.5mm, unchanged value] instead of a
│   │   historical-midpoint formula that would have pulled it 60mm into
│   │   the chamber's own real territory as FIREBOX_L grew — all +120mm of
│   │   growth now happens on the door/far end only [firebox_x1=1493.5mm])
│   ├── Fire cylinder + fire cylinder end-cap (v15 TASK 2 NEW — REPLACES
│   │   Inner duct + inner duct end-cap, BOTH RETIRED entirely. Round,
│   │   456mm dia [62mm wall clearance vs the outer shell, Janis's own
│   │   explicit choice, real OPEN AIR gap], full FIREBOX_L[580mm] span,
│   │   open both ends [same convention as the retired rectangular duct].
│   │   Own end cap welds DIRECTLY to the chamber's own octagon end cap,
│   │   NOT to the outer shell — real full circle minus the SAME passage-
│   │   hole shape the chamber's own rear-wall cut uses. Real fire volume:
│   │   π×228²×580mm = 5,780.25in³ = 100.75% of the 5,737in³ target [was
│   │   102.7% under the old rectangular design]. Real CGAL seal-weld:
│   │   non-empty contact vs the chamber's own solid wall, confirmed;
│   │   zero-contact vs the outer shell RE-CONFIRMED EMPTY)
│   ├── Firebox passage (v15 TASK 3 REBUILT as a plain CIRCLE — was v14.2's
│   │   trapezoid, derived from the octagon's taper to match a RECTANGULAR
│   │   duct's footprint; no longer has a natural basis now the duct is
│   │   round. Real target area [0.008x the new real fire volume]:
│   │   46.242in²=29,833.5mm², diameter 194.898mm. REAL FINDING: the fire
│   │   cylinder's own true center now sits BELOW chamber_floor_z entirely
│   │   [direct consequence of TASK 1's height growth] — passage biased to
│   │   the cylinder's own real top [5mm margin, judgment call, flagged].
│   │   Real CGAL measurement [STL volume, not estimated]: 88.7% of the
│   │   circle's own area is genuinely cut through real chamber material,
│   │   ~11.3% a real confirmed chord below the floor [matches this
│   │   project's own v13/v14 precedent for circular-passage findings])
│   ├── Outer shell + outer shell end-cap (v15 TASK 1 REBUILT as a true
│   │   580x580x580 CUBE [FIREBOX_H 428.6->580mm, FIREBOX_W unchanged,
│   │   FIREBOX_L now 580mm too — all 3 real dimensions equal, "dice"
│   │   proportions per Janis's own explicit direction]. Flange/end-cap
│   │   construction UNCHANGED CODE [`outer_shell_footprint_2d()`/
│   │   `outer_shell_flange_cut_2d()`, reused as-is, automatically consume
│   │   the new FIREBOX_H/L live]. Real, direct consequence: the firebox
│   │   now extends 351.335mm below chamber_floor_z [was 199.935mm] —
│   │   closes ~151mm of the real gap to the axle plane [understructure's
│   │   own concern, next round]. Real CGAL re-verification [mandatory, not
│   │   assumed]: the flat "no material below the floor" construction still
│   │   Simple:yes at the new, much larger range. Zero-contact vs the fire
│   │   cylinder RE-CONFIRMED EMPTY)
│   ├── Fire cylinder partition (v15 TASK 4, NEW — square end plate
│   │   matching the outer shell's own real 580x580 exterior footprint
│   │   minus a circle matching the cylinder's own real diameter [+2e real
│   │   clearance vs an exact-diameter coincident-surface touch], locates
│   │   the cylinder within the square shell per Janis's reference photo.
│   │   REAL BUG FOUND+FIXED VIA CGAL: positioned flush at exactly
│   │   X=firebox_x1 produced a real Simple:no coincident-face result
│   │   against the door — pulled back by a real e=0.01mm epsilon,
│   │   re-verified Simple:yes/empty. Real CGAL: non-empty contact vs the
│   │   outer shell's own wall, EMPTY vs the cylinder and the door)
│   ├── Ash tray — RETIRED v19 (module + ASH_TRAY_* constants +
│   │   ash_tray_out_pct parameter all removed, R-009 zero remaining
│   │   consumers) per Janis's own explicit, direct instruction: "just
│   │   remove this tray, keep cylinder clean" (flagged as asked "4-5
│   │   versions ago" previously, never actually done until this round)
│   └── Firebox door (hinged, joggle-step joint — UNCHANGED CODE, real
│       dimensions stay 580mm wide [FIREBOX_W unchanged], now mounted on a
│       taller 580mm-high shell [was 428.6mm], flagged real consequence)
│       └── Air-intake damper cutout
├── Exhaust Room (half-cylinder, welded to front end-cap) — RESIZED v3 (360x100mm, was 200x200mm v2)
│   └── Chimney Pipe (coaxial, sits on the room's own top plate) — RE-POSITIONED v3
└── Understructure (v6 — TASK 0: pointer bumped v14.2->v15, wires v15's
    │   real square-shell/cylinder firebox into the full assembly chain
    │   for the first time. chamber_floor_z/chamfer/chamber_W all
    │   UNCHANGED by v15 — front bracket flush-fit is a re-CONFIRMATION,
    │   not a rebuild, re-verified live via CGAL not assumed. LEG_DROP/
    │   REAR_BRACKET_H/CASTER_PLATE_BOTTOM_Z/FRONT_SPACER_LEN all recompute
    │   AUTOMATICALLY via their own unchanged live formulas the instant
    │   this pointer moves — zero additional code change needed)
    ├── Rear axle (fixed, non-swivel. WHEEL_D/WHEEL_R/TREAD_W UNCHANGED
    │   457.2/228.6/200. REAR_AXLE_Z UNCHANGED [=WHEEL_R=228.6]. REAR_AXLE_X
    │   formula UNCHANGED but real value shifts +60mm [1203.5, was 1143.5]
    │   since v15's own firebox_x1 grew while firebox_x0 stayed pinned —
    │   real, flagged, automatic consequence. REAR_WHEEL_Y_LEFT/RIGHT now
    │   driven by TASK 2's narrower TRACK_WIDTH[980mm] = -185/795mm [was
    │   -235/845mm] — real 100mm gap to the firebox's own outer-shell edge
    │   each side [was 150mm, firebox insulated, wheel sits closer].
    │   REAR_BRACKET_H recomputes AUTOMATICALLY via v15's new
    │   firebox_floor_z [191.4mm, was 342.8mm] — TASK 4, zero code change.
    │   v12 TASK 3: TRACK_WIDTH now 880mm [was 980mm, TRACK_WIDTH_FIREBOX_
    │   GAP 100->50mm], REAR_WHEEL_Y_LEFT/RIGHT = -135/745mm [was
    │   -185/795mm]. No kinetic parameter — static)
    │   ├── Rear spacers x2 (construction UNCHANGED — real lengths change
    │   │   automatically from the new REAR_WHEEL_Y_LEFT/RIGHT)
    │   └── Rear fenders x2 (v12 REBUILT to Janis's own precise real spec,
    │       rear wheels ONLY — the v6-v11 wraparound-hood/flared-wing
    │       construction RETIRED entirely. NEW: flat rectangular deck
    │       plate, 300mm real fixed outward extension from the firebox
    │       outer shell's own wall [not re-derived from a formula],
    │       548.64mm long [WHEEL_D*1.2, centered on REAR_AXLE_X], 15mm
    │       droop at each 54.864mm [10%] end via hull() between identical
    │       rectangular cross-sections. fender_z[underside]=472.2mm
    │       [REAR_AXLE_Z+WHEEL_R+15] live-confirmed. Real live OpenSCAD
    │       CGAL [isolated via toggle override, not the full-assembly
    │       aggregate]: EMPTY vs tire [real bisected margin = exactly
    │       15mm: 14.9mm clean/15.0mm exact tangency/15.1mm real overlap],
    │       EMPTY vs axle/struts, NON-EMPTY vs outer_shell [24 real
    │       facets, genuine weld contact via FENDER_WELD_OVERLAP=1.5mm,
    │       UNCHANGED value])
    ├── Front wheel support (bracket's own MAIN SHAPE UNCHANGED. LEG_DROP's
    │   own FORMULA UNCHANGED from v5 but real value recomputes
    │   AUTOMATICALLY via v15's new firebox_floor_z [351.335mm, was
    │   199.935mm] — TASK 5, zero code change beyond the pointer bump; leg
    │   bottom still lands EXACTLY at firebox_floor_z[420mm]. Caster
    │   top-plate/front spacer recompute automatically too [185.4mm, was
    │   336.8mm]. *** REAL, CGAL-CONFIRMED: THE FRONT-WHEEL/BRACKET
    │   COLLISION RE-CHECK AT THIS ROUND'S OWN FURTHER-CHANGED GEOMETRY
    │   (TASK 8) STILL CONFIRMS EMPTY *** — re-verified via a real
    │   intersection() probe at the new 980mm track/351.335mm LEG_DROP/
    │   lowered TRIANGLE_Z, not assumed resolved just because v5 already
    │   resolved it once)
    │   ├── Front spacer (real LENGTH recomputes automatically, unchanged
    │   │   construction)
    │   ├── Dual rigid wheels (UNCHANGED mechanism, respans automatically
    │   │   with the new shared TRACK_WIDTH)
    │   └── Tow handle + puller triangle bracket (TASK 6 REBUILT mount +
    │       TASK 7 length re-verified unaffected. TRIANGLE_Z = FRONT_AXLE_Z
    │       directly [228.6mm, was FRONT_AXLE_Z+100=328.6mm floating above
    │       the axle's own real plane, a v3-era carryover, Janis's own
    │       annotated finding]. NEW curved gusset fillet [GUSSET_R=30mm,
    │       judgment call, flagged — no reference photo directly available
    │       this session] via hull() of two spheres, bridging the flat
    │       triangle plate's own underside to the round stub axle's own
    │       surface at their shared mounting point — real CGAL: genuine
    │       volume overlap vs BOTH the plate and the axle, confirmed.
    │       TBAR_LEN UNCHANGED VALUE [1102.735mm, DATUM_Z_RIDGE/WHEEL_R
    │       both untouched by v15])
    │       ├── Kinetic: handle_fold_deg — default UNCHANGED 90 [vertical
    │       │   storage, fixed last round]. *** REAL, FLAGGED SIDE EFFECT
    │       │   OF TASK 6, NOT THE GOAL BUT A WELCOME CONSEQUENCE ***:
    │       │   since TRIANGLE_Z dropped 100mm, the tip's real Z at the
    │       │   90deg default is now 1331.335mm — 50mm BELOW the roof
    │       │   [DATUM_Z_RIDGE=1381.335mm] this time [was 50mm ABOVE under
    │       │   v5] — the v5-flagged roof-overshoot resolves as a real
    │       │   side effect, confirmed via echo not assumed
    │       └── Kinetic: steer_deg — UNCHANGED mechanism, re-verified via a
    │           real CGAL sweep (0/+-22.5/+-45/90) at the new narrower
    │           track + lowered gusset assembly, confirmed empty throughout
    └── ~~Prep shelves x2~~ — REMOVED v12 (2026-07-22) from this branch
        entirely (module + mounting brackets + exclusive constants,
        R-009 confirmed zero remaining callers). RELOCATED to the
        Accessories branch (BBQ-offset-smoker-base-v3.scad, below),
        parented to the Cook Chamber's own new fixed-band datum — not a
        removal from the product concept, see design_scope_of_work_rule.md
└── Accessories (v21/base-v3 — NEW branch, 2026-07-22. FIRST entry: the
    relocated prep tray. LINKAGE FIX (bbq-base-chain-recalibration,
    2026-07-22, zero geometry changed): `BBQ-offset-smoker-base-v3.scad`'s
    own `include` is now ONLY `BBQ-understructure-v13.scad` [pure
    pointer-only bump to `BBQ-chambers-v21.scad`, R-009-confirmed
    zero-consequence for understructure's own geometry] — single path
    restored (base-v2's own direct chambers include, a real but temporary
    workaround from the immediately-prior round, NOT carried forward).
    Real, CGAL-confirmed: fender+wheels+lid-shift+trays ALL present
    together in ONE unified render [4377 facets, 6 volumes], zero
    double-rendered chamber geometry [confirmed via facet arithmetic: 4317
    understructure+chambers + 60 tray facets = 4377 exactly]. Planned NEXT
    addition: a lid counterbalance/fulcrum mechanism, Janis still
    developing the concept — deliberately NOT designed this round, header
    note only, zero code)
    └── Prep trays x2 (Parent: the Cook Chamber's own NEW fixed band,
        above — real hinge weld point, not an independently-derived
        datum. 457.5mm long [X, `chamber_L/2`] x300mm deep [Y, deployed]
        x2mm plate each, 5mm gap CONFIRMED ADDITIVE [920mm real total
        span, 5mm more than chamber_L, not shrunk to fit]. Mounted ONLY
        on the Y=0 side [confirmed by construction]. 2 hinges each, real
        weld to the fixed band at HINGE_Z=980mm [read live,
        NEW_SPLIT_Z-20, not hardcoded]. 2 REAL BUGS FOUND+FIXED VIA LIVE
        CGAL SWEEPS BEFORE SHIPPING: (1) an early draft deployed the
        plate toward +Y [into the chamber's own DATUM_Y_CENTER
        territory] — a real, confirmed collision vs
        `front_wheel_support()` at -30°/-60° — fixed to deploy toward -Y
        [outward, per the Standing Orientation Convention]. (2) pivoting
        exactly at the wall face made the plate's own 2mm thickness
        sweep into real wall material at intermediate angles
        [`Simple: no` at 0°] — fixed via a real 5mm `HINGE_PIVOT_OFFSET`
        hinge-knuckle standoff. Also: `HINGE_OFFSET` 60->90mm [tray1's
        far hinge bisected-confirmed to overlap the firebox's own real
        flange material below X=858mm]. Real live CGAL, all re-verified
        after fixes: full angle sweep [-90° to 0°, 9 steps] vs the
        chamber shell/closed lid/current understructure geometry
        [wheels, front bracket]/firebox all EMPTY; both trays deployed
        vs each other EMPTY [5mm real margin]; hinges vs the fixed band
        NON-EMPTY [real weld contact]; hinges vs the lid's own full
        opening sweep EMPTY at every angle checked. RE-VERIFIED
        2026-07-22 (bbq-base-chain-recalibration, linkage-only fix) in
        the REAL unified assembly (BBQ-offset-smoker-base-v3.scad) — the
        understructure geometry check above now runs against the
        NOW-PRESENT real wheels/front bracket in the SAME file, not a
        separate standalone probe (PR #143's own real gap) — EMPTY at
        all 9 swept angles, confirmed
        ├── Kinetic: tray0_angle_deg — real range -90°[stowed,vertical]
        │   to 0°[deployed,horizontal], own independent parameter
        └── Kinetic: tray1_angle_deg — same real range, independent from
            tray0_angle_deg [not shared, per spec]
```

## PART C — Kinetic Dual-View Table

Per the Kinetic Dual-View Convention (SKILL_product_design_skeleton.md),
every part below got both end states established as real toggles/
parameters from its first committed version, and both states were
verified via real CGAL render this session (not just the default state
— see cc_chat_log.md for the actual sweep record):

| KINETIC PART | STATE A | STATE B | Notes |
|---|---|---|---|
| Lid | closed (`lid_open_deg=0`) | open (`lid_open_deg` up to 120, real CGAL-confirmed ceiling, re-verified after the v3 mirror — stays clean well past that too, 120 chosen as a practical usable-design max, not a hard collision limit) | v3: ridge-hinged, full-length, rotate([-deg,0,0]) about an X-axis line — SIGN FLIPPED from v2's rotate([+deg,0,0]) since the lid is now mirrored to the opposite (Y=0) side; verified via real CGAL bounding-box check, not assumed from symmetry |
| Firebox door | closed (`firebox_door_open_deg=0`) | open (up to ~110) | Continuous angle, unchanged from v1 (DO NOT TOUCH this session). *** REAL DEFECT FLAGGED, STILL NOT FIXED *** (found during understructure v5's own kinetic sweep, RE-CONFIRMED identically this round, v15): real CGAL-confirmed non-manifold (Simple:no) at roughly >90-95deg open, reproduced identically on standalone BBQ-chambers-v14/v14.1/v14.2/v15 — pre-existing in the frozen firebox_door() code across every version tested, NOT introduced by v15's own real cube-shell/cylinder redesign (a real, deliberate re-check this round, not assumed still true). Needs a future chambers-scoped round |
| Chimney (fold) | REMOVED v2 | REMOVED v2 | v1's foldable chimney/drop-tube replaced by a fixed exhaust room + pipe (v2 TASK 2) — no fold mechanism in this version, flagged as a real scope change, not silently dropped |
| ~~Prep shelves~~ | REMOVED v12 | REMOVED v12 | Module + `shelf_deployed` parameter REMOVED entirely from Understructure (2026-07-22) — relocating to a separate accessories file next round, own new kinetic parameter(s) to be established there, not carried over |
| Prep tray 0 (base-v2, NEW) | stowed (`tray0_angle_deg=-90`, vertical) | deployed (`tray0_angle_deg=0`, horizontal, default) | Continuous angle, own independent parameter. Real live CGAL: full sweep (9 steps) vs chamber shell/closed lid/understructure/firebox all EMPTY (2 real bugs found+fixed first, see PART B) |
| Prep tray 1 (base-v2, NEW) | stowed (`tray1_angle_deg=-90`, vertical) | deployed (`tray1_angle_deg=0`, horizontal, default) | Continuous angle, own independent parameter (NOT shared with tray 0, per spec) — same real verification as tray 0, plus both-deployed-simultaneously vs each other EMPTY (5mm real margin) |
| Tow handle (v6 TASK 6) | towing/use (`handle_fold_deg=0`, horizontal) | folded vertical storage (`handle_fold_deg=90`, UNCHANGED default from v5) | Continuous angle. `TRIANGLE_Z`=`FRONT_AXLE_Z` directly now (228.6mm, was `FRONT_AXLE_Z+100`=328.6mm floating above the axle plane — Janis's own annotated finding, fixed) + new curved gusset fillet bridging the plate to the stub axle. `TBAR_LEN` UNCHANGED (1102.735mm). Real, flagged side effect of the `TRIANGLE_Z` fix (not the goal of TASK 6): tip Z at the 90deg default is now 50mm BELOW the roof (was 50mm above under v5) — the v5-flagged roof-overshoot resolves as a welcome consequence, confirmed via echo. `steer_deg` UNCHANGED mechanism, re-verified via a real CGAL sweep at the new narrower track — still a SEPARATE parameter from fold, not its own dual-view row |

Static/removable parts (Grill grate segments — *** TEMPORARILY,
independently Z-positioned at GRATE_Z_FIXED=1000mm as of v13, see Part A/B
above, NOT permanent architecture — floor drain valves, toggle-clamp
latches, Rear axle — fixed/non-swivel, no kinetic parameter, and Front
wheel support's own bracket — fixed weldment, the caster's swivel IS the
`steer_deg` kinetic captured above, not separately modeled) are NOT
independently kinetic beyond what's listed — they get a `show_*`
isolation toggle only (Toggle-Completeness Rule), not a dual-view kinetic
state.

## Toggle-Completeness count (2026-07-22, v1.24)

LINKAGE-ONLY FIX (bbq-base-chain-recalibration) — NO toggle count change.
BBQ-offset-smoker-base-v3.scad ASSEMBLY: 1 module (`trays`), 1 toggle
(`show_trays`) — same as base-v2's own count, content copied forward
verbatim. BBQ-understructure-v13.scad: 3 modules/3 toggles, UNCHANGED
from v12 (pure pointer-only bump). BBQ-chambers-v21.scad: 15 toggles,
UNCHANGED. Combined total: still 19 real toggles — this round reconnects
files, it does not add/remove any ASSEMBLY-called module.

## Toggle-Completeness count (2026-07-22, v1.23)

BBQ-offset-smoker-base-v2.scad ASSEMBLY (NEW file): 1 module called
(`trays`), 1 real toggle (`show_trays`) — 0 gaps. BBQ-chambers-v21.scad
ASSEMBLY UNCHANGED count/toggles from v20 (still 15) — TASK 1 modified 2
existing masks + 1 existing panel construction, not a new ASSEMBLY-called
module. BBQ-understructure-v12.scad UNCHANGED this round (frozen, DO NOT
TOUCH). Combined total: 19 real toggles across all 3 files (was 18).

## Toggle-Completeness count (2026-07-22, v1.22)

BBQ-understructure-v12.scad ASSEMBLY: 3 modules called (`rear_axle`,
`rear_fenders`, `front_wheel_support`), UNCHANGED from v11 minus
`prep_shelves()` (REMOVED, TASK 1 — relocating next round). All 3
remaining modules have a real `show_*` toggle — 0 gaps. BBQ-chambers-v20
ASSEMBLY UNCHANGED, out of scope this round (still 15 real toggles).
Combined total: 18 real toggles (was 19).

## Toggle-Completeness count (2026-07-21, v1.21)

BBQ-understructure-v8.scad ASSEMBLY: 4 modules called, UNCHANGED count from
v7 (only `prep_shelves()`'s own internal placement math changed this
round). BBQ-chambers-v17.scad ASSEMBLY: 8 top-level modules called,
UNCHANGED count from v16 — but real toggle GRANULARITY increased inside
`firebox()`: 4 of its own sub-parts now have independent `show_*` toggles
(Janis's own explicit request), so 15 real toggles now gate the chambers
block (was 8). 12/12 top-level modules still compliant, 0 gaps on anything
asked for, 0 safety-critical exceptions needed.

## Toggle-Completeness count (2026-07-21, v1.20)

BBQ-understructure-v7.scad ASSEMBLY: 4 modules called (`rear_axle`, `rear_
fenders`, `front_wheel_support`, `prep_shelves`) — all 4 have a real
`show_*` toggle, UNCHANGED count from v6 (only `rear_fenders()`'s own
internal shape logic changed this round). BBQ-chambers-v16.scad ASSEMBLY:
8 modules called, all 8 toggled, UNCHANGED count from v15 (this round's 4
fixes rebuilt shape-derivation logic inside existing modules, no new
top-level module added/removed). 12/12 compliant across the full assembly,
0 gaps, 0 safety-critical exceptions needed.

## Toggle-Completeness count (2026-07-20, v1.19)

BBQ-understructure-v6.scad ASSEMBLY: 4 modules called (`rear_axle`, `rear_
fenders`, `front_wheel_support`, `prep_shelves`) — all 4 have a real
`show_*` toggle, unchanged from v5. `tow_bracket_gusset()` NEW but a
sub-part of `front_swivel_assembly()`, no separate toggle needed (same
pattern the tow triangle/handle already use). BBQ-chambers-v15.scad
ASSEMBLY (unchanged this round — chambers not touched): 8 modules called,
all 8 toggled, carried over unchanged. 12/12 compliant across the full
assembly, 0 gaps, 0 safety-critical exceptions needed.

## Toggle-Completeness count (2026-07-20, v1.17)

BBQ-understructure-v5.scad ASSEMBLY: 4 modules called (`rear_axle`, `rear_
fenders` [NEW], `front_wheel_support`, `prep_shelves`) — all 4 have a real
`show_*` toggle. BBQ-chambers-v14.2.scad ASSEMBLY (unchanged, frozen this
round): 8 modules called, all 8 toggled, carried over unchanged. 12/12
compliant across the full assembly, 0 gaps, 0 safety-critical exceptions
needed.

## Toggle-Completeness count (2026-07-17, v1.11)

BBQ-chambers-v11.scad ASSEMBLY: 8 modules called (`chamber_shell`, `lid`,
`lid_hardware`, `firebox`, `exhaust_room`, `chimney_pipe`, `grill_grate`,
`floor_drains`) — all 8 have a real `show_*` toggle, carried over
unchanged from v2. 8/8 compliant. `firebox_near_wall_closure()`,
`firebox_upper_wall_seal()` (v11 NEW — same no-separate-toggle sub-part
status, called from `firebox()` alongside `firebox_near_wall_closure()`),
`lid_territory_margin_fill()` (v8 — REPLACES `lid_territory_end_caps()`,
PR #121/v6, same no-separate-toggle sub-part status), and
`firebox_passage()` are all sub-parts called from within
`chamber_shell()`/`firebox()`, same pattern as `fire_grate()`/`ash_tray()`
— no separate toggle needed. `chamber_inner_cavity()` RETIRED entirely as
a standalone module (v8 — its job is now `octagon_ring()`'s own internal
step, reused by both `chamber_outer_tube()` and
`lid_territory_margin_fill()`), never had its own toggle either way (not
ASSEMBLY-called). `fixed_shell_profile()` DELETED (v9 — zero remaining
real callers after `firebox_passage_profile()`'s rebuild), also never
ASSEMBLY-called, no toggle count change. `show_lid_hardware` still
defaults FALSE — see PART_MANIFEST.md.

BBQ-understructure-v3.scad ASSEMBLY: 3 modules called (`rear_axle`,
`front_wheel_support`, `prep_shelves`) — was 4 in v2 (`show_tow_handle_assembly`
correctly RETIRED, not a gap: the triangle/handle are no longer an
independent mechanism, TASK 4 rigidly welds them into
`front_wheel_support()`'s own swivel assembly, so they're now a sub-part
of that ONE toggle, same as any other sub-part). 3/3 compliant. Sub-parts
(`rear_axle_bracket()`/`rear_spacers()`/`rear_wheels()`,
`front_bracket()`/`front_caster_plate()`/`front_swivel_assembly()`/
`front_spacer()`/`front_stub_axle()`/`front_wheels()`/`tow_triangle()`/
`tow_handle()`, `tray_mount_bracket()`) are called from within their own
single ASSEMBLY-toggled wrapper — same no-separate-toggle sub-part pattern
`chamber_shell()`'s own sub-parts already use, not a new exception.

No safety-critical no-toggle exceptions needed this version (nothing in
this product blocks hand access the way VM-01/VM-02's drop-zone guards
do).
