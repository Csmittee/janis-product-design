CC PROMPT — bbq-understructure-v12-tray-removal-fender-trackwidth
================================================================
Repo location: bbq-offset-smoker/BBQ-understructure-v12.scad (new, source v11)

REVISION NOTE: 3 real changes — (1) REMOVE the prep tray/shelf entirely
from this file, it is being relocated to a separate accessories file in
a follow-up round (not this prompt's job to build the replacement, only
to cleanly remove the old one); (2) rebuild the rear fender per Janis's
own precise spec (rear wheels ONLY, no front fender); (3) recompute
TRACK_WIDTH to a new real gap value. Chamber/firebox files are OUT OF
SCOPE — the +50mm parting-line change is a separate, later round (see
bbq-chamber-parting-shift-and-tray-init, run AFTER this one). Do not
open or reference that pending chamber-side change beyond reading its
CURRENT live values.

VERSION NOTE (corrected from the original draft of this prompt): source
is v11, not v9 — v9 and v10 were superseded by direct-cc rounds while
this prompt was queued (v10 = pointer bump to chambers-v19, v11 =
pointer bump to chambers-v20). Confirm v11 is real and current before
starting; if a newer version exists, stop and flag rather than building
on stale source (REPO TRUTH rule).

## 1. CC INTRO

Session continuity check (cc self-determines):
Are cc_rules.md, knowledge.map, and cc_chat_log.md already loaded in
your active context from earlier in THIS session, with no git
pull/merge to main since?
→ YES: CONTINUATION. Skip re-reading those three. State "Continuation —
  governance already current" and go straight to TASKS.
→ NO: FRESH. `git fetch --all && git checkout main && git pull origin
  main`. Read cc_rules.md → knowledge.map → cc_chat_log.md (first 3
  entries). State every file read before writing a line.

Claude Web override: none

