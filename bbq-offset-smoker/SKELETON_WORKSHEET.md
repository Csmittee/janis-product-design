# SKELETON_WORKSHEET.md — BBQ Offset Smoker
> Version 1.2 — 2026-07-14
> Changes: bbq-chambers-v2-closure-exhaust-lid session. Part A's Chimney/
> drop-tube row REPLACED (drop_tube removed entirely, exhaust room+pipe
> added as new sub-assemblies). Part B's BOM tree updated to match (Window
> Cut / Chimney / Drop Tube entries replaced with Exhaust Room / Chimney
> Pipe). Part C's Lid kinetic row updated — new ridge-hinge mechanism
> (was end-hinged trunk lid), new confirmed max angle. Detail/content
> update within the SAME 3-part structure, not a new artifact — X.Y bump.
> Previous: 1.1 — 2026-07-13

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
  Lid               — Parent: Cook Chamber's ridge midpoint — offset: length-wise hinge at (-, DATUM_Y_CENTER, DATUM_Z_RIDGE), v2 (was end-hinged, v1)
  Firebox           — Parent: Cook Chamber's rear wall (DATUM_X_REAR)   — offset: own floor via firebox_drop
  Exhaust room      — Parent: Cook Chamber's front end-cap (DATUM_X_FRONT) — offset: welded flush at X=0, v2 (replaces v1's chimney/drop-tube)
  Chimney pipe      — Parent: Exhaust room's own top plate — offset: coaxial with the room's pipe-mounting hole, v2
  Understructure     — Parent: Cook Chamber's chamber_floor_z (DERIVED leg_h) — offset: down to ground
```

## PART B — BOM Subassembly Tree

```
BBQ Offset Smoker V2 (top assembly)
├── Cook Chamber
│   ├── Chamber shell (fixed 7-point profile: floor+left wall+left chamfer
│   │   +half ridge, wall_t hollow, TRUE octagon closure v2)
│   ├── Lid (ridge-hinged, full-length, 3 flat panels: half-ridge+chamfer
│   │   +wall — v2, replaces v1's end-hinged trunk lid)
│   │   ├── Lift handle rail (2 standoff posts) — DISABLED v2, stale v1 positions
│   │   ├── Toggle-clamp latches x2 (BUY, off-shelf placeholder) — DISABLED v2
│   │   ├── Dome thermometer (BUY, off-shelf placeholder) — DISABLED v2
│   │   └── Counterbalance lever + weight — DISABLED v2
│   ├── Grill grate (3 removable segments)
│   └── Floor drain valves x2 (BUY, off-shelf placeholder)
├── Firebox
│   ├── Firebox shell (4-wall hollow box, open both ends)
│   ├── Fire grate (welded bars)
│   ├── Ash tray (slide-out)
│   └── Firebox door (hinged, joggle-step joint)
│       └── Air-intake damper cutout
├── Exhaust Room (half-cylinder, welded to front end-cap) — v2, replaces v1's chimney/drop-tube
│   └── Chimney Pipe (coaxial, sits on the room's own top plate) — v2
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
| Lid | closed (`lid_open_deg=0`) | open (`lid_open_deg` up to 120, real CGAL-confirmed ceiling — stays clean well past that too, 120 chosen as a practical usable-design max, not a hard collision limit) | v2: ridge-hinged, full-length, rotate([deg,0,0]) about an X-axis line — replaces v1's end-hinged rotate([0,deg,0]) mechanism entirely |
| Firebox door | closed (`firebox_door_open_deg=0`) | open (up to ~110) | Continuous angle, unchanged from v1 (DO NOT TOUCH this session) |
| Ash tray | in (`ash_tray_out_pct=0`) | out (`ash_tray_out_pct=1`) | Full-out only physically valid with door open — same accepted door-dependency pattern as VM-02's `tray_out_pct`, not a bug. Unchanged from v1 |
| Chimney (fold) | REMOVED v2 | REMOVED v2 | v1's foldable chimney/drop-tube replaced by a fixed exhaust room + pipe (v2 TASK 2) — no fold mechanism in this version, flagged as a real scope change, not silently dropped |
| Prep shelves | deployed (`shelf_deployed=true`, horizontal) | stowed (`shelf_deployed=false`, vertical) | Discrete boolean, unchanged from v1 |

Static/removable parts (Grill grate segments, floor drain valves, toggle-
clamp latches) are NOT independently kinetic — they're removable/fixed
hardware, not hinged/sliding mechanisms, so they get a `show_*` isolation
toggle only (Toggle-Completeness Rule), not a dual-view kinetic state.

## Toggle-Completeness count (2026-07-14, v1.2)

BBQ-chambers-v2.scad ASSEMBLY: 8 modules called (`chamber_shell`, `lid`,
`lid_hardware`, `firebox`, `exhaust_room`, `chimney_pipe`, `grill_grate`,
`floor_drains`) — all 8 have a real `show_*` toggle from first commit/
carried over. 8/8 compliant. `show_lid_hardware` DEFAULTS FALSE this
version (stale v1 positions, not a Toggle-Completeness gap — the toggle
exists and works, it's just off by default per this session's explicit
instruction) — see PART_MANIFEST.md.

BBQ-understructure.scad ASSEMBLY: 4 modules called (`legs`, `casters`,
`tow_handle`, `prep_shelves`) — all 4 have a real `show_*` toggle from
first commit, unchanged this session. 4/4 compliant.

No safety-critical no-toggle exceptions needed this version (nothing in
this product blocks hand access the way VM-01/VM-02's drop-zone guards
do).
