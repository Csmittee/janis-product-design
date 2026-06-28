# CC PROMPT — VM-01-base-v24 — spring_tray() Manifold Fix + tray_zone_frame Height
# Date: 2026-06-28
# Save to: /prompts/VM-01-base-v24-spring-tray-fix.md

---

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order before touching anything. State every file read:
1. cc_rules.md
2. cc_chat_log.md (last 3 entries)
3. rules-dimensions.md
4. rules-codes.md
5. vending-machine/VM-01-base/VM-01-base-v23.scad ← READ FULL FILE FIRST

---

## 2. CONTEXT — KT CONFIRMED ROOT CAUSE

After 7 versions of failed fixes, Janis manually performed comment-toggle isolation
testing in OpenSCAD F6. Result confirmed today 2026-06-28:

**`spring_tray()` is the sole 2-manifold culprit.**

Method: All other modules were commented out — warning still appeared.
Then `for (t = [0:tray_count-1]) spring_tray(t);` was commented out — warning GONE.
All other modules restored — warning stayed gone. spring_tray() confirmed.

KT R-111 is now resolved with confirmed root cause. This prompt contains the fix.

---

## 3. NEW FILES

- vending-machine/VM-01-base/VM-01-base-v24.scad

Add to knowledge.map. Mark v23 as Superseded.

---

## 4. TASKS

### TASK 1 — Fix spring_tray() — 3 specific geometry defects

Read v23 spring_tray() module in full before writing any change.

The module has a `difference()` of a `union()` tray body minus window cutouts.
Three geometry defects cause non-manifold:

---

**Defect 1 — union() floor cube shares only an EDGE with side walls.**

Current union() structure:
```openscad
union() {
    cube([tray_w, tray_d, tray_floor_t]);              // FLOOR — thin slab
    translate([0, tray_d - tray_wall_t, 0])
        cube([tray_w, tray_wall_t, tray_h]);           // REAR WALL
    cube([tray_wall_t, tray_d, tray_h]);               // LEFT WALL
    translate([tray_w - tray_wall_t, 0, 0])
        cube([tray_wall_t, tray_d, tray_h]);           // RIGHT WALL
}
```

Problem: The floor cube is `tray_floor_t` tall (5mm). The left/right wall cubes
start at Z=0 and go full height `tray_h`. They share the same Z=0 base plane —
but the floor cube only overlaps the walls for 5mm of height, then the walls
continue upward with only an edge contact against air. In CGAL, this T-junction
(floor top face flush against wall interior) creates a non-manifold topology.

Fix: Embed the floor INTO the walls by making the floor cube the full height
of tray_h but then cutting it back with the difference(). Better: merge the
floor into the union properly by making all 4 walls overlap with the floor.

**Cleanest fix — replace the union() with a single difference() approach:**

Replace the entire `difference() { union(){...} ... }` block with a simpler
open-box construction using a single difference():

```openscad
// Tray body — open top, open front (Y=0 face)
// Single solid box, hollow interior subtracted = clean manifold geometry
color("#CCCCCC")
difference() {
    // Outer solid box — full tray footprint
    cube([tray_w, tray_d, tray_h]);

    // Hollow interior — subtracted from inside, leaving floor + walls
    translate([tray_wall_t, tray_wall_t, tray_floor_t])
        cube([tray_w - (tray_wall_t * 2),
              tray_d - (tray_wall_t * 2),
              tray_h - tray_floor_t + 1]);    // +1 overshoot = open top

    // Open front face (Y=0 side) — customers see springs
    translate([tray_wall_t, -1, tray_floor_t])
        cube([tray_w - (tray_wall_t * 2),
              tray_wall_t + 2,
              tray_h - tray_floor_t + 1]);

    // Left side wall window (viewing window)
    translate([-1, tray_wall_t * 2, tray_floor_t + tray_wall_t])
        cube([tray_wall_t + 2,
              tray_d - (tray_wall_t * 4),
              tray_h - tray_floor_t - (tray_wall_t * 2)]);

    // Right side wall window (viewing window)
    translate([tray_w - tray_wall_t - 1, tray_wall_t * 2, tray_floor_t + tray_wall_t])
        cube([tray_wall_t + 2,
              tray_d - (tray_wall_t * 4),
              tray_h - tray_floor_t - (tray_wall_t * 2)]);

    // Rear motor mount cutouts
    for (i = [0:spring_lanes-1]) {
        x = tray_wall_t + spring_od/2 + i*(spring_od + spring_gap);
        translate([x - 11, tray_d - tray_wall_t - 1, tray_floor_t])
            cube([22, tray_wall_t + 2, 35]);
    }

    // Rear latch pin hole
    translate([tray_w/2, tray_d - tray_wall_t - 1, tray_h/2])
        rotate([-90, 0, 0])
            cylinder(d=latch_pin_d, h=tray_wall_t + 2);
}
```

