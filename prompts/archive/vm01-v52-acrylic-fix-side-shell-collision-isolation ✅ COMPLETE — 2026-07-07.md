# cc Prompt — Fix Double-Layer Acrylic Regression + Targeted Top-Panel AND
# Left-Side-Shell vs Door Collision Test (v51 QA)
# Date: 2026-07-07
# Source: vending-machine/VM-01-base/VM-01-base-v51.scad (current ACTIVE)

## 1. CC INTRO

Session continuity check: main has changed since v51 merged (PR #96) —
treat this as FRESH regardless of your own session state.
git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → knowledge.map → cc_chat_log.md (first 3
entries) → rules-dimensions.md → PART_MANIFEST.md (VM-01) →
vending-machine/VM-01-base/VM-01-base-v51.scad (current committed
source). State every file read before writing a single line.

Claude Web override: none.

## 2. CONTEXT

Two separate findings from Janis's v51 QA pass:

**Finding A — double-layer acrylic, a real regression from the last
prompt's Task 4.** The instruction was to REMOVE the old steel-bar patch
entirely and extend the door's own shell material to fill the gap it
left, so the acrylic pane remains the only visible/attached material at
the back of that zone. Instead, screenshot evidence shows what looks like
TWO overlapping acrylic-colored layers after the top strip's removal —
suggesting a new fill piece was added ALONGSIDE the existing acrylic
rather than the old element being properly removed and replaced. This is
a quality defect, not a manifold issue — fix it as its own task.

**Finding B — door-closed-only manifold warning, Janis's own elimination
already narrows this significantly, refined further since the first
report — read carefully, the exact condition matters.**

Her systematic test sequence, already run (do not repeat these — trust
and build on them):
- Door open → no error. Door closed → error. (confirms door-state-
  dependent, already known)
- Front inner frame (tray_zone_frame) removed → error persists → RULED
  OUT
- Acrylic removed → error persists → RULED OUT
- Closing/latch side inspected visually → nothing abnormal
- Top shell removed ALONE → error persists
- Bottom shell removed ALONE → error persists
- Side shell removed ALONE → error persists (an earlier report said this
  alone cleared it — superseded by the more careful test below, do not
  rely on the earlier single-variable result)

**The refined, precise finding: error clears ONLY when `show_shell_top =
false` AND `show_shell_left = false` TOGETHER — not either alone.** This
is a meaningful difference from "just the side" — it strongly suggests
TWO separate contact points exist (one involving the top panel, one
involving the left/hinge-side wall), each independently sufficient to
trigger the 2-manifold warning on its own, so removing only one still
leaves the other's overlap in place. Do not assume a single unified
cause — go in expecting to find and report two distinct overlaps, and
say explicitly if you instead find they're actually the same root
feature spanning both panels.

Bottom was confirmed NOT part of the condition (removed alone, error
persists; not needed in the combination that clears it) — do not spend
time on bottom this round.

## 3. NEW FILES
None. Edits to existing VM-01-base file, new version v51→v52.

## 4. TASKS

### TASK 1 — Fix the double-layer acrylic regression

Find the exact change made in the last prompt's Task 4 (steel-bar
removal + shell-fill). Confirm whether a NEW piece was added as a
sibling/addition alongside the existing acrylic pane, rather than the
old steel-bar element being deleted and the door's shell material
properly extended in its place. State explicitly what you find — do not
assume the hypothesis above is correct without checking the actual
geometry.

Fix so there is exactly ONE piece of material in that zone at the back
of the door: either the acrylic pane alone (if no fill was actually
needed there) or the shell material extension alone (replacing the old
bar) — not both. Confirm the final result has zero overlapping/duplicate
geometry in this area before reporting done.

### TASK 2 — Isolate BOTH overlaps (top-vs-door AND left-side-vs-door) —
### do NOT blind-fix yet, confirm exact geometry for each first

