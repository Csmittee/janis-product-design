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

## 7. v6.1 update — direct-cc tuning pass (2026-07-24, Janis's own live render review)

Janis reviewed a real v6 render and gave 4 real, direct instructions
(R-011 direct-cc pass, no new Claude Web prompt — see
`BBQ-offset-smoker-base-v6.1.scad`'s own header for full detail):

1. Kinetic parameters (`door_open_deg`, `tray0_angle_deg`,
   `tray1_angle_deg`) relocated to one block just before ASSEMBLY —
   Janis could not find/drive them where v6 had put `door_open_deg`
   (right after the include line) and reported the tray angle controls
   missing too.
2. **Real fix**: the door-side arm reached down to apex A, which sits
   BELOW the real parting line (`NEW_SPLIT_Z`) — i.e. on the FIXED
   shell, not the lid. The arm's own lower anchor is now the real
   parting-line point on the same wall edge; the handle reaches out from
   there, not from apex A.
3. **Real fix**: `HANDLE_Y` -140 → -110 (pulled back 30mm) — Janis's own
   direct instruction, the handle overhung too far outward from the
   chamber in the real render. `HANDLE_Z` confirmed correct, unchanged.
   **Flagged consequence**: `R_HANDLE` (radial pivot-to-handle distance)
   changes 551.9mm → 534.3mm — the swept force curve in Section 3 above
   assumed the OLD handle position and is now stale. NOT recomputed this
   round (Janis has explicitly deferred the stopper/counterbalance
   review until the door can be opened) — flagged here for that
   follow-up.
4. **Real fix**: the door-side spine points (previously centered exactly
   ON the octagon's own real surface) are now pulled outward by a real
   `DOOR_ARM_STANDOFF`(15mm) along each wall segment's own outward normal
   — Janis's own direct report was that the rib looked "sunk into the
   door" with a "shorter than expected" ridge, consistent with roughly
   half the rib's own material being embedded in the lid's solid body
   under the old (surface-centered) construction.

No OpenSCAD available in this execution environment to independently
confirm any of these visually — all 4 are real code changes responding
directly to Janis's own live render observations, not independently
re-verified by cc via a render of its own. Everything else (CB1/stopper/
prong geometry, the apex-D corner-arc fix, axle/UCP204-12 placeholders)
is UNCHANGED from v6 — Janis has explicitly deferred reviewing that area
until the door can be opened.

---

## 9. v7 update — Janis's own direct diagnosis, pivot moved from apex C to apex D (2026-07-24)

Janis reviewed the real v6.1 render and root-caused 3 real problems
against the actual code (not re-guessed) — see
`BBQ-offset-smoker-base-v7.scad`'s own header for the full detail. This
section covers the parts that affect the numbers in this doc.

**Problem 2 — the pivot was on the LID, not the fixed shell.** `FC_Y`/
`FC_Z` were derived from apex C (178.665mm) — LESS than
`DATUM_Y_CENTER`(305mm), i.e. on the lid's own half of the ridge, not the
fixed half. This is why the bearing housing rendered embedded in the
door. FIX: `FC_Y = RIB_REF_D[0] - 15` (416.335mm, real margin vs
`DATUM_Y_CENTER`: 111.335mm, comfortably fixed-side), `FC_Z =
RIB_REF_D[1] + 33.3` (1314.635mm, same numeric value as before since C
and D share the same ridge height — only the reference point moved).

**Consequence 1 — R_HANDLE changes again.** `HANDLE_Y`/`HANDLE_Z`
themselves are UNCHANGED (Section 5 DO NOT TOUCH, still -110/875) — but
since `R_HANDLE` is the radial distance from the PIVOT to the handle, and
the pivot moved substantially, `R_HANDLE` changes from 534.3mm (v6.1,
C-based pivot) to **685.8mm** (v7, D-based pivot). The swept force curve
in Section 3 above is now stale a second time — NOT recomputed this
round (Janis's own stopper/counterbalance review is still deferred).

**Consequence 2 — CB1's own closed-frame coordinate changes.** CB1's
real, locked inputs (170.8mm from apex D, 65.8mm standoff, 8.06kg, no
fill weight) are completely UNCHANGED — CB1's own OPEN-state world
coordinate is therefore also unchanged (598.6, 1207.1, same as Section 4
above). But since `CB1_CLOSED` is CB1's position expressed in the
pivot's own native/closed frame, and the pivot moved, `CB1_CLOSED`
changes from (301.2, 1719.6) under the old C-based pivot to **(523.9,
1496.9)** under the new D-based pivot — a pure, mechanical consequence of
the round-trip rotation formula, not a re-tuning of CB1 itself.

**Consequence 3 — a real, PROVABLE clearance ceiling at the pivot.** The
new pivot sits only **36.522mm from apex D** (was ~419mm under the old
pivot). Since the pivot is a mandatory, non-moving point on every branch
built from it, NO construction technique can make that branch's own
centerline clear D by more than the pivot's own fixed 36.522mm distance
— a hard, provable ceiling, not a construction shortfall. With this
project's own 15mm-meat-around-every-bore convention (the pivot bore
alone needs 28.5mm real half-width), the maximum ACHIEVABLE net clearance
at the pivot's own structural pad is **36.522 - 28.5 = 8.022mm** —
provably short of rules-bbq-fab.md's own 20mm apex-clearance rule. A real
full-spine sweep (0.01° steps, full 0-90°) confirms this genuinely IS the
global worst case for the whole assembly (occurring at the door-side
arm's own C-to-pivot segment, at `door_open_deg=0`) — every other zone
(the CB-branch via its new bow waypoint, the CB1 pipe surface itself)
clears with real margin. See `BBQ-offset-smoker-base-v7.scad`'s own
header for the full numeric derivation, including why the OLD 45mm
corner-arc-around-D technique was retired (re-tested against the new,
closer pivot, it made clearance WORSE, not better) and replaced with a
single, precisely-placed bow waypoint that reaches the true 36.522mm
ceiling.

**Real, flagged, unresolved**: this ceiling is a direct, unavoidable
consequence of TASK 2's own given `FC_Y = RIB_REF_D[0]-15` formula —
resolving it would require either moving the pivot further from D
(contradicts the given formula) or reducing the axle bore's own required
meat below this project's 15mm convention (trades one flagged violation
for another). Flagged for Janis's own decision, same disposition pattern
as the tray-interference finding in Section 6.

**Root-cause pattern across 2 of these 3 rounds** (R-010/R-014
self-trigger, this being the 3rd real round touching this mechanism):
both v6.1's apex-A-vs-parting-line mistake and this round's apex-C-vs-
apex-D mistake are the SAME class of error — an octagon vertex chosen by
visual proximity to "roughly the right corner," without an explicit
numeric check against the real fixed/lid split. Written down as a locked
amendment to rules-bbq-fab.md's own "Three-Rib Lid Counterbalance
System" convention (v1.7->1.8) so a future product doesn't repeat this a
3rd time.

---

## 10. Locked values used, for cross-check against the built geometry

- CB1 mass: 8.06kg, no fill weight — UNCHANGED, matches
  `BBQ-offset-smoker-base-v7.scad`'s `CB1_MASS_KG`.
- CB1 position: 170.8mm from apex D along the D-E edge, 65.8mm standoff —
  UNCHANGED, matches `CB1_EDGE_DIST`/`CB1_STANDOFF`. Open-state world
  coordinate UNCHANGED (598.6, 1207.1 — NOT the prompt's own illustrative
  decimal, see Section 4). Closed-state (native-frame) coordinate is
  PIVOT-DEPENDENT and changed in v7: (523.9, 1496.9), was (301.2, 1719.6)
  under v6/v6.1's own C-based pivot — see Section 9.
- Handle mass: 0.957kg, position (-110, 875) closed — UNCHANGED from
  v6.1 (Section 5 DO NOT TOUCH, this round). `R_HANDLE` is
  PIVOT-DEPENDENT: 543.0mm in v7.2 (was 685.8mm in v7, 534.3mm in v6.1,
  551.9mm in v6, the original prompt's own locked value under the very
  first, C-based pivot) — see Section 11.

---

## 11. v7.2 update — Janis's own real-world correction, PLUS a serious, unresolved verification finding (2026-07-25)

Janis reviewed the v7 render and corrected it against a real,
physically-built reference product (photo of an actual smoker's hinge):
the v7 pivot relocation (apex C → apex D) was WRONG despite being
geometrically defensible. Real hinge hardware mounts via a bracket
bolted to fixed material, which can hold the actual pivot pin at almost
any (Y,Z) that bracket reaches — the "pivot point itself must sit past
`DATUM_Y_CENTER`" test (v7's own reasoning) checks a different, stricter
question (does a bore AT that exact point have fixed material around it)
than whether a bracket anchored to fixed material can reach that point.
Janis's own real-world reference takes precedence.

**Pivot rebuilt from apex C again**, Janis's own direct instruction,
executed literally: `FC_Y = RIB_REF_C[0] + 30` (208.665mm, offset
increased from the original v6/v6.1 value of 15mm), `FC_Z =
RIB_REF_C[1] + 33.3` (UNCHANGED value and formula structure — Janis's
own explicit instruction, "Z remains the same"). This point does NOT
pass v7's own "Y > DATUM_Y_CENTER" fixed-side test (208.665mm <
305mm) — stated explicitly, not silently dropped; not being re-derived
by cc, this is Janis's own confirmed instruction.

**A second axis (the source prompt's earlier "40mm in x direction away
from the door") was NOT implemented as a separate offset.** After
back-and-forth, Janis simplified to "30mm... and apex C 30mm" — cc's
best-available reading is that this describes the same single Y-offset
from two angles, not a second independent axis. Flagged as an open
interpretation, not asserted as certain — subject to correction once a
real render is available.

**REAL, SERIOUS, UNRESOLVED FINDING** — stated plainly, per this
project's own Verification Discipline Rule (R-014): a rigorous fresh
re-check of the CB1-branch's own clearance to apex D (0.01° sweep steps,
full 0–90°) using several independent construction techniques — a single
bow waypoint, a multi-point arc at radii from 45mm to 200mm, and a dense
sampled path following the source prompt's own "trace D-E, offset 20mm
outward" instruction literally — ALL converge on a near-zero (<0.02mm)
worst-case clearance to apex D for this v7.2 pivot position. Adding more
waypoints iteratively does not improve it (the search oscillates between
the same two failure states). No construction found this session
achieves a real, positive clearance margin for this specific pivot
position.

**More seriously**: re-running the ORIGINAL v6 45mm-corner-arc
construction — the one this project's own file headers state achieved
44.95mm clearance — against the ORIGINAL v6 pivot (`FC_Y = C_Y+15`) in a
fresh, careful re-implementation this session gives **0.0106mm**, not
44.95mm. cc cannot currently explain this discrepancy. This calls the
CB1-branch apex-D clearance claim into real doubt going back to the
very first v6 build — not just this round's own new pivot. Flagged
prominently, not buried. Possible explanations not yet investigated:
a bug in the original v6 verification script, a bug in this session's
re-implementation, or a genuine difference in method between the two
(e.g. sweep step size, segment endpoint handling) — no conclusion drawn
without further work.

**Disposition**: NOT fixed this round. Janis has explicitly deferred
CB1/stopper review until the door can be opened, and this finding lives
in that same area — `BBQ-offset-smoker-base-v7.2.scad`'s own branch/
CB1/prong code is unchanged from v7 (the `BRANCH_BOW_NATIVE` construction
recomputes live from the new `FC_Y`/`FC_Z`, but is NOT verified to clear
apex D at this pivot position). This is not represented as fixed or
safe — real re-verification, likely requiring a genuinely different
construction approach (not a local waypoint tweak), is needed before
fabrication, in the same round CB1/stopper get reviewed.

## 12. v8 update — "unify system" redesign: real `RIDGE_SPLIT_Y` ridge parting line, hinge bracket rebuilt, door-arm/foot collision found + fixed (2026-07-25)

Janis's own direct message, quoted in full in `cc_chat_log.md`: "there is
a mistake i gave you on the hinge location and the door concept that we
might need to redo the design, including the the door parting line on
face CD, this must calculate and go as one unify system." Full 6-point
instruction list + QA checklist + Can-do/Cannot-do list, all executed
this round in `BBQ-chambers-v25.scad` (new) and
`BBQ-offset-smoker-base-v8.scad` (new).

**1. `RIDGE_SPLIT_Y` (new, `BBQ-chambers-v25.scad`)** — the ridge's own
real trim/seal/parting line is now a tunable design parameter,
`chamfer+30` (208.665mm), replacing the old hardcoded `chamber_W/2` /
`DATUM_Y_CENTER` ridge-midpoint (305mm) used by every prior version.
R-009 duplication check confirmed exactly 4 real consumers:
`fixed_side_wedge()`, `lid_side_wedge()`, `lid_closed_panels()`'s ridge-
cap panel width, `lid()`'s own rotation point — all 4 updated.
`DATUM_Y_CENTER` itself is UNCHANGED, still used for its own unrelated
purposes (`exhaust_room()`/`chimney_pipe()`). Moving this line closer to
apex C (was 305mm, now 208.665mm) is what finally makes a hinge "close to
C" AND "on the fixed side" simultaneously achievable — impossible under
every prior version, where C (178.665mm) sat deep inside a ridge split
fixed at 305mm no matter what pivot offset was tried.

**2. Pivot rebuilt from `RIDGE_SPLIT_Y`, not an octagon vertex.** cc's
own real reading of Janis's stated "15-25mm gap"/"feet must not fly in
the air" constraint: `FC_Y = RIDGE_SPLIT_Y + HINGE_GAP` (`HINGE_GAP`=20mm,
midpoint of the stated range) = 228.665mm; `FC_Z = DATUM_Z_RIDGE +
BRACKET_RISE` (`BRACKET_RISE`=25mm, short-bracket placeholder, replaces
the retired UCP204-12's 33.3mm H) = 1406.335mm. This is now a REAL,
CHECKABLE fixed-side fact (`FC_Y` > `RIDGE_SPLIT_Y`, confirmed against
`fixed_side_wedge()`'s own real boundary), not a re-guess from octagon
topology (v7's mistake) or an instruction taken on faith without a
topology check (v7.2's gap: 208.665mm < the-then 305mm).

**3. `hinge_bracket()` (new, replaces `ucp_bearing()`/the retired
UCP204-12 pillow block).** Foot plate flush-mounted ON the ridge surface
(Z=`DATUM_Z_RIDGE`), fully inside the fixed zone: `FOOT_Y0`=213.665mm,
`FOOT_Y1`=258.665mm (both > `RIDGE_SPLIT_Y`=208.665mm — "the feet of the
hinge must not fly in the air", satisfied by construction). Short hull-
based riser/gusset connects the foot to the pivot boss, matching the
reference photo's own short angled arm. Exact bracket dimensions are cc's
own placeholder judgment calls (a photo, not a spec sheet) — flagged,
pending the real part.

**4. Axle bore location on the rib** — delegated explicitly by Janis
("you are free to find the hole location"). cc kept it at `[FC_Y,FC_Z]`,
the same convention every prior version has used (bore at the spine's own
door-side terminus) — reused, not reinvented.

**5. CB1/counterbalance/stopper-vs-apex-D** — explicitly deferred by
Janis this round ("let the back cb and its arm collide first ignore it").
NOT touched. Live-recomputed dist FC-to-D is now 202.670mm (down from
v7.2's ~225.1mm) — still not independently verified to clear apex D by a
real margin; the v7.2 finding (Section 11 above) stands, unresolved,
carried forward.

**REAL COLLISION FOUND + FIXED THIS ROUND (self-checked via a Python
geometry sweep BEFORE committing, per R-014 — not asserted without
evidence):** the naive door-side arm (`RIB_C_OFFSET` -> `FC` straight
segment, at its old `WELD_HALF_W_C`=40mm half-width) swept directly
through `hinge_bracket()`'s own foot plate at `door_open_deg`=0 (closed)
— a real, unavoidable consequence of this round's pivot sitting much
closer to the door's own parting line than any prior version (less room
for the arm to clear the fixed foot). Worst-case penetration: -19.07mm
(fine sweep, 0.02° steps, capsule-vs-box distance, excluding the ~30mm
knuckle region immediately around FC where the rotating pad and the fixed
boss/riser are EXPECTED to sit close together by design — same accepted
simplification every prior version's own pillow-block placeholder has
always had). FIX: `WELD_HALF_W_C` reduced 40mm -> 25mm (still ≥
`MIN_HALF_W`=20mm), plus a new `DOOR_ARM_DETOUR` waypoint (same real
"push the closest-approach point away from the obstacle by a fixed
margin" technique already established for the CB-branch's own
`BRANCH_BOW_NATIVE`, reused not reinvented) — a live midpoint between
`RIB_C_OFFSET` and `FC`, pushed +25mm in world Z, at `MIN_HALF_W`=20mm.
Re-verified after the fix: worst-case real clearance +12.79mm at
`door_open_deg`=0, comfortably positive.

**Self-check before presenting** (real OpenSCAD renders, per this
project's own established `xvfb-run -a openscad` pipeline, not just the
formulas): `--render` (full CGAL) at `door_open_deg`=0 and 90 both report
`Simple: yes` (manifold-clean, 0 self-intersections); visual renders at
0°/15°/45°/90° confirm the door and 3 ribs continue to move as one rigid
unit (the v7.1/v7.2 sync mechanism is UNCHANGED code, so this was
expected, not re-derived — confirmed anyway, not assumed). The door-side
arm's own real collision (above) was caught by the geometry sweep, NOT by
the visual render — flagged explicitly, since the bracket's own small
size makes it hard to spot visually at the whole-assembly render scale.

**R_HANDLE**: 543.0mm -> 548.4mm, pure consequence of the pivot's own
real position (`HANDLE_Y`/`HANDLE_Z` unchanged). Swept force curve
(Section 3) is stale YET AGAIN, still not recomputed (stopper/CB review
still deferred, item 5 above).
