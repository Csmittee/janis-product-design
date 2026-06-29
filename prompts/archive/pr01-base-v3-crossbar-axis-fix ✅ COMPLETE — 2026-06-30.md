# pr01-base-v3-crossbar-axis-fix.md
# PR-01-base — v3 Fix Prompt
# Version: 1.0 — 2026-06-30
# Author: Claude Web
# Target: read latest committed version, save as next version (v2 or v3)

---

## 1. MANDATORY OPENING

```
git fetch origin && git pull origin main
```

Read in order before touching any code:
1. cc_rules.md
2. knowledge.map
3. cc_chat_log.md — first 3 entries only
4. rules-pr.md
5. rules-dimensions.md
6. .claude/rules-codes.md
7. Latest PR-01-base scad file — read full file before any edit

Check what version exists. Save new file as next version number.

---

## 2. CONTEXT

The crossbar is running in the WRONG direction. It currently runs side-to-side (X-axis / lateral).
It must run front-to-back (Y-axis / longitudinal) — along the length of the bed.
This is the only fix in this prompt. Nothing else changes.

---

## 3. NEW FILES

NONE — save-as only: PR-01-base-v[N+1].scad

---

## 4. TASKS

### TASK 1 — Fix crossbar axis: must run along Y (longitudinal)

**Root cause:** `crossbar_body()` uses `rotate([0,90,0])` which orients the cylinder along X-axis (side-to-side). The bed length runs along X in this SCAD coordinate system — confirm by checking pole_cx values which span 0 to bed_l along X.

**STOP. Before writing any code, verify the coordinate system from the existing file:**
- Check pole_cx values — if they span 0 to bed_l, the bed length is along X-axis
- Check pole_cy values — if they span 0 to bed_w, the bed width is along Y-axis
- The crossbar must span the BED LENGTH (X-axis) = longitudinal direction

**If bed length is along X-axis (pole_cx spans bed_l):**
- `rotate([0,90,0])` is CORRECT for longitudinal — this is the X-axis direction
- The bug is elsewhere: check the translate position — crossbar must start at X=0, span to X=bed_l
- Check: `translate([0, y_pos, xbar_z])` — y_pos must be the FRONT pole Y or REAR pole Y position
- Front crossbar: y_pos = pole_cy[0] (front pair)
- Rear crossbar: y_pos = pole_cy[2] (rear pair)
- The two crossbars are PARALLEL, both running longitudinally, separated by bed_w in Y

**If bed length is along Y-axis (pole_cx spans bed_w only):**
- Then `rotate([90,0,0])` is correct for longitudinal
- Translate must start at Y=0, span to Y=bed_l

**The visual result must be:**
- Two parallel bars, both running the full length of the bed (front-to-back in the 3D view)
- One bar passes through the two FRONT pole top collars
- One bar passes through the two REAR pole top collars
- The bars are separated by bed_w distance in the lateral direction
- The bars do NOT connect the front pole to the rear pole (that would be lateral = wrong)

**Fix the collar bore to match:**
- `pole_top_collar()` bore must be drilled in the same axis as the crossbar
- If crossbar runs along X: collar bore = `rotate([0,90,0]) cylinder(...)` — drilled through X
- If crossbar runs along Y: collar bore = `rotate([90,0,0]) cylinder(...)` — drilled through Y
- Collar body remains vertical (Z-axis cylinder) — only the bore changes

---

## 5. DO NOT TOUCH

- rules-dimensions.md — read only
- All .scad files except the new version being created
- bed_l, bed_w, bed_h — no changes
- grip_od = 32 — OWNER-LOCKED
- leg_w, leg_t — no changes (keep whatever v2 set)
- Pole D-profile shape — no changes
- All VM-01 files — do not touch
- viewer/janis-product-viewer.html — do not touch

---

## 6. QA VERIFICATION

Before committing, cc confirms:
- [ ] F5 renders without errors or warnings
- [ ] Two crossbars visible — both running along the BED LENGTH direction
- [ ] Front crossbar passes through both FRONT pole top collars
- [ ] Rear crossbar passes through both REAR pole top collars
- [ ] Collar bore is aligned with crossbar direction — bar passes cleanly through collar ring
- [ ] No crossbar connecting front pole to rear pole (that is lateral = wrong)
- [ ] Version header incremented
- [ ] No previous version overwritten

---

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at TOP
2. Archive this prompt → /prompts/archive/pr01-base-v3-crossbar-axis-fix.md ✅ COMPLETE — 2026-06-30
3. Update knowledge.map — add new scad version entry
4. Bump version on all changed files
5. Commit all → merge to main
