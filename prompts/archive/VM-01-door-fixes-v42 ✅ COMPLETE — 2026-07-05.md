# CC PROMPT — VM-01 Left-Zone Door: Single-Piece Rebuild + Static Stopper + Isolation Toggles
# Date: 2026-07-05
# Save to: /prompts/VM-01-door-fixes-v42.md
# Source: vending-machine/VM-01-base/VM-01-base-v41.scad

---

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order before touching anything. State every file read:
1. cc_rules.md
2. cc_chat_log.md (last 3 entries)
3. rules-dimensions.md
4. .claude/SKILL_manifold_triage.md
5. vending-machine/VM-01-base/VM-01-base-v41.scad (current committed source)

---

## 2. CONTEXT

Janis QA'd v41 in SketchUp/OpenSCAD directly and found 6 real issues, all
confirmed against the live file by Claude Web (not assumptions):

1. **Door is two disconnected pieces, not one.** The return flange
   (`X: door_left_x` to `door_left_x+door_t` = 2–5mm) and the main front
   panel (`X: door_left_x+return_depth` to `door_right_x` = 25–414mm) do
   not touch — there is a 20mm gap (X 5–25) with no material at all. This
   is a spec error from the original prompt (Claude Web specified two
   separate cubes without ensuring they share a face) — cc built exactly
   what was asked, this is not a cc error.
2. **No way to isolate the door to inspect the shell's left-wall cutout
   underneath it.** No `show_door` toggle exists. Separately, confirmed:
   `outer_shell_debug()`'s left product zone cutout only cuts the FRONT
   face — there is currently no cutout in the LEFT SIDE wall at all for
   the return flange/hinge to sit in.
3. **Stopper rod incorrectly rotates with the door.** It's written inside
   the same `rotate([0,0,-door_open_angle])` block as the door leaf,
   which defeats its purpose as a fixed stop — a stop that moves with the
   thing it's stopping isn't a stop. The acrylic pane, by contrast, IS
   correctly inside that same rotation already (it should move with the
   door) — but it's also gated by `render_mode=="full"`, so testing
   `door_open=true` under a different render_mode makes it disappear
   entirely, which can look like "it stayed behind." Re-test with
   `render_mode="full"` once Task 2 below lands.
4. Exit flap — confirmed working, no change needed.
5. **Acrylic/window framing looks asymmetric — confirmed NOT a separate
   acrylic-sizing bug, verified numerically in sandbox.** Window area =
   138,768mm² (336×413), acrylic area = 146,358mm² (346×423) — a uniform
   +5mm border on every side, exactly per spec. The acrylic formula itself
   is correct; do not change it. The visible mismatch is entirely a side
   effect of issue #1: frame border left of the window currently measures
   only 15mm (`window_x0=40` minus the panel's buggy actual edge at
   X=25) versus 38mm on the right — the uniform 5mm acrylic overlap eats
   a third of the already-too-thin left margin, reading as "acrylic
   bigger than the frame" when it's actually "frame too thin on one
   side." Fixing #1 alone resolves this — once the panel's true left edge
   moves to X≈5, left frame becomes ~35mm, roughly symmetric with the
   right (38mm). Do NOT touch `acrylic_border`, `window_margin_side`, or
   any acrylic dimension in this prompt — only the panel geometry from
   Task 1.
6. **2-manifold warning returned.** Primary suspect: the flange/panel gap
   itself (a gap is non-manifold by definition) plus the hinge-seam mark
   cubes, which currently only touch the flange along a partial face
   (T-junction pattern — same class of bug documented in rules-codes.md
   from the v18-v20 manifold history). Confirm via the standard isolation
   method in SKILL_manifold_triage.md after Task 1 is applied — do not
   assume Task 1 alone clears it.

---

## 3. NEW FILES

None. Edits VM-01-base-v41.scad in place, saves as v42.

---

## 4. TASKS

### TASK 1 — Rebuild `left_zone_door()`'s flange+panel as ONE continuous piece

Replace the current two-cube approach (separate return-flange cube and
main-panel cube, currently disconnected) with a single 2D cross-section
extruded through the door's height — this is what actually guarantees
"one piece with a bend," not two cubes that happen to be adjacent.

