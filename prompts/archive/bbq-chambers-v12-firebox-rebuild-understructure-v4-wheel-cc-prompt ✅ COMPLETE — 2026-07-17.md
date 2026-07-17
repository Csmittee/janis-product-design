CC PROMPT — bbq-chambers-v12-firebox-rebuild + understructure-v4-wheel-anchor
================================================================
Repo locations:
- bbq-offset-smoker/BBQ-chambers-v12.scad (new, source v11)
- bbq-offset-smoker/BBQ-understructure-v4.scad (new, source v3)

REVISION NOTE: this SCOPE-EXPANDS beyond understructure-only —
`BBQ-chambers-v11.scad` was locked all session, this prompt explicitly
UNLOCKS it for a firebox rebuild only (see TASK 1). Everything else in
chambers stays frozen. This round covers firebox resize + internal
fuel cylinder (chambers) and wheel-size correction + world-Z re-anchor
(understructure) ONLY. Front axle span, spacer brackets, T-bar, and
front-bracket height alignment (all queued from the v3 review) are
explicitly NOT in this prompt — they depend on this round's real
output (new firebox X-midpoint, confirmed wheel geometry) and will be
a follow-up prompt once this merges.

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

Task-specific reads (read regardless of continuation/fresh):
1. bbq-offset-smoker/BBQ-chambers-v11.scad — LIVE, in full. State real
   current values: `chamber_L`(915)/`chamber_W`(610), `chamber_floor_z`
   (600), `firebox_x0/x1`, `firebox_size`(457, current cube), `firebox_y0/
   y1`, `firebox_floor_z`(400), `true_octagon_profile()`'s apex-A point
   (real local coordinate), and the REAL local distance from apex A to
   the grate/grill surface as currently built — state this explicitly,
   this round assumes it is ~0 (grate = apex A today), confirm or flag
   a mismatch.
2. bbq-offset-smoker/BBQ-understructure-v3.scad — LIVE, in full. State
   current WHEEL_D/WHEEL_R, REAR_AXLE_X/REAR_TRACK_WIDTH/REAR_AXLE_Z/
   REAR_BRACKET_H, and the wheel-to-ground Z relationship as actually
   built (this round specifically needs to verify whether the wheel's
   bottom really sits at world Z=0 — Janis flagged suspicion it may not,
   see TASK 3).
3. .claude/SKILL_joint_construction.md
4. .claude/rules-codes.md
5. bbq-offset-smoker/design_scope_of_work_rule.md — Envelope +
   Compartment Map sections (firebox figures being changed this round)

## 2. CONTEXT

Real render review by Janis this session confirmed the firebox as
originally sized (a simple `firebox_size=457` cube) is real-world too
small — the actual fabricated reference is insulated, with a separate
internal cylindrical fuel-storage vessel, meaning the OUTER firebox
shell can be sized independent of the old "1/3 chamber volume" rule
(that rule sizes the internal fire cylinder, not the outer jacket).
This prompt rebuilds the firebox as an insulated jacket around a new
internal cylinder, at explicit locked dimensions (below) — not
re-derived from the volume formula.

**Locked spec, confirmed numerically across this session — use these
exact numbers, do not re-derive or round:**

| Item | Value |
|---|---|
| Apex A / today's real grate line (world Z) | 900mm — TODAY's real geometry, unchanged this round |
| Firebox top_Z (world) | **1000mm** — built to a FUTURE target height now, intentionally 100mm above today's real apex A/grate line (see note below) |
| Firebox bottom_Z (world) | **571.4mm** = 900 − WHEEL_R(228.6) − 100mm clearance |
| Firebox height | **428.6mm** (1000 − 571.4) |
| Firebox length (X) | **460mm** — centered on the CURRENT firebox X-midpoint (was 457mm, ~1.5mm shift each side, negligible) |
| Firebox width (Y) | **510mm** |
| Internal fuel cylinder wall thickness | 3mm |
| Internal fuel cylinder diameter | **388.6mm** = min(firebox height 428.6, firebox width 510) − 40mm (20mm gap to the smaller-dimension walls) |
| Internal fuel cylinder length (X) | flush to the firebox's rear/door-side face — the far end is open per Janis, "let me see how it looks then I'll explain the adjustment" (flag this as a known open item, do not over-engineer the far end) |
| Wheel diameter / radius | **457.2mm / 228.6mm** (18", replaces both the old 609.6mm and the briefly-discussed 480mm custom size — 18" is now FINAL, no more changes) |
| Wheel tread width | 200mm |

