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

This prompt has multiple governance tasks + one SCAD fix.
Complete ALL tasks. Do not commit until all tasks are done.

---

## 2. CONTEXT

This is a governance restructure session. The project has grown and the
file structure needs reorganisation. Simultaneously, spring_gap is being
corrected from 20mm to 13mm (Janis-approved design change), and
WORKFLOW_SKILL.md is being replaced with a cleaner version.

v25 tray_track for-loop warning is EXPECTED — spring_tray() still has
coplanar contacts inside the for-loop (motors, springs, partitions touching
tray floor and rear wall). This is the fix target in v26 Task G below.

---

## 3. NEW FILES

- vending-machine/VM-01-base/VM-01-base-v26.scad
- .claude/SKILL_problem_solving_kt_scad.md (new — SCAD-specific KT skill)
- .claude/rules-codes.md (moved from root)
- .claude/rules-materials.md (moved from root)
- .claude/rules-vm.md (moved from root, create if not exists)

Add all new files to knowledge.map.

---

## 4. TASKS

---

### TASK A — Move rules files into .claude/

Move these files from repo root to /.claude/:
- rules-codes.md → .claude/rules-codes.md
- rules-materials.md → .claude/rules-materials.md
- rules-vm.md → .claude/rules-vm.md (create empty with header if not exists)

**Files that STAY in repo root (do not move):**
- cc_rules.md ← cc reads this first, must be at root
- chat_rules.md ← Claude Web governance, root only
- rules-dimensions.md ← authoritative dimensions, root only
- knowledge.map ← navigation, root only
- cc_chat_log.md ← session log, root only
- WORKFLOW_SKILL.md ← Claude Web skill, root only
- SKILL_problem_solving_kt.md ← if exists at root, move to .claude/

After moving, delete the original root copies.

---

### TASK B — Update knowledge.map for new file locations

Update knowledge.map FILE LOCATIONS table — change all moved files to show
their new path under .claude/:

```
| .claude/rules-codes.md    | .claude/ | cc — reads for SCAD tasks |
| .claude/rules-materials.md | .claude/ | cc — reads for SCAD tasks |
| .claude/rules-vm.md       | .claude/ | cc — reads for VM tasks |
| .claude/SKILL_problem_solving_kt.md | .claude/ | cc reads on R-111 trigger |
| .claude/SKILL_problem_solving_kt_scad.md | .claude/ | cc reads on SCAD manifold R-111 |
```

Update cc SESSION START PROCEDURE in knowledge.map:
- Step 8: "Read .claude/rules-dimensions.md" → keep as rules-dimensions.md (root)
- Step 8: "Read .claude/rules-codes.md and .claude/rules-materials.md for SCAD tasks"

Bump knowledge.map version and date.

---

### TASK C — Update cc_rules.md to reflect new file paths

In the "Files cc Reads" section, update paths:
- rules-codes.md → .claude/rules-codes.md
- rules-materials.md → .claude/rules-materials.md
- rules-vm.md → .claude/rules-vm.md
- SKILL_problem_solving_kt.md → .claude/SKILL_problem_solving_kt.md

Bump cc_rules.md version and date.

---

### TASK D — Archive ALL non-archived prompt files in /prompts/

List every file in /prompts/ that is NOT already in /prompts/archive/.
Move each one to /prompts/archive/ with suffix " ✅ COMPLETE — 2026-06-29"
unless it is today's active prompt (this file).

This file (governance-restructure-v26.md) stays in /prompts/ until this
session closes, then moves to archive in Task J (mandatory closing).

---

### TASK E — Update rules-dimensions.md

**E1 — Update spring_gap (Janis-approved design change):**

Change:
```
| Spring gap | 20mm | Between lanes |
```
To:
```
| Spring gap | 13mm | OD-to-OD gap. 5mm clearance each side of 3mm partition. OWNER-LOCKED — see below |
```

**E2 — Add OWNER-LOCKED DIMENSIONS section** at the top of rules-dimensions.md,
directly after the header, before Zone Stack:

```
---

## ⚠️ OWNER-LOCKED DIMENSIONS — JANIS APPROVAL REQUIRED TO CHANGE

These dimensions have downstream consequences. Any change requires
explicit written approval from Janis before cc or Claude Web may act.
If a prompt asks you to change these without a clear approval note — STOP.
Write a flag in cc_chat_log and ask Claude Web to escalate to Janis.

| Dimension | Value | Why locked |
|---|---|---|
| spring_gap | 13mm | Drives tray width, product_w, total_w cascade |
| spring_od | 66mm | Physical spring — supplier part, cannot change in software |
| motor_d | 60mm | Physical motor — supplier spec, cannot change in software |
| total_h | 700mm | Drives all zone stack calculations — change breaks everything |
| tray_h | 121mm | Drives zone stack — floor(5)+spring_od(66)+clearance(50) |
| exit_door_h | 250mm | Customer UX decision — locked by Janis |
| Motor position | BACK of tray | Firmware + physical design — LOCKED |
| Spring direction | Front at Y=0 | Products fall forward — LOCKED |
| Payment | Online only | No cash/coin ever — business decision |
| Dashboard screen | 7" landscape 165×100mm | Until firmware portrait confirmed |
| System_w | 185mm | Drives total_w — cannot change without screen layout change |

---
```

**E3 — Update tray spring_gap entry in the Trays table** to reference OWNER-LOCKED section.

**E4 — Add PENDING DECISION note** at bottom of rules-dimensions.md:

```
---

## PENDING DESIGN DECISIONS (not yet locked)

| Item | Decision needed | Owner |
|---|---|---|
| Dashboard orientation | Portrait vs landscape — depends on Satu firmware layout | Janis + firmware team |
| system_w reduction | If portrait confirmed: system_w 185→168mm, total_w 620→603mm | After firmware decision |
| PR-01 dimensions | Not started — Janis to provide measurements | Janis |
```

Bump rules-dimensions.md version and date.

---

### TASK F — Add module isolation test rule to .claude/rules-codes.md

Add new section at the bottom of .claude/rules-codes.md:

```
---

## Module Isolation Testing — MANDATORY for Manifold Debugging

**Rule: Every SCAD file must support module-level isolation testing.**
Before writing any new module, ensure it can be called standalone
(commented in/out in ASSEMBLY without breaking other modules).
This is the primary diagnostic tool for 2-manifold warnings.

**Pattern — ASSEMBLY section must be structured so each module
can be commented out independently:**
```openscad
// ASSEMBLY
legs();
translate([0, 0, leg_h]) outer_shell();
compartment_divider();
tray_rack();
for (t = [0:tray_count-1]) spring_tray(t);  // ← comment this line to isolate
front_door();
// ... etc
```

**Rule: Never combine two unrelated modules into one assembly call.**
`spring_tray_and_rack()` is forbidden. Always keep them separate so
each can be isolated for diagnosis.

**Rule: When 2-manifold warning appears — isolate FIRST, fix SECOND.**
Method: comment out modules one at a time in ASSEMBLY. Press F6.
If warning disappears → that module is the culprit.
Never write a fix before the culprit is confirmed by isolation test.
If Janis confirms isolation result → Claude Web writes surgical fix prompt.

**Rule: Inner objects inside a tray/box module must never land exactly
on the tray floor or wall faces.**
Motors, springs, partitions placed inside a tray body must be offset
by epsilon (e = 0.01) on any axis where they touch a tray face.
Pattern: motor bottom Z = tray_floor_t + e (not tray_floor_t exactly).
This prevents coplanar face collisions = non-manifold in CGAL.
```

Bump .claude/rules-codes.md version and date.

---

### TASK G — Fix spring_gap + epsilon offsets in VM-01-base-v26

Read v25 in full before writing. Apply these changes:

**G1 — spring_gap: 20 → 13**

In PARAMETERS section, find:
```openscad
spring_gap = 20;
```
Change to:
```openscad
spring_gap = 13;    // OD-to-OD gap — OWNER-LOCKED (5mm clearance + 3mm partition + 5mm clearance)
```

**G2 — Epsilon offsets on inner objects inside spring_tray()**

Inside the `for` loop of `spring_tray()`, apply `+ e` on Z and Y where
inner objects land exactly on tray faces:

