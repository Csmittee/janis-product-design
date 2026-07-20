CC PROMPT — bbq-chambers-v15-square-shell-cylinder-firebox
================================================================
Repo location: bbq-offset-smoker/BBQ-chambers-v15.scad (new, source v14.2)

REVISION NOTE: real structural redesign, bigger than v14.1/v14.2's
targeted fixes. Outer shell rebuilt as a true CUBE — 580x580x580, all
three dimensions equal ("dice" proportions, Janis's own explicit
direction) — inner rectangular duct RETIRED entirely, replaced by a
cylinder with a real 62mm wall clearance on all sides. Chamber
apex(950mm)/`chamber_floor_z`(771.335mm) — UNCHANGED, do not touch.
Understructure remains completely out of scope (a separate, already-
prepared v6 prompt depends on THIS round's real output — do not open
BBQ-understructure-v5.scad).

## 1. CC INTRO

Session continuity check (cc self-determines):
Are cc_rules.md, knowledge.map, and cc_chat_log.md already loaded in
your active context from earlier in THIS session, with no git
pull/merge to main since?
→ YES: CONTINUATION. Skip re-reading those three. State "Continuation —
  governance already current" and go straight to TASKS.
→ NO: FRESH. `git fetch --all && git checkout main && git pull origin
  main`. Read cc_rules.md → knowledge.map → cc_chat_log.md (first 3
  entries). State every file read before writing a line.

Claude Web override: none

**MANDATORY FIRST CHECK — confirm real, live values in
BBQ-chambers-v14.2.scad before touching anything**: `chamber_floor_z`
(expect 771.335mm), apex A/`GRATE_Z` (expect 950mm), `firebox_floor_z`
(expect 571.4mm, about to change), `FIREBOX_W` (expect 580mm, staying
unchanged), `FIREBOX_H` (expect 428.6mm, about to change to 580mm),
`FIREBOX_L` (expect 460mm, about to change to 580mm), the real current
trapezoid passage dimensions (bottom≈95.29mm/top≈227.00mm/height≈
188.665mm, area≈47.124in²), and the real current fire volume (expect
≈5,890.51in³). If ANY differ from expected, STOP and flag.

Task-specific reads:
1. bbq-offset-smoker/BBQ-chambers-v14.2.scad — LIVE, in full. Need the
   real current `outer_shell_footprint_2d()`/`outer_shell_flange_2d()`/
   `outer_shell()` construction (TASK 1 rebuilds around these), the
   real current inner duct module(s) (TASK 2 retires and replaces
   these), and `firebox_passage_profile()`'s real current construction
   (TASK 3 reshapes this).
2. `true_octagon_profile()`'s real boundary (all reference heights) —
   needed for TASK 3's containment check on the new, larger passage.
3. .claude/rules-codes.md
4. .claude/SKILL_joint_construction.md

## 2. CONTEXT

Real design direction this round (Janis's own reasoning, stated
explicitly): the current firebox reads visually "too flat/wide" and
sits too far below the wheel axle plane. Raising the outer shell's own
height to match its width, and going further to make ALL THREE
dimensions equal (580x580x580, a true cube — Janis's own explicit
"dice" reference against the sample photos) both (a) looks more
proportional and (b) genuinely closes ~151mm of the real gap between
the firebox bottom and the axle plane — real numeric outcome, not just
a visual guess (see TASK 1 math below).

Separately, the inner rectangular duct is being replaced by a real
cylinder — closer to the reference photos Janis is building against
(round fire-holding cylinder inside a square insulating shell). Real
volume math (this session, Claude Web + Janis, using a fixed 62mm wall
clearance per Janis's own explicit choice — well over this project's
30mm-minimum insulation-gap standard, and confirmed a safe choice
since the gap is staying OPEN AIR this round, not filled — a wide open
gap risks natural-convection heat loss, but 62mm was a deliberate,
informed choice, not a default): diameter = 580 − 2×62 = **456mm**, at
the full 580mm depth this yields a real fire volume ≈5,779.9in³ (≈
100.75% of the standing 5,737in³ 1/3-chamber target) — state your own
live V=πr²×depth confirmation.

