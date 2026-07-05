# cc Prompt — VM-01 Frame Rebuild + Window/Acrylic Resize + Toggle Fixes (v44)
# Date: 2026-07-05
# Supersedes: nothing merged is wrong. Builds on VM-01-door-datum-rebuild-v43
# (PR #85). If PR #85 is not yet merged to main, merge it FIRST, then apply
# this prompt on top of v43 — do not build v44 from an older version.

## 1. CC INTRO
git fetch --all && git checkout main && git pull origin main
CONFIRM PR #85 (VM-01-door-datum-rebuild-v43) is merged to main. If not
merged yet, merge it first, THEN proceed — this prompt's base file is
VM-01-base-v43.scad, not v42.
Read in order: cc_rules.md → cc_chat_log.md (first 3 entries) →
rules-dimensions.md → .claude/rules-codes.md → VM-01-base-v43.scad
State every file read before writing a single line.

## 2. CONTEXT

Real-render QA session on v43 (Janis + Claude Web, local OpenSCAD + CGAL
boolean intersection testing, not just screenshots) surfaced 6 issues.
Claude Web isolation-tested all 6 against the actual v43 source before
writing this prompt — findings and required fixes below.

### Finding A — sensor_strip() has a fabricated center beam that was never
part of the real design (Janis-confirmed 2026-07-05)
`sensor_strip()` correctly draws two real strips (left at `strip_x0`,
right at `strip_x1`, capturing product fall left/right of the exit space
— this part is correct, keep it). But it ALSO draws a third element: a
thin red cube (2x2mm cross-section) spanning the FULL GAP between the two
strips, looking like a connecting beam/rod. Janis has confirmed this
center element was never part of the actual sensor design — the design is
strictly 2 independent side pieces, nothing bridging them. This fabricated
center cube is what was mistaken for a "ghost rod" next to
`flap_stopper_rod()`. DELETE the center cube entirely — do not just
relabel or toggle it.

### Finding B — acrylic isolation toggle inconsistent with its siblings
The door's real acrylic pane (`left_zone_door()`, correctly modeled,
correctly moves with the door) is gated on
`render_mode=="full" && show_acrylic`. `show_door` and `show_flap` are
NOT render_mode-gated — they work standalone. Because `render_mode`
defaults to `"standard"`, the acrylic never renders regardless of
`show_acrylic`, which reads as "toggle does nothing." Root cause is the
inconsistent gating, not missing geometry.

### Finding C — `tray_zone_frame()` is placed against the WRONG reference
point entirely, not just missing a curve (Janis-confirmed 2026-07-05,
visually the frame sits at/outside the shell's real interior wall)
Every bar in `tray_zone_frame()` starts at `translate([0, e*2, ...])` —
X=0, Y≈0 is the shell's THEORETICAL SHARP exterior corner. The module
never accounts for `skin_t` (wall thickness) or `corner_r` (the rounded
corner) at all — it was built as if the shell had a flat, zero-thickness,
un-rounded corner at the origin. This is why it visually sits at/outside
the shell's actual interior wall surface, not merely lacking a cosmetic
curve. The fix (Task 3) must reposition the ENTIRE frame against the SAME
interior-corner reference `left_zone_door()` already uses
(`skin_t + (corner_r-1)` formula, see `arc_cx`/`arc_cy` in that module),
not just curve one edge of an otherwise-still-misplaced frame.

Separately, CONFIRMED via CGAL boolean intersection (not visual
inspection): `intersection() { tray_zone_frame(); left_zone_door(); }`
tested at door_open_deg = 0, 20, 25, 30, 35, 40, 45, 70, 100:
- 0°–~30°: REAL solid intersection (non-empty geometry, multiple volumes)
  — top bar, bottom bar, AND right bar all clip the door leaf.
- ~35° and beyond: clear, empty intersection.
Only the left vertical bar never collided. This is a SEPARATE issue from
the wrong-reference-point problem above — fixing the reference point does
not automatically guarantee door clearance, both must be verified
independently in QA.

### Janis's redesign spec for `tray_zone_frame()` (replaces the above
entirely — this is a full rebuild, not a patch):
1. Full height: floor to roof of the left-zone door envelope — Z range
   `door_bot_z` (50) to `door_top_z` (698), matching `door_h` (648mm) —
   not the old tray_0_z-to-roofline (270-700) partial range.
