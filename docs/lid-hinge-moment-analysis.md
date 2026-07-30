# Lid Hinge Moment Analysis — 0° to 90°, current geometry (2026-07-30)

Real gravity moment about the shared pivot (`FC_Y`/`FC_Z` =
`HINGE_PIVOT_Y`/`HINGE_PIVOT_Z`, `BBQ-chambers-v26.scad`), computed from
the **current, live** geometry in `BBQ-offset-smoker-base-v12.scad` /
`BBQ-chambers-v26.scad` — not re-derived from an old assumption. This
supersedes `docs/lid-hinge-counterbalance-calc.md` (built on a retired
pivot and a retired CB1 counterweight-pipe design that no longer exists).

Method (`/tmp/.../scratchpad/moment_analysis.py`, real script, not hand
algebra):

1. Mass + center of gravity of the two shapes with real 2D profiles
   (rib+CB1 bracket, and the visual lid shell) were taken from an actual
   STL export of the live OpenSCAD geometry (`rib_solid(RIB1_X, true)`
   and `lid(0)`), volume/centroid computed by tetrahedron decomposition
   from the mesh triangles (`stl_mass.py`) — not a hand-derived polygon
   area, since the rib profile is a `difference()` of several unioned
   pieces and two bores, which is error-prone to reproduce by hand.
2. The handle rod's mass/CG is computed analytically (hollow tube + 2
   end caps) since it's a simple rotationally-symmetric shape centered
   exactly on `[HANDLE_Y, HANDLE_Z]`.
3. Steel density 7850 kg/m³ (mild steel, this project's own standard
   sheet-metal material per `rules-bbq-fab.md`).
4. For a rigid body rotating about a fixed pivot via
   `rotate([-door_open_deg,0,0])`, a point's native/closed-frame offset
   from the pivot `(dy,dz)` maps to world position
   `Y(θ) = FC_Y + dy·cosθ + dz·sinθ`. Summing `m·g·Y(θ)` over every
   rotating component gives the potential energy `PE(θ)`; the moment the
   user must apply in the opening direction is `dPE/dθ`, which reduces to
   a clean closed form:

   ```
   M(θ) = -g · (A·cosθ + B·sinθ)
   A = Σ mᵢ·dyᵢ   (kg·m, mass-weighted Y offset from pivot, closed frame)
   B = Σ mᵢ·dzᵢ   (kg·m, mass-weighted Z offset from pivot, closed frame)
   ```

   Sign convention matches Janis's own: **positive = user must lift/push
   to open (gravity favors closed)**, **negative = user must pull to
   close (gravity favors open)**.
5. Only the parts that actually rotate with the door are included: the
   visual lid shell, all 3 rib+CB1 assemblies, and the handle rod. The
   hinge brackets (`hinge_bracket()`) are fixed to the chamber and
   excluded — they never move.

## Live inputs (echo'd from the actual files, 2026-07-30)

| Component | mass (kg) | dy from pivot (mm) | dz from pivot (mm) |
|---|---:|---:|---:|
| Lid shell (3 panels, `lid(0)`) | 8.803 | -172.53 | -218.69 |
| 3× rib+CB1 bracket (`rib_solid(RIB1_X,true)`, ×3) | 3.481 | -109.82 | -69.10 |
| Handle rod (hollow tube + end caps) | 0.644 | -352.66 | -470.34 |
| **Total rotating mass** | **12.927** | | |

`FC_Y=242.665mm`, `FC_Z=1345.34mm`, `R_HANDLE=587.867mm` (pivot-to-handle
radius, used to convert torque into an equivalent hand force).

`A = -2.128 kg·m`, `B = -2.468 kg·m`.

## Result

| Angle | Moment | Equivalent force at handle |
|---|---:|---:|
| 0° (closed) | +20.9 N·m | **+3.6 kgf** (must lift to start opening) |
| ~45° | +31.9 N·m (peak) | +5.5 kgf |
| 90° (full open) | +24.2 N·m | **+4.2 kgf** (must still push/hold — never goes negative) |

Zero-crossing: **none** across the full 0-90° sweep — the moment stays
positive (closing-favored) at every angle, peaking around 45-50°.

![Moment vs. angle](lid-hinge-moment-analysis.png)

## Comparison against Janis's stated design intent

| Janis's requirement | Target | Computed | Verdict |
|---|---|---|---|
| Startup lift at 0° | 3-7 kgf to begin lifting | 3.6 kgf | **MEETS** |
| Zero moment at/after 45° | crosses to negative at 45° or later | never crosses zero | **FAILS** |
| Gentle negative before 90° (no slam shut) | negative before reaching 90° | stays positive all the way to 90° | **FAILS** |
| Self-holding at 90° (won't fall back closed) | ~5 kgf pull needed to bring it down | door is NOT self-holding — it takes +4.2 kgf of continued push just to keep it at 90°; release it and gravity swings it back toward CLOSED | **FAILS** |

**1 of 4 criteria met.** The root cause is structural, not a tuning
error: gravity's net moment stays same-signed (closing-favored) across
the whole sweep because `A` and `B` are both negative — the combined CG
of the lid+ribs+handle never crosses to the other side of "directly
below the pivot" as the door opens. A sign flip requires a real
counterbalancing mass whose own CG swings from one side of the pivot to
the other during the 0-90° travel (this is what the original, since-
retired CB1 counterweight *pipe* concept in
`docs/lid-hinge-counterbalance-calc.md` was for). The **current** CB1 is
a welded stopper/bracket only — it adds a small amount of mass near the
rib, but not enough leverage on the far side of the pivot to flip the
sign (confirmed by the numbers above: CB1's mass is already included in
the "3× rib+CB1 bracket" row and the moment still never goes negative).

**Bottom line:** the current door behaves like an ordinary gravity-
closed hatch — it needs a light, steady push the whole way from closed
to open (about 3.6-5.5 kgf), and it will swing itself shut if released
at any angle, including fully open. It will not slam on the way down
from a good push (peak resistance is mid-travel, ~45-50°, not right at
the end), but it also will not stay open on its own and does not need a
deliberate pull to close. Achieving Janis's full envelope (self-holding
open, needs a pull to close) needs a real counterweight mass added on
the correct side of the pivot — a follow-up design decision, not a code
bug in the current geometry.
