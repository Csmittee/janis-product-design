# bbq-lid-hinge-sideribs-v1-cc-prompt.md
# BBQ Offset Smoker — Lid Hinge / Counterbalance Mechanism, SIDE RIBS ONLY
# Date: 2026-07-23
# Author: Claude Web (sandbox-verified geometry, this session)
# Target file: BBQ-offset-smoker-base-v5.scad -> save as v6

---

## 1. CONTEXT

This adds the lid's real hinge/handle/counterbalance mechanism, replacing the
long-disabled `lid_hardware()` stub in the chambers file. Per Janis's
explicit architecture decision earlier this session, this mechanism is built
in the BASE file (not the chambers file), and drives the chambers file's own
`lid_open_deg` kinetic variable by reassignment AFTER the include chain —
this override mechanism was empirically verified in-sandbox this session
(OpenSCAD's real "last top-level assignment wins globally" behavior,
confirmed via `echo()` probes on a mock 3-file include chain matching this
project's real structure). Reassign `lid_open_deg` in this file, after
`include <BBQ-understructure-v15.scad>`, not before.

All geometry below (pivot, handle, pipe positions, rotation sign) was
independently verified in an OpenSCAD sandbox this session — real renders,
real rotation-sense checks against a user-supplied reference photo, real
coordinate math. This is not a rough sketch — treat every number below as a
locked target, not a starting estimate.

**THIS ROUND IS SIDE RIBS ONLY (2 of 3 ribs).** The center rib carries an
additional counterbalance arm (CB2) that is explicitly OUT OF SCOPE this
round — see Section 7.

---

## 2. SOURCE — READ LIVE, DO NOT HARDCODE DUPLICATES

Read the following live from the existing include chain (already available
via `BBQ-understructure-v15.scad` -> `BBQ-chambers-v22.scad`), per this
project's own R-009 duplication-check convention. Do not redeclare local
copies of these:

- `chamber_L`, `chamber_W`, `chamber_H`, `chamfer`, `wall_t`
- `chamber_floor_z`, `DATUM_Z_RIDGE`, `DATUM_Y_CENTER`, `APEX_A_Z`, `GRATE_Z`
- `LID_X0`, `LID_X1`

---

## 3. REAL GEOMETRY — LOCKED VALUES (sandbox-verified this session)

### 3.1 Octagon vertices (world Y,Z) — for reference/verification only,
already exist implicitly in the chamber shell geometry, do not redraw:

```
A = (0, APEX_A_Z)                              // currently (0, 850.0)
B = (0, chamber_floor_z + chamber_H - chamfer)  // currently (0, 1102.67)
C = (chamfer, DATUM_Z_RIDGE)                    // currently (178.665, 1281.335)
D = (chamber_W - chamfer, DATUM_Z_RIDGE)        // currently (431.335, 1281.335)
E = (chamber_W, chamber_floor_z+chamber_H-chamfer) // currently (610.0, 1102.67)
```

### 3.2 Pivot (fulcrum) — `fc`

Real formula, live:
```
fc_y = C.y + 15          // 15mm along the ridge, toward D
fc_z = DATUM_Z_RIDGE + 33.3   // 33.3mm up off the ridge surface = UCP204-12's
                                // real "H" (base-to-bore-center) dimension
```
Current numeric value: `fc = (193.665, 1314.635)`.

The ridge (C-D edge) is horizontal (both at `DATUM_Z_RIDGE`), so the pillow
block mounts flat on top of it, bore centerline sitting straight up by `H`.

### 3.3 Rotation convention — CONFIRMED, do not re-derive or flip

`door_open_deg`: 0 = closed, 90 = fully open.

**Real, verified formula:**
```openscad
module lid_rib_assembly(door_open_deg = 0) {
    translate([RIB_X, fc_y, fc_z])
        rotate([-door_open_deg, 0, 0])
        translate([0, -fc_y, -fc_z])
        rib_solid();
}
```
The `-door_open_deg` sign is REAL and CONFIRMED — verified against a
user-supplied reference photo of the actual physical mechanism (red-line
sketch showing the handle's real open-position direction) and cross-checked
numerically. Do NOT flip this sign without re-verifying against that same
reference — an earlier pass in this session used the opposite sign and
produced a mechanically backwards result (handle swinging into the chamber
instead of away from it).

### 3.4 Grab handle — 1" rod

```
handle_closed = (Y=-100, Z=APEX_A_Z-25)     // currently (-100, 825)
handle_open   = rotate(handle_closed, -90 about fc)  // currently (-296.0, 1608.3)
```
Rod: 25.4mm OD (1"), through-bore in each rib 27mm dia (clearance), rod
welded to all 3 ribs where it passes through.

### 3.5 Axle / pivot bearing — UCP204-12 (real catalog part, confirmed by Janis)

| Spec | Value |
|---|---|
| Bore | 3/4" (19.05mm) |
| H (base to bore center) | 33.3mm — used directly in `fc_z` above |
| L (bolt hole span) | 127mm |
| J (foot width) | 95mm |
| A (base length) | 38mm |
| Bolt hole | M10 |
| Weight | 0.7kg |

Axle: 1" solid rod (25.4mm), machined down to 3/4" (19.05mm) at each end to
seat in the two pillow-block bores. Bulk of the rod stays full 1" diameter
between the ribs. Model the bearing housings as a simple rounded bell shape
with a foot and a center hole per Janis's explicit instruction — do not
attempt to replicate the supplier's real casting detail.

### 3.6 CB1 — 4" square counterbalance pipe (side ribs carry this)

```
Material: 4" sq tube, 101.6mm OD, 3mm wall, both ends capped with 3mm plate.
Length = chamber_L - 100   // real live formula, currently 815mm
Orientation: ONE FLAT FACE of the square pipe is parallel to the D-E face
  (this is real — it may look diamond-oriented in a Y-Z view because D-E
  itself runs at ~45deg, that is expected, not a design error).
```

Standoff (pipe centerline from the D-E face, along its outward normal
`(0.7071, 0.7071)`): `15mm air gap + 50.8mm (half of 101.6mm) = 65.8mm`.

Stopper contact point on the D-E face: **150mm from vertex D**, measured
along the D-E edge (real, confirmed position — NOT at the vertex itself,
NOT the pipe's own surface).

```
stop_pt (literal D-E contact point) = (537.40, 1175.27)
cb1_pipe_center_open   = (583.93, 1221.80)
cb1_pipe_center_closed = (286.50, 1704.90)   // = rotate(open, +90 about fc)
```

**Stopper mechanism — real, specific, do not simplify to a plain hole:**
the pipe is held by a U-shaped ("open like a wrench") prong, laser-cut as
part of the rib, 15mm material thickness at the prong itself. The prong —
NOT the pipe — makes the literal hard-stop contact with the D-E face
(real reason, stated by Janis: raw pipe stock varies lot to lot, the
laser-cut prong profile is the dimension actually under control). The pipe
sits inside the U with clearance/freedom, not a tight fit. Only ONE side of
the U touches the D-E face; the other side is a non-contact guide, ~3mm
short of the D-E surface.

---

## 4. CONSTRUCTION ORDER — MANDATORY, DO NOT DEVIATE

This exact sequence is required — real lesson from this session's sandbox
work, where building the branch geometry in the wrong order/reference frame
produced a mechanically backwards result twice:

1. **Place the fixed reference geometry FIRST, as real coordinates, before
   drawing any rib material:**
   a. Axle/pivot bore at `fc`, with the real UCP204-12 bolt pattern
   b. Grab handle rod at its CLOSED position
   c. CB1 pipe, correctly oriented flat-to-D-E, at its OPEN position
      (`cb1_pipe_center_open`, at the 150mm-from-D stopper point)
2. Draw the rib's door-side arm ONLY, in its CLOSED-state configuration
   (handle -> pivot, following/welded flush along the lid's own A-B, B-C
   faces per Section 5). Do not draw the CB1 branch yet.
3. Kinetically sweep this door-side arm alone (`door_open_deg` 0-90) and
   confirm it clears the shell before proceeding.
4. **Only then**, draw the rib material connecting the pivot to the CB1
   pipe's OPEN position placed in step 1c — the branch must physically
   reach the pre-placed, already-correct pipe location, not be positioned
   independently and hoped to align with it.
5. The rib is ONE continuous laser-cut piece. The door arm and the CB1
   branch/prong are the same physical part, built in ONE consistent
   (closed/native) reference frame, with `door_open_deg` rotating the whole
   rigid assembly together — never build part of the rib in "open"
   coordinates and part in "closed" coordinates.

---

## 5. RIB MATERIAL / PROFILE RULES

- Steel: 3mm laser-cut plate
- General/travel width: **40mm**
- Weld-contact zone specifically where the rib touches the lid along A-B,
  B-C: 70-100mm (real structural reason — flag to Janis in cc_chat_log if
  this creates a visible mismatch with the 40mm general width; a smooth
  free-form widening transition is expected and fine, not a defect)
- Minimum 15mm material ("meat") around every rod/pipe/bore hole
- Fillet every corner and direction-change — no hard edges anywhere on the
  profile
- Real 2D construction method: trace the relevant fixed-structure contour
  (ridge/D-E) and offset OUTWARD by 20mm to get the branch's own
  centerline — do not freehand a path or search for an arbitrary bulge
  point. This 20mm offset, by construction, keeps the branch's centerline
  a real 20mm clear of the traced surface everywhere along it, including at
  vertex D — confirmed in-sandbox this session (offsetting the actual
  contour is both simpler and geometrically safer than any custom-routed
  waypoint).
- The U-prong (Section 3.6) is a small, local feature at the very tip of
  this branch, reaching the short additional distance from the 20mm-offset
  contour out to the pipe's own 65.8mm standoff — it is NOT the dominant
  shape of the branch.

---

## 6. RIB X-POSITIONS (along `chamber_L`)

```
rib0_x (front side) = LID_X0 + 150   // live formula, currently 250mm
rib2_x (rear side)  = LID_X1 - 150   // live formula, currently 665mm
```
Both side ribs use the IDENTICAL profile described in Sections 3-5.

---

## 7. OUT OF SCOPE THIS ROUND — DO NOT ADD

- **Center rib** (at the midpoint between rib0_x and rib2_x, currently
  457.5mm) — for THIS round, give it the SAME profile as the side ribs
  (door arm + CB1 branch only). Its real, differentiated design (an
  additional CB2 counterbalance arm) is deferred to a future session — do
  not attempt it, do not add a stub for it.
- **CB2 / stretched counterbalance arm** — explicitly deferred.
- **Moment/force/torque physics** — do NOT recompute, re-derive, or
  second-guess the counterbalance sizing. That analysis is complete and
  belongs to Janis; see Section 9 for where it's preserved. This round is
  pure geometry + collision QA only.
- Do not alter `BBQ-chambers-v22.scad` or `BBQ-understructure-v15.scad`.

---

## 8. QA VERIFICATION — REQUIRED

- [ ] Real CGAL sweep, `door_open_deg` 0 to 90, real fine steps (5deg or
      finer) — full assembly (both side ribs + handle + axle + CB1 pipe +
      base + understructure + chambers, real `include` chain, not a
      standalone probe) — confirm `Simple: yes` and ZERO collision at every
      step, not just the two endpoints. (This project's own standing lesson
      — a straight-line branch checked only at endpoints missed a real
      mid-sweep collision with apex D twice this session; check the whole
      swept path.)
- [ ] Explicit collision check against: (a) the full fixed chamber shell —
      all faces, not just the D-E/apex-D area, (b) `trays()` from this
      file, both `tray0_angle_deg` and `tray1_angle_deg` at their default
      deployed (0) angle — real concern flagged by Janis early this
      session about handle-side tray interference, confirm it directly,
      don't assume clear.
- [ ] Confirm via real render (not assumed) that the handle remains
      reachable at both `door_open_deg=0` and `=90`.
- [ ] This is geometry/collision QA ONLY — do not attempt to validate,
      recompute, or comment on the counterbalance moment physics; explicitly
      out of scope, see Section 7.

---

## 9. REFERENCE — PRESERVE IN REPO, DO NOT LOSE

Create `docs/lid-hinge-counterbalance-calc.md` capturing the full
moment-balance analysis from this session, for the future center-rib round:

- Pivot/rotation derivation (Section 3.2-3.3 above, plus the full
  right-hand-rule sign derivation)
- Component mass & CG table: lid shell 8.51kg (A-B-C profile), handle rod
  3.24kg, axle 3.24kg, CB1 pipe 8.06kg, ribs ~3.9kg (Pass-1 estimate at
  the OLD 100mm width — flag as needing recompute at the real 40mm width)
- Torque formula used throughout: `torque = -mass * g * deltaY`, where
  `deltaY` is the horizontal (Y) distance from the pivot to the mass's own
  CG (gravity acts vertically, so only the horizontal offset does work
  about the pivot) — sign convention: positive torque favors closing,
  negative favors opening, confirmed via a direct sanity check (a hanging
  closed-position lid should resist opening, i.e. read positive).
- Full angle-sweep force-curve results: single-CB1-arm baseline (9.85kgf at
  closed easing to 4.53kgf at open, never crosses zero) vs. the hybrid
  two-arm concept explored this session.
- **Hybrid CB2 parameters found, for future center-rib work — SAVE, do not
  implement yet:** `mass2 = 2kg`, `R2 = 350mm` (radius from pivot `fc`),
  `phi2 = 80deg` (closed-state polar angle from `fc`, standard math
  convention matching Section 3.3's rotation formula) — verified via a real
  shell-clearance sweep this session, minimum 56mm clearance from the
  fixed structure across the full 0-90deg range. This is a real, checked
  starting point for the center rib, not a guess.

This doc is reference material only — it does not gate or block this
round's actual geometry work.

---

## 10. MANDATORY CLOSING

1. Prepend `cc_chat_log.md` — newest entry at top: state the real
   construction-order fix this prompt encodes, confirm the QA sweep result
   (pass/fail, real angle list), confirm the reference doc was created.
2. Archive this prompt -> `/prompts/archive/`
3. Update `knowledge.map` / `PART_MANIFEST` for the new hinge mechanism and
   the new `docs/lid-hinge-counterbalance-calc.md` reference file.
4. Bump version — `BBQ-offset-smoker-base-v6.scad`, v5 kept unchanged.
5. Commit, merge to main.
