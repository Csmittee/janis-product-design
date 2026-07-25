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

**REAL CORRECTION, SAME DAY, AFTER PR #151 WAS ALREADY OPEN** — Janis
re-sent the reference image; cc had only worked from a text description
of it before (`hinge_bracket()`'s first pass was built without ever
having seen its actual pixels). Once actually visible, the image shows a
real, checkable shape mismatch against the first pass: a genuinely LONG
DIAGONAL ARM from a foot anchored near the chimney back to the pivot eye
near the door edge — not the short stubby hull-wedge cc built first.
Two real fixes, both self-checked before pushing:
1. **Foot re-anchored near `DATUM_Y_CENTER`** (305mm, the chimney's own
   real Y position, `PIPE_HOLE_Y` in `BBQ-chambers-v25.scad`) instead of
   right at the parting line — still fully inside the fixed zone, still
   ~101mm clear of apex D, and produces a real ~85mm diagonal reach to
   the pivot boss, matching the reference image's own proportions.
   Re-ran the door-arm-vs-foot collision sweep (Section 12 above) against
   the new foot position: clearance IMPROVED (+41.8mm worst-case, up from
   +12.79mm) — moving the foot farther from the door's own swept path can
   only help, never hurt, that specific check.
2. **Arm shape corrected** — a `hull()` between the WHOLE foot slice and
   the boss cylinder fills in all the space between them (a chunky
   trapezoid, confirmed via an isolated side-view render), not a slender
   arm. Rebuilt as a real hull of two small spheres (`ARM_R`=8mm,
   foot-top-center -> boss-center), which gives a genuine uniform-
   thickness rod — confirmed via a standalone isolated render
   (foot + arm + boss only, no chamber body) showing a shape that visibly
   matches the reference image's own silhouette.
Re-verified after both fixes: full `--render` (CGAL) pass at
`door_open_deg`=0 and 90 both `Simple: yes`. `hinge_bracket()`'s own
`FOOT_MARGIN` constant retired (replaced by the `DATUM_Y_CENTER`-anchored
`FOOT_Y0`); `FC_Y`/`FC_Z`/`HINGE_GAP`/`BRACKET_RISE` (the pivot's own real
position, the actual hard constraint) are UNCHANGED — only the fixed
bracket's own visual/structural shape moved, not the pivot itself.

