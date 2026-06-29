# CC PROMPT — VM-01-base-v29
# Date: 2026-06-29
# Author: Claude Web
# Status: READY FOR EXECUTION

---

## 1. SESSION START — READ IN ORDER

```
1. git fetch --all
2. git merge origin/main
3. Read cc_rules.md
4. Read knowledge.map
5. Read cc_chat_log.md (last 3 entries)
6. Read this prompt file in full
7. Read vending-machine/VM-01-base/VM-01-base-v28.scad in full
8. Read rules-dimensions.md
9. Read .claude/rules-codes.md
```

Save-as: `vending-machine/VM-01-base/VM-01-base-v29.scad`
Never overwrite v28.

---

## 2. CONTEXT

v28 has 4 known issues to fix in one pass:
1. `total_w` and `system_w` too narrow — screen circuit board does not fit with tilt
2. Dashboard screen undercut clips right compartment shell corner — caused by insufficient compartment width
3. 2-manifold warning still present — spring coil front face overlaps motor rear face by 0.02mm
4. No debug visibility toggles — QA inspection of interior zones requires manual commenting

All 4 are addressed in v29. No design decisions changed. Tilt on screen stays — it is intentional.

---

## 3. NEW FILES

- `vending-machine/VM-01-base/VM-01-base-v29.scad` — add to knowledge.map, v28 → Superseded

---

## 4. TASKS

---

### TASK 1 — Widen machine: total_w and system_w

**Root cause:** `system_w = 185mm` gives `dash_w = 162mm`. Screen circuit board is 180×100mm landscape — needs minimum 181mm dash_w plus bezel clearance. Compartment is 9mm too narrow before tilt is even considered.

**In PARAMETERS section — change these two values:**

```openscad
// Before:
total_w = 620;
system_w = 185;

// After:
total_w = 640;
system_w = 204;    // screen board 180mm + bezel×2 + margin
```

All derived values that use `total_w` or `system_w` will update automatically.
Do not change any other parameters.
Verify: `dash_w = system_w - divider_t - (skin_t*2)` = 204 - 19 - 4 = **181mm** ✓

---

### TASK 2 — Dashboard undercut fix

**Root cause:** With `system_w = 185`, screen at `-30°` tilt clipped the right shell corner. Task 1 widens the compartment to 204mm which gives the tilt room to clear. No code change needed in `dashboard()` module itself — the width fix in Task 1 resolves this.

**cc must verify after writing v29:**
- Screen X start = `product_w + divider_t + 10` = 416 + 19 + 10 = 445mm
- Screen right edge (flat) = 445 + screen_w = 445 + 165 = 610mm
- total_w = 640mm — shell right inner face = 640 - skin_t = 638mm
- Clearance = 638 - 610 = **28mm** before tilt displacement ✓
- Flag in cc_chat_log if this clearance looks insufficient after visual check

---

### TASK 3 — Fix 2-manifold: spring coil overlaps motor

**Root cause:** In `spring_tray()` for-loop, coil is placed at Y = `spring_l + e` = 390.01mm. After `rotate([90,0,0])` the coil extends -Y by `spring_l = 390mm`. Coil front face lands at 390.01mm. Motor rear face = `tray_d - motor_d - e` = 389.99mm. Overlap = 0.02mm → non-manifold.

**Fix — change `spring_coil()` module only:**

```openscad
// Before:
module spring_coil() {
    color("#888888", 0.8)
    cylinder(h=spring_l, d=spring_od);
}

// After:
module spring_coil() {
    color("#888888", 0.8)
    cylinder(h=spring_l - 2, d=spring_od);  // -2mm clears motor face, visual only
}
```

This gives 2mm clearance between coil front face and motor rear face.
Do not change `spring_l` parameter — change is local to this module only.
Do not change any translate values in the for-loop.

---

### TASK 4 — Add debug visibility toggles

**Root cause:** QA inspection of interior zones (spring tray, dashboard, manifold area) requires manually commenting out shell panels. This is slow and error-prone. Toggles make it one-line per panel.

**Add these parameters to the PARAMETERS section, at the bottom before epsilon:**

```openscad
// ─────────────────────────────
// DEBUG TOGGLES — set false to hide panel for interior inspection
// All true = normal render. Change to false to expose interior zones.
// ─────────────────────────────
show_shell_top   = true;   // hide to inspect tray zone from above
show_shell_left  = true;   // hide to inspect spring lanes from left
show_shell_right = true;   // hide to inspect dashboard/screen from right
```

