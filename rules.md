# Janis Product Design — Rules & Governance
## Owner: Janis
## Started: June 2026
## Active projects: Vending Machine (VM) + Pilates Reformer (PR)

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
- VM-01-frame-corner-v2.scad
- COMMON-pipe-tee-connector-v1.stl

## 3. Version Control Rules
- Never overwrite — always increment v1→v2→v3
- Every supplier export goes in /exports/for-supplier/
- Every prompt saved in /prompts/ before CAD session starts

## 4. New Chat Handover Protocol
Paste this at start of EVERY new chat session:
---
Project: Janis Product Design
Repo: github.com/[your-username]/janis-product-design
Read: RULES.md + lessons_learned.md
Current status: [what's done]
Today's task: [what to build]
Active model: [VM-01 / PR-01 etc]
---

## 5. AdamCAD Session Rules
- Save prompt in /prompts/ BEFORE generating
- Export STL + SCAD immediately after approval
- Name file per convention above
- Note parametric variables used

## 6. Component Hierarchy
COMMON → Base Model → Option variants
Never build options before base model is approved.

## 7. Approval Gates
Before moving to next model:
□ STL exported and named correctly
□ SCAD file saved to repo
□ 2D drawing generated (OpenSCAD)
□ Render screenshot saved in /renders/
□ Prompt saved in /prompts/
□ lessons_learned.md updated

## 8. Related Repos (reference only)
- Vending machine backend: github.com/[you]/[vm-backend-repo]
- Pilates website: github.com/[you]/[pilates-site-repo]
- Never mix CAD and code repos
- Paste relevant specs into chat when needed

## 9. Tool Stack
- Prompt design: Claude (web)
- 3D generation: AdamCAD (browser)
- 2D drawings: OpenSCAD (local)
- CNC G-code:
