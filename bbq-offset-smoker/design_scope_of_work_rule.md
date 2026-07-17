# BBQ Offset Smoker — Design Scope of Work
> Version 1.2 — 2026-07-17
> Changes: bbq-understructure-v3-wheel-height-tray-handle. Envelope
> section's grate-height control value CHANGED: 700mm (MASTER CONTROL
> VALUE) SUPERSEDED — Janis re-verified ergonomic reach height this
> session, new locked target is 900-1000mm from true ground. Real chosen
> value 928.665mm (GRATE_Z + new understructure-level GROUND_OFFSET=150mm
> -- see BBQ-understructure-v3.scad's own header for the full mechanism:
> chamber_floor_z/GRATE_Z themselves are unchanged, BBQ-chambers-v11.scad
> is completely locked -- the lift happens entirely at the understructure
> level, true ground moves relative to the fixed chamber frame). Detail
> correction to an already-FINAL section (per this file's own two-tier
> confidence system below) -- Product Identity/Envelope numbers were
> "copied verbatim from the original prompt" and FINAL as of v1.0/1.1; this
> specific figure is now Janis-superseded, explicitly, not a silent
> downgrade of the section's overall FINAL status.
> Previous: 1.1 — 2026-07-13
> Changes: bbq-offset-smoker-v1-init-ADDENDUM. Compartment Map / Functional
> Features / Appearance / Made-Buy-Hire sections REPLACED — v1.0's content
> was cc's own reconstruction from Task 2/3's technical description (no
> other source was available at the time); this version uses the content
> Claude Web supplied directly in the addendum prompt, reconstructed from
> the confirmed session handoff. Still NOT re-confirmed verbatim by Janis
> in this exact wording — see the flag below, unchanged confidence tier.
> Previous: 1.0 — 2026-07-13

Customer-facing scope only — owner vocabulary, features, envelope,
appearance. Technical/construction detail belongs in rules-bbq-fab.md, not
here (same filter VM-01/PR-01's own scope files use).

---

## ⚠️ GOVERNANCE FLAG — READ BEFORE TREATING THIS FILE AS FINAL

The original prompt (`prompts/bbq-offset-smoker-v1-init-cc-prompt.md`)
instructed the Compartment Map / Functional Features / Appearance-DoNot /
Made-Buy-Hire lists to be pulled "from the two confirmed scope drafts" of
"this session's chat log" — a Claude Web <-> Janis conversation cc has no
access to. cc correctly declined to invent this content (v1.0 of this
file used a DRAFT reconstructed from Task 2/3's technical description
instead, flagged as such).

The `bbq-offset-smoker-v1-init-ADDENDUM-cc-prompt.md` follow-up supplied
real content for these sections directly in the prompt text (Section 3a),
which is what appears below as of v1.1. Per that addendum's own stated
confidence level: this content is "reconstructed by Claude Web from the
confirmed session handoff... has NOT been re-confirmed verbatim by Janis
in this exact wording." Two tiers, same as v1.0:

- **Product Identity / Envelope** — copied verbatim from the original
  prompt itself — FINAL as stated.
- **Compartment Map / Functional Features / Appearance / Made-Buy-Hire**
  — supplied by the addendum, materially correct per Claude Web but NOT
  yet Janis-reconfirmed in this exact wording. Still requires Janis's
  explicit review before being treated as locked — not silently upgraded
  to FINAL just because it's now inline in a committed file.

Also flagged per the addendum's own DO NOT TOUCH instruction: this
addendum states "rules-dimensions.md — VM-specific, not applicable to
BBQ." That file already carries a "BBQ Offset Smoker Base" section, added
in the original v1-init session (merged, PR #115) before this addendum
existed — a real conflict between the addendum's stated scope and the
already-merged state of the repo, not resolved here (out of this
addendum's own DO NOT TOUCH scope) — left for Janis/Claude Web to decide.

---

## Product Identity
Mobile wheeled octagonal-profile offset BBQ smoker, hobbyist-commercial
grade, 2-3mm steel. V1 = pass-through smoke flow.

## Envelope
Cook chamber 915mm L x 610mm flat-to-flat cross-section.
Grate height 900-1000mm from true ground (SUPERSEDES the original 700mm
MASTER CONTROL VALUE — Janis re-verified ergonomic reach height
2026-07-17, real value 928.665mm — see BBQ-understructure-v3.scad).
Firebox 457x457x457mm cube, floor 200mm below chamber floor
[ASSUMPTION - Janis to confirm before final merge].

---

## Compartment Map — per addendum Section 3a, materially correct but NOT
yet Janis-reconfirmed in this exact wording (see flag above)
- Cook Chamber — main octagonal-profile smoking chamber, pass-through
  smoke flow (V1)
- Firebox — offset, attached at chamber rear (world X, corrected from the
  original prompt's own Y notation — see BBQ-chambers-v1.scad header),
  floor lower than chamber floor (classic offset-smoker draft technique)
- Chimney — front shoulder mount, foldable, internal drop-tube down to
  grate level
- Understructure — corner-tube wheeled frame, 2 fixed + 2 swivel
  casters, tow handle at chimney end
- Prep Shelves x2 — fold-up (vertical stowed / horizontal deployed),
  left + right, front of chamber

## Functional Features — per addendum Section 3a, see flag above
1. Full-length counterbalanced lid — lever + weight, target ~85-90%
   self-balance (slight self-closing bias, not full balance)
2. Full-width lift handle rail, 150mm standoff, 2+ mounting posts
3. 2+ floor drain valves, spaced front-third / back-third of chamber
4. Firebox door — lockable, off-shelf spiral-wire heat-safe handle
5. Laser-cut steel grill grate, 3-4 removable segments on internal
   support ledge
6. 2 fold-up prep shelves (vertical stowed / horizontal deployed)
7. Foldable chimney with internal drop-tube (smoke circulates low
   across food, not a short-circuit top vent)
8. Adjustable firebox air-intake damper
9. Slide-out ash tray below the fire grate
10. Toggle-clamp lid latches x2+
11. Dome thermometer port (placeholder)
12. Hybrid fuel — wood or charcoal

## Appearance / Do-Not — per addendum Section 3a, see flag above
- Reference plan images (corner-tube frame, toggle-clamp lid) are
  construction-method inspiration only — do NOT copy their dimensions
- V1 is pass-through smoke flow only — reverse-flow is explicitly OUT
  OF SCOPE for this version, do not add it

## Made / Buy / Hire — per addendum Section 3a, see flag above
- Made (laser-cut / welded in-house): grill grate segments, drain valve
  bosses, chamber/firebox shells, understructure frame
- Buy (off-shelf): wheels, axle, wheel-axle joints, toggle clamp
  latches, dome thermometer, spiral-wire firebox handle, drain valves
- Hire / supplier-verify: bend allowances for formed panels (doors,
  end-caps)