**IMPORTANT — intentional 100mm gap, do not "fix" it:** the firebox
top (1000mm) intentionally sits 100mm ABOVE today's real apex-A/grate
line (900mm). This is deliberate — Janis is reserving that gap for a
FUTURE reinforcement frame at chamber face A-B plus a correspondingly
shorter door, both explicitly deferred to a later session. Do not
close this gap, do not treat it as a defect, do not alter apex A or
the grate to match. State the gap explicitly in your own verification
(expect ~100mm, confirm the real number) rather than silently
resolving it.

**Chamber itself stays completely frozen** — `true_octagon_profile()`,
apex A, the grate/grill surface, chamber_L/chamber_W: zero changes.
Only the firebox (a separate sub-assembly under the chamber) and its
new internal cylinder change.

## 3. NEW FILES

None. New `BBQ-chambers-v12.scad` (source v11) and
`BBQ-understructure-v4.scad` (source v3).

## 4. TASKS

### TASK 1 — Firebox rebuild (BBQ-chambers-v12.scad)

Resize `firebox_shell()` (and everything parented to it — door, ash
tray, fire grate placeholder) from the current 457mm cube to the real
dimensions above: length(X)=460mm, width(Y)=510mm, height(Z)=428.6mm,
top_Z=1000mm/bottom_Z=571.4mm (world). Keep the firebox centered on
its current X-midpoint (real ~1.5mm shift only, state the actual
before/after numbers).

Real interference check required: confirm the enlarged firebox
doesn't newly collide with anything else in the chambers file (grate
support, exhaust room, etc.) at the new dimensions — state the check
explicitly.

Existing door/damper/ash-tray sub-features: resize/reposition to
follow the new outer shell proportionally, state your approach and
flag any judgment call. Fire grate placeholder inside the firebox:
**REMOVE ENTIRELY** — replaced by the new fuel cylinder (Task 2), not
rebuilt at the new size.

### TASK 2 — Internal fuel cylinder (BBQ-chambers-v12.scad)

New solid: a cylinder, wall thickness 3mm, real diameter 388.6mm
(state your own re-derivation confirming this number against the
ACTUAL rebuilt firebox height/width from Task 1 — if Task 1's real
built numbers differ even slightly from the 428.6/510 table above,
recompute the cylinder diameter from the REAL numbers, don't just
copy 388.6mm blindly).

Position: centered in Y (chamber/firebox Y-center), vertically
centered within the firebox's real internal height. Length along X:
flush with the firebox's rear/door-side internal face (so the door,
when closed, touches the cylinder's open face) — the opposite (far)
end is open/unfinished per Janis, flag explicitly as an open item for
a future prompt, do not add an end cap or additional detail there
beyond what's structurally necessary.

Real CGAL check: minimum 100mm-intent gap is now superseded by the
actual computed clearance (20mm smaller-axis, ~60mm+ larger-axis per
the diameter formula) — state the REAL gap on all sides explicitly,
confirm the cylinder doesn't touch/intersect the firebox's own inner
wall anywhere.

### TASK 3 — Wheel size correction + world-Z re-anchor (BBQ-understructure-v4.scad)

```
WHEEL_D = 457.2   // 18" — FINAL, locked, no further changes
WHEEL_R = 228.6
TREAD_W = 200
```

Single source, both rear axle wheels and the front caster's two wheels
(from v3) consume it.

**Mandatory real check before any other math in this task:** Janis
flagged suspicion that the wheel's bottom may NOT actually sit at
world Z=0 in the current live file (i.e. the wheel might be floating
above or sunk below true ground). State the REAL current
`REAR_AXLE_Z` and confirm explicitly: does `REAR_AXLE_Z − WHEEL_R`
(old radius) equal 0? If not, state the real offset found and correct
it as part of this task — world Z=0 must equal the wheel's own
ground-contact point, full stop, this is the anchor everything else in
future prompts will be checked against.

Recompute `REAR_AXLE_Z` (= new `WHEEL_R`, once confirmed anchored to
real world Z=0) and `REAR_BRACKET_H` (= `firebox_floor_z` (from the
NEW Task 1 firebox bottom_Z, 571.4mm real value) − `REAR_AXLE_Z`).
State the real recomputed strut height.

