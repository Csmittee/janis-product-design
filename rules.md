# Project Rules & Governance

## Project: Pilates Reformer + Vending Machine Design
## Owner: [Your name]
## Started: June 2026
## Target: 7 models in 30 days

---

## 1. Standard Units
- All dimensions in MILLIMETERS
- Pipe OD: 25mm standard (state if different)
- Wall thickness: 2mm aluminum / 3mm steel / 4mm composite
- Tolerance: ±0.5mm unless stated

## 2. File Naming Convention
[PRODUCT]-[MODEL]-[COMPONENT]-[VERSION]
Examples:
- PR-01-base-rail-joint-v1.stl
- VM-02-frame-corner-v2.scad
- COMMON-pipe-tee-connector-v1.stl

## 3. Version Control Rules
- Never overwrite v1 — always save as v2, v3
- Every export to supplier goes in /exports/for-supplier/
- Every prompt used goes in /prompts/ before CAD session

## 4. Handover Protocol (Claude → Claude)
When starting a NEW chat session, always paste:
"Read RULES.md and lessons_learned.md first.
Current status: [what's done]
Today's task: [what to build]
Active model: [PR-01 / VM-02 etc]"

## 5. AdamCAD Session Rules
- Save prompt in /prompts/ BEFORE generating
- Export STL immediately after approval
- Name file per convention above
- Note parametric variables used

## 6. CAD Session Rules
- Open COMMON/ parts first, confirm dimensions
- Never modify COMMON without noting in lessons_learned.md
- All supplier exports = STL + PDF drawing

## 7. What Goes in lessons_learned.md
- Any prompt that worked exceptionally well
- Any dimension that needed correction
- Any supplier feedback on drawings
- Any CAD workaround discovered

## 8. Component Hierarchy
COMMON → Base Model → Option variants
Never build options before base is approved.

## 9. Approval Gates
Before moving to next model:
□ STL exported and named
□ 2D drawing generated
□ Render/screenshot saved
□ Prompt saved in /prompts/
□ lessons_learned.md updated
