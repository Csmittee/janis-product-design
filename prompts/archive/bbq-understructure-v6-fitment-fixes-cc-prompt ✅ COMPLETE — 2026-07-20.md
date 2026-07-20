CC PROMPT — bbq-understructure-v6-fitment-fixes
================================================================
Repo location: bbq-offset-smoker/BBQ-understructure-v6.scad (new, source v5)

REVISION NOTE: 4 real fitment fixes from Janis's live OpenSCAD-desktop
review of v5, PLUS a full numbers recompute against the NEW chambers
round (bbq-chambers-v15-square-shell-cylinder-firebox) that Janis is
running FIRST, before this prompt. Do not dispatch this prompt until
v15 is confirmed merged — TASK 0 below is the mandatory live check for
that.

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

**MANDATORY FIRST CHECK — TWO real things, in order, before touching
anything:**

1. **Confirm BBQ-chambers-v15.scad is actually merged to main.** State
   its real, live `firebox_floor_z` (expect 420mm), `FIREBOX_H` (expect
   580mm), `FIREBOX_W` (expect 580mm, unchanged), cylinder diameter
   (expect ≈489.3mm), `chamber_floor_z` (expect 771.335mm, unchanged).
   If v15 is NOT yet merged, STOP — do not proceed on estimated numbers,
   flag back to Janis.