Front caster wheels (from v3's dual-wheel rebuild): same `WHEEL_D`/
`WHEEL_R`, same re-anchor requirement — confirm front wheel bottoms
also land at world Z=0 after this change.

**Explicitly NOT in scope this round** (do not attempt, will be a
follow-up prompt once this merges and real numbers are confirmed):
front axle span/parallelism vs. the new firebox width, spacer
brackets (front/rear), T-bar handle rebuild, front bracket height
alignment to the new firebox bottom.

## 5. DO NOT TOUCH

- `true_octagon_profile()`, apex A's own coordinates, the grate/grill
  surface, `chamber_L`/`chamber_W` — chamber itself is completely
  frozen, zero changes
- Front bracket's own leg/bottom-plate geometry (`MID_H`/`TOP_W`/
  `BOT_W`/`LEG_GAP`/`LEG_DROP`/`FRONT_X`) — untouched this round,
  alignment to the new firebox height is a follow-up prompt
- Front axle span, spacer brackets, T-bar/tow-handle geometry — all
  explicitly deferred to the follow-up prompt (see Task 3 scope note)
- Exhaust room, chimney, lid — unrelated to this round, read only if
  needed for the Task 1 interference check, zero changes
- rules-dimensions.md, cc_rules.md — read only (note:
  design_scope_of_work_rule.md's Envelope/Compartment Map sections DO
  need updating this round, see Mandatory Closing — that file is not
  in this read-only list)

## 6. QA VERIFICATION

- [ ] Real local apex-A-to-grate distance stated from the live file
      (Task-specific read #1) — confirmed ~0mm or flagged if different
- [ ] Firebox resized to real length/width/height stated explicitly,
      before/after X-midpoint shift stated
- [ ] Fire grate placeholder removed entirely — confirmed, not just
      hidden
- [ ] Firebox real interference check vs. rest of chambers file —
      stated explicitly, empty/clear confirmed
- [ ] Cylinder diameter re-derived from the ACTUAL rebuilt firebox
      numbers (not blindly copied from this prompt's table) — real
      value stated
- [ ] Cylinder real clearance to firebox inner walls stated on all
      sides, confirmed non-intersecting
- [ ] Cylinder flush to firebox rear/door-side face confirmed; far end
      status stated explicitly as an open/deferred item
- [ ] 100mm gap between firebox top (1000mm) and today's real apex-A/
      grate line (900mm) stated explicitly and NOT closed
- [ ] `WHEEL_D`/`WHEEL_R`/`TREAD_W` = 457.2/228.6/200, single source,
      rear + front caster both consume it
- [ ] World-Z anchor check: real current (pre-fix) `REAR_AXLE_Z −
      WHEEL_R` stated explicitly — confirmed 0 or corrected
- [ ] Post-fix: rear AND front wheel bottoms both confirmed at world
      Z=0
- [ ] `REAR_BRACKET_H` recomputed from the NEW firebox bottom_Z
      (571.4mm) and NEW `WHEEL_R` — real number stated
- [ ] Full CGAL manifold sweep, `Simple: yes` on every solid (both
      files)
- [ ] Full kinetic sweep (door, lid, tray, shelf, existing understructure
      kinetics) — `Simple: yes` throughout
- [ ] 4-angle screenshots (iso/front/side/rear) of the combined
      assembly, PLUS one dimensioned side-view showing grate_Z, apex-A
      Z, firebox top/bottom Z, and wheel-ground contact Z all labeled
      with real numbers
- [ ] Error-Log clean, both files

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at top, under 10 lines: state
   real firebox before/after dimensions, real cylinder diameter used,
   the world-Z anchor finding (was it already correct or did it need
   fixing, real numbers either way), new REAR_BRACKET_H, and confirm
   the intentional 100mm apex-A/firebox-top gap explicitly.
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-18
3. Update knowledge.map, PART_MANIFEST.md, SKELETON_WORKSHEET.md for
   the rebuilt firebox + fuel cylinder + corrected wheel size
4. Update `bbq-offset-smoker/design_scope_of_work_rule.md`'s Envelope
   and Compartment Map sections: new firebox dimensions, new internal
   fuel cylinder (replaces old fire-grate description), wheel size
   457.2mm/18" (final), note the deferred 100mm reinforcement-frame/
   shorter-door item explicitly as a flagged future task
5. Save as BBQ-chambers-v12.scad (v11 kept) and
   BBQ-understructure-v4.scad (v3 kept); update
   BBQ-offset-smoker-base-v1.scad's includes v11→v12 and v3→v4
6. Commit all → merge to main
