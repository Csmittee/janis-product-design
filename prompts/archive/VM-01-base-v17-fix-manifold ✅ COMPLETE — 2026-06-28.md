# CC PROMPT — VM-01-base-v17 Fix 2-Manifold (Diagnosis + Revert)
> Version 1.0 — 2026-06-28
> Task: Revert v16 Fix 2 shell assembly error + identify true 2-manifold source
> Source: vending-machine/VM-01-base/VM-01-base-v16.scad
> Save as: vending-machine/VM-01-base/VM-01-base-v17.scad
> Save this prompt to: /prompts/VM-01-base-v17-fix-manifold.md

---

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order before touching ANYTHING. State each file read before proceeding:
1. `cc_rules.md`
2. `knowledge.map`
3. `cc_chat_log.md` (last 3 entries)
4. `rules-dimensions.md`
5. `rules-codes.md`
6. `vending-machine/VM-01-base/VM-01-base-v16.scad` ← READ THE FULL FILE BEFORE ANY EDIT

**RULE: Do not write a single line of code until all 6 files above are confirmed read.**
The v16 shell geometry was broken because cc wrote a fix without reading the live SCAD first.
This must not repeat.

---

## 2. CONTEXT

VM-01-base-v16 has TWO problems:

**Problem A — Shell geometry broken (introduced in v16):**
v16 Fix 2 changed the shell assembly incorrectly:
- It removed `translate([0,0,leg_h])` from the assembly call
- It changed the hollow subtract Z from `skin_t` to `leg_h+skin_t` inside the module
- These two changes are NOT equivalent. The result is the shell sits at Z=0
  (embedded in the ground) and the interior is incorrectly exposed.

**Problem B — 2-manifold warning (existed before v16, source unknown):**
The 2-manifold warning has persisted from v13 through v16 despite multiple fix attempts.
The true source module has never been systematically identified.
This prompt fixes Problem A first, then identifies Problem B source.

---

## 3. NEW FILES

- `vending-machine/VM-01-base/VM-01-base-v17.scad`

Add to knowledge.map. Mark v16 as Superseded.

---

## 4. TASKS

Copy VM-01-base-v16.scad as VM-01-base-v17.scad. Apply in order:

---

### TASK 1 — Revert v16 Fix 2: Restore correct shell assembly pattern

**What v16 broke:** Removed `translate([0,0,leg_h])` from assembly and tried
to compensate inside `outer_shell()` module — wrong approach.

**The correct pattern (from v14/v15 which was visually correct):**

In the ASSEMBLY section, the outer_shell call must be:
```
translate([0, 0, leg_h]) outer_shell();
```

Inside `outer_shell()` module, the hollow subtract must use local Z=0 origin:
```
translate([skin_t, skin_t, skin_t])
    rounded_box(total_w-(skin_t*2), total_h-(skin_t*2), total_d-(skin_t*2), corner_r-1);
```

The `total_h-(skin_t*2)` height (the v14 bottom-skin fix) MUST be kept.
Only the assembly translate is being restored — nothing else changes in this task.

**Verify after applying:**
- Assembly line calls: `translate([0, 0, leg_h]) outer_shell();`
- Inside outer_shell(): hollow starts at `skin_t`, height is `total_h-(skin_t*2)`
- These two together = shell sits at leg_h in world space + fully closed top and bottom

---

### TASK 2 — Systematic 2-manifold source identification

After applying Task 1, the shell should be visually correct.
The 2-manifold warning may or may not persist. Identify its source:

**Method — comment out modules one at a time in the ASSEMBLY section.**
For each module listed below:
1. Comment it out in assembly
2. Run `openscad --check vending-machine/VM-01-base/VM-01-base-v17.scad` if available
   OR note in cc_chat_log which module was active when warning appeared/disappeared
3. Restore the comment before trying the next module

**Test each in this order:**
1. `front_door()`
2. `flap_door()`
3. `spring_zone_panel()`
4. `left_front_acrylic()`
5. `tray_zone_frame()`
6. `drop_zone_visual()`
7. `sensor_strip()`
8. `dashboard()`
9. `acrylic_display()`
10. `rear_service_door()`

**Report in cc_chat_log:**
- Which module, when commented out, makes the 2-manifold warning disappear
- If warning disappears after Task 1 revert alone (no module commented out), report that
- Do NOT fix the culprit module in this version — identify only

**Deliver v17 with ALL modules UNCOMMENTED (restored to full assembly).**
The diagnosis is for Claude Web to read and plan the surgical fix in v18.

---

### TASK 3 — Update rules-codes.md with new lesson learned

Append the following new rule to the **OpenSCAD 2-Manifold Rules** section
of `rules-codes.md`. This is a mandatory governance update — not optional.

Add after the existing "Assembly Z offset must match module internals" rule:

```
**Rule: Read the live .scad file before writing any fix.**
cc must open and read the full active .scad file before writing any geometry change.
The v16 Fix 2 error (shell assembly Z broken) happened because cc inferred the
assembly pattern from context instead of reading the file. If the file is not in
repo, stop and ask Janis to push it before proceeding. Never infer structure —
always read first.
```

Bump rules-codes.md version to 1.1 with date 2026-06-28.

---

## 5. DO NOT TOUCH

- `rules-dimensions.md` — read only, never edit
- `knowledge.map` — only update version index and active status
- All `.scad` files other than v17 being created
- `WORKFLOW_SKILL.md`, `chat_rules.md`
- Any visual geometry NOT related to the shell assembly revert (no visual fixes in this version)
- The v14 bottom-skin fix: `total_h-(skin_t*2)` — keep this, do not revert

---

## 6. QA VERIFICATION

Before committing, confirm all of the following:

- [ ] v17 file header says Version: v17, date 2026-06-28
- [ ] Assembly section calls `translate([0, 0, leg_h]) outer_shell();`
- [ ] Inside outer_shell(): hollow subtract height is `total_h-(skin_t*2)` (NOT `total_h-skin_t`)
- [ ] Inside outer_shell(): hollow subtract Z starts at `skin_t` (NOT `leg_h+skin_t`)
- [ ] All assembly modules are uncommented and present (no modules left disabled)
- [ ] rules-codes.md updated to v1.1 with new "read live file" rule
- [ ] cc_chat_log documents which module (if any) is the 2-manifold culprit
- [ ] knowledge.map: v16 marked Superseded, v17 marked ACTIVE

---

## 7. MANDATORY CLOSING

1. Append `cc_chat_log.md` — newest entry at BOTTOM. Include:
   - Confirm shell assembly revert applied (Task 1)
   - State the 2-manifold diagnosis result (Task 2) — name the culprit module or confirm warning cleared
   - Confirm rules-codes.md updated to v1.1 (Task 3)
   - Flag: Claude Web needs to read diagnosis result before writing v18 prompt
2. Archive this prompt → `prompts/archive/` stamped ✅ COMPLETE — 2026-06-28
3. Update `knowledge.map` — v16 → Superseded, v17 → ACTIVE
4. Bump version header on every file changed (v17 scad, rules-codes.md, cc_chat_log.md, knowledge.map)
5. Commit all in correct order → merge to main

Confirm what you changed after commit.
