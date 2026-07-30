# Tray Relocation Bracket + Folding Link — 2026-07-30

Fixes a real, confirmed collision: the prep trays' old hinge (`HINGE_Z`
= 880mm, derived from `NEW_SPLIT_Z-20`) put the deployed tray plate
(Z=[880,882]) inside the grab handle boss's own Z-range
(`t1`/`R1` → Z=[850.3,899.7]) — a genuine overlap, not a near-miss.

## Construction (Janis's own 5-step method, executed literally)

![Derived construction](tray-relocation-bracket.png)

> **H / face HA — confirmed by Janis:** the octagon has 8 vertices;
> running the alphabet around them (A, B, C...), the last one is **H**.
> **Face HA** is the face just before apex A going around — i.e. the
> existing chamfer wall directly below apex A
> (`H = [chamfer, chamber_floor_z]` = live `[178.665, 671.335]`). Matches
> what's built below exactly.

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
5. **Folding link** — corrected per Janis's own follow-up: the first
   pass fixed `tt` at "tray tip -20mm" and computed an approximate `ts`
   that landed 99.7mm short of `al`, which isn't tight enough for a real
   45° link. Flipped the construction: **`ts` = `al` itself** (the real,
   fixed anchor from step 1, not merely "close to" it), then the 45°
   line runs the OTHER way — from `al` back up to the tray's own
   underside (`HINGE_Z`=835.3mm) — to find `tt`. Result: `tt=[-185.3,
   835.3]`, well inside the tray's own real tip (deployed span reaches
   Y=-305.01mm), i.e. `tt` sits further inward from the tray's edge than
   the first pass, exactly as Janis called for.
   **Link length: tt-to-ts straight-line distance = 262.1mm** (this is
   the number to search the market for — the link itself isn't modeled
   as a real folding 2-bar mechanism here, since Janis's own ask was
   just the length, not the mechanism; when the tray folds to stowed
   vertical, this rigid `tt`-`ts` relationship no longer holds exactly —
   a real folding 2-bar link is needed there, per Janis's own note that
   it should collapse 50/50 and hide behind the tray's own face).

## Tray skirt

A 10mm skirt (`TRAY_SKIRT_H`) was added at the tray's own inner
(hinge-side) edge, folded 90° from the main plate and rigidly part of
the tray — per Janis's explicit ask, to cover the hinge from view (both
stowed and deployed, since it moves with the tray) and finish the raw
edge instead of leaving it sharp. Exact fold direction/placement wasn't
fully specified — cc's own judgment call, disclosed here, not silently
assumed.

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
