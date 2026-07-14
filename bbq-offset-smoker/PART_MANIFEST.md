# PART_MANIFEST.md — BBQ Offset Smoker
# What every ASSEMBLY-called module actually IS, in plain language.
# Read by: Claude Web + cc, before any QA session and before adding any
# new part. Update this file in the SAME prompt that adds/renames/removes
# any ASSEMBLY-called module — never let it drift from the real file.
#
# Version: 1.1 — 2026-07-14 (bbq-chambers-v2-closure-exhaust-lid): source
# now BBQ-chambers-v2.scad. chamber_shell()'s entry updated (true octagon,
# closure-fixed, no more lid_opening_cut()). lid()'s entry updated (new
# ridge-hinge mechanism, replaces the old end-hinged construction).
# chimney()/drop_tube() REMOVED, exhaust_room()/chimney_pipe() ADDED.
# lid_hardware()'s Toggle changed to default-off (stale v1 positions).
# Previous: 1.0 — 2026-07-13 (bbq-offset-smoker-v1-init): first version,
# seeded from SKELETON_WORKSHEET.md's BOM Subassembly Tree, grounded in
# the real BBQ-chambers-v1.scad + BBQ-understructure.scad.
# Source: BBQ-chambers-v2.scad + BBQ-understructure.scad ASSEMBLY blocks.
#
# Toggle column key: a `show_*` name means the module is gated by that
# toggle, per the Toggle-Completeness Rule (cc_rules.md). "(none — always
# on, safety-critical)" is the ONLY other permitted value.

## BBQ-chambers-v2.scad

| Module | What it IS | What it is NOT (only if real confusion risk exists) | Toggle |
|---|---|---|---|
| `chamber_shell()` | fixed portion of the octagon (floor + left wall + left chamfer + half ridge), full chamber_L length, wall_t hollow; TRUE 8-point octagon profile (chamfered top AND bottom, v2 — was 6-point, top-only in v1); CLOSURE BUG FIXED (v1's inner cavity overshot past both extrusion ends, leaving only a paper-thin end rim — v2 insets it to real wall_t solid end caps); rear wall carries the window_hole pass-through cut (unchanged); front end-cap carries the NEW exhaust_room_opening() cut (v2) | the lid's own territory (right wall + right chamfer + half ridge) — that's a SEPARATE part now (`lid()`), not a cutout in this module (v1 used a cutout in a full-octagon profile; v2 excludes that material from the profile itself) | `show_chamber_shell` |
| `lid(lid_open_deg)` | full-length (895mm, X:10-905) clamshell lid, 3 flat panels (half-ridge + chamfer + wall), hinged along the FULL chamber length at the ridge midpoint (rotate about an X-axis line) — v2, REPLACES v1's end-hinged trunk-lid construction entirely (old lid_x0/lid_x1/LID_MARGIN_FRONT/REAR/lid_opening_cut() all removed) | the fixed shell's own left wall/chamfer/half-ridge — those stay part of `chamber_shell()` | `show_lid` |
| `lid_hardware(lid_open_deg)` | lift handle rail, toggle-clamp latches x2, dome thermometer port, counterbalance lever+weight — UNCHANGED code from v1, built for the OLD lid geometry, now stale/wrong for the new lid shape | a correctly-positioned v2 part — it is NOT repositioned this session, explicitly deferred per this session's own DO NOT respecify instruction | `show_lid_hardware` — DEFAULTS FALSE v2 (was true in v1) — TODO: reposition once new lid confirmed, follow-up prompt |
| `firebox(firebox_door_open_deg, ash_tray_out_pct)` | shelled 457mm cube, open on BOTH the chamber-facing and door-facing ends (door is the only covering on the outward face) — wraps `firebox_shell()`, `fire_grate()`, `ash_tray()`, `firebox_door()`. UNCHANGED this session (DO NOT TOUCH, already correct/CGAL-verified) | | `show_firebox` |
| `exhaust_room()` | NEW v2 — half-cylinder mounting room (200mm dia/height), vertical axis, welded flush to the chamber's front end-cap (curved side + floor + top solid wall_t, back face fully open, matching the chamber's own new endcap opening). REPLACES v1's `chimney()` construction. REAL INCONSISTENCY FLAGGED: the source prompt describes the endcap opening as "semicircular" but the room's own true flat interface face (given its stated vertical axis + 200mm height) is a RECTANGLE — built to match the room's real geometry, not the prompt's semicircle description; see BBQ-chambers-v2.scad's own header | v1's `chimney()` (recessed stub, mounted differently) or `drop_tube()` (REMOVED entirely, no v2 equivalent — see cc_chat_log.md) | `show_exhaust_room` |
| `chimney_pipe()` | NEW v2 — 127mm pipe, coaxial with a round hole cut through the room's own top plate, base extends below the hole for a real manifold-safe weld. REAL DIMENSIONAL CONFLICT FLAGGED: 127mm pipe cannot be fully inscribed within the room's 200mm semicircular top (max inscribable circle = 100mm) — positioned with real CGAL-verified clearance from the lid's own front edge (a SECOND real collision found+fixed this session, not in the source prompt) | v1's `chimney()` (recessed/foldable) — this is a simple fixed coaxial stack, no fold mechanism this version | `show_chimney_pipe` |
| `grill_grate()` | 3 removable laser-cut segments, top at GRATE_Z exactly. UNCHANGED this session (DO NOT TOUCH) | | `show_grate` |
| `floor_drains()` | 2 placeholder drain valve bosses, front third / back third of chamber length. UNCHANGED this session (DO NOT TOUCH) | | `show_drains` |

## BBQ-understructure.scad

| Module | What it IS | Toggle |
|---|---|---|
| `legs()` | 4 corner-tube legs, height DERIVED from `chamber_floor_z` (not independently set) | `show_legs` |
| `casters()` | 2 fixed (firebox/rear end) + 2 swivel (chimney/front end), placeholder geometry | `show_casters` |
| `tow_handle()` | placeholder tow handle, chimney/front end | `show_tow_handle` |
| `prep_shelves(shelf_deployed)` | 2 fold-up prep shelves, left+right, front of chamber | `show_shelves` |

## Toggle-completeness count (2026-07-14, v1.1)

12 modules called across both ASSEMBLY blocks (8 in chambers, 4 in
understructure) — same count as v1.0 (chimney()+drop_tube() removed,
exhaust_room()+chimney_pipe() added, net zero change). 12/12 have a real
`show_*` isolation toggle — 0 gaps, 0 safety-critical exceptions needed
this version. `show_lid_hardware` defaults false this session (see its
own row above) — the toggle itself is present and compliant, only its
default value changed.
