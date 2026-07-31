# BBQ Offset Smoker — Fabrication Rules
> Version 1.20 — 2026-07-31
> Changes: bbq-lid-hinge-v17. TWO new locked lessons, both from Janis's
> own direct teaching this round: (1) **A rotation direction/sign
> convention must be confirmed by an actual colored render, never by
> sign-reasoning alone.** v16 built the tray's stow direction from
> abstract "CCW=negative" reasoning and got it backwards (the tray
> folded UP past apex A instead of down toward the ground) — the bug
> only surfaced once a real render with distinct, correctly-rendering
> colors was produced (an earlier attempt used a colorscheme that
> silently dropped explicit `color()` calls in full CGAL `--render`
> mode, masking the direction error). Any hinge/fold direction gets a
> real render check before being called correct, full stop — this
> project's own "verify against real geometry" rule applies to
> DIRECTION, not just position. (2) **Two rigid, same-width bars sharing
> one pivot point cannot fold together without interpenetrating unless
> offset in DEPTH, not in-plane.** Confirmed via a real rectangle-overlap
> (SAT) simulation before applying it: an in-plane offset between 2
> pivots doesn't remove the collision, it only relocates it (can make it
> worse at some angles); only a depth (out-of-plane) split works,
> because it gives the bars a genuine separating axis regardless of
> their in-plane angle — the same reason real hinges and scissors stack
> their 2 leaves instead of building them coplanar. Applies to ANY
> future 2-bar/lap-joint mechanism in this project, not just this tray
> link. Detail addition, not new document structure — X.Y bump.
> Previous: 1.19 — 2026-07-30
> Changes: bbq-lid-hinge-v16. New locked lesson: **a "gap" constant
> shared by two rigidly-linked-but-not-identical geometries (a fixed
> anchor point and a rotating plate riding the SAME pivot) is not a
> free knob you can widen to buy clearance for one of them without
> checking the other.** Found while chasing a real, disclosed near-full-
> stow collision between the folding tray link's slider and the folded
> tray plate: widening `HINGE_PIVOT_OFFSET` (the tray hinge's own real
> knuckle standoff) from 5mm to 15mm, expecting more clearance, instead
> made the collision WORSE at the same angle — because that constant
> sets BOTH the folded plate's own resting position AND (via the shared
> pivot) where the link's rotating `tt` pin lands, and the two moved
> together, not apart. The fix for a real tight-tolerance finding like
> this needs the same live-sweep verification as any other geometry
> change, not an assumption that "more clearance" is monotonic in a
> single constant. Detail addition, not new document structure — X.Y
> bump.
> Previous: 1.18 — 2026-07-30
> Changes: bbq-lid-hinge-v13. TWO new locked lessons, both from Janis's
> own direct catches: (1) **Process discipline**: several real rounds in
> a row (sanitization, CB1 pipe restore, moment analysis, tray
> relocation) were all made in place to a file whose name never changed
> — a real violation of this project's own "always create a new version
> file, never overwrite in place" rule, caught only because Janis
> tracks file revisions to keep separate chat sessions aligned. A new
> round of REAL changes (not a pure pointer bump) means a new version
> file, every time, no exceptions for "it's a small tweak." (2)
> **Rotated cross-sections must be built in the SAME local frame as
> whatever they mate with, not derived as a separate rotation angle**:
> `cb1_pipe()`'s first pass built its square cross-section axis-aligned
> with Y/Z, but the bracket it mates with (`cb1_link_2d()`) is built in
> a DE-face-tangent local frame (`tangential_pt()`, aligned with
> `DE_DIR`/`DE_NORM`) — the two frames don't match, so the "square" pipe
> sat cocked at a real angle inside the bracket's slot instead of flush.
> Only caught by Janis looking at an actual render; the render alone
> looked plausible from most angles. FIX, and the locked convention
> going forward: when a new part must mate flush with an existing
> DE-frame (or any other non-axis-aligned local frame) part, build its
> own points with the SAME local-frame helper function
> (`tangential_pt()` here) and the SAME frame-conversion step
> (`freeze_from_open()` here) — never re-derive an equivalent rotation
> angle by hand, since that's a second, independent place the two parts'
> orientations could silently drift apart.
> Previous: 1.17 — 2026-07-30
> Changes: bbq-lid-hinge-v12, sanitization + real moment analysis round.
> New locked lesson: OpenSCAD's Customizer treats every top-level
> assignment following a `/* [Group] */` comment as a candidate UI
> parameter, and resolves its default value with an isolated, literal-
> only evaluator that has no access to other top-level variables in
> sequence — a variable reassigned to another variable's value (not a
> literal) in that position triggers "Ignoring unknown variable" from
> that scanner, even though the real top-to-bottom render evaluation
> resolves it correctly (confirmed via direct render: `Simple: yes`,
> identical geometry, with or without the warning). Grouping it under
> `/* [Hidden] */` does NOT fix this — confirmed by direct test, the
> warning persists regardless of visibility, only the RHS being a
> literal removes it. If the variable is otherwise dead (superseded by a
> direct explicit module argument elsewhere), the real fix is deleting
> it, not fighting the Customizer scanner.
> Previous: 1.16 — 2026-07-30
> Changes: bbq-lid-hinge-v12, 3rd CB1 REWORK same day — t6be/t7/t7r linked
> into a single SOLID FILLED web (not two hollow arms), per Janis's own
> explicit correction. New locked lesson: forcing a fillet/arc to be
> exactly tangent at one endpoint while passing through a distant second
> point can over-constrain the circle into a huge radius/wide sweep that
> bulges outside the intended fill region — a real defect only visible in
> an actual render, not from the math alone. Prefer a disclosed, gentle
> fixed-radius arc over a forced tangency solve.
> Previous: 1.15 — 2026-07-30
> Changes: bbq-lid-hinge-v12, 2nd CB1 REWORK same day — Janis confirmed
> the bracket orientation was STILL wrong after the 1.14 fix (contour
> count was fixed, but the "breach one edge" notch opened the wrong
> side). Amended with 1 more real, locked lesson: a single-contour check
> confirms a shape is CONNECTED, not that it's ORIENTED correctly — when
> a casual simplification instruction changes HOW a shape is built
> without re-stating WHICH original named features (Ua/Ub/Uc etc.) go
> where, re-derive orientation from the original detailed spec's own
> literal text, quoted, and confirm with a labeled diagram before
> touching committed code. Bracket rebuilt as ONE traced polygon
> (Ub=back wall perpendicular to DE, Ua/Uc=arms reaching 50.8mm along
> DE to CB1's own centerline, Uc touching DE) — Janis confirmed correct
> against a pencil-labeled diagram before this fix was committed.
> Previous: 1.14 — 2026-07-30
> Changes: bbq-lid-hinge-v12, CB1 REWORK round — Janis caught a real,
> fundamental error in the first v12 pass directly from a render (not
> found by cc): CB1 was built directly from the fixed RIB_REF_D/E points
> as if that were already the native/closed-frame coordinate, baking
> DE-contact into the CLOSED state instead of the OPEN state (backwards
> for a stopper: should float clear when closed, touch DE only when
> open). Amended the "Three-Rib Lid Counterbalance System" section with
> 2 new real, locked lessons: (1) a stopper/link whose rest state is
> defined at the OPEN door position must be built via the real
> open-then-freeze method (open-frame target -> `freeze_from_open()` ->
> native frame) — the "build directly from a fixed point, no rotate()"
> technique that IS correct for t1-t6 is WRONG here, because those
> points' own rest state is the CLOSED position, not the open one;
> verify with a render at both door states, not just an algebraic check;
> (2) a `difference()` notch sized to exactly "half" of an embedded
> shape, inside an outer shape built with a uniform margin, stays short
> of every edge and produces an enclosed hole (2 DXF contours) instead of
> a genuine open U/C (1 contour) — the notch must be extended to actually
> breach the one edge meant to be open.
> Previous: 1.13 — 2026-07-30
> Changes: bbq-lid-hinge-v12, CB1 lateral link round. Amended the
> "Three-Rib Lid Counterbalance System" section with 2 new real, locked
> lessons: (1) a multi-piece bracket built as several separately-unioned
> rectangles can hit OpenSCAD's own 2D boolean coincident-edge gap trap
> even with mathematically exact shared edges — fix is to trace the whole
> shape as ONE single polygon, not union separate pieces; (2) a point
> constrained to a single axis (e.g. "vertical line offset by >=Nmm") can
> be a genuine impossibility once two independent clearance floors apply
> from opposite directions on that same axis — fix is to free up a second
> degree of freedom (diagonal offset) and re-solve, not push harder on the
> same axis.
> Previous: 1.12 — 2026-07-26
> Changes: pointer split — the general "open-then-freeze" method now
> lives in `.claude/SKILL_kinematic_frame_construction.md` (reusable
> across products), `docs/hinge-construction.md` keeps BBQ's own
> numbers. Detail addition, not new structure — X.Y bump.
> Previous: 1.11 — 2026-07-25
> Changes: added a one-line pointer to new docs/hinge-construction.md
> (the full worked reference for the shared-pivot/end-margin-zone
> lessons below, plus the "open-then-freeze" method for positioning rib/
> link points against a real physical target). Detail addition, not new
> structure — X.Y bump.
> Previous: 1.10 — 2026-07-25
> Changes: bbq-lid-hinge-v9, real shared hinge pivot round. Amended the
> "Three-Rib Lid Counterbalance System" section with 2 new real, locked
> lessons: (1) two parts that must move together as one rigid assembly
> (the lid shell and its own rib/hinge structure) must share the LITERAL
> same rotation center, not just numerically-close ones — the root cause
> of the entire v8 sink/float saga (5 failed passes) was two independently
> tuned rotation points, fixed by one real shared `HINGE_PIVOT_Y`/
> `HINGE_PIVOT_Z` constant pair read live by both; (2) the "end margin
> zone" — the region outside a lid's own `LID_X0`/`LID_X1` range has no
> door at all, so a pivot mounted there can sit its Y exactly on the
> fixed/lid parting line with zero gap, unlike anywhere inside the door's
> real operating range.
> Previous: 1.9 — 2026-07-25
> Changes: bbq-lid-hinge-v8, "unify system" redesign round. Amended the
> "Three-Rib Lid Counterbalance System" section with 2 new real, locked
> lessons: (1) a hardcoded fixed/lid split (e.g. a ridge midpoint) must
> become its own real, tunable design parameter once a real reference
> part can't be reconciled with it as a bare coincidence — the
> `RIDGE_SPLIT_Y` fix, root-causing what v7/v7.2's pivot-only fixes could
> not fully resolve; (2) a fixed bracket's own foot/mounting plate is a
> real obstacle the swept arm must clear too, not just the pivot bore —
> found via a capsule-vs-box distance sweep, not visual inspection, fixed
> with the same "push the closest-approach point away" technique already
> locked for corner obstacles, now generalized to box obstacles.
> Previous: 1.8 — 2026-07-24
> Changes: bbq-lid-hinge-v7-sync-pivot-margin. R-010/R-014 self-trigger
> (3rd real round touching the rib/pivot mechanism in this same direct-cc
> session — v6, v6.1, v7): amended the "Three-Rib Lid Counterbalance
> System" section (below) with a new, real, recurring-root-cause lesson —
> TWO of the three rounds' real bugs were the SAME class of mistake (an
> octagon vertex used as a reference point from visual proximity to
> "roughly the right corner," without explicitly checking which side of
> the real fixed/lid split it's actually on: apex A vs. the real parting
> line in v6.1, apex C vs. apex D in v7). Also added the real, provable-
> ceiling finding from v7's own pivot relocation (a pivot's own fixed
> distance from a corner sets a hard, provable maximum on any branch/arm
> built from it — no construction technique can push past it). Detail
> addition to the existing section, not new document structure — X.Y bump.
> Previous: 1.7 — 2026-07-24
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
- **Convex-corner clearance is NOT automatic from a straight offset, AND
  an arc-around-the-corner fix is not universally correct either** — it
  depends on how close the pivot itself sits to that corner. If the
  counterbalance branch's own path is built by offsetting a straight
  reference edge outward by some margin, that margin is only guaranteed
  along the FLAT part of the edge — at any convex corner the reference
  contour turns through, a straight offset segment can swing back inside
  the intended margin (found round 1 of this pattern: a naive straight
  branch spine passed within 0.01mm of a real fixed corner it was
  supposed to clear by 20mm; fixed with a sampled arc around the corner,
  each point round-trip-converted to native frame). BUT if a LATER round
  moves the pivot much closer to that same corner, RE-TEST the arc
  technique fresh before reusing it — found round 2 (bbq-lid-hinge-v7):
  with the pivot relocated to only 36.5mm from the corner, the SAME
  arc-around-the-corner technique made clearance WORSE (near-zero at
  several angles), because arc waypoints placed close to the corner swing
  even closer to it when rotated about a pivot that's already close by.
  The general, real fix in that case: find the single closest-approach
  point on the NAIVE straight path (via a real sweep, not guessed), and
  push just that one point directly away from the corner — cheaper and
  more robust than a multi-point arc once the pivot itself is the
  dominant proximity constraint.
