# SKELETON_WORKSHEET.md — BBQ Offset Smoker
> Version 1.1 — 2026-07-13
> Changes: bbq-offset-smoker-v1-init-ADDENDUM. No content rewrite needed —
> the addendum's Section 3b instructs Part B/C to be DERIVED from the
> module list already locked in Task 2/3, which is exactly what v1.0
> already did (confirmed correct approach, not superseded). This version
> updates the GOVERNANCE FLAG to reflect the addendum's confirmation +
> confidence framing, and reconciles Part A's axis notation explicitly.
> Previous: 1.0 — 2026-07-13

## ⚠️ GOVERNANCE FLAG — same as design_scope_of_work_rule.md

The original prompt states these 3 parts are "exactly as confirmed this
session... Copy verbatim from chat log" — a Claude Web chat log cc has no
access to. The `bbq-offset-smoker-v1-init-ADDENDUM-cc-prompt.md` follow-up
confirmed the correct handling for each part:

- **Part A (datum chain)** — fully specified directly in the original
  prompt's own TASK 2 (GLOBAL PARAMS + DATUMS + module descriptions are
  literal, not log-referenced), GROUNDED IN THE REAL BUILT FILE
  (BBQ-chambers-v1.scad, real CGAL-verified — see cc_chat_log.md). The
  addendum's own Section 3b restates Part A using the original prompt's
  pre-correction "Y=chamber_L" notation — this file uses the CORRECTED
  axis (X=chamber_L) throughout, matching the actually-built file and
  rules-dimensions.md's locked all-models coordinate standard (see
  BBQ-chambers-v1.scad's header for the full correction rationale).
- **Parts B/C (BOM tree, Kinetic table)** — the addendum confirms these
  were never a verbatim Janis-confirmed source to begin with, and
  instructs deriving them mechanically from the module list already
  locked in Task 2/3 — exactly what this file already did. Confirmed
  correct, not rewritten. Per the addendum's own instruction: stated
  explicitly here that Parts B/C are CC-DERIVED from the geometry spec,
  not copied from a prior Janis confirmation — still requires Janis's
  review, not silently presented as pre-confirmed.

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

## Toggle-Completeness count (2026-07-13, v1.1 — unchanged from v1.0)

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