**Add this module after `outer_shell()` module definition:**

```openscad
module outer_shell_debug() {
    color("#C8C8C8", 0.75)
    difference() {
        rounded_box(total_w, total_h, total_d, corner_r);

        // Hollow interior
        translate([skin_t, skin_t, skin_t])
            rounded_box(total_w-(skin_t*2), total_h-(skin_t*2), total_d-(skin_t*2), corner_r-1);

        // Left product zone front cutout
        translate([skin_t, -1, 0])
            cube([product_w-(skin_t*2), skin_t+2, tray_zone_top_z - leg_h]);

        // Exit zone chute cutout
        translate([(product_w - exit_door_w)/2, -1, 0])
            cube([exit_door_w, skin_t+2, exit_door_h]);

        // Upper front display cutout
        translate([skin_t, -1, tray_zone_top_z - leg_h])
            cube([product_w-(skin_t*2), skin_t+2, upper_display_h]);

        // Right compartment front face opening
        translate([product_w + divider_t, -1, 0])
            cube([system_w - divider_t - skin_t, skin_t+2, tray_zone_top_z - leg_h]);

        // Top panel — removed when show_shell_top = false
        if (!show_shell_top)
            translate([0, 0, total_h - skin_t - 1])
                cube([total_w, total_d, skin_t + 2]);

        // Left panel — removed when show_shell_left = false
        if (!show_shell_left)
            translate([-1, 0, 0])
                cube([skin_t + 2, total_d, total_h]);

        // Right panel — removed when show_shell_right = false
        if (!show_shell_right)
            translate([total_w - skin_t - 1, 0, 0])
                cube([skin_t + 2, total_d, total_h]);
    }
}
```

**In ASSEMBLY — replace the existing `outer_shell()` call:**

```openscad
// Before:
translate([0, 0, leg_h]) outer_shell();

// After:
translate([0, 0, leg_h]) outer_shell_debug();
```

Keep `outer_shell()` module in the file — do not delete it. It remains the clean reference.

---

## 5. DO NOT TOUCH

- rules-dimensions.md — READ ONLY for this task (screen spec is documented below for Janis to update separately)
- All .scad files except VM-01-base-v29.scad
- spring_gap = 13mm — OWNER-LOCKED — do not change
- Screen tilt `rotate([-30, 0, 0])` — intentional design — do not remove
- All other parameters not listed in Task 1

**Note for Janis — update rules-dimensions.md manually after this session:**
```
## Screen — Dashboard
- Circuit board: 180 × 100mm
- Active display: 165 × 100mm (landscape, portrait planned for future)
- Tilt: -30° (inset for shipping protection — LOCKED)
```

---

## 6. QA VERIFICATION

cc confirms before committing:
- [ ] `total_w = 640` in parameters
- [ ] `system_w = 204` in parameters
- [ ] `dash_w` derived value = 181mm (verify by calculation in comment)
- [ ] `spring_coil()` uses `spring_l - 2` — no other coil change
- [ ] `spring_l` parameter unchanged at 390
- [ ] `outer_shell_debug()` module present with 3 if-blocks
- [ ] `outer_shell()` original module still present, not deleted
- [ ] Assembly calls `outer_shell_debug()` not `outer_shell()`
- [ ] All 3 debug toggles default to `true` (normal render by default)
- [ ] No undefined variable warnings in SCAD
- [ ] Version header updated to v29, date 2026-06-29
- [ ] Changes from v28 listed in header comment

---

## 7. MANDATORY CLOSING

1. Append cc_chat_log.md — newest entry at BOTTOM. Include:
   - All files committed
   - Confirm total_w=640, system_w=204, spring_coil h=spring_l-2
   - Confirm outer_shell_debug() added with 3 toggles
   - FLAG: "Janis must F6 v29 — confirm 2-manifold warning GONE"
   - FLAG: "Janis must test show_shell_right=false to inspect dashboard clearance"
   - FLAG: "Janis to update rules-dimensions.md with screen spec manually"
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-06-29
3. Update knowledge.map — v28 → Superseded, v29 → ACTIVE
4. Bump version on all changed files
5. Commit all → merge to main
