# PART_MANIFEST.md — BBQ Offset Smoker
# What every ASSEMBLY-called module actually IS, in plain language.
# Read by: Claude Web + cc, before any QA session and before adding any
# new part. Update this file in the SAME prompt that adds/renames/removes
# any ASSEMBLY-called module — never let it drift from the real file.
#
# Version: 1.20 — 2026-07-21 (Janis's own SECOND direct-feedback round the
# same day, on the just-pushed v16/v7 fixes): chambers table REBUILT —
# source now BBQ-chambers-v17.scad. 2 real fixes to defects the v16 round's
# own TASK C fix introduced/left unaddressed (found via CGAL, not assumed):
# (1) v16's octagon-clipped flange solid-filled ~48.5mm of the chamber's
# own real hollow interior bore (real, non-empty CGAL overlap) — a genuine
# wall blocking the chamber's interior, never asked for. (2) that same
# clip, re-rendered before shipping, was found to also carve a real hole
# with no material from either part wherever the firebox's 580mm square
# exceeds the octagon's real width — the chamber has zero material outside
# its own true boundary, so clipping the square down to match creates
# exactly the gap it was meant to prevent (matches Janis's own separate
# "missing...end cap that should stretch to fuse with the chamber shell"
# finding). FIX (one redesign resolves both): new `chamber_hollow_cavity_2d()`
# replaces the octagon-clip — the flange's own outer boundary is now always
# the full continuous 580mm square (flush with the main body everywhere,
# zero notches), with only the chamber's own real hollow-bore shape cut
# out of it. Re-verified via CGAL: EMPTY vs the chamber's own hollow
# cavity (2mm real margin), NON-EMPTY vs the chamber's own real wall
# material. Also new: 4 real firebox sub-part toggles
# (`show_fire_cylinder`/`show_fire_cylinder_end_cap`/`show_outer_shell`/
# `show_outer_shell_end_cap`), Janis's own explicit request, so future
# issues can be isolated and reported precisely.
# Understructure table REBUILT — source now BBQ-understructure-v8.scad. 1
# real pre-existing bug found+fixed: `prep_shelves()`'s own right-side
# shelf applied `mirror()` AFTER an already-applied `translate()`,
# reflecting the pre-positioned geometry back around Y=0 instead of onto
# the chamber's opposite side — real, measured consequence (STL vertex-
# extent probe): both shelves landed on the SAME side (combined Y-extent
# [-610,0] instead of one per side) — matches Janis's own "bad tray stack
# in each other". Fixed: dropped the unnecessary `mirror()`, right shelf
# now a direct `translate([0,chamber_W,0])`. Also investigated: the rear
# fender's "coiled" look in Janis's own OpenSCAD-desktop screenshot — a
# real matching-angle F6 (--render) render shows a clean, correct
# flat+curved band, no coil — strong evidence of an F5 Preview
# (unresolved-overlap) rendering artifact, not a real geometry defect;
# flagged for Janis to double-check via F6 specifically.
# Previous: 1.19 — 2026-07-21 (Janis's own DIRECT feedback round, not a new
# CC prompt — 7 real defects across BBQ-chambers-v15.scad/BBQ-understructure-
# v6.scad, explicitly flagged "told chat many time to fix but dont
# effectively fixed"): chambers table REBUILT — source now
# BBQ-chambers-v16.scad. TASK A: `firebox_passage_profile()` REBUILT — real
# root cause found via CGAL+echo diagnostics: v15's own passage circle was
# sized purely from the fire cylinder's own 0.008-fire-volume target-area
# rule, with ZERO reference to real chamber material — 33.233mm of its own
# bottom sat below chamber_floor_z entirely (a literal hole through
# nothing, matching Janis's screenshot). FIX: size/position now DERIVED
# from the real vertical band where the cylinder's own clear bore overlaps
# the chamber's real octagon material (15mm real margins both ends), built
# as `intersection(candidate circle, real chamber material)` — real new
# PASSAGE_R=65.335mm (was 97.449mm). Real CGAL: now fully contained in real
# chamber material AND fully clear of the cylinder's own bore wall. TASK B:
# `fire_cylinder_end_cap_2d()` rebuilt two-zone (octagon-clipped above
# chamber_floor_z / native circle below, new shared
# `chamber_octagon_or_open_below_2d()` mask). TASK C: new
# `outer_shell_flange_footprint_2d()` (two-zone: octagon-clipped, flush,
# above chamber_floor_z / native square below) now feeds
# `outer_shell_flange_cut_2d()` — `outer_shell_footprint_2d()` itself stays
# plain/unclipped (still correctly used by the door-end partition, no
# chamber reference there). TASK D: `FLANGE_LEN` 20->50mm, `FIREBOX_SHELL_L`
# stays the SAME additive formula (630mm, was 600mm; `FIREBOX_L`'s own
# 580mm interior depth untouched). All 5 real CGAL probes for these 4
# fixes returned the expected result. Understructure table REBUILT —
# source now BBQ-understructure-v7.scad, its own `include` bumped
# v6->BBQ-chambers-v16.scad. 1 real fix: `rear_fenders()` REBUILT AGAIN
# (v6's own full-arc-from-the-wall design was STILL the wrong shape per
# Janis's direct feedback) — real root cause found by re-reading the
# ORIGINAL v5 prompt's own written spec text: a FLAT panel over most of
# the run, curving down ONLY after clearing the wheel's own outer edge.
# FIX: real flat plate from the firebox wall to directly above the
# wheel's own center (the real geometric tangent point to `FENDER_R_IN`'s
# own circle), then the existing curved-flare mechanism continues from
# there. Real CGAL: clears the wheel (empty), clears the rear axle/struts
# (empty), real weld contact with `outer_shell()` (non-empty) — re-
# rendered, confirmed a real wraparound hood shape. 3 items from the same
# feedback round NOT addressed this version, pending a reference image/
# clarification (flagged): prep tray/shelf location, front wheel axle
# center bracket ("T bar puller") shape; the wheel-to-firebox 100mm gap
# reconfirmed via echo as already exactly 100mm, unchanged.
# Previous: 1.18 — 2026-07-20 (bbq-understructure-v6-fitment-fixes):
# understructure table REBUILT — source now BBQ-understructure-v6.scad, its
# own `include` bumped v14.2->BBQ-chambers-v15.scad (wires v15 into the full
# assembly for the first time). 4 real fitment fixes from Janis's live
# desktop review: prep shelf now 3 real distributed brackets (was 1,
# cantilevered); TRACK_WIDTH recomputed to 980mm (100mm gap, was 1080mm/
# 150mm); rear fender rebuilt as a real short flared wing (was a long
# straight panel — the flat portion spanned to the wheel's own centerline
# before curving; fixed by starting the arc almost immediately at the real
# angle where it reaches the firebox wall); T-bar bracket now mounts
# directly at the front axle's own real plane with a new curved gusset
# (was floating 100mm above it). REAR_BRACKET_H/LEG_DROP recompute
# automatically via v15's new firebox_floor_z (191.4mm/351.335mm, were
# 342.8mm/199.935mm) — zero code change beyond the pointer bump. TBAR_LEN
# unaffected (1102.735mm) — the v5-flagged 50mm roof-overshoot flips to a
# genuine 50mm real clearance margin as a side effect of the gusset fix.
# Front-wheel/bracket collision re-check at the new geometry: still
# resolved (EMPTY), confirmed not assumed. REAL BUG FOUND+FIXED VIA CGAL:
# the fender's own wider 147deg arc sweep broke the inherited 3-point
# wedge-mask technique (chord cut inside the ring, producing disconnected
# slivers) — fixed with a real multi-point fan mask, re-verified as a
# clean continuous band.
# Previous: 1.17 — 2026-07-20 (bbq-chambers-v15-square-shell-cylinder-
# firebox): chambers table REBUILT — source now BBQ-chambers-v15.scad, real
# structural firebox redesign (understructure v5 completely out of scope,
# not opened). Outer shell rebuilt as a true 580x580x580 cube (FIREBOX_H
# 428.6->580mm); firebox_floor_z now live-derived (420mm, top pinned at
# 1000mm) — firebox now extends 351.335mm below chamber_floor_z (was
# 199.935mm). REAL, NECESSARY FIX found before shipping: firebox_x0
# repinned directly at its own real weld position (913.5mm, unchanged
# value) instead of a historical-midpoint formula that would have pulled
# it 60mm into the chamber's own territory as FIREBOX_L grew (460->580mm).
# Rectangular inner duct RETIRED, replaced by a 456mm-dia fire cylinder
# (62mm wall clearance, real volume 5,780.25in³=100.75% of target). Rear
# passage rebuilt as a circle (194.898mm dia) — real CGAL: cylinder's own
# true center now sits below chamber_floor_z, passage biased to the
# cylinder's real top, 88.7% of the circle's area genuinely cut through
# real material (measured via STL volume), ~11.3% a real confirmed chord.
# NEW fire_cylinder_partition() locates the cylinder in the square shell.
# TWO REAL BUGS FOUND+FIXED VIA CGAL: ash tray width collided with the
# cylinder's own wall (checked the wrong corner) — fixed 150->80mm;
# partition sat exactly coincident with the door's own face — fixed via
# epsilon. SEPARATE, PRE-EXISTING, FLAGGED finding: firebox_door() still
# non-manifold above ~90-95deg open, reproduced identically to the prior
# round, confirms NOT a v15 regression. Full detail in
# BBQ-chambers-v15.scad's own header, SKELETON_WORKSHEET.md,
# design_scope_of_work_rule.md, cc_chat_log.md.
# Previous: 1.16 — 2026-07-20 (bbq-understructure-v5-trackwidth-fender-tbar):
# understructure table REBUILT — source now BBQ-understructure-v5.scad
# (chambers v14.2.scad's own pointer, unbumped since v13, FINALLY wired in
# — TASK 0, real +50mm chamber_floor_z shift, front bracket leg re-verified
# flush via CGAL at the new Z). ONE shared TRACK_WIDTH=1080mm now drives
# BOTH front and rear wheel Y-position (retires REAR_TRACK_WIDTH and the
# front caster's own DUAL_WHEEL_OFFSET spacing) — real, CGAL-confirmed:
# this ALONE resolves the standing ~6mm front-wheel/bracket collision
# flagged since v4 (front wheels now sit 224mm clear of the bracket's own
# widest edge, was overlapping). NEW `rear_fenders()` module (150mm real
# radial clearance arc, welds to the firebox's own outer shell). Front
# bracket tip (`tow_triangle()`) rebuilt round (150mm dia boss, was a sharp
# point). Front U-bracket `LEG_DROP` now a live formula, lands exactly at
# `firebox_floor_z` (was a 150mm literal). T-bar `TBAR_LEN` now a live
# formula (1102.735mm, was 400mm literal); `handle_fold_deg` default fixed
# 0->90 (vertical storage — was shipping flat, a standing v12/v4 QA defect).
# REAL, FLAGGED, NOT SILENTLY ABSORBED finding this round: TBAR_LEN's own
# formula assumes a wheel-height pivot, but this file's real (unchanged)
# TRIANGLE_Z hinge sits 100mm higher — at the new 90deg default the tip's
# Z exceeds DATUM_Z_RIDGE by 50mm; a real CGAL check confirms this causes
# NO actual collision (the T-bar sits forward of/outside the chamber's own
# footprint at that Z), but the numeric margin itself is negative, flagged
# for the record. SEPARATE REAL FINDING, unrelated to this round's own
# scope, found incidentally during this round's own mandatory kinetic
# sweep: `firebox_door()` (frozen chambers code, UNCHANGED) is real,
# CGAL-confirmed non-manifold (Simple:no) at `firebox_door_open_deg`
# roughly >90-95°, reproduced identically on v14/v14.1/v14.2 standalone
# with zero understructure geometry present — pre-existing, NOT introduced
# this round, NOT fixed here (chambers explicitly frozen/DO NOT TOUCH),
# flagged for a future chambers-scoped round.
# Previous: 1.15 — 2026-07-20 (bbq-chambers-v14.2-passage-area-fix-real-cut-
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

