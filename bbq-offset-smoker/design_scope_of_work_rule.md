# BBQ Offset Smoker — Design Scope of Work
> Version 1.0 — 2026-07-13
> Changes: New file, first version. Product Identity + Envelope sections
> copied verbatim from prompts/bbq-offset-smoker-v1-init-cc-prompt.md
> (marked FINAL by that prompt). Compartment Map / Functional Features /
> Appearance / Made-Buy-Hire sections are a DRAFT — see the flag below.
> Previous: N/A

Customer-facing scope only — owner vocabulary, features, envelope,
appearance. Technical/construction detail belongs in rules-bbq-fab.md, not
here (same filter VM-01/PR-01's own scope files use).

---

## ⚠️ GOVERNANCE FLAG — READ BEFORE TREATING THIS FILE AS FINAL

The source prompt (`prompts/bbq-offset-smoker-v1-init-cc-prompt.md`) states
the Product Identity and Envelope sections below are "finalized... use
verbatim from this session's confirmed scope," and instructs the
Compartment Map / Functional Features / Appearance-DoNot / Made-Buy-Hire
lists to be pulled "from the two confirmed scope drafts" of "this
session's chat log."

**cc has no access to that chat log.** It exists only in the Claude Web
session that produced the prompt — not in this repo, not in
`cc_chat_log.md`, not in any file cc can read. Per cc_rules.md ("If the
prompt doesn't show evidence of this, flag it in cc_chat_log rather than
silently inventing datums") and the general rule that cc never makes
design decisions, this file is split into two tiers:

- **Product Identity / Envelope** — copied verbatim from the prompt itself
  (the prompt states this content directly, not by reference to an
  external log) — this tier is FINAL as stated.
- **Compartment Map / Functional Features / Appearance / Made-Buy-Hire**
  — the prompt gives NO literal content for these, only a pointer to an
  unavailable log. What appears below is a DRAFT cc reconstructed from
  Task 2/3's own technical module descriptions (the only real source
  available) — **NOT sourced from Janis's actual confirmed scope
  conversation.** This DRAFT requires Janis's explicit review before it
  can be treated as confirmed, same as the file's own governance
  convention requires for any new product's scope file.

---

## Product Identity
Mobile wheeled octagonal-profile offset BBQ smoker, hobbyist-commercial
grade, 2-3mm steel. V1 = pass-through smoke flow.

## Envelope
Cook chamber 915mm L x 610mm flat-to-flat cross-section.
Grate height 700mm from ground (MASTER CONTROL VALUE, fixed).
Firebox 457x457x457mm cube, floor 200mm below chamber floor
[ASSUMPTION - Janis to confirm before final merge].

---

## Compartment Map — DRAFT, reconstruct from Task 2/3, see flag above
- Cook chamber — the main smoking compartment, full 915mm length, grate
  at fixed 700mm height, lid-accessible along its top.
- Firebox — separate 457mm cube compartment at the rear, connected to the
  cook chamber only via the pass-through opening (no direct food/heat
  path other than that opening).
- Ash/ember compartment — beneath the firebox's own fire grate, accessed
  via the slide-out ash tray through the firebox door.
- Prep surface — 2 fold-up shelves at the front of the chamber, stowed
  vertical for transport, deployed horizontal for use.

## Functional Features — DRAFT, see flag above
1. Pass-through smoke flow: firebox → chamber (full length) → chimney,
   with an internal drop-tube pulling smoke down to grate height before
   it recirculates across the food, not a short-circuit top vent.
2. Hinged main lid, counterbalanced for a slight self-closing bias
   (~85-90% balance, not full — per this session's torque calc, cited in
   rules-bbq-fab.md), full-width lift handle.
3. Hinged firebox door with an air-intake damper for fire control.
4. Slide-out ash tray for cleanout without disturbing the fire grate.
5. Foldable chimney for lower transport height/clearance.
6. Mobile: 2 fixed + 2 swivel casters, tow handle at the chimney end.
7. Fold-up prep shelves, left and right, stowed for transport.
8. Floor drain valves (x2) for grease/moisture cleanout.

## Appearance — DRAFT, see flag above
- Octagonal-profile (chamfered-coffin) chamber cross-section, not a plain
  round barrel — a deliberate silhouette choice, not just structural.
- Raw/brushed steel finish (2-3mm), hobbyist-commercial reference grade —
  not a mirror-polish showpiece finish.
- Chimney: "fat over long" proportion (per Janis, this session) — height
  capped at 2.5m from ground regardless of chimney volume.

## Made / Buy / Hire — DRAFT, see flag above (owner-vocabulary framing;
full technical Made-vs-Buy split lives in rules-bbq-fab.md, not here)
- MADE (fabricated in-house): chamber shell, lid, firebox, doors, grill
  grate segments, chimney + drop tube, ash tray, drain bosses.
- BUY (off-shelf hardware): wheels/casters, axle, tow handle, toggle
  clamp latches, dome thermometer, drain valve hardware, spiral-wire
  firebox handle.
