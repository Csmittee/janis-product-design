# CC PROMPT — bbq-chambers-v8-regular-octagon-continuous-channel
# Date: 2026-07-16
# Repo location: bbq-offset-smoker/BBQ-chambers-v8.scad (new, source v7)
# Two related fixes, both locally verified before writing this
# (SKILL_local_render.md): (1) `chamfer` was never actually producing a
# regular octagon — locked at 150mm, but the math for a true 8-equal-side
# octagon in a 610x610 square requires ~178.665mm. (2) The end-cap
# boundary (X=LID_X0/LID_X1) has a real, visible flat closing wall
# (PR #121's `lid_territory_end_caps()`) — Janis wants it gone entirely,
# not reshaped. Both are fixed together because the correct fix for (2)
# (making the fixed-side wedge run the FULL chamber_L continuously,
# rather than stopping at LID_X0/X1 and needing a separate end-cap
# module) naturally eliminates the wall from (2), and both touch the
# same modules.

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order, state every file read before writing a single line:
1. cc_rules.md
2. knowledge.map
3. cc_chat_log.md (first 3 entries)
4. bbq-offset-smoker/rules-bbq-fab.md
5. bbq-offset-smoker/SKELETON_WORKSHEET.md
6. bbq-offset-smoker/BBQ-chambers-v7.scad — LIVE file, in full. State
   the exact current value and every reference/usage of `chamfer` in
   the file (not just the ones this prompt names — grep for all of
   them, state the full list).
7. .claude/rules-codes.md
8. rules-dimensions.md — `chamfer` is likely listed there as a locked
   value; state what it currently says.

Claude Web override: none.

**R-009 duplication check is critical here** — `chamfer` is used in more
places than this prompt lists explicitly (at minimum `trough_h`,
`GRATE_Z`, `ROOM_BASE_Z`/`ROOM_TOP_Z`, and `fixed_shell_profile()` /
`firebox_passage_profile()`). Find every real usage before changing the
constant, not just the ones named in TASK 1-3 below. State the full list
in cc_chat_log before writing the fix.

## 2. CONTEXT

