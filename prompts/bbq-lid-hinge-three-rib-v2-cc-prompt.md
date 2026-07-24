# bbq-lid-hinge-three-rib-v2-cc-prompt.md
# BBQ Offset Smoker — Lid Hinge / Counterbalance Mechanism, THREE IDENTICAL RIBS
# Date: 2026-07-24
# Author: Claude Web (independent plain-Python moment-balance verification,
# spanning this session and the prior one — see Section 9 for the full record)
# Target file: BBQ-offset-smoker-base-v5.scad -> save as v6
# Also touches: BBQ-chambers-v22.scad -> v23 (NARROW change only -- retires
# the stale lid_hardware()/LEVER_ARM/COUNTERWEIGHT_KG placeholder, R-009,
# see Section 8). Chambers is otherwise frozen, same pattern as the tray.
# Supersedes: bbq-lid-hinge-sideribs-v1-cc-prompt.md (2026-07-23, never run —
# that round's "2 side ribs, center rib deferred" scope and its CB1+CB2
# hybrid concept are BOTH superseded. This round is simpler: 3 identical
# ribs, ONE counterbalance arm, no fill weight needed.
# Architecture note (confirmed with Claude Web, prior session -- carried
# forward into this prompt, not present in the session that drafted the
# original version of this file): the mechanism lives in the base
# (Accessories) file, not chambers; it sits on the same Y=0 face as the
# relocated prep tray, so lid/tray/counterbalance interaction must be
# swept together, not checked in isolation.

---

## 1. CC INTRO

Session continuity check (cc self-determines):
Are cc_rules.md, knowledge.map, and cc_chat_log.md already loaded in your
active context from earlier in THIS session, with no git pull/merge to main
since?
-> YES: CONTINUATION. Skip re-reading those three. State "Continuation --
   governance already current" and go straight to TASKS.
-> NO (new session/chat, first prompt of the day, or main changed since):
   FRESH. git fetch --all && git checkout main && git pull origin main.
   Read cc_rules.md -> knowledge.map -> cc_chat_log.md (first 3 entries).
   State every file read before writing a line.

Before writing any fix (per R-009, RULES.md): confirm whether the
value/logic being changed exists in more than one place. State this check
explicitly in cc_chat_log even if the answer is "no duplicates found."

Claude Web override: none

Task-specific reads (read regardless of continuation/fresh):
- bbq-offset-smoker/rules-bbq-fab.md -- LIVE, in full. TASK 6 below appends
  a new locked convention; match the file's existing formatting/dating style.
- bbq-offset-smoker/design_scope_of_work_rule.md -- LIVE, in full.
- bbq-offset-smoker/SKELETON_WORKSHEET.md -- LIVE, in full.
- bbq-offset-smoker/PART_MANIFEST.md -- LIVE, current BBQ-chambers and
  BBQ-understructure rows.
- knowledge.map -- current bbq-offset-smoker/ row.

---

## 2. CONTEXT

This adds the lid's real hinge/handle/counterbalance mechanism, replacing
the long-disabled `lid_hardware()` stub in the chambers file. Built in the
BASE file (not chambers), driving the chambers file's own `lid_open_deg`
kinetic variable by reassignment AFTER the include chain -- OpenSCAD's real
"last top-level assignment wins globally" behavior, already empirically
verified in-sandbox in the prior (2026-07-23) session via `echo()` probes
on this project's real 3-file include chain. Reassign `lid_open_deg` in
this file, after `include <BBQ-understructure-v15.scad>`, not before.

**This round is a full redesign of the prior round's scope, not an
addendum.** The 2026-07-23 round proposed 2 side ribs (identical profile)
plus a deferred, differently-designed center rib carrying a second
counterbalance arm (CB2), because the single-arm design could not clear
the 1kgf lift target at the closed position. That CB2 concept, and the
"2 ribs now, 1 deferred" split, are BOTH superseded here:

- **All 3 ribs are identical** -- each carries the handle, the axle, and
  the CB1 counterbalance pipe. There is no differentiated center rib.
- **Only ONE counterbalance arm exists (CB1).** A real, independently
  re-derived moment-balance analysis this session -- using the lid's own
  real CG (not the stale/unrecorded value the 9.85kgf figure depended on),
  the corrected handle position, and the handle's real hollow-tube mass --
  found that CB1 alone, repositioned and with no added fill weight, meets
  the actual target: comfortable force at both the closed and open
  extremes, with a sign change (push becomes pull) somewhere in the
  middle -- which is expected UX, not a defect, per Janis's own explicit
  confirmation this session.
