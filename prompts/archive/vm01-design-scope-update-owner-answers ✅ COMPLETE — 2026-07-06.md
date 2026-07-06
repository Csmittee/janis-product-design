# cc Prompt — Update design_scope_of_work_rule.md (VM-01) — Owner Answers, 2026-07-06 Round 2
# Date: 2026-07-06
# Documentation-only. No .scad files touched. Not related to any geometry
# work in flight (corner-frame-redesign, etc.) — safe to run any time,
# independently.
# Standing rule this prompt executes: any session confirming a new
# feature/goal with the owner updates design_scope_of_work_rule.md in
# that SAME prompt — this file must never trail behind a decision.

## 1. CC INTRO
git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → cc_chat_log.md (first 3 entries) →
vending-machine/design_scope_of_work_rule.md → pilates-reformer/design_scope_of_work_rule.md.
State every file read before writing anything.

## 2. CONTEXT

Janis reviewed the Open Questions section of vending-machine/design_scope_of_work_rule.md
(created 2026-07-06, partial extraction) and answered 5 of them directly.
One answer also clarified the document's own core purpose/filter — that
clarification applies to BOTH project scope files going forward, not just
VM-01's content.

**Owner's own words on the document's purpose (record this, it governs
all future edits to either scope file):** "The focus of this file contain
mainly feature that customer recognize or marketing headline that we need
to stick to. No one care if i spot or weld, no one care how long sensor i
use, thats more on the bom rule, dim rule, and other technical rule that i
have." — i.e. construction/assembly method, exact component specs (sensor
length, etc.), BOM, and dimensional/technical rules NEVER belong in this
file, even as "open questions." This file only holds what a customer would
recognize or what could appear as a marketing headline.

## 3. NEW FILES
None. Edits to two existing files.

## 4. TASKS

### TASK 1 — VM-01: Resolve "Envelope target drift" open question

Owner's answer: the envelope is a target only, not a mandatory/market-
driven restriction — there is no external regulatory sizing constraint
forcing a specific envelope. Sizing may be adjusted as needed.

Update the "Envelope Targets" section: remove the "gap"/unresolved framing.
State instead, owner-confirmed 2026-07-06: current dimensions (640×700×600mm)
and the original brief's numbers (620×800×410mm) are both understood as
target guidance, not a fixed external requirement — sizing is flexible
within reasonable bounds, not locked to either number. Remove the
corresponding line from Open Questions (it is now resolved, not open).

### TASK 2 — VM-01: Add new confirmed UX/Safety feature — door operation + lock

Owner's answer (new feature, not previously captured): the door's
operation must be safe and refined — no significant gaps, no hard
pull/push resistance, no abnormal noise during open/close. The door must
also have a lock, installed as a separate hardware component — this does
NOT exist in the current design yet, but is a required feature for the
final product.

Add to "Functional Features" (numbered, customer/operator-facing language):
- Door opens and closes smoothly and safely: no significant gaps, no
  hard/rough resistance on push or pull, no abnormal noise.
- Door includes a separately-installed lock mechanism (hardware, not yet
  designed) — required for the final product.

Do NOT mark this as resolving the still-open "shell trim/joggle collision"
technical item — that stays a separate, still-unresolved build defect
tracked in cc_chat_log/open items. This task only records the customer-
facing safety/smoothness standard the eventual fix must meet; state this
distinction explicitly so the two aren't conflated.

### TASK 3 — VM-01: Update Appearance section — corner-frame-redesign context

Owner's answer: the corner-frame-redesign (open geometry item, in
progress) exists in service of the appearance goal — a smooth, uniform,
modern look/theme — and also affects UX (matches the door-safety feature
above: a poorly integrated corner/frame could itself cause gaps or rough
operation).

