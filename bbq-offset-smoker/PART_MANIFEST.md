# PART_MANIFEST.md — BBQ Offset Smoker
# What every ASSEMBLY-called module actually IS, in plain language.
# Read by: Claude Web + cc, before any QA session and before adding any
# new part. Update this file in the SAME prompt that adds/renames/removes
# any ASSEMBLY-called module — never let it drift from the real file.
#
# Version: 1.15 — 2026-07-20 (bbq-chambers-v14.2-passage-area-fix-real-cut-
# check): chambers table REBUILT — source now BBQ-chambers-v14.2.scad, two
# targeted fixes on the just-merged v14.1 (chamber apex/firebox width/
# fire-volume math ALL FROZEN, understructure v4 COMPLETELY untouched).
# Trapezoid resized to the real 0.008-of-fire-volume opening-area target
# (47.124in²=30,402.6mm², was 2.25x oversized) — bottom=95.29mm/
# top=227.00mm, same taper. Per Janis's own direct clarification
# (overrides this round's own prompt-file "height frozen" note, flagged):
# bottom stays at chamber_floor_z, top rises to 20mm below the inner
# duct's own real top wall (960mm, was 950mm=apex A) — height grows
# 178.665→188.665mm. REAL cut-penetration defect found via an actual CGAL
# ray-probe (NOT the benign v14.1 axial-camera artifact — a genuinely
# different bug): v14.1's flange/end-cap simplification left them PLAIN
# unperforated rectangles, sealing the passage shut even though the
# chamber wall and duct end cap both had a real hole (matches Janis's
# "very large but not cut through"/"thin film" report). Fixed via new
# `outer_shell_flange_cut_2d()` — see BBQ-chambers-v14.2.scad's own header
# for the full record.
# Previous: 1.14 — 2026-07-20 (bbq-chambers-v14.1-flat-tuckunder-trapezoid-
# passage): chambers table REBUILT — source now BBQ-chambers-v14.1.scad,
# targeted bug-fix + simplification round on the just-merged v14.
# Previous: 1.13 — 2026-07-18 (bbq-chambers-v14-apex950-firebox-widen-dual-
# endcap): chambers table REBUILT — source now BBQ-chambers-v14.scad,
# CHAMBER+FIREBOX round (understructure v4 COMPLETELY untouched/not
# opened — its own `include` bump to v14 is a later, separate round).
# Previous: 1.12 — 2026-07-17 (bbq-chambers-v13-reanchor-grate-decouple-rear-
# passage): chambers table REBUILT — source now BBQ-chambers-v13.scad,
# CHAMBER-ONLY round (firebox v12 and understructure v4 both frozen, zero
# changes to either's own dims/anchor; understructure's own `include`
# pointer-bumped to v13, not a design change). `chamber_floor_z` changed
# from a 600mm literal to a live formula (900-chamfer) so apex A/`GRATE_Z`
# lands at EXACTLY 900mm (real, algebraic — was 778.665mm through v12,
# last round's own honestly-flagged finding). `grill_grate()` Z-anchor
# DECOUPLED from the chamber body — new `GRATE_Z_FIXED`=1000mm, ***
# TEMPORARY *** (mandatory in-module comment present), real 100mm air gap
# above apex A, unsupported, expected — a future reinforcement-frame task
# will re-merge it. `firebox_passage_profile()` REBUILT: real
# `intersection()` of the fuel cylinder's actual circle against the live
# octagon boundary (round upper/octagon-clipped lower), replaces the old
# rectangular/inset cut — `PASSAGE_INSET` retired. NEW `firebox_end_cap()`
# REPLACES `firebox_near_wall_closure()`+`firebox_upper_wall_seal()` (both
# retired) — one continuous plate, real aligned hole matching the passage
# cut exactly. Real CGAL seal-weld + no-new-collision checks throughout —
# see cc_chat_log.md for the full record.
# Previous: 1.11 — 2026-07-17 (bbq-chambers-v12-firebox-rebuild-understructure-
# v4-wheel): BOTH tables REBUILT — source now BBQ-chambers-v12.scad +
# BBQ-understructure-v4.scad. TASK 1/2 (chambers): `firebox_shell()`/
# `firebox_near_wall_closure()`/`firebox_upper_wall_seal()`/`ash_tray()`/
# `firebox_door()` all resized from a uniform 457mm cube to independent
# FIREBOX_L/W/H=460/510/428.6mm, world Z=[571.4,1000] (LOCKED spec — real
# mismatch found+flagged vs the prompt's own "apex A=900mm" claim, real
# value 778.665mm, see file header). `fire_grate()` REMOVED ENTIRELY
# (zero remaining callers, R-009-confirmed), REPLACED by new
# `fuel_cylinder()` (388.6mm dia hollow tube, wall_t=3mm, re-derived live
# from the real Task 1 numbers — matches the prompt's own table exactly).
# `ash_tray()` height reduced 80mm->12mm — REAL, FLAGGED consequence of
# fuel_cylinder()'s real 17mm clearance above the firebox floor (was NOT
# requested explicitly, a necessary side effect, real CGAL-confirmed
# clearance). TASK 3 (understructure): WHEEL_D/WHEEL_R/TREAD_W ->
# 457.2/228.6/200 (18", FINAL). REAR_AXLE_Z direct-construction fix
# (=WHEEL_R, GROUND_OFFSET's subtractive role RETIRED) — real, CGAL-
# confirmed wheel-bottom-at-world-Z=0 anchor, both axles. REAR_BRACKET_H
# recomputed 342.8mm (was 350). *** REAL, CONFIRMED, UNRESOLVED COLLISION
# FOUND (NEW, flagged, NOT fixed this round) ***: the bigger/higher-
# anchored front wheels now real-CGAL-intersect the front bracket legs
# (~6mm), front_caster_plate (~6mm, full footprint), and tow_triangle
# (~6mm, full cross-section) — all explicitly DO-NOT-TOUCH/deferred this
# round. See both .scad files' own headers and cc_chat_log.md for the full
# verification record and exact bounding boxes.
# Previous: 1.10 — 2026-07-17 (bbq-understructure-v3-wheel-height-tray-handle):
# BBQ-understructure.scad's own table below REBUILT again for
# BBQ-understructure-v3.scad. Real render review by Janis (actual v2
# screenshots) found 4 things, all fixed: (1) WHEEL_D/WHEEL_R 609.6/304.8
# -> 400/200, single source both axles; front caster ONE wheel -> TWO
# (same single pivot, new stub axle, 120mm center-to-center, TIRE_W
# 150->100). (2) Grate height control value CHANGED: 700-750mm SUPERSEDED,
# new locked target 900-1000mm from true ground — achieved via ONE new
# `GROUND_OFFSET`=150mm constant (chamber/firebox never move,
# BBQ-chambers-v11.scad zero changes) — real grate height 928.665mm.
# `REAR_AXLE_Z`/`REAR_BRACKET_H` recomputed (50mm/350mm, was 304.8/95.2).
# New spacer brackets: front x1 (`front_spacer()`, 394mm, bridges the
# confirmed caster top-plate down to the new axle Z) + rear x2
# (`rear_spacers()`, 278.5mm each, push each wheel axle outward clear of
# the firebox) — front bracket's own MID_H/TOP_W/BOT_W/LEG_GAP/LEG_DROP/
# FRONT_X and rear strut's own REAR_AXLE_X/REAR_TRACK_WIDTH all confirmed
# ZERO diff from v2. (3) `prep_shelves()` re-hinged at real octagon "apex
# A" (world Y=0/610, Z=GRATE_Z=778.665mm — the same point
# `fixed_side_wedge()`/`lid_side_wedge()` already share as the lid's own
# parting-line reference), via new `tray_mount_bracket()` — real CGAL
# contact confirmed (was floating in v2, no real chamber contact). (4) Tow
# handle REPLACES v2's "entirely independent" design (wrong assumption,
# corrected via Janis's own reference photo): triangle bracket now
# RIGIDLY WELDED to `front_spacer()` (the front axle/caster yoke) inside
# new `front_swivel_assembly()` — `steer_deg` now rotates the front wheel
# pair too (coupled steering, real CGAL-confirmed weld + collision-free
# sweep). Handle is now a real T-shaped crossbar
# (`HANDLE_UPRIGHT_LEN`=400/`HANDLE_CROSSBAR_LEN`=300). Fold parameter
# renamed `handle_fold_deg` (was v2's `handle_tilt_deg`) — real CGAL vs
# `exhaust_room()` at full fold: 87.5mm X / 292.5mm Z margins (re-derived
# at the new height/coupled geometry, NOT v2's old 137.5/155mm numbers).
# See BBQ-understructure-v3.scad's own header + cc_chat_log.md for the
# full verification record. BBQ-chambers-v11.scad's own table (below)
# UNCHANGED this session (chambers file itself not touched, per DO NOT
# TOUCH).
# Previous: 1.9 — 2026-07-17 (bbq-understructure-v2-axles-swivel-handle):
# BBQ-understructure.scad's own table below REBUILT for BBQ-understructure-v2.scad.
# v1's explicit placeholders (`legs()`/`casters()`/`tow_handle()`) REPLACED
# wholesale with 3 real, mutually-UNRELATED mechanisms: TASK 1 `rear_axle()`
# (fixed non-swivel axle, 2 big 609.6mm wheels, under the firebox, real
# track width 857mm derived from the firebox footprint + 200mm clearance
# each side); TASK 2 `front_wheel_support()` (ONE bent-sheet bracket, real
# trapezoid geometry derived from the chamber's own chamfer/chamber_W —
# MID_H=89.332mm/TOP_W=431.335mm/BOT_W=252.670mm — carrying a single swivel
# caster reusing TASK 1's own 609.6mm wheel spec, flagged judgment call);
# TASK 3 `tow_handle_assembly()` (top-view triangle + hinged handle,
// `handle_tilt_deg` kinetic 0..90, `steer_deg` independent). Real CGAL:
# leg-top-edge flush fit vs `true_octagon_profile()` at h=MID_H confirmed
# (both endpoints land exactly on the real chamfer boundary, non-empty
# material probe both ends); front bracket vs `prep_shelves()` intersection
# probe EMPTY (no conflict); handle at full-vertical tilt vs `exhaust_room()`
# intersection probe EMPTY (137.5mm real X clearance, 155mm real Z
# clearance). Full kinetic sweep (handle_tilt_deg 0/45/90, steer_deg
# +/-45, combined with lid/door/tray/shelf states) all Simple:yes. `legs()`/
# `casters()`/`tow_handle()`/`caster()` REMOVED (zero remaining callers,
# R-009-confirmed) — `CASTER_CLEARANCE`/`leg_h`/`LEG_INSET`/`SHELF_D`/
# `SHELF_T` KEPT (still real consumers via `prep_shelf()`, DO NOT TOUCH);
# `LEG_TUBE`/`CASTER_D` REMOVED (were exclusively consumed by the now-
# removed modules, confirmed orphaned before removing). See
# BBQ-understructure-v2.scad's own header + cc_chat_log.md for the full
# verification record. BBQ-chambers-v11.scad's own table (below) UNCHANGED
# this session (chambers file itself not touched, per DO NOT TOUCH).
# Previous: 1.8 — 2026-07-17 (bbq-chambers-v11-firebox-wall-seal): source
# now BBQ-chambers-v11.scad. THE REAL FIX for the "triangle leak" (v9's
# 1.7 entry below left it KT-exhausted/unexplained after 3 rounds) — root
# cause found by Janis directly, independently confirmed by Claude via a
# real local render before any code was written. The octagon narrows near
# the floor (bottom two chamfers); `firebox_shell()` is a plain square —
# above `chamber_floor_z` the square sticks out past the true octagon
# boundary on both sides, and nothing ever built a closing panel there
# (`firebox_near_wall_closure()` only ever covered BELOW `chamber_floor_z`).
# New `firebox_upper_wall_seal()` (+ `firebox_upper_wall_seal_2d()`) closes
# exactly that region, built from the real `firebox_square_2d()`/
# `fixed_side_solid_2d()` boolean (both unchanged). Verified: real CGAL
# probe confirms the two former-gap triangles now solid (added ~31516mm³,
# matches the expected 2x5218.84mm²x wall_t); full kinetic sweep 0-120°
# and the full assembly chain both `Simple: yes`; both panels
# 5218.8436mm² each, confirmed mirror-symmetric. `firebox()`'s entry
# updated to include the new sub-part.
# Previous: 1.7 — 2026-07-16 (bbq-chambers-v9-firebox-passage-true-profile):
# source now BBQ-chambers-v9.scad. DOES NOT FIX THE "TRIANGLE LEAK" — the
# prompt theorized `firebox_passage_profile()`'s use of `fixed_shell_profile()`
# (fake diagonal) instead of the true-octagon+wedge construction was the
# cause; independent verification (real geometric XOR test) proved these
# two shapes are IDENTICAL, so the rebuild changes zero geometry (new
# passage area 88209.549116mm², exact match to v8's 88209.5mm²). Still
# implemented as a real code-quality cleanup: new `fixed_side_solid_2d()`
# helper, `firebox_passage_profile()` rebuilt to use it,
# `fixed_shell_profile()` DELETED entirely (confirmed zero remaining real
# callers). The actual "triangle leak" symptom remains UNEXPLAINED after
# 3 real investigation rounds (PR #121 x2, this session) — KT-exhausted,
# needs Janis's direct input, not a 4th guess. See cc_chat_log.md and
# BBQ-chambers-v9.scad's own header for the full verification record.
# Previous: 1.6 — 2026-07-16 (bbq-chambers-v8-regular-octagon-continuous-
# channel): source now BBQ-chambers-v8.scad. Two related fixes. (1)
# `chamfer` corrected 150mm->178.665mm (real `chamber_W/(2+sqrt(2))`
# regular-octagon formula) — forced `GRATE_Z` to become formula-derived
# (`chamber_floor_z + chamfer` = 778.665mm, was hardcoded 750mm) and
# `chamber_floor_z` to become the new fixed PRIMARY DATUM (`grate_clearance`
# retired). (2) `lid_territory_end_caps()` (PR #121/v6) REMOVED,
# `lid_territory_margin_fill()` ADDED — same coverage (X=0-100/815-915),
# now built from the SAME `true_octagon_profile()`+`octagon_ring()`
# construction the fixed-side tube itself uses (was a separately-profiled
# shape via `lid_profile()`) — real CGAL boundary probe confirms no
# closing wall at LID_X0/LID_X1. `chamber_inner_cavity()` RETIRED as a
# standalone module. `firebox_passage()`'s area changed as a real side
# effect (92741.2mm²->88209.5mm², code itself unchanged) — flagged, not
# silently absorbed. `grill_grate()`'s entry updated (GRATE_Z now
# formula-derived, moves automatically).
# Previous: 1.5 — 2026-07-15 (bbq-chambers-v7-fixed-shell-open-channel-
# rebuild, R-111 territory — 3 prior real-but-wrong-module fixes: PR #119
# color/opacity, v5's own end-cap gap, PR #121's lid_territory_end_caps()
# hollow rebuild): source now BBQ-chambers-v7.scad. REAL root cause found
# (via local OpenSCAD render before writing any fix): `fixed_shell_profile()`'s
# own PARTING-line closing edge (apex A to ridge midpoint) was never a real
# octagon edge, and extruding it the full chamber_L length turned that seam
# into a permanent spanning panel across the open-lid sightline.
# `chamber_shell()`'s entry CORRECTED (v3-v6 claimed "TRUE 8-point octagon
# profile" — never actually true until now). `chamber_outer_tube()`/
# `chamber_inner_cavity()` REBUILT from a new `true_octagon_profile()` (real
# edges only) + `fixed_side_wedge()` (cutting-plane mask, applied to an
# already-hollow ring, not baked into the profile). `fixed_shell_profile()`
# KEPT unchanged (R-009 check found a 3rd real caller,
# `firebox_passage_profile()`, a separate open item) but no longer used by
# the main tube. `lid_territory_end_caps()` UNCHANGED (PR #121's fix,
# re-verified clean join to the rebuilt tube, not re-touched).
# Previous: 1.4 — 2026-07-14 (direct-cc, R-011, no prompt file — Janis's
# live OpenSCAD-desktop review of v5 found the "reads solid" complaint
# STILL unresolved plus 3 more items): source now BBQ-chambers-v6.scad.
# `lid_territory_end_caps()` REBUILT (v5's own version was a SOLID fill —
# a real design gap in the v5 fix itself, sitting right in an open-lid
# viewer's sightline; now a proper hollow shell). `lid()`'s entry updated
# (LID_X0/X1 margin widened 10mm->100mm each end). `firebox_passage()`'s
# entry updated (PASSAGE_INSET 10mm->15mm). `grill_grate()`'s entry
# updated (GRATE_Z repositioned 700->750, aligned to the lid parting
# line).
# Previous: 1.3 — 2026-07-14 (direct-cc, R-011, no prompt file — 3 findings
# from Janis's annotated OpenSCAD-desktop screenshots of the v4 build):
# source now BBQ-chambers-v5.scad. `chamber_shell()`'s entry updated (new
# `lid_territory_end_caps()` sub-part, closes a real CGAL-confirmed
# unclosed gap at both lid-territory end margins). `grill_grate()`'s entry
# updated (Y-range now real CGAL-confirmed collision-free against the
# fixed shell — was silently colliding, not actually DO-NOT-TOUCH-safe as
# v1-v4 assumed). `window_hole()` REMOVED, `firebox_passage()` ADDED
# (small fixed rectangle -> large profile-intersection opening, per
# Janis's explicit spec).
# Previous: 1.2 — 2026-07-14 (bbq-chambers-v3-closure-exhaust-resize-lid-
# mirror): source now BBQ-chambers-v3.scad. `firebox()`'s entry updated
# (new `firebox_near_wall_closure()` sub-part, closes a real gap below
# chamber_floor_z). `exhaust_room()`/`chimney_pipe()` entries updated
# (resized 200/200 -> 360/100, the 127mm-pipe-vs-200mm-room conflict from
# v2 resolved at the source, no more forced overhang). `lid()`'s entry
# updated (mirrored to the Y=0 side, per the new Standing Orientation
# Convention in rules-bbq-fab.md).
# Previous: 1.1 — 2026-07-14 (bbq-chambers-v2-closure-exhaust-lid): source
# then BBQ-chambers-v2.scad. chamber_shell()'s entry updated (true octagon,
# closure-fixed, no more lid_opening_cut()). lid()'s entry updated (new
# ridge-hinge mechanism, replaces the old end-hinged construction).
# chimney()/drop_tube() REMOVED, exhaust_room()/chimney_pipe() ADDED.
# lid_hardware()'s Toggle changed to default-off (stale v1 positions).
# Previous: 1.0 — 2026-07-13 (bbq-offset-smoker-v1-init): first version,
# seeded from SKELETON_WORKSHEET.md's BOM Subassembly Tree, grounded in
# the real BBQ-chambers-v1.scad + BBQ-understructure.scad.
# Source: BBQ-chambers-v7.scad + BBQ-understructure.scad ASSEMBLY blocks.
#
# Toggle column key: a `show_*` name means the module is gated by that
# toggle, per the Toggle-Completeness Rule (cc_rules.md). "(none — always
# on, safety-critical)" is the ONLY other permitted value.

