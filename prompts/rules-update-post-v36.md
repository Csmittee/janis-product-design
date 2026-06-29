# rules-update-post-v36.md
# Prompt for cc — Post-Manifold Chase Rules Update
# Written by: Claude Web
# Date: 2026-06-29
# Save to: /prompts/rules-update-post-v36.md

---

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order before touching anything. State every file read:
1. cc_rules.md
2. cc_chat_log.md (first 3 entries — newest at top after this session)
3. rules-dimensions.md
4. knowledge.map
5. rules.md (old lowercase — you will replace this)

This prompt has no SCAD changes. Docs and governance only. Complete ALL tasks before committing.

---

## 2. CONTEXT

The 2-manifold warning that persisted from v17 to v36 was caused by two OpenSCAD-specific
traps not documented anywhere in the rules system:

1. Implicit union trap — display objects as siblings inside structural translate() are
   silently unioned. Surface at 0mm clearance = non-manifold.
2. Polygon undercut trap — $fn=64 cylinders dip ~0.04mm below theoretical radius.
   Epsilon (e=0.01mm) is not enough clearance for cylinder-to-flat-face contact.

Neither trap was documented. Neither was in Claude Web's diagnostic protocol.
Result: 20 revisions of guessing instead of 2 revisions of systematic isolation.

This prompt permanently encodes all lessons. It also:
- Replaces the old lowercase rules.md with a proper RULES.md (numbered R-xxx format)
- Creates SKILL_manifold_triage.md for Claude Web's fast-path diagnosis
- Flips cc_chat_log to top-append so Claude Web always reads newest 3 entries first
- Adds one-prompt-at-a-time as a written rule

---

## 3. NEW FILES

- `RULES.md` — NEW at repo root — replaces and deletes `rules.md`
- `.claude/SKILL_manifold_triage.md` — NEW — Claude Web manifold fast-path (cc never reads this)

Add both to knowledge.map.

---

## 4. TASKS

---

### TASK 1 — Delete `rules.md` and create `RULES.md` at repo root

Delete the file `rules.md` from repo root entirely.

Create new file `RULES.md` at repo root with the following complete content.
Merge any unique governance content from the old rules.md that is not already
covered below (check sections 1-9 of old rules.md — units, naming, version control,
approval gates). If already covered in rules-dimensions.md or cc_rules.md, do not duplicate.

```markdown
# RULES.md
# Janis Product Design — Numbered Rules Log
# Version: 1.0 — 2026-06-29
# Changes: Created — replaces rules.md. Merges old governance + numbered lessons from v17-v36 chase.
# Previous: rules.md (deleted)
# Read by: cc before every SCAD task. Claude Web during diagnosis.
# Format: newest rule at TOP. Append above previous entries. Never delete — mark [DEPRECATED] if superseded.

---

## Standard Units & Governance (from rules.md — retained)

- All dimensions in MILLIMETERS — always
- Pipe OD: 25mm standard (state if different)
- Wall thickness: 2mm aluminum / 3mm steel / 4mm composite
- Tolerance: ±0.5mm unless stated
- Never overwrite files — always increment v1→v2→v3
- Every supplier export → /exports/for-supplier/
- Every prompt saved in /prompts/ before CAD session starts
- Never put more than 400 lines in any rules file — split by domain
- Never delete old rules — mark [DEPRECATED] if changed

## File Naming Convention
[PRODUCT]-[MODEL]-[COMPONENT]-[VERSION]
Examples: PR-01-base-rail-joint-v1.stl / VM-01-frame-corner-v2.scad

## Approval Gates (before moving to next component)
- F5 preview correct
- F6 full render clean — no warnings
- STL → /exports/for-supplier/
- DXF → /exports/for-cnc/
- Prompt → /prompts/
- Screenshot → /renders/
- Relevant rules file updated if new learning

---

## Numbered Rules — Newest First

## R-004 — One prompt open at a time
Date: 2026-06-29
Never push a second prompt to /prompts/ while cc is executing one.
Wait for cc_chat_log confirmation before writing the next prompt.
Stacked prompts cause version conflicts and unclear QA state.

## R-003 — Debug toggle declaration rule
Date: 2026-06-29
Never comment out a debug variable declaration line (e.g. // show_shell_back = true).
If a module references that variable, OpenSCAD warns "Ignoring unknown variable".
To hide a panel: set value to false. Keep the declaration line active always.

## R-002 — Polygon undercut minimum clearance
Date: 2026-06-29
$fn=64 cylinders undercut theoretical radius by ~0.04mm per r=33mm
formula: r × (1 - cos(180/$fn)).
Epsilon (e=0.01mm) is NOT enough for cylinder-to-flat-face contact.
Minimum clearance for any cylinder near a flat face: 2mm.
Root cause of coil-floor contact in v36 manifold chase.

## R-001 — Implicit union trap (display objects inside structural translate)
Date: 2026-06-29
In OpenSCAD, all children of translate()/rotate()/color() are implicitly unioned.
A display object (coil, motor, partition) placed as a sibling of a structural
difference() body inside the same translate() will union with that body.
If its surface touches any tray face at 0mm clearance = non-manifold.
Fix: call display objects from assembly level as their own named module —
never as siblings inside a structural translate().
Root cause of v17–v36 manifold chase (20 revisions).
```

