# cc Prompt — Fix Sensor Strip Placement + Drop-Zone Side Bracket Squeeze
# (check if this is the manifold cause)
# Date: 2026-07-07
# Source: vending-machine/VM-01-base/VM-01-base-v53.scad (current ACTIVE)

## 1. CC INTRO

Session continuity check: main has changed since the last merge — treat
as FRESH regardless of your own session state.
git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → knowledge.map → cc_chat_log.md (first 3
entries) → rules-dimensions.md → PART_MANIFEST.md (VM-01) →
vending-machine/VM-01-base/VM-01-base-v53.scad (current committed
source). State every file read before writing a single line.

Claude Web override: none.

## 2. CONTEXT

Two separate confirmed defects from Janis's visual QA, screenshots this
session:

1. **Sensor strip misplaced** — currently sitting on the OUTSIDE face.
   It should be on the INSIDE, facing the opposite side, in the exit
   zone. Clear, unambiguous fix.
2. **Drop-zone side bracket visibly squeezed by the door at close
   position** — confirmed by screenshot, real physical interference, not
   a rendering artifact. Separately: this bracket is ALREADY known
   (prior session) to be oversized toward the front, and in Z too — this
   was previously deprioritized as "no harm," but Janis now flags it may
   be involved in the door-close squeeze.

Janis's own elimination test already showed this bracket is STILL
PRESENT and the manifold error STILL SHOWS in the no-error configuration
test (side+top removed) — meaning it was not the deciding factor in that
specific test. That does NOT rule it out as a contributing cause once
properly fixed rather than just toggled off — report clearly whether
fixing it changes the manifold warning status, without assuming either
outcome ahead of time.

## 3. NEW FILES
None. Edits to existing VM-01-base file, new version v53→v54.

## 4. TASKS

### TASK 1 — Fix sensor strip placement

Locate `sensor_strip()`. Confirm it is currently positioned facing
outward/outside. Reposition to face inward, on the correct side for the
exit zone (opposite side from its current placement) — state the exact
before/after coordinates or orientation values changed.

### TASK 2 — Fix drop-zone side bracket: resize + resolve door-close squeeze

Locate the drop-zone side bracket module. Confirm the already-known
oversizing toward the front (and Z, per Janis's note) — resize to its
correct footprint, referencing whatever the correct/intended size should
be from `rules-dimensions.md` or the bracket's own stated design intent;
do not invent a new size without a clear reference.

After resizing, check the door-close position (`door_open_deg = 0`)
against the bracket's corrected geometry — confirm the squeeze/collision
Janis found is actually resolved by the resize, not just visually
smaller. State the real clearance result, not an assumption.

### TASK 3 — Check whether this fix affects the door-closed manifold warning

With Task 2's fix applied, re-check the manifold warning status at
`door_open_deg = 0`. Report plainly: still present, resolved, or changed
in character (e.g., still present but different cause now dominant). Do
not assume either outcome — this is a genuine open question, not a
confirmation exercise. If still present, this does NOT block committing
Tasks 1-2 (both are real, independently-justified fixes regardless of
the manifold outcome) — just report the manifold result honestly
alongside them.

## 5. DO NOT TOUCH

- Any other part of the shell, frame, or door geometry — this prompt is
  scoped to the sensor strip and the one drop-zone side bracket only
- The two v52/v53 exact-tangency findings (door-top-left-corner vs roof,
  hinge-pivot cylinder vs exterior wall) — those remain separately
  tracked, not addressed by this prompt
- Any PR-01 file

## 6. QA VERIFICATION

- [ ] Sensor strip repositioned to face inward/correct exit-zone side —
      before/after values stated
- [ ] Drop-zone side bracket resized to correct footprint — reference
      source for the correct size stated
- [ ] Door-close squeeze against the resized bracket re-checked — real
      clearance result stated, not assumed
- [ ] Manifold warning status re-checked at door_open_deg=0 after the fix
      — reported honestly (present/resolved/changed), not assumed
- [ ] No new manifold/undefined-variable warnings introduced elsewhere
- [ ] Version incremented v53 → v54, v53 untouched

## 7. MANDATORY CLOSING

1. Prepend `cc_chat_log.md` — newest entry at TOP, under 10 lines: sensor
   fix confirmation, bracket resize + squeeze-resolution result, manifold
   status after the fix
2. Archive this prompt → `/prompts/archive/` ✅ COMPLETE — 2026-07-07
3. Update `knowledge.map` only if needed
4. Bump `rules-dimensions.md` if the bracket's corrected size changes a
   stated dimension
5. Commit all → merge to main
