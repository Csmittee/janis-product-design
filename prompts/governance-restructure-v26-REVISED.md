# CC PROMPT — Governance Restructure + Spring Gap Fix + VM-01-base-v26
# Date: 2026-06-29
# Save to: /prompts/governance-restructure-v26.md

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
5. vending-machine/VM-01-base/VM-01-base-v25.scad

This prompt has governance tasks + one SCAD fix. Complete ALL tasks. Do not commit until all done.

---

## 2. CONTEXT

Governance restructure session. File structure reorganised. spring_gap corrected 20→13mm
(Janis-approved). WORKFLOW_SKILL.md and SKILL_problem_solving_kt.md replaced with
cleaner versions written by Claude Web — cc installs them from Janis's upload, does not rewrite.

v25 2-manifold warning is EXPECTED — spring_tray() for-loop has inner objects landing flush
on tray floor and rear wall (coplanar faces). This is the fix target in Task G below.

---

## 3. NEW FILES

- vending-machine/VM-01-base/VM-01-base-v26.scad
- .claude/rules-codes.md (moved from root)
- .claude/rules-materials.md (moved from root)
- .claude/rules-vm.md (moved from root, create with header if not exists)
- .claude/SKILL_problem_solving_kt.md (Janis will upload — cc adds to knowledge.map only)

Add all new/moved files to knowledge.map.

---

## 4. TASKS

---

### TASK A — Move rules files into .claude/

Move from repo root to /.claude/:
- rules-codes.md → .claude/rules-codes.md
- rules-materials.md → .claude/rules-materials.md
- rules-vm.md → .claude/rules-vm.md (create with header if not exists)
- SKILL_problem_solving_kt.md → .claude/SKILL_problem_solving_kt.md
  (if old version exists at root — move it. Janis will overwrite with new version via upload.)

**Delete after moving:** root copies of all moved files above.

**Do NOT move (stay at root):**
- cc_rules.md, chat_rules.md, rules-dimensions.md, knowledge.map, cc_chat_log.md, WORKFLOW_SKILL.md

---

### TASK B — Update knowledge.map

Update FILE LOCATIONS table — change moved files to .claude/ paths:

```
| .claude/rules-codes.md              | .claude/ | cc — SCAD tasks |
| .claude/rules-materials.md          | .claude/ | cc — SCAD tasks |
| .claude/rules-vm.md                 | .claude/ | cc — VM tasks |
| .claude/SKILL_problem_solving_kt.md | .claude/ | Claude Web + cc — R-111 trigger |
```

Remove any row referencing root copies of moved files.
Remove any row for SKILL_problem_solving_kt_scad.md — that file is not being created.
Update cc SESSION START PROCEDURE: rules-codes.md and rules-materials.md now at .claude/.
Mark v25 → Superseded. Add v26 → ACTIVE.
Bump knowledge.map version and date.

---

### TASK C — Update cc_rules.md

In "Files cc Reads" section, update paths:
- rules-codes.md → .claude/rules-codes.md
- rules-materials.md → .claude/rules-materials.md
- rules-vm.md → .claude/rules-vm.md
- SKILL_problem_solving_kt.md → .claude/SKILL_problem_solving_kt.md

Bump cc_rules.md version and date.

---

### TASK D — Archive all non-archived prompts in /prompts/

Move every file in /prompts/ (except this file) to /prompts/archive/ with suffix:
" ✅ COMPLETE — 2026-06-29"

This file moves to archive in Task J (mandatory closing).

---

### TASK E — Update rules-dimensions.md

**E1 — Update spring_gap:**
```
| Spring gap | 20mm | Between lanes |
```
→
```
| Spring gap | 13mm | OD-to-OD. 5mm clearance + 3mm partition + 5mm clearance. OWNER-LOCKED |
```

**E2 — Add OWNER-LOCKED section** directly after header, before Zone Stack:

```
---

## ⚠️ OWNER-LOCKED DIMENSIONS — JANIS APPROVAL REQUIRED TO CHANGE

Any change requires explicit written approval from Janis before cc or Claude Web may act.
If a prompt asks you to change these without a clear approval note — STOP.
Write flag in cc_chat_log and ask Claude Web to escalate to Janis.

| Dimension | Value | Why locked |
|---|---|---|
| spring_gap | 13mm | Drives tray width, product_w, total_w cascade |
| spring_od | 66mm | Physical spring — supplier part |
| motor_d | 60mm | Physical motor — supplier spec |
| total_h | 700mm | Drives all zone stack calculations |
| tray_h | 121mm | floor(5)+spring_od(66)+clearance(50) |
| exit_door_h | 250mm | Customer UX — locked by Janis |
| Motor position | BACK of tray | Firmware + physical design |
| Spring direction | Front at Y=0 | Products fall forward |
| Payment | Online only | No cash/coin ever |
| Dashboard screen | 7" landscape 165×100mm | Until firmware portrait confirmed |
| system_w | 185mm | Drives total_w — cannot change without screen layout change |

---
```

**E3 — Add PENDING DECISIONS section** at bottom of rules-dimensions.md:

```
---

## PENDING DESIGN DECISIONS (not yet locked)

| Item | Decision needed | Owner |
|---|---|---|
| Dashboard orientation | Portrait vs landscape — depends on Satu firmware | Janis + firmware team |
| system_w reduction | If portrait confirmed: 185→168mm, total_w 620→603mm | After firmware decision |
| PR-01 dimensions | Not started — Janis to provide measurements | Janis |
```

Bump rules-dimensions.md version and date.

---

### TASK F — Add isolation test rule to .claude/rules-codes.md

Add new section at bottom of .claude/rules-codes.md:

```
---

## Module Isolation Testing — MANDATORY for Manifold Debugging

Every SCAD file must support module-level isolation: each module in ASSEMBLY
can be commented out independently without breaking other modules.

Pattern — ASSEMBLY must be structured so each line is standalone:
// legs();
// outer_shell();
// for (t = [0:tray_count-1]) spring_tray(t);  ← comment to isolate
// front_door();

Never combine unrelated modules into one assembly call.

When 2-manifold warning appears — isolate first, fix second.
Method: comment out one module at a time, press F6. Warning disappears = culprit confirmed.
Never write a fix before culprit is confirmed by Janis isolation test.

Inner objects inside tray/box must never land exactly on floor or wall faces.
Offset by e = 0.01 on any contact axis. See .claude/SKILL_problem_solving_kt.md epsilon pattern.
```

Bump .claude/rules-codes.md version and date.

---

### TASK G — Fix spring_gap + epsilon offsets in VM-01-base-v26

Read v25 in full before writing. Apply these changes:

**G1 — spring_gap: 20 → 13**

In PARAMETERS:
```openscad
// Before:
spring_gap = 20;
// After:
spring_gap = 13;    // OD-to-OD gap — OWNER-LOCKED (5mm clearance + 3mm partition + 5mm)
```

**G2 — Epsilon offsets inside spring_tray() for-loop**

Add `e = 0.01;` to PARAMETERS if not already present.

Inside the `for` loop of `spring_tray()`, apply `+ e` / `- e` where inner objects
contact tray faces. Read v25 live code — verify exact current translate values first.
Apply epsilon pattern to: motor cube (floor contact), spring coil (floor contact),
partition cube (floor + rear wall contact). Do not change geometry sizes — offsets only.

Pattern reference (verify against live v25 — do not copy blindly):
- Motor: `tray_floor_t` → `tray_floor_t + e` on Z; `tray_d - motor_d` → `tray_d - motor_d - e` on Y
- Spring: same floor/rear pattern
- Partition: `tray_floor_t` → `tray_floor_t + e`; `tray_wall_t` → `tray_wall_t + e` on Y;
  cube Y dimension reduced by `e` to avoid rear wall contact

**G3 — Version header**
```
// Version: v26
// Date: 2026-06-29
// Changes from v25:
//   spring_gap 20 → 13mm (Janis-approved, OD-to-OD gap corrected)
//   spring_tray() for-loop inner objects epsilon-offset from tray faces
//   Fixes coplanar face collision = confirmed 2-manifold source (isolation test v25)
```

