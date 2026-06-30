# CC FIX PROMPT — PR-01-base v8 — Crossbar Seating + Overshoot Fix

## 1. CC INTRO
git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → cc_chat_log.md (first 3 entries) → rules-dimensions.md → pilates-reformer/PR-01-base/PR-01-base-v7.scad
State every file read before writing a single line.

## 2. CONTEXT
Janis QA on v7 (3 screenshots) = FAIL. Root cause confirmed by direct code read (Claude Web), not guessed:
- Crossbar Z position floats above the pole_top() boss instead of seating inside it (visible gap)
- Crossbar length/origin and end caps are positioned at bed extremes (X=0, X=bed_l) instead of at the actual pole centers, causing the bar to overshoot past the poles
- Secondary: $fn resolution mismatch between pole_body() (64) and pole_top()/pole_base_collar()/pole_wood_socket() (default 32) gives those parts a faceted/knurled look in render

## 3. NEW FILES
NONE

## 4. TASKS

1. **pilates-reformer/PR-01-base/PR-01-base-v7.scad → save as v8**

   a. Fix `xbar_z` formula (currently adds top_boss_h*0.5, should subtract, to seat bar mid-height in the top boss rather than above it):
      Change: `xbar_z = bed_h + pole_h + top_boss_h * 0.5;`
      To: `xbar_z = bed_h + pole_h - top_boss_h * 0.5;`

   b. Fix crossbar length and origin to run pole-center to pole-center, not bed-edge to bed-edge:
      Change: `grip_l = bed_l;`
      To: `grip_l = bed_l - leg_w;` (distance between front-left and front-right pole centers)
      In `crossbar_body()`, change the X origin from `0` to `leg_w/2` so the bar starts at the pole center, not the bed edge.

   c. Fix `crossbar_end_cap()` call positions in `crossbar_assembly()` — currently hardcoded to `0` and `grip_l` (bed extremes). Change to use actual pole center X positions:
      Front row: `pole_cx[0]` and `pole_cx[1]`
      Rear row: `pole_cx[2]` and `pole_cx[3]`

   d. Set `$fn = 64` explicitly on `pole_top()`, `pole_base_collar()`, and `pole_wood_socket()` cylinders to match `pole_body()` resolution and eliminate the faceted/knurled look.

2. Verify after fix: crossbar visually seats inside the pole_top() boss with no gap, and terminates flush at each pole pair with no overshoot — confirm both in cc_chat_log with the actual computed xbar_z and grip_l values.

## 5. DO NOT TOUCH
- rules-dimensions.md — read only
- VM-01-base — not in scope
- All other geometry: pole_body() D-profile, pole_wood_socket() depth/OD, pole_base_collar() pin dimensions — unchanged, Stage 2 scope only
- bed_frame(), bed_surface() — unchanged

## 6. QA VERIFICATION
- [ ] No undefined variable warnings in SCAD
- [ ] Version incremented — save as PR-01-base-v8.scad, never overwrite v7
- [ ] State actual computed xbar_z value in cc_chat_log
- [ ] State actual computed grip_l value in cc_chat_log
- [ ] Confirm crossbar end caps align with pole_cx positions (state the 4 X values used)
- [ ] Confirm $fn=64 applied to all three previously-default-32 modules

## 7. MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Update knowledge.map if new files created
4. Bump version on all changed files (PR-01-base v7→v8)
5. Commit all → merge to main
