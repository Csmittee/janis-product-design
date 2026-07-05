# CC PROMPT — VM-01 Front Door: Datum Correction + Manifold Fix + Drop Zone
# Date: 2026-07-05
# Save to: /prompts/VM-01-door-datum-rebuild-v43.md
# Source: vending-machine/VM-01-base/VM-01-base-v42.scad
# Scope: FRONT DOOR ASSEMBLY ONLY (left_zone_door, its recess pocket in the
# shell, drop_zone_visual). No other BOM item touched this round.

---

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order before touching anything. State every file read:
1. cc_rules.md
2. cc_chat_log.md (last 3 entries)
3. rules-dimensions.md
4. .claude/rules-codes.md ("Datum Rules" section)
5. .claude/SKILL_product_design_skeleton.md
6. .claude/SKILL_manifold_triage.md
7. vending-machine/VM-01-base/VM-01-base-v42.scad (current committed source)

---

## 2. CONTEXT

This is a from-scratch rebuild of the front door's coordinate math, not a
patch. Root cause of the recurring desync bugs on this part: dimensions
were being measured from whatever was nearby (a datum name, a cosmetic
tuning parameter, a Cousin module) instead of each part's true Parent.
Janis walked through this in detail; the corrected design logic below is
Janis-confirmed, point by point, before this prompt was written.

**Explicit governance note:** `.claude/SKILL_product_design_skeleton.md`
grandfathers VM-01 out of the new Skeleton/Datum-Reference-Frame system.
This prompt is a Janis-approved, door-scoped EXCEPTION to that clause —
apply the corrected logic below to the front door assembly only. Do not
touch any other VM-01 module's coordinate system.

### 2.1 — Foot base must be explicit, never folded into a datum name

`DATUM_LEG_TOP = leg_h` silently absorbed the 50mm foot height into a
datum label. Any part built on `DATUM_LEG_TOP` looked "floor-referenced"
but was actually one hidden addition away from true ground. Fix:
introduce `FOOT_BASE_H` as its own named constant, and require every
vertical stack calculation from ground to show it as an explicit added
term.

### 2.2 — Hinge center is the door's datum; the shell derives it independently

Two assemblies mate at the hinge: the shell (which cuts a recess pocket)
and the door (which pivots there). Per Janis: **the hinge center is the
referential datum for the ENTIRE door assembly** — every door dimension
(flange/trim line, face offset, depth, width, window, flap, acrylic)
transfers from this one point. The shell does NOT read the door's local
origin (that would be a Cousin reference) — it independently re-derives
the same world coordinate from its OWN structural datum (the sharp corner
above the foot base). The two must land on the same number by shared use
of named constants (`HINGE_Y_OFFSET`, `hinge_od`, `FOOT_BASE_H`), never by
one module reaching into the other's variable.

**Hinge center, world coordinates:**
- `Z = FOOT_BASE_H + 0` — sits directly on the body floor, explicit term
- `Y = HINGE_Y_OFFSET = 25mm` — fixed, independent constant, measured from
  the shell's theoretical SHARP corner (the invisible intersection of the
  front face plane extended and the left side face plane extended — NOT
  the rounded fillet's center at `(corner_r, corner_r)`). This number does
  NOT move if `corner_r` is tuned later for cosmetic reasons — `corner_r`
  becomes a separate clearance check ("does 25mm still clear the curve"),
  not an input to this formula. Do not write this as `corner_r + 5`.
- `X = 0 - (hinge_od / 2)` — the hinge barrel is exposed on the exterior
  (door opens outward, cannot be concealed inside the cavity), so its
  center sits proud of the shell's exterior wall face (world X=0),
  offset outward by half the barrel diameter.

This point becomes the door's LOCAL ORIGIN (0,0,0 in door space). Replace
the current `translate([door_left_x, hinge_y, door_bot_z])` anchor with
this corrected point. Every existing child offset inside `left_zone_door()`
(window, flap, acrylic, hinge marks, flange/trim polygon) is re-expressed
relative to this new origin — do not change their relative geometry,
only what they're measured FROM.

The shell's Task-3 recess pocket (`outer_shell_debug()`/`outer_shell()`)
must independently compute this same point from ITS OWN datum chain (its
own sharp-corner reference + `FOOT_BASE_H` + `HINGE_Y_OFFSET` + `hinge_od`)
— do not have the shell read `left_zone_door()`'s local variables.

### 2.3 — Window/acrylic: no Cousin reference to tray naming

`window_z0`/`window_z1` were derived from `DATUM_TRAY_BOT`/`DATUM_TRAY_TOP`
— numerically correct, but the name implied a dependency that doesn't
structurally exist (the window is the door's own feature, not the tray's).
Freeze these as the door's own local constants, offset from the door's
new local origin, not from any tray datum:

```
window_x0 = 38;    // local X, origin -> window left edge
window_z0 = 220;   // local Z, origin -> window bottom edge
window_w  = 336;
window_h  = 242;
```

Acrylic: same corner as the window, offset outward 5mm on all 4 sides —
already correct in v42, keep this relationship, just re-anchor to the
frozen local constants above instead of the old `DATUM_TRAY_*`-derived
variables.

### 2.4 — Curved flange (from prior QA round, unchanged from last agreed direction)

