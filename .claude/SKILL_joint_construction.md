# SKILL_joint_construction.md
# Joint & Cross-Section Transition Construction — Janis Product Design
# Version: 1.1 — 2026-07-21
# Location: .claude/SKILL_joint_construction.md
# Changes: added RULE 4 — Dual End-Cap Footprint Pattern, from the BBQ
# firebox/chamber v16/v17/v18 build-and-fix cycle (3 real attempts before
# a correct, verified construction — captured here so the NEXT product to
# hit this exact shape-matching problem reuses the pattern instead of
# re-deriving it, same discipline as RULE 2's own multi-step loft below).
# Read when: building or fixing any junction where two modules with
# different cross-section shapes meet (round-to-D, round-to-square, etc.)
# or any T-junction where a child member attaches to a parent member, OR
# a flat end-cap/footprint panel must widen to match a wider reference
# profile at the SAME position without leaving a gap (RULE 4).

---

## WHEN TO USE THIS

Triggered any time a prompt involves:
- Two modules with DIFFERENT cross-section shapes meeting (e.g. round bell
  to D-profile body, round neck to square boss)
- A child member (crossbar, sleeve, boss) attaching to a parent member
  (post, body, pole) — a "T-junction" pattern
- Any joint that has already failed QA once on alignment/seam/fit grounds

Do NOT use for: single-shape extrusions, simple coaxial stacking of
identical cross-sections (no rule needed there), bore/hole placement alone.

---

## RULE 1 — DATUM IS THE PARENT'S AXIS, NEVER THE CHILD'S EDGE

When a child member (bar, sleeve, boss) attaches to a parent member (post,
body, pole), the datum/anchor point is the PARENT's centerline axis — not
the child's face, tip, or edge.

Real-world analogy: a horizontal bar through a vertical post is centered ON
the post's axis (T-junction), not balanced on the post's edge like a lid.

WRONG: anchoring a cone/bar by its own end-face sitting on top of the post.
RIGHT: the cone/bar's central axis passes through and is perpendicular to
the post's centerline.

Before writing any fix: state both axes as explicit world-coordinate lines
and confirm they intersect at the correct point. Do not state "aligned"
without showing the actual line equations / coordinates.

---

## RULE 2 — MISMATCHED CROSS-SECTIONS NEED A MULTI-STEP LOFT, NEVER A SINGLE HULL()

When two cross-section shapes differ (round-to-D, round-to-square,
round-to-octagon), a single `hull()` between the two end shapes produces
flat triangular facets bridging the gap wherever one shape's corners
extend past the other's radius — this reads as a crease/notch, not a
smooth transition (confirmed defect, PR-01-base v17).

WRONG: `hull() { shape_a(); translate([...]) shape_b(); }` jumping directly
between two dissimilar cross-sections.

RIGHT: multi-step loft — minimum 6-8 intermediate cross-sections, each
incrementally interpolated in shape between shape_a and shape_b, hulled
pairwise between adjacent steps. This is the same pattern already proven
correct elsewhere in this project: `pole_body()`'s taper and the bell's own
exterior profile both use multi-step Bezier/loft construction, not a single
hull jump.

If a transition zone must also stay clear of a bore or other void, the
bore-envelope subtraction must apply to every intermediate step, not just
the two end shapes.

---

## RULE 3 — STATE COORDINATES, DON'T JUST CLAIM "ALIGNED" OR "FIXED"

Before any joint/transition fix is committed, cc must output as plain
numbers (in cc_chat_log, not just in code comments):
- The parent's centerline as a world-coordinate line equation
- The child's centerline as a world-coordinate line equation
- The actual intersection point (or the minimum distance between the two
  lines, if not exactly intersecting) — show the number, not just "0" or
  "aligned"
- For cross-section transitions: the cross-section shape/key dimensions at
  the start, end, and at least one middle step of the loft

This applies whether or not cc has render access. "Code-reviewed, math-
verified" must mean the actual numbers were computed and stated — not that
the code was read and looked plausible.

