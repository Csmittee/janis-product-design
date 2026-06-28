# 🎯 WORKFLOW SKILL — Janis Product Design
> Version 2.0 — 2026-06-28
> Changes: KT problem solving section upgraded — full trigger rule, repo file reference added
> Previous: v1.0 — 2026-06-28

---

## DOCUMENT VERSIONING RULE (applies to ALL .md files in this project)

Every document must carry a version header. Format:
```
> Version X.Y — YYYY-MM-DD
> Changes: [one line summary of what changed]
> Previous: vX.Y — YYYY-MM-DD
```

Version increment rules:
- **X.Y → X.Y+1**: same sections, detail change only
- **X.0 → X+1.0**: new section added or structure changed

Who applies this: whoever last edited the file — Claude Web, cc, or Janis.
No document is committed without a version bump if content changed.

---

## PROJECT CONTEXT

This repo is the **physical body** of the Satu vending machine system.
The heart (firmware) and brain (backend) live in separate Satu project repos
and are already built. This repo designs, versions, and exports the
mechanical enclosure for supplier fabrication.

**Repo:** github.com/Csmittee/janis-product-design
**Stack:** OpenSCAD (.scad), STL exports, DXF exports, PNG renders
**Authoritative dimensions:** rules-dimensions.md (repo root)
**Design decisions:** rules-dimensions.md only — not duplicated anywhere

---

## THE THREE ROLES

### 👤 JANIS (Owner)
- Describes goals, reports QA results via screenshots
- Approves or rejects every version before supplier export
- Pushes prompt files to repo — never pastes prompts directly to cc chat
- Never edits .scad files manually unless Claude Web gives exact line instruction
- Observes workflow health — if something feels wrong, checks this document first

### 🧠 CLAUDE WEB (this session)
- Reads repo via project knowledge sync
- Reads cc_chat_log.md last 3 entries at every session open
- Diagnoses before acting — never guesses dimensions
- Writes cc prompts as complete .md files (7 sections — see template below)
- Rapid-fire phrases only for single confirmed one-line fixes
- Does NOT write .scad code directly
- Generates CHAT_HANDOFF at session end
- Flags any decision that touches locked dimensions to Janis before writing prompt

### 🤖 CC (Claude Code)
- Reads cc_rules.md + cc_chat_log.md + rules-dimensions.md before every session
- Reads the prompt file specified for today's task
- Writes complete replacement .scad files — never patches or diffs
- Is NOT bound by Claude Web's suggested implementation — verifies from live repo
- Writes to cc_chat_log.md at end of every session
- Commits and merges to main before session closes
- Never writes CHAT_HANDOFF — that is Claude Web's responsibility only
- Never reads or updates WORKFLOW_SKILL.md — that governs Claude Web only

---

## SYMMETRIC 3-DOCUMENT SYSTEM

Every party has: HANDOFF + SKILL + RULE

| Doc type | Claude Web | CC |
|---|---|---|
| **HANDOFF** | `CHAT_HANDOFF.md` — project knowledge only, single use, never in repo | `cc_chat_log.md` — repo root, cc writes, Claude Web reads last 3 |
| **SKILL** | `WORKFLOW_SKILL.md` — this file, project knowledge master | `cc_rules.md` — repo root, cc reads every session |
| **RULE** | `chat_rules.md` — project knowledge | `rules-dimensions.md` — repo root, authoritative for all dimensions |

**File location discipline:**
- Project knowledge = Claude Web's world (CHAT_HANDOFF, WORKFLOW_SKILL, chat_rules)
- Repo = cc's world (cc_chat_log, cc_rules, rules-dimensions, all .scad files)

---

## WORKFLOW_SKILL.md LOAD ORDER — MANDATORY

At start of every Claude Web session:
1. Try to read WORKFLOW_SKILL.md from repo first — confirms repo access
2. If not in repo, read from project knowledge
3. If found in neither — **STOP. Tell Janis to download WORKFLOW_SKILL.md
   and install to project knowledge before proceeding. Do not continue.**

Claude Web must not respond to any task until this file is confirmed loaded.

---

## THE DEVELOPMENT LOOP

```
Janis describes goal or pastes CHAT_HANDOFF
        ↓
Claude Web reads cc_chat_log last 3 entries → reads rules-dimensions.md → diagnoses
        ↓
Claude Web writes cc prompt as .md file → Janis pushes to /prompts/ in repo
        ↓
Janis runs cc: "Hey cc, git fetch --all && git checkout main && git pull first.
                Then read prompts/[filename].md and execute."
        ↓
cc reads cc_rules.md + cc_chat_log + rules-dimensions + prompt → executes
cc writes complete new .scad file (never overwrites — always increments version)
cc updates cc_chat_log → commits → merges to main
        ↓
Janis opens .scad in OpenSCAD → screenshots → sends to Claude Web
        ↓
Claude Web QA: PASS or FAIL with specific reasons
If PASS → approve for export
If FAIL → Claude Web writes fix prompt → loop repeats
        ↓
Claude Web writes CHAT_HANDOFF → Janis saves to project knowledge
```

---

