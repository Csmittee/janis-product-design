# Construction Rules — 3. Understructure
> New 2026-07-31. Concept + generalizable rules for the understructure
> (wheels/axles/fenders/tow handle/front steering) subsystem. Same
> cross-referencing policy as the other 4 subsystem docs — points at
> `rules-bbq-fab.md`'s locked sections rather than copying them.

## Concept

The understructure carries the entire chamber+firebox assembly on 2
fixed rear wheels and a steerable front wheel/tow-handle assembly. Its
job is to translate the chamber's own fixed Z-datum chain (`GRATE_Z` →
`chamber_floor_z` → `firebox_floor_z`) down to real ground contact at
world `Z=0` for both axles — it is the one subsystem whose entire
purpose is bridging a fixed upper structure to a moving-wheel lower
structure, so unlike the chamber/firebox (built top-down from `GRATE_Z`)
the understructure is built **bottom-up from the ground** and must
absorb whatever vertical span exists between `Z=0` and the chamber's own
fixed floor. This is the concept that carries to every future variant
regardless of scale — a taller/shorter chamber changes how much span the
understructure absorbs, never whether it must absorb it.

## Generalizable rules

1. **Both axles are DIRECT CONSTRUCTION anchors to real world `Z=0`,
   never an indirect/subtractive offset.** `REAR_AXLE_Z = WHEEL_R` and
   `FRONT_AXLE_Z = REAR_AXLE_Z` (same shared anchor, keeps the vehicle
   stance level) — both CGAL-confirmed to put the wheel's own real
   bottom at literal world `Z=0`, not assumed from the formula alone.
   This is "the anchor everything else in future prompts will be
   checked against" (`SKELETON_WORKSHEET.md` PART A) — any future
   variant re-derives its own `WHEEL_R` for a different wheel size, but
   keeps this same direct-to-ground construction, never a subtractive
   `GROUND_OFFSET`-style indirection (that pattern was tried and
   retired — see `SKELETON_WORKSHEET.md` PART A's own v4 TASK 3 entry).
2. **When the chamber's own vertical datum chain shifts (a `GRATE_Z`
   change on a new variant, or a mid-project level-drop), the
   understructure absorbs it structurally — bracket heights, spacer
   lengths, T-bar lengths all move by the same real delta — while the
   wheels/axles stay fixed to true ground `Z=0`, unchanged.** Locked
   precedent: a real -100mm `GRATE_Z` drop moved
   `REAR_BRACKET_H`/`FRONT_SPACER_LEN`/`TBAR_LEN` each by exactly
   -100mm while `REAR_AXLE_Z`/`FRONT_AXLE_Z` stayed at `WHEEL_R`,
   unchanged (`rules-bbq-fab.md` history, bbq-understructure-level-drop
   round). Never "fix" a datum shift by moving the wheels instead of the
   brackets between the fixed structure and the wheels.
3. **Wheel-Radius-Derived Fender Arch Convention** (`rules-bbq-fab.md`,
   locked 2026-07-22, full derivation there — a real numeric
   bisection-solved profile, not a hand-picked curve): flat roof
   directly above the wheel + two STRAIGHT sloped shoulders (not arcs),
   solved from `WHEEL_R` via `FENDER_ARCH_TOP_CLEARANCE`,
   `FENDER_ARCH_SOLVE_SWING_DEG`, `FENDER_ARCH_BUILD_SWING_DEG`. Applies
   to ANY future `WHEEL_R` — re-solve the formula fresh for a new wheel
   size, never manually estimate or copy a prior variant's built angle.
   The profile's own true global-minimum clearance to the tire is at the
   flat roof's own underside center, NOT the shoulder ends — re-verify
   this via a live CGAL bisection for any new `WHEEL_R`/`FENDER_T`
   combination, don't assume the prior round's number/location carries
   over.
4. **A fixed bracket's own foot/mounting plate is a real solid obstacle
   for any nearby sweeping arm (steering, tow-handle fold), not just its
   own pivot bore** — checked via a capsule-vs-box distance sweep across
   the full range of motion, not visual inspection (small brackets are
   easy to miss by eye at whole-assembly render scale).
5. **Off-shelf hardware stays a simple bbox/cylinder placeholder, no
   detail** — wheels, axle, wheel-axle joint, tow handle grip, spiral-
   wire firebox handle, toggle-clamp latches, dome thermometer, drain
   valves (Construction Method, `rules-bbq-fab.md`). Don't over-model
   parts this project treats as sourced hardware.

## Current live implementation (BBQ-offset-smoker, v19)

- `BBQ-understructure-v19.scad`: `rear_axle()`/`rear_wheels()`/
  `rear_fenders()` (fixed rear pair), `front_wheel_support(steer_deg,
  handle_fold_deg)`/`front_swivel_assembly()`/`tow_handle()` (steerable
  front assembly), `rear_fender()`/`fender_arch_profile()` (Wheel-
  Radius-Derived Fender Arch).
- Live values: `WHEEL_R=228.6mm`, `REAR_AXLE_Z=FRONT_AXLE_Z=228.6mm`
  (both wheel bottoms at world `Z=0`, CGAL-confirmed).
- **Known open item, not resolved by this round**: front wheels have a
  confirmed, unresolved ~6mm CGAL collision with
  `front_bracket()`/`front_caster_plate()`/`tow_triangle()` — flagged in
  `SKELETON_WORKSHEET.md` PART A, not fixed here (out of this round's
  scope, carried forward).

## New-variant checklist

When starting a new understructure (different scale, longer/reverse-
offset chassis):
1. Fix `WHEEL_R` for the new variant's real wheel size; re-derive
   `REAR_AXLE_Z=FRONT_AXLE_Z=WHEEL_R` directly — never copy a prior
   variant's absolute axle Z.
2. Confirm both wheel bottoms land at real world `Z=0` via CGAL, not
   assumed from the formula.
3. Re-solve the fender arch's own `θ` fresh for the new `WHEEL_R`
   (bisection, not estimation) and re-verify the true global-minimum
   tire clearance via a live CGAL bisection.
4. If the new chamber's own `GRATE_Z` differs from this variant,
   propagate that delta into every bracket/spacer/T-bar length here —
   wheels/axles stay at `Z=0`, unchanged.
5. Re-run the steering/tow-handle-fold sweep against every nearby fixed
   bracket before calling the work done.
