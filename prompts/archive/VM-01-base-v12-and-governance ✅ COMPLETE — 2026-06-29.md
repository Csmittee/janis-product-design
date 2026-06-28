git fetch --all && git checkout main && git pull origin main

Read: cc_rules.md only.

## TASK 1 — VM-01-base-v12.scad

Copy VM-01-base-v11.scad as VM-01-base-v12.scad. Apply fixes:

FIX 1 — outer_shell opacity
Change outer_shell color from:
  color("#C8C8C8", 0.75)
To:
  color("#C8C8C8", 0.15)
This makes the full shell semi-transparent for QA inspection.

FIX 2 — left product zone front face must be see-through acrylic
The left product zone front face (full width product_w, Z 50-700)
is currently solid shell. It should be a separate acrylic panel:
- Add module: left_front_acrylic()
- Color: #ADD8E6, opacity 0.15
- Position: X=skin_t, Y=0, Z=leg_h (50mm)
- Width: product_w - (skin_t*2)
- Height: total_h - leg_h (650mm)
- Thickness: 3mm
- This replaces the visual of the solid front face on left zone
- Customer can see springs, trays, products through this panel

## TASK 2 — WORKFLOW_SKILL.md governance fixes

FIX A — Remove Section 6 entirely
Delete the entire "Current Project Status" section and its 
version list. cc_chat_log.md is the only living status file.

FIX B — Remove all cc references
Remove any instruction telling cc to read or update 
WORKFLOW_SKILL.md. This file governs Claude Web only.

FIX C — Add load order rule at top of file under 
"Handover Protocol":

WORKFLOW_SKILL.md Load Order:
1. Claude Web reads this file from repo first
2. If not in repo, read from project knowledge
3. If found in neither — STOP. Tell Janis to download
   WORKFLOW_SKILL.md and install to project knowledge
   before proceeding. Do not continue session.

## TASK 3 — cc_rules.md

Remove any reference to reading or updating WORKFLOW_SKILL.md.
cc reads cc_rules.md only at session start.

## After all tasks:
Update cc_chat_log.md with what changed.
Confirm every file committed.
