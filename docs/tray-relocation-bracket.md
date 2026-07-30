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

1. **hal** = apex H itself, `[178.665, 671.335]` (`TRAY_HAL`) — **real
   fix, Janis's own direct catch**: the first pass drew "al" as a plain
   200mm straight drop from apex A, which overshot past apex H's own
   real Z (671.335) — landing 21.3mm past the real wall's own physical
   end, floating in open air, not on real face-HA material. `hal`
   cannot float past the real wall — it IS the wall's own end.
2. **al** = same Z as `hal`/H, on the apex-A/al vertical line:
   `[0, 671.335]` (`TRAY_AL`) — derived FROM `hal` now, not the other
   way around. The real drop from apex A is 178.665mm (exactly
   `chamfer`, a consequence of face HA's own 45° geometry, not the
   original 200mm guess) — forms the right triangle apex A / hal / al
   exactly as described, with its diagonal edge (apex A → hal) now
   lying entirely on real physical wall material for its full length.
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
   that didn't land tightly on `al`. Flipped the construction: **`ts` =
   `al` itself** (the real, fixed anchor, not merely "close to" it),
   then the 45° line runs the OTHER way — from `al` back up to the
   tray's own underside (`HINGE_Z`=835.3mm) — to find `tt`. Result (live
   values, current `al`=`[0,671.335]`): `tt_raw=[-163.965, 835.3]`, well
   inside the tray's own real tip (deployed span reaches Y=-321mm from
   v15's own `TRAY_MOUNT_GAP`-adjusted mount), i.e. `tt` sits well
   inward from the tray's edge, exactly as Janis called for.
   **Real working span (ts to tt, before the v15 clearance offset):
   221.5mm.**