Build a 2D polygon in the XY plane representing the door's L-shaped
cross-section:
- Point A: `(door_left_x, hinge_y)` — hinge line, on the side wall plane
- Point B: `(door_left_x, skin_t)` — where the flange meets the front face plane
- Point C: `(door_right_x, skin_t)` — front-right corner of the panel
- Point D: `(door_right_x, skin_t + door_t)` — front-right, inner face
- Point E: `(door_left_x + door_t, skin_t + door_t)` — inner face, back to the corner
- Point F: `(door_left_x + door_t, hinge_y)` — back to the hinge line, inner face

`linear_extrude(height = door_h)` this polygon, translated to `door_bot_z`.
This produces one true manifold solid with a real bent corner — no gap,
no coincident-face T-junction with the rest of the assembly.

Cut the top window and exit-flap openings from this extruded solid via
`difference()`, same X/Z ranges as currently computed
(`window_x0/x1/z0/z1`, `exit_x`/`exit_bot_z`/`exit_w`/`exit_h` — unchanged
formulas, verify against the live file, do not recompute from scratch).

Hinge-seam mark cubes (item 3): extend each mark's Y-range by a small
overlap (e.g. `hinge_mark_d + e`) into the flange body rather than sitting
flush at its face, to avoid a repeat T-junction contact.

### TASK 2 — Move the stopper rod OUT of the rotating leaf

Remove item 8 (stopper rod) from inside `left_zone_door()`'s
`rotate([0,0,-door_open_angle])` block entirely. Create a new standalone
module, `flap_stopper_rod()`, containing just that rod (same `stop_y`/
`stop_z` derivation, same diameter/span), called separately in ASSEMBLY
— NOT nested inside `left_zone_door()`, NOT affected by `door_open`. It
must be positioned in world coordinates matching the door's CLOSED-state
geometry (it stops the flap regardless of whether the main door is open
or closed).

### TASK 3 — Add left-side-wall recess for the return flange/hinge

In `outer_shell_debug()` (and `outer_shell()` for consistency, though only
the debug variant is live in ASSEMBLY), add a cutout in the LEFT SIDE
wall (X near 0) spanning `Y: skin_t` to `hinge_y`, `Z: door_bot_z` to
`door_top_z` (local-Z equivalents per the existing convention — subtract
`leg_h` same as the other cutouts in this module), sized so the return
flange sits flush and the hinge line has real wall material to mount
into. Confirm the exact recess depth against `return_depth` (23mm) and
`hinge_y` (25mm) already defined — do not introduce new unexplained
numbers.

### TASK 4 — Add isolation toggles

Add alongside the existing `show_shell_*`/`door_open`/`flap_open`/
`tray_out_pct` toggle block:

```
show_door    = true;   // false -> hide left_zone_door() entirely, for
                        // inspecting the shell's left-wall cutout underneath
show_acrylic = true;   // false -> hide the acrylic pane independent of render_mode
show_flap    = true;   // false -> hide the exit flap independent of show_door
```

Wire `show_door` around the `left_zone_door()` call in ASSEMBLY. Wire
`show_acrylic` around the acrylic pane's own `if` block (in addition to,
not replacing, the existing `render_mode=="full"` gate — both conditions
must be true to show it). Wire `show_flap` around the flap geometry
specifically, independent of the rest of the door.

### TASK 5a — Establish named Z-datums (prevents this class of bug recurring)

Root structural issue, not just the tray_0_z symptom fixed in Task 5b below:
this file has no single source of truth for shared reference heights. Values
like `window_z0`, `tray_0_z`, `flap_top_z` are each derived from their own
independent formula chain (e.g. `tray_0_z = leg_h + exit_door_h` vs
`flap_top_z = exit_bot_z + exit_h` vs `door_bot_z = leg_h` — three separate
chains that can drift apart silently, which is exactly what happened here).

Add ONE block near the top of the file, clearly marked, defining the
machine's key Z-reference planes as named datums — computed once, from
raw dimensions only (never from each other in a multi-step chain):

```
// ─────────────────────────────
// DATUMS — single source of truth for shared Z-reference planes.
// Every module below must reference ONE of these directly for any
// position shared with another module. Never derive a new "local"
// version of one of these values inside a module — reference the
// datum itself. If a datum's definition changes, everything that
// references it updates automatically; nothing should need editing
// in more than one place.
// ─────────────────────────────
DATUM_FLOOR      = 0;
DATUM_LEG_TOP    = leg_h;                        // 50 -- body sits here
DATUM_FLAP_TOP   = DATUM_LEG_TOP + 30 + exit_h;  // hinge line of the exit flap
DATUM_TRAY_BOT   = DATUM_FLAP_TOP + window_flap_gap; // tray zone starts here
DATUM_TRAY_TOP   = DATUM_TRAY_BOT + tray_zone_h; // 242mm of trays, from real tray_h*tray_count
DATUM_ROOFLINE   = total_h;                      // 700 -- absolute top
```