Key changes in this approach:
- Start with ONE solid cube (full tray_w × tray_d × tray_h) — always manifold
- Subtract hollow interior in one operation — no union() T-junctions
- Open top via +1 overshoot on hollow height
- Open front face via explicit front-face subtract
- Side windows now use `tray_wall_t * 2` Y-start offset (not `tray_wall_t`)
  to avoid cutting into rear wall region

---

**Defect 2 — Side window subtractors use translate([-1,...]) cutting through outer face.**

Current code:
```openscad
// Left side wall window
translate([-1, tray_wall_t, tray_floor_t + tray_wall_t])
    cube([tray_wall_t + 2, ...]);
```

The `translate([-1,...)` moves the subtractor 1mm OUTSIDE the tray on the left.
Since the left wall is `tray_wall_t` thick (3mm), the subtractor at X=-1 with
width `tray_wall_t+2` (5mm) cuts FROM X=-1 TO X=4mm — removing the entire
3mm left wall and 1mm beyond. This creates an open hole through the outer face.

This is fixed in the new approach above — the window subtractor starts at X=0
(inside the wall face) and overshoots right with `tray_wall_t+2` width.
The `-1` is on the RIGHT side of the subtractor (translate X = tray_w - tray_wall_t - 1)
which overshoots outward correctly for the boolean cut. That direction is fine.
The LEFT side must NOT use translate([-1,...]).

The new approach above already corrects this.

---

**Defect 3 — spring_coil() inner cylinder — verify v23 has spring_l-1 (not spring_l+1).**

Read v23 spring_coil() module. Confirm inner cylinder is `spring_l-1`.
If it reads `spring_l+1`, change to `spring_l-1`.
If already `spring_l-1` (fixed in v20), leave it — do not change.

cc must READ the live file and confirm — do not assume.

---

### TASK 2 — Fix tray_zone_frame() height to match spring_zone_panel()

In v23, `spring_zone_panel()` was extended to Z 300–700 (panel_h = 400mm).
The frame that borders this panel must match. Currently it uses `tray_zone_h`
(242mm, Z 300–542). Must be updated to 400mm (Z 300–700).

Add these two derived variables to the PARAMETERS section, after the existing
tray zone variables:

```openscad
panel_zone_top_z = total_h;                          // 700mm
panel_zone_h     = panel_zone_top_z - tray_0_z;      // 400mm (Z 300-700)
```

Then update `tray_zone_frame()` — replace `tray_zone_top_z` with `panel_zone_top_z`
and replace `tray_zone_h` with `panel_zone_h`:

```openscad
module tray_zone_frame() {
    color("#AAAAAA")
    union() {
        // Top bar — full width, owns top corners — Z 700
        translate([0, e*2, panel_zone_top_z - frame_bar])
            cube([product_w, skin_t, frame_bar]);
        // Bottom bar — full width, owns bottom corners — Z 300
        translate([0, e*2, tray_0_z])
            cube([product_w, skin_t, frame_bar]);
        // Left bar — middle only, Z 300+frame to 700-frame
        translate([0, e*2, tray_0_z + frame_bar])
            cube([frame_bar, skin_t, panel_zone_h - (frame_bar * 2)]);
        // Right bar — middle only, Z 300+frame to 700-frame
        translate([product_w - frame_bar, e*2, tray_0_z + frame_bar])
            cube([frame_bar, skin_t, panel_zone_h - (frame_bar * 2)]);
    }
}
```

Read v23 live code to confirm exact current variable names before writing.

---

### TASK 3 — Update rules-codes.md with lesson learned

Append to the **OpenSCAD 2-Manifold Rules** section:

```
**Rule: Never build a tray/box using union() of separate floor + wall pieces.**
When a thin floor cube meets tall wall cubes at a shared Z=0 base, CGAL detects
T-junction topology = non-manifold. The correct pattern is ONE solid outer box
with hollow interior subtracted via difference(). This is always manifold.
Pattern:
  difference() {
    cube([w, d, h]);                              // solid outer
    translate([wall, wall, floor])
      cube([w-(wall*2), d-(wall*2), h-floor+1]); // hollow interior, +1 open top
  }
Never use: union() { thin_floor_cube; tall_wall_cube; tall_wall_cube; }
```

Bump rules-codes.md to v1.4, date 2026-06-28.

---

## 5. DO NOT TOUCH

- rules-dimensions.md — read only, never edit
- outer_shell() — do not modify
- dashboard() — do not modify
- sensor_strip() — do not modify
- front_door() — do not modify
- flap_door() — do not modify
- spring_zone_panel() — do not modify
- acrylic_display() — do not modify
- compartment_divider() — do not modify
- tray_rack() — do not modify
- WORKFLOW_SKILL.md, chat_rules.md — Claude Web documents only

---

## 6. QA VERIFICATION

Before committing, confirm ALL:

- [ ] v24 version header: Version v24, date 2026-06-28
- [ ] spring_tray(): uses single solid cube difference() approach (no union() floor+walls)
- [ ] spring_tray(): left side window subtractor does NOT use translate([-1,...]) on left wall
- [ ] spring_tray(): open front face subtract present (Y=0 side open for spring viewing)
- [ ] spring_tray(): rear motor cutouts and latch pin hole preserved
- [ ] spring_coil(): inner cylinder confirmed spring_l-1 (read from live file)
- [ ] panel_zone_top_z and panel_zone_h declared in PARAMETERS
- [ ] tray_zone_frame(): top bar uses panel_zone_top_z (NOT tray_zone_top_z)
- [ ] tray_zone_frame(): side bars use panel_zone_h (NOT tray_zone_h)
- [ ] rules-codes.md updated to v1.4 with new union() box rule
- [ ] knowledge.map: v23 → Superseded, v24 → ACTIVE
- [ ] Janis must open v24 in OpenSCAD → F6 → confirm warning GONE

---

## 7. MANDATORY CLOSING

1. Append cc_chat_log.md — newest at BOTTOM. Include:
   - Confirm spring_tray() rewritten with single-box difference() approach
   - Confirm spring_coil() inner height (state which value was found in v23)
   - Confirm tray_zone_frame() height updated to panel_zone_h (400mm)
   - Confirm rules-codes.md updated to v1.4
   - FLAG FOR CLAUDE WEB: "Janis must open v24 F6 — confirm 2-manifold warning cleared"
   - FLAG FOR CLAUDE WEB: "KT R-111 resolution — root cause was spring_tray() union() T-junction"
2. Archive this prompt → prompts/archive/ stamped ✅ COMPLETE — 2026-06-28
3. Update knowledge.map: v23 → Superseded, v24 → ACTIVE
4. Bump version header on every file changed
5. Commit all in correct order → merge to main

Confirm every file committed after merge.
