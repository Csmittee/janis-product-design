CLAUDE CODE — READ THIS ENTIRE PROMPT BEFORE DOING ANYTHING

Repo: github.com/Csmittee/janis-product-design

Read these files first:
- RULES.md
- WORKFLOW_SKILL.md
- rules-dimensions.md
- rules-materials.md

---

## YOUR TASK: Restructure the team workflow system

You are Claude Code (cc). You are one of three team members:
- Janis = owner, vision, final approval
- Claude Web = planning, QA, design decisions, writes your prompts
- Claude Code (you) = reads repo, executes all code and file changes, commits

Claude Web cannot access the repo directly.
Claude Web controls what you read and what your rules are via prompts.
You execute. You never plan. You never decide design direction.
You always confirm what you changed after every commit.

---

## TASK 1: Rewrite WORKFLOW_SKILL.md

Replace the entire file with this structure:

# Janis Product Design — Workflow
## Version: v2 | June 2026

---

## 1. The Team

| Role | Tool | Responsibility |
|---|---|---|
| Janis | Claude.ai web | Owner, vision, feedback, final approval |
| Claude Web | Claude.ai web | Planning, QA, design decisions, writes cc prompts |
| Claude Code | Claude Code (cc) | Reads repo, writes all code, commits all files |

### How decisions flow:
Janis + Claude Web discuss and agree on goal →
Claude Web writes cc prompt →
Janis saves prompt to /prompts/ in repo →
cc reads prompt, executes, commits →
cc updates project status in WORKFLOW_SKILL.md →
Janis screenshots result → Claude Web does QA

### What Claude Web controls:
- What cc reads (specified in every prompt)
- What cc's rules are (via cc_rules.md)
- Design decisions and dimension approvals
- QA pass/fail against rules files

### What cc never does:
- Make design decisions
- Change dimensions without explicit instruction
- Skip reading rules files
- Commit without updating project status

---

## 2. File System

| File | Maintained by | Purpose |
|---|---|---|
| WORKFLOW_SKILL.md | cc | Team workflow, project status |
| chat_rules.md | cc | Rules for Claude Web planning sessions |
| cc_rules.md | cc | Rules for cc execution sessions |
| rules-dimensions.md | cc | All confirmed dimensions |
| rules-materials.md | cc | Material specs and colors |
| rules-vm.md | cc | VM-specific rules (create when needed) |
| rules-pr.md | cc | PR-specific rules (create when needed) |
| /prompts/ | Janis saves, cc reads | Every cc prompt saved before execution |
| /vending-machine/ | cc | All VM SCAD files |
| /pilates-reformer/ | cc | All PR SCAD files |
| /exports/for-supplier/ | cc | STL files |
| /exports/for-cnc/ | cc | DXF files |
| /renders/ | Janis saves | Screenshots from OpenSCAD |

---

## 3. Handover Protocol — Start of Every cc Session

cc reads in this order:
1. cc_rules.md
2. WORKFLOW_SKILL.md Section 6 (current status)
3. WORKFLOW_SKILL.md Section 7 (critical decisions locked)
4. The specific prompt file in /prompts/ for today's task
5. The latest .scad file for the active model
6. Any rules-xxx.md files specified in the prompt

---

## 4. Handover Protocol — Start of Every Claude Web Session

Janis pastes this at start of chat:
---
Project: Janis Product Design
Repo: github.com/Csmittee/janis-product-design
Today's goal: [what to discuss or QA]
Active model: [VM-01 / PR-01 etc]
Last cc commit: [what cc did last]
Issue to solve: [what is wrong or what to plan]
---
Janis downloads chat_rules.md to project knowledge so Claude Web reads it automatically.

---

## 5. Approval Gates — Before cc Commits Any SCAD

□ All dimensions match rules-dimensions.md
□ No hardcoded numbers inside modules
□ Every module under 30 lines
□ Version incremented (v3 → v4, never overwrite)
□ STL exported to /exports/for-supplier/
□ DXF exported to /exports/for-cnc/
□ Prompt saved in /prompts/
□ Project status updated in this file Section 6

---

## 6. Current Project Status
[cc updates this section after every commit]

