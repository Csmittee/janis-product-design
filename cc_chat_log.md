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

## Flags for Claude Web
- exit_door_w (shell cutout): currently 400mm. Janis may want to confirm this.
- Flap door dimensions (100mm tall x 250mm wide): confirm with Janis from front render.
- rules-materials.md: confirm it is in repo root (it is — .claude/ copy was deleted).
- PR-01 (pilates reformer): NOT STARTED.
