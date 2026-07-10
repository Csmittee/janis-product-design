# cc Prompt — VM-02 (derived from VM-01 v58) — Major Variant
# Date: 2026-07-09
# Session goal: NEW product line, VM-02, seeded from VM-01-base-v58.scad.
# Large multi-part geometry change. Read this whole prompt before starting
# — several tasks interact with the same datums, do not tackle in
# isolation without reading the "CROSS-CUTTING WARNINGS" section first.

## 1. CC INTRO

git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → knowledge.map → cc_chat_log.md (first 3
entries) → rules-dimensions.md (in full) → PART_MANIFEST.md →
VM-01-base-v58.scad (in full — this is your seed file, read every line,
not just the parts you think you'll touch).

State the exact current v58 line count and confirm read before writing
anything.

## 2. CONTEXT

Janis is deriving a second product, VM-02, from the now-locked VM-01
Generation 1 (v58). This is NOT a new VM-01 version — it's a new sibling
product line, same base architecture, several real geometry changes.
Both product lines continue independently after this (VM-01 stays locked
at v58 unless a future session says otherwise).

Two decisions already confirmed directly by Janis (not cc's to
re-litigate):
- Sensor holes go through the tray FLOOR (vertical, sensor mounted
  below looking up) — not the front wall.
- The narrower portrait dashboard's freed compartment width comes off
  TOTAL MACHINE WIDTH, not out of the product/tray zone. `product_w`
  stays 416mm unchanged; `total_w` shrinks to fit the new narrower
  `system_w`.

## 3. NEW FILES

- New folder: `vending-machine/VM-02-base/`
- New file: `vending-machine/VM-02-base/VM-02-base-v1.scad` — seeded as a
  full copy of `VM-01-base-v58.scad` (same convention as VM-01's own
  per-version files — a complete standalone file, not a diff/include),
  header rewritten to identify it as VM-02 v1, derived from VM-01 v58,
  with a changelog section (same style as v58's own header) listing
  every change made in this prompt.
- Add `knowledge.map` entry for the new folder.
- Add `rules-dimensions.md` VM-02 section (mirror the existing VM-01
  section's structure) once real values are known.
- Add `PART_MANIFEST.md` entries for: 3rd spring tray, per-lane sensor
  holes, resized legs, resized back door.

## 4. CROSS-CUTTING WARNINGS — read before starting any task below

- **`total_h` must become a DERIVED value, not a literal.** Task A makes
  tray row count a live Customizer parameter. If `total_h` stays a fixed
  number, changing row count in the Customizer will silently break
  roofline clearance for anyone who touches that slider later — the
  whole point of Task A.2 is that it's supposed to be safely adjustable.
  Derive `total_h` from `tray_stack_z0 + (tray_count * tray_h) +
  ROOFLINE_MARGIN`, where `ROOFLINE_MARGIN` is a new named constant set
  to whatever margin the original v58 2-tray design actually had between
  stack-top (612mm) and roofline (700mm) — re-derive this exactly from
  the real file, don't assume it's exactly 88.
- **`DATUM_TRAY_TOP` / `tray_zone_h` currently drive the RIGHT
  compartment's acrylic zone** (`acrylic_bot_z = tray_zone_top_z =
  DATUM_TRAY_TOP`), and v58's own comments explicitly call this datum
  "deliberately decoupled/frozen" from the live tray stack. Since
  `tray_count` becomes live in VM-02, `tray_zone_h` (`tray_h *
  tray_count`) will also become live — confirm whether the right
  compartment's whole layout (Task B, redesigned around the new "400mm
  from top" rule anyway) still reads this datum at all after your
  changes. If it does, that's likely a live bug waiting to happen the
  next time someone touches the row-count slider. Flag explicitly in
  cc_chat_log either way, don't silently leave it wired.
- **`acrylic_display()`** (the upper-right-compartment 3-face viewing
  window, currently anchored to the old `acrylic_bot_z`/`acrylic_zone_h`)
  may no longer make geometric sense in a 120mm-wide portrait-dashboard
  compartment. Don't blindly keep it at its old proportions and don't
  blindly delete it — evaluate against the new system-compartment
  dimensions from Task B, make a judgment call, and flag your reasoning
  in cc_chat_log for Janis to confirm/override.
- **Everything on the LEFT side (drop zone, trays, frame, sensor strips,
  stopper rod, flap) is defined relative to `product_w`/`skin_t`, not
  `total_w`.** Since `product_w` is unchanged, none of that should need
  to move when `total_w` shrinks in Task B — confirm this holds via real
  render, don't just assume the architecture is as clean as it looks.

## 5. TASKS

### TASK A — Spring tray remake

A.1. Change default row count 2→3 (add tray #2 ON TOP of the existing
     stack — tray #0 and everything below/at its level is UNCHANGED, per
     Janis's explicit "do not touch anything below bottom tray").

A.2. Make `tray_count` a live Customizer parameter (`/* [Tray
     Configuration] */` group), range `[1:5]` — 5 as ceiling headroom,
     not just 3, since Janis wants this genuinely adjustable long-term.
     `total_h` and every dependent datum must correctly recompute for
     any value 1-5, not just be hardcoded for 3 (see Cross-Cutting
     Warnings above). Test at minimum tray_count=1, 3, 5 for manifold
     sweep (Task E).

A.3. Detach per-tray slide: replace the single scalar `tray_out_pct`
     with a length-5 Customizer vector (e.g. `tray_out_pct = [0,0,0,0,0];
     // [0:0.05:1]` per-entry range), only the first `tray_count` entries
     meaningful. Each tray's Y-position must read its own array index,
     independent of the others — confirm via render that trays can be
     exported at different slide percentages simultaneously (e.g.
     tray 0 at 0%, tray 1 at 50%, tray 2 at 100%, all in one render).

A.4. Sensor holes: on EVERY tray (scales with `tray_count`), at EVERY
     lane (5 lanes per tray), add a 3mm-diameter hole through the tray
     FLOOR (vertical, Z-axis), centered at each lane's existing
     centerline X (`tray_wall_t + spring_od/2 + i*(spring_od+spring_gap)`
     — reuse this exact formula, don't re-derive), Y = 5mm from the
     tray's own front edge (Y=0 local). Confirm hole doesn't collide
     with the existing rear motor-mount cutouts or partitions (it's at
     the front, motor cutouts are at the rear, should be clear — verify
     don't assume).

### TASK B — System compartment (dashboard + back door)

B.1. Rotate dashboard screen assembly to portrait: physical panel stays
     165mm x 100mm — do NOT change these two numbers — just remount so
     the 165mm edge runs VERTICAL instead of horizontal. This is a real
     geometry rework (screen cube, bezel cube, support-bracket crossbar,
     and the existing -30° tilt rotation all currently assume landscape
     proportions) — don't just swap variable names, rebuild the
     transforms so the tilt still works correctly in the new orientation.

B.2. Screen vertical position: mounted so **top of screen edge = 400mm
     below top of shell** (i.e. `screen_top_z = total_h - 400`, using
     VM-02's own new `total_h` from Task A, not the old 700). This
     REPLACES the old fixed `screen_center_z = 280` anchor — screen
     center is now derived from this 400mm-from-top rule, not a fixed
     number.

B.3. QR scanner / card reader / speaker: keep the same relative-offset
     chain below the screen that v58 already uses (`qr_z = screen_bottom
     - 50 - qr_h`, etc. — reuse the existing formulas, just recomputed
     against the new screen position). Re-center each in X for the new
     narrower `dash_w` (the existing `dash_x + (dash_w - part_w)/2`
     centering formula should handle this automatically — confirm it
     does, don't hardcode new X values).

B.4. New `system_w` = 10mm border + dashboard's MOUNTED width (100mm in
     portrait) + 10mm border = **120mm**. Confirmed well under the old
     204mm ceiling.

B.5. New `total_w` = `product_w + divider_t + system_w` = 416 + 19 + 120
     = **555mm** (product_w/divider_t unchanged per Janis's decision —
     recompute this exactly from the real live values, don't trust my
     arithmetic here, re-derive in the actual file). Confirm this
     cascades correctly through the shell, right-compartment front
     cutout, and anywhere else `total_w`/`system_w` are read.

B.6. Rear service door: height = full compartment interior, floor to
     ceiling (`leg_h` to `total_h - skin_t`, world Z — i.e. genuinely
     top-to-bottom access, not the old 50%-height panel). Width = new
     `system_w - 10` (≈110mm). Position/centering within the compartment
     at cc's discretion for best access — state your choice and
     reasoning in cc_chat_log.

### TASK C — Machine foot

Increase leg diameter 25mm → **80mm** (`leg_od`). Leg height (`leg_h`)
and inset (`leg_inset` = 40mm) unchanged — but 40mm inset with an 80mm
(40mm radius) leg is tight against the shell's rounded corner (`corner_r`
20mm) and, on VM-02's narrower 555mm width, against the other legs too.
**This needs a real clearance check, not an assumption** — verify the
leg doesn't clip the corner curve or the shell wall, on BOTH VM-01's
original proportions (for regression) and VM-02's new narrower width.
Flag in cc_chat_log if `leg_inset` needs to change to make this fit —
don't silently shrink the leg back down to make it clear without telling
Janis.

### TASK D — Front door

Stretch to VM-02's new (taller) `total_h` — width/X-configuration
unchanged (door only spans `product_w`, which didn't change). This
should mostly cascade automatically since the door's Z-features are
already formulaic (`door_bot_z`/`door_top_z`/hinge_z/frame_z0/frame_z1
etc.), but confirm explicitly, don't assume:

- Acrylic/window: bottom edge stays pinned to `tray_stack_z0` (already
  true today — this IS "bottom of lowest tray," no change needed there),
  top edge stretches with the new door height using the SAME
  border-margin formula already in the code (`acrylic_top_limit_z =
  door_top_z - frame_inset - FLANGE_T - e`) — just recomputed against
  the new taller `door_top_z`. Border size/look stays the same by
  construction (same formula, different input).
- `tray_zone_frame()` H-frame verticals should stretch automatically
  (`frame_h = frame_z1 - frame_z0`, both already formulaic) — confirm
  via render this doesn't collide with anything, especially the new
  3rd tray.
- Flap cut, stopper rod, hinge marks: unchanged position (all anchored
  low, near-floor, unaffected by the roofline moving up) — confirm, but
  no change expected.

## 6. QA VERIFICATION

- [ ] VM-02-base-v1.scad created, full standalone file, real changelog header
- [ ] `tray_count` Customizer-adjustable [1:5], `total_h` correctly
      derives for each tested value (1, 3, 5)
- [ ] Per-tray `tray_out_pct` array confirmed independent (render with
      mixed values, not just all-0 or all-1)
- [ ] 5 sensor holes per tray, floor-mounted, correct lane centerline X,
      5mm from front edge, no collision with motor cutouts
- [ ] Dashboard portrait-mounted, 165x100 panel dims unchanged, tilt
      still correct, top-of-screen = total_h - 400
- [ ] QR/card/speaker re-centered correctly under new dash_w
- [ ] system_w = 120mm, total_w = 555mm (or your re-derived exact value
      if my arithmetic above was off), both confirmed against live code
- [ ] Rear door full floor-to-ceiling height, width = system_w - 10
- [ ] Leg diameter 80mm, clearance-checked against corner_r and
      leg_inset on the new narrower width — explicitly confirmed clear
      or flagged if leg_inset needed to change
- [ ] Front door stretched, acrylic/window/frame all recomputed
      formulaically, zero hardcoded old-height numbers left behind
- [ ] `DATUM_TRAY_TOP`/`acrylic_display()` cross-dependency explicitly
      evaluated and flagged (Cross-Cutting Warnings), not silently
      ignored either direction

## 7. MANDATORY TESTING — lessons-learned pass

Janis explicitly expects zero manifold issues on this build and wants
the recent v55/v56 manifold-bug lessons actually applied here, not
re-learned the hard way. Before calling this done:

- Real OpenSCAD/CGAL render (not `--render=false`) at minimum these
  combinations: `tray_count` = 1, 3, 5; `door_open_deg` sweep (same
  style as the v57 11-angle 0-100° sweep); at least one render with
  mixed non-zero `tray_out_pct` values across trays; `flap_open`
  true/false.
- Confirm `Simple: yes` (manifold) at every combination tested — state
  the actual CGAL output, don't just say "looks fine."
- Any warning at any angle/combination = stop and fix before closing,
  same standard as the v55/v56 fixes.

## 8. DO NOT TOUCH

- `VM-01-base-v58.scad` itself — VM-02 is a new derived file, VM-01
  stays locked exactly as-is
- Anything below the bottom tray (drop zone, stopper rod, sensor strips
  at Z350, legs' Z-position, floor) — X/Y/Z position unchanged, only
  leg diameter changes (Task C)

## 9. MANDATORY CLOSING

1. Prepend `cc_chat_log.md` — newest entry at TOP, concise summary of
   all 4 task areas + the manifold sweep result
2. Archive this prompt → `/prompts/archive/`
3. Update `knowledge.map` (new VM-02-base folder)
4. Add VM-02 section to `rules-dimensions.md`, entries to
   `PART_MANIFEST.md`
5. Commit all → merge to main
6. Tell Janis: real `total_w`/`system_w`/`total_h` final values (confirm
   my arithmetic above against the actual file), the `acrylic_display()`
   judgment call made, the leg-clearance result, and the manifold sweep
   result — this is a big derived variant, Janis should review the
   summary before treating VM-02 v1 as final.
