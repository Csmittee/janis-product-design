# cc Prompt — Door Fix: Lower Flap-Zone Metal Stacking + Acrylic Border
# Date: 2026-07-06
# Standalone — separate from the corner/frame/shell-width redesign prompt.
# Safe to run BEFORE or AFTER that prompt — see TASK 2 note on why.
# Active file: whatever is on main when this runs (v48 or v49 — confirm
# and state which).

## 1. CC INTRO
git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → cc_chat_log.md (first 3 entries) →
rules-dimensions.md → left_zone_door() in the live file on main.
State every file read. State explicitly which version is on main
(v48 or v49) and therefore which `tray_zone_frame()` geometry — old
(20mm bars, 5mm inset, not touching shell) or new (8mm bars, touching
shell/partition) — this prompt's Task 2 clearance check is being run
against. If v49 (the frame redesign) has landed, use its real geometry.
If it hasn't landed yet, use the current live v48 frame geometry and
say so plainly in cc_chat_log — do NOT guess which one "should" be
current, read main and report what's actually there.

## 2. CONTEXT

Janis identified the real cause of the door's lower flap-zone thickness
problem (screenshots this session): instead of building the metal panel
as a continuous part of the door's own skin (like every other part of
the door), the metal panel in that zone was built as a SEPARATE sheet
mounted to the door frame from the back — the same "separately-applied
sheet" pattern used for the acrylic. Two applied sheets stacking in the
same zone (door's own structure + this separate metal sheet) is what
creates the excess thickness risk near the frame, not a clearance/border
tuning problem.

Janis's fix, approved, execute as specified (not asking you to re-decide
this, only to build it correctly):
- The lower flap-zone metal should NOT be a separately-mounted sheet at
  all. It should be the door's own continuous skin (same door_t=3mm as
  the rest of the panel), with a cutout/mount built directly into that
  skin for the flap — same construction method as the rest of the door,
  not a special case.
- Separately: the upper acrylic's mounting border (top, left, right) gets
  pushed down/inward, increasing the plain-metal-only border around it,
  so that only the single door_t (3mm) metal skin — never the acrylic —
  sits in the zone nearest the frame's contact/collision-critical area.

## 3. TASKS

### TASK 1 — Rebuild the lower flap-zone as continuous door skin

Find where the current metal panel for this zone is built as a
separately-mounted sheet (attached to the door frame from the back,
same pattern as the acrylic mount). Remove that construction. Rebuild
this zone as part of the door's own single continuous skin at door_t
(3mm) — same piece, same thickness, same construction method as the
rest of the door panel — with the flap's opening cut directly into it
(cutout + whatever mount feature the flap needs, built into this skin,
not a bolted-on extra layer).

Confirm via real measurement (not visual) that this zone is now single
door_t thickness, not door_t+door_t or door_t+acrylic_t. State the
before/after thickness explicitly in cc_chat_log.

### TASK 2 — Push the acrylic's mounting border down/in

Reduce the acrylic's extent from the top, left, and right (increasing
the plain-metal-only border on those three sides) so that only the
single-thickness metal skin — never the thicker acrylic — occupies the
zone nearest wherever `tray_zone_frame()`'s bars actually sit, per
whatever frame geometry is live on main right now (see CC INTRO — state
which version you checked against).

Derive the exact border increase needed from LIVE geometry (the real
frame position currently in the file), not a guessed number and not a
number carried over from a different frame version. Verify via real
geometry check (not visual) that with this new border, the acrylic
itself has zero contact with the frame at door_open_deg=0, across
whatever frame geometry is actually live.

If the frame redesign (v49) has NOT landed yet when this runs: verify
against the CURRENT (old) frame, note explicitly in cc_chat_log that
this needs to be RE-verified once v49 lands, since the frame's position
will change. Do not skip this note.

## 4. DO NOT TOUCH
- `tray_zone_frame()` itself — that's the separate corner/frame/shell-
  width redesign prompt, not this one
- `drop_zone_guards()`, `sensor_strip()`, `tray_compartment_partition()`,
  `exit_compartment_wall()` — already fixed in v48, zero change
- Right compartment (`acrylic_display()`, `dashboard()`) — out of scope
- The window opening itself (`window_x0/z0/w/h`) — only the acrylic's
  MOUNTING border relative to that window changes, not the window/view
  opening itself, unless the two turn out to be the same thing in the
  live code — if so, flag this explicitly rather than silently changing
  the visible window size along with the border

## 5. QA VERIFICATION
- [ ] Stated which file version (v48/v49) and which frame geometry this
      prompt ran against
- [ ] Lower flap-zone rebuilt as single continuous door_t skin — before/
      after thickness stated explicitly
- [ ] Flap cutout/mount confirmed functional (flap can still open through
      its full range, `flap_open_deg` 0-55°, zero collision with the
      rebuilt skin)
- [ ] Acrylic border pushed down/in on top, left, right — exact new
      values stated
- [ ] Acrylic-vs-frame contact confirmed zero at door_open_deg=0, against
      whichever frame geometry was live — explicitly flagged for re-
      verification if checked against the old (pre-redesign) frame
- [ ] No new manifold/undefined-variable warnings
- [ ] Version incremented appropriately (state new version number based
      on whatever it branched from)

## 6. MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP, under 10 lines: which
   frame version checked against, before/after flap-zone thickness,
   new acrylic border values, and an explicit flag if re-verification
   against v49 is still needed
2. Archive this prompt → /prompts/archive/
3. Update knowledge.map if new constants warrant a note
4. Bump version on rules-dimensions.md for changed constants
5. Commit all → merge to main