## TRIGGER → ACTION → VALIDATOR CONTRACT

| Trigger | Detected by | Action | Validator |
|---|---|---|---|
| New .scad file created | cc | Add to knowledge.map | Claude Web reads cc_chat_log next session |
| Same fix fails twice | Claude Web or cc | **STOP → invoke KT framework (see below)** | Claude Web completes all KT phases before next prompt |
| Dimension change requested | Janis | Claude Web flags impact → Janis approves → update rules-dimensions.md first | cc reads updated rules-dimensions before any .scad change |
| WORKFLOW_SKILL.md changed | Janis decides, cc writes | Claude Web verifies content before merge | Claude Web confirms to Janis explicitly |
| Locked decision touched without approval | cc detects | cc stops, writes flag in cc_chat_log, does not proceed | Claude Web reads log, escalates to Janis |
| Version not incremented on commit | cc or Claude Web | Reject — add version bump before committing | Whoever reviews next flags it |
| cc_chat_log unreadable or missing | Claude Web | Tell Janis immediately — do not proceed without it | Janis syncs, Claude Web re-reads |
| Janis works in live file (not versioned) | Janis tells Claude Web | Note in session — only push to repo when stable | cc only edits files that exist in repo |
| QA screenshot shows geometry missing | Claude Web | Check error log for undefined variables first | Fix variable declaration order before any visual fix |
| Supplier export requested | Claude Web | Only after QA PASS — write export prompt for STL + DXF + 4-angle PNG | cc confirms all 3 export types in cc_chat_log |

---

## INTERVENTION LEVELS — USE THE LIGHTEST ONE

| Level | Who | When | Example |
|---|---|---|---|
| Full cc prompt (Build) | cc reads all context | Multi-file, new feature, new model | New product model, major rebuild |
| Fix prompt | cc reads 1-2 files | Single bug, clear symptom | Fix one module, one variable |
| Rapid fire phrase | Claude Web tells Janis what to type to cc | One confirmed change, cc still in session | Change one color, insert one variable |
| Janis direct edit | Janis edits in OpenSCAD | One line, Claude Web gives exact instruction | Insert `exit_door_h = 250;` at line 52 |

**Never use a heavier intervention than needed. Saves tokens and time.**

---

## CLAUDE WEB SESSION OPENING — MANDATORY SEQUENCE

Janis pastes CHAT_HANDOFF → Claude Web executes in order, confirms each step:

1. Load WORKFLOW_SKILL.md (repo first, project knowledge fallback, STOP if neither)
2. Read chat_rules.md from project knowledge
3. Read cc_chat_log.md last 3 entries — state summary + any pending flags
4. Read open items in CHAT_HANDOFF — state "Memory installed"

Only then ask: "Ready — what's today's goal?" (even if already stated in handoff)
Do not respond to any task until all 4 steps confirmed.

---

## CC PROMPT TEMPLATE (7 sections — all required for build prompts)

**DELIVERY RULE:**
- Full build prompts → .md file in /prompts/ — never a chat text block
- Rapid-fire fixes → text block in chat is acceptable

```markdown
## 1. CC INTRO
git fetch --all && git checkout main && git pull origin main
Read in order before touching anything:
  1. cc_rules.md
  2. cc_chat_log.md (last 3 entries)
  3. rules-dimensions.md
  4. [source .scad file for this task]
State every file read before writing a single line.

## 2. CONTEXT
[Why this prompt exists. What problem it solves.]

## 3. NEW FILES (if any)
[List every new filename being created]
[Add each to knowledge.map]
[Write NONE if no new files]

## 4. TASKS
[Numbered. Root cause stated. Exact file named. Exact fix described.]
[cc verifies from live repo — not bound by Claude Web's suggested implementation]

## 5. DO NOT TOUCH
[Explicit exclusion list]
[Always include: rules-dimensions.md — read only, never edit]
[Always include: any .scad file not listed in TASKS]

## 6. QA VERIFICATION
[What cc confirms before closing PR]
[Always: confirm no undefined variable warnings in SCAD]
[Always: confirm version incremented — never overwrite]

## 7. MANDATORY CLOSING (every session)
1. Append cc_chat_log.md — newest entry at BOTTOM
2. Archive this prompt → /prompts/archive/ stamped ✅ COMPLETE — [date]
3. Update knowledge.map if any new files created
4. Bump version header on every file changed
5. Commit all in correct order → merge to main
```

---

## CLAUDE WEB PRE-DELIVERY SELF-CHECK

Before delivering any cc prompt, Claude Web silently verifies:
- [ ] Is this a build prompt? → must be .md file, never a text block
- [ ] Does Section 1 include git fetch + all 4 required reads?
- [ ] Does Section 7 closing steps match the delivery type?
- [ ] Is the target file path explicit?
- [ ] Does DO NOT TOUCH list include rules-dimensions.md?
- [ ] Is the save-as filename explicitly stated with version increment?

If any check fails → fix before delivering. Never ask Janis to remind Claude Web.

---

## CHAT HANDOFF TEMPLATE

> Claude Web generates at end of every session.
> Janis saves to project knowledge. Never paste to repo.
> Single use — overwrite each session.

