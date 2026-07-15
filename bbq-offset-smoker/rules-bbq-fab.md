# BBQ Offset Smoker — Fabrication Rules
> Version 1.2 — 2026-07-16
> Changes: bbq-chambers-v8-regular-octagon-continuous-channel. New
> "Regular Octagon Requirement" section added (locks `chamfer` to the real
> `chamber_W/(2+sqrt(2))` formula, not an arbitrary decimal — the prior
> 150mm value, locked since v1, was never actually derived this way and
> produced a non-regular octagon, correctly flagged by Janis as visually
> exaggerated). Detail addition, not new document structure — X.Y bump.
> Previous: 1.1 — 2026-07-14
> Changes: bbq-chambers-v3-closure-exhaust-resize-lid-mirror. New
> "Standing Orientation Convention" section added (locks exhaust=left/
> firebox=right/lid-toward-user when facing the smoker, confirmed against
> the v3 lid mirror's actual rotation direction — real geometry, not
> assumed) — a previously-undocumented convention this session made
> explicit so it's never re-guessed. Detail addition, not new document
> structure — X.Y bump.
> Previous: 1.0 — 2026-07-13

Technical/construction only — NOT customer-facing (that's
design_scope_of_work_rule.md). Read by cc before any BBQ SCAD task.

---

## Construction Method
- Main chamber body: single flat blank, multi-bend press-brake (minimize
  weld seams vs. 8 separate flat panels).
- All doors/access panels: 3mm joggle-step joint at opening edge for
  flush closure (material thickness = 3mm, joggle = 3mm).
- File split: BBQ-chambers-v1.scad / BBQ-understructure.scad /
  BBQ-offset-smoker-base-v1.scad (base includes understructure, which
  itself includes chambers — handles final positioning; see that file's
  own header for why chambers isn't included a second time directly).
- Flat panels: design as 2D polygon -> linear_extrude for 3D view; same
  2D geometry is the DXF export source for laser cutting.
- Formed panels (doors, end-caps, lid): flat blank + marked fold line,
  bend allowance is supplier-verify, not computed here. In this repo's
  3D model, formed panels are represented as thin uniform-thickness
  shells/flat-panel assemblies (cube()-based, per rules-codes.md's own
  preference) — geometrically simplified vs. a true multi-plate bend
  model, since bend allowance itself is explicitly out of scope here.
- Standard steel blank: 1250x2500mm (panels at this chamber size fit with
  no nesting/splitting needed).
- Off-shelf placeholders (simple bbox/cylinder only, no detail): wheels,
  axle, wheel-axle joint, tow handle, spiral-wire firebox handle, toggle
  clamp latches, dome thermometer, drain valves.

## Sizing Formula (standing rule, reuse for all future firebox/window/
chimney calcs on this product, do not re-derive per session)
```
firebox_volume = chamber_volume / 3
window_area    = firebox_volume * 0.008
intake_area    = firebox_volume * 0.003
chimney_volume = firebox_volume * 0.05   (diameter chosen for "fat over
  long" per Janis; built length by standard horizontal-smoker practice
  ~30-40in, NOT the raw volume/length formula; chimney top must stay
  <= 2.5m from ground)
```
Source: feldoncentral.com/bbqcalculator.html, verified against its own
worked example this session (per the source prompt — cc has not
independently re-verified this external reference).

## OPEN FLAG
`firebox_drop = 200mm` is Claude Web's assumption, not yet Janis's
explicit number. Confirm or correct after first render — see
BBQ-chambers-v1.scad's own header and design_scope_of_work_rule.md.

## Standing Orientation Convention (locked 2026-07-14)

When a person faces the smoker (the customer/user-facing view):
- The EXHAUST end is always on their LEFT.
- The FIREBOX end is always on their RIGHT.
- The LID/DOOR always opens TOWARD the user (the near side, facing them)
  — never the far side.

In world coordinates (per SKELETON_WORKSHEET.md's MASTER ORIGIN):
exhaust = DATUM_X_FRONT (X=0), firebox = DATUM_X_REAR (X=chamber_L).
"Toward the user" = **the side nearer Y=0** — confirmed by the v3 lid
mirror's own real geometry, not assumed: the lid was moved from the
Y=chamber_W side (v2) to the Y=0 side (v3 TASK 3) specifically so it
opens toward the user, and the rotation direction was empirically
verified (CGAL bounding-box check) to swing toward NEGATIVE Y — i.e.
away from the fixed shell, toward and past Y=0. This line reflects the
real, built, verified state of BBQ-chambers-v3.scad, not a draft.

This convention applies to ALL future BBQ product work — do not
re-derive or re-ask per session.

## Regular Octagon Requirement (locked 2026-07-16)

`chamfer` is NOT a free/arbitrary dimension — the chamber's octagon cross-
section is required to be REGULAR (all 8 sides equal length). For an
octagon inscribed in a `chamber_W`-square cross-section (chamber_W ==
chamber_H, this product's own case), the real constraint is:
```
chamber_W - 2*chamfer = chamfer * sqrt(2)
chamfer = chamber_W / (2 + sqrt(2))
```
`chamfer` was locked at 150mm from v1 through v7 — a round-number pick,
never actually derived from this formula, and it does NOT produce a
regular octagon (4 sides at 310mm, 4 at 212.13mm). CORRECTED v8 to the
real formula (chamfer=178.665mm at the current chamber_W=610mm) — see
BBQ-chambers-v8.scad's own header for the full derivation, including the
resulting GRATE_Z datum-chain change (GRATE_Z is now derived from
`chamber_floor_z + chamfer`, not the other way around).

This convention applies to ALL future BBQ chamber work — if `chamber_W`
or `chamber_H` ever change, `chamfer` must stay computed from this
formula, never re-locked to a decimal literal.

## v1 Judgment Calls (technical, cc-made, flagged per R-009/general
duplication+ambiguity discipline — see BBQ-chambers-v1.scad header and
cc_chat_log.md for full detail)
- Lid opening extent (`LID_MARGIN_FRONT`/`LID_MARGIN_REAR`) is not in the
  source prompt — chosen so the fixed chimney mount sits on solid,
  lid-independent shell material.
- Chimney mounts on the FIXED shell (not the lid) for the same reason —
  opening the lid never disturbs the flue.
- Real hinge/fold clearances found via CGAL and fixed this session (not
  in the source prompt, since they're only discoverable by rendering):
  firebox door hinge-line exact-tangency (HINGE_GAP), lid hinge clearance
  past the fixed rear-margin shell (HINGE_CLEARANCE), chimney fold pivot
  height (FOLD_PIVOT_Z), counterbalance lever standoff (LEVER_CLEARANCE).
