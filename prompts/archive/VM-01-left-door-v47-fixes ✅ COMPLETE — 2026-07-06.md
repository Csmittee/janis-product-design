# cc Prompt — Left Door Assembly QA Fixes (post-v47)
# Date: 2026-07-06
# Session goal: consolidate all confirmed v47 QA findings into one round.
# Active file: VM-01-base-v47.scad → save as VM-01-base-v48.scad
# Scope: LEFT main spring-compartment door assembly only. Right compartment
# (acrylic_display(), dashboard()) is NOT in scope this round.

## 1. CC INTRO
git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → cc_chat_log.md (first 3 entries) → rules-dimensions.md → VM-01-base-v47.scad
State every file read before writing a single line.
Confirm VM-01-base-v47.scad (PR #89) is on main — Janis confirms merged.

## 2. CONTEXT

Janis did her own F5/F6 QA pass on v47 and found four confirmed issues, all
on the LEFT door assembly. Known 2-manifold warning is explicitly DEFERRED
by Janis this session — do not attempt to fix it, flag only if a NEW one
appears from this prompt's changes.

## 3. NEW FILES
None. Edits VM-01-base-v47.scad in place, saves as v48.

## 4. TASKS

### TASK 1 — `sensor_strip()` still pokes through closed door

Root cause: `strip_x0`/`strip_x1` put the strips' front Y-edge at
`skin_t + e` (≈2.01mm) — this module was never updated when
`drop_zone_guards()` got its door-clearance fix in v47. Fix: apply the
SAME reference constant `drop_zone_guards()` now uses (`world_arc_cy + e`,
≈21.01mm) to `sensor_strip()`'s front Y-edge, so both strips clear the
door leaf identically. Re-verify with the same 9-angle sweep
(door_open_deg 0/20/25/30/35/40/45/70/100) + fine 0.5° sweep used for the
other door-clearance fixes. Zero overlap required at every angle.

### TASK 2 — `tray_compartment_partition()` reopened a reach-through gap

Root cause: v47 pulled the partition's front edge back to Y=526mm purely
to avoid overlapping `tray_zone_frame()`'s footprint — this left the
compartment under the vacated tray-0 space (Y≈21–526mm) uncovered.
Janis confirmed via render (see attached screenshot description: "close
this compartment under the spring tray") that this must be a fully sealed
compartment, not just safe-by-margin.

Fix: rebuild `tray_compartment_partition()` so its front edge extends
forward as far as physically possible — right up to `exit_compartment_wall()`
(zero gap, real contact, not just proximity) — by routing AROUND the
actual footprint of `tray_zone_frame()`'s vertical bars at Z=tray_0_z,
rather than pulling the entire partition back by an oversized uniform
margin. Use whatever construction (difference(), split geometry, etc.)
actually achieves a fully sealed compartment with zero unintended overlap
with the frame's real footprint at that Z-plane — verify with real
geometry (contact receipt), not a blanket safety margin. State the final
Y-range used and the confirmed clearance/contact numbers explicitly in
cc_chat_log.

### TASK 3 — Acrylic/metal split: material realism + collision + flap clearance

All in `left_zone_door()`'s acrylic/metal split (v46 TASK 2 area).

**3a. Differentiate real material thickness.** Both pieces currently reuse
`door_t` (3mm) for their Y-depth. Introduce a new named constant for real
acrylic sheet thickness (5mm) and apply it ONLY to the acrylic piece's
Y-dimension. The metal panel stays at `door_t` (3mm, sheet-metal spec) —
do not rename or alter `door_t` itself, it's used elsewhere.

**3b. Pull the acrylic's top boundary down.** Currently `win_z1 +
acrylic_border` reaches world Z=698mm — the door's absolute top edge,
zero clearance. Janis confirmed this creates a collision risk: with real
5mm acrylic (from 3a) plus tolerance, if the inner frame (`tray_zone_frame()`)
isn't offset far enough from the front plane at that height, closing the
door collides. Janis's explicit direction: reduce the acrylic's Z-extent
from the top so only the thinner metal panel (not the thicker acrylic)
occupies the zone nearest the frame's collision-critical region — the
resulting larger top border is acceptable/desired. Derive the exact
clearance needed from the LIVE frame-to-door-face offset (real geometry
check, not a guessed number) and state it explicitly in cc_chat_log,
along with the resulting acrylic top Z and new top border thickness.

**3c. Flap clearance.** Janis confirmed via render inspection that the
acrylic/metal assembly's Z-length currently extends down far enough to
physically block the exit flap when it opens (her words: "the hidden
acrylic paste on back blocking the flap door"). Check the panel assembly's
lower Z-extent against the flap's full swept volume at `flap_open_deg` from
0 to its max (55°) and adjust whichever boundary is causing the overlap so
the flap has zero-collision clearance through its full opening range.
Verify via geometry sweep across the flap's opening angles, not visual
inspection alone.

**3d. Flap plane constraint.** Per Janis: the exit flap should sit flush
in the same plane as the metal sheet — no additional inner-frame-style
offset/stacking at the flap's location, since there is no inner frame
layer behind the door panel at that spot. Confirm in cc_chat_log whether
this is already true in the current geometry or required an adjustment as
part of 3c.

### TASK 4 — New isolation toggle for shell trim/joggle feature

Second door-closed collision (frame trim/joggle line at the right body
edge, screenshots this session) is NOT YET root-caused. Janis suspects
it originates in the shell (`outer_shell_debug()`'s recess pocket /
hinge-side trim), not `tray_zone_frame()` or `drop_zone_guards()` (both
already fixed and confirmed clean in v47). Per isolation-before-fix
discipline: do NOT attempt a blind fix this round.

Identify the actual shell sub-feature responsible for the trim/joggle line
Janis is describing — she indicates there is a top sub-piece AND a bottom
sub-piece, and neither is currently controllable independent of
`show_frame`/`show_door`. Add a dedicated isolation toggle (name it per
existing `show_*` convention) that hides BOTH sub-pieces of this shell
feature independently, so Janis can isolate shell-vs-door collision
visually in her next QA pass. State explicitly in cc_chat_log which
module/feature/lines this toggle controls — do not force-fit an existing
module if it doesn't actually match; flag if genuinely uncertain rather
than guessing.

## 5. DO NOT TOUCH

- `tray_zone_frame()`'s own already-verified geometry (v44-v46, door
  clearance re-confirmed v47) — TASK 4 only ADDS a toggle for a DIFFERENT
  (shell) feature, does not modify the frame itself
- `drop_zone_guards()` — already correctly fixed in v47, zero change
- Right compartment: `acrylic_display()`, `dashboard()` — out of scope
- Known 2-manifold warning — explicitly deferred by Janis this session;
  do not fix, only flag if a NEW warning appears from this prompt's changes
- Any PR-01 file
- `CURRENT_STATE.md`, `.claude/rules-waivers.md` — unrelated

## 6. QA VERIFICATION

- [ ] `sensor_strip()` front edge now uses the same door-clearance
      reference as `drop_zone_guards()` — state exact value used
- [ ] Re-swept 9 angles + fine 0.5° sweep for sensor_strip-vs-door — ZERO
      overlap at every angle, reported explicitly
- [ ] `tray_compartment_partition()` extended to zero-gap contact with
      `exit_compartment_wall()` — state final Y-range
- [ ] Confirmed zero overlap between partition and `tray_zone_frame()`'s
      REAL footprint (not a blanket margin) — state the construction used
      and the confirmed clearance
- [ ] New acrylic-thickness constant introduced (5mm), applied ONLY to the
      acrylic piece; metal panel confirmed unchanged at door_t (3mm)
- [ ] Acrylic top boundary pulled down — state exact new Z, new top border
      thickness, and the frame-offset number that drove the calculation
- [ ] Confirmed zero collision risk between acrylic (post-3b) and
      `tray_zone_frame()` at door_open_deg=0
- [ ] Flap swept-volume check (0–55°) against the acrylic/metal assembly —
      state before/after overlap status and any boundary changed
- [ ] Flap-to-metal-sheet plane constraint confirmed (flush, no extra
      offset) — state explicitly true or adjusted
- [ ] New shell-trim isolation toggle added, name stated, confirmed hides
      BOTH top and bottom sub-pieces, independent of show_frame/show_door
- [ ] No NEW undefined-variable or manifold warnings introduced (pre-
      existing warning explicitly out of scope, do not report as new)
- [ ] Version incremented v47 → v48, v47 untouched

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at TOP, under 10 lines, MUST
   include: sensor_strip fix value, partition final Y-range + clearance
   method, acrylic thickness constant + new top Z, flap clearance
   before/after, shell-trim toggle name
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-06
3. Update knowledge.map if new constants/toggle warrant a note
4. Bump version on rules-dimensions.md (new acrylic thickness constant,
   updated partition/acrylic Z values) and any other changed files
5. Commit all → merge to main
