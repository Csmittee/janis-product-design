# cc Prompt — Acrylic Step Fix, Door Curve/Pole Mismatch, Hinge Rod Removal, Lock System Provision
# Date: 2026-07-09
# Session goal: four related left-door-assembly fixes, one round, in the
# order below. This is a FRESH session — the prior direct-chat session
# with Janis on this same topic became stuck on cloud container resume
# and was abandoned; treat all of the below as new instructions, not a
# continuation of anything mid-flight in that stuck session.
# Active file: whatever is on main when this runs (v56 or later — confirm
# and state which, per CC INTRO below).

## 1. CC INTRO

Session continuity check: this is a NEW session regardless of any prior
session state — the previous direct-chat session hung indefinitely on
cloud container resume and was abandoned before anything was committed.
Treat as FRESH.

git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → knowledge.map → cc_chat_log.md (first 3
entries) → rules-dimensions.md → PART_MANIFEST.md (VM-01) → the current
committed `VM-01-base-vXX.scad` on main. State every file read and the
exact current version number before writing a single line — do not
assume it's v56, confirm.

Claude Web override: none.

## 2. CONTEXT

Janis's end goal, stated directly: **no visible step on the acrylic
pane** — it should read as one smooth, continuous, flush surface from
the front, not a stepped/offset assembly. Four related issues, to be
fixed in the order below, because later tasks depend on earlier ones
being resolved first (do not reorder or parallelize):

**Background — acrylic step (confirmed real, not a rendering artifact):**
Janis's own `show_acrylic=false` test proved BOTH lines of the "double
sheet" appearance disappear together when the acrylic is hidden — this
rules out the door leaf's own material thickness as the cause (that
theory was tested twice by cc and was wrong both times, see
`rules-dimensions.md`'s acrylic history). Both lines belong to the
acrylic assembly itself: the pane's own front edge, plus a mounting
border/step where it meets its frame lip. This is a real double-offset,
not a single clean recess.

