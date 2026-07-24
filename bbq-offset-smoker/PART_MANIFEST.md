# PART_MANIFEST.md — BBQ Offset Smoker
# What every ASSEMBLY-called module actually IS, in plain language.
# Read by: Claude Web + cc, before any QA session and before adding any
# new part. Update this file in the SAME prompt that adds/renames/removes
# any ASSEMBLY-called module — never let it drift from the real file.
#
# Version: 1.30 — 2026-07-24 (bbq-lid-hinge-three-rib-v2): chambers table
# REBUILT — source now BBQ-chambers-v23.scad (source v22). `lid_hardware()`
# module + `LEVER_ARM`/`COUNTERWEIGHT_KG` constants + `show_lid_hardware`
# toggle + its ASSEMBLY call all RETIRED (R-009 confirmed dead — zero other
# content changed, byte-diffed against v22). Understructure table: new
# BBQ-understructure-v16.scad row (PURE POINTER-ONLY BUMP from v15 — v15
# itself untouched, a real chain-break fix, see that file's own header:
# v15's own `include` pointed at v22 directly, which would have kept the
# stale stub in the real render chain even with v23 created). Base assembly
# table REBUILT — new BBQ-offset-smoker-base-v6.scad: the lid's real hinge/
# handle/counterbalance mechanism (3 identical ribs, ONE CB1 arm, no fill
# weight), replacing the retired chambers stub. REAL, FLAGGED, NOT RESOLVED:
# rib0/rib2 have a confirmed geometric interference with the existing prep
# trays at their shared Y=0 weld zone — see
# docs/lid-hinge-counterbalance-calc.md.
# Previous: 1.29 — 2026-07-22 (bbq-rear-fender-arch-redesign): understructure
# table REBUILT — source now BBQ-understructure-v15.scad (source v14). Real
# PROFILE redesign of rear_fender() — NOT a linkage/datum change. Replaces
# the flat-plate-with-curve-down-zone cross-section with a real wheel-arch
# shape (flat roof + two straight sloped shoulders), solved directly from
# WHEEL_R via a real numeric bisection: theta converges to 24.3358° at
# WHEEL_R=228.6mm (self-check confirmed against expected ~24.3°). Real
# Step 2 values: roof_z=328.6mm, roof_half_w=148.616mm, R_tip=360.645mm,
# arch_end_x=203.419mm, arch_end_z=297.801mm. REAL, FLAGGED FINDING: the
# true global minimum clearance (live CGAL bisection, 95.9mm empty/96.0mm
# contact) occurs at the flat roof's own underside center, NOT near the
# shoulder ends as the prompt anticipated — real value =
# FENDER_ARCH_TOP_CLEARANCE(100) - FENDER_T(4) = 96mm exactly; the solve/
# build-swing angle gap instead governs a separate real quantity (the
# shoulder endpoint's own 25.181mm pull-back from the wheel's vertical
# tangent line). Real CGAL: vs tire EMPTY (96mm margin), vs axle/struts
# EMPTY, vs firebox outer shell NON-EMPTY (378 facets, real weld contact).
# New "Wheel-Radius-Derived Fender Arch Convention" locked into
# rules-bbq-fab.md (v1.5->1.6). Base assembly table: new
# BBQ-offset-smoker-base-v5.scad (pure pointer-only bump from v4, tray
# content byte-identical). Chambers table UNCHANGED this entry.
# Previous: 1.28 — 2026-07-22 (bbq-understructure-level-drop-companion):
# understructure table REBUILT — source now BBQ-understructure-v14.scad
# (source v13, `include` bumped v21->v22). Companion round absorbing
# chambers-v22's own real -100mm level drop structurally.
# REAR_BRACKET_H/FRONT_SPACER_LEN/TBAR_LEN all confirmed via live
# measurement to shrink exactly -100mm each; wheels/axles stay fixed to
# true ground Z=0 (unchanged, by design). REAL FINDING: LEG_DROP stays
# UNCHANGED (351.335mm) — correct, not a missed consumer, since it
# measures the span between chamber_floor_z/firebox_floor_z, which both
# drop together. Real mount-point CGAL: front_bracket() vs
# chamber_shell() NON-EMPTY, rear_axle_bracket() vs firebox() NON-EMPTY.
# Fender Z/15mm-tire-clearance formula UNCHANGED per Janis's own
# clearance-priority decision — re-verified real CGAL: vs outer_shell()
# (now 100mm lower) NON-EMPTY (real margin increased), vs tire EMPTY
# (exact 15mm re-confirmed via bisection), vs axle/struts EMPTY. Base
# assembly table: new BBQ-offset-smoker-base-v4.scad (pure pointer-only
# bump from v3, tray content byte-identical). Chambers table UNCHANGED
# this entry (see 1.27 below for the chambers-v22 round itself).
# Previous: 1.27 — 2026-07-22 (bbq-chambers-grate-master-datum-restore-and-
# level-drop): chambers table REBUILT — source now BBQ-chambers-v22.scad.
# TASK 1: grate RESTORED as the project's real master/reference datum
# (Janis's own explicit statement — undoes a v13-era time-pressure
# workaround that had pinned the grate independently and pushed the
# chamber's own anchor to compensate). `GRATE_Z` (renamed from
# `GRATE_Z_FIXED`) is now the real master; `APEX_A_Z = GRATE_Z - 50`
# (renamed from this file's own old, misleadingly-named `GRATE_Z`
# variable) is now derived; `chamber_floor_z = APEX_A_Z - chamfer` is now
# derived too (was a hardcoded `950-chamfer` literal). REAL FIX found
# during the consumer sweep: `FIREBOX_TOP_Z_FIXED` was an independent
# literal with zero formula link to the grate (only numerically
# coincidental) — re-pointed to `GRATE_Z` so the firebox genuinely
# follows future drops. `grill_grate()` re-pointed to `GRATE_Z` directly,
# old duplicate `GRATE_Z_FIXED` retired (R-009). Verified pixel-identical
# to v21 at current values via a real vertex-multiset STL comparison.
# TASK 2: real -100mm level drop, `GRATE_Z` 1000->900 — every consumer
# confirmed auto-following via live echo. Real bounding-box check
# confirms the whole assembly shifted exactly -100mm; one tessellated
# vertex (of 3556) differs at a complex circle-octagon boolean
# intersection — investigated, assessed as a benign CGAL floating-point
# triangulation artifact, flagged not silently absorbed. Understructure/
# base tables UNCHANGED this round (companion round absorbs the shift).
# Previous: 1.26 — 2026-07-22 (bbq-base-chain-recalibration): LINKAGE-ONLY
# FIX, zero geometry/module content changed from either PR #143 round.
# Real file now: BBQ-understructure-v13.scad (pure pointer-only bump,
# source v12, `include` now BBQ-chambers-v21.scad — R-009 confirmed every
# real consumed datum byte-identical between v20/v21, understructure-only
# isolated render confirmed pixel-identical, 3188 vertices/3364 facets/5
# volumes both versions) + BBQ-offset-smoker-base-v3.scad (source: v2's
# real tray content copied forward verbatim/diffed byte-identical + v1's
# original single-include-path structure — includes ONLY
# BBQ-understructure-v13.scad, chambers now reached transitively, v2's own
# direct chambers include NOT carried forward). Real cause fixed: PR #143
# shipped BBQ-understructure-v12.scad (still wired to chambers-v20) and
# BBQ-offset-smoker-base-v2.scad (chambers-v21 directly, bypassing
# understructure/wheels) as two separate valid-but-disconnected chains,
# each Simple:yes alone, never merged into one real assembly. Full unified
# assembly now real and CGAL-confirmed: fender+wheels+lid-shift+trays ALL
# present together (4377 facets, 6 volumes), zero double-rendered chamber
# geometry (confirmed via facet arithmetic), tray sweep re-verified EMPTY
# against the NOW-PRESENT real understructure geometry in the same file.
# v12/base-v1/base-v2 all kept, unmodified, on record.
# Previous: 1.25 — 2026-07-22 (bbq-chamber-parting-shift-and-tray-init):
# chambers table REBUILT — source now BBQ-chambers-v21.scad. TASK 1: real
# lid/fixed parting-line shift +50mm on the Y=0 side only —
# fixed_side_wedge()/lid_side_wedge()'s own shared vertex moved from apex
# A to a new real point on the SAME octagon wall edge (NEW_SPLIT_H, world
# Z=1000mm) — reuses the locked chamber_outer_tube() construction
# directly, no new insert. lid_closed_panels()'s own vertical panel
# shortened by exactly 50mm to match. Real live CGAL: new fixed band vs
# existing fixed shell NON-EMPTY, lid(closed) vs band NON-EMPTY
# (intentional weld overlap = zero gap), lid's real swept volume vs band
# EMPTY at every angle 0.5°-120° (9 real steps). NEW row:
# BBQ-offset-smoker-base-v2.scad — FIRST real content ever added (the
# relocated prep tray, TASK 2). 2 real bugs found+fixed via live CGAL
# sweeps before shipping: tray plate deployed the wrong direction (+Y,
# into the chamber) in an early draft, confirmed via a real collision
# vs front_wheel_support(); pivoting exactly at the wall face made the
# plate's own thickness sweep into real wall material at intermediate
# angles (Simple:no) — fixed via a real 5mm hinge-knuckle standoff.
# Understructure table UNCHANGED (still BBQ-understructure-v12.scad,
# frozen this round per DO NOT TOUCH — its own `include` stays on v20).
# Previous: 1.24 — 2026-07-22 (bbq-understructure-v12-tray-removal-fender-
# trackwidth): understructure table REBUILT — source now
# BBQ-understructure-v12.scad. TASK 1: prep_shelf()/prep_shelves()/
# tray_mount_bracket()/tray_mount_brackets() rows REMOVED — module deleted
# entirely (relocating to a separate accessories file, next round), R-009
# confirmed zero remaining callers (SHELF_D/SHELF_T/LEG_INSET real
# consumers all tray-exclusive; CASTER_CLEARANCE/leg_h also removed — REAL
# FINDING: already orphaned before this round, unrelated to the tray).
# TASK 2: rear_fenders() row REBUILT — Janis's own precise real spec (rear
# wheels only): flat 548.64mm x 300mm deck plate, 15mm droop each
# 54.864mm end via hull(), fender_z=472.2mm. Real live OpenSCAD CGAL:
# EMPTY vs tire (15mm real margin, bisected), EMPTY vs axle/struts,
# NON-EMPTY vs firebox outer shell (real weld contact). TASK 3:
# TRACK_WIDTH 980->880mm (TRACK_WIDTH_FIREBOX_GAP 100->50mm) — real
# front-wheel-vs-bracket re-check at the new narrower width: live CGAL
# EMPTY, re-confirmed not assumed. Chambers table UNCHANGED (still
# BBQ-chambers-v20.scad, out of scope this round).
# Previous: 1.23 — 2026-07-21 (Janis toggled show_outer_shell_end_cap off,
# still saw a wall): chambers table REBUILT — source now
# BBQ-chambers-v20.scad. Real cause: `outer_shell()`'s own flange (the
# 50mm tuck-under) was built as a SOLID 50mm block since v14 ("SOLID, no
# interior cavity", never questioned) — two redundant wall-like surfaces
# where there should be exactly one real end cap. Also a real, standing
# inconsistency with this project's own thin-sheet-metal Construction
# Method. FIX: flange rebuilt HOLLOW, wall_t thick, same real technique
# as the main hollow body. `outer_shell_end_cap()` UNCHANGED — now
# genuinely the ONE cap. Real CGAL: non-empty weld contact preserved,
# empty vs chamber's hollow interior (2mm margin), empty in the flange's
# own mid-wall interior (confirmed truly hollow), passage cut still
# passes cleanly through. `rules-bbq-fab.md` Rule 1 amended to explicitly
# require this (hollow, never solid) for future rounds. Understructure
# table: source now BBQ-understructure-v11.scad, pure pointer bump.
# Previous: 1.22 — 2026-07-21 (Janis's own closer visual inspection of v18):
# chambers table REBUILT — source now BBQ-chambers-v19.scad. 2 real fixes:
# (1) `fire_cylinder_end_cap_2d()` had a real remaining hole — same
# failure class as v16's original outer-shell mistake
# (`intersection(circle,octagon)` clips down wherever the octagon is
# locally narrower; real math confirmed octagon half-width 126.335mm <
# circle half-width 219.6mm at chamber_floor_z) — v18's own QA Step 2
# never actually checked this specific end cap. FIX: directly reused the
# just-written Dual End-Cap Footprint Pattern (RULE 4,
# `.claude/SKILL_joint_construction.md`) — `union(circle, octagon)`
# bounded by a new `fire_cylinder_end_cap_bound_2d()` (the cylinder's own
# real diameter box), minus the shared passage cut. Real CGAL/STL:
# end cap now always >= the native circle (2mm real margin, confirmed
# empty residual), real weld contact preserved, own bbox exactly matches
# the cylinder's diameter envelope. (2) `ash_tray()` RETIRED entirely
# (module + `ASH_TRAY_*` constants + `ash_tray_out_pct` parameter
# threading through `firebox()`/DEBUG TOGGLES) per Janis's own explicit,
# direct instruction — R-009, zero remaining consumers confirmed via grep.
# Understructure table: source now BBQ-understructure-v10.scad, pure
# pointer bump, zero geometry change.
# Previous: 1.21 — 2026-07-21 (Rule 1 QA simulation on unmerged PR #138):
# chambers table REBUILT — source now BBQ-chambers-v18.scad. Janis ran
# their own 4-step QA simulation against v17 before merging (per Janis's
# own explicit hold) and, alongside the new rules-bbq-fab.md "Dual End-Cap
# Independence Convention" (locked the same session), found v17's own
# `outer_shell_flange_footprint_2d()` (kept ALWAYS the plain square) never
# actually satisfies Rule 1's own "the top part...follows the chamber's
# own real profile" / "meets the octagon face" requirement — it dodged the
# two known bugs without delivering the stated goal. FIX: rebuilt via
# `union(plain square, true_octagon_profile())` minus the chamber's own
# real hollow-cavity hole (NOT `intersection()`, v16's own original
# mistake). REAL BUG CAUGHT BEFORE SHIPPING (STL bbox probe): a bare
# union pulled octagon material all the way to the chamber's own RIDGE
# height (`true_octagon_profile()` isn't height-bounded on its own) —
# fixed by intersecting with a real height-bound mask matching the
# flange's own physical range first. Re-verified: footprint bbox now
# exactly [-228.665,351.335] (was [-610,351.335]), `outer_shell()`'s own
# real world-Z range now exactly [420,1000] (no ridge overreach). Real
# CGAL: EMPTY vs the chamber's own hollow cavity, NON-EMPTY vs the
# chamber's own real wall material. Understructure table: source now
# BBQ-understructure-v9.scad, pure pointer bump, zero geometry change.
# Previous: 1.20 — 2026-07-21 (Janis's own SECOND direct-feedback round the
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

