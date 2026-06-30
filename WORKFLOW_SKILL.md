# WORKFLOW_SKILL.md
# Janis Product Design — How We Work
# Version: 3.2 — 2026-06-30
# Changes: Joint construction skill + rapid-fire template + R-111 self-trigger reinforcement added.
# Previous: v3.1 — 2026-06-29

---

## DOCUMENT VERSIONING RULE (all .md files in this project)

```
> Version X.Y — YYYY-MM-DD
> Changes: [one line summary]
> Previous: vX.Y — YYYY-MM-DD
```
- X.Y → X.Y+1 = detail change, same structure
- X.0 → X+1.0 = new section or structure changed
No file is committed without a version bump if content changed.

---

## PROJECT CONTEXT

Repo: github.com/Csmittee/janis-product-design
Product: Satu vending machine — physical enclosure only
Stack: OpenSCAD (.scad), STL, DXF, PNG renders
Authoritative dimensions: rules-dimensions.md (repo root) — never duplicated
Payment: Online only — no cash/coin, never

---

## THE THREE ROLES

### 👤 JANIS (Owner)
- Describes goals, QAs results via screenshots, approves all versions
- Pushes prompt files to repo — never pastes prompts directly to cc
- Never edits .scad files manually unless Claude Web gives exact line instruction

### 🧠 CLAUDE WEB (this session)
- Plans, diagnoses, writes cc prompts — never writes SCAD directly
- Reads cc_chat_log from project knowledge (synced from repo) at every session open
- Diagnoses before acting — never guesses dimensions
- Generates CHAT_HANDOFF at session end
- Flags any locked dimension change to Janis before writing any prompt

### 🤖 CC (Claude Code)
- Reads cc_rules.md + required files before every task
- Writes complete replacement .scad files — never patches
- Verifies from live repo — not bound by Claude Web's suggested implementation
- Writes to cc_chat_log.md after every session — this is cc's only response channel back
- Never writes CHAT_HANDOFF — Claude Web only

---

## SYMMETRIC COMMUNICATION SYSTEM

| Doc type | Claude Web | CC |
|---|---|---|
| **HANDOFF** | CHAT_HANDOFF.md — project knowledge, single use | cc_chat_log.md — repo root, cc writes, Claude Web reads |
| **SKILL** | WORKFLOW_SKILL.md — this file | cc_rules.md — repo root |
| **RULE** | chat_rules.md — project knowledge | rules-dimensions.md — repo root |

cc_chat_log.md is the **only channel cc has to respond to Claude Web**.
Claude Web instructs forward via prompts. cc responds backward via cc_chat_log.
This asymmetry is by design. All spy tests must be designed for Janis to execute.

---

## CLAUDE WEB SESSION OPENING — MANDATORY SEQUENCE

Janis pastes CHAT_HANDOFF → Claude Web executes in order:

**Step 1:** Search project knowledge for "WORKFLOW_SKILL" — load this file.
  Not found → tell Janis to upload WORKFLOW_SKILL.md to project knowledge. STOP.

**Step 2:** Search project knowledge for "chat_rules" — load rules.
  Not found → tell Janis to upload chat_rules.md. STOP.

**Step 3:** Search project knowledge for "cc_chat_log" — read first 3 entries (newest at top).
  This file is synced from repo root. Finding it confirms project knowledge is live.
  Not found → repo sync is broken. Tell Janis before proceeding. Do NOT ask Janis
  to download and upload manually — that defeats the connectivity check.

**Step 4:** Read CHAT_HANDOFF open items. State "Memory installed."

**Step 5:** Ask "Today's goal?" — even if handoff already states it.

Do not respond to any task until all 5 steps confirmed.

---

## JANIS SESSION PREP

Before opening Claude Web: paste CHAT_HANDOFF.md into new chat.
Project knowledge syncs from repo — cc_chat_log is always current if sync is healthy.
No manual download/upload of cc_chat_log needed.

---

## THE DEVELOPMENT LOOP

