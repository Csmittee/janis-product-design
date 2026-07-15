# CC PROMPT — bbq-chambers-v9-firebox-passage-true-profile
# Date: 2026-07-16
# Repo location: bbq-offset-smoker/BBQ-chambers-v9.scad (new, source v8)
# Single-focus fix. Root cause confirmed via independent local
# verification (SKILL_local_render.md R-111 addendum) — NOT another
# guess. This is the 3rd report of the same "triangle leak at the
# firebox passage" symptom; PR #121's manifold-only check found "no
# CGAL-provable defect" twice because it was checking the wrong
# property.

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order, state every file read:
1. cc_rules.md
2. knowledge.map
3. cc_chat_log.md (first 3 entries)
4. bbq-offset-smoker/rules-bbq-fab.md
5. bbq-offset-smoker/BBQ-chambers-v8.scad — LIVE file, in full. State
   the exact current bodies of `fixed_shell_profile()`,
   `true_octagon_profile()`, `fixed_side_wedge()`, `firebox_square_2d()`,
   `firebox_passage_profile()`, `firebox_passage()`.
6. .claude/rules-codes.md

Claude Web override: none.

## 2. CONTEXT

**Root cause (confirmed via independent local render — overlaid
`fixed_shell_profile()` against `true_octagon_profile()` in 2D):**
`firebox_passage_profile()` computes its cut shape as
`offset(-PASSAGE_INSET) intersection(fixed_shell_profile(),
firebox_square_2d())`. `fixed_shell_profile()` still contains the fake
diagonal parting-line edge (apex A → ridge midpoint) — the same artifact
that caused the "reads solid" bug fixed in v7. That fake edge cuts off a
real wedge of material (bottom-left corner region) that the ACTUAL wall
(`chamber_outer_tube()`, built from `true_octagon_profile()` +
`fixed_side_wedge()`, no fake edge) genuinely has. Where the firebox
opening overlaps that wedge region, the passage's computed cut boundary
and the real wall's actual boundary disagree — a structural mismatch,
not a manifold defect, which is why 2 prior CGAL-only checks (PR #121)
found nothing wrong. This is almost certainly the persistent "triangle
leak."

**Fix:** rebuild `firebox_passage_profile()` to intersect against the
REAL wall boundary (`true_octagon_profile()` clipped to the fixed side
via `fixed_side_wedge()`, same construction `chamber_outer_tube()`
already uses) instead of the old `fixed_shell_profile()`.

## 3. NEW FILES

None. New `BBQ-chambers-v9.scad` (source v8).

## 4. TASKS

### TASK 1 — Rebuild firebox_passage_profile() against the real wall boundary

Replace:
```openscad
module firebox_passage_profile() {
    offset(delta = -PASSAGE_INSET)
        intersection() {
            fixed_shell_profile();
            firebox_square_2d();
        }
}
```
with an equivalent that intersects `firebox_square_2d()` against the
REAL fixed-side wall shape — `intersection(true_octagon_profile(),
fixed_side_wedge())` — not `fixed_shell_profile()`. State the exact
construction used (a helper module is fine if it avoids duplicating the
intersection logic — check whether `chamber_outer_tube()`'s own 3D
construction can be reused/adapted for a 2D equivalent, or build a new
small 2D-only helper — your call, state reasoning).

### TASK 2 — Confirm fixed_shell_profile() now has zero real callers

Per v7/v8's own notes, `fixed_shell_profile()` was kept ONLY for this
one caller. After TASK 1, grep the full file for any remaining usage. If
none, state this explicitly and either remove the module or mark it
clearly as dead/retained-for-reference — your judgment, state which and
why. Do NOT silently leave a now-unused module without flagging it.

### TASK 3 — Real verification of the actual fix

This symptom has survived 2 manifold-only checks that found nothing —
don't repeat that mistake. Required:
1. Real 2D overlay check (same method as Claude Web's local
   verification): confirm the NEW `firebox_passage_profile()`'s
   intersection input now matches `chamber_outer_tube()`'s real boundary
   exactly in the corner region where the old mismatch existed — state
   the specific check performed, not just "looks right."
2. Real CGAL 3D check: after cutting, confirm the passage opening's
   boundary lies entirely within real wall material on all sides (no
   partial/leaked edge) via an actual intersection() probe against the
   built wall, not just an absence-of-warning check.
3. State the new passage area (shoelace or equivalent) and compare to
   v8's 88209.5mm² — expect a small change, state the real number, don't
   assume it's identical.

## 5. DO NOT TOUCH

- `true_octagon_profile()`, `fixed_side_wedge()`, `chamber_outer_tube()`,
  `octagon_ring()` — unchanged, already correct (v7/v8)
- `lid_territory_margin_fill()` — unchanged
- `PASSAGE_INSET = 15` — unchanged value, only the boundary it's applied
  to changes
- `firebox_shell()`, `fire_grate()`, `ash_tray()`, `firebox_door()` —
  unchanged
- Exhaust room position — separate open item, not this prompt
- `firebox_drop`, `lid_hardware()` — still open, not this prompt
- Understructure — separate file
- rules-dimensions.md, cc_rules.md — read only

## 6. QA VERIFICATION

- [ ] TASK 1: new profile confirmed built from real wall boundary, not
      `fixed_shell_profile()`
- [ ] TASK 2: zero remaining real callers of `fixed_shell_profile()`
      confirmed via grep, module fate stated (removed or flagged dead)
- [ ] TASK 3: 2D overlay check confirms no divergence in the corner
      region
- [ ] TASK 3: 3D intersection probe confirms opening lies fully within
      real wall material
- [ ] New passage area stated numerically
- [ ] Full kinetic sweep (0-120°) — `Simple: yes`
- [ ] Full assembly chain render — `Simple: yes`
- [ ] Zoomed render of the firebox passage corner (the specific region
      Janis has flagged 3 times) — visually confirm no gap
- [ ] No undefined variable warnings

## 7. MANDATORY CLOSING

1. Prepend `cc_chat_log.md` — newest entry at top, under 10 lines: state
   the real root cause (profile mismatch, not manifold defect), confirm
   the fix and the 2D+3D verification results
2. Archive this prompt → `/prompts/archive/` ✅ COMPLETE — 2026-07-16
3. Update `knowledge.map` if `fixed_shell_profile()` is removed
4. Bump version — `BBQ-chambers-v9.scad`, v8 kept unchanged
5. Update includes v8→v9
6. Commit all → merge to main
