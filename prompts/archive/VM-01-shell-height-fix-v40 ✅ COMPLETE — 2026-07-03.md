# CC PROMPT — VM-01 Shell Height Fix (outer_shell_debug leg_h double-count)
# Date: 2026-07-03
# Save to: /prompts/VM-01-shell-height-fix-v40.md
# Sequencing: Janis confirmed this fix lands FIRST, front-door redesign
# follows in a separate prompt (VM-01-front-door-redesign-v41.md).

---

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order before touching anything. State every file read:
1. cc_rules.md
2. cc_chat_log.md (last 3 entries)
3. rules-dimensions.md
4. vending-machine/VM-01-base/VM-01-base-v39.scad (current committed source, PR #80)

---

## 2. CONTEXT

Janis reported the acrylic panel still appears to "not comply with the body
corner curve" near the top-right corner even after v39's Y-recess fix (PR
#80). Diagnosed by Claude Web via local OpenSCAD install + STL bounding-box
measurement (not visual guess):

`outer_shell_debug()` (the module actually called in ASSEMBLY, via
`translate([0, 0, leg_h]) outer_shell_debug();`) builds its own
`rounded_box(total_w, total_h, total_d, corner_r)` using the FULL `total_h`
(700) as its own local extrusion height. Combined with the external
`+leg_h` (50) translate in ASSEMBLY, this double-counts leg height: the
shell's real world Z range is 50→750, not the intended 50→700.

Measured directly: exported `outer_shell_debug()` alone (as called in
ASSEMBLY, with its translate) to STL — bounding box Z = 50.00 to 750.00.
After changing the module's own extrusion height from `total_h` to
`total_h - leg_h`, re-measured: Z = 50.00 to 700.00 (correct).

This means the shell's actual roofline has been floating 50mm above every
other Z-referenced feature in the file (acrylic panels top out at world
Z=698, dashboard, tray zones — all calibrated assuming the roof sits at
world Z=total_h=700). That mismatch is what reads as the acrylic "not
matching the corner" near the top.

This is NOT a flaw in v39's acrylic Y-recess fix (PR #80) — that fix is
correct and addressed a different (X/Y-plane) issue. This is a separate,
pre-existing bug in `outer_shell_debug()` specifically (not its non-debug
twin `outer_shell()`, which received an equivalent leg_h fix back in v14
per cc_chat_log — `outer_shell_debug()` was added later and never got the
same fix). Likely present since assembly switched to calling
`outer_shell_debug()` for its show_shell_* toggles (~v17).

---

## 3. NEW FILES

None. Edits VM-01-base-v39.scad in place, saves as v40.

---

## 4. TASKS

### TASK 1 — Fix `outer_shell_debug()` height math

File: `vending-machine/VM-01-base/VM-01-base-v39.scad`
Module: `outer_shell_debug()` (currently ~line 280)

Add a local variable at the top of the module:
```
shell_h = total_h - leg_h;
```

Replace the outer shape call:
```
rounded_box(total_w, total_h, total_d, corner_r);
```
with:
```
rounded_box(total_w, shell_h, total_d, corner_r);
```

Replace the hollow-interior subtract call:
```
rounded_box(total_w-(skin_t*2), total_h-(skin_t*2), total_d-(skin_t*2), corner_r-1);
```
with:
```
rounded_box(total_w-(skin_t*2), shell_h-(skin_t*2), total_d-(skin_t*2), corner_r-1);
```

These are the ONLY two lines to change in this module. Every door/window/
cutout `translate()` inside `outer_shell_debug()` already uses the correct
"local Z = world Z − leg_h" convention (e.g. `tray_zone_top_z - leg_h`) and
must NOT be touched — they are already correct relative to the fixed
`shell_h`.

Save as `VM-01-base-v40.scad`.

---

## 5. DO NOT TOUCH

- `acrylic_display()` — v39's Y-recess fix (PR #80) is correct, do not
  modify or revert
- `outer_shell()` (non-debug twin) — unused in current ASSEMBLY, out of
  scope for this prompt
- `front_door()`, `flap_door()`, `spring_zone_panel()` — a separate prompt
  (VM-01-front-door-redesign-v41.md) is coming for a full redesign of
  these; do not pre-emptively touch them here
- `rules-dimensions.md` — read only, no new locked dimension is being
  introduced by this fix (it corrects existing geometry back to its
  already-documented total_h=700 roofline)
- All other `.scad` files

---

## 6. QA VERIFICATION

- [ ] Export `outer_shell_debug()` alone (as called in ASSEMBLY, with its
      `translate([0,0,leg_h])`) to STL, measure bounding box, confirm Z
      range is exactly 50.00 to 700.00 — paste the measured numbers into
      cc_chat_log, not just "looks right"
- [ ] F6 render, all three `render_mode` states (standard/full/open)
      still compile with no undefined-variable warnings
- [ ] Full-model F6 screenshot showing the acrylic panel's top edge now
      flush against the corrected roofline near the top-right corner —
      for Janis's visual confirmation
- [ ] No other module's Z math touched — confirm explicitly
- [ ] Version incremented v39→v40, not overwritten

---

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at TOP, under 10 lines
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-03
3. Update knowledge.map (VM-01-base-v40 STL filenames)
4. Bump version on all changed files
5. Commit all → merge to main
