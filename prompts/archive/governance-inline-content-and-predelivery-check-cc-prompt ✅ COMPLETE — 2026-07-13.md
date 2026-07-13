CC PROMPT — governance-inline-content-and-predelivery-check
=============================================================
Date: 2026-07-13
Documentation/process only. Zero .scad files touched. Run this AFTER
the BBQ v1-init + addendum work is complete and closed out — unrelated
to that build, does not need to interrupt it.

## 1. CC INTRO

Session continuity check: if main has changed since your last read in
this session (e.g. the BBQ addendum's MANDATORY CLOSING already merged),
treat as FRESH.
git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → knowledge.map → cc_chat_log.md (first 3
entries) → WORKFLOW_SKILL.md (full) → chat_rules.md (full) → RULES.md
(full, to confirm the current highest rule number — do not assume it,
confirm it live from the file).
State every file read before writing a single line.

Claude Web override: none.

## 2. CONTEXT

This session (bbq-offset-smoker-v1-init) exposed two real governance
gaps, both process failures on Claude Web's side, not cc's:

1. The original v1-init prompt told you to pull scope-file content and
   SKELETON_WORKSHEET content "from this session's chat log." You
   correctly could not do this — that content lives only in a Claude
   Web <-> Janis conversation, which you have no access to. Nothing in
   this repo currently states, as an explicit rule, that a cc prompt
   must never reference content only visible in that conversation.
   This needs to become a durable rule, not just a one-off fix, because
   it will recur on every future new-product kickoff unless it's
   structurally blocked.

2. WORKFLOW_SKILL.md already contains a "PRE-DELIVERY SELF-CHECK" that
   Claude Web is supposed to silently run before delivering every cc
   prompt — including a check for exactly this kind of gap ("Section 1
   has git fetch + all required reads?", "DO NOT TOUCH includes
   rules-dimensions.md?"). That checklist was not applied to the
   original v1-init prompt (it shipped with no CC INTRO, no DO NOT
   TOUCH, and no MANDATORY CLOSING at all). The checklist existing
   isn't enough on its own if nothing forces Claude Web to actually run
   it in a long session — this needs to be promoted to a numbered
   RULES.md lesson, the same pattern already used for R-111 (repeat-
   fix escalation) and the duplication-check rule, so it's a structural
   check rather than something relying on memory late in a session.

## 3. NEW FILES
None. Edits to `RULES.md`, `WORKFLOW_SKILL.md`, `chat_rules.md`.

## 4. TASKS

### TASK 1 — Add new rule: No Chat-Only Content References in cc Prompts

Confirm the current highest rule number in RULES.md (per CC INTRO — do
not assume it). Add as the next sequential rule:

```
**Rule R-0XX: No Chat-Only Content References in cc Prompts.**
A cc prompt must NEVER instruct cc to pull content from "this session's
chat log," "our discussion," "the confirmed conversation," or any
similar phrase referring to the Claude Web <-> Janis chat itself. cc has
no access to that conversation under any circumstance — only to the
repo (files, cc_chat_log.md, knowledge.map, prompt files). Any content
confirmed in chat that cc needs to act on (scope text, feature lists,
worksheet content, dimensions, etc.) MUST be transcribed directly into
the cc prompt's own text, in full, before the prompt is delivered to
Janis. If Claude Web does not have the exact confirmed wording on hand
when drafting a prompt, it must say so explicitly to Janis and ask for
it, rather than writing a placeholder for cc to fill in from a source
it cannot reach.
Example this rule would have caught: bbq-offset-smoker-v1-init-cc-prompt.md
told cc to pull Compartment Map / Functional Features / SKELETON_WORKSHEET
content "from this session's chat log" — cc correctly could not do this,
requiring a same-session addendum prompt to unblock Task 1.
```

### TASK 2 — Add new rule: Pre-Delivery Self-Check is Mandatory, Not Optional

Add as the next sequential rule after Task 1's:

```
**Rule R-0XX: Pre-Delivery Self-Check Runs on EVERY cc Prompt, No Exceptions.**
WORKFLOW_SKILL.md's PRE-DELIVERY SELF-CHECK (Build prompt is .md? Section
1 has git fetch + all required reads? Target file path explicit? DO NOT
TOUCH includes rules-dimensions.md? Save-as filename stated with version
increment?) must be run and satisfied before ANY cc prompt is delivered
to Janis — including prompts written late in a long session, prompts
written under time pressure, and prompts for brand-new product lines
with no prior template to copy from. A prompt missing CC INTRO, DO NOT
TOUCH, or MANDATORY CLOSING sections has failed this check and must not
be delivered until fixed — these are not optional sections that can be
skipped for a "simple" or "first" prompt.
Example this rule would have caught: bbq-offset-smoker-v1-init-cc-prompt.md
shipped with no CC INTRO (no git fetch, no governance file read list, no
continuation self-check), no DO NOT TOUCH section, and no MANDATORY
CLOSING section — all five Pre-Delivery Self-Check items would have
caught at least one of these gaps if actually run.
```

### TASK 3 — Add a NEW PRODUCT KICKOFF note to WORKFLOW_SKILL.md's
### PRE-DELIVERY SELF-CHECK section

Find the existing PRE-DELIVERY SELF-CHECK block in WORKFLOW_SKILL.md.
Add one line directly beneath it, in the surrounding explanatory text
(not inside the checklist itself):

"This checklist applies with EXTRA weight on the first cc prompt of any
new product line (per chat_rules.md's New Product Design Discipline) —
there is no prior version of that product's prompt to silently inherit
structure from, so every section must be built fresh and correctly,
including inlining all chat-confirmed content per R-0XX (chat-only
content rule, added 2026-07-13)."

Reference the actual rule number assigned in Task 1, not a placeholder.

### TASK 4 — Cross-reference in chat_rules.md

Find chat_rules.md's "Prompt Writing" section (contains "Never
hardcode values into cc prompts," "Every cc prompt must follow the
7-section template," etc.). Add one new bullet:

"Never write 'pull from chat/session/discussion' into a cc prompt — cc
cannot see the Claude Web <-> Janis conversation under any circumstance.
Transcribe confirmed content directly, every time. See RULES.md R-0XX."

Reference the actual rule number assigned in Task 1.

## 5. DO NOT TOUCH

- Any `.scad` file — zero geometry change
- Any `bbq-offset-smoker/` file — unrelated to this session, do not
  touch regardless of BBQ's current build status
- Existing rule numbers in RULES.md — this session only APPENDS, never
  renumbers or edits existing rule text
- `rules-dimensions.md`, `cc_rules.md` — unrelated

## 6. QA VERIFICATION

- [ ] Current highest RULES.md rule number confirmed live before adding
      (not assumed) — state the number found
- [ ] Both new rules added with correct sequential numbering, each with
      its own concrete example as drafted above
- [ ] WORKFLOW_SKILL.md's PRE-DELIVERY SELF-CHECK section has the new
      explanatory line, correct rule number referenced (not a
      placeholder)
- [ ] chat_rules.md's Prompt Writing section has the new bullet, correct
      rule number referenced (not a placeholder)
- [ ] No existing rule content removed, reworded, or renumbered
- [ ] No `.scad` file touched — confirm explicitly
- [ ] No `bbq-offset-smoker/` file touched — confirm explicitly
- [ ] Version bumped on every file actually changed (RULES.md,
      WORKFLOW_SKILL.md, chat_rules.md), per the Document Versioning
      Rule (X.Y — detail/rule addition, not new structure)

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at TOP, under 10 lines: state
   both new rule numbers and one-line summary of each, confirm zero
   .scad and zero bbq-offset-smoker/ files touched, confirm version
   bumps on the three edited files
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-13
3. Update knowledge.map only if a version/status line needs it
4. Commit all → merge to main
