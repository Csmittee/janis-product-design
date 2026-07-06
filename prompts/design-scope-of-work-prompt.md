# cc Prompt — Create design_scope_of_work_rule.md (VM-01 + PR-01)
# Date: 2026-07-06
# Standalone prompt — not related to the frame/pole geometry fixes.
# Two actions in this prompt: one file per project.

## 1. CC INTRO
git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → cc_chat_log.md (first 3 entries) →
CURRENT_STATE.md → PART_MANIFEST.md (VM-01) → rules-dimensions.md →
rules-codes.md → every archived prompt in /prompts/archive/ for BOTH
vending-machine/VM-01-base and pilates-reformer/PR-01-base.
State every file/folder read before writing anything.

## 2. CONTEXT

The repo has technical rules (rules-dimensions.md, rules-codes.md — the
"how"), process docs (cc_rules.md, WORKFLOW_SKILL.md — the "order of
operations"), and state trackers (CURRENT_STATE.md, cc_chat_log.md — "what
was done"). There is NO document that holds the owner's actual product
concept — the target dimensions, compartment layout, and functional/
appearance features the owner has stated over many sessions — in the
owner's own vocabulary, independent of implementation detail. That
information currently only exists scattered across old handoffs, old
chat turns, and old cc_chat_log entries, and gets lost between sessions.

This prompt creates ONE new document PER PROJECT that fixes that gap.

## 3. NEW FILES

### `vending-machine/design_scope_of_work_rule.md`
### `pilates-reformer/design_scope_of_work_rule.md`

For EACH file, extract information ONLY from what has already been
established in that project's own governance files, chat logs, and
archived prompts — do NOT invent, assume, or fill gaps with plausible-
sounding content. If a section has no confirmed source, write
`NOT YET SPECIFIED BY OWNER` for that line rather than guessing.

**Filter — this is the most important instruction in this prompt:**
Extract ONLY the owner-level product concept — what the FINAL PRODUCT
is, does, and looks like to the customer who touches/uses it. Do NOT
pull in implementation detail:
- YES: "overall envelope must not exceed W x D x H", "left compartment
  splits into storage (top) and exit (bottom)", "spring tray must be
  removable without interference", "lowest tray needs ≥100mm hand-access
  space behind it to lift off the notch"
- NO: specific mm values for frame_bar width, datum formulas, which
  variable a module references, manifold-fix details, toggle names —
  that's rules-dimensions.md/rules-codes.md territory, not this file.
If you're unsure whether something is "owner concept" or "implementation
detail," ask: would the owner (non-technical, describing this to a
manufacturer) say this sentence? If yes, it belongs here.

**Required structure for each file:**

```markdown
# Design Scope of Work — <Product Name> <version>
# Last updated: <date> — updated whenever a NEW feature/goal is confirmed
# by the owner in any session, same session it's confirmed, not deferred.

## Product Identity
<one line: what this product is, for whom, in owner's words>

## Envelope Targets
<overall W/D/H caps as the OWNER stated them, if ever stated as a target
—  distinguish clearly from CURRENT BUILT dimensions if the owner never
gave an explicit target cap. If only current built dimensions exist and
no owner target was ever separately stated, say so explicitly rather
than presenting current values as if they were the target.>

## Compartment / Section Map
<plain-language breakdown of the physical layout, in the owner's
vocabulary — e.g. compartment names, what's in each section>

## Functional Features
<numbered list, plain language, one feature per line, phrased as
customer/operator-facing behavior, not geometry>

## Appearance / Do-Not Features
<explicit "must look like X" / "must NOT do Y" statements the owner has
given, if any — mark NOT YET SPECIFIED if none found>

## Open Questions / Gaps Found During This Extraction
<anything you found evidence OF but not a clear/confirmed final answer
for — flag here rather than silently pick one interpretation>
```

## 4. TASKS

### TASK 1 — VM-01 extraction
Scan all VM-01 governance files, chat logs, and archived prompts. Build
`vending-machine/design_scope_of_work_rule.md` per the structure above.
Known seed facts to confirm/expand (do not treat this list as complete —
find more, and confirm these against real source rather than copying
them blind):
- Two main compartments: left (product/payout), right (control/display)
- Left compartment: storage (top) + exit (bottom)
- Right compartment: dashboard/ID-card/printer (bottom) + product display
  (top)
- Service door: right compartment, rear, for circuit/power access
- Feature: spring tray removable without interference
- Feature: lowest tray needs ≥100mm hand-access space behind it to lift
  off the notch
Confirm each of these against actual project history (don't just restate
what's given in this prompt) and find any others that exist in the repo's
history but aren't listed here.

### TASK 2 — PR-01 extraction
Same process, independently, for `pilates-reformer/PR-01-base`. Do not
assume it mirrors VM-01's structure — build this from PR-01's own
governance files and history only.

## 5. DO NOT TOUCH
- Any .scad file — this prompt is documentation only, zero geometry
  changes
- rules-dimensions.md, rules-codes.md, cc_rules.md, WORKFLOW_SKILL.md —
  do not merge their content into the new files, only reference them
- CURRENT_STATE.md, cc_chat_log.md — read-only sources for this task

## 6. QA VERIFICATION
- [ ] Both files created, one per project, at the paths specified above
- [ ] Every line traceable to an actual source in that project's history
      — no invented content
- [ ] Technical/implementation detail (dimensions formulas, variable
      names, toggle names, manifold fixes) excluded — owner-facing
      product language only
- [ ] Gaps marked `NOT YET SPECIFIED BY OWNER` rather than filled in
- [ ] Open Questions / Gaps section populated honestly for both files

## 7. MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP, under 10 lines, note
   both files created and a one-line summary of what was found vs. what's
   still a gap for each project
2. Archive this prompt → /prompts/archive/
3. Add both new files to knowledge.map
4. Note in cc_chat_log: going forward, ANY session that confirms a new
   feature/goal with the owner must include a task in that SAME prompt
   to update the relevant project's design_scope_of_work_rule.md — this
   file must never trail behind a confirmed decision.
5. Commit all → merge to main