- **A pivot's own fixed distance from a corner is a PROVABLE CEILING on
  clearance, not just a starting risk** — since the pivot is a mandatory,
  non-moving point on every branch/arm built from it, no construction
  technique (arc, bow, or otherwise) can push that branch/arm's own
  centerline clearance to a nearby fixed corner past the pivot's own
  static distance to that corner. Combined with this project's own
  15mm-meat-around-every-bore convention, this can make the formal
  20mm apex-clearance rule genuinely UNACHIEVABLE at the pivot's own
  structural pad if the pivot sits close enough to the corner — compute
  and state this ceiling explicitly (pivot-to-corner distance minus the
  bore's own required half-width) rather than iterating construction
  techniques indefinitely trying to reach an impossible number. Flag it
  as a real, provable finding for the product owner instead.
- **Any reference point pulled from the chamber's own octagon MUST have
  its fixed-vs-lid side explicitly checked against the real split (the
  ridge's own `DATUM_Y_CENTER` midpoint, or the real parting line
  elsewhere on the wall), not assumed from which corner looks
  "roughly right."** Root cause of TWO separate real bugs across this
  mechanism's own build history: apex A used as a spine anchor when the
  real parting line (not apex A) is the true fixed/lid boundary on that
  wall edge (bbq-lid-hinge v6.1); apex C used as the pivot reference when
  apex C is provably on the LID's own half of the ridge, not the fixed
  half (bbq-lid-hinge v7) — both are the SAME class of mistake, an
  octagon vertex chosen by visual proximity rather than an explicit
  fixed/lid check. Before using ANY octagon vertex as a fixed-structure
  reference point, state the real numeric comparison (e.g. "431.335mm >
  DATUM_Y_CENTER(305mm), fixed side, margin 126.335mm") — do not assume
  it from the vertex's name or its rough position in a sketch.
- **Apex/corner clearance rule**: minimum 20mm real clearance, worst
  case, across the FULL swept rotation (fine steps, not just the two
  endpoints) — verify via a real numeric sweep (Python or equivalent),
  not assumed from the construction method alone. See the "provable
  ceiling" bullet above for what to do when this target is genuinely
  unreachable given a locked pivot position.
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
- **A hardcoded fixed/lid split (e.g. a ridge midpoint) is not a real
  design parameter until it has its own name and can be tuned** —
  bbq-lid-hinge v6/v6.1/v7/v7.2 all reused the ridge's own literal
  midpoint (`chamber_W/2`, coincidentally equal to `DATUM_Y_CENTER`) as
  the fixed/lid boundary there, which made "pivot close to a real hinge
  bracket" and "pivot provably on the fixed side" mutually exclusive
  whenever the desired hinge location sat near a vertex deep in the
  midpoint's own lid half. Round 4 (bbq-lid-hinge-v8) fixed this at the
  root: promoted the ridge split to its own real, independently-tunable
  parameter (`RIDGE_SPLIT_Y`) — moving THAT line, not just the pivot
  offset, is what finally made both constraints achievable together. When
  a product owner's own real reference hardware conflicts with a
  hardcoded geometric coincidence, check whether the coincidence itself
  (not just the number derived from it) is the thing that needs to become
  a real parameter.
- **A fixed bracket's own foot/mounting plate is a real solid obstacle
  the SWEEPING arm must clear too, not just the pivot bore** — checking
  only "is the pivot point itself on the fixed side" (the v7/v7.2 lesson
  above) is necessary but not sufficient once the fixed bracket has real
  volume near the swept path. bbq-lid-hinge-v8: a naive straight door-arm
  segment, previously safe with a distant pivot, swept directly through
  the new `hinge_bracket()`'s own foot plate once the pivot (and
  therefore its bracket) moved close to the door's own parting line —
  found via a capsule(arm-width)-vs-box(foot) distance sweep (0.02° steps,
  full 0-90°), NOT by visual inspection (the bracket was too small to
  spot a collision by eye at whole-assembly render scale). Fix reused the
  SAME "push the closest-approach point away by a fixed margin" technique
  already locked above for corner obstacles — applies equally to a box
  obstacle, not just a point/corner. Exclude the small knuckle region
  immediately around the pivot itself from this check (the rotating pad
  and the fixed boss are EXPECTED to sit close together there by design,
  same accepted simplification as every version's own pillow-block
  placeholder) — the real new risk is further along the arm, not at the
  pivot.
- **Two parts that must move together as one rigid assembly (a lid shell
  and its own rib/hinge structure) MUST share the literal same rotation
  center — not just numerically-close ones.** Root cause of the ENTIRE
  bbq-lid-hinge-v8 sink/float saga (5 passes, all failed): the chamber
  file's `lid()` and the base file's rib assembly each carried their OWN
  `FC_Y`/`FC_Z`-equivalent point, tuned independently each round. Two
  rigid bodies rotated by the same angle about two different centers
  necessarily drift apart at every angle except whichever one happened to
  be tuned — no amount of per-corner standoff/miter tuning can fix this,
  because the defect is structural, not dimensional. Fix (v9): ONE real
  constant pair (`HINGE_PIVOT_Y`/`HINGE_PIVOT_Z`, chambers file) is now
  the single source of truth, read live by both the lid's own rotation
  point and the rib assembly's `FC_Y`/`FC_Z` — with a shared center, the
  two parts' relative geometry is identical at every angle BY
  CONSTRUCTION, not by re-verifying a sweep every round. When a hinge/lid
  mechanism spans two separate files/modules, grep for every rotation
  call touching that joint and confirm they all resolve to the same
  named point before trusting any clearance number.
- **The "end margin zone"**: on a lid that doesn't span its full parent
  face (e.g. `LID_X0`/`LID_X1` short of the chamber's true 0/full-length
  ends), the region outside `[LID_X0, LID_X1]` has NO door at all — the
  cross-section there is fixed material regardless of Y or Z. A pivot
  bracket mounted at an X-position inside this zone can therefore sit its
  Y-coordinate EXACTLY on the fixed/lid parting line with zero safety
  gap, something that would be unsafe anywhere inside the door's own real
  operating X-range. Always check whether a hinge/bracket's chosen
  X-position falls inside this zone before deciding whether a Y/Z gap is
  required at all — it can eliminate an otherwise-real constraint
  entirely rather than just shrinking it.
- **Full worked reference for both lessons above**: `docs/hinge-
  construction.md` (new 2026-07-25) — read it before touching
  `HINGE_PIVOT_Y`/`HINGE_PIVOT_Z` or any `FC_Y`/`FC_Z`-derived point.
  The general "open-then-freeze" construction method for positioning any
  rib/link point against a real physical target — reusable across any
  product, not BBQ-specific — now lives in `.claude/
  SKILL_kinematic_frame_construction.md` (split out 2026-07-26).
- **A multi-piece bracket/pad built as several separately-unioned
  rectangles can hit OpenSCAD's own 2D boolean coincident-edge gap trap,
  even when every coordinate is analytically exact** (bbq-lid-hinge-v12,
  CB1 lateral link U-bracket): 3 axis-aligned rectangles (back wall + 2
  arms) sharing a long COINCIDENT (not overlapping) straight edge — same
  variable, same formula, zero floating-point drift — still produced 2
  separate DXF contours instead of 1 (confirmed via an isolated minimal
  test, the exact discipline `.claude/SKILL_local_render.md`'s own
  "technical trap" section already calls for). This is a DIFFERENT
  failure mode from the near-miss/rounding gaps that section already
  documents (those involve a real, if tiny, measured distance between
  pieces) — here the edges are mathematically identical, and the union
  still split. **Real fix: trace the whole multi-segment shape as ONE
  single simple polygon (one ordered point list, one `polygon()` call)
  instead of unioning separate rectangles/pieces that happen to share an
  edge.** A single polygon has no internal seam for the boolean engine to
  fail on, and produces cleaner geometry besides (fewer facets). Prefer
  this construction from the start for any bracket/pad assembled from
  more than one rectilinear piece — don't reach for `union()` of
  primitives as the default and only fall back to a single traced
  outline after hitting the gap.
- **A point defined as "a vertical/single-axis line offset from a fixed
  center by >= Nmm" can be a genuine mathematical impossibility once two
  independent clearance floors apply on opposite sides of that same
  line** (bbq-lid-hinge-v12, `t6be`): the prompt's own literal spec (a
  pure-vertical line through the t6 pivot, offset down >=15mm) required
  simultaneously satisfying a ridge-floor constraint (Z >= a fixed
  minimum, pushing the point UP) and a pivot-boss keepout constraint
  (Z <= a fixed maximum, pushing the point DOWN) — on a single vertical
  line these two floors conflicted by a real, computed 4.5mm under this
  project's own 20mm-half-width convention, not a construction failure.
  **Real fix: relax the constraint from a single-axis line to a
  diagonal offset (both axes free) and re-solve** — the same two
  clearance floors, now satisfiable together off-axis, gave a real
  10.0mm/11.6mm margin on each side. Before iterating harder on a
  single-axis placement that keeps producing a negative or near-zero
  margin, check algebraically whether the two floors are compatible on
  that axis AT ALL — if not, the fix is a different degree of freedom,
  not a different number on the same one.
