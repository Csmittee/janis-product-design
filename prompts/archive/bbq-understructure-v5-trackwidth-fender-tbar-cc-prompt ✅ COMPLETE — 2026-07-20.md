CC PROMPT — bbq-understructure-v5-trackwidth-fender-tbar
================================================================
Repo location: bbq-offset-smoker/BBQ-understructure-v5.scad (new, source v4)

REVISION NOTE: full understructure rebuild — track width, front bracket
tip reshape, rear wheel/fender, T-bar length+default angle. Chamber/
firebox (BBQ-chambers-v14.2.scad) are FROZEN, do not touch. This is the
first understructure round since v4 (2026-07-17) — three chamber rounds
(v13, v14, v14.1, v14.2) have landed since without this file's own
`include` pointer being bumped. TASK 0 below is not optional preamble —
it is the real first fix this round requires, before any of the
mechanical tasks.

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

**MANDATORY FIRST CHECK — confirm real, live values in
BBQ-chambers-v14.2.scad before touching anything**: `chamber_floor_z`
(expect 771.335mm, formula 950-chamfer), `chamfer` (expect 178.665mm),
`chamber_H` (expect 610mm, unchanged), `firebox_floor_z` (expect
571.4mm, LOCKED since v12), `FIREBOX_W`/outer shell width (expect
580mm), `DATUM_Y_CENTER` (expect 305mm). If ANY differ from expected,
STOP and flag — do not build v5 on an unexpected chambers state.

