CC PROMPT — bbq-understructure-level-drop-companion
================================================================
Repo location: bbq-offset-smoker/BBQ-understructure-v14.scad (new,
source v13)

REVISION NOTE: Companion round to bbq-chambers-grate-master-datum-
restore-and-level-drop (BBQ-chambers-v22.scad, must be real and merged
before starting this). The chamber+firebox assembly dropped −100mm in
world Z (grate 1000→900, apex A 950→850 via its own restored master-
datum formula). Wheels/axles stay exactly where they are (fixed to true
ground Z=0, independent of the chamber by design) — the support poles
(front and rear) and the T-bar absorb the entire 100mm by shrinking.
The fender needs a real re-check, not an automatic recompute (see TASK
2) — its own formula is wheel-referenced, not shell-referenced, so it
does not move on its own, but the shell moving 100mm closer to it needs
verifying, not assuming clear.

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

Per R-014: state the SPECIFIC real check performed for every QA item,
not a generic "confirmed working."

**MANDATORY FIRST CHECK**: confirm `BBQ-chambers-v22.scad` is real and
merged — state its real current `GRATE_Z`/`apex_A` values (expect
900/850). State the REAL current formulas for every support-pole/T-bar
length in this file (leg drop, front spacer length, rear bracket
height, T-bar length) — confirm which are already live formulas off
`chamber_floor_z`/`firebox_floor_z` (expect: all of them, per this
project's own history) vs. any that might be hardcoded literals (flag
if found, do not assume).

## 2. CONTEXT

Wheels/axles: fixed to true ground Z=0, unchanged, independent of the
chamber by design (confirmed understructure convention). The entire
100mm drop is absorbed structurally by the poles/T-bar shortening —
nothing about the wheel/axle/track-width geometry changes.

Fender: real formula is `fender_z = REAR_AXLE_Z + WHEEL_R + 15`,
wheel-referenced, not shell-referenced. Since wheels don't move, this
value does NOT automatically change — Janis has confirmed the
CLEARANCE-PRIORITY default: the fender's real tire-clearance height
(15mm above tire) stays exactly as-is, unmoved. What DOES need a real
check is whether the fender can still physically reach and weld to the
firebox outer shell now that the shell sits 100mm closer to the fixed
wheel position — this is a real geometry question, not assumed either
way.

## 3. NEW FILES

None. New `BBQ-understructure-v14.scad` (source v13).

## 4. TASK 1 — Confirm poles/T-bar auto-follow the drop

For every support-pole and T-bar length identified in the Mandatory
First Check as a live formula: confirm it recomputed automatically once
v22's values changed (100mm shorter, matching the drop) — real
measurement, not assumed from the formula alone. If any turns out to be
hardcoded (flagged in the Mandatory First Check), fix it to a live
formula now and state the real before/after value explicitly.

**Mandatory real check**: real render at the new elevation — confirm
every pole/T-bar length is exactly 100mm shorter than its v13 value,
confirm the chamber assembly now sits flush/correct atop the
understructure with zero gap and zero interpenetration at the mount
points (real CGAL contact check, non-empty weld/mount contact, same
discipline as every prior mount-point check in this project).

## 5. TASK 2 — Fender: keep Z fixed, verify real weld/reach clearance

Do NOT change the fender's Z position or its 15mm-above-tire formula —
per the clearance-priority decision above, that value is unchanged.

**Mandatory real checks, each with its specific probe (per R-014)**:
- Real distance from the fender's inner mounting edge to the firebox
  outer shell's real side wall, AT THE NEW (100mm-lower) shell position
  — state the real live-measured gap or overlap
- If the fender can still make genuine non-empty weld contact with the
  shell at this new relative position: confirm via real CGAL contact
  check, same as the original fender round
- If it CANNOT reach (the shell has moved out of the bracket's real
  physical range): STOP, do not silently stretch/redesign the bracket —
  state the real gap/interference found and flag it back, this is a
  genuine design decision (extend the bracket vs. reconsider) not a
  judgment call to resolve unilaterally
- Fender vs. tire: EMPTY (state real margin, expect unchanged ~15mm
  since neither fender nor tire moved)
- Fender vs. rear axle/struts: EMPTY (state real margin)

## 6. DO NOT TOUCH

- Wheel/axle positions, track width, tread width — all unchanged
- Fender's own Z value and 15mm tire-clearance formula — unchanged (see
  TASK 2)
- `BBQ-chambers-v22.scad` — read only, zero changes
- Front axle steering mechanism, tow handle/T-bar geometry beyond its
  own length recompute (TASK 1) — unchanged otherwise

## 7. QA VERIFICATION

- [ ] Mandatory First Check: real chambers-v22 values confirmed, real
      pole/T-bar formula list stated (live vs. hardcoded)
- [ ] TASK 1: real 100mm-shorter measurement confirmed for every
      pole/T-bar, real mount-point contact check (non-empty)
- [ ] TASK 2: real fender-to-shell gap/contact stated explicitly, real
      weld contact check OR explicit flag if reach fails, fender-vs-tire
      and fender-vs-axle margins re-confirmed unchanged
- [ ] Full CGAL manifold sweep, `Simple: yes`
- [ ] Full kinetic sweep (steer/fold, lid/door/tray) at new elevation —
      `Simple: yes` throughout
- [ ] Screenshots: iso/front/side/rear at new elevation + fender
      close-up showing real shell clearance
- [ ] Error-Log clean

## 8. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at top, under 10 lines: real
   pole/T-bar new lengths, real fender clearance/contact result.
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Update knowledge.map, PART_MANIFEST.md, SKELETON_WORKSHEET.md — new
   pole/T-bar lengths, real new elevation noted
4. Update `bbq-offset-smoker/design_scope_of_work_rule.md` if it states
   any of these values directly
5. Save as BBQ-understructure-v14.scad (v13 kept, unmodified, on
   record). Bump `BBQ-offset-smoker-base-vX.scad` to the next real
   version (pointer-only, same convention as base-v3) pointing at
   BBQ-understructure-v14.scad — state the real new base filename used.
6. Commit all → merge to main
