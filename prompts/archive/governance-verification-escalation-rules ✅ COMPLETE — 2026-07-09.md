# cc Prompt — Governance Update: Verification Discipline, Duplication
# Checks, Repeat-Touch Escalation, Direct-CC Escalation Protocol
# Date: 2026-07-09
# Session goal: DOCS ONLY. Zero .scad files touched. This converts a
# retrospective (57 versions to close the VM-01 door/manifold saga) into
# standing rules so the SAME classes of wasted cycles don't recur on the
# next project. Modeled on the prior governance-only session
# (governance-cc-intro-knowledge-map-rules-refresh, 2026-07-07).

## 1. CC INTRO

git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → knowledge.map → cc_chat_log.md (first 3
entries) → chat_rules.md → WORKFLOW_SKILL.md → RULES.md (or
.claude/rules-codes.md — confirm actual current filename/location,
do not assume) → rules-dimensions.md (skim, for examples referenced
below). State every file read, and the CURRENT version number of each
file about to be edited — do not assume version numbers, confirm from
the live file.

Claude Web override: none.

## 2. CONTEXT

Retrospective finding (Claude Web + Janis, 2026-07-09): the VM-01
door/manifold/acrylic saga took 57 versions across many sessions to
fully resolve. Root causes identified, in order of impact:

1. **Duplication drift** — the same value/logic independently re-derived
   in 2+ places, only one copy fixed at a time, causing the SAME bug
   class to resurface twice (v55 door-floor datum: 4 duplicated copies;
   v56 corner-cutout: 2 duplicated copies in `outer_shell()` vs.
   `outer_shell_debug()`).