## BBQ-chambers-v23.scad

v23 (bbq-lid-hinge-three-rib-v2, Section 7.5): `lid_hardware()` module +
`LEVER_ARM`/`COUNTERWEIGHT_KG` constants + `show_lid_hardware` toggle +
its ASSEMBLY call line all RETIRED (R-009 confirmed dead: zero real
consumers, `show_lid_hardware=false` since the v2 ridge-hinge redesign —
the real counterbalance mechanism now lives in
`BBQ-offset-smoker-base-v6.scad`'s own Accessories branch, a genuine
duplication risk with the stale stub still present). No other content
changed — every other module/constant/value below is BYTE-IDENTICAL to
v22 (confirmed via diff before committing).

v22 TASK 1/2 (bbq-chambers-grate-master-datum-restore-and-level-drop):
grate restored as real master datum (`GRATE_Z`, renamed from
`GRATE_Z_FIXED`), apex A now derived (`APEX_A_Z = GRATE_Z - 50`, renamed
from this file's own old `GRATE_Z`), `chamber_floor_z` now derived from
that. Real -100mm drop applied (`GRATE_Z` 1000->900) — every module
below moves automatically via this restored chain; table content
otherwise UNCHANGED from v21 (zero shape/dimension edits, pure Z-datum
restructure + drop).

| Module | What it IS | What it is NOT (only if real confusion risk exists) | Toggle |
|---|---|---|---|
| `chamber_shell()` | v21 TASK 1: `fixed_side_wedge()`'s own single shared vertex moved from apex A (chamfer,0) to a new real point `NEW_SPLIT_H` (228.665mm local h) on the SAME true_octagon_profile() left-wall edge, +50mm (world Z=1000mm, was 950mm) — a real modification to the EXISTING construction (`chamber_outer_tube()` = `octagon_ring()` ∩ extruded `fixed_side_wedge()`), not a new independent insert. Real, automatic consequence: the octagon's own real wall material between world Z=[950,1000] at Y=0, full chamber_L length, is now genuinely FIXED (never moves with the lid) — real structural weld base for the relocated tray's hinges (BBQ-offset-smoker-base-v2.scad). Real live CGAL: new band vs existing fixed shell NON-EMPTY (14 facets, 2 volumes, genuine structural continuity) | a new additive insert unioned on top — this is the SAME locked mechanism every prior round uses, just one moved vertex | `show_chamber_shell` |
| `lid(lid_open_deg)` | v21 TASK 1: `lid_side_wedge()`'s own matching vertex moved the same +50mm (exact complement of `fixed_side_wedge()`, confirmed by construction). `lid_closed_panels()`'s own real vertical Y=0 panel shortened by EXACTLY 50mm (`PARTING_SHIFT`) to match — top edge (real top-left octagon corner) UNCHANGED, only the bottom moved up. Real live CGAL: lid(closed) vs the new fixed band NON-EMPTY (6 facets — a real, intentional ~3mm `LID_OVERLAP` weld contact, confirming "zero gap" at the seam, NOT a defect); lid's real SWEPT volume vs the new fixed band EMPTY at every one of 9 angles checked (0.5°/1°/5°/15°/30°/45°/60°/90°/120°) — the lid clears the fixed band immediately upon opening | UNCHANGED shape/hinge mechanism — only the fixed/lid MATERIAL split moved | `show_lid` |
| `lid_territory_margin_fill()` | UNCHANGED CODE. Real, confirmed contact vs `outer_shell()`'s own flange at the chamber's rear-territory zone — SAME real weld contact as every version since v14 | a NEW conflict introduced by this round's firebox changes — confirmed unchanged/pre-existing, not a regression | (none — sub-part of `chamber_shell()`, no separate toggle) |
| `firebox_passage()` | v16 TASK A REBUILT — Janis's own words: "the hole shape is dictate by the cut on the chamber, nothing else". Real root cause of v15's own defect: `firebox_passage_profile()` sized its circle (194.898mm dia) purely from the cylinder's own 0.008-fire-volume target-area rule, with ZERO reference to real chamber material — 33.233mm of its own bottom sat BELOW chamber_floor_z entirely (a literal hole through nothing, confirmed via CGAL+echo, matching Janis's screenshot). FIX: size/position now DERIVED from the real vertical band where the cylinder's own clear bore (225mm) overlaps the chamber's real octagon material at the rear wall (`CYL_WALL_MARGIN`=15mm/`CHAMBER_EDGE_MARGIN`=15mm real insets both ends) — built as `intersection(candidate circle, real chamber material)`, so the final shape is, by construction, always the real chamber cut. Real new `PASSAGE_R`=65.335mm (was 97.449mm — genuinely smaller, a real consequence of deriving from actual available space, not a defect). Real CGAL: passage now FULLY contained in real chamber material (zero residual outside it, confirmed via a real `difference()` probe) AND fully clear of the cylinder's own bore wall (confirmed empty overlap) | a placeholder — both the target radius derivation and the belt-and-suspenders real-material intersection are load-bearing, not decorative | (none — sub-part of `chamber_shell()`, no separate toggle) |
| `lid(lid_open_deg)` | UNCHANGED CODE. Clamshell lid, 3 flat panels, hinged along the ridge midpoint | | `show_lid` |
| `firebox(firebox_door_open_deg)` | TWO fully independent welded assemblies (fire cylinder + outer shell, see next rows). 4 real sub-part toggles (`show_fire_cylinder`/`show_fire_cylinder_end_cap`/`show_outer_shell`/`show_outer_shell_end_cap`), Janis's own explicit request — each independent of `show_firebox` below (which still gates the whole assembly). `fire_cylinder_partition()`/`firebox_door()` NOT separately toggled (not part of that round's ask). v19: `ash_tray_out_pct` parameter DROPPED (`ash_tray()` itself retired, see below — zero remaining consumers). v22 REAL FIX: `FIREBOX_TOP_Z_FIXED` (governs `firebox_floor_z`/`firebox_z0`/`firebox_z1`/`CYL_Z_CENTER`) was an INDEPENDENT hardcoded literal (1000) with zero formula link to the chamber's own grate/apex-A datum chain — only numerically coincidental. Re-pointed to the restored master `GRATE_Z` so the entire firebox genuinely follows the grate-master-datum-restore-and-level-drop round's own -100mm drop (confirmed via live echo: firebox_floor_z 420->320, firebox_z1 1000->900) | a shell that automatically tracked the chamber body before this round — it did NOT, confirmed via grep, this was a real, silent gap now closed | `show_firebox` |
| `fire_cylinder()` / `fire_cylinder_end_cap()` | Round, 456mm diameter (62mm wall clearance vs the outer shell), full `FIREBOX_L`(580mm) span, open both ends. `fire_cylinder_end_cap_2d()` v19 REBUILT via the Dual End-Cap Footprint Pattern (RULE 4, `.claude/SKILL_joint_construction.md`) — REPLACING the old `intersection(circle, chamber_octagon_or_open_below_2d())` construction (RETIRED, real confirmed defect: Janis found a real remaining hole by looking inside the built cylinder — the octagon's own real half-width at chamber_floor_z, 126.335mm, is LESS than the circle's own real half-width there, 219.6mm, so the intersection clipped the circle down and the chamber has zero material outside its own true edge to fill what got clipped away — same failure class as v16's original outer-shell mistake, just never checked on this specific end cap until this round). FIX: `union(circle, true_octagon_profile())`, bounded by new `fire_cylinder_end_cap_bound_2d()` (the cylinder's own real diameter box — without it a bare union would pull in unlimited octagon material, the same overreach bug already found once this session on the outer shell), minus the shared passage cut. Real CGAL/STL: end cap now always >= the native circle (2mm real margin, confirmed empty residual, not just an exact-boundary touch), real weld contact with the chamber's own wall material preserved (non-empty), own real bbox exactly matches the cylinder's own diameter envelope (no overreach). Independently toggleable (`show_fire_cylinder`/`show_fire_cylinder_end_cap`, UNCHANGED) | connected to or touching the outer shell anywhere — confirmed via a real mandatory zero-contact CGAL check | `show_fire_cylinder` / `show_fire_cylinder_end_cap` |
| `fire_cylinder_partition()` | Square end plate (matches `outer_shell_footprint_2d()`'s own real 580x580 exterior footprint, plain/unclipped) minus a circle matching the cylinder's own real diameter (+2e real clearance) — physically locates the cylinder within the square outer shell. Positioned at the door/front end (X=[firebox_x1-wall_t-e,firebox_x1-e]). Real CGAL: non-empty contact vs `outer_shell()`'s own wall, EMPTY vs the cylinder and the door | welded/fused to the cylinder itself — a separate locating collar, real clearance not material overlap | (none — sub-part of `firebox()`, no separate toggle) |
| `outer_shell()` / `outer_shell_end_cap()` | Real 580x580x580 CUBE. v20 REAL FIX: the flange (50mm tuck-under) was built as a SOLID block since v14 ("SOLID, no interior cavity", never questioned) — Janis toggled `show_outer_shell_end_cap` off and still saw a wall, because the solid block's own far face is a SECOND real wall-like surface distinct from the actual end-cap plate — two redundant surfaces where there should be exactly one, also a real, standing inconsistency with this project's own thin-sheet-metal Construction Method. FIX: the flange is now HOLLOW, wall_t thick, built with the SAME real technique as the main hollow body (outer boundary via `outer_shell_flange_cut_2d()` minus an inset-by-`wall_t` inner cavity via `offset(delta=-wall_t) outer_shell_flange_footprint_2d()`). `outer_shell_end_cap()` UNCHANGED position/role — now genuinely the ONE real cap; toggling it off shows straight through the flange's own real hollow interior to the chamber's own material. Real CGAL/STL: non-empty weld contact with the chamber's own wall material preserved, empty vs the chamber's own hollow interior (2mm margin, still not blocked), empty in the flange's own mid-wall interior (confirmed genuinely hollow), passage cut still passes cleanly through (confirmed empty/open). Footprint mechanism itself (`outer_shell_flange_footprint_2d()`, union-based, satisfies Rule 1's "meets the octagon face") UNCHANGED from v18. `FLANGE_LEN`=50mm UNCHANGED, STAYS ADDITIVE. Independently toggleable (`show_outer_shell`/`show_outer_shell_end_cap`, UNCHANGED) | a redesigned cube — same cube, only the flange's own SOLID-vs-HOLLOW construction changed (4th real attempt on this module, this one closes the redundant-wall defect) | `show_outer_shell` / `show_outer_shell_end_cap` |
| `exhaust_room()` | UNCHANGED CODE, UNCHANGED position this round (chamber_floor_z untouched) | | `show_exhaust_room` |
| `chimney_pipe()` | UNCHANGED CODE | | `show_chimney_pipe` |
| `grill_grate()` | UNCHANGED CODE, UNCHANGED position this round (chamber_floor_z/GRATE_Z untouched) | | `show_grate` |
| `floor_drains()` | UNCHANGED CODE | | `show_drains` |

