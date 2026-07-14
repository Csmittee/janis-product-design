# PART_MANIFEST.md — BBQ Offset Smoker
# What every ASSEMBLY-called module actually IS, in plain language.
# Read by: Claude Web + cc, before any QA session and before adding any
# new part. Update this file in the SAME prompt that adds/renames/removes
# any ASSEMBLY-called module — never let it drift from the real file.
#
# Version: 1.3 — 2026-07-14 (direct-cc, R-011, no prompt file — 3 findings
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
# Source: BBQ-chambers-v5.scad + BBQ-understructure.scad ASSEMBLY blocks.
#
# Toggle column key: a `show_*` name means the module is gated by that
# toggle, per the Toggle-Completeness Rule (cc_rules.md). "(none — always
# on, safety-critical)" is the ONLY other permitted value.

## BBQ-chambers-v5.scad

| Module | What it IS | What it is NOT (only if real confusion risk exists) | Toggle |
|---|---|---|---|
| `chamber_shell()` | fixed portion of the octagon (floor + RIGHT wall + right chamfer + half ridge, v3 MIRRORED — was the left/Y=0 side in v2), full chamber_L length, wall_t hollow; TRUE 8-point octagon profile; closure-fixed real solid end caps; NEW v5 `lid_territory_end_caps()` closes the confirmed gap at both lid-territory end margins (X=0-10, X=905-915); rear wall carries `firebox_passage()` (v5, replaces window_hole()); front end-cap carries exhaust_room_opening() (resized v3, cut also applies through the new v5 end caps) | the lid's own territory for X=[LID_X0,LID_X1] — a SEPARATE part (`lid()`) | `show_chamber_shell` |
| `lid_territory_end_caps()` | NEW v5 — solid end-plug fill (using `lid_profile()`'s own shape) at the 2 short margins where the lid stops short of the shell's true ends. CONFIRMED real unclosed gap via CGAL (empty probe result against v4's `chamber_shell()`) | a moving/hollow part — these are short fixed solid plugs, not lid material | (none — sub-part of `chamber_shell()`, no separate toggle) |
| `firebox_passage()` | NEW v5 — REPLACES `window_hole()` (v1, fixed 254x119mm rectangle). Real 2D intersection of `fixed_shell_profile()` and the firebox's own square cross-section, inset 10mm, per Janis's explicit spec. Much larger opening, contour-following (both bottom chamfers + the internal parting seam), CGAL-confirmed manifold and bounded correctly by the chamber's own floor | the old fixed-rectangle window — REMOVED, real scope change, not silently dropped | (none — sub-part of `chamber_shell()`, no separate toggle, same as `window_hole()` before it) |
| `lid(lid_open_deg)` | full-length (895mm, X:10-905) clamshell lid, 3 flat panels, hinged along the FULL chamber length at the ridge midpoint. v3 MIRRORED to the Y=0 side (was Y=chamber_W in v2) per the new Standing Orientation Convention (rules-bbq-fab.md) — opens toward the user. Rotation SIGN also flipped from v2 (real CGAL bounding-box check, not assumed from mirror symmetry) | the fixed shell's own right wall/chamfer/half-ridge — those stay part of `chamber_shell()` | `show_lid` |
| `lid_hardware(lid_open_deg)` | UNCHANGED code, still built for v1's original end-hinged geometry, now doubly stale (v2's ridge-hinge redesign AND v3's mirror both postdate it) | a correctly-positioned v3 part — still not repositioned, still explicitly deferred | `show_lid_hardware` — still FALSE by default — TODO: reposition once lid geometry is fully confirmed, follow-up prompt |
| `firebox(firebox_door_open_deg, ash_tray_out_pct)` | shelled 457mm cube, open on both the chamber-facing and door-facing ends — wraps `firebox_shell()`, NEW `firebox_near_wall_closure()`, `fire_grate()`, `ash_tray()`, `firebox_door()`. `firebox_shell()`/`fire_grate()`/`ash_tray()`/`firebox_door()` UNCHANGED (DO NOT TOUCH) | | `show_firebox` |
| `firebox_near_wall_closure()` | NEW v3 — solid wall_t panel closing a REAL gap: the firebox's near wall is correctly open for Z>=chamber_floor_z (matches window_hole), but for firebox_floor_z..chamber_floor_z (the 200mm firebox_drop step) there was no chamber wall behind it at all — a genuine unclosed hole, not a designed opening. Confirmed via real intersection() probe (full footprint check, not a sample point) | the window_hole's own opening — that stays untouched/open, this panel only covers the Z-range strictly below chamber_floor_z | (none — sub-part of `firebox()`, no separate toggle, same pattern as `fire_grate()`/`ash_tray()`) |
| `exhaust_room()` | half-cylinder mounting room, RESIZED v3: 360mm dia x 100mm height (was 200/200 in v2) — inscribes a real 180mm-diameter circle around the 127mm pipe (26.5mm clearance each side), resolving v2's own found conflict (200mm room could only inscribe 100mm, forcing overhang) at the source. Endcap opening RE-CONFIRMED still a rectangle (360x100mm now), same real-geometry finding as v2, not the "semicircle" language | v2's 200/200 room (superseded) | `show_exhaust_room` |
| `chimney_pipe()` | 127mm pipe, coaxial with the room's mounting hole. RE-POSITIONED v3: `PIPE_HOLE_X=-90` (was -60 in v2), now centered with real 26.5mm clearance on both sides instead of a forced overhang — v2's 2 real collision workarounds (rear-margin shell, then the lid's front edge) are no longer needed at this size | v2's overhang-compromise position (superseded) | `show_chimney_pipe` |
| `grill_grate()` | 3 removable laser-cut segments, top at GRATE_Z exactly (unchanged, MASTER CONTROL VALUE). Y-RANGE FIXED v5: was a constant-width assumption that CGAL-confirmed collided with the fixed shell's own bottom chamfers (36 facets, real intersection); now computed from the real chamfer-boundary formulas at the grate's own height band, + wall_t/safety inset | GRATE_Z itself was NOT moved — only the Y-range changed | `show_grate` |
| `floor_drains()` | 2 placeholder drain valve bosses, front third / back third of chamber length. UNCHANGED this session (DO NOT TOUCH) | | `show_drains` |

## BBQ-understructure.scad

| Module | What it IS | Toggle |
|---|---|---|
| `legs()` | 4 corner-tube legs, height DERIVED from `chamber_floor_z` (not independently set) | `show_legs` |
| `casters()` | 2 fixed (firebox/rear end) + 2 swivel (chimney/front end), placeholder geometry | `show_casters` |
| `tow_handle()` | placeholder tow handle, chimney/front end | `show_tow_handle` |
| `prep_shelves(shelf_deployed)` | 2 fold-up prep shelves, left+right, front of chamber | `show_shelves` |

## Toggle-completeness count (2026-07-14, v1.3)

12 modules called across both ASSEMBLY blocks (8 in chambers, 4 in
understructure) — same count as v1.2 (`lid_territory_end_caps()` and
`firebox_passage()` are both sub-parts called from within
`chamber_shell()`, not new direct ASSEMBLY entries, same pattern as
`firebox_near_wall_closure()`). 12/12 have a real `show_*` isolation
toggle — 0 gaps, 0 safety-critical exceptions needed this version.
`show_lid_hardware` still defaults false (unchanged this session).
