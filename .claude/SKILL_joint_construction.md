# SKILL_joint_construction.md
# Joint & Cross-Section Transition Construction — Janis Product Design
# Version: 1.0 — 2026-06-30
# Location: .claude/SKILL_joint_construction.md
# Read when: building or fixing any junction where two modules with
# different cross-section shapes meet (round-to-D, round-to-square, etc.)
# or any T-junction where a child member attaches to a parent member.

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
