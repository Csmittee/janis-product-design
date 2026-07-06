# cc Prompt — Left-Front-Corner Redesign: Remove Shell Pole, Rebuild Frame,
# Widen Shell for Spring-Tray Clearance, Reinforce Door Pivot
# Date: 2026-07-06
# Active file: VM-01-base-v48.scad → save as VM-01-base-v49.scad

## 1. CC INTRO
git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → cc_chat_log.md (first 3 entries) →
rules-dimensions.md → PART_MANIFEST.md → VM-01-base-v48.scad
State every file read before writing anything. Confirm v48 (PR #90) is
on main before starting.

## 2. CONTEXT

Janis removed `tray_zone_frame()` entirely from her render this session
to isolate the door-vs-shell collision from Task 4 of the last prompt
(which cc could not root-cause). With the frame gone, a thin vertical
"pole" of shell material remains at the left-front corner, exactly where
the door closes against it — confirmed colliding with the door by direct
visual isolation (screenshots this session). This is very likely leftover
shell geometry from before the door's hinge was shifted off the actual
corner to its current offset position (`HINGE_Y_OFFSET`=25mm) — a shift
made specifically so the door could open wide enough to pull the spring
trays for refilling without obstruction. When the hinge moved, the shell's
corner treatment was apparently never fully reconciled to the new hinge
position.

Separately, Janis's own isolation testing (pulling the spring trays out
in the current render) found `tray_zone_frame()`'s vertical bars physically
overlap the outermost spring coils' footprint (lane 0 on the left, lane 4
on the right) when the trays slide toward the front — confirmed by rough
geometry check this session: lane 0 sits around world X 13-79mm, the
frame's left bar around X 7-27mm (~14mm real overlap); lane 4 sits around
X 329-395mm, the frame's right bar around X 389-409mm (~6mm real overlap).
These are approximate hand-checks only — cc must re-derive exact figures
from live geometry, not reuse these numbers directly.

Janis's design decision for this round (approved, proceed — not asking
you to re-litigate the decision, only to execute it correctly):
- Remove the redundant corner shell material (the "pole") entirely rather
  than trying to inset/notch it — not practical in real sheet-metal
  forming to inset an already-formed rounded corner.
- Rebuild `tray_zone_frame()` to be the SOLE reinforcement at that corner:
  thinner bars, but extended to make REAL contact with the housing
  (left: touches the shell, wraps the round corner where the pole used to
  be; right: touches `compartment_divider()`'s wall) instead of floating
  with a gap as it does now.
- Widen the shell enough that the new frame + full spring-tray travel
  never collide, verified live, not guessed.
- Add reinforcement along the door's own hinge pivot line, to carry the
  structural role the removed corner pole used to carry, from the door
  side.

Also flagging two carried-over open items from v48 (PR #90), not
necessarily to fix in this same prompt but to keep in view since this
redesign may affect both:
- The acrylic/metal assembly's overlap with `tray_zone_frame()` grew
  (17,412mm³ → 22,091mm³) when the acrylic got its real 5mm thickness —
  flagged, needs an owner decision on acrylic border/mounting depth,
  independent of this prompt's scope but may shift once the frame itself
  is rebuilt here.
- A NEW protrusion was found this session where the lower tray partition
  welds to the exit-compartment back wall — a thin edge appears to poke
  past the shell's left wall (screenshots this session, arrow shows a
  sliver sticking out past the left surface). NOT in scope for this
  prompt — flag as a known open item in cc_chat_log for a future round,
  do not attempt to fix it here.

## 3. TASKS

### TASK 1 — Identify and remove the corner shell pole

Read `outer_shell_debug()` / `outer_shell()` and the left-side-wall recess
cutout (`shell_return_depth` region, added v43 TASK 3) carefully. Find the
exact geometry responsible for the thin vertical "pole" of remaining shell
material at the left-front corner that Janis confirmed collides with the
closed door (screenshots this session — a distinct thin vertical sliver
between the door's front face and the shell's angled corner wall).

Do NOT assume it's the same recess cutout already tested clean in a prior
session's sandbox check (that check found only a thin, benign coincident-
face artifact at Z=50/52/698, not a real bulk collision) — this pole is a
SEPARATE, real, substantial collision, confirmed by Janis with the frame
removed. Identify precisely which part of the corner's geometry this is
before removing it.

Once identified: remove it. Confirm via CGAL/geometry check (not visual
only) that:
(a) the collision with the door is actually gone across the full
    door_open_deg sweep (0-100°, same 9-angle + fine sweep discipline as
    prior door-clearance fixes)
(b) the shell remains a valid manifold solid after removal — this is
    exterior cabinet wall, removing material here must not open a hole
    to the outside or break the shell's watertightness. If removal alone
    breaks manifold integrity, flag this explicitly rather than forcing
    a fix — this may need Janis's input on how the corner should actually
    close up structurally once the pole is gone.