2. 5mm border inset from the door's own edges on all four sides (top,
   bottom, left, right) — not flush with X=0/product_w or Z=roofline like
   the old design.
3. H-shape: two full-height vertical bars (existing `frame_bar`=20mm
   width, inset per #2) + ONE horizontal crossbar, 10mm thick, spanning
   left-to-right between the verticals, positioned at the CURRENT
   crossbar Z location (`tray_0_z` = 270mm — the old bottom-bar position,
   the natural exit/tray-zone boundary). This replaces the old top
   bar + bottom bar + short mid-height side bars entirely.
4. FIRST reposition the entire frame (both verticals + crossbar) to
   reference the shell's REAL interior wall surface — same
   `skin_t + (corner_r-1)` interior-corner formula `left_zone_door()`
   already uses — instead of the current wrong reference (world X=0/Y=0,
   the shell's theoretical sharp exterior corner). This is a prerequisite,
   not the same step as curving the edge.
   THEN, the full-height leftmost vertical bar's outer edge must be curved
   to match the door's own curved flange — same center/radius as
   `left_zone_door()`'s `arc_pts()` curve (`corner_r`-1 radius, same
   center formula) — AND inset far enough from the hinge/flange swept
   volume that NO collision occurs at ANY `door_open_deg` from 0-100°.
   MANDATORY: re-run the same CGAL `intersection()` test used in this
   session's QA (tray_zone_frame vs left_zone_door, sweep 0/20/25/30/35/
   40/45/70/100°) against the NEW frame — report the result at EVERY
   angle in cc_chat_log, not just "looks clear." Zero non-empty results
   required across the full sweep, not just past 35°.

### Janis's spec for the door window + acrylic (Janis-approved, lock into
rules-dimensions.md once built):
- Resize the door's window (`window_x0/window_z0/window_w/window_h` in
  `left_zone_door()`) to match the NEW frame's inner clear opening — i.e.
  the window should span the full inset area bounded by the H-frame's two
  verticals (left/right) and reach from near-floor to near-roof (matching
  the frame's new full-height span from #1 above, each inset the same 5mm
  border), giving a full view of the entire compartment — springs, trays,
  everything — not just the old tray-zone slice.
- The 10mm crossbar sits in front of/behind the glass as a single visible
  structural bar crossing the (now much taller) window — it does NOT
  split the window into two separate cutouts. One continuous window
  opening.
- Resize the acrylic pane (currently `acrylic_border`-oversized relative
  to the old small window) to match this new, larger window exactly, same
  `acrylic_border` overlap convention as before.
- Once built and confirmed against a real F6/Preview render, lock the
  final window_x0/window_z0/window_w/window_h and acrylic dimensions into
  `rules-dimensions.md` as Janis-approved 2026-07-05, superseding the v43
  frozen values.