Task-specific reads:
1. bbq-offset-smoker/BBQ-understructure-v4.scad — LIVE, in full,
   including its own real `include` line (expect it currently points at
   BBQ-chambers-v13.scad, NOT v14.2 — confirm this directly, do not
   assume from this prompt's own claim).
2. bbq-offset-smoker/BBQ-chambers-v14.2.scad — LIVE, in full. Need
   `true_octagon_profile()`'s real boundary at h=0 and h=chamfer/2 for
   TASK 2's front-bracket-leg re-verification.
3. .claude/rules-codes.md
4. rules-dimensions.md — BBQ Offset Smoker Base section

## 2. CONTEXT

BBQ-understructure has been frozen at v4 since 2026-07-17, while four
chamber/firebox rounds (v13, v14, v14.1, v14.2) landed. v4 shipped with
a real, CGAL-confirmed, UNRESOLVED ~6mm collision between the front
wheels and the front bracket/caster plate/tow triangle. This round both
fixes that AND implements a real mechanical redesign (wider shared
track width, reshaped front bracket tip, new rear wheel position +
fender, longer T-bar with a corrected default angle).

**Standing architectural risk, confirmed real this session, not
assumed**: `front_wheel_support()`'s own geometry
(`MID_H`/`TOP_W`/`BOT_W`) and Z-position are LIVE FORMULAS off
`chamber_floor_z`/`chamfer`, read from whatever chambers file is
included — this is sound architecture. But BBQ-understructure-v4.scad's
own `include` line was never bumped past BBQ-chambers-v13.scad through
three subsequent chamber rounds (v14/v14.1/v14.2 all explicitly state
"understructure completely out of scope, not opened, include pointer
not bumped"). This means the bracket, as currently wired, is built
against `chamber_floor_z=721.335mm` (v13's value) — a real 50mm gap
from v14.2's actual 771.335mm. TASK 0 fixes this before anything else
touches the file.

Real numbers this round is built on (all reconfirmed live per TASK-
SPECIFIC READS above, not copied from any prior draft blindly):
- `chamber_floor_z` = 771.335mm (950 − chamfer)
- `chamber_H` = 610mm (unchanged) → roof Z (`DATUM_Z_RIDGE`) =
  chamber_floor_z + chamber_H = **1381.335mm**
- `firebox_floor_z` = 571.4mm — LOCKED, confirmed unchanged since v12
- Firebox outer shell width (`FIREBOX_W`) = 580mm
- `WHEEL_R` = 228.6mm (18" wheel, v4's own real world-Z=0 anchor
  convention — reuse, do not reintroduce the old `GROUND_OFFSET`
  paper-offset pattern that caused the v3→v4 crisis)

## 3. NEW FILES

None. New `BBQ-understructure-v5.scad` (source v4).

## 4. TASKS

### TASK 0 — Pointer bump + real front-bracket re-verification (DO FIRST)

Bump this file's own `include` from `<BBQ-chambers-v13.scad>` to
`<BBQ-chambers-v14.2.scad>`. This alone changes `chamber_floor_z` from
721.335mm to 771.335mm, which shifts `front_bracket_leg()`'s real
world-Z position by +50mm (its own `MID_H`/`TOP_W`/`BOT_W` formulas are
unchanged in VALUE since `chamfer`/`chamber_W` are unchanged — only the
base Z shifts).

Real check required, not assumed: re-verify via CGAL that the bracket
leg's top edge (h=MID_H) is still flush against
`true_octagon_profile()`'s real boundary at the new `chamber_floor_z`
— same check v2's own session did originally. State the real result.
This is the direct, concrete answer to the standing "does the bracket
actually track the chamber" worry — confirm it live here, do not carry
forward the v2-era confirmation as still valid without re-running it
at the new Z.

### TASK 1 — Track width rebuild (both front AND rear)

Replace v4's rear `REAR_TRACK_WIDTH`(857mm, old formula) and the
front's single-pivot spacing with ONE shared, re-derived track width:

```
TRACK_WIDTH = FIREBOX_W(580, read live) + 2*150 + TIRE_W(200) = 1080mm
```

center-to-center, both front and rear. Front axle spans this same
1080mm via the SAME single-center-pivot mechanism already built (see
TASK 5) — not independent track widths front vs rear.

### TASK 2 — Front bracket tip reshape

The extension that pushes forward to weld the T-bar pivot bracket
currently ends in a sharp/pyramid apex. Rebuild it ROUND, minimum
150mm width at the tip — not a point. This is the U-bracket's own
forward extension only — the U-bracket's main shape (per TASK 4) stays
untouched.

### TASK 3 — Rear wheel position (new placement, insulated-firebox-aware)

- X: bottom-mid section of the firebox (X/length direction).
- Y: minimum 150mm gap from the firebox side (closer than v4's old
  clearance — firebox is insulated as of v12+, safe to sit nearer).
- Axle height: center = WHEEL_R(228.6mm) above ground (world Z=0),
  same anchor convention as v4.
- Real axle-to-firebox-bottom gap: firebox_floor_z(571.4, read live) −
  WHEEL_R(228.6) = 342.8mm expected — cross-check this against v4's
  own `REAR_BRACKET_H` if that constant still exists in v4; state
  whether it matches.
- Vertical gap between axle center and firebox: absorb with bracket
  FILLERS left/right, under the firebox — same "spacer bracket
  absorbs the gap" convention as v3.
- Wheel bottom must stay at world Z=0 (v4's real anchor discipline —
  do not regress to the old GROUND_OFFSET pattern).
- NEW wheel fender: flat steel panel, welded to the firebox's own
  OUTER SHELL, straight off the firebox side (viewed from the back),
  curving down after clearing the wheel's outer edge, ~150mm gap
  above the wheel. No numeric spec beyond that gap.

### TASK 4 — Front wheel position (mirrors rear, via the U-bracket)

The existing U-shaped bracket welded under the front zone of the
chamber is CONFIRMED GOOD — do not touch its main shape (only its tip,
per TASK 2). Its DROP LENGTH must equal firebox_floor_z (571.4mm, read
live) — i.e. reach exactly as low as the firebox's own real lowest
point. Front wheel is then a COPY of the rear wheel (same TASK 1 track
width, same WHEEL_R/Z=0 anchor), placed directly under this bracket.
Any remaining gap: filler bracket or the central caster bearing itself
taking up slack, same convention as TASK 3.

### TASK 5 — Front axle rigidity + steering (re-verify, do not rebuild)

Front wheel pair is a RIGID structure, single center pivot — confirm
this mechanism (triangle welded to one yoke, `steer_deg` rotates the
pair) already exists in v4 and re-verify it through the TRACK_WIDTH
change (respan to 1080mm) and the bracket-tip reshape. Do not redesign
the mechanism itself.

### TASK 6 — T-bar length + default angle fix

Length — LIVE FORMULA, do not hardcode:
```
TBAR_LEN = roof_Z(DATUM_Z_RIDGE, read live) − WHEEL_R(228.6) − bracket_thickness(50)
```
Using this round's real chamber_floor_z(771.335)+chamber_H(610) =
1381.335mm roof → TBAR_LEN ≈ **1102.735mm** (~43.4in) — state your own
live-computed value, confirm it matches or explain any variance.

Default angle: T-bar must default to 90° (vertical storage position),
NOT flat/horizontal — this was flagged broken in the v12/v4 QA round
(built showing it defaulting flat). Fix the actual default parameter
value, verify by rendering at the default (no explicit override) and
confirming it reads 90°.

### TASK 7 — Real collision re-check (the original v4 defect)

v4 shipped with a real, CGAL-confirmed, UNRESOLVED ~6mm collision
between the front wheels and the front bracket/caster plate/tow
triangle. After TASKS 1-6, run a real CGAL check confirming this
specific collision is now resolved by the new 1080mm track width +
repositioned wheels — do not assume the wider spacing automatically
fixes it. State the real result (resolved / still present / different
now) explicitly.

## 5. DO NOT TOUCH

- BBQ-chambers-v14.2.scad — read only, zero changes, chamber/firebox
  math is frozen
- `prep_shelves()` — confirmed no conflict with `front_wheel_support()`
  in the v2 session; do not re-touch unless TASK 1-4 changes create a
  new real conflict (check, don't assume clean)
- Front axle steering MECHANISM (triangle/yoke/steer_deg) — respan
  only, per TASK 5, not a redesign
- U-bracket's main shape — tip reshape only, per TASK 2
- Caster mounting plate spec (`CASTER_PLATE_SIZE`) — still a
  placeholder, out of scope this round
- Grate's 100mm→50mm gap / reinforcement frame — deferred, unrelated

## 6. QA VERIFICATION

- [ ] TASK 0: real `chamber_floor_z` stated (771.335mm), front bracket
      leg top edge re-verified flush against `true_octagon_profile()`
      at the new Z — real CGAL result stated
- [ ] TASK 1: real TRACK_WIDTH computed live (expect 1080mm), applied
      to both front and rear
- [ ] TASK 2: front bracket tip real minimum width stated (≥150mm),
      confirmed round not sharp
- [ ] TASK 3: rear wheel real X/Y stated, real 150mm+ firebox gap
      confirmed, fender real gap-above-wheel confirmed (~150mm), wheel
      bottom at world Z=0 confirmed via real check
- [ ] TASK 4: front U-bracket drop length confirmed = firebox_floor_z
      (571.4mm) live, front wheel position confirmed as true copy of
      rear
- [ ] TASK 5: rigid single-pivot steering re-verified post-respan,
      `steer_deg` sweep still clean
- [ ] TASK 6: T-bar length real live-computed value stated, default
      angle rendered and confirmed 90° (no override)
- [ ] TASK 7: real collision check result stated explicitly (resolved/
      not/different) — not assumed
- [ ] Full CGAL manifold sweep, `Simple: yes` on every solid
- [ ] Full kinetic sweep (lid, firebox door, T-bar tilt, steer_deg) —
      `Simple: yes` throughout
- [ ] Screenshots: iso/front/side/rear + T-bar at default (90°) +
      close-up of front bracket tip + close-up of rear wheel/fender
- [ ] Error-Log clean

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at top, under 10 lines: real
   pointer-bump result, real track width, real collision-resolution
   result, real T-bar length, default-angle fix confirmed.
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Update knowledge.map, PART_MANIFEST.md, SKELETON_WORKSHEET.md —
   full understructure branch rebuild, all 7 tasks reflected
4. Update `bbq-offset-smoker/design_scope_of_work_rule.md` — track
   width/fender/T-bar now real built values, not scoped-only; bump
   version
5. Save as BBQ-understructure-v5.scad (v4 kept); update
   BBQ-offset-smoker-base-v1.scad's include pointer
6. Commit all → merge to main