Motor cube — bottom Z flush with floor top:
```openscad
// Before:
translate([x-10, tray_d - motor_d, tray_floor_t])
// After:
translate([x-10, tray_d - motor_d - e, tray_floor_t + e])
```

Spring coil — bottom Z flush with floor + spring_od/2:
```openscad
// Before:
translate([x, tray_d - motor_d, tray_floor_t + spring_od/2])
// After:
translate([x, tray_d - motor_d - e, tray_floor_t + spring_od/2 + e])
```

Partition cube — bottom Z flush with floor, rear Y flush with rear wall interior:
```openscad
// Before:
translate([x + spring_od/2 + spring_gap/2, tray_wall_t, tray_floor_t])
    cube([2, tray_d-(tray_wall_t*2), partition_h]);
// After:
translate([x + spring_od/2 + spring_gap/2, tray_wall_t + e, tray_floor_t + e])
    cube([2, tray_d-(tray_wall_t*2) - e, partition_h]);
```

Read v25 live code — verify exact current translate values before writing.
Apply epsilon pattern consistently. Do not change geometry sizes, only offsets.

**G3 — Update version header**
```
// Version: v26
// Date: 2026-06-29
// Changes from v25:
//   Fix 1: spring_gap 20 → 13mm (Janis-approved, OD-to-OD gap corrected)
//   Fix 2: spring_tray() inner objects epsilon-offset from tray faces
//           Motor, spring coil, partition all offset by e=0.01 on contact axes
//           Fixes coplanar face collision = 2-manifold source confirmed by isolation test
```

---

### TASK H — Create .claude/SKILL_problem_solving_kt_scad.md

Create new file: .claude/SKILL_problem_solving_kt_scad.md

Content:

```markdown
# SKILL_problem_solving_kt_scad.md
# SCAD-Specific Problem Solving — KT Adapted for OpenSCAD Manifold Issues
# Version: 1.0 — 2026-06-29
# Location: .claude/SKILL_problem_solving_kt_scad.md
# Load when: 2-manifold warning appears and does not clear after first fix attempt

---

## THE SCAD MANIFOLD PROBLEM

OpenSCAD shows only: "Object may not be a valid 2-manifold and may need repair!"
It does NOT say which module caused it. This makes blind fixing ineffective.

KT lesson from this project: v17–v25 (8 versions) of failed fixes because
the culprit module (spring_tray()) was never isolated — all fixes targeted
other modules based on guesses. One isolation test in OpenSCAD found it in 2 minutes.

---

## MANDATORY SEQUENCE — DO NOT SKIP STEPS

### Step 1 — Isolate before fixing (Janis does this in OpenSCAD)

In the ASSEMBLY section of the active .scad file:
Comment out modules ONE AT A TIME. Press F6 after each.

Order to test (most likely culprits first):
1. The most recently added or changed module
2. Any module containing a for() loop with inner geometry
3. Any module using union() with multiple cubes
4. Any module with difference() subtractions

If warning DISAPPEARS → that module is the culprit. Stop. Report to Claude Web.
If warning STAYS for ALL modules commented out → culprit is in core (outer_shell, legs).

### Step 2 — Look INSIDE the culprit module

Once module is identified, look for these patterns in order:

| Pattern | Symptom | Fix |
|---|---|---|
| Inner object Z = tray_floor_t exactly | Motor/spring/partition sitting on floor | Add + e to Z translate |
| Inner object Y = tray_d - wall exactly | Object flush with rear wall | Add - e to Y translate |
| union() cubes sharing only an edge | Frame bars, box parts | Extend bars to overlap volume |
| difference() inner >= outer on any axis | Hollow subtract overshooting | Reduce inner by 1mm on protruding axis |
| Any face exactly flush with shell boundary | Component coplanar with shell | Offset by skin_t or e |

### Step 3 — One fix, one version, one F6 check

Never apply more than one geometric change per version.
After fix: Janis presses F6. Warning gone = confirmed. Warning stays = escalate.

### Step 4 — If warning persists after 2 surgical fixes → escalate

R-111 triggered. Claude Web invokes full KT framework.
Read: .claude/SKILL_problem_solving_kt.md

---

## THE EPSILON PATTERN — for inner objects inside containers

Any object placed inside a box/tray that touches a face must be offset by e:

```openscad
e = 0.01;   // declared in PARAMETERS — always

