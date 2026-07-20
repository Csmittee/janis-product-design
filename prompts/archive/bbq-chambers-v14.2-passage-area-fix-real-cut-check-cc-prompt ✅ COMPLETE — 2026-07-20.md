CC PROMPT — bbq-chambers-v14.2-passage-area-fix-real-cut-check
================================================================
Repo location: bbq-offset-smoker/BBQ-chambers-v14.2.scad (new, source
v14.1)

REVISION NOTE: two targeted fixes on top of the just-merged v14.1 (PR
#133). Chamber apex(950mm)/firebox width(580mm)/fire-volume math/outer
shell flat face — ALL FROZEN, correct, do not re-touch. Understructure
remains completely out of scope.

## 1. CC INTRO

Session continuity check (cc self-determines):
Are cc_rules.md, knowledge.map, and cc_chat_log.md already loaded in
your active context from earlier in THIS session, with no git
pull/merge to main since?
→ YES: CONTINUATION. Skip re-reading those three. State "Continuation
  — governance already current" and go straight to TASKS.
→ NO: FRESH. `git fetch --all && git checkout main && git pull origin
  main`. Read cc_rules.md → knowledge.map → cc_chat_log.md (first 3
  entries). State every file read before writing a line.

Claude Web override: none

**MANDATORY FIRST CHECK** — confirm real, live values in
BBQ-chambers-v14.1.scad: real fire volume (expect ≈5,890.5in³), the
trapezoid's real current dimensions (expect bottom≈226.67mm,
top≈540mm, height≈178.665mm, area≈106.2in²), and the outer shell's
flat-face construction (expect unchanged from v14.1, do not re-touch).
If these differ from expected, STOP and flag.

Task-specific reads:
1. bbq-offset-smoker/BBQ-chambers-v14.1.scad — LIVE, in full. State
   the real current trapezoid module's exact construction (2D profile
   + `linear_extrude`/`difference()` mechanics — TASK 2 needs to see
   exactly how the cut is currently implemented to diagnose it).
2. `true_octagon_profile()`'s real boundary — same reference points as
   v14.1 used (h=0, h=chamfer) — needed to re-derive the resized
   trapezoid's real bottom/top widths against actual live geometry,
   not the estimate in this prompt.
3. The chamber's real wall thickness at the passage location (whatever
   constant/formula governs the octagon end cap's own material
   thickness — TASK 2 needs this to confirm the cutting solid's real
   extrusion depth exceeds it with margin on both faces).
4. .claude/SKILL_joint_construction.md
5. .claude/rules-codes.md

## 2. CONTEXT

**Problem 1 — real, numeric, this prompt's fault for not specifying
it**: v14.1's trapezoid was derived from the octagon's real boundary
but was never sized against the project's own standing 0.008-of-
firebox-volume opening-area rule. Real check: (226.67+540)/2×178.665 ≈
68,486mm² ≈ 106.2in² — against a real target of 5,890.5in³×0.008 ≈
47.1in², that's ~2.25x oversized. This round gives you the real target
explicitly rather than leaving sizing to inference.

