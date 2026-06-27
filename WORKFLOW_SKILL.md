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

### Claude Web Prompt Delivery Rule
- Claude Web always delivers ONE file only: the cc prompt
- File saved to: /prompts/[task-name].md
- Janis saves to repo and pushes to cc
- Claude Web never delivers inline instructions in chat
- cc reads the prompt file from repo, never from chat paste
- This ensures every prompt is version controlled in /prompts/

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
- VM-01-base-v4: COMMITTED — tray_h=86, front face open, tray Z fixed, acrylic right compartment only
- VM-01-base-v5: COMMITTED — springs visible, acrylic wrong position
- VM-01-base-v6: COMMITTED — zones wrong, height wrong (was 800)
- VM-01-base-v7: COMMITTED — total_h=700, all zones fixed, screen visible, acrylic 542-698
- VM-01-base-v8: COMMITTED — tray side windows restored (3mm frame), screen on front face (Y=skin_t)
- Prompt delivery protocol: LOCKED June 27 2026
- PR-01: NOT STARTED

---

## 7. Critical Design Decisions Locked
[Claude Web adds to this via prompts. cc never changes without instruction.]

- All units: MM always
- Tray height: 86mm (spring OD 66 + 20mm clearance)
- Tray zone total: 172mm (2 x 86mm)
- Tray front face: OPEN — springs always visible from customer side
- Acrylic panel: RIGHT compartment only, above screen to roof
- Left product zone 472–800mm: full front door only, no acrylic
- Tray Z: leg_h + exit_door_h + (tray_num * tray_h)
- Never overwrite versions — always increment
- Tray height = 121mm (5 floor + 66 spring + 50 clearance)
- Trays are INDEPENDENT removable units — not stacked boxes
- Tray top = OPEN, tray front = OPEN, tray sides = framed window only
- Rear latch on every tray — 8mm pin
- Front door = single panel, left hinge, z 50–542mm
- Dashboard = right compartment, ATM style recessed 30deg screen
- Total height = 700mm LOCKED — do not change without Janis approval
- Upper display zone = 158mm (542–700mm)
- Zone stack LOCKED: legs 0-50 | exit door 50-300 | tray0 300-421 | tray1 421-542 | upper display 542-700
- Acrylic = right compartment only, above 542mm to roof (698mm), 3 faces
- rules-dimensions.md root is authoritative. No duplicate in .claude/ folder ever.
- Machine purpose = smart donation vending machine for buddha ornaments
- Payment = online only, no cash/coin mechanism ever
