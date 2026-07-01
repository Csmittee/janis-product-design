# CC PROMPT — PR-01-base v26: Flatten Module Structure + Standalone Ghost-Context Defaults
# Date: 2026-07-01
# Save to: /prompts/PR-01-flatten-modules-v26.md

---

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order before touching anything. State every file read:
1. cc_rules.md
2. cc_chat_log.md (last 3 entries)
3. rules-dimensions.md
4. knowledge.map
5. pilates-reformer/PR-01-base/PR-01-assembly-v25.scad
6. pilates-reformer/PR-01-base/modules/pole_top.scad
7. .claude/rules-codes.md (MULTI-FILE MODULE CONVENTION section, added last session — will be amended)

This prompt has THREE fix tasks. Tasks 1-2 are FAIL-loop-1 fixes from
Janis's v25 F5 verification — not repeat failures on the same root cause
(Issue 1 is a workflow/structure mismatch, Issue 2 is a missing-defaults
gap). Task 3 codifies both fixes as standing convention. Complete ALL
THREE tasks. Do not commit until all done.

---

## 2. CONTEXT

Janis confirmed on 2026-07-01: working folder is local
(/Users/ChaijohnAir/Documents/scad_works), files are always downloaded
individually from GitHub — no git clone, no repo pull. This was not known
when v25's modules/ subfolder structure was designed.

**Issue 1 — include path fails locally:**
`PR-01-assembly-v25.scad` uses `include <modules/pole_top.scad>`. This only
resolves if the modules/ subfolder is manually recreated next to the
assembly file on Janis's machine, every session, for every module. Given
the download-only workflow, this WILL break again as base/poles/gears are
added. Fix: flatten — module files sit in the SAME folder as the assembly
file, no subfolder. Root cause confirmed by Janis directly (not a cc code
defect) — no diagnosis needed beyond this, proceed straight to fix.

**Issue 2 — undefined globals on standalone module open:**
The ghost-context preview stanza (established v25) references `pole_d`,
`xbar_z`, `grip_od` — real project globals, but they are only ever declared
in the assembly file, BEFORE its include. Opening the module file standalone
(the entire point of the ghost-context feature) leaves these undefined,
producing the WARNING output Janis saw. Fix: guard each with `is_undef()`
fallback defaults inside the module file itself, sourced from
rules-dimensions.md, following the same pattern already used for
`$is_assembly`.

---

## 3. NEW FILES

- `pilates-reformer/PR-01-base/PR-01-assembly-v26.scad` (new — content
  identical to v25 except the include path, per Task 1)

`pole_top.scad` itself is moved, not newly created — still not
individually versioned, per v25's established exception. Add
PR-01-assembly-v26.scad to knowledge.map, mark v25 Superseded.

---

## 4. TASKS

---

### TASK 1 — Flatten module folder structure

Move `pilates-reformer/PR-01-base/modules/pole_top.scad` to
`pilates-reformer/PR-01-base/pole_top.scad` (same folder as the assembly
file). Delete the now-empty `modules/` folder.

Create `pilates-reformer/PR-01-base/PR-01-assembly-v26.scad` as a new file
(do NOT patch v25 in place — its include path is changing, which is a
content change, so per the "never overwrite" rule this gets a new version
number like any other change). Copy v25's content, changing only:
```scad
include <modules/pole_top.scad>
```
to:
```scad
include <pole_top.scad>
```
Everything else identical to v25 — same globals, same assembly call, zero
geometry change. Mark `PR-01-assembly-v25.scad` → Superseded in
knowledge.map (kept in repo, not deleted, per standard practice).

