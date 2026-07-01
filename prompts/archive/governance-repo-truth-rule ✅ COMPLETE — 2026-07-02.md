## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order, state every file read before writing a single line:
1. cc_rules.md
2. knowledge.map
3. cc_chat_log.md (first 3 entries — newest at top)
4. WORKFLOW_SKILL.md (repo root copy)
5. chat_rules.md (repo root copy)

## 2. CONTEXT

Janis identified a governance gap this session: Project Knowledge is a
SNAPSHOT synced at Janis's discretion (session start, or manually by
process) — it is never a live view of the repo. Claude Web has no
mechanism to independently confirm current repo state. This surfaced
concretely when Claude Web could not determine whether PR #66 had been
merged to `main`, and had (incorrectly, per the existing "Claude Web NEVER
reads directly from repo" rule in knowledge.map) attempted to resolve that
uncertainty by fetching GitHub directly rather than asking Janis.

The fix is not "don't fetch" — it's naming Janis as the only source of
truth for current status, explicitly, as a standing rule Claude Web reads
every session, not something it has to be reminded of after the fact.

## 3. NEW FILES

NONE.

## 4. TASKS

### TASK 1 — Add repo-truth rule to `WORKFLOW_SKILL.md`

Add a new short section immediately after the existing "JANIS SESSION
PREP" section:

```
---

## REPO TRUTH — WHO CONFIRMS CURRENT STATE

Project Knowledge is a SNAPSHOT, synced at Janis's discretion — never a
live view of the repo. Claude Web has no independent way to confirm
current repo state (merged vs. open PRs, latest commit, file content) and
must not assume a fetch or a Project Knowledge search reflects "right now."

Rule: at any point in a session where Claude Web needs to know the TRUE
CURRENT status of the repo — whether a PR is merged, whether a file
matches what's committed, whether main reflects a given fix — Claude Web
asks Janis to confirm or re-sync. This is not a fallback for when other
methods fail; it is the only correct method every time.
```

Bump `WORKFLOW_SKILL.md` version per its own header convention, changes
line: "Added REPO TRUTH section — Janis is the only source of current
repo state, Claude Web must ask rather than assume."

### TASK 2 — Reinforce in `chat_rules.md`

Under the existing `## Reading & Diagnosis` section, the current bullet:
```
- Read cc_chat_log at every session open — if unreadable or absent, tell Janis sync is broken before proceeding. Do not proceed.
```
Add a new bullet immediately after it:
```
- Project Knowledge is a snapshot, not live repo access. Never treat a
  fetch, a search result, or an assumption as current truth — ask Janis
  to confirm or sync whenever current repo/PR/merge status actually
  matters to the task at hand.
```

Bump `chat_rules.md` version per its own header convention.

⚑ FLAG in cc_chat_log: Janis must re-upload both `WORKFLOW_SKILL.md` and
`chat_rules.md` to Project Knowledge after this commit — repo and Project
Knowledge must match, this is a manual sync step on Janis's side.

## 5. DO NOT TOUCH

- Any `.scad` file — documentation/governance only, zero geometry changes
- `rules-dimensions.md`, `rules-pr.md`, `.claude/rules-codes.md`
- `cc_chat_log.md` — prepend only, per standard rule
- All files not explicitly named in TASKS 1-2
- PR #66 — merge status/timing is Janis's call, not part of this prompt

## 6. QA VERIFICATION

- [ ] `WORKFLOW_SKILL.md` — new REPO TRUTH section present, version bumped
- [ ] `chat_rules.md` — new bullet present under Reading & Diagnosis, version bumped
- [ ] No `.scad` file touched — confirm explicitly in cc_chat_log
- [ ] Flag for Janis to re-upload both files to Project Knowledge stated
      clearly in cc_chat_log, not buried in prose

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at TOP. Must include the Janis
   re-upload flag explicitly.
2. Archive this prompt → /prompts/archive/governance-repo-truth-rule ✅ COMPLETE — 2026-07-02
3. Update knowledge.map if needed (version bump only, no new files)
4. Bump version on every file changed (WORKFLOW_SKILL.md, chat_rules.md,
   cc_chat_log.md)
5. Commit all → merge to main

Confirm what changed after commit.