## BBQ-chambers-v17.scad

| Module | What it IS | What it is NOT (only if real confusion risk exists) | Toggle |
|---|---|---|---|
| `chamber_shell()` | UNCHANGED CODE (chamber's own shape frozen, DO NOT TOUCH) — fixed portion of the octagon, full chamber_L length, wall_t hollow. Real world position UNCHANGED this round (chamber_floor_z=771.335mm, untouched). Rear wall carries the REBUILT `firebox_passage()` (v16: real material-derived circle, TASK A); front end-cap carries exhaust_room_opening() | the lid's own territory for X=[LID_X0,LID_X1] — a SEPARATE part (`lid()`) | `show_chamber_shell` |
| `lid_territory_margin_fill()` | UNCHANGED CODE. Real, confirmed contact vs `outer_shell()`'s own flange at the chamber's rear-territory zone — SAME real weld contact as every version since v14 | a NEW conflict introduced by this round's firebox changes — confirmed unchanged/pre-existing, not a regression | (none — sub-part of `chamber_shell()`, no separate toggle) |
| `firebox_passage()` | v16 TASK A REBUILT — Janis's own words: "the hole shape is dictate by the cut on the chamber, nothing else". Real root cause of v15's own defect: `firebox_passage_profile()` sized its circle (194.898mm dia) purely from the cylinder's own 0.008-fire-volume target-area rule, with ZERO reference to real chamber material — 33.233mm of its own bottom sat BELOW chamber_floor_z entirely (a literal hole through nothing, confirmed via CGAL+echo, matching Janis's screenshot). FIX: size/position now DERIVED from the real vertical band where the cylinder's own clear bore (225mm) overlaps the chamber's real octagon material at the rear wall (`CYL_WALL_MARGIN`=15mm/`CHAMBER_EDGE_MARGIN`=15mm real insets both ends) — built as `intersection(candidate circle, real chamber material)`, so the final shape is, by construction, always the real chamber cut. Real new `PASSAGE_R`=65.335mm (was 97.449mm — genuinely smaller, a real consequence of deriving from actual available space, not a defect). Real CGAL: passage now FULLY contained in real chamber material (zero residual outside it, confirmed via a real `difference()` probe) AND fully clear of the cylinder's own bore wall (confirmed empty overlap) | a placeholder — both the target radius derivation and the belt-and-suspenders real-material intersection are load-bearing, not decorative | (none — sub-part of `chamber_shell()`, no separate toggle) |
| `lid(lid_open_deg)` | UNCHANGED CODE. Clamshell lid, 3 flat panels, hinged along the ridge midpoint | | `show_lid` |
| `lid_hardware(lid_open_deg)` | UNCHANGED code, stale, still deferred | | `show_lid_hardware` — still FALSE by default |
| `firebox(firebox_door_open_deg, ash_tray_out_pct)` | TWO fully independent welded assemblies (fire cylinder + outer shell, see next rows). v17 NEW: 4 real sub-part toggles (`show_fire_cylinder`/`show_fire_cylinder_end_cap`/`show_outer_shell`/`show_outer_shell_end_cap`), Janis's own explicit request ("Can you make the inner shell of the fire box and outer shell of the fire box can be toggle...both back end cap...toggle on off too") — each independent of `show_firebox` below (which still gates the whole assembly). `fire_cylinder_partition()`/`ash_tray()`/`firebox_door()` NOT separately toggled (not part of this round's ask) | one shared assembly — deliberately two separate, non-touching solids | `show_firebox` |
| `fire_cylinder()` / `fire_cylinder_end_cap()` | Round, 456mm diameter (62mm wall clearance vs the outer shell), full `FIREBOX_L`(580mm) span, open both ends. `fire_cylinder_end_cap_2d()` two-zone: for world Z>=chamber_floor_z clips to the real octagon (`chamber_octagon_or_open_below_2d()` mask, UNCHANGED this round — a cap plate SHOULD be a solid disc, no interior to keep clear, unlike the flange below); below that keeps its native full circle. Own end cap welds DIRECTLY to the chamber's own octagon end cap. Real CGAL seal-weld: non-empty contact vs the chamber's own solid wall; zero-contact vs `outer_shell()` EMPTY. v17 NEW: independently toggleable (`show_fire_cylinder`/`show_fire_cylinder_end_cap`) | connected to or touching the outer shell anywhere — confirmed via a real mandatory zero-contact CGAL check | `show_fire_cylinder` / `show_fire_cylinder_end_cap` |
| `fire_cylinder_partition()` | Square end plate (matches `outer_shell_footprint_2d()`'s own real 580x580 exterior footprint, plain/unclipped) minus a circle matching the cylinder's own real diameter (+2e real clearance) — physically locates the cylinder within the square outer shell. Positioned at the door/front end (X=[firebox_x1-wall_t-e,firebox_x1-e]). Real CGAL: non-empty contact vs `outer_shell()`'s own wall, EMPTY vs the cylinder and the door | welded/fused to the cylinder itself — a separate locating collar, real clearance not material overlap | (none — sub-part of `firebox()`, no separate toggle) |
| `outer_shell()` / `outer_shell_end_cap()` | Real 580x580x580 CUBE. Flange/end-cap footprint v17 REBUILT via new `chamber_hollow_cavity_2d()`, REPLACING v16's own octagon-clip (RETIRED, R-009, 2 real defects found via CGAL+re-render before shipping, not assumed clean): (1) v16's octagon-clip solid-FILLED ~48.5mm of the chamber's own real hollow interior bore — a genuine wall blocking the chamber's interior Janis never asked for ("i didnt ask for this wall!"), confirmed non-empty vs the chamber's own hollow-cavity solid. (2) that same clip ALSO carved a real hole with NO material from either part wherever the firebox's 580mm square exceeds the octagon's real width (the chamber has zero material outside its own true boundary) — matched Janis's separate "missing...end cap that should stretch to fuse with the chamber shell" finding. FIX: the flange's own OUTER boundary is now ALWAYS the full continuous 580mm square (flush with the main body everywhere, zero notches, identical to `outer_shell_footprint_2d()`'s own boundary by construction), with ONLY the chamber's own real hollow-bore shape (`offset(delta=-wall_t) true_octagon_profile()`) cut out of it. Real CGAL: EMPTY vs the chamber's own hollow cavity (2mm real margin, not just an exact touch), NON-EMPTY vs the chamber's own real wall material (genuine structural weld contact preserved). `FLANGE_LEN`=50mm (UNCHANGED this round), STAYS ADDITIVE — `FIREBOX_SHELL_L`=630mm, `FIREBOX_L`'s own 580mm untouched. v17 NEW: independently toggleable (`show_outer_shell`/`show_outer_shell_end_cap`) | a redesigned cube — same cube, only the flange/end-cap's own footprint mechanism changed (twice this round, second attempt is the real fix) | `show_outer_shell` / `show_outer_shell_end_cap` |
| `exhaust_room()` | UNCHANGED CODE, UNCHANGED position this round (chamber_floor_z untouched) | | `show_exhaust_room` |
| `chimney_pipe()` | UNCHANGED CODE | | `show_chimney_pipe` |
| `grill_grate()` | UNCHANGED CODE, UNCHANGED position this round (chamber_floor_z/GRATE_Z untouched) | | `show_grate` |
| `floor_drains()` | UNCHANGED CODE | | `show_drains` |
| `ash_tray(ash_tray_out_pct)` | v15 REQUIRED real fix (R-009 consequence of retiring the rectangular duct's own DUCT_W/DUCT_Y_CENTER). Real width now governed by the fire cylinder's own real chord width at the tray's own FARTHEST-from-center face — REAL BUG FOUND+FIXED VIA CGAL: the first pass (150mm, checking only the tray's TOP corner) found a real, substantial 49,100mm³ overlap with the cylinder's own solid wall — the tray's BOTTOM face is actually farther from center (220mm vs the top's 208mm) and is the true binding constraint (94.34mm safe max, not 171.6mm). Fixed: ASH_TRAY_W=80mm, real margin, re-verified empty. Length grows automatically to 534mm (was 414mm) with the longer cylinder | still 150mm/514mm-class wide like the old rectangular-duct version — the round cylinder's own real geometry is much more constraining | (none — sub-part of `firebox()`, no separate toggle) |

## BBQ-understructure-v8.scad

| Module | What it IS | What it is NOT (only if real confusion risk exists) | Toggle |
|---|---|---|---|
| `rear_axle()` | UNCHANGED this round. WHEEL_D/WHEEL_R/TREAD_W (457.2/228.6/200). REAR_WHEEL_Y_LEFT/RIGHT via `TRACK_WIDTH`(980mm) = -185/795mm — real, reconfirmed via echo: exactly 100mm gap to the firebox's own outer-shell edge each side (Janis's feedback point re-checked as a spec confirmation, not a defect — no code change needed) | a swivel/steerable mechanism — static, no kinetic parameter | `show_rear_axle` |
| `rear_fenders()` | v7 REBUILT AGAIN — Janis's own words: "The fender or mudguard is wrong shape", after v6's own full-arc-from-the-wall rebuild was ALSO wrong. Real root cause found by re-reading the ORIGINAL v5 prompt's own written spec text (not re-guessed): "flat steel panel...straight off the firebox side...curving down after clearing the wheel's outer edge" — a FLAT plate over most of the run, curving down ONLY at the outboard end. v6 had overcorrected into a full semicircular arc starting almost immediately at the firebox wall (zero real flat run), which doesn't match that text either. FIX: real flat plate from the firebox wall to DIRECTLY ABOVE the wheel's own center (`flat_z`=REAR_AXLE_Z+FENDER_R_IN=607.2mm — the one point where a flat plane is geometrically TANGENT to FENDER_R_IN's own circle, forced by tangent-continuity, not a judgment call; matches the spec's own "~150mm gap above the wheel" read as clearance above the wheel's own top point), then the existing curved-flare mechanism (`fender_arc_2d()`, UNCHANGED, multi-point fan mask from the v6 bugfix) continues from there down past the wheel's own outboard tangent edge (UNCHANGED `FENDER_ARC_PAST_EDGE`=25deg). `FENDER_GAP`(150mm)/`FENDER_T`(4mm)/`FENDER_W`(240mm) all UNCHANGED. Real CGAL: EMPTY vs `rear_wheels()`, EMPTY vs `rear_axle_bracket()` (struts/spacers), NON-EMPTY vs `outer_shell()` (real weld contact) — re-rendered visually (isometric), confirmed a real wraparound hood shape (flat top + curved outboard flare), not a side-mounted wing. v8 RE-INVESTIGATED (Janis's OpenSCAD-desktop screenshot showed a "coiled" look) — CODE UNCHANGED this round: a real matching-angle F6 (--render, full CGAL boolean) render reproduces the SAME clean flat+curved band with zero coiling, strong evidence Janis's own screenshot was an F5 Preview (OpenCSG, unresolved-overlap) artifact, not a real geometry defect — flagged for Janis to re-check specifically via F6 (Render), not re-guessed at further without a rendered (not previewed) screenshot | a full wheel-well enclosure — a single flat+curved panel per side, open underneath | `show_rear_fenders` |
| `front_wheel_support(steer_deg, handle_fold_deg)` | `front_bracket()`'s own MAIN SHAPE UNCHANGED. `LEG_DROP`'s own FORMULA UNCHANGED from v5 but real value recomputes AUTOMATICALLY via v15's new firebox_floor_z (351.335mm, was 199.935mm) — TASK 5, zero code change beyond TASK 0's pointer bump; leg bottom still lands EXACTLY at firebox_floor_z(420mm). `front_caster_plate()`/`FRONT_SPACER_LEN` recompute automatically too (185.4mm, was 336.8mm). *** REAL, CGAL-CONFIRMED: THE FRONT-WHEEL/BRACKET COLLISION RE-CHECK AT THIS ROUND'S OWN FURTHER-CHANGED GEOMETRY (TASK 8) STILL CONFIRMS EMPTY *** — not assumed resolved because the numbers moved in a plausible direction, re-verified via a real `intersection()` probe at the new 980mm track/351.335mm LEG_DROP/lowered TRIANGLE_Z | still colliding — re-verified at THIS round's own geometry, not carried forward from v5's own resolution unchanged | `show_front_wheel_support` |
| `tow_triangle()` / `tow_bracket_gusset()` / `tow_handle(handle_fold_deg)` | TASK 6 REBUILT mount + TASK 7 (length, re-verified unaffected). `TRIANGLE_Z` = `FRONT_AXLE_Z` directly (228.6mm, was `FRONT_AXLE_Z+100`=328.6mm floating above the axle's own real plane, a v3-era carryover, Janis's own annotated finding). NEW `tow_bracket_gusset()`: real curved fillet (`GUSSET_R`=30mm, judgment call, flagged — no reference photo directly available this session) via `hull()` of two spheres, bridging the flat triangle plate's own underside to the round stub axle's own surface at their shared mounting point — real CGAL: genuine volume overlap vs BOTH the plate and the axle, confirmed (not just a touching face). `TBAR_LEN` UNCHANGED VALUE (1102.735mm, `DATUM_Z_RIDGE`/`WHEEL_R` both untouched by v15) — real, flagged side effect of the `TRIANGLE_Z` fix: tip Z at the 90deg default is now 50mm BELOW the roof (was 50mm above under v5), the v5-flagged roof-overshoot resolves as a welcome consequence, not the goal of TASK 6 | independent of the front caster — still rigidly coupled, unchanged | (none — sub-parts of `front_wheel_support()`'s own `front_swivel_assembly()`, no separate toggle) |
| `prep_shelves(shelf_deployed)` | v8 REAL BUG FOUND+FIXED (Janis: "bad tray stack in each other"). Real root cause, confirmed via a real STL vertex-extent probe (not assumed): the right-side call applied `mirror([0,1,0])` AFTER an already-applied `translate()`, reflecting the pre-positioned geometry back around Y=0 instead of onto the chamber's opposite side — real measured consequence: both shelves landed on the SAME (left) side (combined Y-extent [-610,0]) instead of one per side. FIX: dropped the unnecessary `mirror()` (`prep_shelf()`'s own stow rotation is already symmetric about its own hinge line, no reflection needed) — right shelf now a direct `translate([0,chamber_W,0]) prep_shelf(0,...)`, real confirmed Y-extent now [-300,0]/[610,910], one per side. `tray_mount_brackets()`'s own 3-bracket distributed mount (TASK 1, prior round) UNCHANGED — those were never the bug, only the shelf PANEL's own right-side placement was | a kinematic/rotation fix — the stow rotation itself was already correct, this is a placement-math fix only | `show_shelves` |