- CB2 is not being built. Do not add a stub for it.

All geometry below was independently verified via a real Python
moment-balance model this session (rotation formula round-trip checked
against the prior session's own confirmed open/closed coordinate pairs;
CB1's 8.06kg mass independently re-derived from its real material
dimensions and matched the prior session's figure exactly). Treat every
locked number below as a checked target, not a starting estimate. Full
derivation, including the specific bug this session caught and fixed
(a sign error in the closed<->open coordinate inverse, caught by a
round-trip self-check before it reached any locked number) is preserved
in the new reference file, Section 9 below -- read it before questioning
any number here.

---

## 3. REAL GEOMETRY -- LOCKED VALUES

### 3.1 Octagon vertices (world Y,Z) -- reference only, already exist
implicitly in the chamber shell geometry, do not redraw:
```
A = (0, APEX_A_Z)                                    // (0, 850.0)
B = (0, chamber_floor_z + chamber_H - chamfer)        // (0, 1102.67)
C = (chamfer, DATUM_Z_RIDGE)                          // (178.665, 1281.335)
D = (chamber_W - chamfer, DATUM_Z_RIDGE)              // (431.335, 1281.335)
E = (chamber_W, chamber_floor_z+chamber_H-chamfer)    // (610.0, 1102.67)
```

### 3.2 Pivot (fulcrum) -- `fc` -- UNCHANGED from the prior session
```
fc_y = C.y + 15       // 15mm along the ridge, toward D
fc_z = DATUM_Z_RIDGE + 33.3   // UCP204-12's real "H" dimension
```
Current numeric value: `fc = (193.665, 1314.635)`.

### 3.3 Rotation convention -- CONFIRMED, do not re-derive or flip
`door_open_deg`: 0 = closed, 90 = fully open.
```openscad
module lid_rib_assembly(door_open_deg = 0) {
    translate([RIB_X, fc_y, fc_z])
        rotate([-door_open_deg, 0, 0])
        translate([0, -fc_y, -fc_z])
        rib_solid();
}
```
`RIB_X` is a real module parameter -- called once per rib at each of the
3 X-positions in Section 6. (Flagging a real gap in the prior session's
own prompt: `RIB_X` appeared in that pseudocode but was never declared as
a parameter -- fix it here, this is not new geometry, just a missing
parameter in an already-locked snippet.)

### 3.4 Grab handle -- CORRECTED this session, do not use the prior
session's -100/825 value
```
handle_closed = (Y=-140, Z=875)      // = APEX_A_Z(850) + 25
handle_open   = rotate(handle_closed, -90 about fc)  // (-246.0, 1648.3)
```
Rod: hollow stainless steel tube, 25.4mm OD (1"), 2mm wall. Free-rotating
on off-the-shelf bearing bushings at BOTH ends -- **the bushings
themselves are NOT modeled in this drawing; Janis is sourcing the real
off-shelf part directly.** The rib only needs a clearance bore at the
handle position. Use a placeholder bore of 30-32mm diameter (consistent
with this project's existing 27mm-bore-over-25.4mm-rod clearance margin
convention) and flag it explicitly in cc_chat_log as TBD -- confirm/resize
once Janis has the real bushing part number, before this is sent for
fabrication. The rod passes through all 3 ribs; end caps close both ends
of the hollow tube.

### 3.5 Axle / pivot bearing -- UCP204-12 -- UNCHANGED from the prior
session, real catalog part confirmed by Janis against the supplier chart
| Spec | Value |
|---|---|
| Bore | 3/4" (19.05mm) |
| H (base to bore center) | 33.3mm -- used directly in `fc_z` |
| L (bolt hole span) | 127mm |
| J (foot width) | 95mm |
| A (base length) | 38mm |
| Bolt hole | M10 |
| Weight | 0.7kg |
Axle: 1" solid rod (25.4mm), machined to 3/4" (19.05mm) at each end to seat
in the two pillow-block bores. Bearing housings: simple rounded bell shape
with a foot and a center hole -- do not replicate supplier casting detail.

### 3.6 CB1 -- 4" square counterbalance pipe -- POSITION CORRECTED, NO
FILL WEIGHT (this is the headline change from the prior session)
```
Material: 4" sq tube, 101.6mm OD, 3mm wall, both ends capped 3mm plate.
Length = chamber_L - 100   // live formula, currently 815mm
Mass: 8.06kg TOTAL (bare pipe + end caps) -- NO added fill weight.
Orientation: ONE FLAT FACE parallel to the D-E face (may look diamond-
  oriented in a Y-Z view since D-E itself runs at ~45deg -- expected).
Standoff from D-E face (along outward normal (0.7071,0.7071)):
  15mm air gap + 50.8mm (half of 101.6mm) = 65.8mm -- UNCHANGED.
```
**Position -- LOCKED, do not re-derive: 170.8mm from apex D**, measured
along the D-E edge (moved from the prior session's 150mm -- the real
moment-balance re-solve this session, using a corrected rib mass
distribution assumption per Section 3.7, converged on this value with the
bare pipe's own weight, no fill needed).
```
cb1_pipe_center_open   = D + 170.8*(0.7071,-0.7071) + 65.8*(0.7071,0.7071)
                        ~ (536.5, 1269.2)   // world Y,Z
cb1_pipe_center_closed ~ (239.1, 1657.5)    // world Y,Z, rotate -90 about fc
```

**Stopper -- COMBINED with the CB1 holder (reversing the prior session's
"separate feature" framing), real and specific:**
The holder is a U-shaped laser-cut prong, 15mm material thickness, that
grips the pipe **from the side, wrapping only HALF the pipe's own width**
-- not a full wrap, not top-and-bottom. As the door opens, this same
prong rotates with the pipe; the stop happens when **one localized point
or edge of the prong** (not a flat face) contacts the D-E surface.
Structurally, ANY point along the full D-E face is an acceptable contact
zone -- there is no fixed target location for the stop itself. The
practical choice: land that contact point at CB1's own already-locked
170.8mm position, since that requires zero extra prong material reach
(most laser-cut-material-efficient option, not a structural requirement).
The two sides of the U-prong are NOT required to be the same length --
if the geometry naturally wants one side longer to land the contact
point cleanly, that is expected and correct, not a defect.

### 3.7 Rib mass distribution -- real observation from a built reference
part (Janis's own physical unit, photographed this session), used as the
basis for the CB1 re-solve above:
**~70% of each rib's own total mass sits on the door-side (weld-to-lid
zone through the pivot); ~30% sits on the CB-side (pivot through the
CB1/prong end).** This is a real-part-informed target for cc's own
profile judgment in Section 5, not a hard geometric constraint -- the
rib's true total mass remains a Pass-1 estimate (~3.9kg) pending the real
drawn profile. If the drawn profile's own real mass split differs
significantly from 70/30, flag it in cc_chat_log; do not silently force
material to match the ratio at the expense of the construction rules in
Section 5.

---

## 4. CONSTRUCTION ORDER -- MANDATORY, DO NOT DEVIATE

Real lesson from the prior session's sandbox work, where two separate
construction-order bugs (branch built from an ad-hoc waypoint instead of
a traced contour; branch built in open-state coordinates treated as
closed-state) each produced a mechanically backwards result:

1. Place the fixed reference geometry FIRST, as real coordinates, before
   drawing any rib material: axle/pivot bore at `fc` with the real
   UCP204-12 bolt pattern; handle bore at its CLOSED position; CB1 pipe,
   correctly oriented flat-to-D-E, at its OPEN position
   (`cb1_pipe_center_open`, the locked 170.8mm-from-D point).
2. Draw the rib's door-side arm ONLY, in its CLOSED-state configuration
   (handle bore -> pivot, welded flush along the lid's own A-B, B-C
   faces). Do not draw the CB1 branch yet.
3. Kinetically sweep this door-side arm alone (`door_open_deg` 0-90) and
   confirm it clears the shell before proceeding.
4. Only then, draw the rib material connecting the pivot to the CB1
   pipe's OPEN position placed in step 1 -- the branch must physically
   reach the pre-placed, already-correct pipe location.
5. The rib is ONE continuous laser-cut piece, one consistent (closed/
   native) reference frame throughout -- `door_open_deg` rotates the
   whole rigid assembly together. Never build part of the rib in "open"
   coordinates and part in "closed" coordinates.

This is a real, reusable pattern -- see Section 6 (new named convention).

---

## 5. RIB PROFILE -- REAL FIRST-DRAFT GEOMETRY, NOT A STUB

This round should produce a genuine first-draft rib profile, not a
placeholder box -- Janis will do a direct-cc tuning pass on the exact
spline afterward (R-011, Direct-CC Escalation Protocol; no further
Claude-Web-drafted prompt is expected for that fine-tuning round). Build
a real, reasonable profile per these rules so that tuning pass starts
from something usable:

- Steel: 3mm laser-cut plate.
- **Width is a MINIMUM (40mm), not a fixed constant.** The profile grows
  at three real transition zones, connected by smooth free-form curves --
  no hard width changes:
  a. **Weld-contact zone** where the rib touches the lid along A-B, B-C:
     70-100mm.
  b. **Handle wrap**: grow from the traced spine to fully wrap the handle
     bore with at least a 10mm round transition.
  c. **CB1/prong reach**: the branch widens smoothly into the U-prong
     (Section 3.6) at its tip.
- Minimum 15mm material ("meat") around every rod/pipe/bore hole. Fillet
  every corner and direction-change -- no hard edges anywhere.
- **Door-side arm construction**: trace the real A-B/B-C contour from the
  pivot toward the handle as the spine's starting reference.
- **CB-side branch construction**: trace the real D-E contour and offset
  OUTWARD by 20mm for the branch's own centerline (this offset, by
  construction, keeps the branch a real 20mm clear of the traced surface
  everywhere along it -- do not freehand a path or search for an
  arbitrary waypoint).
- **Ridge (top edge) profile -- real aesthetic direction from a built
  reference part Janis photographed this session**: one continuous,
  large-radius arc spline sweeping from the door-weld zone through to the
  CB1 end -- not a series of straight segments or sharp direction changes.
  This is the single most visually important surface of the part; give it
  real curve character, not a mechanical offset-only path.
- Real target: ~70% of the rib's own mass on the door-side portion, ~30%
  on the CB-side portion (Section 3.7) -- informational guidance for
  profile judgment, not a hard constraint.

---

## 6. RIB X-POSITIONS -- ALL 3 RIBS IDENTICAL

```
rib0_x (front)  = LID_X0 + 150   // live formula, currently 250mm
rib1_x (center) = midpoint(rib0_x, rib2_x)  // currently 457.5mm
rib2_x (rear)   = LID_X1 - 150   // live formula, currently 665mm
```
All 3 ribs use the IDENTICAL profile described in Sections 3-5. There is
no differentiated center rib in this design.

---

## 7. KINETIC VIEWABILITY -- BOTH FILES, AS USUAL

- In the BASE file: expose `door_open_deg` as a real, Customizer-visible
  top-level parameter (default 0), driving the full rib/handle/axle/CB1
  assembly per Section 3.3, and reassigning the chambers file's own
  `lid_open_deg = door_open_deg` AFTER the include chain (Section 2).
  Adjusting this one parameter in the base file must move the rib
  assembly AND the visual lid shell together.
- Confirm the CHAMBERS file's own native `lid_open_deg` parameter
  (already existing, independent of this round's changes) still works
  correctly when the chambers file is opened and rendered on its own,
  without the base file -- this is the existing isolated-viewing path,
  unaffected by this round, but explicitly re-confirm it in QA rather
  than assume it still works after this round's changes.

---

## 7.5 RETIRE THE STALE CHAMBERS STUB -- REAL CHANGE, R-009

`BBQ-chambers-v22.scad` still carries the old, disabled `lid_hardware()`
module and its `LEVER_ARM = 400` / `COUNTERWEIGHT_KG = 10` constants --
built for the pre-v2 end-hinged lid geometry, `show_lid_hardware=false`
since that round, zero real callers since v1 (confirmed: this is a stale
placeholder, not a live duplicate value in active use). With this
prompt's real counterbalance mechanism now built in the base file, this
stale stub becomes a genuine R-009 duplication risk -- two unrelated
"counterbalance" concepts in the codebase, one dead. **Delete
`lid_hardware()` and its two constants entirely from
`BBQ-chambers-v22.scad`, save as v23.** State the real R-009 duplication
check explicitly in cc_chat_log per this project's own CC INTRO
convention, even though the answer here is "confirmed dead, removing the
only copy." This is the ONLY change chambers gets this round -- see
Section 8.

---

## 8. DO NOT TOUCH

- `rules-dimensions.md` -- read only.
- `BBQ-chambers-v22.scad` -- ONE change only, Section 7.5 (stale stub
  removal). No other content change. `BBQ-understructure-v15.scad` -- no
  changes at all. The base file reassigns `lid_open_deg` after including
  them, per the already-established pattern -- that mechanism itself is
  untouched.
- The moment/torque physics itself -- LOCKED. Do not recompute, re-derive,
  or second-guess CB1's mass or position. See Section 9 for where the
  full analysis is preserved. This round is geometry + collision QA only.
- Every other `.scad` file not listed above.

---

## 9. REFERENCE -- PRESERVE IN REPO, DO NOT LOSE

Create `docs/lid-hinge-counterbalance-calc.md`, capturing:

- Pivot/rotation derivation (Section 3.2-3.3), including the round-trip
  self-check method used this session to catch a real sign bug in the
  closed<->open coordinate inverse before it reached a locked number --
  worth keeping as a standing verification pattern for any future
  kinematic derivation on this project.
- Component mass & CG table, world (Y,Z), closed state:
  lid shell 8.51kg (44.7, 1084.2); handle (hollow, corrected) 0.957kg
  (-140, 875); axle 3.24kg (on pivot, ~zero moment arm); rib ~3.90kg
  (Pass-1 estimate, 70/30 door/CB split per Section 3.7, position
  dependent on final profile -- flagged as still approximate); CB1
  8.06kg (239.1, 1657.5).
- Torque convention: `moment = -mass * y'(theta)`, where `y'(theta) =
  y0'*cos(theta) + z0'*sin(theta)` is the rotated horizontal offset from
  the pivot, `(y0',z0')` the closed-state relative position. Force at
  handle = moment / R_handle, where R_handle is the constant radial
  distance from pivot to handle (551.9mm) -- this project's chosen
  convention (radial/tangential, not vertical-only decomposition), stated
  explicitly since Janis's own original spec authorized either.
- Full swept force curve, 0-90deg, 10deg steps: +2.00, +1.80(10), +1.54
  (20), +1.23(30), +0.89(40), +0.52(50), +0.13(60), -0.26(70), -0.64(80),
  -1.00(90) kgf. Crosses zero near 62-63deg -- expected, matches Janis's
  own confirmed UX goal (push becomes pull mid-sweep is fine; what
  matters is both endpoints stay modest and neither favors runaway
  opening at 0deg nor runaway closing at 90deg).
- Explicit note: this design change (CB1 alone, no CB2, repositioned to
  170.8mm) makes the prior session's hybrid CB2 parameters (mass2=2kg,
  R2=350mm, phi2=80deg) obsolete -- preserved in this doc's own history
  section for the record, not as a live design input.
- Explicit note that the rib's real total mass and true CG are still
  pending the final drawn profile -- flag that the force numbers above
  could shift somewhat once that's real, same sensitivity already
  demonstrated this session (a rough rib CG guess vs. the real 70/30
  split moved CB1's position from 83mm to 170.8mm and its required mass
  from 10.40kg to 8.06kg -- a large swing from one input).

This doc is reference material -- it does not gate or block this round's
geometry work.

---

## 10. NEW LOCKED CONVENTION -- APPEND TO `rules-bbq-fab.md`

Append a new dated section, **"Three-Rib Lid Counterbalance System
(locked 2026-07-24)"**, so a future product line's lid mechanism can be
requested and built in ONE prompt instead of the multi-session derivation
this one took. Write it GENERALIZED -- describe the reusable STRUCTURAL
pattern, not today's specific numbers (a future product's own chamber
geometry will produce its own real values via the same method):

- **Pattern**: 3 identical ribs (not a differentiated center rib) --
  each carries three real control points: a grab handle, a pivot axle,
  and a single counterbalance arm (CB1). Start with ONE counterbalance
  arm; only add a second (differentiated on one rib) if a real moment-
  balance calculation proves one arm cannot meet the target force range
  -- do not default to a two-arm design as a first attempt.
- **Physics method**: real Python moment-balance model (not OpenSCAD),
  using each mass's real CG position and the rotation-formula round-trip
  self-check (Section 9 of this prompt) to catch coordinate-inverse
  errors before any number is locked. Target the force at BOTH extremes
  (closed and open) as the primary constraint -- a mid-sweep sign change
  is expected, not a defect, as long as both endpoints stay within a
  comfortable range confirmed with the product owner.
- **Combined stopper/holder**: the counterbalance pipe's own U-prong
  holder doubles as the hard stop -- a single localized contact point/
  edge against the fixed structure, landed wherever the pipe's own
  already-solved position makes it free (material-efficient), not at an
  arbitrarily separate location.
- **Rib profile**: minimum width, not fixed -- grows at the weld-contact,
  handle-wrap, and counterbalance-branch transition zones, connected by
  smooth free-form curves per this session's real reference-part
  photograph. Ridge gets one continuous large-radius arc spline.
- **Construction order** (Section 4 of this prompt): fixed references
  placed first as real coordinates, door-side arm built and swept-tested
  before the counterbalance branch is drawn, everything in ONE consistent
  closed-state reference frame.
- **Apex clearance rule**: minimum 20mm real clearance, worst case,
  across the full swept rotation -- not just the two endpoints.

Cross-reference this new section from `design_scope_of_work_rule.md`'s
own counterbalanced-lid feature entry (per this file's existing
cross-reference convention).

---

## 11. QA VERIFICATION -- REQUIRED

- [ ] Real CGAL sweep, `door_open_deg` 0-90, real fine steps (5deg or
      finer), full assembly (all 3 ribs + handle + axle + CB1 + base +
      understructure + chambers, real `include` chain) -- confirm
      `Simple: yes` and ZERO collision at every step, not just endpoints.
- [ ] **Apex D clearance: real minimum 20mm, worst case, stated as an
      actual measured number across the full sweep** -- new explicit
      rule this round, not previously checked for the 170.8mm position.
- [ ] **Real 3-way combinatorial sweep, not a single fixed state**: the
      counterbalance mechanism shares the same Y=0 face as the relocated
      prep tray (`trays()`). Sweep `door_open_deg` (0-90) CROSSED with
      `tray0_angle_deg`/`tray1_angle_deg` (-90 to 0, both trays, real
      steps at both extremes and at least one mid-point each) -- state
      the actual combination matrix checked and the real result for each,
      `Simple: yes` / EMPTY throughout. Checking trays only at their
      deployed (0deg) default while the lid sweeps is NOT sufficient --
      this project has already found real collisions twice from checking
      one state instead of the full combined space (apex D mid-sweep;
      the base-chain-recalibration incident). Do not repeat that pattern
      here on the same Y=0 face.
- [ ] Confirm via real render that the handle stays reachable at both
      `door_open_deg=0` and `=90`.
- [ ] Confirm the U-prong wraps only half the pipe's width (not a full
      wrap) and state the real single contact point's coordinates.