**Problem 2 — real, visually reported, likely a genuine defect not an
artifact**: Janis reports the trapezoid renders as a visible OUTLINE
with no actual material removed behind it ("very large but not cut
through") — distinct from v14.1's diagnosed camera-angle OpenGL
artifact (that one was confirmed benign; this one looks like an actual
`difference()`/extrusion-depth failure, e.g. the cutting solid's real
Z-extent not fully penetrating the wall's own real thickness, leaving
an uncut membrane on one face). Treat this as a real bug to find and
fix, not something to re-diagnose as the same benign artifact as last
round — the symptom pattern (visible boundary line, no actual opening)
is different from last round's finding.

## 3. NEW FILES

None. New `BBQ-chambers-v14.2.scad` (source v14.1).

## 4. TASKS

### TASK 1 — Resize trapezoid to the real 0.008 area target

Target area = real fire volume(state it live) × 0.008 — state the
real computed target in in² and mm², don't copy the ≈47.1in² estimate
in this prompt blindly.

Height stays FIXED at the same real value as v14.1 (bottom edge at
`chamber_floor_z`, top edge at firebox_top−50mm — both positions are
Janis's real placement requirement, not adjustable for area purposes).
Only the WIDTHS (bottom/top) change, scaled down from v14.1's real
values to hit the real target area while preserving the same
proportional taper (top wider than bottom, following the octagon's
real widening direction — do not invert or flatten the taper).

State your real solved bottom/top widths and the real resulting area
— confirm it lands at the target (small rounding tolerance is fine,
state the real % of target achieved).

Real verification: re-run the same containment check v14.1 did (full
trapezoid clears real chamber material, no chord/clip) at the new,
smaller size — should be easier to satisfy at a smaller size, but
confirm live, don't assume.

### TASK 2 — Diagnose and fix the real cut-penetration defect

Do NOT default to "camera artifact" — investigate as a real modeling
defect first:

1. State the real current cutting-solid construction: what shape is
   extruded, what real Z-depth/thickness it spans, and whether that
   depth actually exceeds the chamber wall's own real material
   thickness (from task-specific read #3) with real margin on BOTH
   the entry and exit faces (a common real cause of an
   apparent-but-not-actual cut: the extrusion depth matches the wall
   thickness exactly, leaving a zero-thickness coincident face on one
   side — same CLASS of issue as this project's prior coincident-face
   bugs).
2. Real check: after the `difference()`, is there real, verifiable
   empty space (a true hole) through the wall at the trapezoid's
   location — confirm via an actual ray/probe check or an
   equivalent real geometric test, not a visual read of a preview
   screenshot.
3. If a real defect is found (insufficient extrusion depth, wrong
   solid subtracted, wrong Z-position, etc.), fix it and re-verify
   with the same real check.
4. If, after genuine investigation, no real defect is found and this
   turns out to be another rendering/preview artifact — state that
   explicitly, with a real reproduction/diagnosis (same rigor as
   v14.1's TASK 3), not a guess or a repeat of the prior finding
   without re-testing THIS specific symptom.

## 5. DO NOT TOUCH

- Chamber apex A(950mm), `chamber_floor_z`, `GRATE_Z_FIXED`, firebox
  width(580mm)/dimensions, fire-volume math — all correct, zero changes
- Outer shell's flat-face construction (v14.1's TASK 1 fix) — correct,
  zero changes
- Trapezoid's Z-position (bottom at `chamber_floor_z`, top at
  firebox_top−50mm) — only widths change this round
- `BBQ-understructure-v4.scad` — entirely out of scope, do not open
- rules-dimensions.md, cc_rules.md — read only

## 6. QA VERIFICATION

- [ ] Real fire volume re-stated (expect unchanged, ≈5,890.5in³)
- [ ] Real target area stated (fire volume × 0.008), both in² and mm²
- [ ] Real new trapezoid bottom/top widths stated, height confirmed
      unchanged from v14.1
- [ ] Real resulting area stated, confirmed at/near target (%stated)
- [ ] Real containment check: trapezoid still fully clears chamber
      material at the new smaller size, no chord/clip
- [ ] Real cutting-solid extrusion depth vs. real wall thickness —
      stated explicitly, margin on both faces confirmed
- [ ] Real verification that the passage is a genuine through-hole
      (actual probe/ray check, not a visual read) — result stated
- [ ] If a defect was found: real fix described, re-verified
- [ ] If no defect found: real reproduction/diagnosis stated for THIS
      specific symptom, not a reference back to v14.1's prior finding
      without new testing
- [ ] Full CGAL manifold sweep, `Simple: yes` on every solid
- [ ] Full kinetic sweep (lid, firebox door) — `Simple: yes` throughout
- [ ] Screenshots: dimensioned trapezoid corner view (new size) PLUS a
      real look-through-the-open-door shot clearly showing daylight/
      background visible through the passage (not just an outline)
- [ ] Error-Log clean

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at top, under 10 lines: real
   new trapezoid dimensions + area vs. target, real cut-defect
   finding (fixed, or genuinely reproduced-and-diagnosed as benign).
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-20
3. Update knowledge.map, PART_MANIFEST.md, SKELETON_WORKSHEET.md —
   update trapezoid dimensions, note the cut-verification finding
4. Update `bbq-offset-smoker/design_scope_of_work_rule.md`'s Envelope
   section: passage area now real target-matched (state %), bump version
5. Save as BBQ-chambers-v14.2.scad (v14.1 kept); update
   BBQ-offset-smoker-base-v1.scad's include pointer per v14/v14.1
   precedent (confirm real chain location, understructure still out
   of scope)
6. Commit all → merge to main
