# BBQ Offset Smoker — Fabrication Rules
> Version 1.7 — 2026-07-24
> Changes: bbq-lid-hinge-three-rib-v2. New "Three-Rib Lid Counterbalance
> System" section added — locks the reusable STRUCTURAL pattern behind
> this round's real lid hinge/handle/counterbalance mechanism (3 identical
> ribs, ONE counterbalance arm first, real Python moment-balance physics
> with a round-trip coordinate self-check, combined stopper/holder,
> minimum-not-fixed rib profile, fixed-references-first construction
> order, 20mm apex-clearance rule) — generalized so a future product
> line's own lid mechanism can be requested and built in ONE prompt
> instead of the multi-session derivation this one took. Cross-referenced
> from design_scope_of_work_rule.md's own counterbalanced-lid feature
> entry, per this file's existing cross-reference convention. Detail
> addition, not new document structure — X.Y bump.
> Previous: 1.6 — 2026-07-22
> Changes: bbq-rear-fender-arch-redesign. New "Wheel-Radius-Derived Fender
> Arch Convention" section added — locks the rear fender's real wheel-arch
> cross-section (flat roof + two straight sloped shoulders) as a reusable,
> `WHEEL_R`-parametric formula (not today's specific numbers), per Janis's
> own explicit request that future builds with different wheel sizes must
> re-derive this automatically. Replaces the prior flat-rectangular-plate-
> with-curve-down-zone fender design (BBQ-understructure-v10/v12), which
> had no reusable formula of its own. Detail addition, not new document
> structure — X.Y bump.
> Previous: 1.5 — 2026-07-21
> Changes: Rule 1 clarified (docs-only, zero .scad files touched) — a
> real defect found via Janis's own direct visual check: the outer
> shell's own tuck-under flange had been built as a SOLID block since v14
> (never revisited), creating two redundant wall-like surfaces instead of
> one real end cap capping a hollow tube. Rule 1 now explicitly states the
> tuck-under extension itself must be HOLLOW (wall_t thick), never a
> solid fill, regardless of "stronger structural support" reasoning.
> Detail addition, not new document structure — X.Y bump.
> Previous: 1.4 — 2026-07-21
> Changes: standardization follow-up to the Dual End-Cap Independence
> Convention (docs-only, zero .scad files touched) — Janis's own request,
> after running a manual 4-step QA simulation against unmerged PR #138
> (v17) caught a real Rule 1 violation that CGAL's own "Simple:yes, no
> collision" checks had NOT caught (manifold-clean is not the same as
> rule-compliant). New "Dual End-Cap QA Simulation Checklist" section
> added — transcribes Janis's own 4-step manual method verbatim as a
> standing, numbered checklist, so any future firebox/chamber round runs
> it BEFORE calling the work done, instead of it existing only in a chat
> transcript. Detail addition, not new document structure — X.Y bump.
> Previous: 1.3 — 2026-07-21
> Changes: bbq-governance-dual-endcap-convention (docs-only, zero .scad
> files touched). New "Dual End-Cap Independence Convention" section
> added — locks the standing architectural relationship between a
> firebox/chamber assembly's TWO independent end-cap partitions (the
> outer shell's own end cap, and the inner fire-holding entity's own end
> cap), found necessary during the v15/v16/v17 build-and-fix cycle (real
> visible-hole/mismatched-passage/wall-inside-chamber/missing-material
> defects, each traced back to this relationship being re-derived
> ad-hoc per round instead of written down once). Applies to ALL future
> BBQ firebox/chamber work, not just this round. Detail addition, not new
> document structure — X.Y bump.
> Previous: 1.2 — 2026-07-16
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

---
**Dual End-Cap Independence Convention (locked 2026-07-21)**