## Toggle-completeness count (2026-07-21, v1.20)

12 top-level ASSEMBLY-called modules, UNCHANGED count. Real toggle GRANULARITY
increase inside `firebox()` (Janis's own explicit request): 4 of its own
real sub-parts (`fire_cylinder()`/`fire_cylinder_end_cap()`/`outer_shell()`/
`outer_shell_end_cap()`) now have their OWN independent `show_*` toggles,
in addition to the existing master `show_firebox` — 15 real toggles total
now gate the chambers ASSEMBLY block (was 8, +4 new +3 unaffected already-
counted), understructure unchanged at 4. `fire_cylinder_partition()`/
`ash_tray()`/`firebox_door()` deliberately NOT separately toggled (outside
this round's explicit ask, R-009: scope discipline). 0 gaps on anything
that WAS asked for. `show_lid_hardware` still defaults false (unchanged).

## Toggle-completeness count (2026-07-21, v1.19)

12 modules called across both ASSEMBLY blocks, UNCHANGED count (8 in
chambers, 4 in understructure) — this round's fixes rebuilt shape/sizing
logic inside existing modules (`firebox_passage()`'s own profile,
`fire_cylinder_end_cap()`'s own 2D, `outer_shell()`'s own flange footprint,
`rear_fenders()`'s own arc/flat construction), no new top-level ASSEMBLY-
called module added or removed. 12/12 still have a real `show_*` isolation
toggle — 0 gaps. `show_lid_hardware` still defaults false (unchanged).

## Toggle-completeness count (2026-07-20, v1.18)

12 modules called across both ASSEMBLY blocks (8 in chambers, unchanged
this round — chambers not touched; 4 in understructure, unchanged —
`rear_axle()`, `rear_fenders()`, `front_wheel_support()`, `prep_shelves()`;
`tow_bracket_gusset()` NEW but a sub-part of `front_swivel_assembly()`,
same no-separate-toggle pattern, no new toggle needed). 12/12 have a real
`show_*` isolation toggle — 0 gaps, 0 safety-critical exceptions needed
this version. `show_lid_hardware` still defaults false (unchanged).

## Toggle-completeness count (2026-07-20, v1.17)

12 modules called across both ASSEMBLY blocks (8 in chambers, unchanged —
`fire_cylinder()`/`fire_cylinder_end_cap()`/`fire_cylinder_partition()`/
`ash_tray()` are all sub-parts called from within `firebox()`, same no-
separate-toggle pattern the retired `inner_duct()` used, no new toggle
needed; 4 in understructure, unchanged this round — understructure not
opened). 12/12 have a real `show_*` isolation toggle — 0 gaps, 0
safety-critical exceptions needed this version. `show_lid_hardware` still
defaults false (unchanged).

## Toggle-completeness count (2026-07-20, v1.16)

12 modules called across both ASSEMBLY blocks (8 in chambers, unchanged; 4
in understructure — `rear_axle()`, `rear_fenders()` (NEW), `front_wheel_
support()`, `prep_shelves()`). 12/12 have a real `show_*` isolation toggle
— 0 gaps, 0 safety-critical exceptions needed this version. `show_lid_
hardware` still defaults false (chambers, unchanged).

## Previous toggle-completeness count (2026-07-17, v1.11)

11 modules called across both ASSEMBLY blocks (8 in chambers, unchanged —
`fuel_cylinder()` is a sub-part of `firebox()`, same no-separate-toggle
pattern `fire_grate()`/`ash_tray()` already used, no new toggle needed; 3
in understructure, unchanged: `rear_axle()`, `front_wheel_support()`,
`prep_shelves()`). 11/11 have a real `show_*` isolation toggle — 0 gaps, 0
safety-critical exceptions needed this version. `show_lid_hardware` still
defaults false (unchanged, chamber's own hardware module not touched this
round either).