**REAL BUG FOUND + FIXED, SAME DAY — "everything disappeared" when
Janis opened v8** (a real render, not the CLI's own no-`-D` default,
which never reproduced it — flagged, not silently glossed over: this
means the bug only manifests under the OpenSCAD GUI's own Customizer
behavior, not a plain compile, the SAME class of gap that caused the
original `lid_open_deg`/v7 bug). Root cause, confirmed via a full
top-level-variable duplication sweep across the flattened include chain
(`BBQ-chambers-v25.scad` + `BBQ-understructure-v18.scad` +
`BBQ-offset-smoker-base-v8.scad`, per R-009): cc's own new `HINGE_GAP`
constant (this round's lid-pivot gap, =20mm) COLLIDED with a
pre-existing, unrelated `HINGE_GAP`=0.5mm already declared in
`BBQ-chambers-v25.scad` (`firebox_door()`'s own real hinge-line
clearance gap, nothing to do with the lid mechanism). Because OpenSCAD
resolves same-named top-level variables via one global "last assignment
wins" rule across the ENTIRE flattened file, cc's own later `HINGE_GAP
=20` silently overwrote the firebox door's own intended 0.5mm value
(and/or the GUI Customizer's own auto-generated control for the
duplicate name resolved to the wrong one) — a 40x-larger value where a
tiny 0.5mm clearance was expected badly corrupts `firebox_door()`'s own
geometry, consistent with the catastrophic-looking broken render Janis
saw. FIX: renamed cc's own constant `HINGE_GAP` -> `PIVOT_GAP`
throughout `BBQ-offset-smoker-base-v8.scad` (confirmed collision-free via
the same duplication sweep) — no value or formula changed, pure rename.
Re-verified: full `--render` (CGAL) `Simple: yes` at 0°/90°, same facet/
vertex counts as before the rename (confirms zero geometric change).
**Lesson for this project's own governance** (candidate for a future
rules-bbq-fab.md amendment): before introducing ANY new top-level
constant name in a direct-cc session, run the same duplication sweep
this fix used (grep every top-level `NAME =` assignment across the
flattened include chain) — not just for the specific names being edited,
but for every NEW name being introduced. cc did this for `BKT_W`/
`BKT_BOLT_D` this same round (after the user's own earlier reminder) but
not for `HINGE_GAP`, `BRACKET_RISE`, `FOOT_*`, or `ARM_R` when they were
first introduced — this specific miss should have been caught by
applying the SAME discipline uniformly, not selectively.

**REAL DESIGN CORRECTION, SAME DAY — hinge mounting moved from the
ridge to the chamber's own TRUE end caps**, per Janis's own direct
question: "why cant you put it on the side near end cap? ... we pass a
shaft to all 3 ribs, and with both end to the hinge which sit on the fix
side of the frame near the door parting." This is a real, checkable
re-reading of the ORIGINAL "Cannot do" constraint ("the hinge must stay
at the fix side near end cap") — both of cc's first 2 passes this round
under-weighted "near end cap" as loose/descriptive language rather than
literal (mount at `DATUM_X_FRONT`=0/`DATUM_X_REAR`=915, not distributed
along the ridge between the ribs). `FC_Y`/`FC_Z`/`PIVOT_GAP`/
`BRACKET_RISE` (the pivot's own real position, tied to `RIDGE_SPLIT_Y`)
are UNCHANGED — Janis's own "close to the hinge door parting line on the
top ridge" confirms the pivot's own Y-Z location was always right, only
the bracket's own mounting SURFACE and X-position were wrong. New
`BKT0_X`/`BKT1_X` (20mm/895mm, a real `BKT_X_MARGIN`=20mm inset from each
true end cap for weld/bolt access) replace the old RIB0_X/RIB2_X-flanking
positions. `hinge_bracket()` rebuilt: foot now mounts flush against the
real end-cap material (`octagon_ring()`'s own `cap_x0`/`cap_x1` wall_t
plate, BBQ-chambers-v25.scad) instead of the ridge surface, extending
inward into the chamber's own interior (not floating), positioned close
to the ridge/door parting line in Y-Z (`FOOT_Y0`=RIDGE_SPLIT_Y+5,
`FOOT_Z1`=DATUM_Z_RIDGE). `axle_rod()` — already a single continuous
shaft spanning all 3 ribs before this round, unchanged code — now spans
`BKT0_X` to `BKT1_X` instead of hugging the outer ribs. REAL CHECK: the
rear bracket's own X-range (907-915mm) overlaps in X with the firebox
(`firebox_x0`=913.5mm) but NOT in Z — firebox tops out at Z=1000mm,
the bracket sits at Z=1336-1381mm (335mm+ clear) — confirmed via the
chambers file's own real `firebox_z1`/`FOOT_Z0` values, not assumed.
Re-verified: full `--render` (CGAL) `Simple: yes` at 0°/90°.

## 13. v8 4th pass — hinge reverted to the ridge, real UCP204-12 numbers (H0=64mm), door-side arm rebuilt to stop floating above the door (2026-07-25)

Janis, with an annotated screenshot: "i specifically ask to assembly on
the top ridge not from side and its locate near the door lid" — the 3rd
pass's own end-cap mount was WRONG; "near end cap" described the
bracket's own X-position preference (close to the ribs), not a literal
instruction to move off the ridge. `hinge_bracket()` reverted to
ridge-mounted (reusing the 2nd pass's own real slender hull-of-spheres
arm technique, unchanged), positioned near the outer ribs (`RIB0_X`,
`RIB2_X+RIB_T`) instead of the true end caps. `FC_Y`/`FC_Z` (the pivot's
own real position) unaffected by this revert.

**Real UCP204-12 numbers, Janis's own explicit choice**: a real pillow
block bearing, 3/4" bore (matches `AXLE_STUB_OD`=19.05mm, used since
v6). Its own real "H0" spec dimension (64mm) is reused, per Janis's own
instruction, for TWO real quantities: `RIDGE_SPLIT_Y` is now
`chamfer+64` (242.665mm, was `chamfer+30`), and `BRACKET_RISE` is now
64mm (was cc's own 25mm placeholder guess). `PIVOT_GAP`(20mm) unchanged,
confirmed still "ok on y" by Janis's own live-render feedback.

**"the rib fly above the door" — real bug, root-caused and fixed.**
Janis's own real render showed the door-side arm floating clear above
the lid's own real surface when open. Root cause: with `RIDGE_SPLIT_Y`
now much farther from apex C, the lid's own ridge-cap panel is
considerably longer than any prior version — the old straight
`RIB_C_OFFSET`->pivot run cut a chord above this longer panel's own
surface instead of tracking it. Self-checked via a real Python sweep
(per R-014) comparing the rib's own swept position (rotating about `FC`)
against the LID's own real panel geometry (rotating about its own,
DIFFERENT center — `RIDGE_SPLIT_Y`+`LID_HINGE_GAP`, not `FC`) at every
angle 0-90°, both directions, not just the closed state — this is a real
geometric subtlety Janis's own QA ask ("either swing close or open")
correctly anticipated: since the rib and lid rotate about different
centers by the same angle, their relative offset genuinely drifts across
the sweep, so a closed-state-only check is not sufficient.

**TWO further real sink issues found by the same sweep, present since
v6.1 (not new this round, just never checked this rigorously before)**:
1. A single-normal offset at a corner where TWO panels meet (e.g. pure
   `AB_NORM` at apex B, which also borders the B-C slant panel) doesn't
   clear the SECOND panel — real overlap, up to ~16mm at various angles.
2. Any spine point offset by a standoff SMALLER than its own real
   half-width overlaps the wall it was offset from, AT that point
   (`RIB_SPLIT_OFFSET`'s own old 15mm standoff vs 22mm width did this).

**Fixes, all self-checked via the same sweep before committing:**
- Real corner-miter normals at B and C (`miter_norm()`, average of both
  adjacent panels' own outward normals) replace the single-wall normals.
- Standoffs increased so each point's own real half-width no longer
  exceeds its standoff: split 15->25mm, B/C 15->30mm (miter direction).
- New `RIDGE_FLAT_PT` waypoint (`RIDGE_ARM_STANDOFF`=40mm above the
  ridge-cap panel, `RIDGE_INSET`=50mm back from `RIDGE_SPLIT_Y`) so the
  arm tracks the panel's own real surface before rising to the pivot.
- `WELD_HALF_W_SPLIT`/`_B`/`_C` reduced to `MIN_HALF_W`(20mm, the
  project's own stated floor) — the tight real geometry here does not
  support the prior 22-25mm convention without reopening the sink.
  `RIDGE_FLAT_HALF_W`=15mm, a real, flagged exception BELOW the 20mm
  floor — the sweep found this is genuinely the narrowest point needed
  to clear the ridge-cap panel's own edge across the full sweep at this
  round's real numbers; 20mm there reopens a confirmed sink.

**Result, fine sweep (0.02° steps, 0-90°, excluding the ~30mm knuckle
zone around FC where the rotating pad and fixed boss are expected to sit
close by design)**: worst-case real clearance **+2.3mm**. This is a
real, flagged THIN margin — well under this project's usual 15-20mm
convention — an honest consequence of how tight this corner geometry
genuinely is at the real widths involved, not a false sense of safety.
Re-verified: full `--render` (CGAL) `Simple: yes` at `door_open_deg`
0°/45°/90°.

## 14. v8 5th pass — REAL BUG in the 4th pass's own miter formula; correct formula applied; visual "floating" issue STILL NOT RESOLVED, architecture change proposed (2026-07-25)

Janis, after seeing the v8 4th-pass renders cc sent: "why didnt you
listen to me... From the image you show me not from the file, i still
see the rib flying above the lid." cc re-examined its own sent images
and confirmed this is correct — the 4th pass's own fix for the sink
issue (Section 13) used a WRONG geometric formula for the corner
offsets at B and C: averaging the two adjacent walls' own normals and
pushing a FLAT chosen distance along that average direction does not
account for the corner's own real angle. The TRUE perpendicular
clearance from such a push is `d*cos(theta/2)`, not `d` — this is why
the 4th pass's own first attempt (d=15mm) under-cleared (the sink), and
the empirically-inflated fix (d=30-40mm) then overshot into a visibly
disconnected gap.

**Real fix applied**: the standard 2D polygon-offset miter-point
formula, `miter_point = V + d*(n1+n2)/(1+n1.n2)` — this is the exact
point that is perpendicular distance `d` from BOTH adjacent walls
simultaneously (a real CAD/vector-graphics construction, not an
approximation). New `miter_point()` function replaces the 4th pass's own
`miter_norm()` + external multiply. Re-tuned via the same Python sweep:
`B_STANDOFF`/`C_STANDOFF`=30mm (the real target perpendicular clearance,
not a raw push distance), `RIDGE_ARM_STANDOFF`=50mm, `RIDGE_INSET`=50mm,
all weld half-widths back at the project's own `MIN_HALF_W`=20mm floor
(no below-floor exception needed with the corrected formula). Fine
sweep result: worst-case clearance **+4.1mm**.

**HONEST STATUS, NOT HIDDEN**: despite this being a real, verified
mathematical improvement (the previous formula was genuinely wrong, this
one is genuinely correct) and a real positive numeric clearance, a fresh
render of this 5th-pass geometry STILL visually shows the same
disconnected-looking gap between the rib and the door panel that Janis
flagged. cc is not claiming this is fixed. This suggests either (a) the
simplified 2D flat-panel model used for the Python sweep (approximating
the lid's own real panels as flat rectangles/segments) misses some real
geometric detail the actual chambers.scad solid has, or (b) "clears by a
few mm" is numerically true but still visually reads as "floating" at
this rendered scale, or both.

**Path forward, Janis's own suggestion, cc agrees**: "should the rib be
create in the chamber file better in that way the rib stay fix to the
door, always? and then you find the pivot location in the rib later."
Building the rib's own door-side profile as a genuine function of the
chamber file's own real door/lid geometry (e.g. a real 2D offset of the
lid's own actual closed-state outline) would GUARANTEE the rib hugs the
real surface by construction, instead of the current approach's
repeated, hard-to-get-right per-corner point math. Not yet implemented —
proposed as the next real step, pending Janis's confirmation of the
"side not the back" hinge-location point raised in the same message.

## 15. v9 — real shared hinge pivot, Janis's own hands-on calculation (2026-07-25)

The round that actually resolves the sink/float saga, after 5 v8 passes
didn't. Full chat is the real record; summary of the real, load-bearing
facts:

**Hinge location, finally pinned down precisely.** Two real corrections
from Janis, both confirmed with images before any code changed:
1. cc's own diagram wrongly implied the door spans the full 915mm
   chamber length. Real code check: `LID_X0`=100, `LID_X1`=815
   (`LID_LENGTH`=715mm) — a real 100mm margin of solid, no-door material
   exists at BOTH true ends. Janis named this the "end margin zone."
2. The hinge bracket mounts INSIDE that end margin zone (its near edge
   25mm from `LID_X0`/`LID_X1`, real UCP204-12 "A"=38mm foot width in X),
   not on the ridge between the ribs, and not at the true X=0/915 ends
   either. This is the key fact that unlocks everything else: AT THAT
   X-POSITION, the CD face is fixed material regardless of Y or Z — no
   door exists there to be "safely clear" of. That is why the pivot's
   own real Y can sit EXACTLY on `RIDGE_SPLIT_Y` (no gap at all), a
   placement that would have been unsafe anywhere inside the door's own
   operating X-range.

**Real UCP204-12 numbers, Janis's own literal spec, not re-derived**:
L=127mm (foot width in Y, centered on the pivot), A=38mm (foot width in
X), H0=64mm (pivot rise above the ridge). `RIDGE_SPLIT_Y` and the
pivot's rise both reuse this same 64mm — Janis's own explicit
instruction, both confirmed with a standalone isolated-hinge render
before touching the full assembly.

**Root cause of the whole saga, finally identified**: `lid()`
(BBQ-chambers) and the rib assembly (base file) rotated about TWO
DIFFERENT centers. Two rigid bodies rotating by the same angle about
different centers necessarily drift apart — no per-corner standoff
tuning can fix that, only avoid it. Fix: `BBQ-chambers-v26.scad`'s new
`HINGE_PIVOT_Y`/`HINGE_PIVOT_Z` is now the ONE real source of truth,
read live by both `lid()` and the base file's own `FC_Y`/`FC_Z`. With a
shared center, the rib and door's relative geometry is identical at
every angle by construction — confirmed visually at 0°/45°/90°, the rib
now visibly tracks the door surface at every angle (screenshots sent to
Janis), not just numerically "clears by a sweep-verified margin" like
every v8 pass claimed.

**Real, elegant confirmation found by direct calculation before writing
any code**: apex B, apex C, and the new pivot are EXACTLY collinear
(`HINGE_PIVOT_Y`-chamfer = 64 = `HINGE_PIVOT_Z`-`DATUM_Z_RIDGE`, matching
the B-C wall's own real 45° chamfer slope). The door-side arm is
therefore one straight run from B to the pivot; apex C needs no separate
corner treatment at all. Per Janis's own explicit instruction ("get back
the original rib you made"), the door-side spine reverted to v6.1's
simpler single-normal standoff technique (`SPLIT_STANDOFF`=15mm,
matching v6.1 exactly) plus the one real remaining corner (apex B, via
the correct `miter_point()` formula, `B_STANDOFF`=20mm) — checked once
at the closed state (a full multi-angle sweep is no longer needed, since
there is no longer a sweep-dependent drift to check).

**Deferred, explicitly, per Janis's own instruction**: CB1/counterbalance/
stopper (unchanged, "let's talk about the counter balance side" next).
Also deferred: the swept force curve (Section 3) was computed against a
pivot assumption several rounds out of date — Janis's own explicit call:
skip re-validating for now, fix any imbalance later with added/removed
counterweight material, rather than block this round on a full physics
recompute.

Full `--render` (CGAL) confirms `Simple: yes` at `door_open_deg`
0°/45°/90°.

## 16. Locked reference extracted to its own file (2026-07-25)

The shared-pivot mechanism above (Section 15) and the real hinge
location are now also written up as a standalone, doc-reload-proof
reference: `docs/hinge-construction.md`. That file additionally records
the "open-then-freeze" construction method (build against the door's
TRUE open-world position, then convert back to native frame) and a real
bug it caught the same day: the CB1 counterbalance pipe's position
formula (unchanged since v6, always marked "LOCKED — do not recompute")
was applying a spurious extra rotation, landing CB1 at a physically
wrong closed-frame position. The corrected math is recorded there; the
`.scad` fix itself is still pending, alongside a full rebuild of the
door-side rib spine (flagged stale this same round — see
`cc_chat_log.md`, 2026-07-25).