Every BBQ firebox/chamber assembly has TWO independent end-cap
partitions — the outer shell's own end cap, and the inner fire-holding
entity's own end cap (duct, cylinder, or whatever shape a future round
uses). They are built independently, do not share geometry, and a real
air gap exists between them (the same gap that forms the insulation
space along the assembly's side walls continues across the back, at
the end caps, too — not just the sides).

**Rule 1 — Outer shell end cap:** constrained to ONLY its own square/
cube projection (matching the outer shell's own cross-section) in
every zone EXCEPT the top part, which follows the chamber's own real
profile (octagon or whatever profile the chamber body uses — this
convention doesn't hardcode "octagon", it means "whatever
`true_octagon_profile()` or its future equivalent actually is"). This
end cap must tuck under the chamber body at a MINIMUM of 50mm. The
face is ONE CONTINUOUS SURFACE from the tuck zone down to the bottom —
no step, no zone-clipped transition between two differently-derived
shapes. **The tuck-under extension itself is HOLLOW (wall_t thick,
same real construction as the rest of the outer shell) — NEVER a solid
fill**, even in the name of "stronger structural support": a solid
block there is a real, standing inconsistency with this project's own
`rules-bbq-fab.md` Construction Method (formed panels are thin uniform-
thickness shells, not solid billets) and produces two redundant wall-
like surfaces (the solid block's own far face, plus the real end-cap
plate stacked against it) where there must be exactly one real cap
closing a genuinely hollow tube (found the hard way: v14 through v19 all
built this extension solid, unquestioned, until a direct visual check
found the redundant wall).

**Rule 2 — Inner (true firebox) end cap:** whatever its own shape
(circle, square, or any future entity shape), it attaches to the
chamber's own end-cap face. It does NOT influence, derive, or
re-shape the passage in any way — the passage is defined SOLELY by
the hole already cut through the chamber wall itself, and the inner
end cap must cut the EXACT SAME shared hole-profile, not an
independently-derived approximation of it. Above that shared cut, the
end cap's own top zone follows the chamber's real profile (same
"whatever the chamber's shape is" language as Rule 1); everywhere else,
it follows its own entity's real shape (circle for a cylinder, square/
rectangle for a duct, etc.).

**Why this exists**: found necessary during the v15 square-shell/
cylinder-firebox review — two independently-derived hole shapes on the
chamber wall vs. the inner cylinder's end cap produced a real
mismatched/visible defect; conflating this convention with the
separate "flat full-height side-wall" fix (a different, earlier
convention, for a different part of the assembly) produced a second,
distinct real defect on the outer shell's own end cap. This section
applies to ALL future BBQ firebox/chamber work — any prompt describing
a NEW fire-holding shape or a NEW outer shell shape must build both end
caps per this rule, not re-derive the relationship from scratch, and
must implement the passage/hole cut as ONE shared 2D profile module
reused across every surface it passes through (chamber wall, inner
end cap, and any other assembly it crosses) — never independently
re-derived per-surface.
---

---
**Dual End-Cap QA Simulation Checklist (locked 2026-07-21)**

WHY THIS EXISTS: a real, CGAL-confirmed "Simple: yes, no collision" result
is NOT the same thing as "satisfies the Dual End-Cap Independence
Convention above." Round v17 was manifold-clean and passed every
collision/containment probe run against it, and STILL failed Rule 1 —
CGAL only proves a shape is well-formed and doesn't intersect what it
shouldn't; it says nothing about whether the shape is the RIGHT shape.
Janis's own manual 4-step walkthrough caught what the CGAL suite alone
did not. This checklist transcribes that method verbatim so it is a
standing, repeatable step — run it, every round, for ANY change that
touches a firebox/chamber's own end-cap or passage geometry (new entity
shape, new outer shell shape, or a fix to either) — BEFORE reporting the
work done, not something re-derived or improvised per round.

1. **Draw the inner (true firebox) entity** at its own real diameter/
   length, pushed to touch the chamber's own end-cap face at the
   location where the passage hole is already cut through the chamber
   wall.