## BBQ-understructure-v16.scad

v16 (bbq-lid-hinge-three-rib-v2, 2026-07-24): PURE POINTER-ONLY BUMP from
v15 — `include` bumped `BBQ-chambers-v22.scad` -> `BBQ-chambers-v23.scad`
(Section 7.5's stub retirement) only. v15 itself is NOT edited (kept
byte-identical, on record) — this new file is a real, necessary chain-
break fix: v15's own `include` pointed at v22 directly, so leaving
base-v6 pointed at v15 unchanged would have kept the stale stub in the
real render chain even after v23 was created (same failure class as the
2026-07-22 bbq-base-chain-recalibration incident). R-009 real consumed-
datum check (grep): every real chambers identifier this file references
has the IDENTICAL declaration in v23 as in v22 — zero-consequence bump.
Table content below UNCHANGED from v15.

v15 (bbq-rear-fender-arch-redesign, 2026-07-22): `rear_fender()` PROFILE
REBUILT — see the `rear_fenders()` row below for the full real formula/
verification detail. Everything else in this file UNCHANGED from v14.
v14 (bbq-understructure-level-drop-companion): `include` bumped v21->v22
(companion chambers round's own real -100mm level drop). Module CODE at
that round UNCHANGED from v13 — every real value changed only via the
live formula chain (`REAR_BRACKET_H`/`FRONT_SPACER_LEN`/`TBAR_LEN` all
confirmed -100mm via live measurement; `LEG_DROP` correctly UNCHANGED,
see PART_MANIFEST.md's own version header for the real reasoning). v13
(`include` still `BBQ-chambers-v21.scad`) is itself a PURE POINTER-ONLY
BUMP from v12 — zero module content changed, R-009 confirmed every real
consumed datum byte-identical between v20/v21 (bbq-base-chain-
recalibration, 2026-07-22).

| Module | What it IS | What it is NOT (only if real confusion risk exists) | Toggle |
|---|---|---|---|
| `rear_axle()` | Module code UNCHANGED. WHEEL_D/WHEEL_R/TREAD_W (457.2/228.6/200). REAR_WHEEL_Y_LEFT/RIGHT via `TRACK_WIDTH`(880mm, v12, was 980mm) = -135/745mm — real, live-recomputed: exactly 50mm gap to the firebox's own outer-shell edge each side (TASK 3, Janis's own real spec update). v14: `REAR_BRACKET_H` (rear strut/beam height) recomputes automatically to 91.4mm (was 191.4mm, real -100mm, live-measured) via the companion chambers-v22 round's own level drop — `REAR_AXLE_Z` itself UNCHANGED (228.6mm, wheels stay fixed to true ground Z=0) | a swivel/steerable mechanism — static, no kinetic parameter | `show_rear_axle` |
| `rear_fenders()` | v15 REAL PROFILE REDESIGN (rear wheels ONLY, confirmed no front fender exists or was added; 300mm outward extension/world Y and 1.5mm weld overlap UNCHANGED). v10-v14's flat-rectangular-plate-with-10%-curve-down-zone cross-section (`fender_slab()`, RETIRED) replaced by a real wheel-arch (flat roof + two straight sloped shoulders), solved directly from `WHEEL_R` via a real numeric bisection — see rules-bbq-fab.md's own "Wheel-Radius-Derived Fender Arch Convention" for the full, reusable, parametric formula. Real solved `FENDER_ARCH_THETA`=24.3358° at `WHEEL_R`=228.6mm (self-check confirmed against the expected ~24.3°). Real Step 2 values: `roof_z`=328.6mm, `roof_half_w`=148.616mm, `R_tip`=360.645mm, `arch_end_x`=203.419mm, `arch_end_z`=297.801mm. Built as ONE closed 2D polygon (uniform vertical thickness, a real stated simplification not a true perpendicular offset), extruded via a plain `linear_extrude()` (no `hull()`-loft needed, the cross-section doesn't change along the 300mm Y-reach) — verified via a local render prototype before shipping. REAL, FLAGGED FINDING: the true global minimum clearance (live CGAL bisection, 95.9mm empty/96.0mm real contact) occurs at the flat roof's own UNDERSIDE center, NOT near the shoulder ends as the prompt anticipated — real value = `FENDER_ARCH_TOP_CLEARANCE`(100) - `FENDER_T`(4) = 96mm exactly (the roof's own real thickness reduces the nominal 100mm design clearance); the solve/build-swing angle gap instead governs a separate real quantity (the shoulder endpoint's own 25.181mm pull-back from the wheel's vertical tangent line, `WHEEL_R` minus `arch_end_x`) — both real numbers stated, not conflated. Real live OpenSCAD CGAL: EMPTY vs `rear_wheels()` (96mm real bisected margin, at the roof underside, not the shoulder ends), EMPTY vs `rear_axle_bracket()`, NON-EMPTY vs `outer_shell()` (378 real facets, genuine weld contact preserved) | a wraparound hood/wheel-well enclosure (v7-v11's own shape) or the v10-v14 flat-plate-with-droop-zones design — a real wheel-arch, formula-derived from WHEEL_R | `show_rear_fenders` |
| `front_wheel_support(steer_deg, handle_fold_deg)` | Module code UNCHANGED. `LEG_DROP`=351.335mm — v14 REAL FINDING: stays UNCHANGED (not a missed consumer) since it measures the span between `chamber_floor_z`/`firebox_floor_z`, which both drop together with the companion chambers-v22 round. `FRONT_SPACER_LEN` recomputes automatically to 85.4mm (was 185.4mm, real -100mm, live-measured) — the front swivel-caster post absorbs the drop. TASK 3's own narrower `TRACK_WIDTH`(880mm, was 980mm) moves both front wheels 50mm CLOSER to center each side (`front_wheels()`/`front_stub_axle()` share the same constant) — real, live-verified re-risk of the standing front-wheel/bracket collision (narrower is the OPPOSITE direction from the v5 fix that originally resolved it): a fresh OpenSCAD CGAL `intersection()` probe at this round's own 880mm width confirms EMPTY, not carried forward from the 980mm-width resolution. v14: `front_bracket()` vs `chamber_shell()` real mount contact re-verified NON-EMPTY (94 facets) at the new elevation | still colliding at the new narrower width — freshly re-verified, not assumed | `show_front_wheel_support` |
| `tow_triangle()` / `tow_bracket_gusset()` / `tow_handle(handle_fold_deg)` | UNCHANGED this round — real structural tow-hitch/handle assembly, confirmed NOT a fender (per this round's own file-header note, in case any front-end geometry is misread as one) | a front-wheel fender — no such part exists in this file | (none — sub-parts of `front_wheel_support()`'s own `front_swivel_assembly()`, no separate toggle) |

Prep tray/shelf REMOVED entirely (TASK 1, v12) — `prep_shelf()`/
`prep_shelves()`/`tray_mount_bracket()`/`tray_mount_brackets()` and their
exclusive constants deleted (R-009, zero remaining callers confirmed via
grep). Relocated to the Accessories branch
(`BBQ-offset-smoker-base-v3.scad`, below) — NOT gone from the product,
just no longer built in this file.

## BBQ-offset-smoker-base-v6.scad

v6 (bbq-lid-hinge-three-rib-v2, 2026-07-24): `include` bumped
`BBQ-understructure-v15.scad` -> `BBQ-understructure-v16.scad` (pure
pointer bump, see that file's own header). NEW real content: the lid's
hinge/handle/counterbalance mechanism (TASK 3, `lid_hinge_assembly()` —
see its own row below), replacing the retired chambers stub. Tray module
content (TASK 2) UNCHANGED, byte-identical to v5.

v5 (bbq-rear-fender-arch-redesign, 2026-07-22): PURE POINTER-ONLY BUMP
from v4 — `include` bumped `BBQ-understructure-v14.scad` ->
`BBQ-understructure-v15.scad` (that round's own real fender profile
redesign). Tray module content below UNCHANGED, byte-identical to v4
(confirmed via diff).

v4 (bbq-understructure-level-drop-companion): PURE POINTER-ONLY BUMP
from v3 — `include` bumped `BBQ-understructure-v13.scad` ->
`BBQ-understructure-v14.scad` (companion round's own real -100mm level
drop absorption). Tray module content below UNCHANGED, byte-identical to
v3 (confirmed via diff).

v3 (LINKAGE-ONLY FIX, bbq-base-chain-recalibration, 2026-07-22 — see
PART_MANIFEST.md's own version header for the full real cause/fix).
Single-include-path structure restored: base file → understructure →
chambers, ONE path, chambers reached transitively — this file's own
`include` is ONLY the understructure file (base-v2's own direct chambers
include NOT carried forward). Tray module content below (TASK 2 from the
parting-shift round) copied forward from `BBQ-offset-smoker-base-v2.scad`
VERBATIM — confirmed via a real line-range diff, zero content changed,
only the surrounding file/include structure. Real cause this fixes:
base-v2's own direct chambers include bypassed understructure/wheels
entirely (no updated understructure existed yet to build on when base-v2
was written) — the mandatory tray-vs-understructure CGAL checks below now
run against the REAL, PRESENT understructure geometry in this same file,
not a separate standalone probe (PR #143's own gap).

| Module | What it IS | What it is NOT (only if real confusion risk exists) | Toggle |
|---|---|---|---|
| `trays()` / `tray(x0, angle_deg)` / `tray_hinges(x0)` | The relocated prep tray (TASK 2), 2 trays, `chamber_L/2`=457.5mm long (X) each, 300mm deep (Y) when deployed, 2mm plate (thin-shell, per rules-bbq-fab.md Construction Method), 5mm gap between them — real, CONFIRMED ADDITIVE (`TRAY_TOTAL_SPAN`=920mm, 5mm MORE than chamber_L, not shrunk to fit). Mounted ONLY on the Y=0 side (confirmed by construction — no Y=chamber_W-side geometry exists). Hinges (2 per tray) weld to TASK 1's new fixed band at `HINGE_Z`=980mm (read live, `NEW_SPLIT_Z-20`). Own independent kinetic parameters `tray0_angle_deg`/`tray1_angle_deg`, real range -90°(stowed)/0°(deployed). 2 REAL BUGS FOUND+FIXED VIA LIVE CGAL SWEEPS: (1) an early draft deployed the plate toward +Y (into the chamber, confirmed real collision vs `front_wheel_support()` at -30°/-60°) — fixed, now deploys toward -Y (outward, per the Standing Orientation Convention). (2) pivoting exactly at the wall face made the plate's own 2mm thickness sweep into real wall material at intermediate angles (`Simple: no` at 0°) — fixed via a real 5mm `HINGE_PIVOT_OFFSET` hinge-knuckle standoff. Also found+fixed: `HINGE_OFFSET` 60->90mm (tray1's far hinge originally overlapped the firebox's own real flange material, bisected the real boundary to X=858mm via CGAL). Real live CGAL, all re-verified after fixes: tray sweep (9 angles, -90° to 0°) vs `chamber_shell()`+closed `lid()` EMPTY (beyond the intentional hinge weld contact), vs `firebox()` EMPTY; both trays deployed vs each other EMPTY (5mm real margin, confirmed via CGAL not just arithmetic); hinges vs new fixed band NON-EMPTY (real weld contact); hinges vs lid sweep EMPTY at every angle checked. RE-VERIFIED 2026-07-22 (bbq-base-chain-recalibration) against the REAL, NOW-PRESENT understructure geometry in this same unified file (`rear_axle()`/`rear_fenders()`/`front_wheel_support()`, not a separate standalone probe) — EMPTY at all 9 swept angles. Full unified assembly Simple:yes (4377 facets, 6 volumes), zero double-rendered chamber geometry confirmed via facet arithmetic | the OLD `prep_shelf()`/`prep_shelves()` construction (removed from Understructure v12) — a genuinely different mount point, hinge mechanism, and kinetic range | `show_trays` |
| `lid_hinge_assembly(door_open_deg)` | NEW (TASK 3, 2026-07-24): the lid's real hinge/handle/counterbalance mechanism — 3 identical ribs (`lid_rib_assembly()` x3 at `RIB0_X`/`RIB1_X`/`RIB2_X`=250/457.5/665mm), a handle rod + CB1 pipe (both rotate WITH the ribs via `lid_rib_rotate()`, the same transform), and a FIXED axle + 2 UCP204-12 pillow-block placeholders (does NOT rotate — Section 4's "fixed references first" rule). Real construction order followed: fixed refs placed first (axle at `fc`, handle bore at its closed position, CB1 at its OPEN-state position, all real coordinates); door-side arm (rib profile from handle through A/B/C to the pivot) built in native/closed frame; CB-side branch built via a real 45mm arc around apex D (converted to native frame via a round-trip rotation self-check) — REAL BUG FOUND+FIXED: a naive straight branch spine would have passed within 0.01mm of apex D at ~83° (see docs/lid-hinge-counterbalance-calc.md). CB1 position built from the source prompt's own LITERAL FORMULA (598.6,1207.1 open-state), not its own illustrative decimal (536.5,1269.2) — flagged mismatch, see calc doc. Real Python sweep confirms apex-D clearance ~24.9mm net (target 20mm). U-prong stopper/holder wraps only HALF the CB1 pipe (a full clearance hole + an extra open-side material removal, not a full collar), contact lands at CB1's own 170.8mm-from-D position. *** REAL, SIGNIFICANT FINDING, NOT RESOLVED THIS ROUND ***: rib0 (X=250, inside tray0's span) and rib2 (X=665, inside tray1's span) have a confirmed real geometric interference with `trays()` above at their shared Y=0 weld zone (up to -35mm overlap, present even at each mechanism's own default rest state) — reducing the weld-zone's own local width helped (45mm->22-25mm) but did not resolve it; moving RIB_X doesn't help either (the trays' combined footprint leaves only one ~5mm gap for 3 required ribs). Flagged in cc_chat_log.md and docs/lid-hinge-counterbalance-calc.md for Janis's decision — NOT silently absorbed | a differentiated center rib, or a 2-arm (CB1+CB2) design — both explicitly superseded this round, see the source prompt's own Section 2 | `show_lid_hinge` |

Lid counterbalance/fulcrum mechanism (TASK 3): retired the "deliberately
NOT designed" note above — real as of 2026-07-24, see the row above and
docs/lid-hinge-counterbalance-calc.md for the full derivation.

## Toggle-completeness count (2026-07-24, v1.30)

BBQ-chambers-v23.scad ASSEMBLY: `show_lid_hardware` REMOVED (module +
toggle + ASSEMBLY call all retired together, R-009 confirmed dead) — was
15 real toggles, now 14. BBQ-offset-smoker-base-v6.scad ASSEMBLY: 1 new
module called (`lid_hinge_assembly`), 1 new real toggle
(`show_lid_hinge`) — 0 gaps; `trays`/`show_trays` UNCHANGED.
BBQ-understructure-v16.scad UNCHANGED from v15 (pure pointer bump, zero
toggle change). Combined total: 19 real toggles (was 19 — net zero, one
retired + one added).

## Toggle-completeness count (2026-07-22, v1.27)

NO CHANGE (bbq-rear-fender-arch-redesign) — a pure profile redesign of
one existing module (`rear_fender()`), zero ASSEMBLY-called modules
added or removed. `show_rear_fenders` unchanged. Combined total: still
19 real toggles across all 3 active files.

## Toggle-completeness count (2026-07-22, v1.26)

NO CHANGE (bbq-understructure-level-drop-companion + bbq-chambers-grate-
master-datum-restore-and-level-drop) — both rounds are pure Z-datum
restructures/pointer bumps, zero ASSEMBLY-called modules added or
removed. Combined total: still 19 real toggles across all 3 active files
(BBQ-chambers-v22.scad, BBQ-understructure-v14.scad,
BBQ-offset-smoker-base-v4.scad).

## Toggle-completeness count (2026-07-22, v1.25)

BBQ-offset-smoker-base-v2.scad ASSEMBLY: 1 module called (`trays`), 1
real toggle (`show_trays`) — 0 gaps. BBQ-chambers-v21.scad ASSEMBLY
UNCHANGED count/toggles from v20 (still 15 real toggles) — TASK 1 was a
real modification to 2 existing masks + 1 existing panel construction,
not a new ASSEMBLY-called module. BBQ-understructure-v12.scad UNCHANGED
this round (frozen, DO NOT TOUCH). Combined total: 19 real toggles (was
18) across all 3 files.

## Toggle-completeness count (2026-07-22, v1.24)

3 top-level ASSEMBLY-called modules in `BBQ-understructure-v12.scad` (was
4 — `prep_shelves()` removed with the tray, TASK 1), ALL 3 toggled
(`show_rear_axle`/`show_rear_fenders`/`show_front_wheel_support`) — 0
gaps. Chambers side UNCHANGED (still 15 real toggles, v20). Combined
total: 18 real toggles across both ASSEMBLY blocks (was 19).

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