```markdown
# CHAT HANDOFF — [date] END OF SESSION
> Paste entire file to open new chat
> BEFORE SESSION BEGINS — Claude Web reads in order:
> Step 1: Load WORKFLOW_SKILL.md (repo → project knowledge → STOP if neither)
> Step 2: Read chat_rules.md
> Step 3: Read cc_chat_log.md last 3 entries — state summary. STOP if unreadable.
> Step 4: Read open items below — state "Memory installed"
> Only then: ask Janis "Today's goal?"

## ACTIVE MODEL
[Current model name and last committed version]

## SYSTEM STATUS
[Each active model: last version | QA status | export status]

## WHAT WAS DONE TODAY
[Specific files changed, prompts sent, QA results]

## OPEN ITEMS — PRIORITY ORDER
| Item | Status | Notes |
|---|---|---|
| [item] | [status] | [notes] |

## NEXT SESSION — START HERE
[Exact first action with file names]

## JANIS ACTION REQUIRED
[Only things Janis must do physically — push file, download, screenshot]

## FLAGS FOR NEXT SESSION
[Decisions pending, things to confirm with supplier, governance notes]
```

---

## SESSION CLOSING CHECKLIST

**cc closes every session with:**
1. Append cc_chat_log.md (newest at BOTTOM)
2. Archive prompt → /prompts/archive/ stamped ✅ COMPLETE
3. Update knowledge.map if new files created
4. Bump version on every file changed
5. Commit all → merge to main

**Claude Web closes every session with:**
1. Read cc_chat_log — verify delivery matches what was asked
2. Flag any gap to Janis before session ends
3. Write CHAT_HANDOFF.md → tell Janis to save to project knowledge

---

## PROBLEM SOLVING — KT FRAMEWORK

> **R-111: After ANY 2 failed fix attempts on the same symptom — STOP.**
> Do not write another line of fix code.
> Complete all KT phases below before any new prompt is written.

**Full KT skill file:** `SKILL_problem_solving_kt.md` in repo root.
Claude Web: if this file exists in repo, read it before forming any hypothesis.
If not in repo, ask Janis to upload it from the Satu project repo.

### KT Minimum (when full file unavailable)

**Phase 1 — What exactly is the symptom?** Raw output only. No interpretation.

**Phase 2 — IS / IS-NOT table:**
| Dimension | IS | IS NOT | Distinctive |
|---|---|---|---|
| WHAT | exact failing object | similar object that works | |
| WHERE | environment where it fails | environment where it doesn't | |
| WHEN | exact conditions | conditions where it does NOT fail | |
| EXTENT | frequency / severity | what is NOT affected | |

**Phase 3 — Hypotheses:** Generate ALL possible causes first.
For each: does it explain BOTH IS and IS-NOT? If not → eliminate immediately.
Never fix a hypothesis that cannot explain the IS-NOT.

**Phase 4 — Spy test:** Minimum invasive test to confirm hypothesis before fixing.
One change. One observation. Then fix.

**KT Rules (non-negotiable):**
- Never fix a symptom you cannot explain with IS/IS-NOT
- Never change two things at once
- Seek global knowledge (docs, library notes, rules files) before third attempt
- Document eliminated hypotheses — they prevent re-investigation next session

---

## WHAT CC CANNOT DO (SCAD constraint)

| Task | Workaround |
|---|---|
| Render .scad visually | Janis opens in OpenSCAD → screenshots to Claude Web |
| Confirm geometry looks correct | Janis describes or screenshots — Claude Web QAs |
| Export STL/DXF/PNG without OpenSCAD | cc writes export script or Janis exports manually |
| Edit files not in repo | Janis pushes local file to repo first |

---

## FILE STRUCTURE — THIS REPO

```
janis-product-design/
├── cc_rules.md                      ← cc reads every session
├── cc_chat_log.md                   ← cc writes, Claude Web reads last 3
├── chat_rules.md                    ← Claude Web rules (project knowledge master)
├── rules-dimensions.md              ← authoritative dimensions — never duplicated
├── rules-codes.md                   ← OpenSCAD coding rules — cc reads for SCAD tasks
├── SKILL_problem_solving_kt.md      ← KT framework — read when R-111 triggers
├── knowledge.map                    ← navigation guide, cc updates when files added
├── WORKFLOW_SKILL.md                ← this file (project knowledge master)
├── prompts/                         ← active cc prompt files
│   └── archive/                     ← completed prompts stamped ✅ COMPLETE
├── vending-machine/
│   └── VM-01-base/                  ← VM-01 .scad versions
├── pilates-reformer/
│   └── PR-01-base/                  ← PR-01 .scad versions (NOT STARTED)
├── exports/
│   └── for-supplier/                ← STL files
│   └── for-cnc/                     ← DXF files
└── renders/                         ← PNG screenshots per version
```

**Project knowledge (Claude Web only — never in repo):**
```
CHAT_HANDOFF.md      ← single use, overwrite each session
WORKFLOW_SKILL.md    ← this file (downloaded from repo when updated)
chat_rules.md        ← Claude Web non-negotiables
```