2. **Check the inner entity's own end cap, at the back, under the
   chamber**: does it seal the entity's own space with NO hole left
   except the one shared passage cut (Rule 2)? Confirm it is the SAME
   shared 2D profile module as the chamber wall's own cut, not an
   independently-derived approximation.
3. **Draw the outer shell** at its own real dimensions, plus its own
   real tuck-under length on the length axis (Rule 1's own minimum
   50mm), pushed to touch the chamber's own end-cap face above/around
   the inner entity — confirm its own real top lands at the chamber's
   own fixed top datum.
4. **Check UNDER the chamber, on the outer shell's own end-cap panel**:
   does it close every real gap — top zone MEETS the chamber's own real
   profile (not clipped short of it, not avoiding it by staying its own
   native shape), bottom zone is the shell's own simple native cross-
   section, ONE continuous surface, no step? This is the step v17 failed
   — re-check it specifically, do not assume a shape that dodges known
   bugs automatically satisfies this step too.

Mechanical CGAL/STL probes that must accompany Step 4 specifically
(these are what actually catch the failure modes found across v16/v17/
v18, not general-purpose sanity checks — see rules-codes.md's own "Dual
End-Cap Footprint Pattern" for the construction these probes verify):
- `intersection()` of the outer shell vs. the chamber's own real hollow
  interior cavity (shrunk by a real margin, not just an exact-touch
  test) — must be EMPTY.
- `intersection()` of the outer shell vs. the chamber's own real wall
  material (the true octagon profile minus its own wall-thickness
  offset) — must be NON-EMPTY (real structural contact, not a floating
  part).
- A real STL/bounding-box probe of the outer shell's own end-cap
  footprint and of the assembled outer shell itself — confirm neither
  extends past the shell's OWN real physical height range (the failure
  mode that shipped inside this same round's own first attempt at the
  Rule 1 fix, caught only because this specific probe was run before
  presenting the result).

This section applies to ALL future BBQ firebox/chamber work — run it
against ANY new prompt/round that touches this territory, and treat a
clean CGAL manifold/collision result alone as necessary, not sufficient.
---

**Wheel-Radius-Derived Fender Arch Convention (locked 2026-07-22)**

Applies to ANY future rear-wheel fender build on this project, for ANY
`WHEEL_R` — this is a reusable, parametric formula, not a one-off number
set. A future wheel-size change re-solves this formula fresh; it must
NEVER be manually estimated or copy-pasted with a guessed replacement
angle for a different `WHEEL_R`.

Real cross-section: a flat roof (Zone C) directly above the wheel, with
two straight sloped shoulders (Zone A/B) — NOT arcs — descending from
each roof edge. Extruded uniformly along the fender's own outward
(world Y) reach (a plain `linear_extrude()`, since the cross-section
itself does not change shape along that extrusion).

Named tuning constants (declare as real top-level constants, never
inline literals):
- `FENDER_ARCH_TOP_CLEARANCE` — real mm the flat roof sits above wheel
  center: `roof_z = WHEEL_R + FENDER_ARCH_TOP_CLEARANCE`
- `FENDER_ARCH_SOLVE_SWING_DEG` — reference swing angle used ONLY to
  solve for the roof half-angle (Step 1 below), never the built angle
- `FENDER_ARCH_BUILD_SWING_DEG` — the REAL swing angle the A/B shoulders
  are built at, strictly less than `FENDER_ARCH_SOLVE_SWING_DEG` (pulls
  the real built edge back from the solve-swing's own tangent reference,
  for margin)