Per R-014 (RULES.md) / cc_rules.md Verification Discipline Rule: before
reporting any check as done, state the SPECIFIC real probe performed
(e.g. "empty vs. tire, 2mm margin" / "non-empty weld contact vs. outer
shell"), not a generic "confirmed no collision."

**MANDATORY FIRST CHECK** — state the real, live values currently in
BBQ-understructure-v11.scad and whatever chambers file it includes
(expect BBQ-chambers-v20.scad — confirm, do not assume): `FIREBOX_W`
(expect 580mm), `WHEEL_D`/`WHEEL_R` (expect 457.2/228.6mm), `TREAD_W`
(expect 200mm), current `TRACK_WIDTH_FIREBOX_GAP` (expect 100mm, about
to change), and confirm `prep_shelf()`/`prep_shelves()`'s real current
callers/consumers before removing anything (R-009 — state the actual
call sites found, don't assume none exist beyond what this prompt
expects).

Task-specific reads:
1. bbq-offset-smoker/BBQ-understructure-v11.scad — LIVE, in full.
2. Whichever BBQ-chambers-vXX.scad file v11 currently includes (expect
   v20) — LIVE, read only for `FIREBOX_W`/`WHEEL_R`/outer shell
   side-wall real world-Y position (needed for TASK 2's fender weld
   point). Do NOT assume the +50mm parting-line change is present —
   that is a separate, later round; read whatever is ACTUALLY there
   right now and state it.
3. .claude/rules-codes.md

## 2. CONTEXT

Real numbers this round is built on:

- `TRACK_WIDTH_FIREBOX_GAP` changes 100mm → **50mm** (Janis's own real
  spec update)
- `TRACK_WIDTH = FIREBOX_W(580) + 2×50 + TREAD_W(200)` = **880mm**,
  shared front AND rear (same convention every prior round has used —
  not splitting front/rear)
- Fender: **rear wheels only** — no front fender exists or should exist
  in this file; if any fender-like geometry is currently present near
  the front wheels, state what it actually is (it may be `tow_triangle()`
  or another structural part being misread in renders, not a real
  fender) — do not silently leave ambiguous geometry unexplained.

## 3. NEW FILES

None. New `BBQ-understructure-v12.scad` (source v11).

## 4. TASKS

### TASK 1 — Remove the prep tray entirely

Delete `prep_shelf()`, `prep_shelves()`, `tray_mount_bracket()`, and any
other tray-exclusive module in this file. Before deleting, run a real
R-009 check on `CASTER_CLEARANCE`, `LEG_INSET`, `SHELF_D`, `SHELF_T` —
prior versions' own headers state these are "still real consumers via
`prep_shelf()`, DO NOT TOUCH." Confirm whether that's still their ONLY
real consumer; if so, remove them too (R-009, zero remaining callers);
if any of them are ALSO used elsewhere in this file, state that
explicitly and keep only that constant.

Remove the tray's own `show_*` isolation toggle and its ASSEMBLY call
line. State the real, final module/toggle count for this file after
removal (Toggle-Completeness recount).

This is a clean removal only — do NOT build a replacement tray, hinge,
or mounting bracket in this file. That work belongs to the separate
`bbq-chamber-parting-shift-and-tray-init` round (BBQ-offset-smoker-base
file), which runs AFTER this prompt and depends on this removal being
real and merged first.

### TASK 2 — Rear fender rebuild (rear wheels ONLY, precise real spec)

Rebuild `rear_fender()` (or equivalent — state the real module name you
use) to this exact spec, per Janis's own numbers:

- **Scope**: rear wheels only. Confirm explicitly that no analogous
  fender exists or is added for the front wheels.
- **Outward extension**: 300mm total, measured from the firebox outer
  shell's real side wall (world Y, the wall nearest each rear wheel),
  extending toward that wheel. This is a fixed literal (covers the real
  50mm firebox-to-wheel gap + 200mm tire width + margin) — do not
  re-derive it from a formula, use 300mm directly.
- **Top-view shape**: rectangular footprint (X-Y plane) before the
  curve-down zones are applied (see below).
- **Length (X, along the wheel's rolling direction)**:
  `WHEEL_D(457.2) × 1.2` = **548.64mm**, centered on the rear wheel's
  own real axle X-position.
- **Curve-down zones**: front 10% and rear 10% of the 548.64mm length
  (54.864mm each) — within each zone, the fender's surface drops 15mm
  below the flat mid-section's level, tapering down toward each end (a
  soft curved lead-in/lead-out, not a sharp step — use a real smooth
  transition, e.g. `hull()` between the flat-level edge and the
  15mm-dropped end edge, consistent with this project's own preference
  for `hull()`-based rounded transitions).
- **Elevation**: the flat mid-section's underside sits 15mm above the
  tire's own outer (topmost) surface. Real formula:
  `fender_z = REAR_AXLE_Z + WHEEL_R + 15` (state your own live-computed
  value — expect 472.2mm, using `REAR_AXLE_Z=WHEEL_R=228.6mm`).
- **Attachment**: welds to the firebox's real outer shell side wall —
  state the real CGAL contact check confirming genuine weld overlap
  (non-empty), same discipline as prior fender rounds.

Real CGAL checks required, each stated with its specific probe (per
R-014, not a generic "no collision"):
- Fender vs. tire: EMPTY (state margin)
- Fender vs. rear axle/struts: EMPTY (state margin)
- Fender vs. firebox outer shell: NON-EMPTY (state real overlap/contact
  area confirming genuine weld, not proximity)

### TASK 3 — Track width recompute

```
TRACK_WIDTH_FIREBOX_GAP = 50   (was 100)
TRACK_WIDTH = FIREBOX_W(580, read live) + 2×50 + TREAD_W(200) = 880mm
```

Apply to BOTH front and rear (shared, same convention as every prior
round). State your own live-recomputed value and confirm the real
resulting wheel Y-positions (expect `DATUM_Y_CENTER ∓ 440mm`).

Real collision re-check required (same discipline as every prior
track-width change): front-wheel-vs-front-bracket collision, re-run at
this new, narrower geometry — state the real result explicitly (EMPTY,
with margin), do not assume resolved because the prior round resolved
it at a different width.

## 5. DO NOT TOUCH

- Any chambers file (BBQ-chambers-v20.scad or later) — read only, zero
  changes, including the pending +50mm parting-line change (separate,
  later round, not yours to build or assume)
- Front axle steering mechanism, U-bracket main shape, T-bar
  bracket/gusset (TASK 6 from v9) — all unchanged, out of scope
- `REAR_AXLE_Z`/`WHEEL_R`/`FRONT_AXLE_Z` anchor formulas — unchanged
  world-Z=0 convention

## 6. QA VERIFICATION

- [ ] TASK 1: real R-009 check stated for CASTER_CLEARANCE/LEG_INSET/
      SHELF_D/SHELF_T, tray modules + toggle + ASSEMBLY line fully
      removed, final module/toggle count restated
- [ ] TASK 2: real fender dimensions stated (300mm extension, 548.64mm
      length, 54.864mm curve zones, 15mm drop, 472.2mm elevation), all
      3 CGAL checks stated with their specific real probe/margin,
      confirmed NO front-wheel fender exists
- [ ] TASK 3: real TRACK_WIDTH stated (expect 880mm), real wheel
      Y-positions stated, real collision re-check result stated with
      margin
- [ ] Full CGAL manifold sweep, `Simple: yes` on every solid
- [ ] Full kinetic sweep (steer/fold full range, lid/door states) —
      `Simple: yes` throughout (note: no more prep-shelf fold state to
      sweep, confirm removed from sweep list too)
- [ ] Screenshots: iso/front/side/rear + rear fender close-up
- [ ] Error-Log clean

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at top, under 10 lines: real
   tray removal confirmation, real fender dimensions, real track width,
   real collision-check result.
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Update knowledge.map, PART_MANIFEST.md, SKELETON_WORKSHEET.md — tray
   removed from the Understructure branch entirely (note it's relocating
   to a separate accessories file, not simply gone)
4. Update `bbq-offset-smoker/design_scope_of_work_rule.md` — remove the
   old "Prep Shelves x2 — left+right" line from the Compartment Map
   entirely (superseded, tray is relocating out of this file); update
   fender/track-width real values
5. Save as BBQ-understructure-v12.scad (v11 kept); update
   BBQ-offset-smoker-base-vXX.scad's (whichever is the real current
   base file — confirm) include pointer
6. Commit all → merge to main
