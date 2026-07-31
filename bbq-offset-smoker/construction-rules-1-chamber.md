# Construction Rules — 1. Chamber
> New 2026-07-31. Concept + generalizable rules for the cook chamber
> subsystem, written so a future chat/cc session (on THIS product or a
> future BBQ variant) can revise chamber geometry without re-reading the
> full round-by-round history. This doc does not duplicate that history —
> it points at the locked sections in `rules-bbq-fab.md` and
> `SKELETON_WORKSHEET.md` that hold the fine print, so there is exactly
> one source of truth for each rule. If this doc and `rules-bbq-fab.md`
> ever disagree, `rules-bbq-fab.md`'s dated locked section wins — fix
> this doc to match, don't silently trust whichever was read first.

## Concept

The chamber is the primary cook vessel and the **master datum root of
the entire product**. Every other subsystem (firebox, lid/ribs,
understructure, trays) attaches to the chamber directly or transitively
through datums the chamber itself exposes — it is never the other way
around. This role is invariant across every future BBQ variant this
product line will build (round bullet capsule, square cross-section,
different scale, reverse offset) even though the chamber's own
cross-section SHAPE will change. A future variant re-derives the
chamber's own shape math fresh; it does not re-derive which role the
chamber plays in the assembly.

The chamber exposes three anchor datums that every other subsystem is
built against — see `SKELETON_WORKSHEET.md` PART A for the live current
values:
- **`GRATE_Z`** — the PRIMARY master datum (grill grate height above
  ground). Every other Z position in the product (chamber floor, firebox
  top, lid parting line, understructure absorption) derives FROM this,
  never the reverse. When starting a new variant, fix `GRATE_Z` (the
  real target cook height above ground) FIRST, then solve the chamber's
  own geometry to place the grate there.
- **`DATUM_X_REAR`** — chamber's rear/firebox wall. Firebox is
  `Parent: DATUM_X_REAR`, not an independently-set X position.
- **`DATUM_Y_CENTER`** — chamber's lateral centerline. Firebox and
  chimney are both `Parent: DATUM_Y_CENTER`.

## Generalizable rules

1. **One shared 2D cross-section profile module, reused everywhere it's
   needed** (chamber wall, both end caps, any passage cut) — never
   independently re-derived per surface. Current implementation:
   `true_octagon_profile()`. A round bullet capsule variant's equivalent
   would be a plain circle function reused the same way — the RULE
   (one profile, one source of truth) carries over, the shape itself
   does not.
2. **A cross-section shape parameter derived from a bounding
   dimension must be a computed formula, never a locked decimal
   literal.** Locked example: `chamfer = chamber_W / (2 + sqrt(2))` for
   a regular octagon inscribed in a `chamber_W`-square (Regular Octagon
   Requirement, `rules-bbq-fab.md`, locked 2026-07-16) — `chamfer` was
   wrong for 7 versions (v1-v7) because it was a round-number literal
   instead of this formula. A cylindrical variant's own equivalent: wall
   thickness/radius relationships must stay a formula off the one real
   free parameter (radius), never two independently-set numbers that can
   drift out of a true circle.
3. **Dual End-Cap Independence Convention** (`rules-bbq-fab.md`, locked
   2026-07-21, full Rule 1/Rule 2 text there — do not re-derive, read it
   before touching an end cap): the outer shell's own end cap and the
   inner fire-holding entity's own end cap are built independently, with
   a real air gap between them continuing the side-wall insulation gap
   across the back too. Outer shell end cap tucks under the chamber body
   >=50mm, ONE continuous hollow surface (never solid fill). Inner end
   cap reuses the SAME shared passage-hole profile as the chamber wall's
   own cut — never an independently-derived approximation of it. Run the
   **Dual End-Cap QA Simulation Checklist** (`rules-bbq-fab.md`, same
   locked section) on any round that touches this territory — a clean
   CGAL manifold/collision result is necessary, not sufficient; it says
   nothing about whether the shape is the RIGHT shape.
4. **Standing Orientation Convention** (`rules-bbq-fab.md`, locked
   2026-07-14): facing the smoker, exhaust end is always the user's
   LEFT, firebox end always the user's RIGHT, lid always opens TOWARD
   the user. This is a customer-facing convention, not a geometry
   accident — preserve it in every future variant regardless of chamber
   shape or scale.
5. **Any chamber-profile vertex/point used as a fixed-structure
   reference by ANOTHER subsystem (hinge pivot, rib anchor, bracket
   mount) must be numerically checked against the real fixed/lid parting
   line** (`RIDGE_SPLIT_Y` or equivalent), never assumed correct from
   its name or rough sketch position — this exact mistake (picking a
   vertex by visual proximity instead of an explicit numeric check)
   caused 2 separate real bugs across the lid-hinge build (see
   `rules-bbq-fab.md`'s Three-Rib Lid Counterbalance System section). A
   round chamber has no vertices at all — the equivalent check becomes
   "is this angle/point on the tangent circle actually on the fixed
   side of the real parting plane," same principle, different geometry.

## Current live implementation (BBQ-offset-smoker, v20/v26)

- `BBQ-chambers-v26.scad`: `true_octagon_profile()` (cross-section),
  `chamber_shell()` (the built solid), `firebox_passage_profile()`
  (shared passage cut, reused by the firebox's own end cap).
- Live datum values: `GRATE_Z=900mm`, `chamber_floor_z=671.335mm`
  (derived, `= APEX_A_Z - chamfer`), `DATUM_X_REAR` (chamber_L=915mm),
  `DATUM_Y_CENTER=305mm`, `chamfer=178.665mm` (from the regular-octagon
  formula above at `chamber_W=610mm`).

## New-variant checklist

When starting a genuinely new chamber shape (round bullet capsule,
different scale, etc.):
1. Fix the real target `GRATE_Z` first (grill height above ground) —
   this is a product-owner decision, not derived from chamber geometry.
2. Write the ONE shared cross-section profile module for the new shape,
   parametric off a single computed formula (never a locked literal).
3. Re-derive `chamber_floor_z` from `GRATE_Z` through the new profile's
   own apex/top-of-wall relationship (the formula chain changes, the
   direction — grate drives chamber, not the reverse — does not).
4. Re-run the Dual End-Cap QA Simulation Checklist against the new
   shape before calling any end-cap work done.
5. Confirm the Standing Orientation Convention still holds (exhaust
   left / firebox right / lid toward user) before final review.