## BBQ-chambers-v14.2.scad

| Module | What it IS | What it is NOT (only if real confusion risk exists) | Toggle |
|---|---|---|---|
| `chamber_shell()` | UNCHANGED CODE v13 (chamber's own shape frozen, DO NOT TOUCH) — fixed portion of the octagon, full chamber_L length, wall_t hollow. Real world position moves via `chamber_floor_z`'s own new live-formula value (900-chamfer=721.335mm, was hardcoded 600) — every downstream Z (DATUM_Z_RIDGE, ROOM_BASE_Z/TOP_Z, lid panels) recomputes automatically. Rear wall carries the REBUILT `firebox_passage()` (real cylinder∩octagon cut, TASK 3); front end-cap carries exhaust_room_opening() | the lid's own territory for X=[LID_X0,LID_X1] — a SEPARATE part (`lid()`) | `show_chamber_shell` |
| `lid_territory_margin_fill()` | v8 — REPLACES `lid_territory_end_caps()` (PR #121/v6, REMOVED). Same coverage (X=0-100, X=815-915) but now built from the SAME shared `true_octagon_profile()`+`octagon_ring()` helper `chamber_outer_tube()` itself uses (was a DIFFERENT profile, `lid_profile()`, in v6/v7 — two independently-modeled shapes meeting at a seam, which Janis was seeing as a visible wall). Real wall_t end cap ONLY at the true outer end (X=0 or X=915); fully OPEN at LID_X0/LID_X1 — no separate closing face. Real CGAL boundary probe: continuous wall_t-only material at the boundary (~5096mm² cross-section, vs ~308258mm² a solid closing panel would show) | a solid plug (v5's version, already fixed pre-v6) or a separately-profiled shape meeting the tube at a seam (v6/v7's version, the real cause of the visible wall) | (none — sub-part of `chamber_shell()`, no separate toggle) |
| `firebox_passage()` | v14.2 TASK 1 RESIZED + REPOSITIONED (was v14.1's own trapezoid build) — still a real TRAPEZOID (`firebox_passage_profile()`), still a **LOCKED spec** (Janis's real heat-rises/ash-avoidance design choice), NOT a placeholder; taper direction UNCHANGED. Resized to the real 0.008-of-fire-volume opening-area rule (5,890.51in³×0.008=47.124in²=30,402.6mm² — v14.1's own trapezoid was never checked against this and came out 2.25x oversized): bottom=95.29mm/top=227.00mm, same proportional taper as v14.1's real values, scaled down. Repositioned per Janis's own direct clarification (real, flagged deviation from this round's own prompt-file "height frozen" instruction): bottom edge STAYS at `chamber_floor_z` (unchanged anchor); top edge RISES from v14.1's chamfer(=apex A=950mm) to 20mm below the inner duct's own real top wall (960mm) for a real weld-clearance margin — height grows 178.665mm→188.665mm as a direct consequence; the "top edge=apex A" coincidence does NOT carry over. Real CGAL: full containment confirmed, NO chord/partial-clip at the new size/position | a placeholder/adjustable default like v14's retired circle was — this trapezoid is locked; its top edge landing on apex A — that was true only for v14.1's own geometry, not this round's | (none — sub-part of `chamber_shell()`, no separate toggle) |
| `lid(lid_open_deg)` | clamshell lid, 3 flat panels, hinged along the ridge midpoint. v6: margin widened LID_X0=100/LID_X1=815 (715mm long, was 10/905/895mm) — the 2 end zones are now real fixed (welded, non-opening) octagon-ring sections, not a thin plug. v3 MIRRORED to the Y=0 side, opens toward the user. Rotation SIGN flipped from v2 (real CGAL bounding-box check) | the fixed shell's own right wall/chamfer/half-ridge — those stay part of `chamber_shell()` | `show_lid` |
| `lid_hardware(lid_open_deg)` | UNCHANGED code, still built for v1's original end-hinged geometry, now stale across 3 redesigns (v2 ridge-hinge, v3 mirror, v6 margin widen) | a correctly-positioned part — still not repositioned, still explicitly deferred | `show_lid_hardware` — still FALSE by default — TODO: reposition once lid geometry is fully confirmed, follow-up prompt |
| `firebox(firebox_door_open_deg, ash_tray_out_pct)` | v14 REWORK — TWO fully independent welded assemblies (see next 4 rows), NO shared end-cap plate between them (eliminates the full-face thermal-bridge problem the v13 concept had). `firebox_door()` UNCHANGED CODE, real dimensions widen automatically 510->580mm (mounted on the wider outer shell). `ash_tray()` width formula corrected to `DUCT_W`-based (514mm, was `FIREBOX_W`-based/484mm — required real fix, the tray sits inside the duct's real interior, not the wider outer shell) | one shared assembly — this version is deliberately two separate, non-touching solids | `show_firebox` |
| `inner_duct()` / `inner_duct_end_cap()` | v14 TASK 2, NEW — REPLACES `fuel_cylinder()` (RETIRED). Rectangular duct, 540x388.6mm cross-section (20mm uniform margin vs the outer shell on all 4 sides), full `FIREBOX_L`(460mm, UNCHANGED) span, open both ends (same convention as the retired cylinder). Own end cap welds DIRECTLY to the chamber's own octagon end cap (NOT to the outer shell) — real full rectangle minus the SAME passage-hole shape `firebox_passage()` cuts (shared 2D module, judgment call: keeps the duct's interior actually connected to the chamber — flagged, see file header). Real CGAL seal-weld: non-empty contact vs the chamber's own solid wall, confirmed | connected to or touching the outer shell anywhere — confirmed via a real mandatory zero-contact CGAL check | (none — sub-part of `firebox()`, no separate toggle) |
| `outer_shell()` / `outer_shell_end_cap()` | v14.1 TASK 1: flange+end cap use `outer_shell_footprint_2d()`'s plain, UNCLIPPED, full FIREBOX_H x FIREBOX_W rectangle for their ENTIRE height — ONE flat continuous plane, no zones (fixed the real, visible STEP Janis screenshotted). v14.2 TASK 2 REAL BUG FOUND+FIXED: v14.1 never cut a passage hole through this rectangle — since the flange's own footprint is LARGER than the duct's own opening and sits directly in the line of sight, it fully sealed the passage shut even though the chamber wall and duct end cap both had a real hole (found via an actual CGAL ray-probe, not a visual read — matches Janis's own "very large but not cut through"/"thin film" report exactly). NEW `outer_shell_flange_cut_2d()` = `outer_shell_footprint_2d()` MINUS `firebox_passage_profile()` (same shared 2D module), now used at BOTH the flange extrusion and `outer_shell_end_cap()` call sites. Real CGAL: upper portion still has non-empty contact with chamber material, lower portion still EMPTY, zero-contact vs inner duct RE-RUN and still EMPTY, and a real ray-probe (10mm then 80mm rod through the passage) now confirms a genuine unobstructed through-hole | a 2-zone/stepped shape (v14's version); a solid unperforated rectangle blocking the passage (v14.1's real bug, now fixed) | (none — sub-part of `firebox()`, no separate toggle) |
| `exhaust_room()` | half-cylinder mounting room, 360mm dia x 100mm height (v3) — inscribes a real 180mm-diameter circle around the 127mm pipe (26.5mm clearance each side). Endcap opening a rectangle (360x100mm) | v2's 200/200 room (superseded) | `show_exhaust_room` |
| `chimney_pipe()` | 127mm pipe, coaxial with the room's mounting hole, `PIPE_HOLE_X=-90` (v3), real 26.5mm clearance both sides | v2's overhang-compromise position (superseded) | `show_chimney_pipe` |
| `grill_grate()` | UNCHANGED CODE v14 (still `GRATE_Z_FIXED`=1000mm, *** TEMPORARY ***, still DO NOT TOUCH). Real gap above the reanchored apex A (`GRATE_Z`=950mm exact, v14 TASK 1) is now 50mm (was 100mm) — automatic consequence of the chamber's own reanchor, GRATE_Z_FIXED itself untouched. X/Y placement formulas unchanged, real values IDENTICAL to v13 (23/587mm) since GRATE_LOCAL_H is invariant under a uniform +50mm shift of both chamber_floor_z and DATUM_GRATE_Z | GRATE_Z_FIXED is NOT the same value as GRATE_Z/DATUM_GRATE_Z — still two independently-positioned things, still TEMPORARY | `show_grate` |
| `floor_drains()` | 2 placeholder drain valve bosses, front third / back third of chamber length. UNCHANGED this session (DO NOT TOUCH) | | `show_drains` |

## BBQ-understructure-v4.scad

| Module | What it IS | What it is NOT (only if real confusion risk exists) | Toggle |
|---|---|---|---|
| `rear_axle()` | Fixed, NON-swivel axle under the firebox — WHEEL_D/WHEEL_R/TREAD_W now 457.2/228.6/200 (18", FINAL, was 400/200/100). REAR_AXLE_Z now DIRECT CONSTRUCTION (`=WHEEL_R`, GROUND_OFFSET's subtractive role RETIRED) = 228.6mm (was 50) — real-CGAL-confirmed wheel bottom at literal world Z=0 for the first time (mandatory check found the v3 wheel's real bottom at raw Z=-150, confirmed NOT zero, see file header). REAR_BRACKET_H recomputed 342.8mm (was 350). REAR_AXLE_X construction updated for v12's independent firebox_x0/x1 (real value UNCHANGED, 1143.5). REAR_WHEEL_Y_LEFT/RIGHT/REAR_TRACK_WIDTH: UNCHANGED FORMULAS, real values shift to -150/760/910mm (was -123.5/733.5/857) as a flagged side effect of v12's wider firebox. Strut/spacer/beam construction UNCHANGED (DO NOT TOUCH) | a swivel/steerable mechanism — static, no kinetic parameter | `show_rear_axle` |
| `front_wheel_support(steer_deg, handle_fold_deg)` | `front_bracket()`/`front_caster_plate()` UNCHANGED (DO NOT TOUCH this round, zero diff). `front_spacer()` real LENGTH recomputes to 215.4mm (was 394mm, since FRONT_AXLE_Z rose to 228.6). *** REAL, CGAL-CONFIRMED, UNRESOLVED COLLISION (NEW THIS ROUND, flagged not fixed) ***: the bigger 457.2mm wheels, combined with the higher direct-anchored FRONT_AXLE_Z, now really intersect `front_bracket()`'s legs (~6mm real overlap, X=[107.6,242.4]/Y=[178.7,431.3]/Z=[447,453]), `front_caster_plate()` (~6mm, its ENTIRE 100x100mm footprint), and `tow_triangle()` (~6mm, its full cross-section) — all explicitly DO-NOT-TOUCH/deferred this round, so NOT fixed here. Blocking real fabrication until the deferred "front bracket height alignment" follow-up prompt resolves it. See BBQ-understructure-v4.scad's own header and cc_chat_log.md for the full probe record | QA-clean — this is a real, confirmed, unresolved defect, not silently absorbed | `show_front_wheel_support` |
| `tow_triangle()` / `tow_handle(handle_fold_deg)` | TASK 4, REBUILT. Triangle: flat top-view-only plate (TRIANGLE_APEX_X=-300/BASE_X=200/BASE_W=200/T=6), rigidly welded to `front_spacer()` (TRIANGLE_BASE_X extends 25mm past CASTER_X specifically to guarantee real 3D overlap with the 40mm-dia spacer, flagged judgment call, real-CGAL-confirmed non-empty). Handle: REAL T-shaped crossbar (HANDLE_UPRIGHT_LEN=400/D=25 + HANDLE_CROSSBAR_LEN=300/D=25, perpendicular grip at the upright's far end) — REPLACES v2's plain round bar. `handle_fold_deg` (renamed from v2's `handle_tilt_deg` — materially different payload+nesting, not a decimal tweak): 0=towing/use (horizontal) .. 90=folded vertical storage, SAME rotate-about-Y-hinge convention as v2. Real CGAL vs `exhaust_room()` at full fold, steer=0: EMPTY, 87.5mm real X clearance / 292.5mm real Z clearance (re-derived at the NEW height+coupled geometry — v2's old 137.5/155mm numbers explicitly NOT reused) | independent of the front caster (that was v2's wrong assumption, corrected via Janis's reference photo) | (none — sub-parts of `front_wheel_support()`'s own `front_swivel_assembly()`, no separate toggle — v2's separate `show_tow_handle_assembly` toggle correctly RETIRED, since the triangle/handle are no longer an independent mechanism) |
| `prep_shelves(shelf_deployed)` | TASK 3, RE-HINGED. SAME size (`chamber_L*0.35 x SHELF_D x SHELF_T`) and SAME kinetic behavior as v2/v1 (DO NOT TOUCH) — ONLY the mount point changed: was an arbitrary floating point (`DATUM_X_FRONT+LEG_INSET`, `chamber_floor_z`, confirmed NO real chamber contact); now real octagon "apex A" (`true_octagon_profile()` point 3, world Y=0/610, Z=`GRATE_Z`=778.665mm — the SAME point `fixed_side_wedge()`/`lid_side_wedge()` already share as the lid's own parting-line reference), via NEW `tray_mount_bracket()` — real CGAL contact check confirms non-empty shared material with `chamber_outer_tube()`/`lid_territory_margin_fill()` at both trays | the profile's absolute lowest point (that's the floor, Z=600) — apex A is the lowest true WALL/CHAMFER corner, real fixed material regardless of `lid_open_deg` | `show_shelves` |

## Toggle-completeness count (2026-07-17, v1.11)

11 modules called across both ASSEMBLY blocks (8 in chambers, unchanged —
`fuel_cylinder()` is a sub-part of `firebox()`, same no-separate-toggle
pattern `fire_grate()`/`ash_tray()` already used, no new toggle needed; 3
in understructure, unchanged: `rear_axle()`, `front_wheel_support()`,
`prep_shelves()`). 11/11 have a real `show_*` isolation toggle — 0 gaps, 0
safety-critical exceptions needed this version. `show_lid_hardware` still
defaults false (unchanged, chamber's own hardware module not touched this
round either).
