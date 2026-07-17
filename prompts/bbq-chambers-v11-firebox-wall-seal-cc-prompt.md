# CC PROMPT — bbq-chambers-v11-firebox-wall-seal
# Date: 2026-07-17
# Repo location: bbq-offset-smoker/BBQ-chambers-v11.scad (new, source v10)
# 4th round on the "triangle leak" symptom (PR #121 x2, v9) — this time
# NOT a re-guess. Root cause found by Janis directly (correct geometric
# insight the prior 3 rounds never tested) and independently confirmed
# by Claude Web via a real local render BEFORE writing this prompt, per
# SKILL_local_render.md's Independent Post-Fix Verification rule.

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```
Read in order, state every file read before writing a single line:
1. cc_rules.md
2. knowledge.map
3. cc_chat_log.md (first 3 entries)
4. bbq-offset-smoker/rules-bbq-fab.md
5. bbq-offset-smoker/BBQ-chambers-v10.scad — LIVE file, in full. State
   the exact current bodies of `firebox_square_2d()`,
   `fixed_side_solid_2d()`, `firebox_shell()`, `firebox_near_wall_closure()`,
   `firebox_passage_profile()`, `firebox()`.
6. .claude/rules-codes.md

Claude Web override: none.

**R-009 duplication check:** confirm `firebox_square_2d()` and
`fixed_side_solid_2d()` are each defined exactly once and list every real
caller of both before adding a new consumer.

## 2. CONTEXT

**This is NOT the same defect as v9/PR #121.** Those rounds all tested
whether `firebox_passage_profile()` (the smoke-opening cut) was clipped
against the correct wall boundary — it is, confirmed 3 separate ways,
not touched by this prompt.

**Real root cause (Janis's own diagnosis, independently confirmed by
Claude Web via local OpenSCAD render of the actual merged v10 file
before writing this prompt):** the chamber's octagon cross-section
narrows near the floor (the bottom two chamfers). The firebox is a
plain square (`firebox_shell()`, size=`firebox_size`). Immediately
above `chamber_floor_z`, the octagon's real width is narrower than the
firebox's square opening — so the firebox's square footprint extends
past the chamber's actual wall envelope on both sides, for a band
roughly `chamber_floor_z` to `chamber_floor_z + (firebox_size -
(chamber_W - 2*chamfer))/2` (recompute this exactly from the live
file's own values — do not trust this prompt's arithmetic).

`firebox_near_wall_closure()` only ever closes the region BELOW
`chamber_floor_z` (a flat full-width rectangle, unchanged, still
correct, DO NOT TOUCH). Nothing has ever built a closing panel for the
region ABOVE `chamber_floor_z` where the square sticks out past the
narrowing octagon. `firebox_passage_profile()`'s inset cut correctly
avoids cutting INTO this region (it clips to the real wall boundary),
but clipping the opening doesn't add material to seal the OUTSIDE of
that boundary — so this area has genuinely never had a wall on either
side. This produces two symmetric triangular openings (mirrored left/
right of the firebox's Y-center), which is the "triangle leak" Janis
has been seeing.

Independent verification performed (2D boolean, real OpenSCAD run,
before writing this prompt): `difference(firebox_square_2d(),
fixed_side_solid_2d())`, restricted to the region at/above
`chamber_floor_z`, produces exactly two non-empty triangular regions —
matching Janis's screenshot precisely (one visible per viewing angle).

## 3. NEW FILES

None. New `BBQ-chambers-v11.scad` (source v10).

## 4. TASKS

### TASK 1 — Add a new closure module for the upper firebox/wall gap

Add a new module (pick a clear, non-colliding name — e.g.
`firebox_upper_wall_seal()` — your call, state reasoning) that builds a
real closing panel for exactly the open region:
```
difference(firebox_square_2d(), fixed_side_solid_2d())
```
restricted to the region at/above `chamber_floor_z` only (do NOT
duplicate the region `firebox_near_wall_closure()` already covers below
`chamber_floor_z` — intersect with the correct half-space first, same
`h>=0` convention `fixed_side_solid_2d()`/`true_octagon_profile()`
already use). Extrude this 2D shape by `wall_t` at the near-wall X
position (`firebox_x0`), same construction pattern
`firebox_near_wall_closure()` already uses (translate + rotate([0,90,0])
+ linear_extrude, or a direct cube-based approach if simpler for this
shape — your call, state reasoning, but it must be built from the REAL
`firebox_square_2d()`/`fixed_side_solid_2d()` boolean, not hardcoded
triangle coordinates, so it stays correct if `chamfer`/`firebox_size`
ever change).

Call this new module from `firebox()`, alongside the existing
`firebox_near_wall_closure()` call.

### TASK 2 — Real verification this actually closes the gap

This symptom has now failed 3 real fix rounds that each passed their own
checks — don't repeat that mistake:
1. Real CGAL probe: after the union of `chamber_shell()` +
   `firebox_shell()` + `firebox_near_wall_closure()` + the new module,
   minus `firebox_passage()`, confirm the ONLY opening at the near-wall
   boundary is the passage itself — state the check performed (e.g. a
   solid-fill probe of the two triangle regions specifically, confirming
   non-empty/Simple:yes there now).
2. Full kinetic sweep (0–120°) — `Simple: yes` throughout, no new
   collisions introduced.
3. Full `BBQ-offset-smoker-base-v1.scad` assembly chain — `Simple: yes`.
4. Render: same corner/angle Janis has been screenshotting (near-wall
   joint, straight-on or iso, lid open) — visually confirm both
   triangles are now filled, not just CGAL-clean.
5. State the real area of each new triangle panel (shoelace or
   equivalent), and confirm the two panels are mirror images of each
   other (same area, opposite Y side).

## 5. DO NOT TOUCH

- `firebox_passage_profile()`, `firebox_passage()` — unchanged, already
  correct (v9/v10)
- `firebox_near_wall_closure()` — unchanged, already correct, covers a
  DIFFERENT region (below chamber_floor_z)
- `fixed_side_solid_2d()`, `true_octagon_profile()`, `fixed_side_wedge()`,
  `chamber_outer_tube()` — unchanged
- `firebox_shell()`, `fire_grate()`, `ash_tray()`, `firebox_door()` —
  unchanged
- Exhaust room (v10's recenter) — separate, already merged, not this
  prompt
- `firebox_drop`, `lid_hardware()` — still open, not this prompt
- Understructure — separate file
- rules-dimensions.md, cc_rules.md — read only

## 6. QA VERIFICATION

- [ ] TASK 1: new module built from the real `firebox_square_2d()` /
      `fixed_side_solid_2d()` boolean, not hardcoded coordinates
- [ ] TASK 1: confirmed restricted to `chamber_floor_z` and above only —
      no overlap with `firebox_near_wall_closure()`'s existing coverage
- [ ] TASK 1: called from `firebox()`
- [ ] TASK 2: real CGAL probe confirms both triangle regions now filled
- [ ] TASK 2: full kinetic sweep 0–120°, `Simple: yes`
- [ ] TASK 2: full assembly chain, `Simple: yes`
- [ ] TASK 2: render at the same angle Janis has flagged, visually clean
- [ ] TASK 2: both triangle panel areas stated, confirmed mirror-symmetric
- [ ] No undefined variable warnings

## 7. MANDATORY CLOSING

1. Prepend `cc_chat_log.md` — newest entry at top, under 10 lines: state
   the real root cause (square-vs-narrowing-octagon gap, NOT a passage
   profile mismatch), confirm the new module and its verification
2. Archive this prompt → `/prompts/archive/` ✅ COMPLETE — 2026-07-17
3. Update `PART_MANIFEST.md` / `SKELETON_WORKSHEET.md` / `knowledge.map`
   for the new module
4. Bump version — `BBQ-chambers-v11.scad`, v10 kept unchanged
5. Update includes v10→v11
6. Commit all → merge to main