---

### TASK 2 — Update `.claude/rules-codes.md`

Append two new sections at the bottom. Do not modify any existing content.

```
---

## COLOR CODING STANDARD
Color by part type — never by material. Makes manifold contact visually obvious during QA.

| Part type           | Color    | Opacity  |
|---|---|---|
| Tray structural body | #CCCCCC | 1.0      |
| Motor (display only) | #555555 | 1.0      |
| Spring coil (display only) | #888888 | 0.8 |
| Partition (display only)   | #BBBBBB | 1.0 |
| Rack rails and legs        | #AAAAAA | 1.0 |
| Outer shell                | #C8C8C8 | 0.75    |
| Acrylic panels             | #ADD8E6 | 0.15–0.30 |

Display objects (motor, coil, partition) must NEVER use the same color as structural bodies.
Color difference makes surface tangency visible during F5 inspection.

---

## MANIFOLD SAFETY RULES
# Hard-won from v17–v36 manifold chase. Violation = multi-revision debug loop.

### Rule M-1 — Implicit Union Rule (CRITICAL)
All children of translate()/rotate()/color() are implicitly unioned by OpenSCAD.
A display object placed as a SIBLING of a structural difference() body inside the
same translate() will be UNIONED with that body. Surface at 0mm = non-manifold.

WRONG:
  translate([x, y, z]) {
      difference() { tray_body(); cutouts(); }  // structural
      cylinder(h=spring_l, d=spring_od);         // display — SILENTLY UNIONED
  }

RIGHT:
  translate([x, y, z]) difference() { tray_body(); cutouts(); }
  spring_display(lane=i, tray_z=z);  // display called from assembly level

### Rule M-2 — Polygon Undercut Rule
$fn=64 cylinders dip below theoretical radius: r × (1 - cos(180/$fn)) ≈ 0.04mm at r=33mm.
Epsilon e=0.01mm is NOT sufficient for cylinder-to-flat-face contact.
Minimum clearance for any cylinder near a flat face: 2mm.

### Rule M-3 — Contact Receipt Rule
Any object within 5mm of another face MUST have a calculation comment showing gap:
  // Motor rear face: tray_d - motor_d - tray_wall_t - e = 386.99mm — gap to rear wall = 60.01mm ✓
  // Coil bottom: tray_floor_t + 2 = 7mm — gap to floor top = 2mm ✓
No geometry placed near a boundary without a written receipt.

### Rule M-4 — Debug Toggle Rule
Debug visibility toggles MUST be declared as variable assignments above ASSEMBLY.
NEVER comment out a declaration line — set to false to hide. See R-003.
```

---

### TASK 3 — Update `rules-dimensions.md`

Append two new sections at the bottom. Do not modify any existing content.

```
---

## Global Clearance Tolerance
| Context | Minimum gap | Reason |
|---|---|---|
| Display object to any tray body face | 2mm | Implicit union → manifold risk (R-001) |
| Cylinder to any flat face | 2mm | Polygon undercut at $fn=64 (R-002) |
| Structural part to shell face | skin_t (2mm) | Standard skin thickness |
| Coplanar face suppression (epsilon) | e = 0.01mm | Geometry z-fight only — NOT for display objects |

---

## Coordinate Reference Points — LOCKED
| Name | World coords | Description |
|---|---|---|
| Machine origin | X=0, Y=0, Z=0 | Front-left corner at floor level |
| Tray local origin | X=lane_x, Y=tray_start_d, Z=tray_z | Front-left of tray floor |
| Spring lane centre | X = tray_wall_t + spring_od/2 + i*(spring_od+spring_gap) | Per lane i (0-indexed) |
| Drop zone boundary | Y = tray_start_d = 138mm | Products fall forward from here |
| Motor rear limit | Y = tray_d - tray_wall_t - e | Never touches or exits rear wall |
| Coil front face | Y = tray_start_d (local Y=0) | Drop zone boundary |

---

## Spring Coil Physical Spec
| Parameter | Value | Note |
|---|---|---|
| OD | 66mm | Supplier part — LOCKED |
| Wire diameter | 3mm | |
| ID | 60mm | OD - 2×wire_d |
| Pitch | 25mm | |
| Length | 390mm | spring_l parameter |
| SCAD model | solid cylinder d=spring_od-2, h=spring_l-2 | 1mm clearance each side — display only |
```

