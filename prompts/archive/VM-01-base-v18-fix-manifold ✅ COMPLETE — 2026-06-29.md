# CC PROMPT — VM-01-base-v18 Fix 2-Manifold (Surgical Fix)
> Version 1.0 — 2026-06-28
> Task: Fix mixed world/local Z coordinates inside outer_shell() — true 2-manifold source
> Source: vending-machine/VM-01-base/VM-01-base-v17.scad
> Save as: vending-machine/VM-01-base/VM-01-base-v18.scad
> Save this prompt to: /prompts/VM-01-base-v18-fix-manifold.md

---

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order before touching ANYTHING. State each file read:
1. `cc_rules.md`
2. `knowledge.map`
3. `cc_chat_log.md` (last 3 entries)
4. `rules-dimensions.md`
5. `rules-codes.md`
6. `vending-machine/VM-01-base/VM-01-base-v17.scad` ← READ FULL FILE FIRST

---

## 2. ROOT CAUSE — CONFIRMED BY CLAUDE WEB

`outer_shell()` is called in assembly as:
```
translate([0, 0, leg_h]) outer_shell();
```

This means inside `outer_shell()`, local Z=0 = world Z=50 (leg_h).

BUT the cutouts inside `outer_shell()` use world Z values directly:
- `leg_h` (50mm) — already offset by assembly translate = cuts at wrong Z
- `tray_zone_top_z` (542mm) — same problem, overshoots shell entirely

**Effect:** Every front face cutout is 50mm too high.
This creates geometry that cuts OUTSIDE the shell boundary = non-manifold.

This violates rules-codes.md Rule: "Assembly Z offset must match module internals."

---

## 3. NEW FILES

- `vending-machine/VM-01-base/VM-01-base-v18.scad`

Add to knowledge.map. Mark v17 as Superseded.

---

## 4. THE FIX — One rule, applied consistently

**Rule:** Inside `outer_shell()`, all Z values must be LOCAL coordinates.
Local Z = World Z − leg_h.

Convert every cutout Z inside `outer_shell()` by subtracting `leg_h`:

| Cutout | Current (world Z) | Fixed (local Z) |
|---|---|---|
| Left product zone front | `leg_h` → `0` | start at local Z=0 |
| Left product zone height | `tray_zone_top_z - leg_h` → `tray_zone_top_z - (leg_h*2)` | ← WRONG, see below |
| Exit zone chute | `leg_h` → `0` | start at local Z=0 |
| Upper display cutout | `tray_zone_top_z` → `tray_zone_top_z - leg_h` | 542-50 = 492 local |
| Right compartment front | `leg_h` → `0` | start at local Z=0 |

**Heights that span a zone:** subtract leg_h from the START only, not the height itself.
Height is already a relative value — do not touch it.

---

## 5. EXACT CODE CHANGES — Apply to VM-01-base-v17.scad

### Change 1 — Left product zone front cutout (lines ~239–240)

Replace:
```scad
// Left product zone front: full height Z 50-542
translate([skin_t, -1, leg_h])
    cube([product_w-(skin_t*2), skin_t+2, tray_zone_top_z - leg_h]);
```
With:
```scad
// Left product zone front: local Z 0-492 (world Z 50-542)
translate([skin_t, -1, 0])
    cube([product_w-(skin_t*2), skin_t+2, tray_zone_top_z - leg_h]);
```

### Change 2 — Exit zone internal chute cutout (lines ~243–244)

Replace:
```scad
// Exit zone internal chute cutout (Z 50-300)
translate([(product_w - exit_door_w)/2, -1, leg_h])
    cube([exit_door_w, skin_t+2, exit_door_h]);
```
With:
```scad
// Exit zone internal chute cutout: local Z 0-250 (world Z 50-300)
translate([(product_w - exit_door_w)/2, -1, 0])
    cube([exit_door_w, skin_t+2, exit_door_h]);
```

### Change 3 — Upper front display cutout (lines ~247–248)

Replace:
```scad
// Upper front display cutout (Z 542-700)
translate([skin_t, -1, tray_zone_top_z])
    cube([product_w-(skin_t*2), skin_t+2, upper_display_h]);
```
With:
```scad
// Upper front display cutout: local Z 492-650 (world Z 542-700)
translate([skin_t, -1, tray_zone_top_z - leg_h])
    cube([product_w-(skin_t*2), skin_t+2, upper_display_h]);
```

### Change 4 — Right compartment front face opening (lines ~251–252)

Replace:
```scad
// Right compartment front face opening — dashboard visible
translate([product_w + divider_t, -1, leg_h])
    cube([system_w - divider_t - skin_t, skin_t+2, tray_zone_top_z - leg_h]);
```
With:
```scad
// Right compartment front face opening: local Z 0-492 (world Z 50-542)
translate([product_w + divider_t, -1, 0])
    cube([system_w - divider_t - skin_t, skin_t+2, tray_zone_top_z - leg_h]);
```

---

## 6. VERIFY — After applying all 4 changes

Check every translate Z inside `outer_shell()`:
- Hollow interior subtract: starts at `skin_t` ✓ (local, correct)
- All 4 front face cutouts: now start at `0` or `tray_zone_top_z - leg_h` ✓
- No `leg_h` value remains as a Z translate inside `outer_shell()` ← confirm this

---

## 7. UPDATE rules-codes.md — New lesson, mandatory

Append to the **Z-Stack and Positioning Rules** section of `rules-codes.md`:

```
**Rule: Local vs world Z — never mix inside one module.**
If a module is called with translate([0,0,offset]) in assembly, ALL geometry
inside that module must use local Z (Z=0 at module base). World Z values must
be converted: local_z = world_z - assembly_offset.
Example: outer_shell() is called with translate([0,0,leg_h]).
Inside outer_shell(), a cutout at world Z=300 must be written as Z=300-leg_h=250.
Never use world Z values directly inside an offset-assembled module.
```

Bump rules-codes.md to version 1.2, date 2026-06-28.

---

## 8. DO NOT TOUCH

- Any geometry outside `outer_shell()` module
- `rules-dimensions.md`
- The hollow interior subtract (lines ~235–236) — already correct
- `WORKFLOW_SKILL.md`, `chat_rules.md`
- Assembly line: `translate([0, 0, leg_h]) outer_shell();` — keep exactly as is

---

## 9. QA CHECKLIST — Before committing

- [ ] Version header: v18, date 2026-06-28
- [ ] All 4 cutout translates inside outer_shell() confirmed changed
- [ ] No `leg_h` remains as a Z start value inside outer_shell()
- [ ] Hollow subtract untouched: starts at skin_t, height total_h-(skin_t*2)
- [ ] Assembly line unchanged: `translate([0, 0, leg_h]) outer_shell();`
- [ ] rules-codes.md updated to v1.2 with new local/world Z rule
- [ ] knowledge.map: v17 → Superseded, v18 → ACTIVE
- [ ] cc_chat_log updated with results

---

## 10. MANDATORY CLOSING

1. Append `cc_chat_log.md` — newest at BOTTOM. Include:
   - Confirm all 4 cutout Z values corrected
   - State whether OpenSCAD --check passes clean (if available)
   - Flag for Claude Web: Janis must open v18 in OpenSCAD, F6, confirm 2-manifold warning GONE
   - Note: if warning persists, Claude Web needs v18.scad uploaded for further diagnosis
2. Archive this prompt → `prompts/archive/` stamped ✅ COMPLETE — 2026-06-28
3. Update `knowledge.map` — v17 → Superseded, v18 → ACTIVE
4. Bump version on all files changed
5. Commit all → merge to main

Confirm every file committed after merge.
