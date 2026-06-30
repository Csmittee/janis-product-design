# CC PROMPT — PR-01-base v20 — pole_top_transition() Elbow Loft Fix

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order, state every file read before writing a single line:
1. cc_rules.md
2. knowledge.map
3. cc_chat_log.md (first 3 entries — newest at top)
4. .claude/SKILL_joint_construction.md
5. pilates-reformer/PR-01-base/PR-01-base-v19.scad (the live file — read in
   full, including the v19 coordinate-dump comment block at the top)

## 2. CONTEXT

v19's Task 1 coordinate dump (read in cc_chat_log, prior entry) found the
real root cause of the seam crease in `pole_top_transition()`: it is NOT a
shape/size mismatch (both ends are round, both 47mm diameter) — it is an
AXIS-ORIENTATION mismatch. The neck's top cross-section sits on the Z-axis
at world (cx, cy, 2001.5); the bell's small-face cross-section sits on the
X-axis at world (cx∓45, cy, 2020) — a 90° rotation plus a 3D offset (45mm
in X, 18.5mm in Z) bridged by a single `hull()`. A single hull() across a
twisted, non-coplanar, non-parallel-axis gap like this produces a diagonal
saddle facet — this is the crease visible in every screenshot since v17.

Per SKILL_joint_construction.md Rule 2, the fix is a multi-step loft, not a
shape change — but here the thing being interpolated is ORIENTATION
(rotation angle 0°→90°) and POSITION along a smooth path, not cross-section
shape (diameter stays constant at 47mm throughout). Think of this as a
smooth elbow-pipe fitting: sweep a constant-diameter circular cross-section
along a curved path from vertical (neck) to horizontal (bell), instead of
jumping straight between the two end orientations.

## 3. NEW FILES

NONE — new version of the existing PR-01-base file (save-as v20).

## 4. TASKS

### TASK 1 — Rebuild pole_top_transition() as a multi-step elbow loft

Replace the current single `hull()` (quoted verbatim in v19's cc_chat_log
entry, lines ~524-531) with a loft of minimum 8 intermediate circular
cross-sections, each `d=neck_od` (47mm, constant — no diameter change
through the loft), positioned and rotated as follows:

- Parametrize `t` from 0 to 1 across 8 steps (t = 0, 1/7, 2/7, ... 1).
- At each `t`, interpolate:
  - Position: linearly interpolate from neck-top anchor
    `(cx, cy, neck_top)` to bell-small-face anchor
    `(bell_small_face_x, cy, xbar_z)` (use the exact same variable names/
    values already defined in the live file — do not hardcode the 45/18.5
    numbers, derive from the existing anchor variables so this stays
    correct if upstream values ever change).
  - Rotation: linearly interpolate the cross-section's normal axis from
    Z (0°, matching the neck's `cylinder()` default orientation) to X (90°,
    matching the bell's `rotate([0,90,0])` orientation) — i.e. each
    intermediate step is `rotate([0, 90*t, 0])` applied to a small
    `cylinder(h=e, d=neck_od, $fn=64)` slice, translated to its
    interpolated position.
  - For a smoother elbow curve (not a straight diagonal path), bias the
    position interpolation using an eased curve (e.g. smoothstep:
    `t_eased = t*t*(3-2*t)`) rather than pure linear — this keeps the
    tangent vertical near the neck and horizontal near the bell, avoiding a
    kinked appearance at either end.
- `hull()` each adjacent pair of the 8 steps (7 hull() pairs total), then
  union all 7 hulled segments together into the final
  `pole_top_transition()` solid.
- Re-apply the existing bore-envelope subtraction (from v18/v19, the
  defensive bore-clearance cylinder) across the FULL transition solid after
  the union, not just at the two end steps — confirm in cc_chat_log that
  every one of the 8 intermediate cross-sections clears the bore envelope,
  not just the first and last.

### TASK 2 — Verification math, not just "looks smooth"

State explicitly in cc_chat_log:
- The 8 interpolated (position, rotation) pairs used — list all 8 as
  `(x, y, z, rotation_deg)`.
- Confirm neck_od (47mm) used consistently at all 8 steps — zero diameter
  drift.
- Confirm first step (t=0) coincides exactly with the neck's existing top
  cross-section, and last step (t=1) coincides exactly with the bell's
  existing small-face cross-section — state the position/rotation match
  numerically (should be 0mm / 0° delta at both ends).
- Confirm the eased interpolation keeps every intermediate step's circle
  non-self-intersecting with its neighbors (no degenerate hull()).

## 5. DO NOT TOUCH

- Bore diameter (33mm), bore axis (X)
- Bell exterior wine-glass profile (both ends, from v19) — unchanged
- `head_large_r` (40mm), `head_small_r` (23.5mm) — unchanged
- `pole_od` (40mm), `neck_od` (47mm), `neck_h`, D-profile zone, bolt
  positions/orientation (all confirmed correct in v18, untouched in v19) —
  unchanged
- `pole_body()`, `pole_base_collar()`, `pole_wood_socket()`, crossbar
  geometry
- rules-dimensions.md, rules-pr.md — read only
- VM-01-base — not in scope
- All `.scad` files not named in TASKS

## 6. QA VERIFICATION

- [ ] All 8 (position, rotation) interpolation pairs stated explicitly in
      cc_chat_log
- [ ] Confirm neck_od constant (47mm) across all 8 steps — zero drift
- [ ] Confirm t=0 and t=1 steps match the existing neck-top and bell-small-
      face cross-sections exactly (state the 0mm/0° deltas)
- [ ] Confirm bore-envelope subtraction re-applied across the full lofted
      solid, all 8 steps individually clear it
- [ ] Confirm neck + transition + bell remain siblings in one color()
      block → single manifold solid (Rule M-1)
- [ ] No undefined variable warnings, brace/paren balance clean (state the
      actual count)
- [ ] Version incremented — save as PR-01-base-v20.scad, v19 not overwritten
- [ ] State explicitly: no OpenSCAD binary in cc sandbox — this is code-
      review + coordinate-math verification only, Janis must F5/F6 render
      to confirm visually (specifically: confirm the diagonal crease is
      gone) before PASS

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at TOP, include all interpolation
   numbers, not a summary.
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Update knowledge.map — v19 → Superseded, v20 → ACTIVE
4. Bump version header on every file changed (v20 scad, cc_chat_log.md,
   knowledge.map)
5. Commit all → merge to main

Confirm what you changed after commit. Per SKILL_joint_construction.md's
isolation discipline, this is Prompt 2 of 2 (coordinate dump was Prompt 1)
— if this fails QA, R-111 fires again on this same problem and escalates
to Janis directly rather than a 3rd attempt.
