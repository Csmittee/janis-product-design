# cc Chat Log
# Claude Code reports back to Claude Web here after every session.
# Claude Web reads this at start of every planning session (via Janis paste or download).
# cc updates BOTTOM of log — newest entry last.
# Format: ### DATE | VERSION | STATUS

---

## How to use this file

**Claude Web:** Read this at session start to know what cc did last,
what the current state is, and what flags need decisions.

**cc:** Append a new entry after every commit session.
Never delete old entries — they are the project history.

---

## Session Log

### 2026-06-27 | Setup | COMMITTED
- Created: WORKFLOW_SKILL.md v2 (team structure, protocols)
- Created: chat_rules.md (Claude Web rules)
- Created: cc_rules.md (cc rules)
- Created: rules-dimensions.md (VM-01 dimensions)
- **Active SCAD:** VM-01-base-v3.scad (existed before this session)

### 2026-06-27 | VM-01-base-v4 | COMMITTED
- tray_h: 116 → 86mm (spring OD 66 + 20mm clearance)
- Spring tray front face: open
- Tray Z formula: leg_h + exit_door_h + (tray_num * tray_h)
- Acrylic panel: right compartment only

### 2026-06-27 | VM-01-base-v5 | COMMITTED
- Acrylic panel: rounded window (hull+cylinders r=10, t=3mm)
- Spring tray side walls: 3mm frame, open centre

### 2026-06-27 | VM-01-base-v6 | COMMITTED
- Major rebuild: tray_h=121, independent removable trays
- New: tray_rack (fixed rails + latch pins)
- New: front_door (single panel Z 50-542, left hinge)
- New: tray_zone_frame
- New: dashboard (ATM screen, QR, card slot, speaker)
- Acrylic: 3 faces of right compartment above 430mm

### 2026-06-27 | VM-01-base-v7 | COMMITTED
- total_h: 800 → 700mm
- Zone stack fixed: legs 0-50 | exit 50-300 | tray0 300-421 | tray1 421-542 | upper 542-700
- Acrylic: Z 542-698 (was 430-798)
- Screen center Z: 280mm
- Upper front door cutout added (Z 542-700)
- Deleted .claude/rules-dimensions.md (root is authoritative)

### 2026-06-27 | VM-01-base-v8 | COMMITTED
- Tray side windows: restored 3mm border frame (centre open)
- Screen Y: moved to skin_t (front face of right compartment)

### 2026-06-27 | VM-01-base-v9 | COMMITTED
- total_d: 550 → 600mm (motor needs 60mm depth)
- motor_d: 20 → 60mm (real motor size from spring thread)
- Spring direction FIXED: motor now at BACK of tray, spring front end
  at drop zone boundary (Y=0 tray-local). Products fall forward into exit zone.
- front_door: now covers EXIT ZONE ONLY (Z 50-300, 250mm).
  Spring display zone Z 300-542 is OPEN — customers see springs.
- Customer pickup flap: 100mm tall x 250mm wide (was full exit zone size)
- Sensor: replaced per-spring sensors with parallel strip pair on
  left/right walls at Z=280mm (just below tray 0 floor).
- Right compartment front: cutout added — screen/QR/card now visible.
- Governance: knowledge.map + cc_chat_log.md created.
- **Active SCAD:** vending-machine/VM-01-base/VM-01-base-v9.scad

### 2026-06-27 | VM-01-base-v10 | COMMITTED
- Spring zone acrylic panel: transparent customer selection window, Z 300-542, full product_w, #ADD8E6 opacity 0.15, left hinge, shown closed
- Screen Y: -30mm (protrudes 30mm forward of machine front face — visible from front view)
- **Active SCAD:** vending-machine/VM-01-base/VM-01-base-v10.scad

### 2026-06-27 | VM-01-base-v11 | COMMITTED
- Fix 1: spring_zone_panel() — explicit world coords: X=skin_t, Y=0, Z=leg_h+exit_door_h (300mm), width=product_w-(skin_t*2), height=tray_h*tray_count (242mm). Left product zone only.
- Fix 2: Roof restored — hollow interior height changed total_h → total_h-skin_t. Top skin now solid at Z=700+leg_h.
- Fix 3: screen_y = skin_t - screen_protrude (was 0 - screen_protrude). Screen protrudes 30mm forward from machine front face.
- **Active SCAD:** vending-machine/VM-01-base/VM-01-base-v11.scad

### 2026-06-27 | VM-01-base-v12 + Governance | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v12.scad
- WORKFLOW_SKILL.md
- cc_chat_log.md

