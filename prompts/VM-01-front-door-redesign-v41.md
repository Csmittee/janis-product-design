# CC PROMPT — VM-01 Left-Zone Front Door Redesign (hidden hinge + exit flap + viewer toggles)
# Date: 2026-07-03
# Save to: /prompts/VM-01-front-door-redesign-v41.md
# Depends on: VM-01-shell-height-fix-v40.md landing first (VM-01-base-v40.scad)
# Supersedes: front_door(), flap_door(), spring_zone_panel() entirely —
# Janis explicitly approved a full rebuild rather than a patch.

---

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order before touching anything. State every file read:
1. cc_rules.md
2. cc_chat_log.md (last 3 entries)
3. rules-dimensions.md
4. vending-machine/VM-01-base/VM-01-base-v40.scad (current committed source
   after the shell-height fix — confirm this exists before starting; if
   only v39 exists, STOP and flag to Janis, do not proceed on v39)

---

## 2. CONTEXT

This feature (exit door / customer pickup flap) has failed across 38 prior
SCAD versions and 6+ chat sessions per project history — treat this prompt
with the project's R-111 discipline even though it is a first attempt in
this specific new form.

Root cause of prior failures (confirmed by code read): `front_door()` was
a single uncut solid panel spanning only the exit zone (Z 50-300mm), with
no `difference()` cutting a hole for `flap_door()` — the flap was
geometrically invisible in every render ever produced. Separately, the
hinge for the old door concept was positioned directly on the front face
at the rounded front-left corner (`corner_r=20`), which cannot accept
hinge hardware in production.

Janis reviewed and approved this replacement design across several rounds
of local OpenSCAD sandbox renders in chat (not committed anywhere until
now). Full corrected spec below.

**New unified door** (replaces `front_door()` + `spring_zone_panel()` +
`flap_door()` entirely):
- Spans the FULL height of the left/spring-tray compartment only — NOT
  the full machine width. Matches the product zone (`product_w`) only.
- Hinge is CONCEALED and shifted OFF the rounded front-left corner onto
  the flat portion of the LEFT SIDE wall, connected back to the front
  panel via a small return flange (wraps around the corner). This solves
  both the "can't mount a hinge on a curved surface" production problem
  and spreads hinge hardware evenly top-to-bottom instead of cramming 3
  hinges into a short 250mm zone (visibly bad in the current build).
- Two cutouts within the one door: a top viewing window (acrylic, flat
  panel screwed from inside with a 5mm overlap border for mounting
  material) and a lower exit-flap opening.
- Exit flap: 300×150mm (does NOT need to match tray width — sized for
  hand access only), hinged at the TOP, swings INWARD, closes by gravity.
  Opens to 55° from vertical. A stopper rod (spans left-to-right across
  the interior) limits the swing — this is also the theft-prevention
  feature (narrows reachable depth so a hand can retrieve a dropped
  product but can't reach the spring trays). No proximity switch yet —
  explicitly deferred by Janis, do not add hardware for it.

**New viewer/export toggles** (Janis needs multiple STL states for a
viewer tool): `door_open`, `flap_open`, `tray_out_pct` — added alongside
the existing `show_shell_*` toggle block, same convention.

---

## 3. NEW FILES

None. Edits VM-01-base-v40.scad in place, saves as v41.

---

## 4. TASKS

### TASK 1 — Delete and replace `front_door()`, `flap_door()`, `spring_zone_panel()`

File: `vending-machine/VM-01-base/VM-01-base-v40.scad`

Remove these three modules entirely. Replace with ONE new module,
`left_zone_door()`, built from these confirmed parameters (add near the
top of the file with the other named constants — no hardcoded numbers
inside the module body, per the 30-line/module + no-hardcoded-numbers
rules):

```
exit_w = 300;                          // supersedes old flap_w=250
exit_h = 150;                          // supersedes old flap_h=100
hinge_y = corner_r + 5;                // 25mm -- flat part of left side wall
return_depth = hinge_y - skin_t;       // 23mm -- flange depth, front face to hinge line
door_top_z = total_h - skin_t;         // 698mm -- matches roofline clearance used elsewhere
door_bot_z = leg_h;                    // 50mm
door_left_x = skin_t;                  // 2mm
door_right_x = product_w - skin_t;     // 414mm -- LEFT ZONE ONLY, not total_w
exit_bot_z = door_bot_z + 30;          // 30mm clearance off the floor
exit_x = door_left_x + ((door_right_x-door_left_x-return_depth) - exit_w)/2 + return_depth; // centered in door width
flap_open_deg = 55;                    // Janis-approved, was targeting "~60 or less"
acrylic_border = 5;                    // overlap border, screw-in material
window_margin_side = return_depth + 15;// clears return flange + margin
window_top_gap = 15;                   // below roofline
window_flap_gap = 40;                  // clearance above the flap opening
```

`left_zone_door()` builds, in this order:
1. Return flange: `door_t` thick, at `X=door_left_x`, `Y` from `skin_t` to
   `hinge_y`, full `door_h` (= `door_top_z - door_bot_z`) tall — connects
   the front panel to the hinge line, wraps the rounded corner.
2. Main front panel: `X` from `door_left_x + return_depth` to
   `door_right_x`, at `Y=skin_t`, full door height, `door_t` thick.
3. Hinge seam indicators: 3 positions at 10%/50%/90% of door height, thin
   flush marks at `X=door_left_x`, `Y=hinge_y` — concept placeholder only,
   NOT a protruding hinge barrel. Actual hinge hardware spec (barrel
   diameter, mounting boss, wall-cavity depth) is a manufacturing detail
   to resolve with the hinge supplier once this concept is in CAD; note
   this explicitly as an open item in rules-dimensions.md (Task 3).
4. Top window cutout (via `difference()`) in the main panel: inset from
   the left edge of the main panel by `window_margin_side` past the
   return flange, matching margin on the right, `window_top_gap` below
   `door_top_z`, ending `window_flap_gap` above the exit flap opening.
5. Acrylic panel: flat panel mounted `door_t` further inside (toward +Y,
   i.e. inside the cabinet) than the door face, sized as the window
   opening plus `acrylic_border` on all four sides.
6. Exit flap opening (via `difference()`) in the main panel: `exit_w` ×
   `exit_h`, positioned per `exit_x`/`exit_bot_z` above.
7. Exit flap itself: hinged at its TOP edge (rotate about the horizontal
   axis running left-right, located at the flap's top Z — NOT a side
   hinge), swings inward (+Y direction) toward `flap_open_deg` when open.
8. Stopper rod: cylinder spanning the interior width (left inner panel to
   right inner panel), positioned to catch the flap at `flap_open_deg`.
   No switch/sensor geometry — explicitly deferred.

Wrap the whole assembly in a `door_open`-controlled rotation (see Task 2)
pivoting at `(door_left_x, hinge_y)`.

Save as `VM-01-base-v41.scad`.

### TASK 2 — Add viewer toggles

Add alongside the existing `show_shell_*` toggle block at the bottom of
the file (same convention, do not restructure the existing toggles):

```
door_open    = false;   // true -> door swung open (100 deg) for viewer STL
flap_open    = false;   // true -> flap swung open (55 deg) for viewer STL
tray_out_pct = 0;       // 0-1, e.g. 0.3 -> tray slid 30% of tray_d out the front
```

Wire `door_open` into `left_zone_door()`'s outer rotation (0° when false,
100° when true, pivoting at the hinge line). Wire `flap_open` into the
flap's own rotation (0° when false, `flap_open_deg` when true). Wire
`tray_out_pct` into `spring_tray()`'s Y-position: shift each tray's Y
offset by `-tray_d * tray_out_pct` (toward the front opening). Locate the
actual Y-translate inside `spring_tray()` from the live file — do not
assume the exact line, verify from source.

