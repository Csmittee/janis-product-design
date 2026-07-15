# PART_MANIFEST.md — BBQ Offset Smoker
# What every ASSEMBLY-called module actually IS, in plain language.
# Read by: Claude Web + cc, before any QA session and before adding any
# new part. Update this file in the SAME prompt that adds/renames/removes
# any ASSEMBLY-called module — never let it drift from the real file.
#
# Version: 1.5 — 2026-07-15 (bbq-chambers-v7-fixed-shell-open-channel-
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

## BBQ-chambers-v7.scad

| Module | What it IS | What it is NOT (only if real confusion risk exists) | Toggle |
|---|---|---|---|
| `chamber_shell()` | fixed portion of the octagon (floor + RIGHT wall + right chamfer + half ridge, v3 MIRRORED — was the left/Y=0 side in v2), full chamber_L length, wall_t hollow. v7 REBUILT: real 8-point `true_octagon_profile()` (real edges only) hollowed FIRST, then clipped to the fixed side via `fixed_side_wedge()` (a cutting-plane mask, not baked into the profile) — this is the first version where "TRUE octagon profile" is actually accurate (v3-v6 used `fixed_shell_profile()`'s own fake diagonal closing edge, which caused the "reads solid" panel defect). Closure-fixed real solid end caps preserved; `lid_territory_end_caps()` (UNCHANGED, PR #121's fix) closes the gap at both lid-territory end margins (X=0-100, X=815-915); rear wall carries `firebox_passage()`; front end-cap carries exhaust_room_opening() | the lid's own territory for X=[LID_X0,LID_X1] — a SEPARATE part (`lid()`) | `show_chamber_shell` |
| `lid_territory_end_caps()` | UNCHANGED v6->v7 (PR #121's fix, already correct for what it covers — this prompt fixed a DIFFERENT module, `fixed_shell_profile()`/`chamber_outer_tube()`). wall_t-thick HOLLOW shell using `lid_profile()`. Re-verified this session: clean join to the REBUILT main tube at LID_X0/LID_X1 (real union()/intersection() boundary probe — only the same benign zero-volume coincident-face touch this file has hit before, no gap, no new overlap) | a solid plug (v5's version) — that was the real defect, already fixed pre-v6 | (none — sub-part of `chamber_shell()`, no separate toggle) |
| `firebox_passage()` | UNCHANGED this session (explicit separate open item, see file header). Real 2D intersection of `fixed_shell_profile()` (KEPT for this one caller only, see R-009 note in file header) and the firebox's own square cross-section, inset 15mm | the old fixed-rectangle window — REMOVED pre-v6, real scope change, not silently dropped | (none — sub-part of `chamber_shell()`, no separate toggle) |
| `lid(lid_open_deg)` | clamshell lid, 3 flat panels, hinged along the ridge midpoint. v6: margin widened LID_X0=100/LID_X1=815 (715mm long, was 10/905/895mm) — the 2 end zones are now real fixed (welded, non-opening) octagon-ring sections, not a thin plug. v3 MIRRORED to the Y=0 side, opens toward the user. Rotation SIGN flipped from v2 (real CGAL bounding-box check) | the fixed shell's own right wall/chamfer/half-ridge — those stay part of `chamber_shell()` | `show_lid` |
| `lid_hardware(lid_open_deg)` | UNCHANGED code, still built for v1's original end-hinged geometry, now stale across 3 redesigns (v2 ridge-hinge, v3 mirror, v6 margin widen) | a correctly-positioned part — still not repositioned, still explicitly deferred | `show_lid_hardware` — still FALSE by default — TODO: reposition once lid geometry is fully confirmed, follow-up prompt |
| `firebox(firebox_door_open_deg, ash_tray_out_pct)` | shelled 457mm cube, open on both the chamber-facing and door-facing ends — wraps `firebox_shell()`, `firebox_near_wall_closure()`, `fire_grate()`, `ash_tray()`, `firebox_door()`. All 4 UNCHANGED (DO NOT TOUCH) | | `show_firebox` |
| `firebox_near_wall_closure()` | v3 — solid wall_t panel closing a REAL gap: the firebox's near wall is correctly open for Z>=chamber_floor_z, but for firebox_floor_z..chamber_floor_z (the 200mm firebox_drop step) there was no chamber wall behind it at all. Confirmed via real intersection() probe | the passage's own opening — that stays untouched/open, this panel only covers the Z-range strictly below chamber_floor_z | (none — sub-part of `firebox()`, no separate toggle) |
| `exhaust_room()` | half-cylinder mounting room, 360mm dia x 100mm height (v3) — inscribes a real 180mm-diameter circle around the 127mm pipe (26.5mm clearance each side). Endcap opening a rectangle (360x100mm) | v2's 200/200 room (superseded) | `show_exhaust_room` |
| `chimney_pipe()` | 127mm pipe, coaxial with the room's mounting hole, `PIPE_HOLE_X=-90` (v3), real 26.5mm clearance both sides | v2's overhang-compromise position (superseded) | `show_chimney_pipe` |
| `grill_grate()` | 3 removable laser-cut segments, top at GRATE_Z exactly. v6: GRATE_Z REPOSITIONED 700->750 — aligned to the lid parting line (bottom of the lid's own vertical wall panel = chamber_floor_z+chamfer = 750 exactly), per Janis's explicit spec. `grate_clearance` moved 100->150 in lockstep so `chamber_floor_z` stays exactly 600 (unchanged) — confirmed no understructure impact (`leg_h` derives from `chamber_floor_z` alone). Y-range (v5 fix) recomputed automatically from the same chamfer-boundary formulas at the new height band — re-verified collision-free against both the fixed shell and the closed lid | GRATE_Z is still a real datum, just re-VALUED to match a real feature line, not arbitrarily moved | `show_grate` |
| `floor_drains()` | 2 placeholder drain valve bosses, front third / back third of chamber length. UNCHANGED this session (DO NOT TOUCH) | | `show_drains` |

## BBQ-understructure.scad

| Module | What it IS | Toggle |
|---|---|---|
| `legs()` | 4 corner-tube legs, height DERIVED from `chamber_floor_z` (not independently set) | `show_legs` |
| `casters()` | 2 fixed (firebox/rear end) + 2 swivel (chimney/front end), placeholder geometry | `show_casters` |
| `tow_handle()` | placeholder tow handle, chimney/front end | `show_tow_handle` |
| `prep_shelves(shelf_deployed)` | 2 fold-up prep shelves, left+right, front of chamber | `show_shelves` |

## Toggle-completeness count (2026-07-15, v1.5)

12 modules called across both ASSEMBLY blocks (8 in chambers, 4 in
understructure) — same count as v1.4 (no ASSEMBLY-called module
added/removed this session; `chamber_inner_cavity()` changed from a
`chamber_shell()`-level subtraction to an internal helper inside the
rebuilt `chamber_outer_tube()`, but it was never ASSEMBLY-called either
way, so no toggle count change). 12/12 have a real `show_*` isolation
toggle — 0 gaps, 0 safety-critical exceptions needed this version.
`show_lid_hardware` still defaults false (unchanged this session).
