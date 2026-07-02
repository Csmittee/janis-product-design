# cc Prompt — Amend Customizer Skill: Mandatory Toggles, Customizer-Only Interaction
# Date: 2026-07-02
# Session goal: single governance amendment to .claude/SKILL_customizer_profile.md
# Zero .scad geometry change.

## 1. REQUIRED READS
- git fetch — confirm current main HEAD
- .claude/SKILL_customizer_profile.md (current version, merged via PR #68)

## 2. CONTEXT
This session Claude Web built two Customizer prototypes (bell collar, then a
full base showcase assembly) but only added visibility show/hide toggles and
a cutaway option to the SECOND one, after Janis had to ask for it manually.
Janis wants this to be a standing requirement, not something requested each
time: every future Customizer prototype must let Janis inspect and adjust
everything through the Customizer panel alone — the owner should never need
to open the code editor pane except to read the version header comment.

## 3. NEW FILES
None — amending the existing skill file only.

## 4. TASKS

### TASK 1 — Amend `.claude/SKILL_customizer_profile.md`

Bump version 1.0 → 1.1. In the `## CRITICAL RULES` section, add these two
new bullets (keep all existing bullets unchanged):

```
- Every Customizer prototype MUST include a `/* [Visibility] */` group with
  a boolean show/hide toggle for every major component in the assembly —
  never a single fixed render the owner cannot decompose.
- Where the prototype has any component nested inside another (e.g. a socket
  embedded in a leg), MUST include a cutaway/section boolean toggle so the
  internal fit is inspectable without hiding the outer part entirely.
- All parameters the owner might reasonably want to adjust MUST be exposed
  as Customizer sliders/values — never require the owner to open the code
  editor pane to change a value. The editor pane is for reading the version
  header comment only, never for making edits.
```

## 5. DO NOT TOUCH
- All .scad geometry files — zero change this prompt
- WORKFLOW_SKILL.md, chat_rules.md, rules-dimensions.md — unrelated to this
  amendment, do not touch
- Any other section of SKILL_customizer_profile.md besides the CRITICAL
  RULES bullets specified above

## 6. QA VERIFICATION
- [ ] SKILL_customizer_profile.md version bumped 1.0 → 1.1
- [ ] Exactly the three bullets above added to CRITICAL RULES, verbatim
- [ ] No other line in the file changed — confirm in cc_chat_log
- [ ] Zero .scad files touched — confirm explicitly

## 7. MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-02
3. knowledge.map — no update needed (no new files)
4. Bump version on changed file (done above)
5. Commit all → merge to main