**Finding 1 — chamfer was never producing a regular octagon.** Claude Web
verified via real math (not guessed): for an octagon inscribed in a
610x610 square to have all 8 sides equal, `chamfer` must satisfy
`W - 2*chamfer = chamfer*sqrt(2)`, i.e. `chamfer = W/(2+sqrt(2))` ≈
**178.665mm** — not the locked 150mm value, which produces 4 sides at
310mm and 4 at 212.13mm (visually noticeable, correctly flagged by
Janis as "face A-B looks exaggerated" even though it's actually the
short chamfer faces that are short, not A-B that's long).

**Finding 2 — remove the end-cap wall entirely, not reshape it.**
`lid_territory_end_caps()` (PR #121) builds the end-margin zones as a
mostly-separate solid block with its own inner-facing closing wall at
X=LID_X0 and X=LID_X1. Janis wants NO visible wall there. Correct fix
(verified locally): don't treat the end margins as a separate capped
module at all. Instead, run the FIXED-side wedge (floor + wall + chamfer
+ half ridge — the same piece `chamber_outer_tube()`/
`chamber_inner_cavity()` already build) continuously across the FULL
`chamber_L` (0 to 915), never interrupted at LID_X0/LID_X1. Then add the
LID-side wedge (the complementary piece) as SOLID material ONLY across
the two end margins (X=[0,LID_X0] and X=[LID_X1,chamber_L]) — open
everywhere else. Since the fixed portion was never broken in the first
place, there's no internal wall to build or remove — the boundary is
just where the lid-side material starts/stops being present, sitting
flush against the continuous fixed portion with no separate closing face.

Real numbers, recomputed with the corrected chamfer (state these back
after your own verification, don't just copy them):
```
chamfer      = 178.665          // was 150 (locked value corrected)
trough_h     = 252.670          // was 310 (chamber_H - 2*chamfer)
GRATE_Z      = chamber_floor_z + chamfer   // = 778.665, was hardcoded 750
```

## 3. NEW FILES

None. New `BBQ-chambers-v8.scad` (source v7).

## 4. TASKS

### TASK 1 — Correct the chamfer constant

Change `chamfer = 150` to `chamfer = chamber_W / (2 + sqrt(2))` (a real
formula, not a hardcoded decimal — so it stays correct if chamber_W ever
changes). Update `rules-dimensions.md` and `rules-bbq-fab.md` to reflect
this is now the derived-correct value, not an arbitrary locked one —
note WHY (regular octagon requirement), so a future session doesn't
"correct" it back to 150 thinking that was the intentional lock.

### TASK 2 — Make GRATE_Z formula-derived, not hardcoded

Per your own R-009 check: if `GRATE_Z` is currently a literal `750`
(even with a comment saying "= chamber_floor_z + chamfer exactly"),
change it to the actual live formula `GRATE_Z = chamber_floor_z +
chamfer` so it moves automatically when chamfer changes (per Janis: "if
you do it right, grate will lift up naturally" — this only happens if
it's a real formula, not a comment claiming a coincidence). State the
new real numeric value after this file's own chamfer correction.

### TASK 3 — Rebuild chamber_outer_tube()/chamber_inner_cavity() as one continuous fixed channel, no end-cap wall

Replace the current architecture (fixed portion only for
LID_X0..LID_X1, plus `lid_territory_end_caps()` as a separate margin
module) with:

1. `fixed_side_wedge()` intersected with the true octagon ring, run
   continuously across the FULL `[0, chamber_L]` range — always present,
   never interrupted.
2. A second piece — same true octagon ring, intersected with the
   complementary lid-side wedge — built ONLY across `[0, LID_X0]` and
   `[LID_X1, chamber_L]` (solid closure at the margins, since the lid
   doesn't open there). Absent everywhere else.
3. Real end caps at the true ends (X=0, X=chamber_L) only, unchanged
   from v7's approach.
4. `lid_territory_end_caps()` as its own separate module is REMOVED
   (folded into this construction) — state explicitly in cc_chat_log
   that it's gone and why the replacement produces the same coverage
   without the internal wall.

Preserve `window_hole()` and `exhaust_room_opening()` subtractions
applied the same way as before.

**Verification required:** real CGAL probe at the LID_X0 and LID_X1
boundary planes confirming NO flat closing face exists there anymore —
the octagon ring's wall_t material should be continuous straight through
the boundary with only the lid-side material appearing/disappearing,
not a perpendicular closing wall. State this as a real check, not "looks
right."

### TASK 4 — Recompute exhaust room position for the new trough_h

Per Claude Web's prior max-flush decision (room stays flush against the
flat wall, doesn't extend into the chamfer) — recompute with the
corrected chamfer:
```
ROOM_BASE_Z = chamber_floor_z + trough_h - ROOM_H   // 752.67, was 810 under old chamfer
ROOM_TOP_Z  = ROOM_BASE_Z + ROOM_H                    // 852.67 — should land exactly at
                                                        // the new wall/chamfer boundary
```
Confirm this lands exactly at the new trough_h boundary (state the real
computed boundary value and confirm it matches).

### TASK 5 — Check firebox_passage_profile() for any regression

`firebox_passage_profile()` uses `fixed_shell_profile()` (kept, per v7's
own note, for this one caller) — which itself uses `chamfer`. Confirm
whether this changes the passage shape/area now that chamfer is
corrected, state the new real area (shoelace, same method as before),
and flag if it meaningfully changes anything Janis previously confirmed
about that passage — don't silently let this ripple through unnoticed.

## 5. DO NOT TOUCH

- `lid_profile()` — unchanged in shape, though its own chamfer-derived
  points will naturally update via the corrected constant (expected,
  not a bug)
- `firebox_shell()`, `fire_grate()`, `ash_tray()`, `firebox_door()` —
  unchanged
- `firebox_drop = 200mm` — still open
- `lid_hardware()` — still disabled
- Grate Y-range (`GRATE_Y0`/`GRATE_Y1`) formula itself — unchanged (it
  already derives from chamfer correctly; only the Z position needed
  the formula fix in TASK 2)
- Understructure — separate file
- rules-dimensions.md — TASK 1 updates the chamfer entry specifically;
  don't touch anything else in it

## 6. QA VERIFICATION

- [ ] TASK 1: chamfer = 178.665 confirmed via real formula, not hardcoded
- [ ] Octagon confirmed regular: all 8 edge lengths computed and stated,
      confirming equal (not just the 4-and-4 pairing from before)
- [ ] TASK 2: GRATE_Z confirmed formula-derived, new value stated
- [ ] TASK 3: real CGAL probe at both LID_X0 and LID_X1 boundaries
      confirms no closing wall remains
- [ ] TASK 3: full kinetic sweep (0-120°) re-verified, `Simple: yes`
- [ ] TASK 4: exhaust room boundary match confirmed numerically
- [ ] TASK 5: firebox passage area re-stated, any change flagged
- [ ] Full `BBQ-offset-smoker-base-v1.scad` assembly chain — `Simple: yes`
- [ ] Visual: iso + straight-on-into-opening renders showing regular
      octagon shape and no visible wall at either end-margin boundary
- [ ] No undefined variable warnings

## 7. MANDATORY CLOSING

1. Prepend `cc_chat_log.md` — newest entry at top, under 10 lines: state
   the corrected chamfer value, confirm all 8 sides equal, confirm the
   end-cap wall is gone (not just reshaped), state new GRATE_Z and
   exhaust room numbers
2. Archive this prompt → `/prompts/archive/` ✅ COMPLETE — 2026-07-16
3. Update `rules-dimensions.md` and `rules-bbq-fab.md` per TASK 1
4. Update `knowledge.map`, `PART_MANIFEST.md`, `SKELETON_WORKSHEET.md`
   to reflect `lid_territory_end_caps()` is removed/folded in
5. Bump version — `BBQ-chambers-v8.scad`, v7 kept unchanged
6. Update includes v7→v8
7. Commit all → merge to main