The flange/trim line (points A-F in the current polygon) is a hard 90°
bend. Replace with an arc that follows the shell's actual rounded corner,
sampled (12+ segments) between the hinge line and the front face, derived
from `corner_r` and `skin_t` live — not hardcoded numbers. See prior
agreed math: inner curve center `(skin_t + (corner_r-1), skin_t + (corner_r-1))`,
radius `corner_r - 1`.

### 2.5 — 2-manifold warning: 3 confirmed root causes (isolation-tested)

All three are the same bug class — a face sitting flush (zero clearance)
against the shell's inner wall, missing the `e=0.01` epsilon required by
`.claude/rules-codes.md` "Epsilon offset on coplanar faces":
- `left_zone_door()` — front face flush at world Y=`skin_t`
- `drop_zone_visual()` — flush at X=`skin_t`, Z=`leg_h` (see 2.6 — this
  module is being restructured, apply the epsilon fix to whatever remains)
- `sensor_strip()` — flush at X=`skin_t`, both strips

### 2.6 — drop_zone_visual(): remove the ghost faces blocking the drop path, keep real safety panels

Current module is a single translucent box behind the flap — all 6 faces
present, 3 of them functionally blocking the product's actual drop path:

```
module drop_zone_visual() {
    color("#F0F0F0", 0.15)
    translate([skin_t, skin_t, leg_h])
        cube([product_w-(skin_t*2), drop_zone_d, exit_door_h]);
}
```

**Remove entirely:**
- Top/bottom faces (constant Z) — blocked vertical product drop
- Front/back faces (constant Y) — blocked front-to-back product path

**Keep, and make REAL (not visual-only):** the two faces at constant X
(left and right sides of the drop zone, spanning Y-Z) — these are a
genuine safety guard preventing a hand from reaching in sideways past the
drop zone toward the mechanism above. Rebuild as solid 2mm panels
(matching `skin_t`), not translucent:

```
// Left/right drop-zone guards — solid, prevent hand access from the
// sides into the mechanism above. Real geometry, not visual aid.
module drop_zone_guards() {
    color("#DDDDDD")
    for (side_x = [skin_t + e, product_w - skin_t - skin_t - e])
        translate([side_x, skin_t + e, leg_h])
            cube([skin_t, drop_zone_d, exit_door_h]);
}
```
(Confirm exact X placement/epsilon direction against live geometry —
don't just paste the above blind; verify it doesn't intersect the door's
new hinge/flange geometry from 2.2.)

Replace the `drop_zone_visual()` call in ASSEMBLY with `drop_zone_guards()`.

---

## 3. NEW FILES

None. Edits VM-01-base-v42.scad in place, saves as v43.

---

## 4. TASKS

1. Add `FOOT_BASE_H` constant (§2.1), refactor door's Z-stack to use it explicitly.
2. Add `HINGE_Y_OFFSET` and re-derive hinge center per §2.2 (both door's local origin AND shell's independent recess-pocket calc — two separate code locations, same resulting number, no cross-reference).
3. Freeze window/acrylic local constants per §2.3.
4. Curved flange per §2.4.
5. Epsilon fixes on `left_zone_door()`, `sensor_strip()`, and whatever remains of the drop zone module, per §2.5.
6. Replace `drop_zone_visual()` with `drop_zone_guards()` per §2.6.

---

## 5. DO NOT TOUCH

- Any other BOM item (tray, console, top-right display door, stopper rod, tray rail, exit/drop sensor brackets, rear service door) — out of scope this round
- The hollow space under/behind the 2 trays — Janis has flagged a future partition + back-door "spare storage" feature here; DO NOT build it now, do not add any partition in this prompt. Add a one-line `// TODO(Janis, deferred): partition + back door for spare storage under trays` comment near `spring_tray()`/`tray_rack()` and stop there.
- `flap_stopper_rod()`, `tray_zone_frame()` — confirmed manifold-clean, no change
- DATUMS block for the tray zone (`DATUM_TRAY_BOT/TOP`) itself — only the door's *reference to* it is being removed, the tray datums stay as-is for the tray zone's own use

---

## 6. QA VERIFICATION

- [ ] Full CGAL render reports no 2-manifold warning — paste actual output
- [ ] F6 Preview (not Thrown Together): door corner shows continuous curve matching shell's `corner_r`
- [ ] Hinge center verified: door's local origin and shell's independently-derived recess-pocket location are the SAME world coordinate — show both calculations' final numbers side by side in the commit message
- [ ] Drop zone: looking straight through from the front with `show_door=false`, no ghost surface blocks the view top-to-bottom or front-to-back; the two side guard panels ARE visible and solid
- [ ] Window/acrylic still bordered symmetric, no change in appearance from v42 (only the reference chain changed, not the numbers)
- [ ] All existing toggles (`door_open`, `flap_open`, `tray_out_pct`, `show_door/acrylic/flap`, `render_mode`) still compile clean
- [ ] Version incremented v42→v43

---

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at TOP, under 10 lines, explicitly note the door-scoped Skeleton exception and the deferred tray-storage TODO
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-05
3. Update knowledge.map if warranted
4. Bump version on all changed files
5. Commit all → merge to main