// Motor sitting on tray floor — WRONG (coplanar = non-manifold)
translate([x, y, tray_floor_t])
    cube([motor_w, motor_d, motor_h]);

// Motor sitting on tray floor — CORRECT (epsilon lift)
translate([x, y, tray_floor_t + e])
    cube([motor_w, motor_d, motor_h]);

// Object touching rear wall — WRONG
translate([x, tray_d - wall_t, z])
    cube([...]);

// Object touching rear wall — CORRECT
translate([x, tray_d - wall_t - e, z])
    cube([...]);
```

---

## F5 vs F6 — KNOW THE DIFFERENCE

| Mode | Key | Use for | Shows transparency? |
|---|---|---|---|
| Preview | F5 | Visual QA, color check, see-through acrylic | YES |
| Full render | F6 | Manifold check, accurate geometry | NO — all objects opaque yellow |

Always use F5 for visual review. Only use F6 to check manifold status.
Never reject a visual based on F6 render — always check in F5 first.
```

---

### TASK I — Replace WORKFLOW_SKILL.md

Overwrite the existing WORKFLOW_SKILL.md with this cleaner version.
This version focuses on HOW we work, not project status (status lives in cc_chat_log).

```markdown
# WORKFLOW_SKILL.md
# Janis Product Design — How We Work
# Version: 3.0 — 2026-06-29
# Purpose: Teach any new Claude Web session our working method instantly
# Project status: always in cc_chat_log.md — never here

---

## THE THREE ROLES

| Role | Tool | Does |
|---|---|---|
| Janis | Claude.ai web | Describes goals, QAs screenshots, approves all versions |
| Claude Web | Claude.ai web | Plans, diagnoses, writes cc prompts, never writes SCAD |
| cc (Claude Code) | Claude Code | Reads repo, writes SCAD, commits, reports in cc_chat_log |

---

## REPO AND PROJECT

Repo: github.com/Csmittee/janis-product-design
Stack: OpenSCAD (.scad), STL exports, DXF exports, PNG renders
Product: Satu vending machine — physical enclosure design only
Payment: Online only — no cash/coin, never

---

## FILE LOCATIONS — WHAT LIVES WHERE

| File | Location | Who reads |
|---|---|---|
| cc_rules.md | repo root | cc — every session |
| cc_chat_log.md | repo root | cc writes, Claude Web reads |
| chat_rules.md | repo root | Claude Web — every session |
| rules-dimensions.md | repo root | cc + Claude Web — authoritative |
| knowledge.map | repo root | cc — navigation guide |
| WORKFLOW_SKILL.md | repo root + project knowledge | Claude Web — this file |
| .claude/rules-codes.md | .claude/ | cc — SCAD tasks |
| .claude/rules-materials.md | .claude/ | cc — SCAD tasks |
| .claude/rules-vm.md | .claude/ | cc — VM tasks |
| .claude/SKILL_problem_solving_kt.md | .claude/ | Claude Web + cc — R-111 trigger |
| .claude/SKILL_problem_solving_kt_scad.md | .claude/ | Claude Web + cc — manifold R-111 |
| /prompts/ | repo | Claude Web writes, Janis pushes, cc reads |
| /prompts/archive/ | repo | cc moves completed prompts here |

**Project knowledge (Claude Web only — never in repo):**
CHAT_HANDOFF.md, WORKFLOW_SKILL.md, chat_rules.md, cc_chat_log.md

---

## CLAUDE WEB SESSION OPENING — MANDATORY SEQUENCE

At start of every session (CHAT_HANDOFF pasted or new session started):

**Step 1:** Search project knowledge for "WORKFLOW_SKILL" — load this file.
  If not found → tell Janis to upload WORKFLOW_SKILL.md to project knowledge. STOP.

**Step 2:** Search project knowledge for "chat_rules" — load rules.
  If not found → tell Janis to upload chat_rules.md. STOP.

**Step 3:** Search project knowledge for "cc_chat_log" — read last 3 entries.
  State what cc did last session and any flags.
  If not found → tell Janis: download cc_chat_log.md from repo → upload to project knowledge.

**Step 4:** Read CHAT_HANDOFF open items. State "Memory installed."

**Step 5:** Ask Janis "Today's goal?" — even if handoff already states it.

Do NOT respond to any task until all 5 steps confirmed complete.

---

## JANIS SESSION PREP — Do This Before Opening Claude Web

1. Download cc_chat_log.md from GitHub repo
2. Upload to project knowledge (replaces old version)
3. Then open Claude Web and paste CHAT_HANDOFF

---

## THE DEVELOPMENT LOOP

```
Janis describes goal
  → Claude Web reads cc_chat_log + rules-dimensions → diagnoses
  → Claude Web writes prompt as .md file
  → Janis pushes to /prompts/ in repo
  → Janis tells cc: "read prompts/[filename].md and execute"
  → cc reads all required files → writes new .scad version → commits
  → cc appends cc_chat_log → archives prompt → updates knowledge.map
  → Janis opens .scad in OpenSCAD → F5 visual check → F6 manifold check
  → Screenshots to Claude Web → QA PASS or FAIL
  → If FAIL → Claude Web writes fix prompt → loop repeats
  → Claude Web writes CHAT_HANDOFF → Janis saves to project knowledge