## 3. NEW FILES
`vending-machine/VM-01-base/VM-01-base-v44.scad` (source: v43, merged PR #85)

## 4. TASKS

### TASK 1 — Delete the fabricated sensor center beam (Finding A)
In `sensor_strip()`, DELETE the red center cube entirely (the
`color("#FF0000", 0.3) translate(...) cube(...)` block spanning the gap
between `strip_x0` and `strip_x1`). Keep both real side strips unchanged
— those are the correct, Janis-confirmed design (2 independent pieces,
left/right of the exit space, capturing product fall). Add a new
isolation toggle `show_sensor` gating the two remaining real strips (same
pattern as `show_door`/`show_acrylic`/`show_flap`), default
`show_sensor = true`.

### TASK 2 — Fix acrylic toggle gating (Finding B)
In `left_zone_door()`, change the acrylic pane's gate from
`render_mode == "full" && show_acrylic` to `show_acrylic` alone —
consistent with `show_door`/`show_flap`, independent of render_mode.
Confirm `acrylic_display()` (right-compartment upper acrylic, unrelated
module) is NOT touched by this — separate part, out of scope.

### TASK 3 — Rebuild `tray_zone_frame()` as full H-frame, correctly
referenced against the shell's real interior wall (Finding C + Janis's
spec, see CONTEXT for exact numbers/logic)
Implement per the 4-point spec above. Two sequential corrections, both
required: (1) reposition the whole frame off the shell's REAL interior
wall surface (`skin_t + (corner_r-1)` formula) instead of the current
wrong sharp-exterior-corner reference — this alone fixes the
"frame sits outside the shell" visual defect; (2) curve the left vertical
bar's edge to match the door's flange arc AND confirm door-swing
clearance via the mandatory CGAL sweep test. Curved edge must reference
the SAME arc center/radius formula `left_zone_door()` uses (`arc_pts()`),
not a new independent curve — two parts sharing a visual curve must
derive it from one source concept, even though this file is grandfathered
out of the full Skeleton/DRF system (per
.claude/SKILL_product_design_skeleton.md exception already in place for
VM-01's door work).

### TASK 4 — Resize door window + acrylic to match new frame (Janis spec)
Implement per the window/acrylic spec above. Update
`window_x0/window_z0/window_w/window_h` and the acrylic pane's cube in
`left_zone_door()` together — do not resize one without the other.

### TASK 5 — Update `rules-dimensions.md`
Add the new frame dimensions (H-shape verticals/crossbar, inset, curve
radius) and the new window/acrylic dimensions, marked "Janis-approved
2026-07-05, supersedes v43 frozen window/acrylic values." State the old
v43 values being replaced explicitly, don't silently overwrite.

## 5. DO NOT TOUCH
- `flap_stopper_rod()` geometry itself — confirmed correct this session,
  only needs the QA screenshot note (Task 6 below), no code change
- `drop_zone_guards()` — confirmed correct, out of scope
- `acrylic_display()` (right-compartment upper panel) — separate part
- Hinge datum logic (`HINGE_Y_OFFSET`, `FOOT_BASE_H`, hinge_x/y/z in both
  `left_zone_door()` and `outer_shell_debug()`) — confirmed correct in
  v43, zero change
- Curved flange arc on the DOOR itself (already locked/approved) — Task 3
  REUSES its formula for the frame's edge, does not modify the door's own
  arc
- All other `.scad` files

## 6. QA VERIFICATION
- [ ] Sensor center beam cube confirmed DELETED from source (not just
      hidden) — grep the file, confirm the red cube block is gone
- [ ] `show_sensor=false` screenshot: both remaining real strips hidden,
      everything else unaffected
- [ ] `show_acrylic=true` with `render_mode="standard"`: door acrylic now
      VISIBLE (confirms Task 2 fix — this was previously impossible)
- [ ] `show_acrylic=false`: door acrylic hidden regardless of render_mode
- [ ] New H-frame: full height floor-to-roof, 5mm inset confirmed via
      measurement (not eyeballed), 10mm crossbar at tray_0_z, left edge
      visibly curved matching the door's own curve
- [ ] Frame's baseline position confirmed measured against the shell's
      real interior wall surface (skin_t + corner_r-1 formula) — screenshot
      showing frame now sits flush inside the shell, not outside/overlapping
      the rounded corner like v43
- [ ] MANDATORY — CGAL `intersection(){tray_zone_frame(); left_zone_door();}`
      re-run at door_open_deg = 0,20,25,30,35,40,45,70,100 — report
      facet/volume count (or "empty") at EVERY angle in cc_chat_log. Zero
      non-empty results required at ALL angles, not just >35°.
- [ ] New door window spans the full frame inner opening, single
      continuous cutout (crossbar visible in front, not splitting the
      window in two)
- [ ] Acrylic resized to match new window exactly, same border convention
- [ ] rules-dimensions.md updated, old v43 values shown as superseded
- [ ] No undefined-variable warnings, no manifold warnings on full CGAL
      render
- [ ] Version incremented v43→v44, not overwritten

## 7. MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP, under 10 lines, MUST
   include the full angle-sweep collision re-test results (Task 3 QA item)
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-05
3. Update knowledge.map if needed
4. Bump version on all changed files (rules-dimensions.md, etc.)
5. Commit all → merge to main
