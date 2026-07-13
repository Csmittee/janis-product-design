# SKELETON_WORKSHEET.md — BBQ Offset Smoker
> Version 1.0 — 2026-07-13
> Changes: New file, first version. Per .claude/SKILL_product_design_
> skeleton.md's 3-artifact convention (Skeleton Definition Worksheet + BOM
> Subassembly Tree + Kinetic Dual-View table), consolidated into one file
> per the same reasoning VM-02's own SKELETON_WORKSHEET.md used ("the
> skill file specifies content format but not a file location").
> Previous: N/A

## ⚠️ GOVERNANCE FLAG — same as design_scope_of_work_rule.md

The source prompt states these 3 parts are "exactly as confirmed this
session... Copy verbatim from chat log" — a Claude Web chat log cc has no
access to. Part A (datum chain) below IS fully specified in the prompt's
own TASK 2 (GLOBAL PARAMS + DATUMS + module descriptions are literal, not
log-referenced) and is GROUNDED IN THE REAL BUILT FILE
(BBQ-chambers-v1.scad, real CGAL-verified this session — see
cc_chat_log.md). Parts B and C are NOT given anywhere in the prompt
itself beyond scattered mentions inside Task 2's module descriptions —
reconstructed here from that same real file, same as VM-02's own
retroactive-governance precedent ("grounded in the real v2.scad, not an
idealized pre-spec"). Not a substitute for Janis's actual confirmation —
flagged for review, not silently presented as pre-confirmed.

---

## PART A — Skeleton Definition Worksheet

```
MASTER ORIGIN: (0, 0, 0) at floor level, front-left corner of the product
  footprint (chimney/tow-handle end = front, firebox end = rear) — matches
  rules-dimensions.md's global "front-left at floor" convention.

PRIMARY DATUM:   DATUM_GRATE_Z (horizontal plane, Z=700mm, MASTER CONTROL
                 VALUE, not derived) — locks Z. Chain runs "grate-down":
                 chamber_floor_z and firebox_floor_z are both offsets FROM
                 this plane, not built up from the floor.
SECONDARY DATUM: DATUM_X_REAR (chamber's rear/firebox wall, X=915mm) —
                 locks X. Firebox is Parent: DATUM_X_REAR, not an
                 independently-set X position.
TERTIARY DATUM:  DATUM_Y_CENTER (chamber's lateral centerline, Y=305mm) —
                 locks Y. Firebox and chimney are both Parent:
                 DATUM_Y_CENTER (centered on the chamber's own width).

MAJOR SUB-ASSEMBLIES:
  Grill Grate      — Parent: DATUM_GRATE_Z              — offset: (0,0,0), fixed
  Cook Chamber      — Parent: DATUM_GRATE_Z              — offset: dZ=-100 (chamber_floor_z)
  Lid               — Parent: Cook Chamber's own ridge/seam datums — offset: hinge at (lid_x1, -, DATUM_Z_RIDGE)
  Firebox           — Parent: Cook Chamber's rear wall (DATUM_X_REAR)   — offset: own floor via firebox_drop
  Chimney/drop tube — Parent: Cook Chamber's fixed front-shoulder ridge — offset: (200,0,0) from DATUM_X_FRONT
  Understructure     — Parent: Cook Chamber's chamber_floor_z (DERIVED leg_h) — offset: down to ground
```

## PART B — BOM Subassembly Tree

```
BBQ Offset Smoker V1 (top assembly)
├── Cook Chamber
│   ├── Chamber shell (fixed hex tube, wall_t hollow)
│   ├── Lid (hinged cap: 2 slant panels + 1 ridge panel)
│   │   ├── Lift handle rail (2 standoff posts)
│   │   ├── Toggle-clamp latches x2 (BUY, off-shelf placeholder)
│   │   ├── Dome thermometer (BUY, off-shelf placeholder)
│   │   └── Counterbalance lever + weight
│   ├── Grill grate (3 removable segments)
│   ├── Drop tube (internal, fixed)
│   └── Floor drain valves x2 (BUY, off-shelf placeholder)
├── Firebox
│   ├── Firebox shell (4-wall hollow box, open both ends)
│   ├── Fire grate (welded bars)
│   ├── Ash tray (slide-out)
│   └── Firebox door (hinged, joggle-step joint)
│       └── Air-intake damper cutout
├── Chimney (foldable, on fixed shell material)
└── Understructure
    ├── Legs x4 (corner tube, DERIVED height)
    ├── Casters x4 (2 fixed + 2 swivel, BUY, off-shelf placeholder)
    ├── Tow handle (BUY, off-shelf placeholder)
    └── Prep shelves x2 (fold-up, left + right)
```

## PART C — Kinetic Dual-View Table

Per the Kinetic Dual-View Convention (SKILL_product_design_skeleton.md),
every part below got both end states established as real toggles/
parameters from its first committed version, and both states were
verified via real CGAL render this session (not just the default state
— see cc_chat_log.md for the actual sweep record):

| KINETIC PART | STATE A | STATE B | Notes |
|---|---|---|---|
| Lid | closed (`lid_open_deg=0`) | open (`lid_open_deg` up to ~100) | Continuous angle, not just 2 discrete states |
| Firebox door | closed (`firebox_door_open_deg=0`) | open (up to ~110) | Continuous angle |
| Ash tray | in (`ash_tray_out_pct=0`) | out (`ash_tray_out_pct=1`) | Full-out only physically valid with door open — same accepted door-dependency pattern as VM-02's `tray_out_pct`, not a bug |
| Chimney | deployed (`chimney_open=true`, vertical) | folded (`chimney_open=false`, horizontal) | Discrete boolean, not continuous |
| Prep shelves | deployed (`shelf_deployed=true`, horizontal) | stowed (`shelf_deployed=false`, vertical) | Discrete boolean |

Static/removable parts (Grill grate segments, floor drain valves, toggle-
clamp latches) are NOT independently kinetic — they're removable/fixed
hardware, not hinged/sliding mechanisms, so they get a `show_*` isolation
toggle only (Toggle-Completeness Rule), not a dual-view kinetic state.

## Toggle-Completeness count (2026-07-13, v1.0)

BBQ-chambers-v1.scad ASSEMBLY: 8 modules called (`chamber_shell`, `lid`,
`lid_hardware`, `firebox`, `chimney`, `drop_tube`, `grill_grate`,
`floor_drains`) — all 8 have a real `show_*` toggle from first commit.
8/8 compliant.

BBQ-understructure.scad ASSEMBLY: 4 modules called (`legs`, `casters`,
`tow_handle`, `prep_shelves`) — all 4 have a real `show_*` toggle from
first commit. 4/4 compliant.

No safety-critical no-toggle exceptions needed this version (nothing in
this product blocks hand access the way VM-01/VM-02's drop-zone guards
do).
