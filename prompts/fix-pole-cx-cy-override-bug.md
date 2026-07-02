# cc Prompt — Fix pole_cx/pole_cy Override Bug (root cause of leg/pole position not tracking bed_w)
# Date: 2026-07-02
# Session goal: fix the specific defect that's now visibly breaking geometry.
# This is the SAME class of bug already fixed for $is_assembly in v27 —
# apply the same fix pattern to pole_cx and pole_cy.

## 1. REQUIRED READS
- git fetch — confirm current main HEAD (PR-01-assembly-v28.scad, pole_top.scad)
- pole_top.scad in full — specifically the standalone-defaults block added
  in v26 (PR-01-flatten-modules-v26), which guards pole_cx/pole_cy (among
  ~23 other globals) with an is_undef()-style self-reassignment pattern
- PR-01-assembly-v28.scad (confirms pole_cx/pole_cy ARE correctly computed
  from bed_w in the assembly file itself — the bug is in pole_top.scad
  silently overriding them via the include-flattening mechanism)
- prompts/archive/PR-01-fix-ghost-leak-toggle-relocate-v27 (the prior fix
  for the identical bug class on $is_assembly — use the same fix pattern)

## 2. CONTEXT
Janis confirmed visually (screenshots, v28): after bed_w 670→840, the bed
surface resized correctly but leg/pole positions did not move — they stayed
at the old ~670mm-based positions. Root cause: pole_top.scad's standalone-
defaults block (v26) contains a self-reassigning guard for pole_cx/pole_cy
(and reportedly ~23 other globals total, flagged but not fixed in v27's
cc_chat_log as "assigned...but overwritten"). Because `include` flattens
scope, OpenSCAD collapses the self-reference to the hardcoded fallback
value regardless of what PR-01-assembly-v28.scad actually computed from the
current bed_w. This was dormant/invisible before because the fallback
happened to numerically match the old bed_w=670 design — bed_w=840 broke
that coincidence and exposed the bug for the first time.

This is the SAME bug class as the $is_assembly ghost-leak fixed in v27 —
fixed there by replacing the self-reassigning pattern with a read-only
`function ghost_mode()`. Apply the identical fix strategy here.

## 3. NEW FILES
None — in-place edit to pole_top.scad (per the established modules-file
unversioned-edit exception, same as the v27 ghost-leak fix).

## 4. TASKS

### TASK 1 — Fix pole_cx/pole_cy specifically (priority — this is the bug
Janis can currently see)

In pole_top.scad, locate the standalone-defaults guard for `pole_cx` and
`pole_cy` (added in v26). It almost certainly follows the same broken
pattern as the old `$is_assembly` code:
```
pole_cx = is_undef(pole_cx) ? [hardcoded fallback array] : pole_cx;
pole_cy = is_undef(pole_cy) ? [hardcoded fallback array] : pole_cy;
```
Replace with the same read-only-function strategy used for `ghost_mode()`
in v27 — e.g. rename the assembly-computed values so they're never
shadowed, OR restructure so the fallback only applies in a genuinely
separate scope that cannot collapse against the assembly's real values.
cc has full discretion on exact implementation (read the live file, do not
guess syntax from this prompt) — the requirement is: when this file is
included from PR-01-assembly-v28.scad, pole_cx/pole_cy used by every
downstream module (bed_frame's legs, pole_body, pole_base_collar,
pole_wood_socket) MUST equal the assembly file's actual computed values,
never the standalone fallback, in 100% of cases — not just "usually."

Verify explicitly in cc_chat_log: state the actual `pole_cx`/`pole_cy`
values used by `bed_frame()` after this fix, computed from bed_w=840,
leg_w=180, leg_t=120, bed_l=2300. Expected: pole_cy = [60, 60, 780, 780].

### TASK 2 — Audit the remaining ~23 flagged globals (do not fix all of
them blind — categorize first)

Read through the full standalone-defaults block. For every remaining
guarded global (not just pole_cx/pole_cy), state in cc_chat_log:
- The variable name
- Whether its current fallback value happens to match the CURRENT assembly
  value (still dormant) or has now diverged (actively broken, like
  pole_cx/pole_cy were)
- Flag ANY that have diverged — do not silently fix them in this prompt
  unless Janis has approved each one; list them for a follow-up decision

This is an audit/report task, not a blanket fix — we got burned once by
assuming dormant means safe. Find out which ones actually are.

## 5. DO NOT TOUCH
- PR-01-assembly-v28.scad — the assembly file's own pole_cx/pole_cy formula
  is already correct, do not modify it
- Any geometry/module logic unrelated to the standalone-defaults block
- housing_*, neck_*, collar_* values — unless TASK 2's audit finds one has
  actually diverged, in which case flag only, do not fix without approval

## 6. QA VERIFICATION
- [ ] pole_cx/pole_cy confirmed equal to the assembly's computed values
      when included from PR-01-assembly-v28.scad — state actual numbers
- [ ] Standalone open of pole_top.scad alone still works (ghost-context
      preview still functions using its own fallback, unbroken)
- [ ] TASK 2 audit table present in cc_chat_log — every remaining guarded
      global categorized as dormant or diverged
- [ ] Janis F6 required: legs/poles now visibly at 60mm/780mm from bed
      edges, matching the 840mm bed width

## 7. MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-02
3. Update knowledge.map (pole_top.scad in-place edit, note per convention)
4. Bump version markers per file convention
5. Commit all → merge to main