- [ ] Confirm the base file's `door_open_deg` moves rib assembly + lid
      shell together; confirm the chambers file's own native
      `lid_open_deg` still works when rendered standalone (Section 7).
- [ ] Confirm the locked mass/position values used (CB1 8.06kg @170.8mm
      from D, handle 0.957kg, no fill weight) match
      `docs/lid-hinge-counterbalance-calc.md` exactly -- flag, do not
      silently adjust, if the real built geometry produces a different
      number than expected.
- [ ] This is geometry/collision QA -- do not recompute, re-derive, or
      comment on the moment/torque physics itself; explicitly locked,
      see Section 8.

---

## 12. MANDATORY CLOSING

1. Prepend `cc_chat_log.md` -- newest entry at top: state the real
   construction-order followed, the real apex-D clearance number found,
   confirm the QA sweep result (pass/fail, real angle list), confirm
   `docs/lid-hinge-counterbalance-calc.md` and the new rules-bbq-fab.md
   convention section were created/appended.
2. Archive this prompt -> `/prompts/archive/`.
3. Update `knowledge.map`, `PART_MANIFEST.md`, `SKELETON_WORKSHEET.md` --
   new hinge mechanism, new `docs/lid-hinge-counterbalance-calc.md` file,
   and the Kinetic Dual-View table entry for the door (closed/open states,
   real numbers, per Section 9).
4. Update `design_scope_of_work_rule.md`'s counterbalanced-lid feature
   entry to reflect the final locked single-arm design (replacing the
   old "~85-90% self-balance" language) and cross-reference the new
   Section 10 convention by name.
5. Bump version -- `BBQ-offset-smoker-base-v6.scad` (v5 kept unchanged)
   AND `BBQ-chambers-v23.scad` (v22 kept unchanged, per Section 7.5 --
   this file also needs its own knowledge.map/PART_MANIFEST row updated,
   not just the base file's).
6. Commit, merge to main.