```
Janis describes goal
  → Claude Web reads cc_chat_log + rules-dimensions → diagnoses
  → Claude Web writes prompt as .md file
  → Janis pushes to /prompts/ in repo
  → Janis tells cc to read and execute
  → cc reads required files → writes new .scad version → commits
  → cc appends cc_chat_log → archives prompt → updates knowledge.map
  → Janis opens .scad in OpenSCAD → F5 visual check → F6 manifold check
  → Screenshots to Claude Web → QA PASS or FAIL
  → If FAIL → Claude Web writes fix prompt → loop repeats
  → Claude Web writes CHAT_HANDOFF → Janis saves to project knowledge
```

---

## TRIGGER → ACTION → VALIDATOR

| Trigger | Action | Validator |
|---|---|---|
| Problem not fixed within 2 loops | R-111 — STOP. Claude Web invokes KT. No new prompt until KT complete | Claude Web states "R-111 triggered" explicitly |
| New .scad file created | cc adds to knowledge.map | Claude Web reads cc_chat_log next session |
| Dimension change requested | Claude Web flags impact → Janis approves → rules-dimensions.md updated first | cc reads updated file before any .scad change |
| Locked dimension touched without approval | cc stops, flags in cc_chat_log | Claude Web reads log, escalates to Janis |
| Version not incremented | Reject commit — add bump first | Whoever reviews next flags it |
| cc_chat_log not found in project knowledge | Repo sync broken — tell Janis immediately | Do not proceed without resolving |
| QA screenshot shows geometry missing | Check error log for undefined variables first | Fix variable declaration order before visual fix |
| Supplier export requested | Only after QA PASS — STL + DXF + 4-angle PNG | cc confirms all 3 in cc_chat_log |
| Joint/transition between mismatched cross-sections fails QA twice | R-111 — read .claude/SKILL_joint_construction.md, complete KT before next prompt | Claude Web states "R-111 triggered" + cites which rule (1/2/3) was violated |

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

---

## RAPID-FIRE PROMPT TEMPLATE — MINIMAL BUT COMPLETE

Rapid-fire chat instructions (single confirmed line/module, cc still in
session) do NOT need to re-list files cc already has in its current session
context — do not ask cc to re-read cc_rules.md, knowledge.map, or the
active .scad file again mid-session.

Rapid-fire instructions DO still need, every time, even though they are
short:
1. The exact module/line/parameter to change
2. Current open-item context relevant to this change (one line — e.g.
   "PR-01-base v18, joint fix, neck-bell still open")
3. The specific QA confirmation cc must state back (what number/result
   proves this worked)
4. Any DO NOT TOUCH items relevant to this specific change (not the full
   project list — just what's at risk of being accidentally touched by
   this exact edit)

A rapid-fire instruction that drops items 2-4 to save length is an
incomplete instruction, not an efficient one. Length savings come from
skipping redundant file re-reads (item 0, not in the list above) — never
from skipping open-items/QA/do-not-touch content.

---

## INTERVENTION LEVELS — USE THE LIGHTEST ONE

| Level | When | Example |
|---|---|---|
| Build prompt (.md file) | New feature, new model, multi-module | Zone redesign |
| Fix prompt (.md file) | Single confirmed bug, clear module | Fix one module |
| Rapid-fire phrase (chat) | One confirmed line, cc still in session | Change one parameter |
| Janis direct edit | One line, Claude Web gives exact instruction | Insert `e = 0.01;` at line 42 |

Never use a heavier intervention than needed.

---

## PROBLEM SOLVING — R-111 AND KT

**R-111 triggers when a problem cannot be resolved within 2 fix loops.**
Claude Web self-triggers. Janis does not need to ask.
No new fix prompt is written until KT phases are complete.

Read: `.claude/SKILL_problem_solving_kt.md`
This single file covers all problem types including SCAD manifold.

KT minimum in-session (if file unavailable):
- Phase 1: Raw symptom only — no interpretation
- Phase 2: IS / IS-NOT table (WHAT / WHERE / WHEN / EXTENT)
- Phase 3: Hypotheses — each must explain both IS and IS-NOT or be eliminated
- Phase 4: Spy test — one change, one observation, then fix

---

## CC PROMPT TEMPLATE (7 sections — build prompts)

**Build prompts → .md file in /prompts/ — never a chat text block.**
**Rapid-fire fixes → chat text block is acceptable.**

