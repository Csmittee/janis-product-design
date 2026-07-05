# cc Prompt — Tray Compartment Access Gap, Acrylic/Metal Split, H-Frame Flange
# Date: 2026-07-05
# Session goal: three related door/tray-compartment fixes on top of v44, in one round
# Active file: VM-01-base-v44.scad → save as VM-01-base-v45.scad

## 1. CC INTRO
git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → cc_chat_log.md (first 3 entries) → rules-dimensions.md → VM-01-base-v44.scad
State every file read before writing a single line.
Confirm VM-01-base-v44.scad is present on main (Janis confirms PR #85/v43 merged;
v44 build already reported DONE by cc — confirm its actual file/module names below,
do not assume they match the v44 prompt's suggested names verbatim).

## 2. CONTEXT
Janis reviewed v44 renders. The mandated v44 test plan (sensor deletion, acrylic
toggle fix, H-frame rebuild + curve, door window resize, 9-angle CGAL sweep) all
PASSED — no regressions there, do not touch that work except where explicitly
listed below. However, three additional issues were found in this QA round that
were outside v44's original scope:

1. A customer's hand can currently reach under the lowest spring tray into the
   tray compartment from the exit zone — no wall/floor blocks it.
2. The acrylic pane currently covers the ENTIRE front door. It should only cover
   the upper portion (from the door's current upper boundary down to the lowest
   tray's floor level) — the lower portion, near the flap, should be a plain
   metal sheet, not acrylic.
3. The H-shaped frame (rebuilt in v44) has no flange at its top or bottom for
   spot-welding it to the shell.

## 3. NEW FILES
None — new modules go inside VM-01-base-v45.scad. Add to knowledge.map if cc
judges a separate file is cleaner (state reasoning if so).

## 4. TASKS

### TASK 1 — Tray compartment access gap (two new/modified parts)

Introduce two clearly named, clearly distinct parts — use these exact names
verbatim in the source and in cc_chat_log, do not rename:

**`tray_compartment_partition()`** — NEW horizontal panel.
- Spans the FULL width and depth of the tray compartment (edge-to-edge).
- Fixed/welded — not a removable/access panel.
- Positioned at the CURRENT (pre-shift) lowest-tray floor reference — i.e. this
  panel's Z stays at whatever Z the lowest tray's floor sits at TODAY, in
  v44. This is the new unchanged baseline. Do not derive it from the post-shift
  tray position — it's the anchor the trays move away from.

**`exit_compartment_wall()`** — MODIFY existing vertical partition / side
bracket that holds the flap stopper (identify the actual existing module in
v44 source — likely part of `drop_zone_guards()` or its own edge bracket;
state which one it is in cc_chat_log).
- Extend it downward so it meets `tray_compartment_partition()` with ZERO gap
  — fully sealed, no hand-pass-through between the exit zone and the tray
  compartment below the lowest tray.

**Tray stack shift**: Move the ENTIRE spring tray stack (all trays, all rows)
UP by exactly 100mm from their v44 Z position. This applies to BOTH the 2x5
and 3x5 tray-count variants if the file parametrizes tray row count — confirm
which variant(s) exist in source and apply the shift to all of them uniformly.
State explicitly in cc_chat_log: old lowest-tray-floor Z, new lowest-tray-floor
Z, and confirm the delta is exactly 100mm.

**Mandatory clearance check**: After the 100mm shift, compute and report the
clearance between the TOP tray (3rd row, in whichever variant has 3 rows) and
the upper zone / dashboard boundary. State the exact clearance value (not
"looks fine") — must be positive (no collision) with room to spare. If it is
NOT positive, stop and flag — do not silently shrink anything else to
compensate.

### TASK 2 — Acrylic / metal panel split

Identify the current door acrylic module (from v44, gated by `show_acrylic`
+ `render_mode`). Split it into two parts on the door:

**Upper portion** — acrylic, unchanged from its current upper boundary,
extending DOWN to `tray_compartment_partition()`'s reference — no, correction:
extends down to the lowest tray's floor level AFTER the 100mm shift (i.e. the
NEW lowest-tray-floor Z, not the pre-shift baseline used for the partition).
This is a live reference to the tray stack's actual current position, not a
hardcoded number — if the tray shift value ever changes again, this boundary
should move with it. State the exact Z value used and confirm it's derived
from the same constant driving the tray stack position, not duplicated as a
separate magic number.

**Lower portion** — replace with a plain flat metal sheet (no acrylic
material/transparency), same border/frame convention as the current acrylic
mounting, extending from the acrylic split point down to the flap area.
No vents, no cutouts, no branding — plain flat panel.

Keep both under the same `show_acrylic` / `render_mode` toggle logic already
fixed in v44 — do not reintroduce the v43 toggle bug.

### TASK 3 — H-frame flange

On the H-shaped frame (`tray_zone_frame()`, rebuilt in v44): add a flange at
the TOP and a flange at the BOTTOM, 10mm each, for spot-welding to the shell.
Confirm placement doesn't reintroduce the v43-style collision with the door
leaf — re-run the same CGAL collision sweep (see Task 4).

### TASK 4 — Mandatory re-verification

Because the tray stack, frame, and acrylic geometry all changed, re-run the
full 9-angle CGAL collision sweep from v44
(`intersection(){tray_zone_frame(); left_zone_door();}` at
door_open_deg = 0,20,25,30,35,40,45,70,100) and report facet/volume count (or
"empty") at EVERY angle. Zero non-empty results required at all angles.

## 5. DO NOT TOUCH
- Sensor deletion, acrylic render_mode toggle logic, H-frame curved/inset left
  edge, door window resize — all v44 work already QA-PASSED, do not regress
- `rules-dimensions.md` — read for context, but only add/update the specific
  new values from this prompt (tray shift, partition dims, flange dims,
  acrylic split Z) — do not touch unrelated rows
- Any VM-1.1/VM-1.2/Satu variant files — not in scope, none exist yet
- Any PR-01 file
- `.claude/rules-waivers.md`, `CURRENT_STATE.md` — unrelated to this prompt

## 6. QA VERIFICATION
- [ ] `tray_compartment_partition()` spans full width/depth, fixed/welded,
      positioned at the v44 (pre-shift) lowest-tray floor Z — state that Z value
- [ ] `exit_compartment_wall()` (state which existing module it extends)
      meets the partition with confirmed ZERO gap — measured, not eyeballed
- [ ] Entire tray stack shifted up exactly 100mm — state old Z, new Z, delta,
      for lowest tray; confirm applied uniformly to 2x5 and/or 3x5 variants
- [ ] Top-tray-to-upper-zone clearance after shift stated explicitly as a
      number, confirmed positive, for the 3-row variant
- [ ] Acrylic upper portion unchanged at top, now ends at the POST-shift
      lowest-tray-floor Z — state that Z value and confirm it's a live
      reference to the same constant driving the tray position, not a
      duplicated magic number
- [ ] Lower metal panel: plain flat sheet, correct border convention, spans
      from acrylic split point to flap area
- [ ] H-frame flange: 10mm top AND bottom, confirmed via measurement
- [ ] 9-angle CGAL collision sweep re-run, zero non-empty results at all 9
      angles — report each angle's result explicitly
- [ ] No undefined-variable or manifold warnings on full render
- [ ] Version incremented v44 → v45, v44 untouched

## 7. MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP, under 10 lines, MUST include
   the tray-shift Z values, the top-tray clearance number, and the 9-angle
   sweep results
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Update knowledge.map if needed
4. Bump version on all changed files (rules-dimensions.md, etc.)
5. Commit all → merge to main