**Real, disclosed kinematic finding, checked in Python before modeling
(not assumed)**: a genuine 2-bar pin-jointed link of fixed total length
can only close the gap between `ts` (fixed at `al`) and the tray's own
`tt` at angles where their real distance is ≤ the link's own length.
Checked via real circle-circle intersection across the full stow sweep
(`tray0_angle_deg` -90°..0°): the `ts`-to-`tt` distance is exactly the
link length at deployed (0°, fully straight) but **grows** well past it
as the tray folds toward stowed (-90°) — `ts` sits low (near apex H,
well below the tray's own hinge Z), so `tt` swings AWAY from it, not
toward it, as the tray folds up. A fixed-length rigid link genuinely
cannot follow the tray through the full stow range from this anchor —
matches why real hardware for this exact job (a folding shelf/table
stay) commonly uses a **slotted**, not a fixed, pivot at one end —
Janis's own explicit call, confirmed: `ts` is a conceptual slider along
the apex-A/al face, no rail modeled (real hardware handles this the
same way). The link is modeled at its deployed reference position only.

## Real hardware model (v15, per Janis's detailed spec after reviewing a render)

- **Flat steel strip**, not a round rod: `TRAY_LINK_W`=15mm wide,
  `TRAY_LINK_T`=3mm thick (both real judgment calls, no exact numbers
  given), built the same way as `tray_bracket()` (a 2D profile in the
  Y-Z plane, extruded thin along X).
- **Real lap overlap at the middle pivot**: two links of a fixed total
  length meeting at a single point isn't how a real folding link works
  — each half now overlaps the other by `TRAY_LINK_OVERLAP`=10mm at the
  middle, so each link's own real length is
  `(ts-to-tt span + overlap) / 2`, not simply half the span. The pivot
  pin sits centered in that 10mm overlap.
- **`tt` pulled clear of the tray surface**: the raw 45°-derived point
  landed exactly ON the tray's own underside (a real, visible
  penetration in the v14 render — Janis's own direct catch).
  `TRAY_LINK_CLEARANCE`=15mm now pulls the real pin point below the
  tray surface; the U-hinge below bridges the remaining gap up to the
  tray itself.
- **U-shaped hinge + pin at BOTH ends** (`hinge_u()`): a simple
  rectangle with a square notch (not a fabrication-precise clevis/fork —
  Janis's own explicit call, "just represent with a simple U shape and
  lock by a pin is ok") plus a real pin cylinder, at `ts` AND at `tt`.
  A third, single pin marks the middle lap joint.
- **`TRAY_MOUNT_GAP`=16mm** (`HINGE_OUT`-`HINGE_PIVOT_OFFSET`): real
  fix, Janis's own direct catch — the tray plate was still mounted
  flush with the pivot line, overlapping the (already-widened)
  `HINGE_OUT` hinge block by this same amount, so widening the hinge
  alone never actually created a real gap for the folded link to hide
  behind. The tray plate's own inner edge (and its skirt) now starts
  flush with the hinge block's own outer tip, leaving the hinge
  block's full depth open behind the tray.

## v16 wiring — link now genuinely responds to tray angle

Janis's own direct catch, after reviewing the v15 render: "when i turn
tray degree, look like the link doesnt link to the the degree turn yet,
you got to wire it, thats it!" v15's `tray_link()` was real geometry but
**static** — always drawn at its deployed (0°) reference position,
regardless of `tray0_angle_deg`/`tray1_angle_deg`. Fixed in v16:

- **`tt`** is rigidly part of the tray (its real pin, bolted to the
  tray's underside) — `tray_link_tt(angle_deg)` now rotates the deployed
  reference point about the tray's own real pivot
  (`Y=-HINGE_PIVOT_OFFSET, Z=HINGE_Z`), the exact same rotation the tray
  plate itself gets.
- **`ts`** is NOT rigid with the tray — it's the real slider. For any
  rotated `tt`, `tray_link_ts(angle_deg)` solves the point on the fixed
  apex-A/al line (`Y=0`) a constant `TRAY_LINK_SPAN` away — a genuine
  circle(center=`tt`, r=`TRAY_LINK_SPAN`) vs. line(`Y=0`) intersection,
  not an approximation. Two roots exist; validated in Python before
  writing any OpenSCAD (not assumed): the **lower** root (`tz - h`) stays
  on the real `[TRAY_AL.z=671.335, RIB_REF_A.z=850]` segment across the
  full `0..-90°` sweep (671.335mm at 0°, exactly matching the old fixed
  `al` — confirms the formula's correctness at the reference config —
  rising smoothly to ~773.64mm at -90°); the **upper** root (969–1215mm)
  sits above apex A entirely, off the real segment, and is discarded.
- `tray_link()` calls moved out of `tray_hinges(x0)` (no angle available
  there) into `tray(x0, angle_deg)` directly, so both tray0 and tray1
  drive their own link independently.

**Re-verified** via a real isolated `intersection()` probe (link vs. the
tray plate alone, chamber/firebox/exhaust geometry suppressed so the
probe is unambiguous), not assumed clean from the code:

| tray angle | tray0 link | tray1 link |
|---|---|---|
| 0° to -82° | empty (no collision) | empty (no collision) |
| -83° to -90° | **real, small collision** | **real, small collision** |

**New, disclosed finding, NOT fixed this round** — this is a geometric
tightness issue, not a wiring bug. At full -90° stow, the folded plate's
own near face always lands at exactly
`Y = -HINGE_PIVOT_OFFSET + TRAY_T` (real rotation math, true regardless
of any other constant) — with the live numbers that's `Y=-3mm`, only 3mm
clear of the fixed `Y=0` slider line the link has to thread through. A
flat 15mm-wide strip with no real slot/rail modeled (Janis's own
explicit simplification) can't always clear that 3mm gap in the last
~7-8° of fold. Tried widening `HINGE_PIVOT_OFFSET` (5mm→15mm) as a fix —
made the overlap **worse** at the same angle, since it shifts both the
folded plate AND the rotating `tt` pin together, not a simple
1-parameter fix. Confirmed the same ~-83° threshold on both tray0 and
tray1 (symmetric, not a per-tray bug). Needs a decision: either treat
-85° as the practical fully-folded operating limit (zero-cost, a
usage/firmware constraint) or design a real notch/slot in the wall face
at this location (a fab step, out of scope here).

## Tray skirt

A 10mm skirt (`TRAY_SKIRT_H`) runs along the tray's own **tip and both
left/right side edges** — folded 90° from the main plate and rigidly
part of the tray. **Real fix**: the first pass put the skirt on the
hinge-side edge instead, where it visibly sank into the hinge block —
Janis's own direct catch from a render (no manifold error, since it's
just overlapping solid material, not a self-intersection, but a real
visible design defect). The hinge side now has zero skirt, on purpose.

## Verification

- Full `--render` CGAL `Simple: yes`, no warnings, at `door_open_deg`
  0/45/90° and a tray angle sweep (0/-30/-45/-60/-90°), both trays
  independently — re-verified after every round of fixes, including the
  v16 angle-wiring fix.
- Real interference sweep (`intersection(trays(), front_wheel_support())`)
  at tray angles -90/-60/-30/0°: **empty at every angle**.
- Real collision check (`intersection(tray_link(), <tray plate>)`) swept
  across angles (both trays): **empty from 0° to about -82°**; a real,
  disclosed collision from about -83° to -90° — see "v16 wiring" above,
  not fixed this round, flagged for a decision.
- The link's `ts`-side U-hinge DOES touch `tray_bracket()`'s own solid
  material — intentional (that's the real attachment/slider point, not
  a defect); the link's own free length extends well clear of the
  bracket beyond that.
- Bracket X positions (87.5/365/550/827.5) never overlap any rib X
  position (200/457.5/715) even accounting for real part thickness — the
  tray/bracket system is geometrically independent of the rib assembly,
  confirmed by direct interval check, not assumed.