With the door in its closed position (`door_open_deg = 0`), run an actual
intersection test (CGAL boolean intersection if the OpenSCAD binary is
available this session — state explicitly whether it is; if not,
fall back to precise coordinate/arithmetic overlap checking, same
standard used for the v51 arithmetic verification) between the door's
full closed-position geometry (`left_zone_door()` at `door_open_deg = 0`)
and EACH of the following, checked independently:

1. **The top shell panel** — the exact top-panel geometry in
   `outer_shell_debug()` that `show_shell_top` controls. Find where it
   overlaps the door's closed swept volume. This is a distinct check
   from Task 2.2 below — do not assume it's the same feature.
2. **The left-side shell wall, INCLUDING its hinge-side recess pocket**
   (`outer_shell_debug()`'s left-wall recess for the door's return
   flange/hinge line — the `shell_hinge_x/y/z`, `shell_return_depth`
   calculation).

Expect these to be TWO SEPARATE overlaps per Janis's refined finding
(error only clears when BOTH are removed together) — report each
independently with its own exact coordinates/volume. If you instead find
they trace to one single underlying feature that happens to be cut by
both toggles, state that explicitly and explain how.

Also separately confirm the RIGHT side shell wall has zero overlap with
the closed door (bottom was already confirmed clean by Janis's own
testing — do not re-check bottom).

Report the EXACT overlapping coordinates/volume for each of the two
findings, and which specific sub-feature of the shell (not just "the top
panel" or "the left wall" generally) is responsible — e.g., the recess
pocket's depth, a specific face, a specific edge. Do not propose or make
a fix in this task — isolation and precise reporting only, per the
project's isolate-before-fix discipline. A fix comes in a follow-up
prompt once the exact responsible geometry is confirmed for both.

## 5. DO NOT TOUCH

- `tray_zone_frame()`, `drop_zone_guards()`, `tray_compartment_partition()`,
  `exit_compartment_wall()` — already ruled out by Janis's own testing,
  do not re-test or modify
- Top and bottom shell geometry — already ruled out, do not modify
- The acrylic pane's own position/dimensions — Task 1 only removes a
  duplicate/regression, does not resize or reposition the acrylic itself
- Any dimension in `rules-dimensions.md` beyond what Task 1 requires to
  correct the duplicate-layer issue
- Any PR-01 file

## 6. QA VERIFICATION

- [ ] Confirmed whether the last prompt's Task 4 created a duplicate/
      sibling layer instead of a true removal-and-replace — stated
      explicitly, not assumed
- [ ] Exactly one material layer now exists in that door zone — confirmed
      via render or precise geometry check
- [ ] OpenSCAD binary availability this session stated explicitly
- [ ] Top-panel vs. closed-door intersection: exact overlap
      coordinates/volume reported, or zero overlap confirmed
- [ ] Left-side shell wall (recess pocket/hinge area) vs. closed-door
      intersection: exact overlap coordinates/volume reported, or zero
      overlap confirmed — reported as a SEPARATE finding from top, not
      merged
- [ ] If both traced to one underlying feature instead of two, stated
      explicitly with explanation
- [ ] Right-side shell wall vs. closed-door: confirmed clean, explicitly
      checked
- [ ] Specific sub-feature named (not just "left wall" generally)
- [ ] No fix attempted on Task 2's finding — isolation/reporting only,
      confirmed
- [ ] No new manifold warnings introduced by Task 1's fix
- [ ] Version incremented v51 → v52, v51 untouched

## 7. MANDATORY CLOSING

1. Prepend `cc_chat_log.md` — newest entry at TOP, under 10 lines:
   double-layer fix confirmation, exact left/right side intersection
   findings with coordinates, specific sub-feature identified or flagged
   unresolved
2. Archive this prompt → `/prompts/archive/` ✅ COMPLETE — 2026-07-07
3. Update `knowledge.map` only if a new sub-feature name/constant
   warrants a note
4. Bump `rules-dimensions.md` only if Task 1's fix changes a stated
   dimension
5. Commit all → merge to main
