# PART_MANIFEST.md — BBQ Offset Smoker
# What every ASSEMBLY-called module actually IS, in plain language.
# Read by: Claude Web + cc, before any QA session and before adding any
# new part. Update this file in the SAME prompt that adds/renames/removes
# any ASSEMBLY-called module — never let it drift from the real file.
#
# Version: 1.12 — 2026-07-17 (bbq-chambers-v13-reanchor-grate-decouple-rear-
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

## BBQ-chambers-v13.scad

| Module | What it IS | What it is NOT (only if real confusion risk exists) | Toggle |
|---|---|---|---|
| `chamber_shell()` | UNCHANGED CODE v13 (chamber's own shape frozen, DO NOT TOUCH) — fixed portion of the octagon, full chamber_L length, wall_t hollow. Real world position moves via `chamber_floor_z`'s own new live-formula value (900-chamfer=721.335mm, was hardcoded 600) — every downstream Z (DATUM_Z_RIDGE, ROOM_BASE_Z/TOP_Z, lid panels) recomputes automatically. Rear wall carries the REBUILT `firebox_passage()` (real cylinder∩octagon cut, TASK 3); front end-cap carries exhaust_room_opening() | the lid's own territory for X=[LID_X0,LID_X1] — a SEPARATE part (`lid()`) | `show_chamber_shell` |
| `lid_territory_margin_fill()` | v8 — REPLACES `lid_territory_end_caps()` (PR #121/v6, REMOVED). Same coverage (X=0-100, X=815-915) but now built from the SAME shared `true_octagon_profile()`+`octagon_ring()` helper `chamber_outer_tube()` itself uses (was a DIFFERENT profile, `lid_profile()`, in v6/v7 — two independently-modeled shapes meeting at a seam, which Janis was seeing as a visible wall). Real wall_t end cap ONLY at the true outer end (X=0 or X=915); fully OPEN at LID_X0/LID_X1 — no separate closing face. Real CGAL boundary probe: continuous wall_t-only material at the boundary (~5096mm² cross-section, vs ~308258mm² a solid closing panel would show) | a solid plug (v5's version, already fixed pre-v6) or a separately-profiled shape meeting the tube at a seam (v6/v7's version, the real cause of the visible wall) | (none — sub-part of `chamber_shell()`, no separate toggle) |
| `firebox_passage()` | v13 REBUILT — real `intersection()` of `fixed_side_solid_2d()` (UNCHANGED) and NEW `fuel_cylinder_circle_2d()` (the ALREADY-BUILT v12 fuel cylinder's own real 388.6mm circular cross-section, read live) — replaces the old rectangular/inset firebox-footprint cut against `firebox_square_2d()`. `PASSAGE_INSET` RETIRED (R-009, zero other consumers). Real result: round on the ridge-ward side (circle unclipped, well inside the octagon's wide vertical-wall zone), octagon-clipped on the floor-ward side (h correctly clamped to exactly [0,258.665] — zero material below chamber_floor_z, confirmed numerically) — matches Janis's "look through the door" description | the old square-footprint cut (retired) or a hand-derived approximate boundary — this uses a real `intersection()` against the live profile | (none — sub-part of `chamber_shell()`, no separate toggle) |
| `lid(lid_open_deg)` | clamshell lid, 3 flat panels, hinged along the ridge midpoint. v6: margin widened LID_X0=100/LID_X1=815 (715mm long, was 10/905/895mm) — the 2 end zones are now real fixed (welded, non-opening) octagon-ring sections, not a thin plug. v3 MIRRORED to the Y=0 side, opens toward the user. Rotation SIGN flipped from v2 (real CGAL bounding-box check) | the fixed shell's own right wall/chamfer/half-ridge — those stay part of `chamber_shell()` | `show_lid` |
| `lid_hardware(lid_open_deg)` | UNCHANGED code, still built for v1's original end-hinged geometry, now stale across 3 redesigns (v2 ridge-hinge, v3 mirror, v6 margin widen) | a correctly-positioned part — still not repositioned, still explicitly deferred | `show_lid_hardware` — still FALSE by default — TODO: reposition once lid geometry is fully confirmed, follow-up prompt |
| `firebox(firebox_door_open_deg, ash_tray_out_pct)` | v13: `firebox_shell()`/`fuel_cylinder()`/`ash_tray()`/`firebox_door()` all UNCHANGED CODE, frozen (firebox itself out of scope this round). Wraps NEW `firebox_end_cap()` (TASK 3, replaces the 2 retired modules below) instead of the old pair. Real, CGAL-confirmed ~1.5mm solid overlap with `chamber_outer_tube()`'s own end cap — unchanged from v12, still flagged, not a manifold defect | the old uniform-cube firebox (retired at v12) | `show_firebox` |
| `firebox_end_cap()` / `firebox_end_cap_2d()` | v13 TASK 3, NEW — REPLACES `firebox_near_wall_closure()` + `firebox_upper_wall_seal()` (BOTH RETIRED, R-009 confirmed zero other real consumers). ONE continuous plate at the firebox's near wall: `firebox_square_2d()` (UNCHANGED, the firebox's own full real rectangle) minus the SAME passage-hole shape `firebox_passage()` uses — provably aligned (same 2D module, same world Y/Z frame). Below chamber_floor_z the hole has zero area so the plate stays fully solid there by direct construction; above it, matches the round/octagon-clipped hole exactly. Real CGAL seal-weld: non-empty contact vs both `fuel_cylinder()` and `firebox_shell()`, confirmed | the old narrow-band pair it replaces — those only covered specific gap slivers, this covers the FULL near-wall face | (none — sub-part of `firebox()`, no separate toggle) |
| `fuel_cylinder()` | v12 TASK 2 NEW — replaces `fire_grate()` (REMOVED entirely, zero remaining callers). Hollow tube, 388.6mm dia (re-derived live from the real Task 1 firebox dims, matches the prompt's table exactly), wall_t=3mm, full firebox_x0..firebox_x1 span (open both ends — door-side end pulled back by `e` off the door plane per this file's own epsilon convention; far/chamber-side end open/unfinished, per Janis's own explicit "let me see how it looks" note — flagged as a real deferred open item). Real CGAL-confirmed clearance to the firebox's own inner wall: 17mm (Z, binding axis) / 57.7mm (Y), non-intersecting | a fixed grate (that concept is retired) or a capped/finished vessel at either end — both explicitly open | (none — sub-part of `firebox()`, no separate toggle) |
| `exhaust_room()` | half-cylinder mounting room, 360mm dia x 100mm height (v3) — inscribes a real 180mm-diameter circle around the 127mm pipe (26.5mm clearance each side). Endcap opening a rectangle (360x100mm) | v2's 200/200 room (superseded) | `show_exhaust_room` |
| `chimney_pipe()` | 127mm pipe, coaxial with the room's mounting hole, `PIPE_HOLE_X=-90` (v3), real 26.5mm clearance both sides | v2's overhang-compromise position (superseded) | `show_chimney_pipe` |
| `grill_grate()` | v13 TASK 2: Z-anchor DECOUPLED from the chamber body — now reads NEW `GRATE_Z_FIXED`=1000mm (*** TEMPORARY ***, mandatory comment at its own declaration — not permanent architecture, intended to be re-merged into `DATUM_GRATE_Z` once a future reinforcement frame + shorter door exist). Real gap above the reanchored apex A (`GRATE_Z`=900mm exact, TASK 1) = 100mm, floating/unsupported, expected. X/Y placement formulas (`GRATE_MARGIN`/`grate_seg_l`/`GRATE_Y0`/`GRATE_Y1`/`GRATE_LOCAL_H`) UNCHANGED CODE per explicit DO NOT TOUCH — still keyed to `DATUM_GRATE_Z`(900), NOT `GRATE_Z_FIXED`(1000), a real flagged consequence (grate built narrower — 564mm — than geometrically available at its real height, safe/non-colliding, confirmed via CGAL, just not width-optimal) | GRATE_Z_FIXED is NOT the same value as GRATE_Z/DATUM_GRATE_Z anymore — the grate and the chamber body are two independently-positioned things this round, by Janis's explicit, TEMPORARY design call | `show_grate` |
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