```
## 1. CC INTRO
git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → cc_chat_log.md (last 3) → rules-dimensions.md → [source .scad]
State every file read before writing a single line.

## 2. CONTEXT
Why this prompt exists. What problem it solves.

## 3. NEW FILES
List all new filenames. NONE if none. Add each to knowledge.map.

## 4. TASKS
Numbered. Root cause stated. Exact file named. Exact fix described.
cc verifies from live repo — not bound by Claude Web's suggested implementation.

## 5. DO NOT TOUCH
Explicit exclusion list.
Always include: rules-dimensions.md — read only.
Always include: all .scad files not listed in TASKS.

## 6. QA VERIFICATION
Checklist cc confirms before committing.
Always: no undefined variable warnings in SCAD.
Always: version incremented — never overwrite.

## 7. MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP
2. Archive prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Update knowledge.map if new files created
4. Bump version on all changed files
5. Commit all → merge to main
```

---

## PRE-DELIVERY SELF-CHECK (Claude Web — silent, before every prompt)

- [ ] Build prompt? → must be .md file
- [ ] Section 1 has git fetch + all required reads?
- [ ] Target file path explicit?
- [ ] DO NOT TOUCH includes rules-dimensions.md?
- [ ] Save-as filename stated with version increment?

Fix before delivering. Never ask Janis to remind.

---

## CHAT HANDOFF TEMPLATE

```
# CHAT HANDOFF — [date] END OF SESSION
> Single-use — paste entire file to open new chat
> BEFORE SESSION BEGINS — Claude Web reads in order:
> Step 1: Load WORKFLOW_SKILL (project knowledge → STOP if missing)
> Step 2: Load chat_rules (project knowledge → STOP if missing)
> Step 3: Read cc_chat_log first 3 entries (newest at top) (project knowledge sync from repo → STOP if missing)
> Step 4: Read open items below → state "Memory installed"
> Step 5: Ask "Today's goal?"

## ACTIVE MODEL
[model name — last committed version]

## SYSTEM STATUS
| Model | Last Version | QA Status | Export Status |

## WHAT WAS DONE TODAY
[files changed, prompts sent, QA results]

## OPEN ITEMS — PRIORITY ORDER
| Item | Status | Notes |

## NEXT SESSION — START HERE
[exact first action with file names]

## JANIS ACTION REQUIRED
[physical actions only — push file, screenshot, download]

## FLAGS FOR NEXT SESSION
[pending decisions, governance notes]
```

---

## SESSION CLOSING

**Claude Web:**
1. Read cc_chat_log — verify delivery matches request. Flag any gap to Janis.
2. Write CHAT_HANDOFF → tell Janis to save to project knowledge.

**cc:**
1. Prepend cc_chat_log (newest at TOP)
2. Archive prompt → /prompts/archive/ ✅ COMPLETE
3. Update knowledge.map if new files
4. Bump version on all changed files
5. Commit all → merge to main

---

## FILE STRUCTURE — REPO

```
janis-product-design/
├── cc_rules.md                          ← cc reads every session
├── cc_chat_log.md                       ← cc writes / Claude Web reads (via project knowledge sync)
├── chat_rules.md                        ← Claude Web rules
├── rules-dimensions.md                  ← authoritative dimensions
├── knowledge.map                        ← navigation — cc updates when files added
├── WORKFLOW_SKILL.md                    ← this file (also in project knowledge)
├── .claude/
│   ├── rules-codes.md                   ← cc — SCAD coding rules
│   ├── rules-materials.md               ← cc — material specs
│   ├── rules-vm.md                      ← cc — VM-specific rules
│   └── SKILL_problem_solving_kt.md      ← Claude Web + cc — R-111 trigger
├── prompts/                             ← active cc prompts
│   └── archive/                         ← completed prompts ✅ COMPLETE
├── vending-machine/VM-01-base/          ← VM-01 .scad versions
├── pilates-reformer/PR-01-base/         ← PR-01 (NOT STARTED)
├── exports/for-supplier/                ← STL
├── exports/for-cnc/                     ← DXF
└── renders/                             ← PNG screenshots
```

Project knowledge (Claude Web only — never in repo):
- CHAT_HANDOFF.md — single use, overwrite each session
- WORKFLOW_SKILL.md — also in repo root, synced when updated
- chat_rules.md — also in repo root