```

---

## INTERVENTION LEVELS — USE THE LIGHTEST ONE

| Level | When | Example |
|---|---|---|
| Build prompt (.md file) | New feature, new model, multi-module | New product zone redesign |
| Fix prompt (.md file) | Single confirmed bug, clear module | Fix one module geometry |
| Rapid-fire phrase (chat) | One confirmed line change, cc still in session | Change one parameter value |
| Janis direct edit | One line, Claude Web gives exact instruction | Insert `e = 0.01;` at line 42 |

---

## PROBLEM SOLVING — WHEN TO TRIGGER

**R-111: After 2 failed fix attempts on the same symptom — STOP.**

Claude Web triggers automatically — Janis does not need to ask.
No new fix prompt is written until KT phases are complete.

For general problems: read .claude/SKILL_problem_solving_kt.md
For SCAD manifold: read .claude/SKILL_problem_solving_kt_scad.md

**SCAD manifold first step is always isolation test (Janis in OpenSCAD).**
Claude Web gives Janis the exact modules to comment out and test.
Never write a fix without confirmed isolation result.

---

## CC PROMPT TEMPLATE (7 sections — build prompts only)

```markdown
## 1. CC INTRO
git fetch + read order (cc_rules, cc_chat_log, rules-dimensions, .scad)

## 2. CONTEXT
Why this prompt exists. What problem it solves.

## 3. NEW FILES
List all new files. Write NONE if none.

## 4. TASKS
Numbered. Root cause stated. Exact file named. Exact fix described.

## 5. DO NOT TOUCH
Explicit exclusion list. Always includes rules-dimensions.md.

## 6. QA VERIFICATION
Checklist cc confirms before committing.

## 7. MANDATORY CLOSING
1. Append cc_chat_log
2. Archive prompt → /prompts/archive/ ✅ COMPLETE — date
3. Update knowledge.map if new files
4. Bump version on all changed files
5. Commit → merge to main
```

---

## CHAT HANDOFF TEMPLATE

```markdown
# CHAT HANDOFF — [date] END OF SESSION
> Single-use — paste entire file to open new chat

## ACTIVE MODEL
[model name and last committed version]

## SYSTEM STATUS
| Model | Last Version | QA Status | Export Status |
|---|---|---|---|

## WHAT WAS DONE TODAY
[files changed, prompts sent, QA results]

## OPEN ITEMS — PRIORITY ORDER
| Item | Status | Notes |

## NEXT SESSION — START HERE
[exact first action]

## JANIS ACTION REQUIRED
[physical actions only — push file, screenshot, download]

## FLAGS FOR NEXT SESSION
[pending decisions, governance notes]
```

---

## SESSION CLOSING CHECKLIST

**Claude Web closes every session:**
1. Read cc_chat_log — verify delivery matches request
2. Flag any gap to Janis
3. Write CHAT_HANDOFF → tell Janis to save to project knowledge
4. Tell Janis to download cc_chat_log.md from repo → upload to project knowledge

**cc closes every session:**
1. Append cc_chat_log (newest at BOTTOM)
2. Archive prompt → /prompts/archive/ ✅ COMPLETE
3. Update knowledge.map if new files
4. Bump version on all changed files
5. Commit all → merge to main
```

---

### TASK J — Update chat_rules.md

Add this new section after "What I Never Do":

```markdown
## Module Isolation Testing — Claude Web Rule

When a 2-manifold warning persists after one fix attempt:
1. Give Janis the exact rapid-fire instruction: which modules to comment out, in what order
2. Wait for F6 screenshot result before writing any fix prompt
3. Never write a geometry fix without confirmed isolation result from Janis

When Janis sends isolation test screenshots:
- Read ALL annotations before confirming result
- State which module was confirmed as culprit explicitly
- Only then write the surgical fix prompt

## Problem Solving Trigger — Automatic

Claude Web triggers R-111 automatically after 2 failed fix attempts.
Janis does not need to ask. Claude Web stops, states "R-111 triggered",
reads .claude/SKILL_problem_solving_kt.md or SKILL_problem_solving_kt_scad.md,
completes all KT phases, then writes the next prompt.
```

Bump chat_rules.md version and date.

---

## 5. DO NOT TOUCH

- rules-dimensions.md root copy — edit content per Task E but do not move
- cc_rules.md — edit per Task C but do not move from root
- chat_rules.md — edit per Task J but do not move from root
- knowledge.map — edit per Task B but do not move from root
- cc_chat_log.md — append only, never edit past entries
- All .scad files other than v26
- /exports/ folder
- /renders/ folder

---

## 6. QA VERIFICATION

Before committing, confirm ALL:

- [ ] rules-codes.md, rules-materials.md, rules-vm.md now in .claude/ (not root)
- [ ] Root copies of moved files deleted
- [ ] knowledge.map updated with new .claude/ paths
- [ ] cc_rules.md updated with new .claude/ paths
- [ ] All non-archived prompts moved to /prompts/archive/
- [ ] rules-dimensions.md has OWNER-LOCKED section at top
- [ ] rules-dimensions.md spring_gap updated to 13mm
- [ ] rules-dimensions.md PENDING DECISIONS section added at bottom
- [ ] .claude/rules-codes.md has module isolation testing section
- [ ] .claude/SKILL_problem_solving_kt_scad.md created
- [ ] WORKFLOW_SKILL.md replaced with v3.0
- [ ] chat_rules.md updated with isolation testing and R-111 trigger rules
- [ ] v26 version header correct: Version v26, date 2026-06-29
- [ ] v26 spring_gap = 13 in PARAMETERS
- [ ] v26 spring_tray() inner objects have epsilon offsets on contact axes
- [ ] knowledge.map updated: v25 → Superseded, v26 → ACTIVE
- [ ] Janis must open v26 F6 → confirm 2-manifold warning GONE

---

## 7. MANDATORY CLOSING

1. Append cc_chat_log.md — newest at BOTTOM. Include:
   - List every file moved, created, or modified (governance tasks)
   - Confirm v26 changes: spring_gap and epsilon offsets
   - State: "FLAG FOR CLAUDE WEB — Janis must open v26 F6 — confirm manifold clear"
   - State: "FLAG FOR CLAUDE WEB — WORKFLOW_SKILL.md updated to v3.0 — Janis must download from repo and replace in project knowledge"
   - State: "FLAG FOR CLAUDE WEB — chat_rules.md updated — Janis must download and replace in project knowledge"
2. Archive this prompt → prompts/archive/ ✅ COMPLETE — 2026-06-29
3. Update knowledge.map: v25 → Superseded, v26 → ACTIVE, all new .claude/ files listed
4. Bump version on every file changed
5. Commit all in correct order → merge to main

Confirm every file committed after merge.
