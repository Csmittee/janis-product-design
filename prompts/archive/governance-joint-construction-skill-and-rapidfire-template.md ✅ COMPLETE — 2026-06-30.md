# CC PROMPT — Governance Update — Joint Construction Skill + Rapid-Fire Template + R-111 Self-Trigger

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order, state every file read before writing a single line:
1. cc_rules.md
2. knowledge.map
3. cc_chat_log.md (first 3 entries — newest at top)
4. .claude/SKILL_problem_solving_kt.md
5. .claude/SKILL_manifold_triage.md (pattern reference for Task 1's new file)
6. WORKFLOW_SKILL.md (repo root copy)
7. chat_rules.md (repo root copy)
8. .claude/rules-codes.md

## 2. CONTEXT

R-111 triggered by Claude Web — pole_top() neck/bell/body junction has failed
QA across 8 versions (v10-v17) without converging. KT analysis (Phase 1-3)
found the root cause: every fix loop patched the specific defect Janis last
flagged (gap, then overlap, then seam, then bolt clearance) without ever
establishing a documented CONSTRUCTION RULE for how a joint between
mismatched cross-section shapes should be built — unlike the bore-orientation
bug (also looped, v10-v14) which converged once it got a real documented
rule (single-rotate-as-last-op) that has held ever since.

This prompt does NOT touch any geometry. It creates the missing governance
documentation so the next geometry attempt (a future v18 prompt) is built on
an actual rule instead of another guess.

Separately, Janis flagged two process gaps this session:
1. Claude Web should self-trigger R-111 automatically after 2 failed QA
   loops on the same problem — this was missed, Janis had to point it out.
2. Rapid-fire chat instructions to cc have been dropping required content
   (PR open items, QA must-confirm list, DO NOT TOUCH list) in an attempt
   to avoid re-asking cc to re-read its own context — the template needs a
   middle ground: skip redundant re-reads of files cc already has in
   session context, but never skip the open-items/QA/do-not-touch content
   itself, since that's instruction, not context.

## 3. NEW FILES

- `.claude/SKILL_joint_construction.md` — add to knowledge.map

## 4. TASKS

### TASK 1 — Create `.claude/SKILL_joint_construction.md`

Follow the structure/tone of `.claude/SKILL_manifold_triage.md` (read in
Section 1) as the pattern reference. Content:

```
# SKILL_joint_construction.md
# Joint & Cross-Section Transition Construction — Janis Product Design
# Version: 1.0 — [date]
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
```

### TASK 2 — Update `.claude/rules-codes.md`

Add a new bullet to the top-level rule index (wherever the manifold-rules
pointer currently lives) pointing to the new file:

```
**Joint/cross-section transition issues:** read
`.claude/SKILL_joint_construction.md` before writing any fix involving a
T-junction or a transition between mismatched cross-section shapes.
```

Bump rules-codes.md version and date.

### TASK 3 — Update `WORKFLOW_SKILL.md` (repo root copy)

Add a new row to the `TRIGGER → ACTION → VALIDATOR` table:

```
| Joint/transition between mismatched cross-sections fails QA twice | R-111 — read .claude/SKILL_joint_construction.md, complete KT before next prompt | Claude Web states "R-111 triggered" + cites which rule (1/2/3) was violated |
```

Add a new subsection immediately after `MANIFOLD WARNING FAST-PATH`:

```
---

## RAPID-FIRE PROMPT TEMPLATE — MINIMAL BUT COMPLETE

Rapid-fire chat instructions (single confirmed line/module, cc still in
session) do NOT need to re-list files cc already has in its current session
context — do not ask cc to re-read cc_rules.md, knowledge.map, or the
active .scad file again mid-session.

Rapid-fire instructions DO still need, every time, even though they are
short:
1. The exact module/line/parameter to change
2. Current open-item context relevant to this change (one line — e.g.
   "PR-01-base v18, joint fix, neck-bell still open")
3. The specific QA confirmation cc must state back (what number/result
   proves this worked)
4. Any DO NOT TOUCH items relevant to this specific change (not the full
   project list — just what's at risk of being accidentally touched by
   this exact edit)

A rapid-fire instruction that drops items 2-4 to save length is an
incomplete instruction, not an efficient one. Length savings come from
skipping redundant file re-reads (item 0, not in the list above) — never
from skipping open-items/QA/do-not-touch content.
```

Bump WORKFLOW_SKILL.md version 3.1 → 3.2, date today, changes line stating
"Joint construction skill + rapid-fire template + R-111 self-trigger
reinforcement added."

### TASK 4 — Update `chat_rules.md` (repo root copy + flag for Project Knowledge re-upload)

Under `## Decay Symptoms`, strengthen the existing "Same issue repeats more
than 2 loops" bullet — replace it with:

```
- Same issue repeats more than 2 loops — Claude Web MUST self-check loop
  count at the START of every QA result it receives, BEFORE responding to
  it. This check happens automatically, every single FAIL, not only when
  Janis raises it. If 2nd consecutive FAIL on the same root component is
  detected, state "R-111 triggered" in the same message as the QA
  response — do not proceed to write or imply a 3rd fix attempt first.
```

Bump chat_rules.md version v3 → v3.3 (or next available — check current
header in repo, do not guess), date today.

⚑ FLAG in cc_chat_log: Janis must re-upload chat_rules.md and
WORKFLOW_SKILL.md to Project Knowledge after this commit — repo and
Project Knowledge must match, this is a manual sync step on Janis's side.

## 5. DO NOT TOUCH

- Any `.scad` file — this prompt is documentation/governance only, zero
  geometry changes
- rules-dimensions.md, rules-pr.md
- cc_chat_log.md — append/prepend only, per standard rule
- All files not explicitly named in TASKS 1-4

## 6. QA VERIFICATION

- [ ] `.claude/SKILL_joint_construction.md` created, all 3 rules + isolation
      discipline section present, added to knowledge.map
- [ ] `.claude/rules-codes.md` updated with pointer, version bumped
- [ ] `WORKFLOW_SKILL.md` updated: new trigger row + rapid-fire template
      subsection, version 3.1→3.2
- [ ] `chat_rules.md` updated: self-trigger language strengthened, version
      bumped (state actual new version number used)
- [ ] No `.scad` file touched — confirm explicitly in cc_chat_log
- [ ] Flag for Janis to re-upload both .md files to Project Knowledge
      stated clearly in cc_chat_log

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at TOP. Must include the Janis
   re-upload flag explicitly, not buried in prose.
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Update knowledge.map — add SKILL_joint_construction.md row
4. Bump version on every file changed (rules-codes.md, WORKFLOW_SKILL.md,
   chat_rules.md, cc_chat_log.md, knowledge.map)
5. Commit all → merge to main

Confirm what you changed after commit. No .scad geometry work happens until
this is committed and Janis confirms the Project Knowledge re-upload.