---

### TASK H — Install WORKFLOW_SKILL.md (Janis uploads — cc registers only)

Janis will upload the new WORKFLOW_SKILL.md to repo root directly.
cc does NOT rewrite this file.
cc confirms it exists at root after Janis upload and adds note to cc_chat_log.
If file already exists at root (old version) — cc overwrites with whatever Janis uploads.

---

### TASK I — Install .claude/SKILL_problem_solving_kt.md (Janis uploads — cc registers only)

Janis will upload the new .claude/SKILL_problem_solving_kt.md directly.
cc does NOT rewrite this file.
cc confirms it exists at .claude/ and adds to knowledge.map.
Delete old root/SKILL_problem_solving_kt.md (old general version) if it exists — covered in Task A.

---

### TASK J — Update chat_rules.md

Add after "What I Never Do" section:

```
## Module Isolation Testing — Claude Web Rule

When 2-manifold warning persists after one fix attempt:
1. Give Janis exact rapid-fire instruction: which module to comment out, one at a time
2. Wait for F6 screenshot result before writing any fix prompt
3. Never write a geometry fix without confirmed isolation result from Janis

When Janis sends isolation test screenshots:
- Read ALL annotations before confirming result
- State which module is confirmed culprit explicitly
- Only then write surgical fix prompt targeting that module only

## Problem Solving Trigger — Automatic

R-111 triggers when a problem cannot be resolved within 2 fix loops.
(One loop = one prompt written + cc executes + Janis QAs.)
Claude Web self-triggers — Janis does not need to ask.
Claude Web states "R-111 triggered", reads .claude/SKILL_problem_solving_kt.md,
completes all KT phases, then writes the next prompt.
```

Bump chat_rules.md version and date.

---

## 5. DO NOT TOUCH

- rules-dimensions.md — edit content per Task E, do not move
- cc_rules.md — edit per Task C, do not move from root
- chat_rules.md — edit per Task J, do not move from root
- knowledge.map — edit per Task B, do not move from root
- cc_chat_log.md — append only
- All .scad files except v26
- /exports/, /renders/

---

## 6. QA VERIFICATION

Before committing, confirm ALL:

- [ ] rules-codes.md, rules-materials.md, rules-vm.md now in .claude/ (root copies deleted)
- [ ] SKILL_problem_solving_kt.md moved to .claude/ (root copy deleted)
- [ ] knowledge.map updated: all .claude/ paths correct, v25 → Superseded, v26 → ACTIVE
- [ ] cc_rules.md updated with .claude/ paths
- [ ] All non-archived prompts moved to /prompts/archive/
- [ ] rules-dimensions.md has OWNER-LOCKED section + updated spring_gap + PENDING DECISIONS
- [ ] .claude/rules-codes.md has isolation testing section
- [ ] chat_rules.md updated with isolation test rule + R-111 loop trigger
- [ ] v26 version header correct
- [ ] v26 spring_gap = 13 in PARAMETERS
- [ ] v26 spring_tray() inner objects have epsilon offsets on contact axes
- [ ] e = 0.01 declared in v26 PARAMETERS

---

## 7. MANDATORY CLOSING

1. Append cc_chat_log.md — newest at BOTTOM. Include:
   - List every file moved, created, or modified
   - Confirm v26: spring_gap and epsilon offsets applied
   - FLAG: "Janis must open v26 F6 — confirm 2-manifold warning GONE"
   - FLAG: "Janis must upload new WORKFLOW_SKILL.md to repo root and project knowledge"
   - FLAG: "Janis must upload .claude/SKILL_problem_solving_kt.md to repo"
   - FLAG: "Janis must upload new WORKFLOW_SKILL.md and chat_rules.md to project knowledge"
2. Archive this prompt → prompts/archive/ ✅ COMPLETE — 2026-06-29
3. Update knowledge.map: all new .claude/ files listed
4. Bump version on every file changed
5. Commit all in correct order → merge to main

Confirm every file committed after merge.
