# coordinate-system-standard-v1.md
# Governance Update — Coordinate System Standard
# Version: 1.0 — 2026-06-30
# Author: Claude Web
# Purpose: Lock automotive coordinate convention across all project files

---

## 1. MANDATORY OPENING

```
git fetch origin && git pull origin main
```

Read in order:
1. cc_rules.md
2. rules-dimensions.md
3. rules-pr.md

---

## 2. CONTEXT

All SCAD models in this project must use the automotive coordinate convention.
This standard is now being written into governance files so it is never ambiguous.
No SCAD files are modified in this prompt — rules files only.

---

## 3. NEW FILES

NONE

---

## 4. TASKS

### TASK 1 — Add coordinate standard to rules-dimensions.md

Find the section header that best fits (top of file or after units section).
Insert the following block. Do not remove any existing content.

```
## COORDINATE SYSTEM STANDARD — ALL MODELS (automotive convention)

Origin: front-left corner of the product at floor level (Z=0)
  - "Front" = the end the user faces / foot end of reformer / door side of vending machine
  - "Left" = user's left when standing at front facing the product

X-axis: longitudinal — runs along the LONG side of the product (front to back)
  - X=0 at front face
  - X increases toward rear
  - bed_l / total_l runs along X

Y-axis: lateral — runs along the WIDTH of the product (left to right)
  - Y=0 at left edge
  - Y increases toward right
  - bed_w / total_w runs along Y

Z-axis: vertical — runs upward
  - Z=0 at floor
  - Z increases upward

OpenSCAD rotation reference (cylinder default axis = Z):
  - To orient cylinder along X (longitudinal): rotate([0,90,0])
  - To orient cylinder along Y (lateral):      rotate([90,0,0])
  - To orient cylinder along Z (vertical):     no rotation needed

QA CHECK — Claude Web reads XYZ gizmo from every OpenSCAD screenshot
before making any orientation diagnosis. Never assume axis mapping.
Always confirm from the gizmo visible in the screenshot.
```

---

### TASK 2 — Add coordinate reference to rules-pr.md

Find the OVERALL DIMENSIONS section near the top of rules-pr.md.
Insert the following line block directly below the dimensions table:

```
## PR-01 COORDINATE MAPPING (automotive convention — see rules-dimensions.md)
- X = longitudinal = bed_l direction (front foot-end to rear head-end)
- Y = lateral = bed_w direction (left pole pair to right pole pair)
- Z = vertical = floor to tower top
- Origin: front-left leg corner at floor (Z=0)
- Crossbar runs along X → rotate([0,90,0]) in OpenSCAD
- Pole runs along Z → no rotation needed
- Bed width (Y) = pole-center to pole-center distance
```

---

### TASK 3 — Add coordinate QA rule to cc_rules.md

Find the QA or geometry section of cc_rules.md.
Append the following rule:

```
## COORDINATE SYSTEM — READ BEFORE ANY GEOMETRY WORK

This project uses automotive convention (locked in rules-dimensions.md):
  X = longitudinal (long axis), Y = lateral (width), Z = vertical (up)
  Origin = front-left corner at floor.

Before writing any rotate() or translate() for a directional component:
1. State the axis explicitly in a comment: // crossbar runs along X
2. Confirm rotation: along X = rotate([0,90,0]), along Y = rotate([90,0,0])
3. Never assume — derive from parameter names (bed_l → X, bed_w → Y)
```

---

## 5. DO NOT TOUCH

- All .scad files — no geometry changes in this prompt
- viewer/janis-product-viewer.html — not in this prompt
- Any file not listed in TASKS above

---

## 6. QA VERIFICATION

Before committing, cc confirms:
- [ ] rules-dimensions.md contains coordinate system block with X/Y/Z definitions
- [ ] rules-pr.md contains PR-01 coordinate mapping block
- [ ] cc_rules.md contains coordinate system rule with rotate() reference table
- [ ] No SCAD files modified
- [ ] Version bumped on all three modified .md files

---

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at TOP
2. Archive this prompt → /prompts/archive/coordinate-system-standard-v1.md ✅ COMPLETE — 2026-06-30
3. Update knowledge.map if structure changed
4. Bump version on all changed files
5. Commit all → merge to main