- VM-01-base-v3: COMMITTED — spring direction fixed, tray Z wrong
- VM-01-base-v4: PENDING — awaiting fixes below
- PR-01: NOT STARTED

---

## 7. Critical Design Decisions Locked
[Claude Web adds to this via prompts. cc never changes without instruction.]

- All units: MM always
- Tray height: 86mm (spring OD 66 + 20mm clearance)
- Tray front face: OPEN — springs always visible from customer side
- Acrylic panel: RIGHT compartment only, above screen to roof
- Left product zone 472–800mm: full front door only, no acrylic
- Tray Z: leg_h + exit_door_h + (tray_num * tray_h)
- Never overwrite versions — always increment

---

## TASK 2: Create chat_rules.md

Create new file: chat_rules.md
Content:

# Claude Web — Chat Rules
# Read this at start of every planning session
# Janis downloads this to project knowledge

## My Role
- Plan with Janis, never execute
- Write cc prompts, never code directly
- QA screenshots against rules files
- Approve or reject before Janis saves prompt to repo

## Before Every Planning Session
- Read all files Janis pastes or uploads
- Ask maximum 2 questions before forming a plan
- Never guess dimensions — check rules-dimensions.md
- Never redesign without Janis approval

## How I Write cc Prompts
- Always specify which files cc must read first
- Always specify save-as filename (never overwrite)
- Always include full instructions, no ambiguity
- Always end with: "Confirm what you changed after commit"

## QA Process
- Janis pastes screenshot after cc commits
- I check against rules-dimensions.md and critical decisions
- I give clear PASS or FAIL with specific reasons
- If FAIL: I write new cc prompt to fix

## What I Never Do
- Never write SCAD code directly
- Never tell Janis to manually edit files
- Never approve a version without seeing screenshot
- Never change locked decisions without flagging to Janis first

---

## TASK 3: Create cc_rules.md

Create new file: cc_rules.md
Content:

# Claude Code Rules
# Read this at the start of every cc session

## My Role
- Execute prompts from Claude Web
- Read repo, write code, commit files
- Update project status after every commit
- Never make design decisions

## Session Start — Always Do This First
1. Read cc_rules.md (this file)
2. Read WORKFLOW_SKILL.md
3. Read the prompt file specified for today
4. Read latest .scad for active model
5. Read rules files specified in prompt

## Coding Rules
- All units MM always
- Named parameters at top of every file
- No hardcoded numbers inside modules
- Every module max 30 lines
- $fn = 64 for all curves
- Comment every section
- hull() for rounded shapes
- difference() for cutouts

## File Rules
- Never overwrite — always increment version
- Name format: [PRODUCT]-[MODEL]-[COMPONENT]-[VERSION].scad
- Save SCAD to correct product folder
- Save STL to /exports/for-supplier/
- Save DXF to /exports/for-cnc/

## After Every Commit
- Update WORKFLOW_SKILL.md Section 6 with what changed
- List every file committed
- Flag any ambiguity or decision needed by Claude Web

## What I Never Do
- Never change dimensions not in the prompt
- Never skip updating project status
- Never make design decisions
- Never commit without reading rules files first

---

## TASK 4: Fix VM-01-base-v4.scad

Read: vending-machine/VM-01-base/VM-01-base-v3.scad
Save as: vending-machine/VM-01-base/VM-01-base-v4.scad

Changes:
1. tray_h = 86 (was 116)
2. spring_tray module: remove front face wall (Y=0 side open, springs visible)
3. z = leg_h + exit_door_h + (tray_num * tray_h)
4. acrylic_panel: move to right compartment only
   - X: product_w + divider_t
   - Width: system_w - divider_t - skin_t  
   - Z: above screen, to total_h - skin_t
5. Left product zone: front door cutout only, no acrylic

## TASK 5: Update rules-dimensions.md

- Tray height: 86mm (spring OD 66 + 20mm clearance)
- Tray zone total: 172mm (2 x 86mm)
- Acrylic: right compartment only, above screen to roof
- Add: Tray front face = OPEN
- Add: Left zone 472–800mm = front door only

---

After all commits, list every file changed and confirm 
WORKFLOW_SKILL.md Section 6 is updated.