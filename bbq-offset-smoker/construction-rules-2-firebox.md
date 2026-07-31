# Construction Rules — 2. Firebox
> New 2026-07-31. Concept + generalizable rules for the firebox
> subsystem. Same cross-referencing policy as the chamber doc
> (`construction-rules-1-chamber.md`) — this doc points at
> `rules-bbq-fab.md`'s locked sections rather than copying them, so
> there is one source of truth. Read the chamber doc first; the firebox
> attaches to the chamber, not the reverse.

## Concept

The firebox is the fire-holding subsystem, welded to the chamber's own
rear wall (`DATUM_X_REAR`). It is built as **two independent welded
assemblies that never share a Parent chain**: the outer shell (the
product's visible sheet-metal housing) and the inner fire-holding entity
(currently a cylinder — a future square-firebox variant makes this a
square duct instead, per Janis's own stated roadmap). The two assemblies
touch nowhere except through the chamber's own shared passage cut — a
real air gap runs between them on every face, including the end caps,
continuing the same insulation gap that runs along the side walls. This
two-assembly, air-gapped structure is the part of the firebox concept
that is invariant across every future shape; only the inner entity's own
cross-section shape changes between variants.

## Generalizable rules

1. **Sizing Formula** (`rules-bbq-fab.md`, standing rule — reuse for
   ALL future firebox/window/chimney calcs, do not re-derive per
   session):
   ```
   firebox_volume = chamber_volume / 3
   window_area    = firebox_volume * 0.008
   intake_area    = firebox_volume * 0.003
   chimney_volume = firebox_volume * 0.05   (diameter chosen for "fat
     over long"; built length by standard horizontal-smoker practice
     ~30-40in, NOT the raw volume/length formula; chimney top must stay
     <=2.5m from ground)
   ```
   Source: feldoncentral.com/bbqcalculator.html — external reference,
   not independently re-derived by cc. Re-run this formula fresh off
   the NEW chamber's own volume for any future variant; never copy a
   prior variant's absolute numbers.
2. **Dual End-Cap Independence Convention applies to the firebox's own
   end caps exactly as it does to the chamber's** (full rule text lives
   once, in `construction-rules-1-chamber.md` / `rules-bbq-fab.md`, not
   repeated here). The inner entity's end cap reuses the chamber wall's
   own shared passage-profile cut — never an independently-derived
   approximation, even when the inner entity's shape changes (circle
   today, square in a future variant).
3. **Zero-contact is mandatory and CGAL-verified, not assumed from
   disjoint-looking geometry.** The outer shell and inner entity must
   report a real `intersection()` EMPTY between them at every relevant
   face — confirmed each round this project has touched the firebox,
   never skipped because "they're obviously separate parts."
4. **Firebox position is derived, not independently set.** It is
   `Parent: DATUM_X_REAR` (chamber's rear wall, the chamber's own real
   weld-overlap position) and `Parent: DATUM_Y_CENTER` (centered on the
   chamber's own width) — see `SKELETON_WORKSHEET.md` PART A. A future
   variant re-derives these from its own chamber's rear wall/centerline,
   never hardcodes an absolute X/Y.
5. **Door**: 3mm joggle-step joint at the opening edge for flush closure
   (material thickness = joggle = 3mm) — this project's own standard
   door-edge convention, applies to every access panel product-wide, not
   just the firebox door.
6. **Sub-part toggles**: firebox's own DEBUG TOGGLES block exposes 4
   independent sub-part toggles (fire cylinder, fire cylinder end cap,
   outer shell, outer shell end cap) beneath the single `show_firebox`
   gate — keep this pattern (one master gate + independent sub-toggles)
   for any future firebox rebuild; it's what makes isolated QA/render
   checks possible per Module Isolation Testing (`rules-codes.md`).

## Current live implementation (BBQ-offset-smoker, v26)

- `BBQ-chambers-v26.scad`: `firebox(firebox_door_open_deg)` (top-level
  assembly), `fire_cylinder()` (inner entity, currently circular,
  456mm dia), `outer_shell()` (outer housing), `firebox_door()` (3mm
  joggle door), `firebox_passage_profile()` (shared cut, defined once
  and reused by both the chamber wall and the inner entity's end cap —
  see chamber doc).
- Firebox interior length `FIREBOX_L=580mm`; outer shell built as a true
  cube (all 3 dims equal) per the v15 rebuild.

## New-variant checklist

When starting a new firebox shape (square firebox, different scale):
1. Re-run the Sizing Formula fresh off the new chamber's own
   `chamber_volume` — never reuse a prior variant's absolute numbers.
2. Build the new inner entity's own cross-section profile as its own
   module (square, in the stated future case) — keep it reusing the
   SAME passage profile the chamber wall itself cuts (Rule 2 above).
3. Re-run the Dual End-Cap QA Simulation Checklist
   (`rules-bbq-fab.md`) against the new shape.
4. Re-verify zero-contact between the outer shell and inner entity via
   a real `intersection()` check before calling the work done.
5. Confirm the firebox still derives its position from `DATUM_X_REAR`/
   `DATUM_Y_CENTER` rather than an independently-set literal.