---

## RULE 4 — DUAL END-CAP FOOTPRINT PATTERN (flat panel must widen to
match a wider reference profile, same position, no gap)

Distinct from RULE 2's loft (which bridges two shapes at DIFFERENT Z/X
positions). This rule is for a FLAT 2D panel/footprint that must sit at
ONE position but match whichever of two shapes is locally WIDER there —
e.g. an outer shell's own end-cap tucking under a wider parent body whose
own cross-section varies with height (BBQ firebox-under-octagon-chamber,
found during the v16/v17/v18 build-and-fix cycle — 3 real attempts before
landing here, do not re-derive from scratch on the next product that hits
this).

**THE WRONG APPROACH (tried twice, both real, shipped, both wrong):**
- `intersection(native_shape, reference_profile)` — clips the panel DOWN
  to whichever is NARROWER. If the reference has zero material of its own
  outside its own true edge (the common case — a parent body doesn't fill
  space beyond its own boundary), this creates a real, literal gap with NO
  material from either part at the clipped corners. (v16's mistake.)
- Keeping the native shape unclipped and ONLY cutting an interior hole —
  avoids the gap, but never actually reaches out to meet the wider
  reference profile where it should. Passes every collision/containment
  CGAL check while still not doing the one thing asked for. (v17's
  mistake — caught by a manual QA simulation, not by CGAL.)

**THE RIGHT APPROACH:**
```
module footprint_2d() {
    difference() {
        intersection() {
            union() {
                native_shape_2d();       // e.g. the shell's own plain cross-section
                reference_profile_2d();  // e.g. the parent body's own true profile
            }
            height_bound_2d();  // REQUIRED, see below — bounds the union to
                                 // the panel's own real physical extent
        }
        interior_cavity_2d();  // the parent's own real hollow interior, so
                                // the panel can never plug/block it
    }
}
```
`union()`, not `intersection()` — the footprint is then ALWAYS at least
as wide as the native shape (no gap, ever, by construction — "one
continuous surface, no step" falls out for free), and reaches out to
match the reference profile exactly wherever it's the wider of the two.

**THE REAL TRAP THIS PATTERN HAS ALREADY CAUGHT ONCE**: `reference_profile_2d()`
is usually NOT bounded to the panel's own real physical height/extent on
its own (it's the PARENT's full shape, which typically extends much
farther than the child panel ever should). A bare `union()` without the
`height_bound_2d()` intersection will pull in reference-profile material
far beyond the panel's own real extent (found via a real STL bounding-box
probe in the BBQ case: the union reached the parent chamber's own ridge
height, 258mm past the child firebox's own real top, before this bound
was added). **Never skip the height-bound intersection step** — verify
with a real STL/bounding-box probe of the footprint alone, not a visual
render, before considering this pattern correctly applied.

**Verification for this pattern specifically** (beyond RULE 3's general
coordinate-dump requirement):
- `intersection()` vs. the parent's own real hollow interior (shrunk by a
  real margin) — must be EMPTY.
- `intersection()` vs. the parent's own real solid material at the
  contact zone — must be NON-EMPTY (real structural contact).
- A real STL bounding-box probe of the footprint/panel alone — confirm it
  never exceeds the child's own real physical extent.

---

## ISOLATION-TEST-FIRST DISCIPLINE (same pattern as manifold triage)

If a joint/transition has already failed QA once:
1. Do NOT write a direct fix prompt as the next step.
2. First write a coordinate-dump-only rapid-fire instruction: cc reports
   the actual parent-axis / child-axis / cross-section numbers per Rule 3,
   no geometry change yet.
3. Claude Web reviews those numbers against Rule 1/2 before writing the
   actual fix prompt.
4. Maximum 2 prompts from second failure to next QA: Prompt 1 = coordinate
   dump, Prompt 2 = fix. If that fix also fails QA, R-111 has now fired
   twice on the same problem — escalate to Janis directly, do not write a
   3rd attempt without new input from Janis (design approach change, etc.)