**Step 1 — solve for the roof half-angle θ.** No closed form exists; a
real numeric solve is required (bisection or equivalent real iterative
method — do not hardcode a literal angle for a new `WHEEL_R`):
```
find θ such that:
  (WHEEL_R + FENDER_ARCH_TOP_CLEARANCE) * sin(θ + FENDER_ARCH_SOLVE_SWING_DEG)
    / cos(θ)  =  WHEEL_R
```
The left-hand side, at any θ, is `R_tip * sin(θ + FENDER_ARCH_SOLVE_SWING_DEG)`
where `R_tip = (WHEEL_R + FENDER_ARCH_TOP_CLEARANCE) / cos(θ)` — i.e. the
real X-coordinate of a point at radius `R_tip` from the wheel center, at
angle `(θ + FENDER_ARCH_SOLVE_SWING_DEG)` from vertical. The equation
finds the θ where that specific point lands exactly on the wheel's own
real vertical tangent line (`X = WHEEL_R`) — a safe, conservative
reference line (always outside or exactly touching the real wheel
circle). The function is monotonically increasing in θ over a real
search range (e.g. 5°–45°), confirmed via echo before implementing —
a real sign-based bisection converges reliably; verified in
BBQ-understructure-v15.scad to 24.3358° at `WHEEL_R=228.6mm` against
this convention's own self-check (θ≈24.3°).

**Step 2 — construct the profile from the solved θ**:
- Roof height: `roof_z = WHEEL_R + FENDER_ARCH_TOP_CLEARANCE`
- Roof half-width: `roof_half_w = roof_z * tan(θ)`
- Roof tip radius from wheel center: `R_tip = roof_z / cos(θ)`
- Zone C (roof): flat segment from `(-roof_half_w, roof_z)` to
  `(roof_half_w, roof_z)` (local X-Z, relative to wheel center)
- Zone A/B (shoulders): STRAIGHT lines (not arcs) from each roof tip to
  a point at the SAME radius `R_tip` (not re-solved), at angle
  `(θ + FENDER_ARCH_BUILD_SWING_DEG)`:
  `end_x = R_tip * sin(θ + FENDER_ARCH_BUILD_SWING_DEG)`,
  `end_z = R_tip * cos(θ + FENDER_ARCH_BUILD_SWING_DEG)`

**Real, verified finding on where the true minimum clearance actually
occurs** (BBQ-understructure-v15.scad, confirmed via a live CGAL
bisection, not assumed from the formula alone): the profile's own
GLOBAL minimum clearance to the tire is NOT at the shoulder ends — it
is at the flat roof's own UNDERSIDE center, equal to
`FENDER_ARCH_TOP_CLEARANCE` minus the panel's own real thickness (e.g.
100mm − 4mm = 96mm at `WHEEL_R=228.6mm`, panel thickness 4mm). The
`FENDER_ARCH_SOLVE_SWING_DEG`/`FENDER_ARCH_BUILD_SWING_DEG` gap governs
a DIFFERENT, separate real quantity — how far the shoulder's own built
endpoint pulls back (in X) from the wheel's vertical tangent line, NOT
the profile's own overall closest-approach margin. Any future build
using this convention must independently CGAL-verify its own real
global minimum (a bisected radius-scan test against the actual tire,
same method as BBQ-understructure-v15.scad's own verification) — do not
assume the roof-underside location or the 96mm number carries over to a
different `WHEEL_R`/`FENDER_T`/`FENDER_ARCH_TOP_CLEARANCE` combination.

This convention applies to ALL future BBQ rear-fender work on this
product — do not re-derive the construction technique from scratch, and
do not skip the real numeric solve for a new wheel size.
---

**Three-Rib Lid Counterbalance System (locked 2026-07-24)**

Applies to ANY future product line's lid hinge/counterbalance mechanism —
this is a reusable STRUCTURAL pattern, not this round's specific numbers.
A future product's own chamber geometry produces its own real values via
the same method.

- **Pattern**: 3 identical ribs (not a differentiated center rib) — each
  carries three real control points: a grab handle, a pivot axle, and a
  single counterbalance arm (CB1). Start with ONE counterbalance arm;
  only add a second (differentiated on one rib) if a real moment-balance
  calculation proves one arm cannot meet the target force range — do not
  default to a two-arm design as a first attempt.
- **Physics method**: real Python moment-balance model (not OpenSCAD),
  using each mass's real CG position and a rotation-formula round-trip
  self-check (rotate a locked point into the other frame, then back, and
  confirm you recover the original exactly) to catch coordinate-inverse
  errors before any number is locked. Target the force at BOTH extremes
  (closed and open) as the primary constraint — a mid-sweep sign change
  is expected, not a defect, as long as both endpoints stay within a
  comfortable range confirmed with the product owner.
- **Combined stopper/holder**: the counterbalance pipe's own U-prong
  holder doubles as the hard stop — a single localized contact point/edge
  against the fixed structure, landed wherever the pipe's own
  already-solved position makes it free (material-efficient), not at an
  arbitrarily separate location. The holder wraps only HALF the pipe's
  own circumference (a real clearance hole for the pipe, plus an
  additional open-side material removal) — never a full collar — and its
  two sides are not required to be the same length.
- **Rib profile**: minimum width, not fixed — grows only at the real
  transition zones (weld-contact, handle-wrap, counterbalance-branch),
  connected by smooth free-form curves (a hull-of-circles/"capsule chain"
  construction reuses this project's own "hull() for rounded shapes"
  coding rule and gives continuous fillets for free). Ridge/top edge gets
  one continuous large-radius arc spline. **A rib blade lying in the
  hinge's own rotation plane (not a flat bracket bolted face-on to a
  wall) satisfies a "weld-contact zone width" spec through the WELD RUN'S
  OWN LENGTH along the wall, not by ballooning the blade's perpendicular
  half-width there** — a real, found-this-round distinction: a wide
  radius at a weld point that also sits near a wall shared with OTHER
  hardware (e.g. a folding tray on the same face) needlessly intrudes
  into that other hardware's own operating envelope. Check this before
  widening any near-wall zone "for weld strength."
