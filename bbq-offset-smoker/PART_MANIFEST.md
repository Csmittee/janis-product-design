# PART_MANIFEST.md — BBQ Offset Smoker
# What every ASSEMBLY-called module actually IS, in plain language.
# Read by: Claude Web + cc, before any QA session and before adding any
# new part. Update this file in the SAME prompt that adds/renames/removes
# any ASSEMBLY-called module — never let it drift from the real file.
#
# Version: 1.9 — 2026-07-17 (bbq-understructure-v2-axles-swivel-handle):
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

## BBQ-chambers-v11.scad

| Module | What it IS | What it is NOT (only if real confusion risk exists) | Toggle |
|---|---|---|---|
| `chamber_shell()` | fixed portion of the octagon (floor + RIGHT wall + right chamfer + half ridge, v3 MIRRORED — was the left/Y=0 side in v2), full chamber_L length, wall_t hollow. v8: octagon is now genuinely REGULAR (chamfer corrected 150->178.665mm, real `chamber_W/(2+sqrt(2))` formula, all 8 sides confirmed 252.670mm). Real 8-point `true_octagon_profile()` (real edges only) hollowed FIRST, then clipped to the fixed side via `fixed_side_wedge()` (a cutting-plane mask, not baked into the profile). Closure-fixed real solid end caps preserved; `lid_territory_margin_fill()` (v8 — REPLACES `lid_territory_end_caps()`) closes the gap at both lid-territory end margins (X=0-100, X=815-915); rear wall carries `firebox_passage()`; front end-cap carries exhaust_room_opening() | the lid's own territory for X=[LID_X0,LID_X1] — a SEPARATE part (`lid()`) | `show_chamber_shell` |
| `lid_territory_margin_fill()` | v8 — REPLACES `lid_territory_end_caps()` (PR #121/v6, REMOVED). Same coverage (X=0-100, X=815-915) but now built from the SAME shared `true_octagon_profile()`+`octagon_ring()` helper `chamber_outer_tube()` itself uses (was a DIFFERENT profile, `lid_profile()`, in v6/v7 — two independently-modeled shapes meeting at a seam, which Janis was seeing as a visible wall). Real wall_t end cap ONLY at the true outer end (X=0 or X=915); fully OPEN at LID_X0/LID_X1 — no separate closing face. Real CGAL boundary probe: continuous wall_t-only material at the boundary (~5096mm² cross-section, vs ~308258mm² a solid closing panel would show) | a solid plug (v5's version, already fixed pre-v6) or a separately-profiled shape meeting the tube at a seam (v6/v7's version, the real cause of the visible wall) | (none — sub-part of `chamber_shell()`, no separate toggle) |
| `firebox_passage()` | Real 2D intersection of `fixed_side_solid_2d()` (v9 NEW — real edges only, replaces `fixed_shell_profile()`, now DELETED) and the firebox's own square cross-section, inset 15mm. v9: rebuilt per the source prompt's theory that the fake-diagonal profile was causing the "triangle leak" — independently verified FALSE (real XOR test: `fixed_shell_profile()` and `fixed_side_solid_2d()` are identical shapes) — area unchanged at 88209.549116mm² (exact match to v8's 88209.5mm²). This rebuild is a code-quality cleanup, NOT a fix — the "triangle leak" symptom remains unexplained, see file header | a fix for the "triangle leak" — that symptom is still open, KT-exhausted, needs Janis's direct input | (none — sub-part of `chamber_shell()`, no separate toggle) |
| `lid(lid_open_deg)` | clamshell lid, 3 flat panels, hinged along the ridge midpoint. v6: margin widened LID_X0=100/LID_X1=815 (715mm long, was 10/905/895mm) — the 2 end zones are now real fixed (welded, non-opening) octagon-ring sections, not a thin plug. v3 MIRRORED to the Y=0 side, opens toward the user. Rotation SIGN flipped from v2 (real CGAL bounding-box check) | the fixed shell's own right wall/chamfer/half-ridge — those stay part of `chamber_shell()` | `show_lid` |
| `lid_hardware(lid_open_deg)` | UNCHANGED code, still built for v1's original end-hinged geometry, now stale across 3 redesigns (v2 ridge-hinge, v3 mirror, v6 margin widen) | a correctly-positioned part — still not repositioned, still explicitly deferred | `show_lid_hardware` — still FALSE by default — TODO: reposition once lid geometry is fully confirmed, follow-up prompt |
| `firebox(firebox_door_open_deg, ash_tray_out_pct)` | shelled 457mm cube, open on both the chamber-facing and door-facing ends — wraps `firebox_shell()`, `firebox_near_wall_closure()`, `firebox_upper_wall_seal()` (v11, NEW), `fire_grate()`, `ash_tray()`, `firebox_door()`. `firebox_shell()`/`fire_grate()`/`ash_tray()`/`firebox_door()` UNCHANGED (DO NOT TOUCH) | | `show_firebox` |
| `firebox_near_wall_closure()` | v3 — solid wall_t panel closing a REAL gap: the firebox's near wall is correctly open for Z>=chamber_floor_z, but for firebox_floor_z..chamber_floor_z (the 200mm firebox_drop step) there was no chamber wall behind it at all. Confirmed via real intersection() probe | the passage's own opening (stays untouched/open) OR the "triangle leak" gap ABOVE chamber_floor_z (that's `firebox_upper_wall_seal()`, v11, below) — this panel only covers the Z-range strictly below chamber_floor_z | (none — sub-part of `firebox()`, no separate toggle) |
| `firebox_upper_wall_seal()` | v11 NEW — THE REAL "triangle leak" FIX. Closes the region ABOVE chamber_floor_z where the firebox's square footprint sticks out past the narrowing octagon (`firebox_square_2d()` minus `fixed_side_solid_2d()`, clipped to h>=0), extruded wall_t at firebox_x0. Built from the real `firebox_square_2d()`/`fixed_side_solid_2d()` boolean (eroded by epsilon `e` to guarantee real volume overlap with `chamber_outer_tube()`'s wall, not just face-touching — found via a real CGAL non-manifold check, fixed, re-verified Simple:yes), not hardcoded triangle coordinates — stays correct if chamfer/firebox_size ever change. Two mirror-symmetric panels, 5218.8436mm² each | a fix for the passage cut itself (`firebox_passage_profile()`, unchanged, already correct) or for the region below chamber_floor_z (`firebox_near_wall_closure()`, above, unchanged) | (none — sub-part of `firebox()`, no separate toggle) |
| `exhaust_room()` | half-cylinder mounting room, 360mm dia x 100mm height (v3) — inscribes a real 180mm-diameter circle around the 127mm pipe (26.5mm clearance each side). Endcap opening a rectangle (360x100mm) | v2's 200/200 room (superseded) | `show_exhaust_room` |
| `chimney_pipe()` | 127mm pipe, coaxial with the room's mounting hole, `PIPE_HOLE_X=-90` (v3), real 26.5mm clearance both sides | v2's overhang-compromise position (superseded) | `show_chimney_pipe` |
| `grill_grate()` | 3 removable laser-cut segments, top at GRATE_Z exactly. v6: GRATE_Z REPOSITIONED 700->750 — aligned to the lid parting line, per Janis's explicit spec. v8: GRATE_Z is now FORMULA-DERIVED (`chamber_floor_z + chamfer` = 778.665mm, was hardcoded 750) — `chamber_floor_z` is now the fixed PRIMARY DATUM (`grate_clearance` retired) and GRATE_Z moves automatically with the corrected chamfer, "lifts up naturally" per Janis. Y-range (v5 fix) recomputed automatically from the same chamfer-boundary formulas at the new height band — re-verified collision-free against both the fixed shell and the closed lid | GRATE_Z is no longer an independent input at all — it's a real derived formula now, not "re-VALUED" by hand | `show_grate` |
| `floor_drains()` | 2 placeholder drain valve bosses, front third / back third of chamber length. UNCHANGED this session (DO NOT TOUCH) | | `show_drains` |

## BBQ-understructure-v2.scad

| Module | What it IS | What it is NOT (only if real confusion risk exists) | Toggle |
|---|---|---|---|
| `rear_axle()` | TASK 1, NEW (replaces v1's `legs()`+half of `casters()`). Fixed, NON-swivel axle under the firebox: 2 struts (Y=DATUM_Y_CENTER+/-150, real weld target inside the firebox's own solid bottom wall) drop from the firebox underside (`firebox_floor_z`=400) to a transverse round beam (REAR_AXLE_Z=304.8=WHEEL_R) spanning the real REAR_TRACK_WIDTH=857mm (`firebox_y0`-200 .. `firebox_y1`+200), carrying 2 placeholder 609.6mm wheels centered at the beam's own ends. Wraps `rear_axle_bracket()` (struts+beam) + `rear_wheels()` | a swivel/steerable mechanism — this axle is static, no kinetic parameter, per the prompt | `show_rear_axle` |
| `front_wheel_support()` | TASK 2, REWRITTEN this round (replaces v1's `legs()`+other half of `casters()`). ONE bent-sheet bracket, press-brake formed from ONE flat trapezoidal blank (6mm), built as 2 real trapezoid side-leg plates (X=FRONT_X=300 and X=FRONT_X-LEG_GAP=50, flagged cc judgment call — under the chamber's own front-third overhang, clear of the lid's hinge/motion zone) + 1 flat bottom plate (X-span=LEG_GAP=250, width=BOT_W), carrying a single swivel caster (100x100mm generic heavy-duty top-plate placeholder, flagged — no real hardware spec yet) whose own wheel REUSES TASK 1's 609.6mm WHEEL_D/WHEEL_R spec (flagged judgment call, real geometric fit — see file header). Top edge (h=MID_H=chamfer/2, width=TOP_W) real-CGAL-confirmed FLUSH against the chamber's own `true_octagon_profile()` boundary at that height (both endpoints, non-empty material probe). Wraps `front_bracket()` (2 legs + bottom plate) + `front_caster_plate()`/`front_caster_stem()`/`front_caster_wheel()` | a 2-caster/2-wheel front axle (only ONE caster, per the prompt's own "single bent-sheet bracket... carrying A swivel caster") — front/rear track width intentionally do NOT match (rear=857mm, front=single centered caster, no track width in the 2-wheel sense) — flagged for Janis to confirm the resulting 3-point/tricycle stance is intentional | `show_front_wheel_support` |
| `tow_handle_assembly(handle_tilt_deg, steer_deg)` | TASK 3, UNCHANGED spec from the source prompt (built fresh — v1's only precedent was an unspec'd placeholder cylinder). Flat TOP-VIEW-only triangle bracket (apex at TRIANGLE_APEX_X=-350, base at TRIANGLE_BASE_X=-50/TRIANGLE_BASE_W=200, plate thickness TRIANGLE_T=6 only — never a tall member) + a separate tall handle bar (HANDLE_LEN=400/HANDLE_D=25), hinged near the triangle's own tip (HINGE_X=-330, 20mm inset from the true apex — a real hinge pin can't seat on a zero-width vertex, real-CGAL-confirmed manifold overlap there). `handle_tilt_deg`: 0=towing/use (horizontal) .. 90=full-vertical storage — real CGAL probe vs `exhaust_room()` at full tilt: EMPTY (137.5mm real X clearance, 155mm real Z clearance, both independently sufficient). `steer_deg`: independent rotation about the triangle's own mount axis (vertical line through TRIANGLE_BASE_X/DATUM_Y_CENTER), turns the whole assembly. GOVERNANCE FLAG: HINGE_X/track-width/clearance numbers are a flagged cc judgment call, NOT a Janis-confirmed prior-session spec — cc_chat_log.md has no such record, see file header | related to / sharing any mount point, axle, or coordinate reference with TASK 2's `front_wheel_support()` — deliberately independent, zero cross-reference (confirmed: X-ranges don't even overlap, -350..-50 vs 50..300) | `show_tow_handle_assembly` |
| `prep_shelves(shelf_deployed)` | UNCHANGED from v1, per this prompt's DO NOT TOUCH. Real intersection() probe run this session against `front_wheel_support()` (TASK 2) — EMPTY, no conflict (X-ranges overlap but Y-ranges don't: bracket Y=[89.3,520.7] vs shelf Y=[-300,0]/[610,910]) | | `show_shelves` |

## Toggle-completeness count (2026-07-17, v1.9)

12 modules called across both ASSEMBLY blocks (8 in chambers, unchanged;
4 in understructure — same COUNT as v1.8, but 3 of the 4 are now real
mechanisms, not placeholders: `rear_axle()`, `front_wheel_support()`,
`tow_handle_assembly()` REPLACE `legs()`/`casters()`/`tow_handle()`
1-for-1, `prep_shelves()` unchanged). 12/12 have a real `show_*` isolation
toggle — 0 gaps, 0 safety-critical exceptions needed this version.
Sub-parts (`rear_axle_bracket()`/`rear_wheels()`,
`front_bracket()`/`front_caster_*()`, `tow_triangle()`/`tow_handle()`) are
called from within their own single ASSEMBLY-toggled wrapper — same
no-separate-toggle pattern `chamber_shell()`'s own sub-parts already use,
not a new exception. `show_lid_hardware` still defaults false (unchanged
this session, BBQ-chambers-v11.scad itself not touched).