Then refactor every module that currently derives a shared reference point
independently to use these datums instead:
- `tray_0_z` → `DATUM_TRAY_BOT` (this IS Task 5b, done via the datum, not
  a one-off patch)
- `flap_top_z` (inside `left_zone_door()`) → `DATUM_FLAP_TOP`
- `window_z0` → `DATUM_TRAY_BOT` (not a separately-derived value)
- `window_z1` → `DATUM_TRAY_TOP` (window now bounds the actual tray rack,
  not an independently-guessed size)
- `door_bot_z` → `DATUM_LEG_TOP`

Verify no module still computes its own local copy of any of these five
values via a separate formula — every one of them must reference the
datum directly.

### TASK 5b — Tray/window sync (now implemented via Task 5a's datums)

With Task 5a's datums in place, `tray_0_z`, `window_z0`, and `window_z1`
now share the same source of truth automatically — this replaces the
need for a separate one-off numeric patch. Confirm `tray_zone_h` (242mm,
2 trays × 121mm) still fits cleanly between `DATUM_TRAY_BOT` and
`DATUM_TRAY_TOP` with no overlap or gap. Flag to Janis in cc_chat_log if
tray count/spacing needs to change to fit — do not silently alter it.

After this, the window/acrylic frame should visibly bound the actual
tray rack exactly — not float around it or crop it.

### TASK 6 — Add datum-referencing rule to rules-codes.md

Append to rules-codes.md, under a "Datum Rules" section (new section if
none exists):

```
**Rule: Shared reference points must be named datums, referenced directly
— never re-derived per module.**
If two or more modules need the same Z (or X/Y) reference point, it must
be defined ONCE as a named DATUM_* constant, computed only from raw
dimensions (never from another derived variable in a separate chain).
Every module needing that reference point must use the datum directly.
This was violated in v41: tray_0_z and the door's window_z0/z1 were each
derived independently, drifted apart when the flap height changed, and
produced a visible mismatch between the window/acrylic frame and the
actual tray rack. Fixed in v42 via an explicit DATUMS block — see
VM-01-base-v42.scad header.
```

Bump rules-codes.md version, date 2026-07-05.

---

## 5. DO NOT TOUCH

- `outer_shell_debug()`'s shell-height fix (`shell_h`, from v40) — do not
  touch, already correct
- `acrylic_display()` (right-zone dashboard panel) — unrelated, unrelated
  corner, out of scope
- `spring_tray()`, `tray_out_pct` wiring — already correct, unrelated to
  these 6 issues
- All other `.scad` files

---

## 6. QA VERIFICATION

- [ ] F6 render: door leaf renders as one continuous solid, no visible
      seam/gap at the flange-to-panel corner
- [ ] `show_door=false` screenshot: left-wall recess cutout clearly
      visible with the door hidden
- [ ] `door_open=true` + `render_mode="full"` screenshot: stopper rod
      stays in its fixed position while the door swings open; acrylic
      pane visibly rotates WITH the door
- [ ] `show_acrylic=false` screenshot: acrylic hidden, door frame/window
      opening still visible
- [ ] Frame border left of window ≈35mm, right ≈38mm (roughly symmetric)
      — confirms issue #5 (acrylic looking oversized) is resolved by
      Task 1 alone; no change to acrylic dimensions themselves
- [ ] Tray rack visibly sits within the window/acrylic frame bounds after
      Task 5's resync — not floating in empty space above/below it, and
      not cropped by the window edges
- [ ] DATUMS block exists near the top of the file, and `tray_0_z`,
      `flap_top_z`, `window_z0`, `window_z1`, `door_bot_z` each reference
      a named datum directly — confirm none of them still compute their
      own independent formula chain
- [ ] `show_flap=false` screenshot: flap hidden independent of door
- [ ] 2-manifold warning gone — confirm via isolation method in
      SKILL_manifold_triage.md, report which specific change (if more
      than Task 1) resolved it, not just "warning gone"
- [ ] No undefined-variable warnings
- [ ] Version incremented v41→v42, not overwritten

---

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at TOP, under 10 lines
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-05
3. Update knowledge.map (new toggle states, v42 filenames)
4. Bump version on all changed files
5. Commit all → merge to main