Changes:
- VM-01-base-v12: outer_shell opacity 0.75 → 0.15 (semi-transparent QA shell)
- VM-01-base-v12: new left_front_acrylic() module — #ADD8E6 opacity 0.15, X=skin_t, Y=0, Z=leg_h(50mm), W=product_w-(skin_t*2)=412mm, H=total_h-leg_h=650mm, T=3mm. Customer sees full left zone.
- WORKFLOW_SKILL.md FIX A: Section 6 (Current Project Status) removed — cc_chat_log.md is the only living status file
- WORKFLOW_SKILL.md FIX B: All cc references removed (flow, file table, section headers). WORKFLOW_SKILL.md now governs Claude Web only.
- WORKFLOW_SKILL.md FIX C: New load order rule added at top of Handover Protocol (Section 3). Sections renumbered.
- cc_rules.md: No WORKFLOW_SKILL.md references were present — no changes needed.
- **Active SCAD:** vending-machine/VM-01-base/VM-01-base-v12.scad

### 2026-06-27 | VM-01-base-v13 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v13.scad

Changes:
- Fix 1: outer_shell opacity restored to 0.75 (solid shell). left_front_acrylic() opacity updated 0.15 → 0.25. Shell is solid; only the left front face panel is transparent.
- Fix 2: exit_door_h = 250 moved BEFORE tray zone calculations. Declaration order: exit_door_h → exit_door_w → tray_zone_h → tray_0_z → tray_zone_top_z. Resolves all 'undefined variable' warnings from OpenSCAD.
- **Active SCAD:** vending-machine/VM-01-base/VM-01-base-v13.scad

### 2026-06-27 | Satu vending 01.scad — Manual fix | CONFIRMED

- exit_door_h = 250 inserted immediately before tray_0_z by Janis manually (Option A)
- File is a local working copy, not in repo — all 28 warnings resolved
- Render confirmed clean: solid shell, springs visible through left front acrylic, dashboard visible right compartment
### 2026-06-28 | VM-01-base-v13 Export Prep | COMMITTED

Files committed:
- exports/for-supplier/.gitkeep (folder created)
- exports/for-supplier/README-export-instructions.md
- renders/.gitkeep (folder created)
- prompts/archive/VM-01-base-v13-export ✅ COMPLETE — 2026-06-28.md
- cc_chat_log.md

Changes:
- Created exports/for-supplier/ folder with .gitkeep
- Created renders/ folder with .gitkeep
- Written README-export-instructions.md with full OpenSCAD export steps for Janis (STL + 4x PNG renders, correct file paths)
- Prompt archived to prompts/archive/ stamped COMPLETE
- QA: all 3 checklist items confirmed ✅

### 2026-06-28 | VM-01-base-v14 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v14.scad
- knowledge.map (v14 added to version index)
- prompts/archive/VM-01-base-v14-fix-manifold ✅ COMPLETE — 2026-06-28.md
- cc_chat_log.md

Changes:
- Fix 1: outer_shell() hollow subtract changed total_h-skin_t → total_h-(skin_t*2). Bottom face now closed — shell is a fully closed solid. Fixes 2-manifold warning.
- Fix 2: outer_shell opacity 0.15 → 0.75 (solid shell, correct value)
- Fix 3: Duplicate exit_door_h declaration removed (was at line 52 AND line 62 — kept line 52 only, before tray_0_z)
- Version header corrected: v12 → v14, date 2026-06-27 → 2026-06-28
- **Active SCAD:** vending-machine/VM-01-base/VM-01-base-v14.scad

⚑ FLAG FOR JANIS: Open VM-01-base-v14.scad in OpenSCAD, press F6. Confirm the 2-manifold warning is gone before proceeding with STL export.

### 2026-06-28 | VM-01-base-v15 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v15.scad
- cc_chat_log.md

Changes:
- Added e = 0.01 to parameters section (epsilon — prevents z-fighting on coincident front faces)
- front_door(): Y 0 → e
- spring_zone_panel(): panel cube Y 0 → e
- left_front_acrylic(): panel cube Y 0 → e
- tray_zone_frame(): all 4 translates Y 0 → e
- **Active SCAD:** vending-machine/VM-01-base/VM-01-base-v15.scad

### 2026-06-28 | VM-01-base-v16 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v16.scad
- cc_chat_log.md

Changes:
- Fix 1: acrylic_display() — hull() front panel replaced with flat cube: translate([acrylic_front_x, e, acrylic_bot_z]) cube([acrylic_front_w, door_t, acrylic_zone_h]). Simpler geometry, no z-fighting.
- Fix 2: outer_shell() hollow subtract Z changed from skin_t → leg_h+skin_t. Assembly translate([0,0,leg_h]) removed — outer_shell() now called directly as outer_shell().
- Fix 3: Version header v15 → v16, date 2026-06-28.
- **Active SCAD:** vending-machine/VM-01-base/VM-01-base-v16.scad

### 2026-06-28 | rules-codes.md v1.0 | COMMITTED

Files committed:
- rules-codes.md (new file)
- knowledge.map (v15, v16 added to version index)
- cc_chat_log.md

Changes:
- Created rules-codes.md Version 1.0 — full OpenSCAD coding rule set extracted from VM-01-base v3–v16 build history
- 7 sections: 2-Manifold Rules, Variable Declaration Rules, Module Structure Rules, File and Version Rules, Z-Stack and Positioning Rules, Color and Opacity Rules, QA Checklist
- knowledge.map: v14 status → Superseded; v15 and v16 added; v16 marked ACTIVE