2. **Confirm the real current state of BBQ-understructure-v5.scad** —
   Janis ran a live desktop review session on v5 directly (not yet
   merged/logged as of this prompt's writing). State its real current
   `include` target, real `TRACK_WIDTH`/track-width-equivalent value,
   real front-bracket-tip construction, real T-bar default angle, and
   whether v5 was ever actually committed/merged, or if this round
   starts fresh from the v5 prompt's own original intent instead. Do
   not assume — state what you actually find.

Task-specific reads (read regardless of continuation/fresh):
1. bbq-offset-smoker/BBQ-understructure-v5.scad — LIVE, in full.
2. bbq-offset-smoker/BBQ-chambers-v15.scad — LIVE, in full (per check
   #1 above).
3. .claude/rules-codes.md

## 2. CONTEXT

Real numbers this round is built on — ALL must be reconfirmed live per
TASK 0/mandatory first check above, not copied from this prompt blindly
(v15's real merged values may differ slightly from Claude Web's
pre-computed estimates):

- `chamber_floor_z` = 771.335mm (unchanged by v15, chamber body itself
  untouched)
- roof Z (`DATUM_Z_RIDGE`) = chamber_floor_z + chamber_H(610) =
  **1381.335mm** (unchanged — firebox height change does not affect
  the chamber body)
- `firebox_floor_z` = **420mm** (was 571.4mm pre-v15 — real, substantial
  change, the firebox now sits ~151mm closer to the ground)
- `FIREBOX_W` = 580mm (unchanged)
- `WHEEL_R` = 228.6mm (18" wheel, v4's real world-Z=0 anchor — unchanged
  convention)

Real axle-to-firebox-bottom gap, recomputed:
```
firebox_floor_z(420) - WHEEL_R(228.6) = 191.4mm (was 342.8mm)
```
This is a real, substantial reduction — nearly half the old gap — and
is the primary real fix for Janis's "whole body flies too high off the
ground" observation from the v5 review. State your own live-recomputed
value, confirm it matches or explain variance.

## 3. NEW FILES

None. New `BBQ-understructure-v6.scad` (source v5).

## 4. TASKS

### TASK 0 — Pointer bump: v14.2 (or whatever v5 currently has) → v15

Bump this file's own `include` to `<BBQ-chambers-v15.scad>`. Re-verify
via CGAL that `front_wheel_support()`'s leg top edge (h=MID_H) is still
flush against `true_octagon_profile()`'s real boundary at the current
`chamber_floor_z` (this datum is UNCHANGED by v15, so this should be a
confirmation, not a rebuild — but confirm live, don't assume clean
just because the datum didn't move).

### TASK 1 — Prep shelf: fix mounting/alignment

Real finding from Janis's live review: the fold-down/fold-up outer prep
shelf (`prep_shelf()`) currently reads as cantilevered from a single
mount point, not aligned flush along the chamber's own side edge (the
edge at apex A). Rebuild its mounting so it attaches along the real
edge — multiple real weld/hinge points tracking that edge, not a single
stacked mount — so it sits level and flush when folded down, matching
a real usable prep-surface geometry. State your real chosen mounting
construction and hinge-point count/positions.

### TASK 2 — Track width: recompute for 100mm wheel-to-firebox gap

Real spec change from Janis (firebox is insulated, wheel can sit
closer): gap reduces from the v5-dispatched 150mm to **100mm** each
side.
```
TRACK_WIDTH = FIREBOX_W(580, read live) + 2*100 + TIRE_W(200) = 980mm
```
Apply to BOTH front and rear, same shared-track-width convention as
v5's own TASK 1. State your real live-computed value.

### TASK 3 — Fender: rebuild as a short flared "wing", not a long panel

Real finding from Janis's live review, confirmed against reference
photos (Taylor Made Custom Fabrication builds): the current fender
reads as a long straight panel. Rebuild as a SHORT flared wing —
hugging the tire's own curvature closely, welded to the firebox's outer
shell, ~150mm gap above the wheel (unchanged spec) but the panel's own
LENGTH (along the wheel's rolling direction) should be short — roughly
matching the tire's own visible arc in the reference photos, not
extending well beyond the wheel's footprint. State your real chosen
panel length/arc and reasoning.

### TASK 4 — Rear wheel/axle position — recompute for new firebox_floor_z

Using the real v15 `firebox_floor_z`(420, read live) and the real
191.4mm axle-to-firebox gap (TASK-level recompute, see CONTEXT above):
rebuild the rear axle strut/spacer geometry to the new, shorter real
gap. Same "axle center = WHEEL_R above ground, world Z=0 anchor"
convention as v5 — only the vertical span between the axle and the
firebox underside shortens. State your real live-recomputed strut
length.

### TASK 5 — Front U-bracket drop length — recompute for new firebox_floor_z

The U-bracket's DROP LENGTH must equal the real `firebox_floor_z`
(420mm, read live from v15) — was 571.4mm. This is a substantial
reduction in bracket material. Re-verify the bracket's own top-edge
flush fit against the octagon (same check as TASK 0) still holds with
the shorter drop — state real result.

### TASK 6 — T-bar bracket: mount at axle plane, not floating above it

Real finding from Janis's annotated screenshot: the bracket that holds
the T-bar puller mount currently sits floating above the front axle's
own plane. Rebuild so it mounts/welds directly AT the same plane as the
axle, with a real curved corner reinforcement transitioning from the
bracket into the axle (per Janis's own reference annotation — a smooth
structural curve, not a sharp right-angle joint). State your real
chosen curve radius/construction.

### TASK 7 — T-bar length: re-verify (should be unaffected)

Re-confirm live: `TBAR_LEN = roof_Z(1381.335, unaffected by v15) -
WHEEL_R(228.6) - bracket_thickness(50)` ≈ 1102.735mm. State your real
live-computed value — this should match v5's own original result since
nothing in this round's chambers change touches `chamber_floor_z`.

### TASK 8 — Real collision re-check (both old defects)

Re-run the real CGAL collision check between front wheels and the
front bracket/caster plate/tow triangle — this is the SAME check v5's
own TASK 7 was supposed to run, at the NOW further-changed geometry
(new track width, new bracket drop length, new axle position). State
the real result explicitly — do not assume resolved because the
numbers moved in the right direction.

## 5. DO NOT TOUCH

- BBQ-chambers-v15.scad — read only, zero changes
- Front axle steering mechanism (triangle/yoke/`steer_deg`) — respan
  only per new TRACK_WIDTH, not a redesign
- U-bracket's main shape — drop length + tip only (TASK 5, and TASK 2
  from v5's own prompt if not yet done — reshape tip round, ≥150mm
  width)
- Caster mounting plate spec — still placeholder, out of scope

## 6. QA VERIFICATION

- [ ] TASK 0: real pointer bump confirmed, front bracket flush-fit
      re-verified
- [ ] TASK 1: prep shelf real mounting construction stated, folds
      down/up cleanly, sits flush along the real edge
- [ ] TASK 2: real TRACK_WIDTH stated (expect 980mm), applied front+rear
- [ ] TASK 3: fender real length/arc stated, visually short/flared not
      long
- [ ] TASK 4: rear axle real recomputed strut length stated
- [ ] TASK 5: U-bracket real drop length stated (expect 420mm), flush
      fit re-verified
- [ ] TASK 6: T-bar bracket real same-plane mount + curve construction
      stated
- [ ] TASK 7: T-bar length real value stated (expect ≈1102.735mm)
- [ ] TASK 8: real collision check result stated explicitly
- [ ] Full CGAL manifold sweep, `Simple: yes` on every solid
- [ ] Full kinetic sweep (lid, firebox door, T-bar tilt, steer_deg,
      prep shelf fold) — `Simple: yes` throughout
- [ ] Screenshots: iso/front/side/rear + T-bar at default (90°) + prep
      shelf folded down + fender close-up + front bracket/axle
      close-up
- [ ] Error-Log clean

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at top, under 10 lines: real
   pointer bump confirmation, real track width, real prep-shelf/fender/
   bracket fixes, real collision-check result, real T-bar length.
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Update knowledge.map, PART_MANIFEST.md, SKELETON_WORKSHEET.md — full
   understructure branch rebuild
4. Update `bbq-offset-smoker/design_scope_of_work_rule.md` — bump
   version, real built values
5. Save as BBQ-understructure-v6.scad (v5 kept, if it was ever
   committed — state real status); update
   BBQ-offset-smoker-base-v1.scad's include pointer
6. Commit all → merge to main