These three toggles must combine freely with each other and with the
existing `show_shell_*` toggles and `render_mode`, matching the pattern
already established for shell panels.

### TASK 3 — Update `rules-dimensions.md`

Under "VM-01 Base — Front Door", mark the existing entry:
```
Door Z range | 50–300mm | EXIT ZONE ONLY — LOCKED
```
as **Superseded** (do not delete — same convention as the pole holder /
bell collar supersession, 2026-07-02). Add new confirmed entries:

```
Door Z range (full height)      | 50–698mm            | CONFIRMED 2026-07-03
Door X range (left zone only)   | 2–414mm              | CONFIRMED 2026-07-03 -- product_w zone only, NOT total_w
Hinge line offset from corner   | 25mm (corner_r + 5)  | CONFIRMED 2026-07-03
Return flange depth             | 23mm                 | CONFIRMED 2026-07-03
Exit flap dimensions            | 300mm W x 150mm H    | CONFIRMED 2026-07-03 -- supersedes old flap_w=250/flap_h=100
Exit flap hinge                 | top, swings inward   | CONFIRMED 2026-07-03
Exit flap max open angle        | 55 deg               | CONFIRMED 2026-07-03
Stopper rod                     | spans left-to-right interior panels, position derived from flap_open_deg | CONFIRMED 2026-07-03 -- no switch yet, deferred
Acrylic border overlap          | 5mm                  | CONFIRMED 2026-07-03
Hinge hardware spec (barrel/boss/cavity) | NOT YET SPECIFIED | OPEN ITEM 2026-07-03 -- concept only, needs hinge-supplier input before manufacturing
```

---

## 5. DO NOT TOUCH

- `outer_shell_debug()` — fixed in v40, do not modify further here
- `acrylic_display()` (right-zone dashboard-side panel) — unrelated,
  out of scope
- All other `.scad` files not listed in TASKS
- `.claude/rules-waivers.md`

---

## 6. QA VERIFICATION

- [ ] F6 render, all combinations of `render_mode` × `show_shell_*` ×
      `door_open` × `flap_open` × `tray_out_pct` compile with no
      undefined-variable warnings
- [ ] True front elevation screenshot: hinge is NOT visible
- [ ] True left-side elevation screenshot: hinge seam IS visible
- [ ] `door_open=true` screenshot: door swings clear of the tray zone,
      no self-intersection with the shell or return flange
- [ ] `flap_open=true` screenshot: flap reads as hinged from the top,
      not the side, from both front and side elevations
- [ ] `tray_out_pct=0.3` screenshot: tray visibly slides out the front
      opening without colliding with the closed door
- [ ] Export STL for each of the three new toggle states individually
      plus baseline closed, per the filename convention already in use
- [ ] rules-dimensions.md supersession applied correctly, old entry
      marked not deleted
- [ ] Version incremented v40→v41, not overwritten

---

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at TOP, under 10 lines
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-03
3. Update knowledge.map (new VM-01-base-v41 STL filenames, all toggle
   state exports)
4. Bump version on all changed files
5. Commit all → merge to main