---

### TASK 4 — Create `.claude/SKILL_manifold_triage.md` (NEW FILE)

cc does not use this file. Create it for Claude Web only. Do not add to cc read list.
Add to knowledge.map with note "Claude Web only — not read by cc".

```markdown
# SKILL_manifold_triage.md
# Claude Web — Manifold Triage Fast-Path
# Version: 1.0 — 2026-06-29
# Changes: Initial — created from v17–v36 manifold chase lessons
# Owner: Claude Web reads this when F6 shows 2-manifold warning. cc does not read this file.

---

## WHEN TO USE THIS

Janis reports F6 "WARNING: The given mesh is not closed!" or 2-manifold warning.
Before writing ANY fix prompt: run this triage. Do not guess. Do not skip steps.

---

## PHASE 1 — COLLECT RAW SYMPTOM

Ask Janis:
1. Which version first showed the warning?
2. Did any recent change touch: tray body, spring coil, motor, partition, or rack?
3. How many warning lines?

Do not form hypothesis yet.

---

## PHASE 2 — IS / IS-NOT TABLE

| Question | IS | IS-NOT |
|---|---|---|
| Which module suspected | | |
| First appeared at version | | |
| Still present after last fix | Yes / No | |

---

## PHASE 3 — HYPOTHESIS (each must explain IS and IS-NOT)

| # | Hypothesis | Test |
|---|---|---|
| H1 | Display object sibling of structural body (R-001) | Wrap display in if(false) — warning disappear? |
| H2 | Cylinder surface tangent to flat face (R-002) | Any cylinder within 2mm of flat face? |
| H3 | Hollow cylinder inner/outer near-flush | Is there difference() inside display module? |
| H4 | Structural coincident faces | Any two structural faces at exactly 0mm? |

---

## PHASE 4 — ISOLATION TEST (mandatory before any fix prompt)

Write ONE rapid-fire instruction (not a .md prompt):
  In [module](), wrap [object] in if(false) { }. No other changes.
  F6 → report: warning gone or still present?

Never write a fix prompt without confirmed isolation result.

---

## PHASE 5 — FIX

H1 confirmed: Separate display from structural translate(). Call from assembly level.
H2 confirmed: Increase clearance to 2mm minimum. Add contact receipt comment.
H3 confirmed: Replace hollow cylinder with solid cylinder.
H4 confirmed: Add epsilon (e) to one face only.

---

## WHAT CLAUDE WEB NEVER DOES DURING MANIFOLD CHASE

- Never writes fix prompt without F6 result from isolation test
- Never skips Phase 1–3 even if hypothesis feels obvious
- Never chains two fixes in one prompt during manifold chase
- Triggers R-111 if warning persists after 2 isolation-confirmed fix attempts
- Maximum 3 prompts from warning to QA PASS:
  Prompt 1: Isolation test → Prompt 2: Fix → Prompt 3: Confirm PASS
```

---

### TASK 5 — Flip `cc_chat_log.md` to top-append

Update the header comment of cc_chat_log.md:

Change:
```
# cc updates BOTTOM of log — newest entry last.
```
To:
```
# cc updates TOP of log — newest entry FIRST.
# Claude Web reads first 3 entries only. Keep each entry under 10 lines.
```

Then move the v36 entry to the TOP of the Session Log section (above v35).
Reorder ALL existing entries so newest is first, oldest is last.
Do not delete any entries — reorder only.

---

### TASK 6 — Update `cc_rules.md`

In "After Every Commit" section, change:
```
1. Update cc_chat_log.md — append new entry with date, version, what changed
```
To:
```
1. Update cc_chat_log.md — PREPEND new entry at TOP (newest first). Max 10 lines per entry.
```

Bump cc_rules.md version and date.

---

### TASK 7 — Update `WORKFLOW_SKILL.md`

Bump version 3.0 → 3.1. Add the following subsection immediately after the
`## TRIGGER → ACTION → VALIDATOR` table:

```
---

## MANIFOLD WARNING FAST-PATH

When Janis reports F6 2-manifold warning:
1. Read .claude/SKILL_manifold_triage.md immediately.
2. Complete Phase 1–3 (IS/IS-NOT + hypothesis) BEFORE writing any prompt.
3. First prompt is ALWAYS an isolation test — never a fix.
4. Fix prompt written ONLY after Janis confirms isolation test result.
5. Warning persists after 2 isolation-confirmed fix attempts → R-111.

Maximum 3 prompts from warning to QA PASS:
  Prompt 1: Isolation test (rapid-fire)
  Prompt 2: Fix
  Prompt 3: Confirm F6 clean — PASS or FAIL
```

Also update Step 3 of the SESSION OPENING sequence:
Change "read last 3 entries" → "read first 3 entries (newest at top)".

---

### TASK 8 — Update `chat_rules.md`

Bump version v3 → v3.1. Make two changes:

**Change 1** — Under `## Reading & Diagnosis`, update:
```
- Never form any diagnosis before reading cc_chat_log last 3 entries + affected SCAD file
```
To:
```
- Never form any diagnosis before reading cc_chat_log first 3 entries (newest at top) + affected SCAD file
```

**Change 2** — Under `## QA Discipline`, add new bullet:
```
- 2-manifold warning: read SKILL_manifold_triage.md before writing any prompt.
  First action is always an isolation test, not a fix.
  Maximum 3 prompts from warning report to QA PASS — if exceeded, R-111 triggers.
```

---

### TASK 9 — Update `knowledge.map`

Add new rows for new files:
```
| RULES.md                            | root    | Numbered rules R-xxx — cc reads before SCAD tasks, Claude Web during diagnosis. Replaces rules.md. |
| .claude/SKILL_manifold_triage.md    | .claude/| Claude Web only — manifold triage fast-path. cc does NOT read this file. |
```

Remove the row for `rules.md` (deleted in Task 1).
Bump knowledge.map version and date.

---

## 5. DO NOT TOUCH

- `rules-dimensions.md` existing content — append only
- `.claude/rules-codes.md` existing content — append only
- `WORKFLOW_SKILL.md` existing content — append only, bump version header only
- `chat_rules.md` existing content — targeted edits only per Task 8, bump version
- `cc_rules.md` existing content — targeted edit only per Task 6, bump version
- `cc_chat_log.md` entries — reorder only, no deletions
- All .scad files — do not touch
- `.claude/SKILL_problem_solving_kt.md` — do not touch
- `/exports/`, `/renders/`

---

## 6. QA VERIFICATION

Before committing, confirm ALL:

- [ ] `rules.md` deleted from repo root
- [ ] `RULES.md` created at repo root — contains governance + R-001 through R-004
- [ ] `.claude/rules-codes.md` — COLOR CODING STANDARD section present
- [ ] `.claude/rules-codes.md` — MANIFOLD SAFETY RULES section present (M-1 through M-4)
- [ ] `rules-dimensions.md` — Global Clearance Tolerance table present
- [ ] `rules-dimensions.md` — Coordinate Reference Points table present
- [ ] `rules-dimensions.md` — Spring Coil Physical Spec table present
- [ ] `.claude/SKILL_manifold_triage.md` — new file exists, 5 phases present
- [ ] `cc_chat_log.md` — header says "newest at TOP", v36 is first entry
- [ ] `cc_rules.md` — "PREPEND at TOP, max 10 lines" in After Every Commit
- [ ] `WORKFLOW_SKILL.md` — version 3.1, MANIFOLD WARNING FAST-PATH section present
- [ ] `WORKFLOW_SKILL.md` — Step 3 says "first 3 entries (newest at top)"
- [ ] `chat_rules.md` — version v3.1, "first 3 entries" in Reading & Diagnosis
- [ ] `chat_rules.md` — manifold triage bullet under QA Discipline
- [ ] `knowledge.map` — RULES.md row added, rules.md row removed, SKILL_manifold_triage.md row added
- [ ] No existing rules content removed or modified beyond what tasks specify
- [ ] No .scad files touched

---

## 7. MANDATORY CLOSING

1. Prepend new entry to cc_chat_log.md at TOP — max 10 lines
2. Archive this prompt → /prompts/archive/rules-update-post-v36 ✅ COMPLETE — 2026-06-29
3. Update knowledge.map — confirm new files added
4. Bump version on all modified .md files
5. Commit all → merge to main