2. **Unverified findings treated as fact** — arithmetic estimates
   (v52's two "exact tangency" findings) were written into
   rules-dimensions.md and treated as closed for 3 versions before a
   real CGAL sweep found both wrong. This repeated with cc's acrylic
   "recess theory" (stated confidently, wrong, twice).
3. **Late fundamental questioning** — the hinge-pivot rod's basic design
   (a continuous barrel instead of real hinge hardware) went unquestioned
   for 7 versions (v50→v57) despite being touched/re-investigated
   multiple times, even though asking "is this how real hardware works"
   at v57 resolved a recurring collision-ambiguity problem in one step.
4. **Coordination overhead between direct-cc-chat and prompt-based
   sessions** — running both channels on the same file without an
   explicit sync point caused real confusion and repeated re-diagnosis
   (e.g. this project's own PR #100/#101 sync-lag incidents).

This prompt codifies four new standing rules addressing each of these,
plus one process clarification on escalation to direct-cc-chat. These
apply to ALL current and future projects in this repo, not VM-01-specific.

## 3. NEW FILES

None. Edits to `chat_rules.md`, `WORKFLOW_SKILL.md`, and
`RULES.md`/`.claude/rules-codes.md` (confirm actual filename) in place.

## 4. TASKS

### TASK 1 — Add Verification Discipline rule

Add to the rules file (RULES.md or rules-codes.md, whichever is
authoritative — confirm from CC INTRO read) as the next numbered rule
(confirm current highest rule number, do not assume it's R-007):

```
**Rule R-0XX: Verification Discipline — no "CONFIRMED"/"RULED OUT" without an attached real check.**
A finding may only be written into rules-dimensions.md using the words
"CONFIRMED", "RULED OUT", "FIXED", or "RESOLVED" if a real geometry
check (CGAL intersection(), a real render, an actual measurement) was
performed AND the method is stated alongside the finding (e.g. "9-angle
CGAL sweep", "single-angle arithmetic estimate").
Arithmetic-only or single-angle findings MUST be labeled explicitly as
such — e.g. "UNVERIFIED — arithmetic only, full sweep pending" or
"SINGLE-ANGLE ONLY — not yet swept across door_open_deg range" — and
CANNOT be treated as closed. Any future session that reads an
UNVERIFIED finding and relies on it for a decision must either perform
the real check itself first, or explicitly flag the reliance as
provisional in its own cc_chat_log entry.
Example this rule would have caught: v52's two "exact tangency"
findings were arithmetic-only, written as fact, and stood unchallenged
for 3 versions before v55's real 9-angle sweep found both wrong.
```

### TASK 2 — Add Duplication Check rule, wire into CC INTRO template

Add as the next rule number:

```
**Rule R-0XX: Duplication Check — before fixing, search for copies.**
Before writing a fix to any module/value, search the ENTIRE active file
(and any other files in the same part's module group) for other places
the same logic/value/constant may be independently re-derived. If any
duplicate is found, the fix must be applied to ALL copies in the same
pass — not just the one that triggered the bug report — and
cc_chat_log.md must state explicitly how many copies were found and
fixed. A fix that only addresses one copy of a duplicated pattern is
INCOMPLETE, not done.
Example this rule would have caught: door_bot_z was independently
re-derived in 4 places (v55); outer_shell()/outer_shell_debug() each
maintained their own copy of the same corner cutout (v56) — both bugs
recurred specifically because only one copy got fixed at a time.
```

Also edit the CC PROMPT TEMPLATE / CC INTRO section in
`WORKFLOW_SKILL.md` (find the existing "state every file read before
writing a single line" instruction) to add a mandatory line:
"Before writing any fix, confirm whether the value/logic being changed
exists in more than one place in the file — state this check explicitly
in cc_chat_log, per Rule R-0XX, even if the answer is 'no duplicates
found'."

### TASK 3 — Add Repeat-Touch Escalation rule

Add as the next rule number:

```
**Rule R-0XX: Repeat-Touch Escalation — 3 strikes means question the design, not just patch it.**
If the same module/feature is the subject of 3 or more separate fix
prompts without full resolution (tracked informally via cc_chat_log
entry titles/scope), the NEXT prompt targeting that same
module/feature MUST include an explicit "is this the right underlying
design" question as its own task — not just another incremental patch
attempt. This applies even if each individual prompt's specific bug was
real and worth fixing at the time; the escalation is about stepping back
to question the approach, not about any single fix being wrong.
Example this rule would have caught: the hinge-pivot rod was
investigated/touched across v50, v52, v53, v55, v56 (5+ times) before
its fundamental design (continuous rod vs. real hinge hardware) was
questioned at v57 — that question resolved the recurring ambiguity in
one step.
```

### TASK 4 — Add Direct-CC Escalation Protocol (formalize, don't just document)

Add as the next rule number in the rules file, AND add a corresponding
section to `chat_rules.md` (find where session-open sequence / Claude
Web's own conduct is documented):

```
**Rule R-0XX: Direct-CC Escalation Protocol.**
The default flow is: Janis describes an issue to Claude Web → Claude
Web drafts a structured prompt (CC INTRO/CONTEXT/TASKS/DO NOT
TOUCH/QA VERIFICATION/MANDATORY CLOSING) → Janis sends it to cc.

Janis MAY escalate directly to cc (bypassing prompt drafting) when the
prompt-based loop is not making progress — e.g. a prompt was built on
insufficient context, cc's response reveals the actual problem needs
faster back-and-forth than the prompt format allows, or repeated
prompt rounds aren't converging. This is a LEGITIMATE, EXPECTED escape
valve, not a process failure — it exists because real-time
back-and-forth is sometimes genuinely faster than structured prompts,
especially for open-ended diagnosis.

When this happens, TWO things are required to avoid the coordination
confusion documented in this rule's origin retrospective:
1. Direct-cc-chat sessions must STILL end with the same MANDATORY
   CLOSING any prompt-based session requires — cc_chat_log.md entry,
   prompt archived if one existed, version bump, commit, merge to main.
   No informal-mode exception.
2. Before the NEXT Claude Web session resumes work on the same file,
   Janis (or Claude Web, via project_knowledge_search/web_fetch on the
   real PR) must confirm the direct-cc-chat session's actual outcome
   from the real repo/cc_chat_log — Claude Web must NEVER assume what
   happened in a direct-cc-chat session from Janis's paraphrase alone
   when the real source (PR diff, cc_chat_log entry) is checkable.
```

## 5. DO NOT TOUCH

- Any `.scad` file — this is a docs-only session
- `rules-dimensions.md` content itself — read only, this session adds
  process rules to the RULES file, not dimension findings
- Existing rule numbers R-001 through whatever is currently the highest
  — this session only APPENDS new rules, never renumbers or edits
  existing ones
- `PART_MANIFEST.md`, `design_scope_of_work_rule.md` — out of scope

## 6. QA VERIFICATION

- [ ] Current highest rule number confirmed from the live file before
      adding new ones (not assumed)
- [ ] All 4 new rules added with correct sequential numbering
- [ ] Each new rule includes its own concrete example (as drafted above,
      verify against actual project history, correct if any detail is
      imprecise)
- [ ] WORKFLOW_SKILL.md's CC INTRO template updated with the duplication-
      check instruction (Task 2)
- [ ] chat_rules.md updated with the Direct-CC Escalation Protocol
      section (Task 4)
- [ ] No existing rule content removed or renumbered
- [ ] No `.scad` file touched — confirm explicitly
- [ ] Version bumped on every file actually changed

## 7. MANDATORY CLOSING

1. Prepend `cc_chat_log.md` — newest entry at TOP, under 10 lines: list
   all 4 new rules added by number, confirm zero .scad touched
2. Archive this prompt → `/prompts/archive/`
3. Update `knowledge.map` only if any file's version/status line needs
   updating
4. Commit all → merge to main
