# CC PROMPT — VM-01-base-v13 STL Export Prep
> Version 1.0 — 2026-06-28
> Task: Create export folder structure + confirm STL export path for Janis
> Save this file to: /prompts/VM-01-base-v13-export.md

---

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order before touching anything:
1. `cc_rules.md`
2. `cc_chat_log.md` (last 3 entries)
3. `rules-dimensions.md`

State every file read before writing a single line.

---

## 2. CONTEXT

VM-01-base-v13 has passed QA. Janis will export STL and PNG renders
manually from OpenSCAD on her Mac. cc's job is to ensure the correct
folder structure exists in the repo so Janis saves files to the right paths.

---

## 3. NEW FILES

Create these empty placeholder files so the folders exist in git:

- `exports/for-supplier/.gitkeep`
- `renders/.gitkeep`

(Only create if folders do not already exist in repo.)

---

## 4. TASKS

### TASK 1 — Confirm folder structure exists

Ensure these paths exist in the repo:
- `exports/for-supplier/`
- `renders/`

Create `.gitkeep` in each if empty and not yet tracked by git.

### TASK 2 — Write export README for Janis

Create file: `exports/for-supplier/README-export-instructions.md`

Content:

```
# VM-01-base-v13 — Supplier Export Instructions

## STL Export (Janis does this in OpenSCAD)
1. Open: vending-machine/VM-01-base/VM-01-base-v13.scad
2. Press F6 (full render — wait for completion)
3. File → Export → Export as STL
4. Save as: exports/for-supplier/VM-01-base-v13.stl

## PNG Renders (Janis does this in OpenSCAD)
After F6 render complete:

FRONT:
- View menu → Front
- File → Export → Export as PNG
- Save as: renders/VM-01-base-v13-front.png

SIDE (right):
- View menu → Right
- File → Export → Export as PNG
- Save as: renders/VM-01-base-v13-side.png

TOP:
- View menu → Top
- File → Export → Export as PNG
- Save as: renders/VM-01-base-v13-top.png

PERSPECTIVE:
- Rotate to a good front-right-above angle manually
- File → Export → Export as PNG
- Save as: renders/VM-01-base-v13-perspective.png

## After All Exports
Push all files to repo main branch.
Tell Claude Web — exports done.
```

---

## 5. DO NOT TOUCH

- `rules-dimensions.md` — read only, never edit
- `vending-machine/VM-01-base/VM-01-base-v13.scad` — do not modify
- All other `.scad` files
- `WORKFLOW_SKILL.md`

---

## 6. QA VERIFICATION

- [ ] `exports/for-supplier/` folder exists in repo
- [ ] `renders/` folder exists in repo
- [ ] `README-export-instructions.md` written and correct

---

## 7. MANDATORY CLOSING

1. Append `cc_chat_log.md` — newest entry at BOTTOM
2. Archive this prompt → `prompts/archive/` stamped ✅ COMPLETE — 2026-06-28
3. Commit all → merge to main

Confirm what you changed after commit.
