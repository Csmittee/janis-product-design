# Tray Relocation Bracket + Folding Link — 2026-07-30

Fixes a real, confirmed collision: the prep trays' old hinge (`HINGE_Z`
= 880mm, derived from `NEW_SPLIT_Z-20`) put the deployed tray plate
(Z=[880,882]) inside the grab handle boss's own Z-range
(`t1`/`R1` → Z=[850.3,899.7]) — a genuine overlap, not a near-miss.

## Construction (Janis's own 5-step method, executed literally)

![Derived construction](tray-relocation-bracket.png)

> **Flagged interpretation, not previously an established term:**
> "face HA" doesn't appear anywhere else in this project. cc's reading —
> forced by step 2's own wording, since "a horizontal line from face HA
> to connect with al" only makes sense if apex A does *not* itself sit
> on face HA — is that **H** is the existing octagon corner where the
> chamber floor meets the 45° chamfer wall directly below apex A
> (`[chamfer, chamber_floor_z]` = live `[178.665, 671.335]`), and **face
> HA** is that diagonal chamfer wall. This reading is what's built below.
> Flagged for Janis to correct if wrong — everything downstream follows
> from this one assumption.

1. **al** = straight line down from apex A, 200mm in Z: `[0, 650]`
   (`TRAY_AL`).
2. **hal** = face HA's own line (apex A → H), extended to al's own Z:
   `[200, 650]` (`TRAY_HAL`) — forms the right triangle apex A / hal / al
   exactly as described.
3. **Bracket** = that triangle (`TRAY_BRACKET_OUTLINE`), extruded
   `TRAY_BRACKET_W`=30mm wide (`HINGE_W`+10mm margin, a real judgment
   call — no exact width given). New module `tray_bracket(x_center)`,
   4 copies (one per existing hinge X position — same spacing as the
   original design, per Janis's own summary).
4. **New hinge/tray Z** = lowest point of `t1` (handle boss, real
   radius `R1` included) minus 15mm = `850.3 - 15 = 835.3mm`. This
   **redefines** `HINGE_Z` (old value retired, not left as dead code) —
   `tray_hinge()`/`tray()` need no other change, since they already just
   read the global `HINGE_Z`. Real clearance confirmed: new tray plate
   top surface (837.3mm) sits 13mm clear of the handle boss's own lowest
   point (850.3mm) — was previously fully inside it.
5. **Folding link**: tray tip inset 20mm in Y (`tt`), 45° line from `tt`
   to the apex-A/al plane (Y=0) — lands at `ts=[0, 550.3]` (99.7mm from
   `al`, in the same below-floor region — Janis's own "sweet spot,"
   flagged as approximate per Janis's own "try...to find" phrasing).
   **Link length: tt-to-ts straight-line distance = 403.1mm** (this is
   the number to search the market for — the link itself isn't modeled
   as a real folding 2-bar mechanism here, since Janis's own ask was
   just the length, not the mechanism).

## Verification

- Full `--render` CGAL `Simple: yes`, no warnings, at `door_open_deg`
  0/45/90° and tray angles -90°(stowed)/0°(deployed).
- Real interference sweep (`intersection(trays(), front_wheel_support())`)
  at tray angles -90/-60/-30/0°: **empty at every angle** — no new
  collision introduced by moving the tray/hinge down 44.7mm.
- Bracket X positions (87.5/365/550/827.5) never overlap any rib X
  position (200/457.5/715) even accounting for real part thickness — the
  tray/bracket system is geometrically independent of the rib assembly,
  confirmed by direct interval check, not assumed.