- **A REAL, DANGEROUS error, self-made and caught by Janis directly, not
  cc (bbq-lid-hinge-v12, CB1 rework)**: a stopper/link mechanism whose
  physical rest state is defined at the OPEN door position (must float
  clear of the fixed structure when closed, contact it only when open)
  CANNOT be built directly from a fixed reference point (e.g. an octagon
  vertex) as if that were already the native/closed-frame coordinate —
  doing so bakes the CONTACT state into the CLOSED position instead,
  exactly backwards (it would prevent the door from ever closing, and
  swing the stopper AWAY from its target when opened). This is true even
  though the SAME "build directly from a fixed reference, no rotate()
  call" technique is CORRECT for `t1`-`t6` (those points' own rest/flush
  state is genuinely the CLOSED position, since the door hugs that wall
  when shut) — the technique is only valid when the native/closed frame
  IS the frame where the physical constraint actually holds. Before
  reusing "build directly from a fixed point" for ANY new feature, ask
  explicitly: at which door state (open, closed, or continuously) does
  this feature's own physical constraint actually apply? If the answer
  is "open" (a stopper, a link, anything meant to rest against fixed
  structure only when swung open), the correct construction is the real
  open-then-freeze method — compute the point as a genuine OPEN-frame
  target, then convert to native/closed frame via the shared pivot's own
  rotation formula (`freeze_from_open()`,
  `BBQ-offset-smoker-base-v12.scad`) — never skip the freeze step because
  the target happens to be computable from a fixed reference point.
  **Verify this the same way it was caught here**: render the built
  feature at native/closed frame (should sit CLEAR of its target) and at
  the open angle via the real assembly transform (should land ON its
  target) — a written-down formula "looking right" algebraically is not
  sufficient, an isolated render showing both states is.
