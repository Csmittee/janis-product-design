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
  Prompt 1: Isolation test (rapid-fire)
  Prompt 2: Fix
  Prompt 3: Confirm F6 clean — PASS or FAIL