**Background — door curve mismatch (confirmed via top AND bottom view):**
The door's return-flange curve does not land smoothly into the left
shell wall (`show_shell_left`'s wall) — it terminates short and steps
sideways to meet the wall instead of sweeping into it as one continuous
line. Janis has ALREADY APPROVED moving the hinge outside the frame
(this was done in v43) — meaning there is real freedom to adjust hinge
position (`hinge_x`/`hinge_y`) and/or the door curve's own radius to
make the two curves tangent, without needing Janis's separate
re-approval for that specific adjustment.

**Background — hinge rod (design flaw, not a manifold-only issue):**
The current `hinge-pivot reinforcement cylinder` (added v50, `hinge_od`=
12mm, full `door_h` height, sitting at the door's local rotation origin)
is a single continuous barrel running the entire door height, sitting
right at the shell's exterior corner. Janis's assessment, which this
prompt accepts as the design direction: this is not how real hinge
hardware works (a real hinge is a mating pair of fixed/dynamic knuckles
with real gaps, not one continuous rod) and its presence right at the
corner has been the recurring source of collision ambiguity in this
project (v52 arithmetic misattribution, v55 "ruled out", now suspected
again as part of the curve-mismatch investigation). Full knuckle-hinge
hardware is a SEPARATE, LATER task (deliberately deferred — do not
attempt it this round, too much placement precision risk to combine with
the other three tasks). This round only removes the rod and preserves
the PURE MATHEMATICAL PIVOT POINT the door's rotation already depends on.

**Background — lock system:** no lock/latch hardware exists in the
current file at all. This round only needs to PROVISION for one (reserve
space/mounting reference), not fully design or model it — see Task 4
scope note.

## 3. NEW FILES

None required unless cc judges a separate file is clearly cleaner for
the lock-provision placeholder (state reasoning if so). All other work
edits the existing `VM-01-base` file in place, saves as the next version
number (confirm from `git pull`, do not assume).

## 4. TASKS — IN THIS ORDER, DO NOT REORDER

### TASK 1 — Fix the acrylic step (no visible step, flush recess only)

Root cause to confirm first (do not assume): locate the acrylic's own
mounting border/step geometry — the element that creates the SECOND
offset beyond the acrylic's own single intended recess. State explicitly
in cc_chat_log which module/lines create this second step.

Fix approach, as directed by Janis — implement, do not re-decide:
**shift the front shell window cutout DOWN, or increase the top border
size**, whichever actually eliminates the step at the TOP edge
specifically (Janis's own words: "shift the front shell window cut down
or larger top border so acrylic will have not step on top edge"). Try
both if needed to determine which one actually resolves it without side
effects — state which was used and why.

End state required: the acrylic sits in ONE single, uniform, flush
recess relative to the door's front metal skin — no second border/step
visible from any angle. Re-verify via a real top-down render (not just
arithmetic) that only one edge-pair is visible, matching Janis's own
"single sheet, smooth continuous surface" description from earlier in
this project's history.

Do NOT touch `window_x0`/`window_z0`/`window_w`/`window_h` (the window
OPENING itself) unless the fix genuinely requires it — if it does,
state explicitly why the border-only approach was insufficient.

### TASK 2 — Fix door curve / pole mismatch with the left shell wall

Confirm the curve's actual current termination point vs. the shell
wall's own start point (Janis's own screenshots showed a real gap, not
a rendering artifact — do not re-litigate whether the gap is real).

Fix by adjusting hinge position (`hinge_x`/`hinge_y`) and/or the door
curve's own radius so the door's return-flange curve sweeps smoothly
into the shell wall's own flat face — genuinely tangent, not just
visually close. Since the hinge is already approved to sit outside the
frame, you have freedom here — use it.

**Investigate as part of this same task, do not treat as separate:**
whether this adjustment frees additional X-room for the frame's own
corner pole (`tray_zone_frame()`'s left vertical bar). Do NOT assume
this side benefit exists — verify it against the frame's own curve
radius, which is already maxed at 14mm before it re-hits the door (per
prior finding). If adjusting the door curve does NOT free frame X-room,
say so plainly rather than forcing a change there.

**Sequencing condition on Task 1:** if this fix changes the door's own
X-offset or curve shape in a way that affects the acrylic's step fix
from Task 1, redo Task 1's check AFTER this task, not before — confirm
in cc_chat_log whether Task 1's fix needed re-verification after Task 2.

Re-verify: full angle sweep (9-angle minimum, same convention as prior
sessions) against the door leaf, zero overlap required at every angle.

### TASK 3 — Remove the hinge-pivot rod entirely (not a toggle)

This is a REMOVAL, not a toggle addition — do not add a `show_hinge_rod`
boolean or similar. Delete the cylinder geometry (`hinge_od`-diameter,
full `door_h` height) from `left_zone_door()` entirely.

**Preserve the pivot point as pure rotation math only:** the door's
`translate([hinge_x, hinge_y, hinge_z]) rotate([0,0,-door_open_angle])`
transform must continue to work exactly as before — `door_open`/
`door_open_deg` animation is UNCHANGED. `hinge_x`/`hinge_y`/`hinge_z`
remain live named constants, used purely as the rotation origin — no
physical solid geometry at that point.

**Record the pivot point as a protected/locked reference in
`rules-dimensions.md`:** add or update a clearly labeled entry — e.g.
"HINGE PIVOT POINT — LOCKED REFERENCE, DO NOT MODIFY WITHOUT
RE-VERIFYING TASK 2's CURVE TANGENCY" — stating the exact final
`hinge_x`/`hinge_y`/`hinge_z` values from Task 2 above, explicitly
flagged so a future session doesn't casually change them without
re-checking the curve-tangency work this session did.

Re-verify: zero manifold warnings, full angle sweep, after the rod's
removal — a rod's removal should only ever reduce collision risk (a
dimensionless point cannot collide with anything), but confirm this
explicitly rather than assuming it.

### TASK 4 — Provision (not implement) a new lock system

Scope: this is a PLACEHOLDER/reservation task, not full lock hardware
design. Reserve a clearly marked mounting location/opening on the door
leaf and the adjacent shell/frame structure suitable for a future
lock/latch mechanism (e.g. a simple rectangular recess or boss position
at a sensible location — front-facing, reachable, not conflicting with
the flap, window, or hinge-side geometry).

If any specific requirement (lock type, exact position, dimensions) is
not something you can determine from existing project files, DO NOT
invent one — flag it explicitly in cc_chat_log as needing Janis's input,
and provision the most conservative/generic placeholder (e.g. a simple
rectangular recess sized for a common cabinet lock, clearly commented as
"PLACEHOLDER — dimensions/position not yet confirmed by Janis") rather
than guessing at final hardware.

## 5. DO NOT TOUCH

- `tray_zone_frame()`'s crossbar/right-vertical/flange geometry, beyond
  whatever X-room investigation Task 2 explicitly requires — no
  unrelated changes
- `compartment_divider()` — isolated finding, no observed full-assembly
  impact, out of scope this round (see rules-dimensions.md)
- `tray_compartment_partition()`, `exit_compartment_wall()`,
  `drop_zone_guards()`, `sensor_strip()` — already fixed/confirmed in
  prior sessions, do not re-touch
- Right compartment (`acrylic_display()`, `dashboard()`) — out of scope
- Full knuckle-hinge hardware (top/mid/bottom mating pairs) — explicitly
  DEFERRED to a separate future session, do not attempt this round
- Any PR-01 file

## 6. QA VERIFICATION

- [ ] Root cause of the acrylic's second step/border identified and
      stated explicitly (module/lines named)
- [ ] Acrylic step fix implemented (window cut shifted down, and/or top
      border enlarged) — state which, and why
- [ ] Real top-down render confirms only ONE edge-pair visible on the
      acrylic — no second step, from at least 2 angles
- [ ] Door curve now tangent (not just visually close) to the left shell
      wall — confirmed via real geometry check, both top AND bottom view
      screenshots
- [ ] Frame corner-pole X-room investigated — result stated explicitly
      (freed up, or not, with the 14mm max-radius constraint checked)
- [ ] Task 1's acrylic fix re-verified after Task 2 if Task 2 changed
      door X-offset/curve — stated explicitly either way
- [ ] Hinge-pivot cylinder geometry fully deleted — confirmed via source
      diff, not just a toggle
- [ ] Door open/close animation confirmed unchanged (door_open_deg sweep
      still works identically) after rod removal
- [ ] Pivot point recorded in rules-dimensions.md as a locked/protected
      reference with final hinge_x/hinge_y/hinge_z values
- [ ] Lock system placeholder added, clearly marked as provisional, OR
      explicitly flagged as needing Janis's input if no reasonable
      placeholder could be determined
- [ ] Full-assembly manifold check: zero warnings across a 10-angle sweep
      (0-100°) — confirm this explicitly covers ALL FOUR changes above,
      not just the rod removal
- [ ] No new manifold warnings introduced by any of the 4 tasks
- [ ] Version incremented correctly from whatever was confirmed on main
      at session start (see CC INTRO) — old version untouched

## 7. MANDATORY CLOSING

1. Prepend `cc_chat_log.md` — newest entry at TOP, under 10 lines:
   acrylic step root cause + fix, curve tangency fix + X-room finding,
   rod removal confirmation, pivot point now locked in rules-dimensions,
   lock provision status (placeholder added or flagged for Janis), full
   10-angle manifold sweep result
2. Archive this prompt → `/prompts/archive/`
3. Update `knowledge.map` if any new module/constant warrants a note
4. Bump `rules-dimensions.md` version — must include the new locked
   pivot-point entry from Task 3
5. Commit all → merge to main
