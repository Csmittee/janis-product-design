
Handover Skill File — Save This to Repo
Create file: WORKFLOW_SKILL.md
markdown# Janis Product Design — Workflow Skill
## Version: v1 | June 2026
## Purpose: Guide any new Claude session to continue work instantly

---

## 1. How We Work Together

### The Golden Loop
You describe → Claude codes SCAD →

OpenSCAD previews → You feedback →

Claude fixes → Repeat until approved →

Export STL + DXF → Save to repo

### Claude's Role
- Read ALL rules files before touching any code
- Write OpenSCAD code directly — no AdamCAD needed
- Calculate dimensions, never guess
- Ask maximum 3 questions before coding
- Always save prompt to /prompts/ before generating

### Your Role
- Describe in plain language + sketch photo
- Give feedback on what's wrong visually
- Confirm dimensions before export
- Save files to repo after each approval

---

## 2. Handover Protocol

### Start of EVERY New Chat — Paste This:
Project: Janis Product Design

Repo: github.com/Csmittee/janis-product-design

Rules: Read RULES.md + all rules-xxx.md files first

Status: [what is done]

Today: [what to build]

Active model: [VM-01 / PR-01 etc]

Last file: [filename of last saved SCAD]

Known issues: [what was wrong last session]

### What to Attach to New Chat
- Latest .SCAD file content (paste or upload)
- Any sketch photos for new components
- Relevant rules-xxx.md if working on specific domain

---

## 3. File Structure
janis-product-design/

├── RULES.md              ← governance + units + naming

├── WORKFLOW_SKILL.md     ← this file

├── rules-materials.md    ← material specs

├── rules-dimensions.md   ← standard dimensions

├── rules-codes.md        ← OpenSCAD coding standards

├── rules-parameters.md   ← parametric variable library

├── COMMON/               ← shared components

├── vending-machine/

│   ├── VM-01-base/       ← SCAD + STL files here

│   ├── VM-02-optionA/

│   └── VM-03-optionB/

├── pilates-reformer/

│   ├── PR-01-base/

│   ├── PR-02-optionA/

│   ├── PR-03-optionB/

│   └── PR-04-optionC/

├── exports/

│   ├── for-supplier/     ← STL files

│   ├── for-cnc/          ← DXF files

│   └── for-client/       ← renders

├── prompts/              ← all prompts before CAD session

├── drawings/             ← 2D technical drawings

└── renders/              ← Vectary screenshots

---

## 4. OpenSCAD Coding Standards
See: rules-codes.md

### Key Rules
- All units in MM — always
- Always use named parameters at top of file
- Never hardcode numbers inside modules
- Every module max 30 lines
- Comment every section
- $fn = 64 for smooth curves
- hull() for rounded shapes
- difference() for cutouts

### File Naming
[PRODUCT]-[MODEL]-[COMPONENT]-[VERSION].scad

VM-01-base-v1.scad

PR-01-rail-joint-v2.scad

COMMON-tee-connector-v1.scad

### Version Control
- Never overwrite — always v1→v2→v3
- Keep all versions in same folder
- Note what changed in first comment line

---

## 5. Tool Stack
Prompt design    → Claude web (claude.ai)

3D code          → Claude writes OpenSCAD code

3D preview       → OpenSCAD (local, macOS)

STL export       → OpenSCAD F6 → Export → STL

DXF drawings     → OpenSCAD F6 → Export → DXF

Renders          → Vectary (browser, import STL)

Client video     → Canva (browser)

Repo             → GitHub (github.com/Csmittee/janis-product-design)

Future stack     → Claude Desktop + Fusion 360 MCP (Mac Studio)

---

## 6. Rules File System
### Never put more than 400 lines in any file
### Split by domain:

| File | Contains |
|---|---|
| RULES.md | Governance, naming, version control |
| rules-materials.md | Material specs, thickness, finish |
| rules-dimensions.md | Standard sizes, tolerances, fits |
| rules-codes.md | OpenSCAD standards, patterns |
| rules-parameters.md | Parametric variable library |
| rules-vm.md | Vending machine specific rules |
| rules-pr.md | Pilates reformer specific rules |

### How to Grow Rules
- When you learn something new → add to relevant rules-xxx.md
- When a rule file hits 350 lines → split it
- Never delete old rules — mark as [DEPRECATED] if changed
- Date every new rule entry

---

## 7. Do's and Don'ts

### DO
- ✅ Read all rules files at start of session
- ✅ Save prompt before generating
- ✅ Export STL immediately after approval
- ✅ Test every SCAD file with F5 before declaring done
- ✅ Use COMMON/ parts wherever possible
- ✅ Ask for sketch photo before coding new component
- ✅ Calculate all dimensions — never assume
- ✅ Build COMMON first, variants after

### DON'T
- ❌ Never overwrite existing versions
- ❌ Never hardcode dimensions inside modules
- ❌ Never start option variants before base approved
- ❌ Never mix CAD repo with code repos
- ❌ Never proceed with ambiguous dimensions — ask
- ❌ Never put more than 400 lines in any file
- ❌ Never skip saving prompt to /prompts/

---

## 8. Approval Gates
Before moving to next component:
□ F5 preview looks correct

□ F6 full render clean (no errors)

□ STL exported → /exports/for-supplier/

□ DXF exported → /exports/for-cnc/

□ SCAD saved → correct product folder

□ Prompt saved → /prompts/

□ Screenshot → /renders/

□ Relevant rules-xxx.md updated if new learning

---

## 9. Current Status (June 27 2026)
- VM-01 base frame: IN PROGRESS (v3)
- Spring direction: NEEDS FIX (pointing wrong way)
- PR-01: NOT STARTED
- Tool stack: OpenSCAD local + Claude web
- Mac: MacBook Air 2013, Big Sur 11.7
- Fusion 360: INCOMPATIBLE with current Mac
- Future: Mac Studio + Fusion 360 + Claude MCP

---

## 10. New Rules Files to Create Next
- rules-materials.md (stainless spec, L-bracket spec)
- rules-dimensions.md (all VM-01 confirmed dimensions)
- rules-vm.md (VM specific — springs, trays, exit mechanism)