Add one line to "Appearance / Do-Not Features": corner and frame
construction must present a smooth, uniform, modern appearance,
consistent with the "sleek, like a monitor/microwave" direction already
in this file — not just a technical fit, an appearance requirement.
Cross-reference (don't duplicate) the door safety feature from Task 2 as
the related UX angle.

### TASK 4 — VM-01: Correct sensor description

Owner's answer, corrects a wrong prior assumption: the sensor is NOT one
unit per spring lane. Current confirmed design: a facing PAIR (2 sensor
pieces) placed side-to-side (not front-to-back) at the drop zone,
together capturing the ENTIRE fall/drop space in one detection zone
(supplier's actual product works this way, discovered after the original
per-lane assumption). This impacts drop-zone depth. Currently a 120mm
version is in use.

Replace the old sensor line in "Functional Features" (and remove the
"Sensor strip's actual purpose" line from Open Questions — now answered)
with: two sensors, facing each other side-to-side across the drop zone,
together covering the full width of the fall/drop space in a single
detection zone (not per-spring-lane) — current implementation uses a
120mm-spec version. Note explicitly that this affects drop-zone depth as
a known dependency, without inventing a specific mm value beyond what's
stated here.

### TASK 5 — VM-01: Remove "assembly method" (weld vs. bolt) from Open Questions entirely

Owner's answer: how the machine is put together (weld vs. bolted/spot
construction) is not decided with the supplier yet, AND is explicitly
NOT in scope for this document — it's a technical/BOM-rule matter, not a
customer-facing or marketing feature.

Delete the "Stainless shell structure... welded reinforcement shell"
line from Open Questions entirely. Do not move it anywhere else in this
file, and do not create a new home for it in this file — if it needs
tracking at all, that belongs in a technical file (rules-codes.md /
rules-materials.md territory), not here. State in cc_chat_log that it was
removed per owner instruction, not silently dropped.

### TASK 6 — Both files: codify the document's core filter, permanently

Add a short, explicit line near the top of BOTH design_scope_of_work_rule.md
files (VM-01 and PR-01) — in the existing header comment block, not a new
section — stating the owner's filter in close-to-verbatim form: this
document holds ONLY features/facts a customer would recognize or that
could appear as a marketing headline. It NEVER holds construction/assembly
method, exact component specs (part lengths, sensor models, etc.), BOM, or
dimensional/technical rules — those live in rules-dimensions.md,
rules-codes.md, rules-materials.md, or BOM files, never here. This applies
to all future edits to either file, not just this session's changes.

## 5. DO NOT TOUCH

- Any `.scad` file — zero geometry change, this is documentation only
- `rules-dimensions.md`, `rules-codes.md`, `rules-materials.md`,
  `cc_rules.md`, `WORKFLOW_SKILL.md` — do not edit, reference only if
  needed
- The still-open, still-unresolved technical items (shell trim/joggle
  collision, corner-frame-redesign completion status) — Task 2/3 only add
  customer-facing standards these must eventually meet; do not mark the
  underlying technical bugs as resolved
- `CURRENT_STATE.md`, `cc_chat_log.md` — do not rewrite, only append per
  Mandatory Closing
- Any other section of either file not named in Tasks 1–6 above

## 6. QA VERIFICATION

- [ ] Envelope Targets section reframed as target-only, not restriction —
      owner-confirmed 2026-07-06, old "gap" framing removed
- [ ] New door safety + separate-lock feature added to Functional
      Features, explicitly NOT conflated with the still-open shell
      trim/joggle technical item
- [ ] Appearance section updated with corner/frame smooth-uniform-modern
      requirement, cross-referenced (not duplicated) with the door safety
      feature
- [ ] Sensor description corrected: facing pair, side-to-side, full
      drop-zone coverage, 120mm version in use — old per-lane assumption
      and old "purpose not specified" Open Question both removed
- [ ] Weld-vs-bolt assembly line fully removed from Open Questions, not
      relocated within this file, removal stated explicitly in cc_chat_log
- [ ] Core filter statement added near the top of BOTH
      design_scope_of_work_rule.md files (VM-01 and PR-01), close to the
      owner's own wording
- [ ] "Last updated" date bumped to 2026-07-06 on the VM-01 file (and on
      PR-01 if Task 6 counts as a substantive change — state which)
- [ ] Zero `.scad` files touched — confirm explicitly

## 7. MANDATORY CLOSING

1. Prepend `cc_chat_log.md` — newest entry at TOP, under 10 lines: which
   5 items were resolved/added/removed, and confirmation the core-filter
   line was added to both scope files
2. Archive this prompt → `/prompts/archive/` ✅ COMPLETE — 2026-07-06
3. Update `knowledge.map` only if the header-note change to PR-01's file
   warrants a one-line mention — otherwise skip
4. No dimension files changed — no version bump needed there
5. Commit all → merge to main