**Establish this as the standing convention going forward**: all future
module files (base_foldable.scad, gear_teeth.scad, pole_mid_clamp.scad,
etc.) go in the SAME flat folder as their assembly file. No subfolders.
Reason: Janis's workflow downloads individual files one at a time with no
folder-tree reconstruction — subfolders break silently and are hard to
diagnose from the OpenSCAD error alone (Janis saw a generic "can't open
include file" with no hint that the cause was a missing local folder).

---

### TASK 2 — Standalone-safe defaults for ghost-context globals

In `pole_top.scad` (post-move), near the top, alongside the existing
`$is_assembly` guard, add `is_undef()`-guarded defaults for every global the
ghost-context stanza references. Example pattern (use the ACTUAL global
names already in the file — `pole_d`, `xbar_z`, `grip_od` or equivalent,
verify exact names, do not guess):

```scad
$is_assembly = is_undef($is_assembly) ? false : $is_assembly;
pole_d  = is_undef(pole_d)  ? /* value from rules-dimensions.md */ : pole_d;
xbar_z  = is_undef(xbar_z)  ? /* value from rules-dimensions.md */ : xbar_z;
grip_od = is_undef(grip_od) ? /* value from rules-dimensions.md */ : grip_od;
```

Pull the fallback values from rules-dimensions.md — same values the
assembly file would normally supply. This makes standalone opens
self-sufficient: no warnings, ghost stand-ins render correctly, without
needing the assembly file's globals to already exist in scope.

Verify: opening `pole_top.scad` directly in OpenSCAD (no assembly file
involved) produces ZERO undefined-variable warnings and shows the real part
+ gray ghost stand-ins.

---

### TASK 3 — Amend rules-codes.md convention section

In `.claude/rules-codes.md`, find the "MULTI-FILE MODULE CONVENTION —
GHOST-CONTEXT PREVIEW" section added last session. Amend (do not just
append a contradicting note — actually correct the guidance) to state
module files live flat, alongside their assembly file, no subfolder —
reason: Janis's local workflow is download-only, no git clone, subfolder
structure cannot be relied on to survive the download step. Also add: any
global referenced only for ghost-context display must get an `is_undef()`
guarded default inside the module file, same pattern as `$is_assembly`, so
standalone opens are self-sufficient.

Bump `.claude/rules-codes.md` version.
Bump `knowledge.map` version, update `pole_top.scad` path row.

---

## 5. DO NOT TOUCH

- `rules-dimensions.md` — read only, never edit
- Any module logic, parameter values, or geometry in pole_top_housing(),
  pole_top_neck(), profile_pts(), pole_top() — this is a structure + defaults
  fix only, zero geometry change
- `PR-01-base-v24.scad` — untouched, historical record
- `chat_rules.md` — Claude Web only
- VM-01-base files — untouched, out of scope
- Do not begin any Option B geometry work — still deferred

---

## 6. QA VERIFICATION

Before committing, confirm ALL:

- [ ] `pole_top.scad` exists at `pilates-reformer/PR-01-base/pole_top.scad`
      (flat, no modules/ subfolder)
- [ ] `modules/` folder deleted (empty, no longer referenced anywhere)
- [ ] `PR-01-assembly-v26.scad` created, include path updated to `<pole_top.scad>`,
      all other content identical to v25 (diff to confirm)
- [ ] Standalone open of `pole_top.scad` — zero undefined-variable warnings
- [ ] Standalone open shows real part + gray ghost stand-ins (unchanged
      visual behavior from v25 intent, now actually working)
- [ ] Full-assembly open of `PR-01-assembly-v26.scad` — resolves correctly,
      still shows NO ghost stand-ins, geometry unchanged from v25/v24
- [ ] `.claude/rules-codes.md` MULTI-FILE MODULE CONVENTION section amended
      to say "flat folder, no subfolders" — do not leave the old subfolder
      guidance in place uncorrected (see Task 3 below)
- [ ] `knowledge.map` path updated for `pole_top.scad`'s new location

---

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at TOP. Include:
   - Confirm both issues fixed, root cause stated for each
   - Confirm rules-codes.md amended (flat-folder standing convention)
   - Confirm zero geometry change — this is structure + defaults only
2. Archive this prompt → /prompts/archive/PR-01-flatten-modules-v26 ✅ COMPLETE — 2026-07-01
3. Update knowledge.map — pole_top.scad path corrected, PR-01-assembly-v25
   marked Superseded, PR-01-assembly-v26 marked ACTIVE, versions bumped
4. Bump version on every other file changed (.claude/rules-codes.md,
   knowledge.map, cc_chat_log.md)
5. Commit all in correct order → merge to main

Confirm every file committed after merge.
