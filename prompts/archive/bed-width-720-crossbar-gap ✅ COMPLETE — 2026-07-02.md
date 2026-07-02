# cc Prompt — Bed Width Adjustment (crossbar gap = 720mm)
# Date: 2026-07-02
# Session goal: single dimensional fix, PR-01-base ACTIVE MODEL

## 1. REQUIRED READS
- git fetch — confirm current main HEAD, confirm PR-01-assembly-v27.scad is
  the merged/current file (Janis confirmed PR #66 merged this session)
- PR-01-assembly-v27.scad (current bed_w, leg_t, xbar_y_front/rear)
- rules-dimensions.md

## 2. CONTEXT
Janis: current gap between the two long crossbars (720mm target) reads too
narrow at the current bed_w=670mm. Gap = bed_w - leg_t = 670-120 = 550mm
today. Target: 720mm gap, leg_t unchanged. Solved value: bed_w = 840mm.

## 3. NEW FILES
None.

## 4. TASKS

### TASK 1 — Update `PR-01-assembly-v27.scad` → save as `PR-01-assembly-v28.scad`
Change:
```
bed_w       = 670;    // total bed width — PENDING Janis confirm
```
To:
```
bed_w       = 840;    // total bed width — Janis-confirmed 2026-07-02, sets
                       // crossbar gap (xbar_y_rear - xbar_y_front) = 720mm
                       // with leg_t=120 unchanged. Formula: bed_w = 720 + leg_t.
```
No other value on this line or nearby lines changes. `leg_t` stays 120mm.

### TASK 2 — Verify derived values
Confirm in cc_chat_log the computed result:
- `xbar_y_front = leg_t/2` = 60mm
- `xbar_y_rear = bed_w - leg_t/2` = 780mm
- Gap = xbar_y_rear - xbar_y_front = **720mm** ✓
State these three numbers explicitly in cc_chat_log — do not just say "updated."

### TASK 3 — Update `rules-dimensions.md`
Under the PR-01 dimensions area, update the bed_w entry (or add one if none
exists yet) to reflect: `bed_w = 840mm — Janis-confirmed 2026-07-02, derived
from 720mm crossbar-gap target (bed_w = 720 + leg_t)`. Do not touch any other
PR-01 dimension row.

## 5. DO NOT TOUCH
- pole_top.scad — zero change
- leg_w, leg_t, bed_l, bed_h, pole_d, pole_h — all unchanged this prompt
- Any housing_*, neck_*, collar_*, socket_* parameter — unrelated to this fix
- .claude/SKILL_customizer_profile.md and its WORKFLOW_SKILL/chat_rules entries
  (separate PR, may still be pending — do not touch regardless of its status)

## 6. QA VERIFICATION
- [ ] bed_w = 840 exactly, comment updated as specified
- [ ] cc_chat_log states xbar_y_front=60, xbar_y_rear=780, gap=720 explicitly
- [ ] No other numeric value changed anywhere in the file — diff should show
      exactly one line changed plus the version-bump header
- [ ] File saved as PR-01-assembly-v28.scad, v27 untouched
- [ ] rules-dimensions.md bed_w entry updated, nothing else touched

## 7. MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-02
3. Update knowledge.map if needed (new file PR-01-assembly-v28.scad)
4. Bump version on all changed files
5. Commit all → merge to main
