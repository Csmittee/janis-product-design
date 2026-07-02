# cc Prompt — Customizer-First Design Skill + Confirmed Bell Collar Profile
# Date: 2026-07-02
# Session goal: institutionalize Customizer-based workflow for aesthetic/artistic
# geometry decisions; capture Janis-confirmed bell-collar concept values.
# Zero .scad geometry change — documentation/governance + dimension-record only.

## 1. REQUIRED READS (before any change)
- git fetch — confirm current main HEAD
- WORKFLOW_SKILL.md (current version)
- chat_rules.md (current version)
- rules-dimensions.md (current version, PR-01 sections)
- knowledge.map (current version)

## 2. CONTEXT
Claude Web and Janis worked through a bell-shaped copper/brass pole-holder collar
this session — an aesthetic/artistic decision (curve character, proportion "feel")
that was very hard to converge on through verbal description and static screenshots.
Claude Web built an OpenSCAD Customizer-enabled prototype exposing the collar
profile as sliders, including a `curve_power` exponent controlling convex-bulge vs
concave-converge curve character. Janis tuned it live in OpenSCAD's own Customizer
panel (Window > Customizer, drag sliders, F5) and reported back final numeric
values directly — much faster than the screenshot round-trip loop. Janis wants
this pattern to become a standing skill for any future complex/artistic geometry
decision (as distinct from purely dimensional/structural fixes, which stay in the
existing local-render loop per SKILL_local_render.md).

## 3. NEW FILES
- .claude/SKILL_customizer_profile.md — new skill, Claude-Web-only (cc does not
  read this file, same convention as SKILL_manifold_triage.md)

## 4. TASKS

### TASK 1 — Create `.claude/SKILL_customizer_profile.md`

```
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
```

### TASK 2 — Update `WORKFLOW_SKILL.md`

Bump version (current → next minor). Add new row to the existing
`## TRIGGER → ACTION → VALIDATOR` table:

```
| Aesthetic/artistic geometry ambiguous in words (curve character, stylistic proportion) | Claude Web builds OpenSCAD Customizer-enabled prototype (.claude/SKILL_customizer_profile.md), Janis tunes sliders live, reports final values | Janis explicitly confirms final parameter values in chat before any cc prompt is written |
```

### TASK 3 — Update `chat_rules.md`

Bump version. Add bullet under the existing "Claude Web Rendering Capability"
section:

```
- For aesthetic/artistic geometry decisions (curve character, stylistic
  proportion — not purely dimensional), build a Customizer-enabled prototype
  per .claude/SKILL_customizer_profile.md instead of iterating on static
  screenshots.
```

### TASK 4 — Update `rules-dimensions.md`

Under the existing "## PR-01 Base — 4-Part Split Architecture" area, add a new
subsection (do not delete anything, follow the file's existing
superseded-value convention):

```
## PR-01 Base — Pole Holder, Bell Collar (CONCEPT CONFIRMED via Customizer, 2026-07-02)

Replaces the external split-clamp collar below (superseded, kept for history)
with a bell-shaped copper/brass holder — pole pushes directly into an embedded
leg socket, no external bracket. Values confirmed live by Janis via OpenSCAD
Customizer. Proportion/appearance only — NOT load-tested, not production-ready.

| Parameter | Value | Note |
|---|---|---|
| r_base | 51mm | foot ring radius, flush at wood surface |
| r_top | 29mm | neck radius, meets washer/cap |
| foot_h | 8mm | straight vertical foot ring height |
| dome_h | 35mm | curved dome height |
| dome_steps | 16 | loft resolution |
| curve_power | 1.4 | profile exponent: 1=straight cone, >1=convex bulge, <1=concave converge |
| cap_h | 10mm | knurled brass cap height |
| cap_knurl_count | 45 | knurl notch count |
| washer_h | 5mm | copper washer reveal height |
| washer_overhang | 1mm | copper washer reveal radial overhang beyond dome top |
| pole_od | 40mm | LOCKED, unchanged from existing spec |

Still open, not yet decided:
- Socket-to-wood depth/architecture — Janis directed a >300mm pass-through
  sleeve through a fully drilled leg channel (replaces shallow bonded pocket),
  not yet reconciled with this collar concept.
- Internal lock mechanism — hybrid thread+cam single bezel vs. 3-part reference
  system (separate socket thread + holder bayonet + compression cap/washer).
  Not decided.
```

Then locate the existing split-clamp collar dimension block (collar_wrap_h,
collar_wall_t, collar_bolt_d, etc. — the "Stage 2 = precision fit" split-clamp
sleeve) and prepend a note above it:

```
### SUPERSEDED — DO NOT USE (kept for history only)
Replaced 2026-07-02 by the Bell Collar concept above. External split-clamp
bracket approach abandoned in favor of pole pushing directly into an embedded
leg socket.
```

### TASK 5 — Update `knowledge.map`

Add row:
```
| .claude/SKILL_customizer_profile.md | .claude/ | Claude Web only — Customizer-first workflow for aesthetic/artistic geometry decisions. cc does NOT read this file. |
```
Bump knowledge.map version and date.

## 5. DO NOT TOUCH
- All .scad geometry files (PR-01-base-v*.scad, pole_top.scad, etc.) — zero
  geometry change in this prompt
- .claude/SKILL_local_render.md, .claude/SKILL_manifold_triage.md — unrelated
- cc_rules.md

## 6. QA VERIFICATION
- [ ] .claude/SKILL_customizer_profile.md created, matches spec above exactly
- [ ] WORKFLOW_SKILL.md version bumped, new trigger row present
- [ ] chat_rules.md version bumped, new bullet present
- [ ] rules-dimensions.md: new bell-collar section added with all 11 values
      exactly as specified; old split-clamp section marked SUPERSEDED, not deleted
- [ ] knowledge.map updated, version bumped
- [ ] Confirm explicitly in cc_chat_log: zero .scad files touched

## 7. MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-02
3. knowledge.map already updated in Task 5
4. Bump version on all changed files (done above)
5. Commit all → merge to main
