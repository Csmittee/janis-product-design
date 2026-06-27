# CC PROMPT — VM-01-base-v14 Fix 2-Manifold
> Version 1.0 — 2026-06-28
> Task: Fix 2-manifold warning + correct version header
> Source: vending-machine/VM-01-base/VM-01-base-v13.scad
> Save as: vending-machine/VM-01-base/VM-01-base-v14.scad
> Save this prompt to: /prompts/VM-01-base-v14-fix-manifold.md

---

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order before touching anything:
1. `cc_rules.md`
2. `cc_chat_log.md` (last 3 entries)
3. `rules-dimensions.md`
4. `vending-machine/VM-01-base/VM-01-base-v13.scad`

State every file read before writing a single line.

---

## 2. CONTEXT

VM-01-base-v13 produces a 2-manifold warning on F6 render in OpenSCAD.
This means the STL export will have broken mesh — unusable for supplier.

Root cause: the outer_shell() is called with translate([0,0,leg_h]) at
assembly line 462. Inside outer_shell(), the hollow interior subtraction
starts at Z=skin_t (2mm), which leaves no bottom face on the shell.
An open-bottom shell is not a closed solid = 2-manifold error.

Secondary issue: file header still says Version: v12. Must be corrected to v14.

---

## 3. NEW FILES

- `vending-machine/VM-01-base/VM-01-base-v14.scad`

Add to knowledge.map under VM-01-base.

---

## 4. TASKS

Copy VM-01-base-v13.scad as VM-01-base-v14.scad. Apply these fixes:

### FIX 1 — Correct version header (lines 1-12)

Replace:
```
// VM-01 Base Vending Machine
// Janis Product Design
// Version: v12
// Date: 2026-06-27
```
With:
```
// VM-01 Base Vending Machine
// Janis Product Design
// Version: v14
// Date: 2026-06-28
// Changes from v13:
//   Fix 1: outer_shell() — add bottom skin to close shell (fixes 2-manifold)
//   Fix 2: outer_shell opacity corrected to 0.75 (solid shell, v13 value)
//   Fix 3: Remove duplicate exit_door_h declaration (line 62)
```

### FIX 2 — Remove duplicate exit_door_h (line 62)

In the PARAMETERS section, exit_door_h is declared TWICE:
- Line 52: `exit_door_h = 250;`  ← KEEP THIS ONE
- Line 62: `exit_door_h = 250;`  ← DELETE THIS LINE

Delete line 62 only. Keep line 52.

### FIX 3 — Fix outer_shell() to close the bottom face

The shell has no bottom skin because the hollow subtract starts at skin_t
but the assembly translates the shell up by leg_h, leaving the bottom open.

In the outer_shell() module, change the hollow interior subtract from:
```
translate([skin_t, skin_t, skin_t])
    rounded_box(total_w-(skin_t*2), total_h-skin_t, total_d-(skin_t*2), corner_r-1);
```
To:
```
translate([skin_t, skin_t, skin_t])
    rounded_box(total_w-(skin_t*2), total_h-(skin_t*2), total_d-(skin_t*2), corner_r-1);
```

Change: `total_h-skin_t` → `total_h-(skin_t*2)`

This preserves skin_t thickness on BOTH top AND bottom of the shell,
making it a fully closed solid. No other geometry changes.

### FIX 4 — Restore outer_shell opacity to 0.75

In outer_shell() module, change:
```
color("#C8C8C8", 0.15)
```
To:
```
color("#C8C8C8", 0.75)
```

---

## 5. DO NOT TOUCH

- `rules-dimensions.md` — read only, never edit
- All other `.scad` files not listed above
- All dimensions — no size changes whatsoever
- `WORKFLOW_SKILL.md`
- `chat_rules.md`

---

## 6. QA VERIFICATION

Before closing:
- [ ] File header says Version: v14
- [ ] Only ONE declaration of exit_door_h in PARAMETERS section
- [ ] outer_shell hollow subtract uses `total_h-(skin_t*2)` not `total_h-skin_t`
- [ ] outer_shell color opacity is 0.75
- [ ] No other geometry changed
- [ ] Run OpenSCAD CLI check if available: `openscad --check vending-machine/VM-01-base/VM-01-base-v14.scad`
- [ ] Confirm no undefined variable warnings expected

---

## 7. MANDATORY CLOSING

1. Append `cc_chat_log.md` — newest entry at BOTTOM. Include:
   - Confirm 2-manifold fix applied
   - Confirm duplicate exit_door_h removed
   - Flag: Janis must F6 render v14 and confirm 2-manifold warning is gone
2. Archive this prompt → `prompts/archive/` stamped ✅ COMPLETE — 2026-06-28
3. Update `knowledge.map` — add VM-01-base-v14.scad
4. Bump version header on cc_chat_log.md
5. Commit all → merge to main

Confirm what you changed after commit.
