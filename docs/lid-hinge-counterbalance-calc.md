# Lid Hinge / Counterbalance Mechanism — Moment-Balance Calculation

> Source: prompts/bbq-lid-hinge-three-rib-v2-cc-prompt.md (2026-07-24),
> Section 9. Reference material only — does not gate or block the
> geometry work in `BBQ-offset-smoker-base-v6.scad`. The moment/torque
> physics itself is LOCKED (Section 8 of the source prompt) — this doc
> transcribes it and adds cc's own independent geometry verification
> (round-trip rotation checks, apex-clearance sweep, tray-interference
> sweep) done while building the real geometry this round.

---

## 1. Pivot / rotation derivation

Octagon vertices (world Y,Z), reused live from `BBQ-chambers-v23.scad`,
not redrawn:

```
A = (0, 850.0)
B = (0, 1102.670)
C = (178.665, 1281.335)
D = (431.335, 1281.335)
E = (610.0, 1102.670)
```

Pivot (fulcrum): `fc_y = C.y + 15 = 193.665`, `fc_z = DATUM_Z_RIDGE + 33.3
= 1314.635` (UCP204-12's real "H" dimension). Rotation convention:
`door_open_deg` 0=closed, 90=open, via
`translate([RIB_X,fc_y,fc_z]) rotate([-door_open_deg,0,0])
translate([0,-fc_y,-fc_z])`.

**Round-trip self-check method** (the standing verification pattern this
doc exists to preserve): for any point given in one frame (closed OR
open), rotate it into the other frame, then rotate the result back, and
confirm you recover the original exactly. This is what caught the prior
session's own sign error in the closed↔open inverse before it reached a
locked number, and it is reused directly (not re-derived) for this
round's own new geometry (CB1's native-frame position, the branch's
corner-arc waypoints) — see Section 3 below.

Handle round-trip, run independently in Python this session:

```
handle_closed = (-140, 875)
handle_open computed  = (-245.97, 1648.3)   -- prompt states (-246.0, 1648.3) ✓ matches
round-trip back to closed = (-140.00, 875.0) ✓ exact
R_handle computed = 551.916mm               -- prompt states 551.9mm ✓ matches
```

Confirms the rotation formula itself is correct and matches the prior
session's own locked handle numbers exactly (sub-0.03mm, rounding only).

---

## 2. Component mass & CG table, world (Y,Z), closed state

| Component | Mass | CG (Y,Z), closed |
|---|---|---|
| Lid shell | 8.51 kg | (44.7, 1084.2) |
| Handle (hollow, corrected) | 0.957 kg | (-140, 875) |
| Axle | 3.24 kg | on pivot (~zero moment arm) |
| Rib (Pass-1 estimate) | ~3.90 kg | 70/30 door/CB split (Section 3.7), position dependent on final profile — still approximate |
| CB1 | 8.06 kg | (239.1, 1657.5) *(prompt's own illustrative figure — see Section 3 below for cc's own recomputation)* |