- **Construction order**: fixed references (pivot axle position, handle
  bore position, counterbalance-arm position at its OPEN/resting extreme)
  placed first as real coordinates; the door-side arm built and
  kinetically swept-tested BEFORE the counterbalance branch is drawn;
  everything in ONE consistent closed-state/native reference frame — a
  point specified in the OPEN frame (because that is the natural frame
  for a stop/rest condition) must be converted to the native frame via
  the SAME round-trip rotation functions used for the physics check
  above, never freehanded.
- **Convex-corner clearance is NOT automatic from a straight offset**: if
  the counterbalance branch's own path is built by offseting a straight
  reference edge outward by some margin, that margin is only guaranteed
  along the FLAT part of the edge — at any convex corner the reference
  contour turns through, a straight offset segment can swing back inside
  the intended margin (confirmed this round: a naive straight branch
  spine passed within 0.01mm of a real fixed corner it was supposed to
  clear by 20mm). Trace a real arc (sampled, each point round-trip-
  converted to native frame) around any such corner instead of a single
  straight waypoint.
- **Apex/corner clearance rule**: minimum 20mm real clearance, worst
  case, across the FULL swept rotation (fine steps, not just the two
  endpoints) — verify via a real numeric sweep (Python or equivalent),
  not assumed from the construction method alone.
- **Check shared-face interference explicitly, do not assume disjoint
  Y/X territory protects you**: if this mechanism shares a face with
  other kinetic hardware (trays, shelves, doors), sweep the FULL
  combinatorial space (this mechanism's own angle × each other
  mechanism's own angle) — a mechanism whose OWN geometry review looks
  clean in isolation can still physically conflict with adjacent hardware
  at their shared wall/weld zone, even at each mechanism's own default
  rest state, not only during simultaneous motion. If found and not
  resolvable within the round's own stated scope (e.g. the interfering
  hardware is frozen/DO NOT TOUCH), flag it explicitly as a real,
  unresolved cross-subsystem conflict — do not report the sweep as clean.

---

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
