# CC PROMPT — PR-01-base v19 — Transition Coordinate Dump (Isolation Test) + Bell Profile Fix

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order, state every file read before writing a single line:
1. cc_rules.md
2. knowledge.map
3. cc_chat_log.md (first 3 entries — newest at top)
4. .claude/SKILL_joint_construction.md
5. rules-dimensions.md
6. rules-pr.md
7. pilates-reformer/PR-01-base/PR-01-base-v18.scad (the live file — read in full)

## 2. CONTEXT

v18 fixed the two root-cause issues (cone datum re-anchored to bore midpoint
for a true T-junction; D-profile carried into the neck with bolts moved to
the flat face) — confirmed correct by Janis's screenshots, big improvement.

Two items remain open, and they are NOT the same kind of problem — handle
them differently per `.claude/SKILL_joint_construction.md`:

**Item A — neck/bell transition blend.** v17 introduced
`pole_top_transition()` as a single `hull()` between the neck's top
cross-section and the bell's small face. This is the exact WRONG pattern
flagged in SKILL_joint_construction.md Rule 2 (single hull() between
mismatched cross-sections produces flat triangular facet creases, not a
smooth surface) — visible in Janis's screenshots as crossed diagonal
creasing at the joint. v18 did not touch this module (out of scope for that
prompt). This transition has now effectively failed the "looks like one
cast piece" QA bar across v17 and v18 — per the skill file's
ISOLATION-TEST-FIRST DISCIPLINE, the next step is a coordinate-dump only,
NOT a direct fix, so Claude Web can review the actual numbers against Rule
1/2 before the real fix prompt is written.

**Item B — bell profile shape.** Independent of the transition/joint issue.
Small face already has the correct wine-glass concave curve (confirmed
v13+). Large (pipe-entry) face is still a convex horn flare, never fixed.
Janis also wants `head_large_r` reduced by 6mm from its current value,
provided it stays larger than `head_small_r`. This is a single-shape
profile change (not a joint between two different modules), so it does NOT
require the isolation-test discipline — implement directly.

## 3. NEW FILES

NONE — new version of the existing PR-01-base file (save-as v19).

## 4. TASKS

### TASK 1 — Coordinate dump ONLY for pole_top_transition() — NO geometry change

Per SKILL_joint_construction.md Rule 3, output the following as plain
numbers in cc_chat_log (not just code comments, not "looks fine"):

- The neck's top cross-section: shape type (round/D), key dimensions
  (diameter or flat-width + radius), and its world-coordinate center/plane
  at `neck_top`.
- The bell's small-face cross-section: shape type, key dimensions, and its
  world-coordinate center/plane.
- The actual `hull()` call currently in `pole_top_transition()` — quote it
  verbatim from the live file.
- State explicitly: do these two cross-sections differ in shape (not just
  size)? If yes, by how much does the larger shape's extent exceed the
  smaller shape's radius at the widest mismatch point — this is the
  number that predicts facet-crease severity per Rule 2.
- Do NOT modify `pole_top_transition()` in this task. Do NOT add loft steps
  yet. This is diagnostic only — Claude Web writes the actual fix prompt
  after reviewing these numbers.

### TASK 2 — Bell profile: wine-glass both ends + large-face reduction

1. Read the live file's current `head_large_r` and `head_small_r` values —
   state both explicitly in cc_chat_log before changing anything.
2. Apply the same concave Bezier/loft curve logic currently used for the
   bell's small-face transition to the large (pipe-entry) face as well —
   both ends must curve inward toward the waist symmetrically (true
   wine-glass profile), not the current horn-style outward convex flare on
   the large end.
3. Reduce `head_large_r` by exactly 6mm from its current live-file value.
   Confirm the resulting value is still greater than `head_small_r` — state
   both numbers and the margin between them explicitly. If the 6mm
   reduction would make `head_large_r` smaller than or equal to
   `head_small_r`, STOP and flag this to Claude Web instead of applying a
   different number — do not silently choose a smaller reduction.
4. Re-verify bore diameter (33mm) and bore axis (X) are unaffected — the
   profile change is exterior-only, bore stays untouched.
5. Re-verify minimum wall thickness around the bore at the new large-face
   radius — state the actual computed value, confirm it still clears the
   project's minimum wall rule.

## 5. DO NOT TOUCH

- `pole_top_transition()` geometry — Task 1 is diagnostic only, no edits
- Bore diameter (33mm), bore axis (X)
- `pole_od` (40mm), `neck_od` (47mm), `neck_h`, bolt positions/orientation
  (all confirmed correct in v18 — not in scope this round)
- `pole_body()`, `pole_base_collar()`, `pole_wood_socket()`, crossbar
  geometry
- `head_small_r` value itself — only `head_large_r` changes
- rules-dimensions.md, rules-pr.md — read only
- VM-01-base — not in scope
- All `.scad` files not named in TASKS

## 6. QA VERIFICATION

- [ ] Task 1: all coordinate-dump numbers stated explicitly in cc_chat_log
      (not "aligned"/"fine") — neck cross-section, bell small-face
      cross-section, verbatim current hull() call, shape-mismatch extent
- [ ] Task 1: confirm zero changes made to `pole_top_transition()` geometry
- [ ] Task 2: current and new `head_large_r` stated, margin above
      `head_small_r` stated explicitly
- [ ] Task 2: both bell faces confirmed concave (state how verified —
      e.g. numeric curve sampling, same method used for v14's profile check)
- [ ] Task 2: bore diameter/axis re-confirmed unchanged
- [ ] Task 2: minimum wall thickness at new large-face radius stated
- [ ] No undefined variable warnings, brace/paren balance clean (state the
      actual count, e.g. "36/36 braces, 490/490 parens")
- [ ] Version incremented — save as PR-01-base-v19.scad, v18 not overwritten
- [ ] State explicitly: no OpenSCAD binary in cc sandbox — Task 2 changes
      are code-review + coordinate-math verified only, Janis must F5/F6
      render to confirm visually before PASS

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at TOP. Task 1 numbers and Task 2
   numbers both must be explicit, not summarized as "done."
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Update knowledge.map — v18 → Superseded, v19 → ACTIVE
4. Bump version header on every file changed (v19 scad, cc_chat_log.md,
   knowledge.map)
5. Commit all → merge to main

Confirm what you changed after commit. Claude Web will review Task 1's
numbers against SKILL_joint_construction.md Rule 1/2 before writing the
actual transition-blend fix prompt — that is intentionally a separate next
step, not part of this prompt.
