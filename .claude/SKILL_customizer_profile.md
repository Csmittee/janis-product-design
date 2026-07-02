# SKILL_customizer_profile.md
# Customizer-First Design Profiling — Janis Product Design
# Version: 1.0 — 2026-07-02
# Location: .claude/SKILL_customizer_profile.md
# Claude Web only — cc does NOT read this file.

## WHEN TO USE
Any geometry decision that is aesthetic/artistic rather than purely dimensional —
curve character, proportion "feel", stylistic form — where verbal description or
a single static render is unlikely to converge quickly. Purely dimensional or
structural fixes stay in the normal SKILL_local_render.md loop.

Signal: if Claude Web finds itself about to guess a shape parameter and render
again blind (a second time on the same shape), that's the trigger to switch to
this skill instead of a third blind guess.

## HOW TO USE
1. Identify which parameters are actually ambiguous (not just endpoints/sizes —
   include curve CHARACTER, e.g. an exponent or blend parameter that morphs the
   shape between distinct families: straight / convex bulge / concave converge).
2. Build a single .scad file with OpenSCAD Customizer annotations:
   `/* [Group Name] */` section headers, `variable = default; // [min:step:max]`
   range comments. Group related parameters together.
3. Hand the file to Janis. Instructions: OpenSCAD > Window menu > Customizer
   (enables panel) > drag sliders > F5 to preview live.
4. Janis reports back final parameter VALUES (numbers), not just a description
   or a screenshot alone.
5. Claude Web folds confirmed values into the next local-render verification
   pass (SKILL_local_render.md) before writing any cc prompt.

## CRITICAL RULES
- Always include a curve-character parameter (not just fixed start/end points)
  when the shape involves any curved profile — endpoint-only sliders cannot
  express concave-vs-convex, which is usually the actual ambiguity.
- Never write a cc geometry prompt from Customizer-tuned values until Janis has
  explicitly confirmed the final numbers in chat (a screenshot alone showing a
  slider position is not confirmation — state the values back and get a yes).
- This skill does not replace SKILL_local_render.md — it precedes it, for the
  subset of decisions that are aesthetic rather than dimensional.

## KNOWN FUTURE IMPROVEMENT — NOT YET IMPLEMENTED
Janis has requested a future version expose control points as freeform
draggable positions in a ZX or ZY plane (full-freedom point placement) rather
than fixed named sliders, to allow pulling a curve toward concave or convex in
one direct manipulation instead of tuning an abstract exponent. Flagged for a
future revision of this skill — not built yet, do not assume it exists.