## Flags for Claude Web
- exit_door_w (shell cutout): currently 400mm. Janis may want to confirm this.
- Flap door dimensions (100mm tall x 250mm wide): confirm with Janis from front render.
- rules-materials.md: confirm it is in repo root (it is — .claude/ copy was deleted).
- PR-01 (pilates reformer): NOT STARTED.

---

### 2026-06-28 | VM-01-base-v17 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v17.scad (new)
- rules-codes.md (v1.1)
- knowledge.map (v16 → Superseded, v17 → ACTIVE)
- cc_chat_log.md
- prompts/archive/VM-01-base-v17-fix-manifold ✅ COMPLETE — 2026-06-28.md

**Task 1 — Shell assembly revert: APPLIED**
- Assembly line restored to: `translate([0, 0, leg_h]) outer_shell();`
- Inside outer_shell(): hollow subtract Z restored to `skin_t` (local origin)
- Height `total_h-(skin_t*2)` kept — v14 bottom-skin fix preserved
- Source file v16 was fully read before any edit was made (new rule compliance)

**Task 2 — 2-manifold source diagnosis:**
openscad binary not available in remote cc environment. Diagnosis performed via code analysis against rules-codes.md patterns.

Most likely culprit: **dashboard()** — specifically the curved support bracket at lines 389–394 of v16:
```scad
hull() {
    translate([-screen_w/2, 0, 0])
        rotate([-90, 0, 0]) cylinder(r=bracket_r, h=30);
    translate([screen_w/2, 0, 0])
        rotate([-90, 0, 0]) cylinder(r=bracket_r, h=30);
}
```
This is `hull()` over two rotated cylinders — complex geometry. Rules-codes.md "No hull() for flat panels" was the original warning; this bracket is not a flat panel but curved hull geometry in a tight space, a known 2-manifold risk.

Secondary suspect: **sensor_strip()** — the "laser beam" cube at `cube([..., 1, 1])` is degenerate (1mm in two axes). Near-zero geometry can cause non-manifold edges.

Third candidate: **tray_zone_frame()** — four cubes in a union() that share edges at corners. Shared edges without epsilon offset can produce degenerate topology.

v17 is delivered with ALL modules uncommented (full assembly restored). Claude Web must perform surgical fix in v18 starting with dashboard() bracket geometry.

**Task 3 — rules-codes.md updated to v1.1: CONFIRMED**
- New rule added to 2-Manifold section: "Read the live .scad file before writing any fix"

**Flag for Claude Web — v18 planning:**
- Primary fix target: dashboard() support bracket — replace hull()+rotated cylinders with simpler geometry (two flat cubes or a single extruded profile)
- Secondary: sensor_strip() 1x1mm cube — add minimum 2mm on each axis
- Confirm with Janis whether openscad binary can be installed in cc environment for future manifold testing
- Active SCAD: vending-machine/VM-01-base/VM-01-base-v17.scad

---

### 2026-06-28 | VM-01-base-v18 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v18.scad (new)
- rules-codes.md (v1.2)
- knowledge.map (v17 → Superseded, v18 → ACTIVE)
- cc_chat_log.md
- prompts/archive/VM-01-base-v18-fix-manifold ✅ COMPLETE — 2026-06-28.md

**Root cause (confirmed by Claude Web):**
outer_shell() called with `translate([0,0,leg_h])` in assembly, but all 4 front
face cutouts inside the module used world Z values (leg_h, tray_zone_top_z).
With the assembly translate applied, those cutouts were shifted 50mm too high —
cutting outside the shell boundary = non-manifold geometry.

**All 4 cutout Z values corrected to local coordinates:**
- Left product zone front: `leg_h` → `0` (local Z 0-492, world Z 50-542)
- Exit zone chute: `leg_h` → `0` (local Z 0-250, world Z 50-300)
- Upper display: `tray_zone_top_z` → `tray_zone_top_z - leg_h` (local Z 492, world Z 542)
- Right compartment front: `leg_h` → `0` (local Z 0-492, world Z 50-542)
- Hollow interior subtract: untouched — was already correct at skin_t
- Assembly line: unchanged — `translate([0, 0, leg_h]) outer_shell();`

**OpenSCAD --check:** binary not available in cc environment.

**rules-codes.md updated to v1.2: CONFIRMED**
- New rule added to Z-Stack section: "Local vs world Z — never mix inside one module"

**Flag for Claude Web — ACTION REQUIRED:**
Janis must open VM-01-base-v18.scad in OpenSCAD and press F6 (full render).
Confirm the 2-manifold warning is GONE from the console output.
If warning persists after v18, upload v18.scad to Claude Web for further diagnosis.
The fix targets the confirmed root cause — if another module is also non-manifold,
it will still show after this fix and require a separate v19 pass.

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v18.scad