### TASK 2 — Rebuild tray_zone_frame() to touch the housing

Current: `frame_bar` = 20mm width, `frame_inset` = 5mm from the door's own
envelope, `frame_depth` = 2mm — floats with a real gap to the shell
(confirmed by Janis, screenshots this session: "inner frame gap to left
shell corner", "inner frame gap to top shell").

Rebuild:
- Reduce `frame_bar` (both vertical bars) to 8mm.
- Left bar: extend so its curved outer edge makes REAL contact with the
  shell's interior wall at the corner (where the pole used to sit) —
  full touch, wrapping the round corner, not just proximity. This bar
  becomes the sole structural reinforcement at this corner going forward
  (replacing the removed pole's role).
- Right bar: extend so it makes REAL contact with `compartment_divider()`'s
  wall (the partition between the product zone and the dashboard zone),
  not just proximity.
- Re-verify door clearance across the FULL door_open_deg sweep (0-100°,
  9-angle + fine 0.5° sweep) — this changes bar geometry that was
  previously proven clear at the old dimensions; that proof does not
  carry over automatically to the new dimensions/positions.
- Re-verify frame-vs-spring-footprint clearance (Task 3 below handles the
  shell-width side of this; confirm the frame's own new position doesn't
  reintroduce a different overlap once the bars are repositioned to touch
  the housing).

### TASK 3 — Widen the shell for full spring-tray clearance

Derive (do not guess or reuse the approximate hand-check numbers from
CONTEXT above) the minimum increase to `total_w`/`product_w` (and any
other dimension that depends on them — check the full parameter chain,
not just these two) so that, across the FULL `tray_out_pct` range (0 to
its actual max value — confirm what that is from source, don't assume 1.0)
combined with the Task 2 frame rebuild, there is ZERO overlap between the
frame's bars and the spring coils' swept footprint at every tray position.

Verify via live CGAL intersection sweep across the tray_out_pct range, not
a single static check. State the exact final dimension(s) chosen and the
sweep result explicitly in cc_chat_log. Confirm this widening doesn't
break any other fixed relationship elsewhere in the file (shell/product
zone/dashboard zone boundary, door width, etc.) — check the datum chain,
don't change total_w in isolation without checking what else derives from
it.

### TASK 4 — Reinforce the door's hinge pivot line

Add reinforcement along the door's own hinge pivot centerline (full
height, `door_bot_z` to `door_top_z`) — a strong pole-like member at the
pivot line, replacing the structural role the removed corner pole used to
serve, from the door's side rather than the shell's side. Confirm this
new member doesn't itself collide with anything across the door's full
opening sweep (same discipline as Task 2).

## 4. DO NOT TOUCH
- `drop_zone_guards()`, `sensor_strip()`, `tray_compartment_partition()`,
  `exit_compartment_wall()` — all already fixed and verified in v48,
  zero change
- Acrylic/metal split geometry in `left_zone_door()` — the growing overlap
  with the frame (flagged in CONTEXT) is NOT in scope here; if this
  prompt's frame rebuild happens to change that overlap number, STATE the
  new number in cc_chat_log but do not attempt to further fix the acrylic
  side of it
- The new partition-protrusion collision flagged in CONTEXT — explicitly
  out of scope, log it, do not fix it
- Right compartment (`acrylic_display()`, `dashboard()`) — out of scope
- `rules-waivers.md`, `CURRENT_STATE.md` — unrelated

## 5. QA VERIFICATION
- [ ] Corner shell pole identified (state exact module/lines) and removed
- [ ] Shell confirmed still a valid manifold after removal — state result;
      if removal alone breaks manifold integrity, flag explicitly rather
      than force a workaround
- [ ] Door-vs-corner collision confirmed gone, full 0-100° sweep
- [ ] `frame_bar` reduced to 8mm, both bars confirmed making real contact
      with housing (left: shell corner; right: compartment_divider()) —
      state exact contact geometry, not just proximity
- [ ] Frame re-verified clear of door across full sweep at new dimensions
- [ ] Exact shell width increase stated, derived from live sweep across
      full tray_out_pct range, not guessed — zero overlap confirmed
- [ ] Full datum chain checked for anything else affected by the width
      change — state what was checked
- [ ] Door hinge pivot reinforcement added, confirmed clear across full
      door sweep
- [ ] No NEW manifold/undefined-variable warnings introduced
- [ ] Version incremented v48 → v49, v48 untouched

## 6. MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP, under 10 lines: pole
   removal summary, new frame dimensions/contact points, exact shell
   width increase + sweep result, hinge reinforcement summary, and the
   two carried-over open items (acrylic/frame overlap number, new
   partition-protrusion collision) restated as still-open for the record
2. Archive this prompt → /prompts/archive/
3. Update knowledge.map if new constants warrant a note
4. Bump version on rules-dimensions.md for the new total_w/product_w,
   frame_bar, and any other changed constants
5. Commit all → merge to main