**Reused directly from v14's own architecture, not new**: outer shell
and inner fire-holding assembly are ALREADY built as two fully
independent welded assemblies (v14's own real design decision) — this
round leans on that same independence, it does not reintroduce it.

## 3. NEW FILES

None. New `BBQ-chambers-v15.scad` (source v14.2).

## 4. TASKS

### TASK 1 — Outer shell: rebuild as a true cube (580x580x580)

`FIREBOX_H` (outer shell height) changes from 428.6mm to **580mm**.
`FIREBOX_W` (580mm) stays UNCHANGED — do not touch. `FIREBOX_L` (see
TASK 2) also becomes 580mm this round, making all three real dimensions
equal — confirm live that the outer shell's own physical footprint
reads as a true cube, not just a square cross-section extruded to an
unrelated length.

Firebox top (`firebox_z1`) stays pinned at the current real fixed
datum (state its real current value, expect 1000mm) — UNCHANGED. This
means `firebox_floor_z` (bottom) recomputes automatically:
```
firebox_floor_z = firebox_z1 - FIREBOX_H = 1000 - 580 = 420mm (state real live result)
```
Real, direct consequence, stated not silently absorbed: the firebox
now extends further BELOW `chamber_floor_z`(771.335mm) than before —
from ~200mm below (v14.2) to ~351mm below (v15). The outer shell's own
flat, full-height, unclipped construction (v14.1's own real fix — no
zone-clipping, no octagon intersection below the floor) should extend
correctly to this new range by the SAME "no material below the floor"
convention already established — Janis's own explicit direction is to
let this fill in automatically via that existing construction, not a
new module. Real CGAL re-verification required regardless (see QA) —
confirm live, do not assume the existing flat-plane logic still
produces a clean manifold result at the new, larger range.

### TASK 2 — Replace the inner rectangular duct with a cylinder

RETIRE the current inner duct module(s) entirely (state what's
removed, confirm zero remaining callers per R-009 before deleting).

NEW cylinder, real values (confirm live against the real current fire-
volume formula before finalizing — these are Claude Web's calculated
values, not yet cc-verified):
- Wall clearance = **62mm** on all sides — Janis's own explicit,
  deliberate choice (well over this project's 30mm minimum; the gap
  stays OPEN AIR this round, not insulation-filled — a wide open gap
  can risk natural-convection losses in principle, but 62mm was chosen
  knowingly, not a default to second-guess here)
- Diameter = 580 − 2×62 = **456mm** (radius 228mm) — state your own
  confirmed value
- Depth (X) = **580mm** (equal to W/H, per TASK 1's cube requirement)
- Real resulting volume: state your own live V=πr²×depth computation
  (expect ≈94.7 million mm³ / ≈5,779.9in³, ≈100.75% of the standing
  5,737in³ 1/3-chamber target — confirm live, small variance is fine,
  do not force an exact match by adjusting the diameter away from the
  real 62mm-clearance value above)

Position: cylinder's own center aligned to the outer shell's own
cross-sectional center — same Y-center (`DATUM_Y_CENTER`=305, read
live) and same Z-center (`firebox_floor_z` + `FIREBOX_H`/2, read live,
expect ≈710mm). Real construction: same "welds directly to the
chamber's own octagon end cap, independent of the outer shell" pattern
v14 already established for the rectangular duct — reuse that
attachment logic, don't redesign it.

`FLANGE_LEN`(20mm, additive structural flange on the outer shell) —
UNCHANGED, still applies to the outer shell's own physical length
independent of the cylinder's own 580mm interior depth. Real
consequence, stated not silently absorbed: outer shell's own total
physical length (`FIREBOX_SHELL_L` = FIREBOX_L + FLANGE_LEN) grows to
**600mm** (was 480mm in v14.2) — the firebox now occupies 120mm more
of the chamber's own X-length than before. Real check required: confirm
this still clears whatever else shares that axis (grate margins, lid
territory bounds, exhaust room position) — state the result, do not
assume it fits just because it wasn't flagged as a conflict on paper.

### TASK 3 — Rear passage: re-derive shape and size for the cylinder

The current trapezoid passage was derived from the octagon boundary to
match a RECTANGULAR duct — with the duct now round, re-evaluate
whether a circular passage (matching the cylinder's own cross-section)
is the correct shape, or whether the trapezoid derivation still
applies. State your own reasoning, don't assume trapezoid-by-default.

Real target area, using this round's real NEW fire volume (state your
own live value, expect ≈5,779.9in³ per TASK 2's real 62mm-clearance
result, ≈100.75% of the theoretical 5,737in³ rule target):
```
target_area = fire_volume × 0.008 (state real result in in² and mm²,
expect ≈46.24in² / ≈29,835mm² — using the REAL built fire volume, not
the theoretical target, same convention v14.2 used)
```
Real containment check, mandatory: whatever shape you land on must be
verified via real CGAL against `true_octagon_profile()`'s actual
boundary — the passage is now potentially larger/differently
positioned than v14.2's trapezoid, do not assume the old containment
result still holds. State the real result explicitly (contained / not
contained, real margins).

Real cut-through verification (same rigor as v14.2's own TASK 2): ray-
probe or equivalent real geometric check confirming a genuine through-
hole, not a visual read.

### TASK 4 — End partition to hold the cylinder in place

NEW module: a square end plate (matching the outer shell's own 580x580
footprint) with a circular cutout matching the cylinder's real
diameter (456mm, read live from TASK 2), positioned at the door-side
(front) end of the cylinder — physically supports/locates the cylinder
within the square outer shell, per Janis's reference photo. State your
real chosen thickness/material-representation (same "thin uniform-
thickness shell" simplification convention as other formed panels in
this project) and real Z/X position relative to the cylinder's own
real end face.

## 5. DO NOT TOUCH

- `chamber_floor_z`(771.335mm), apex A(950mm), `GRATE_Z_FIXED` — all
  chamber-body datums, zero changes
- `FIREBOX_W`(580mm) — stays unchanged, only H changes
- `FIREBOX_L` interior depth is being REDEFINED to 580mm (was 460mm)
  as part of TASK 2 — this is an intentional change, not a DO NOT TOUCH
  item, stated here to avoid confusion with the width constant above
- `BBQ-understructure-v5.scad`/`BBQ-understructure-v6.scad` — entirely
  out of scope, do not open
- rules-dimensions.md, cc_rules.md — read only

## 6. QA VERIFICATION

- [ ] TASK 1: real new `firebox_floor_z` stated (expect 420mm), real
      CGAL re-verification of the flat-plane "no material below floor"
      construction at the new range — `Simple: yes`
- [ ] TASK 2: real live cylinder volume computation stated (expect
      ≈5,779.9in³, ≈100.75% of the 5,737in³ target), real wall
      clearance confirmed (expect exactly 62mm), real new
      `FIREBOX_SHELL_L` stated (expect 600mm) with real length-budget
      check against the chamber's other X-axis features, zero-contact
      check (outer shell vs. inner cylinder, same mandatory check as
      v14) re-run and confirmed EMPTY
- [ ] TASK 3: real target area stated (in² and mm²), real shape
      decision stated with reasoning, real containment check result,
      real through-hole verification result
- [ ] TASK 4: end partition real dimensions/position stated, real
      check that it doesn't collide with the cylinder or the outer
      shell's own interior wall
- [ ] Full CGAL manifold sweep, `Simple: yes` on every solid
- [ ] Full kinetic sweep (lid, firebox door) — `Simple: yes` throughout
- [ ] Screenshots: iso/front/side/rear + open-door view showing the
      real cylinder + end partition + passage through-hole
- [ ] Error-Log clean

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at top, under 10 lines: real
   new firebox_floor_z, real cylinder diameter/volume/clearance, real
   passage shape+area+verification result.
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Update knowledge.map, PART_MANIFEST.md, SKELETON_WORKSHEET.md — full
   firebox section rebuild
4. Update `bbq-offset-smoker/design_scope_of_work_rule.md` — Envelope
   section: firebox now square outer shell + cylindrical inner, real
   built values; bump version
5. Save as BBQ-chambers-v15.scad (v14.2 kept); update
   BBQ-offset-smoker-base-v1.scad's include pointer chain per prior
   precedent (understructure still out of scope this round)
6. Commit all → merge to main
