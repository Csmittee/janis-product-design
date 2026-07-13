# PART_MANIFEST.md — BBQ Offset Smoker
# What every ASSEMBLY-called module actually IS, in plain language.
# Read by: Claude Web + cc, before any QA session and before adding any
# new part. Update this file in the SAME prompt that adds/renames/removes
# any ASSEMBLY-called module — never let it drift from the real file.
#
# Version: 1.0 — 2026-07-13 (bbq-offset-smoker-v1-init): first version,
# seeded from SKELETON_WORKSHEET.md's BOM Subassembly Tree, grounded in
# the real BBQ-chambers-v1.scad + BBQ-understructure.scad.
# Source: BBQ-chambers-v1.scad + BBQ-understructure.scad ASSEMBLY blocks.
#
# Toggle column key: a `show_*` name means the module is gated by that
# toggle, per the Toggle-Completeness Rule (cc_rules.md). "(none — always
# on, safety-critical)" is the ONLY other permitted value.

## BBQ-chambers-v1.scad

| Module | What it IS | What it is NOT (only if real confusion risk exists) | Toggle |
|---|---|---|---|
| `chamber_shell()` | fixed hex-tube chamber body, floor to ridge, wall_t hollow; ridge/chamfer zone between lid_x0/lid_x1 cut away for `lid()`; rear wall carries the window_hole pass-through cut | | `show_chamber_shell` |
| `lid(lid_open_deg)` | hinged cap over the ridge cutout, 3 flat panels, hinged at the rear-top edge | the fixed shell's own ridge in the front/rear MARGIN zones — those stay part of `chamber_shell()` | `show_lid` |
| `lid_hardware(lid_open_deg)` | lift handle rail, toggle-clamp latches x2, dome thermometer port, counterbalance lever+weight — all rigid on the lid's own hinge, rotate WITH it | | `show_lid_hardware` |
| `firebox(firebox_door_open_deg, ash_tray_out_pct)` | shelled 457mm cube, open on BOTH the chamber-facing and door-facing ends (door is the only covering on the outward face) — wraps `firebox_shell()`, `fire_grate()`, `ash_tray()`, `firebox_door()` | | `show_firebox` |
| `chimney(chimney_open)` | foldable flue, mounted on the FIXED shell's front-margin ridge (not the lid), base recessed 40mm for weld joint | the internal drop_tube — that's a separate always-fixed part | `show_chimney` |
| `drop_tube()` | internal smoke tube, chimney base connection down to GRATE_Z, always fixed regardless of chimney fold state | | `show_drop_tube` |
| `grill_grate()` | 3 removable laser-cut segments, top at GRATE_Z exactly | | `show_grate` |
| `floor_drains()` | 2 placeholder drain valve bosses, front third / back third of chamber length | | `show_drains` |

## BBQ-understructure.scad

| Module | What it IS | Toggle |
|---|---|---|
| `legs()` | 4 corner-tube legs, height DERIVED from `chamber_floor_z` (not independently set) | `show_legs` |
| `casters()` | 2 fixed (firebox/rear end) + 2 swivel (chimney/front end), placeholder geometry | `show_casters` |
| `tow_handle()` | placeholder tow handle, chimney/front end | `show_tow_handle` |
| `prep_shelves(shelf_deployed)` | 2 fold-up prep shelves, left+right, front of chamber | `show_shelves` |

## Toggle-completeness count (2026-07-13, v1.0)

12 modules called across both ASSEMBLY blocks (8 in chambers, 4 in
understructure). 12/12 have a real `show_*` isolation toggle from first
commit — 0 gaps, 0 safety-critical exceptions needed this version.