- **A `difference()` notch sized to exactly remove "half" of an
  embedded shape can produce an enclosed hole instead of a genuine open
  "U"/"C" shape, even when that's what was intended** (bbq-lid-hinge-v12,
  CB1 bracket): a bracket built as `big_square - half_of_CB1_footprint`
  looks like it should open the square up on one side, but if the outer
  square was built with a UNIFORM margin on all 4 sides (e.g. "offset
  20mm from CB1"), a notch sized to only half the embedded shape's own
  footprint stays short of every outer edge by exactly that margin — the
  result is a fully-enclosed picture-frame (2 DXF contours: outer + inner
  hole), not an open U (which needs the notch to genuinely BREACH one
  outer edge). Confirmed via an isolated DXF contour count before
  assuming the shape was right. **Fix: extend the notch past the
  embedded shape's own edge, all the way to the corresponding OUTER edge
  on the side meant to be open** — the notch then removes slightly more
  than a literal "half" of the embedded footprint (it also eats the
  margin strip on that one side), but this is what actually produces a
  connected, genuinely-open U/C profile in one single `difference()`
  call. Verify with a DXF contour count: a closed frame reads as 2
  contours, a real open U reads as 1.
- **CORRECTION to the bullet immediately above, same day**: fixing the
  CONTOUR COUNT (1 vs 2) is not the same as fixing the ORIENTATION — the
  very next round, using this exact "breach one edge" technique, breached
  the WRONG edge and produced a single-piece U that was still physically
  backwards (open on the side away from where the tube needs its weld
  reach, not along the pipe face as the spec required). Root cause:
  Janis's own casual simplification instruction ("just subtract a
  square") didn't specify a breach DIRECTION, and cc guessed one without
  re-checking it against the ORIGINAL detailed spec's own named parts
  (`Ua`/`Ub`/`Uc` here — which arm reaches where, which face contacts the
  fixed structure). **A single DXF contour confirms the piece is
  connected — it says NOTHING about whether the shape is oriented
  correctly.** When a casual/simplified rebuild instruction changes HOW a
  shape is built (union -> difference, 3 pieces -> 1 square) without
  re-stating WHICH original named features go where, re-derive the
  orientation from the ORIGINAL detailed spec's own literal text before
  writing code — quote it, don't re-guess it — then confirm with a
  labeled diagram before touching the committed file, especially after a
  prior round already got this same feature wrong once.
- **Forcing a fillet/arc to be exactly TANGENT to an existing edge at one
  endpoint, while also passing through a distant second point, can
  over-constrain the circle into a huge radius and a very wide sweep —
  not a small, gentle arc** (bbq-lid-hinge-v12, the t4-to-neck_r "top rib
  line"): solving for tangency at t4 plus passage through a point 310mm
  away produced a 160mm-radius circle with a 151-degree sweep that
  bulged far outside the intended fill region — a real, visible gap in
  the rendered material, not merely an ugly curve. This is NOT visible
  from the math alone (the tangency/pass-through solve "succeeds" and
  looks fine as numbers) — it only showed up as a real defect in an
  actual render (confirmed with a full `--render` CGAL pass, not just
  the fast OpenCSG preview, since the two can look different at a
  boolean seam). **When asked for "a smooth arc, not a sharp angle,"
  prefer a disclosed, reasonable fixed radius chosen for a gentle sweep
  over one derived by force-solving a tangency constraint** — tangency
  is not required for "smooth," and over-constraining it can produce a
  worse shape than a plain, generous circular arc between the two
  endpoints. Always render the actual result (both OpenCSG preview and a
  real `--render`) before trusting a new curve construction, exactly as
  for any other new geometry this project builds.

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