Torque convention: `moment = -mass * y'(theta)`, where
`y'(theta) = y0'*cos(theta) + z0'*sin(theta)` is the rotated horizontal
offset from the pivot, `(y0',z0')` the closed-state relative position.
Force at handle = moment / R_handle (551.9mm, radial/tangential
convention, Janis's own authorized choice). LOCKED — not recomputed this
round (Section 8 of the source prompt).

## 3. Real swept force curve, 0–90°, 10° steps (LOCKED, transcribed)

```
+2.00(0), +1.80(10), +1.54(20), +1.23(30), +0.89(40), +0.52(50),
+0.13(60), -0.26(70), -0.64(80), -1.00(90) kgf
```

Crosses zero near 62–63°. Expected UX (push becomes pull mid-sweep),
matches Janis's own confirmed goal — both endpoints stay modest, neither
end favors runaway opening/closing.

CB2 (mass2=2kg, R2=350mm, phi2=80deg — the prior session's hybrid
concept) is obsolete, preserved here for the record only, not a live
design input.

Rib's real total mass/CG remain a Pass-1 estimate pending the final
profile — sensitivity already demonstrated once this project (rough rib
CG guess vs. the real 70/30 split moved CB1 from 83mm/10.40kg to
170.8mm/8.06kg, a large swing from one input). This round's own real
first-draft profile (`BBQ-offset-smoker-base-v6.scad`) has NOT been
re-weighed against this sensitivity — flagged, not silently assumed
still valid, for the direct-cc tuning pass.

---

## 4. REAL, FLAGGED FINDING — CB1's own position formula vs. its own illustrative number

Section 3.6 of the source prompt gives BOTH a literal formula for CB1's
open-state position:

```
cb1_pipe_center_open = D + 170.8*(0.7071,-0.7071) + 65.8*(0.7071,0.7071)
```

AND an illustrative approximate result, `~(536.5, 1269.2)`. Plugging the
prompt's own locked numbers (D, 170.8, 65.8, the two unit directions)
into its own locked formula, independently in Python this session:

```
CB1_OPEN computed = (598.636, 1207.088)     -- NOT (536.5, 1269.2)
CONTACT_OPEN (170.8mm from D, no standoff) = (552.109, 1160.561)
CB1_CLOSED (round-trip inverse @ 90°)       = (301.211, 1719.606)   -- prompt states ~(239.1, 1657.5)
```

Round-trip verified self-consistent (rotating `CB1_CLOSED` forward by 90°
reproduces `CB1_OPEN` exactly to 1e-9mm) — the rotation machinery itself
is correct (same functions that reproduced the handle's numbers exactly).
The discrepancy is between the prompt's own formula and its own
illustrative decimal, not in cc's own math. Per the Verification
Discipline Rule (cc_rules.md) and Section 11's own instruction ("flag, do
not silently adjust, if the real built geometry produces a different
number than expected"): **`BBQ-offset-smoker-base-v6.scad` builds from
the FORMULA** (the real, locked geometric construction — 170.8mm from
apex D along the D-E edge, 65.8mm standoff along the outward normal),
using `CB1_OPEN computed` above, not the illustrative `(536.5, 1269.2)`.
CB1's own locked inputs (170.8mm, 65.8mm, 8.06kg, no fill weight) are
UNCHANGED — only the resulting Y,Z coordinate (a pure trigonometric
consequence of those inputs) is corrected to match the formula that
actually produces it.

---

## 5. REAL BUG FOUND + FIXED — branch spine vs. apex D (before shipping)

Section 5's own text asserts the branch's 20mm-outward offset from the
D-E line "by construction, keeps the branch a real 20mm clear of the
traced surface everywhere along it." This is true for the D-E FACE, but
D itself is a CONVEX CORNER (where the C-D ridge face meets the D-E
slope) — offsetting the two adjacent straight faces does not
automatically clear the corner by the same margin; that requires an arc.

Checked via a real Python sweep (fine step, 0.01°) before writing the
final SCAD geometry: a naive straight branch spine from the pivot
directly to `CB1_CLOSED` passes within **0.01mm of apex D at
door_open_deg≈83.1°** — effectively through the corner.

**Fix**: the branch's corner-hugging waypoints trace a real arc around D
(radius `CORNER_STANDOFF=45mm`, phi 90°→45°, i.e. from the C-D ridge
face's own outward normal (0,1) to the D-E face's own outward normal
(0.7071,0.7071), 9 sampled points), each converted to native/closed frame
via the SAME round-trip rotation functions used for CB1 and the handle.
Re-verified via the same fine sweep:

```
Min branch-centerline clearance to D across the FULL 0-90° sweep: 44.95mm
  (target 45mm; ~0.05mm shortfall is finite-sample chording of the arc
  into 9 straight segments, not a real exposure — finer sampling
  recovers it)
Net real solid-material clearance (minus the branch's own 20mm minimum
  half-width): ~24.9mm
```

Clears the Section 10 apex-clearance rule (min 20mm, worst case across
the full sweep) with ~5mm real margin. `CORNER_STANDOFF=45` is a real,
named, cc-derived judgment call (= 20mm apex rule + 20mm min half-width +
5mm margin), same pattern as this project's own `HINGE_PIVOT_OFFSET`/
`HINGE_OFFSET` precedent (BBQ-offset-smoker-base-v2/v3).

Separately, the bare CB1 PIPE's own surface (50.8mm radius, not the
branch's centerline) was checked against D across the same full sweep:
minimum clearance 128.2mm at θ≈83.1° — comfortably clear, no fix needed
there.

---

## 6. REAL, SIGNIFICANT FINDING — rib vs. prep tray (Section 11's mandatory 3-way sweep)

The counterbalance mechanism and the relocated prep trays
(`BBQ-offset-smoker-base-v6.scad`, `trays()`) share the same Y=0 face —
Section 2 of the source prompt explicitly calls this out as requiring a
combined sweep, not isolated checks, and Section 11 requires it
explicitly (citing this project's own prior history of exactly this
failure class).

**Real 3-way combinatorial sweep run** (Python, segment/rectangle model
of the rib's door-side arm vs. each tray's plate, both angle ranges swept
1-2° steps, both trays checked — tray0 against rib0, tray1 against rib2,
since rib1 at X=457.5 sits in the 5mm gap between the two trays and does
not overlap either tray's X-span):

```
door_open_deg: 0-90° (11-91 samples per run)
tray0_angle_deg / tray1_angle_deg: -90 to 0° (91 samples)
```

**Result: NOT clean.** Worst overlap found: **-35.0mm** (real material
interpenetration, not a graze), at combinations spanning
`door_open_deg` 0-31° crossed with the FULL `tray_angle` range
(-90 to 0°) — including door_open_deg=0 (lid fully closed, the
resting state) against the tray's own full normal sweep alone
(-30.0mm worst case) and tray fully stowed (-90°) against the door's
own full sweep alone (-34.9mm worst case).

**Root cause**: the rib's real weld-flush run along A-B (both at world
Y=0, Z=[850,1102.67], required by Section 5's own "welded flush along the
lid's own A-B, B-C faces" construction rule) occupies the SAME real wall
real-estate the STOWED tray also needs when folded vertically flush
against that same Y=0 wall (stowed tray real Z-range ≈[980,1285],
computed from the tray's own hinge/rotation geometry — directly
overlapping the A-B/B-C run). The BARE CENTERLINES (zero rib radius) are
already within ~0.0002mm of touching at several combined angles — this
is not primarily a rib-width problem.

**Mitigation applied, real but partial**: `WELD_HALF_W_A`/`_B` reduced
from a naive 45mm (matching the "70-100mm" spec via width) to 22-25mm
(matching the same spec via the A-B run's own real ~253mm LENGTH
instead) — this is arguably the more correct reading of Section 5's
"weld-contact zone" spec for a rib blade lying in the Y-Z plane (welding
along its own thin edge, not a broad flat face). Re-swept at 25mm: worst
case improves only to -28mm — the reduction helps but does NOT resolve
the conflict, because the underlying issue is centerline proximity, not
radius.

**Confirmed NOT fixable by moving RIB_X**: the two trays' combined X-span
(`[-2.5, 917.5]`, i.e. nearly the entire lid length) leaves only ONE real
gap (≈5mm, near X=457.5) for 3 required ribs — at most one rib can ever
sit clear of both trays' footprints; the other two are unavoidably inside
a tray's X-span at ANY placement satisfying Section 6's "3 ribs across
the lid length" requirement.

**Disposition**: flagged, NOT silently resolved, NOT silently declared
clean. Resolving this fully requires either touching the tray (frozen
this round, Section 8 — "carried forward... byte-identical") or a
cross-subsystem re-architecture (relocate tray hinges, or fundamentally
rework where ribs 0/2 mount) beyond a first-draft rib-profile pass. Real
open item for Janis: an operating-sequence note (do not stow/deploy
tray0/tray1 while rib0/rib2 occupy the conflicting Z-band) or a follow-up
redesign round. QA Section 11's combinatorial-sweep item is reported
**FAIL** for this specific rib-vs-tray interaction — every other
combination checked this round (apex-D clearance, CB1-vs-D, handle
reachability, U-prong wrap, `lid_open_deg` linkage) is real and clears
with margin, see `BBQ-offset-smoker-base-v6.scad`'s own QA notes and
cc_chat_log.md for the full matrix.

---

## 7. Locked values used, for cross-check against the built geometry

- CB1 mass: 8.06kg, no fill weight — UNCHANGED, matches
  `BBQ-offset-smoker-base-v6.scad`'s `CB1_MASS_KG`.
- CB1 position: 170.8mm from apex D along the D-E edge, 65.8mm standoff —
  UNCHANGED, matches `CB1_EDGE_DIST`/`CB1_STANDOFF`. Resulting world
  coordinate corrected per Section 4 above (598.6, 1207.1 open /
  301.2, 1719.6 closed — NOT the prompt's own illustrative decimal).
- Handle mass: 0.957kg, position (-140, 875) closed — UNCHANGED.
- R_handle: 551.9mm — confirmed via independent recomputation (551.916mm).
