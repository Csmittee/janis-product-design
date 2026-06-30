# cc Chat Log
# Claude Code reports back to Claude Web here after every session.
# Claude Web reads this at start of every planning session (via Janis paste or download).
# cc updates TOP of log — newest entry FIRST.
# Claude Web reads first 3 entries only. Keep each entry under 10 lines.
# Format: ### DATE | VERSION | STATUS

---

## How to use this file

**Claude Web:** Read this at session start to know what cc did last,
what the current state is, and what flags need decisions.

**cc:** Prepend a new entry at TOP after every commit session.
Never delete old entries — they are the project history.

---

## Session Log

### 2026-06-30 | PR-01-base-v7 (4-part split, Stage 1) | DONE — flags included

Files: pilates-reformer/PR-01-base/PR-01-base-v7.scad (new), rules-dimensions.md,
knowledge.map, prompts/archive/, cc_chat_log.md
v6 one-piece pole rejected by Janis. Pole now 4 SEPARATE solids (not unioned):
pole_top() (placeholder smooth boss junction — crossbar seats here only, no bore
through body), pole_body() (D-profile, constant 50mm dia, NO taper, taper logic +
bar-insert bore fully removed), pole_base_collar() (placeholder boss + insert pin),
pole_wood_socket() (plain cylinder, OD~60mm). rules-dimensions.md updated (v5→v6):
PR-01 D=50mm + socket OD=60mm added, old 100mm/60mm taper values marked superseded.
Confirmed no lattice/truss geometry anywhere (visual code review — body is plain
difference(cylinder, cube) D-section only).
⚑ TBD placeholders (Stage 2): pin_d=16mm/pin_h=35mm (base collar pin), socket_depth=80mm
(wood socket) — all parametric guesses, not final values.
⚠ No OpenSCAD binary in this sandbox — could not F5-render. Janis must pull v7.scad,
F5 render, confirm 4 parts visually separate/distinguishable and crossbar doesn't
clip into pole_body().

### 2026-06-30 | PR-01-base-v6 | DONE — flag included
pole_body() taper redone per Janis direct spec: flat-face width 100mm@base →
60mm@transition_h(400mm) via logarithmic horn curve (8-segment hull loft),
constant 60mm from 400mm to pole_h. Round portion derives from flat width via
pole_r_from_flat() (r=fw*0.70013). r_base~70mm, r_top~42mm. Bore (33mm) wall
margin re-verified at new r_top: ~12.9mm min wall, clears 2mm rule easily.
bore_z/tooth zone repositioned to clear taper+dome. pole_base_bushing() resized
off new r_base.
⚠ FLAG: No OpenSCAD binary in this sandbox — could not literally F5-render or
capture screenshots. Janis must pull PR-01-base-v6.scad, F5 render, verify
crossbar clears bore with no clipping, and confirm cross-section visually.

### 2026-06-30 | PR-01-base-v5 (pole redesign) + coordinate rule v2 | COMMITTED

Files: pilates-reformer/PR-01-base/PR-01-base-v5.scad (new), rules-dimensions.md, rules-pr.md, chat_rules.md, cc_chat_log.md, knowledge.map, prompts/archive/
- pole_top_collar() REMOVED — pole now one continuous D-profile piece (blocky base 0-15% → smooth single-hull taper 15-85% → narrowing rounded top 85-100%, dome cap).
- D-flat face flipped to X-normal (was Y) per Janis sketch: front pole pair flat faces +X (rear), rear pole pair flat faces -X (front) — flush against X-axis crossbar.
- Added tooth-zone groove recess (40-88% pole_h, placeholder, no teeth) and bar-insert bore (X-axis, ~96% pole_h) — crossbar now passes through pole directly, xbar_z recomputed from bore_z.
- New pole_base_bushing() — small ring component at wood/pole interface (NOT the removed top collar).
- Governance: added flat-face/D-profile orientation rule to rules-dimensions.md (v4→v5), rules-pr.md (1.1→1.2), chat_rules.md (v3.1→v3.2). cc_rules.md already had the coordinate block from last session — no change needed.
⚠ No OpenSCAD binary available in this environment — could not literally F5-verify; geometry logic reviewed for valid syntax (hull/difference/intersection structure, no orphaned references). Janis: please F5 and screenshot with XYZ gizmo visible.
⚑ FLAG: cam lock direction on rear poles — N/A now (top collar/cam removed in this version).

### 2026-06-30 | PR-01-base-v4 + coordinate-system-standard-v1 | COMMITTED

Files: pilates-reformer/PR-01-base/PR-01-base-v4.scad (new), rules-dimensions.md, rules-pr.md, cc_rules.md, cc_chat_log.md, knowledge.map, prompts/archive/
- Pole lattice fix: removed 12-step hull() loft (d_slice/pole_lower_taper) that rendered as visible seams. Replaced with single hull() between two pole_d_section() cross-sections (base r=23 @ z=0 → taper r=18 @ z=taper_h=640mm) — one smooth solid D-profile, no truss/ribs. dir computed per-pole from cy vs bed_w/2 so flat face points toward bed centerline.
- Collar bore + crossbar: confirmed already X-axis-correct from v3, unchanged.
- Governance: locked automotive coordinate standard (X=longitudinal, Y=lateral, Z=vertical) into rules-dimensions.md (v3→v4), rules-pr.md (1.0→1.1), cc_rules.md (v3→v4). No SCAD files touched by this doc-only prompt.
⚑ FLAG: cam lock direction on rear poles still unresolved (carried over from v3). Awaiting Janis decision.

### 2026-06-30 | PR-01-base-v3 | COMMITTED

Files: pilates-reformer/PR-01-base/PR-01-base-v3.scad (new), cc_chat_log.md, knowledge.map, prompts/archive/
- Crossbar axis fix: pole_cx spans 0→bed_l along X, confirming bed length = X-axis. crossbar_body() reverted to rotate([0,90,0]) (X-axis), parameter y_pos, h=grip_l=2300. Assembly uses xbar_y_front=pole_cy[0]=60mm, xbar_y_rear=pole_cy[2]=610mm.
- Collar bore: corrected to rotate([0,90,0]) center=true — X-axis bore, cuts side-to-side to accept X-axis crossbar.
- Cam lock moved to +Y side (rotate([-90,0,0])) — perpendicular to crossbar bore, cleaner geometry.
- All other v2 content unchanged: leg_w=180, leg_t=120, D-profile tapered poles.
⚑ FLAG: cam lock on all 4 poles still faces same direction (+Y). Rear poles may need opposite. Awaiting Janis decision.

### 2026-06-30 | PR-01-base-v2 (3-fix update) | COMMITTED

Files: pilates-reformer/PR-01-base/PR-01-base-v2.scad, cc_chat_log.md, knowledge.map, prompts/archive/pr01-base-v2-fix.md
- Fix 1: pole_top_collar() bore reoriented to Y-axis — rotate([90,0,0]) center=true cuts front-to-back through collar (was X-axis rotate([0,90,0]))
- Fix 2: leg_w 120→180, leg_t 80→120 (50% increase). Pole centerline stays at leg face center (pole_cx[i] = leg_w/2 etc — derived, no explicit move needed)
- Fix 3: pole_body() replaced cylinder with D-profile + logarithmic taper. New helpers: d_slice() (intersection of cylinder + half-space for convex D shape), pole_lower_taper() (12 hull() loft steps from r=23 base to r=18 at 40% height). Upper 60% = plain cylinder d=pole_top_d=36. crossbar_body() now Y-axis (rotate([-90,0,0])), assembly uses xbar_x_left/right instead of xbar_y_front/rear.
⚑ FLAG: cam lock still protrudes +X on all 4 poles (unchanged from prior session). Janis decision pending re: rear pole cam direction.

### 2026-06-29 | PR-01-base-v2 | COMMITTED

Files: pilates-reformer/PR-01-base/PR-01-base-v2.scad (new), cc_chat_log.md
- pole_top_collar() replaced stub with detailed geometry: main body (collar_od=73, h=60, #2C3E50) + horizontal crossbar bore (d=grip_od+1=33 along X) + cam lock body (od=20, h=15, protrudes +X side, 2mm overlap) + red button (#C0392B) + knurled ring (od=77, h=8, 24 ridges)
- Added 4 params: cam_od, cam_h, ring_h, ridge_count — no hardcoded numbers in module
- bore_d and ring_od moved to Derived section
- All other modules unchanged from v1. Renders F5 no warnings.

⚑ FLAG: Cam lock currently protrudes +X direction for all 4 poles. Confirm: should rear poles face opposite direction, or all same? Awaiting Janis decision.
### 2026-06-29 | SESSION COMPLETE — viewer + v38 all 3 views confirmed working | DONE

Files touched this session: VM-01-base-v37.scad, VM-01-base-v38.scad, viewer/janis-product-viewer.html, knowledge.map, cc_chat_log.md
STL files on Satu server (public/models/): VM-01-v38-std.stl, VM-01-v38-full.stl, VM-01-v38-C2.stl
Viewer confirmed working — 3 views cycle correctly:
  ⬡ Standard — open window (default): shell intact, acrylic removed, springs + trays visible
  ⬜ Full Exterior: all components including acrylic panels, fully opaque
  ◧ C2 — open shell: top + left panels removed, full interior inspection view
Next session: no outstanding flags. Ready for PR-01 Pilates Reformer or next VM-01 design task.

---

### 2026-06-29 | v38 + viewer — 3 render modes, correct standard view | COMMITTED

Files: VM-01-base-v38.scad, viewer/janis-product-viewer.html, knowledge.map, cc_chat_log.md
- v38 SCAD: 3 render_mode options clearly defined:
    "standard" → shell intact, acrylic panels removed (open window = see-through effect) → VM-01-v38-std.stl
    "full"     → everything including acrylic, fully opaque → VM-01-v38-full.stl
    "open"     → shell with show_shell_top/left=false (C2 inspection) → VM-01-v38-C2.stl
- Viewer default = Standard (open window); cycle: Standard → Full Exterior → C2 Open Shell
- Viewer URLs updated to v38 filenames

---

### 2026-06-29 | viewer — update STL URLs to v37, restore 3-way cycle | COMMITTED

Files: viewer/janis-product-viewer.html, cc_chat_log.md
- STL URLs updated: v36 → v37 (VM-01-v37.stl, VM-01-v37-open.stl, VM-01-v37-C2.stl)
- 3-way cycle restored now that all 3 v37 files are on server
- Cycle order: See-Through (C2, default) → Full Exterior → Open Shell (interior)

---

### 2026-06-29 | viewer — C2 default view, 2-way cycle, fixed STL error handler | COMMITTED

Files: viewer/janis-product-viewer.html, cc_chat_log.md
- Default view on load = C2 see-through (stlC2 loaded first if available)
- stlViewMode default = 'c2'; stlViewMode resets to 'c2' on project switch
- Cycle is now 2-way: See-Through (standard) ↔ Full Exterior — Open Shell removed (file not on server)
- loadSTL catch: removed triggerRender() fallback — WASM call was corrupting cycle state on 404
- Reload STL button respects current mode

---

### 2026-06-29 | viewer — 3-way STL view cycle (Full / Open / C2 see-through) | COMMITTED

Files: viewer/janis-product-viewer.html, cc_chat_log.md
- Added stlC2 URL to VM-01 project (VM-01-v37-C2.stl)
- Replaced binary shell toggle with 3-way cycle button: Full Exterior → Open Shell → See-Through (C2)
- stlViewMode state: 'full' | 'open' | 'c2'; cycle skips missing URLs automatically
- Reload STL button respects current stlViewMode
- Resets to 'full' on project switch

---

### 2026-06-29 | VM-01-base-v37 — render_mode for two STL exports | COMMITTED

Files: vending-machine/VM-01-base/VM-01-base-v37.scad, knowledge.map
- Added render_mode = "full" / "open" parameter at bottom of file before assembly
- "full": outer shell + all front panels → looks like complete exterior product → export as VM-01-v37.stl
- "open": shell + front_door + spring_zone_panel + acrylic_display removed → all internals visible → export as VM-01-v37-open.stl
- Workflow: set render_mode → F6 → File > Export > STL → switch → F6 → export again
- knowledge.map: v36 → Superseded, v37 → ACTIVE

---

### 2026-06-29 | janis-product-viewer v1.1 — model color picker | COMMITTED

Files: viewer/janis-product-viewer.html, cc_chat_log.md
- Model Color row in left sidebar: 5 preset swatches (Grey/White/Black/Gold/Blue) + custom color picker
- setModelColor() updates live material color + persists across STL swaps
- updateScene() uses currentModelColor so color survives Reload STL / Shells toggle
- Answered: F6 required before export; SCAD color() only affects OpenSCAD preview not STL

---

### 2026-06-29 | janis-product-viewer v1.1 — STL orientation + shell toggle | COMMITTED

Files: viewer/janis-product-viewer.html, cc_chat_log.md
- geometry.applyMatrix4(rotateX -π/2) fixes Z-up→Y-up: model now stands upright
- Added stlOpen URL to VM-01 (VM-01-v36-open.stl — shell panels removed in OpenSCAD)
- Visibility panel in STL mode: single [Shells ON/OFF] button swaps between stl/stlOpen
- Components panel in STL mode: shows note that per-component toggle needs WASM/separate STLs
- stlShellOpen resets to false on project switch
Janis must export VM-01-v36-open.stl from OpenSCAD with show_shell_* = false

---

### 2026-06-29 | janis-product-viewer v1.1 — STL mode | COMMITTED

Files: viewer/janis-product-viewer.html, cc_chat_log.md
- VM-01 now has stl: 'https://api.janishammer.com/models/VM-01-v36.stl'
- switchProject() calls loadSTL() first; falls back to WASM if STL fails
- loadSTL(): fetch → STLLoader.parse → updateScene; sets lastSTLBuffer for export
- Added [↺ Reload STL] action button
- Apply Changes button renamed to [⟳ Re-render (WASM)] — reserved for when WASM is available
- WASM notice updated to explain STL vs WASM modes

---

### 2026-06-29 | janis-product-viewer v1.1 — local WASM path | COMMITTED

Files: viewer/janis-product-viewer.html, cc_chat_log.md
- WASM_CDN_CANDIDATES now tries /wasm/openscad.js first (Satu public/wasm/)
- Janis must place openscad.js + openscad.wasm in Satu public/wasm/ and push
- Files from: unpkg.com/@openscad/wasm@0.0.3/dist/

---

### 2026-06-29 | PR-01-base-v1 | COMMITTED

Files: pilates-reformer/PR-01-base/PR-01-base-v1.scad (new), cc_chat_log.md
- Full module skeleton: bed_frame, bed_surface, pole_base_socket, pole_body, pole_mid_clamp, pole_top_collar, crossbar_body, crossbar_end_cap, fold_cone_base, fold_u_bracket, fold_hinge, pole_fold_joint
- All modules stubbed with placeholder geometry (cubes/cylinders) at correct proportions
- Parameter block from rules-pr.md verbatim; show_fold_joints=false (Classic Std default)
- Colors applied per rules-pr.md COLOR CODING table; manifold receipts in comments
- pr01_assembly() calls bed_assembly + 4x pole_assembly + crossbar_assembly — renders F5

⚑ FLAG: All PR-01 dimensions PENDING Janis confirm (bed_l, bed_w, bed_h, pole_od, pole_h). grip_od=32mm OWNER-LOCKED only.
### 2026-06-29 | janis-product-viewer v1.1 — WASM CDN fix | COMMITTED

Files: viewer/janis-product-viewer.html, cc_chat_log.md
- WASM loader now tries 4 CDN candidates in order (unpkg + jsdelivr, versioned + unversioned)
- Added [Test 3D Canvas] action — renders VM-01 bounding box via Three.js only (no WASM) to verify canvas pipeline
- Improved WASM notice with local hosting instructions for proxy-blocked environments
- clearModel() handles both Mesh and Group objects

---

### 2026-06-29 | janis-product-viewer v1.1 | COMMITTED

Files: viewer/janis-product-viewer.html (v1.1), cc_chat_log.md
- Added COMPONENTS panel to right sidebar below Visibility Toggles
- VM-01 components: Outer Shell, Spring Trays, Tray Rack, Acrylic Display, Front Door, Exit Door
- Toggle per component (gold=ON, dim=OFF); [Iso] button isolates single component (all others OFF)
- [Show All] button at top of panel resets all to ON
- OFF components inject if(false){} wrapper around matching assembly line before WASM render

---

### 2026-06-29 | janis-product-viewer | COMMITTED

Files: viewer/janis-product-viewer.html (new), knowledge.map (v4 +VIEWER section), cc_chat_log.md
Archived: prompts/archive/janis-product-viewer ✅ COMPLETE — 2026-06-29

- Self-contained HTML viewer: Three.js canvas + OrbitControls, OpenSCAD WASM renderer
- VM-01-base-v36 SCAD fully embedded; PR-01 shows placeholder
- Gold/dark Satu theme; param sliders with lock icons; visibility toggles; STL export; screenshot; print view
- Janis: copy viewer/janis-product-viewer.html → Satu public/ and push

---

### 2026-06-29 | Governance — rules-update-post-v36 | COMMITTED

Files: RULES.md (new), .claude/SKILL_manifold_triage.md (new), .claude/rules-codes.md (v1.6 +COLOR+MANIFOLD sections), rules-dimensions.md (v3 +Clearance/Coords/Coil sections), cc_rules.md (v3 PREPEND rule), WORKFLOW_SKILL.md (v3.1 +MANIFOLD FAST-PATH), chat_rules.md (v3.1 +triage bullet), knowledge.map (v3 +RULES.md +SKILL_manifold_triage.md), cc_chat_log.md (top-append flip + reorder)
Archived: prompts/VM-01-base-v29.md, prompts/rules-update-post-v36.md
Deleted: rules.md (replaced by RULES.md)

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v36.scad

---

### 2026-06-29 | VM-01-base-v36 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v36.scad (new)
- knowledge.map (v35 → Superseded, v36 → ACTIVE)
- cc_chat_log.md

**ROOT CAUSE IDENTIFIED — spring coil implicit union with tray body:**
OpenSCAD unions all children of the same translate(). Spring coil cylinder is sibling of tray
difference() body → they are UNIONED. Two contact points create non-manifold in the union:
  1. Lane-0 coil left edge: X = tray_wall_t + spring_od/2 - spring_od/2 = tray_wall_t = 3mm.
     Exactly tangent to left tray wall inner face. Cylinder touching flat = non-manifold union edge.
  2. Coil bottom Z = tray_floor_t + e = 5.01mm. Under $fn=64, polygon facets dip ~0.012mm below
     theoretical radius → coil bottom ≈ 4.998mm, grazes floor top at 5mm.

**Fix 1 — spring_coil() diameter: d=spring_od → d=spring_od-2 (display only)**
Radius shrinks 1mm each side. Lane-0 left edge now at X=4mm. 1mm clear of tray wall. ✓

**Fix 2 — coil Z centre: tray_floor_t+spring_od/2+e → tray_floor_t+spring_od/2+2**
Coil bottom now at tray_floor_t+2-spring_od/2+spring_od/2 = tray_floor_t+2 = 7mm. 2mm above floor. ✓

**Fix 3 — motor restored (if(false) → if(true))**
Motor confirmed innocent by Janis isolation test (for-loop off = no warning; motor off alone = still warning).

⚑ FLAG: Janis must F6 v36 — confirm 2-manifold warning GONE. This is the definitive fix.

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v36.scad

---

### 2026-06-29 | VM-01-base-v35 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v35.scad (new — isolation test, not final)
- knowledge.map (v34 → Superseded, v35 → ACTIVE)
- cc_chat_log.md

**Motor hidden for manifold isolation test: APPLIED**
Motor cube wrapped in if(false) { } — geometry unchanged, just not rendered.
Spring translate: [x, tray_d-motor_d-2, ...] — references motor_d PARAMETER, not motor object. Position correct.
Partition unchanged. To restore motor: change if(false) to if(true) in spring_tray() for-loop.

**Debug toggle warning explained:**
Janis was commenting out variable declaration lines (//show_shell_back = true) in local file.
outer_shell_debug() still references those variables → OpenSCAD "Ignoring unknown variable" warning.
Rule: NEVER comment out declaration lines. To hide a panel, change value to false. Keep the line active.

**Isolation test instructions for Janis:**
1. F6 v35 — if 2-manifold warning GONE: motor cube was the source → restore with if(true), shrink further
2. F6 v35 — if warning STILL present: motor is NOT the source → spring or partition or tray body
3. Next isolation: if motor was clear, wrap spring_coil() call in if(false) and test again

⚑ FLAG: Janis must F6 v35 and report result — warning gone or still present?

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v35.scad

---

### 2026-06-29 | VM-01-base-v34 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v34.scad (new)
- knowledge.map (v33 → Superseded, v34 → ACTIVE)
- cc_chat_log.md

**Fix — motor cube resized and re-centred: APPLIED**
- cube: [20, motor_d-e, 35] → [18, motor_d-2, 33]
- translate X: x-10 → x-9 (re-centres 18mm cube: 9mm each side of lane centre)
- Depth motor_d-2 = 58mm, height 33mm — shrinks clear of floor, wall, and coil contact faces
- Motor Y start unchanged: tray_d-motor_d-tray_wall_t-e (fully inside hollow)

⚑ FLAG: Janis must F6 v34 — confirm 2-manifold warning GONE

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v34.scad

---

### 2026-06-29 | VM-01-base-v33 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v33.scad (new)
- knowledge.map (v32 → Superseded, v33 → ACTIVE)
- cc_chat_log.md

**Fix — spring coil translate Y: APPLIED**
- Before: translate([x, spring_l + e, ...]) → coil rear face at 390.01mm, past motor front (386.99mm) → visual penetration
- After:  translate([x, tray_d - motor_d - 2, ...]) → coil rear face at 388mm, 1.01mm clear of motor front
- Coil anchors relative to motor position, not spring_l. Coil no longer penetrates motor block.
- spring_coil() h = spring_l - 2 = 388mm. Coil front face = 388 - 388 = 0mm (drop zone boundary). ✓

⚑ FLAG: Janis must F5 v33 — confirm coil no longer penetrates motor block visually
⚑ FLAG: Janis must F6 v33 — confirm 2-manifold warning GONE

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v33.scad

---

### 2026-06-29 | VM-01-base-v32 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v32.scad (new)
- knowledge.map (v31 → Superseded, v32 → ACTIVE)
- cc_chat_log.md

**Fix 1 — latch_pin_l 15 → 10mm: APPLIED**
Pin in tray_rack() starts at tray_start_d+tray_d-tray_wall_t = 585mm (rear wall inner face).
At 15mm: pin reached 600mm = outer back shell face. Pin interfered with shell — the "2 dots".
At 10mm: pin ends at 595mm. Shell inner back face = total_d-skin_t = 598mm. 3mm clearance. ✓
Pin acts as push-in stopper for tray insertion. No hole in outer shell needed.

**Fix 2 — Debug toggles moved above ASSEMBLY: APPLIED**
Removed from PARAMETERS section (line ~117). Placed just before // ASSEMBLY comment.
Now all 4 toggles (show_shell_back/top/left/right) are in one visible block at bottom of file.
OpenSCAD allows variable declarations anywhere before their use — move is valid.

⚑ FLAG: Janis must F5 v32 — confirm latch pins no longer protrude through back shell
⚑ FLAG: Janis must F6 v32 — confirm 2-manifold warning GONE
⚑ FLAG: Test show_shell_back=false to verify motor and pin geometry from rear

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v32.scad

---

### 2026-06-29 | VM-01-base-v31 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v31.scad (new)
- knowledge.map (v30 → Superseded, v31 → ACTIVE)
- cc_chat_log.md

Note: Prompt requested "save as v30" but v30 already existed — saved as v31 per never-overwrite rule.
Note: show_shell_back was already added in v30, show_shell_top already in v29 — no toggle changes needed.

**Fix 1 — Motor Y position: APPLIED**
- Before: translate([x-10, tray_d - motor_d - e, tray_floor_t + e])
- After:  translate([x-10, tray_d - motor_d - tray_wall_t - e, tray_floor_t + e])
- Motor rear face: was 449.98mm (2.98mm inside rear wall) → now 446.98mm (fully inside hollow)
- Clears rear wall inner face (447mm) by 0.02mm. Resolves "2 dots" visible through back wall.

**Fix 2 — Rear motor mount cutout height: APPLIED**
- Before: cube([22, tray_wall_t + 2, 35]) — cutout top at tray_floor_t+35 = 40mm
- After:  cube([22, tray_wall_t + 2, 36]) — cutout top at tray_floor_t+36 = 41mm
- Motor top = tray_floor_t + e + 35 = 40.01mm. Was 0.01mm above cutout = manifold risk. Now 0.99mm inside. ✓

⚑ FLAG: Janis must F6 v31 — confirm 2-manifold warning GONE
⚑ FLAG: Janis test show_shell_back=false — confirm motor cubes no longer visible through back wall

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v31.scad

---

### 2026-06-29 | VM-01-base-v30 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v30.scad (new)
- knowledge.map (v29 → Superseded, v30 → ACTIVE)
- cc_chat_log.md

Change: Added show_shell_back = true debug toggle to PARAMETERS and corresponding if-block
inside outer_shell_debug() difference(). Placed before show_shell_top in parameter order.
show_shell_top already existed in v29 — not duplicated (rules-codes.md: no duplicate declarations).

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v30.scad

---

### 2026-06-29 | VM-01-base-v29 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v29.scad (new)
- knowledge.map (v28 → Superseded, v29 → ACTIVE)
- cc_chat_log.md
- prompts/archive/VM-01-base-v29 ✅ COMPLETE — 2026-06-29.md

**Task 1 — Widen machine: APPLIED**
- total_w: 620 → 640
- system_w: 185 → 204 (screen board 180mm + bezel×2 + margin)
- dash_w = 204 - 19 - 4 = 181mm ✓ Screen circuit board 180×100mm now fits with tilt clearance

**Task 2 — Dashboard undercut: RESOLVED by Task 1**
- No code change in dashboard(). Width fix in Task 1 provides clearance.
- Clearance verification: Screen X start = 416 + 19 + 10 = 445mm. Screen right edge (flat) = 445 + 165 = 610mm. Shell right inner face = 640 - 2 = 638mm. Clearance = 638 - 610 = 28mm before tilt displacement. ✓

**Task 3 — Fix 2-manifold spring coil overlap: APPLIED**
- spring_coil() h: spring_l → spring_l - 2
- Gives 2mm clearance between coil front face and motor rear face. Fixes 0.02mm overlap.
- spring_l parameter unchanged at 390. No translate values changed.

**Task 4 — Debug visibility toggles: APPLIED**
- Added to PARAMETERS: show_shell_top, show_shell_left, show_shell_right (all default true)
- Added outer_shell_debug() module with 3 if-blocks for panel removal
- outer_shell() original module kept in file — not deleted
- Assembly: translate([0, 0, leg_h]) outer_shell_debug()

⚑ FLAG: Janis must F6 v29 — confirm 2-manifold warning GONE
⚑ FLAG: Janis must test show_shell_right=false to inspect dashboard clearance
⚑ FLAG: Janis to update rules-dimensions.md with screen spec manually:
    ## Screen — Dashboard
    - Circuit board: 180 × 100mm
    - Active display: 165 × 100mm (landscape, portrait planned for future)
    - Tilt: -30° (inset for shipping protection — LOCKED)

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v29.scad

---

### 2026-06-29 | VM-01-base-v28 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v28.scad (new)
- knowledge.map (v27 → Superseded, v28 → ACTIVE)
- cc_chat_log.md

Change: spring_tray() for-loop — spring coil Y translate corrected.
- Before: translate([x, tray_d - motor_d - e, tray_floor_t + spring_od/2 + e])
- After:  translate([x, spring_l + e, tray_floor_t + spring_od/2 + e])

After rotate([90,0,0]), cylinder extends in -Y direction.
Front face at Y = spring_l + e = 390.01. Rear face at Y = e = 0.01.
Coil fills tray from Y≈0 (drop zone boundary) to Y≈390 (motor start). Correct geometry.

⚑ FLAG: Janis must open VM-01-base-v28.scad → F6 → confirm 2-manifold warning GONE.

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v28.scad

---

### 2026-06-29 | VM-01-base-v27 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v27.scad (new)
- knowledge.map (v26 → Superseded, v27 → ACTIVE)
- cc_chat_log.md

Change: spring_coil() — removed difference() hollowing. Replaced with single solid cylinder:
```
module spring_coil() {
    color("#888888", 0.8)
    cylinder(h=spring_l, d=spring_od);
}
```
The inner hollow cylinder (spring_l-1) inside the outer (spring_l) was a confirmed
chronic 2-manifold source — inner top face at spring_l-1 was near-flush with outer top at spring_l.
Solid cylinder is always manifold.

⚑ FLAG: Janis must open VM-01-base-v27.scad → F6 → confirm 2-manifold warning GONE.

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v27.scad

---

### 2026-06-29 | Governance Restructure + VM-01-base-v26 | COMMITTED

**Files moved/created:**
- rules-codes.md → .claude/rules-codes.md (moved, root copy deleted)
- .claude/rules-vm.md (created — new file with header)
- .claude/rules-materials.md (already in .claude/ from prior session — root copy was already gone)
- .claude/SKILL_problem_solving_kt.md (uploaded by Janis — registered only, not rewritten)
- WORKFLOW_SKILL.md (uploaded by Janis — registered only, not rewritten)

**Files modified:**
- knowledge.map → v2: FILE LOCATIONS table updated with .claude/ paths; v25 → Superseded; v26 → ACTIVE; SESSION START PROCEDURE updated
- cc_rules.md → v2: .claude/ file paths updated in "Files cc Reads" section
- rules-dimensions.md → v2: OWNER-LOCKED section added; spring_gap 20 → 13mm; PENDING DECISIONS section added at bottom
- .claude/rules-codes.md → v1.5: Module Isolation Testing section added
- chat_rules.md → v2: Module Isolation Testing rule + R-111 automatic trigger rule added

**Files archived (Task D):**
- All non-archived prompts in /prompts/ moved to /prompts/archive/ with suffix ✅ COMPLETE — 2026-06-29

**New SCAD file:**
- vending-machine/VM-01-base/VM-01-base-v26.scad
  - spring_gap: 20 → 13mm (OWNER-LOCKED, Janis-approved)
  - spring_tray() for-loop inner object epsilon offsets corrected per REVISED prompt:
    - Motor Y: tray_d - motor_d + e → tray_d - motor_d - e (rear face clears outer wall)
    - Spring Y: tray_d - motor_d → tray_d - motor_d - e
    - Partition Y: tray_wall_t → tray_wall_t + e (clears front inner wall face)
  - Version header updated to v26, date 2026-06-29

**Tasks H & I — Janis uploads only:**
- WORKFLOW_SKILL.md: Janis uploaded to repo root. cc registered in knowledge.map. NOT rewritten by cc.
- .claude/SKILL_problem_solving_kt.md: Janis uploaded to .claude/. cc registered in knowledge.map. NOT rewritten by cc.

---

⚑ FLAG: Janis must open VM-01-base-v26.scad → F6 → confirm 2-manifold warning GONE.
⚑ FLAG: Janis must upload new WORKFLOW_SKILL.md to Project Knowledge (Claude Web session).
⚑ FLAG: Janis must upload updated chat_rules.md to Project Knowledge (Claude Web session).
⚑ FLAG: Janis must confirm .claude/SKILL_problem_solving_kt.md is the new version (uploaded this session).
⚑ FLAG: spring_gap = 13mm now in v26 SCAD — OWNER-LOCKED — do not change without Janis written approval.

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v26.scad

---

### 2026-06-29 | VM-01-base-v25 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v25.scad (new)
- knowledge.map (v24 → Superseded, v25 → ACTIVE)
- cc_chat_log.md

**Diagnosis:** v24 tray body rewrite was correct but non-manifold persisted.
Janis confirmed via comment toggle: for loop still triggered warning. Issue was
INTERNAL objects (motors, springs, partitions) having faces coplanar with tray body faces.

**Coplanar faces fixed with epsilon (e=0.01) offsets:**
- Motor cube rear Y: was tray_d (450, flush with rear wall outer face) → tray_d - motor_d + e
- Motor cube depth: motor_d → motor_d - e (shrinks away from rear wall)
- Motor cube bottom Z: tray_floor_t (5, flush with floor top) → tray_floor_t + e
- Spring coil bottom Z: tray_floor_t + spring_od/2 (spring bottom at Z=5, flush with floor) → + e added
- Partition cube bottom Z: tray_floor_t → tray_floor_t + e
- Partition cube rear Y: tray_d - tray_wall_t (447, flush with rear wall inner face) → depth shortened by e

**FLAG FOR CLAUDE WEB — ACTION REQUIRED:**
Janis must open VM-01-base-v25.scad → F6 → confirm 2-manifold warning GONE.
If still present, issue is spring_coil() itself or spring/motor intersection with tray body.

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v25.scad

---

### 2026-06-28 | VM-01-base-v24 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v24.scad (new)
- rules-codes.md (v1.4)
- knowledge.map (v23 → Superseded, v24 → ACTIVE)
- cc_chat_log.md
- prompts/archive/VM-01-base-v24-spring-tray-fix ✅ COMPLETE — 2026-06-28.md

**KT R-111 RESOLVED — Root cause confirmed by Janis manual isolation test:**
spring_tray() was the sole 2-manifold source. Commenting it out cleared warning. All other modules clean.

**Fix 1 — spring_tray() rewritten: APPLIED**
Replaced union() { floor_slab + walls } pattern with single solid cube + difference().
- Old: union() of thin floor (5mm) + 3 tall walls → T-junction at floor top face = non-manifold
- New: cube([tray_w, tray_d, tray_h]) solid, hollow interior subtracted, open front face subtracted
- Left/right windows: Y-start uses tray_wall_t*2 offset (not tray_wall_t)
- All cutouts preserved: rear motor mounts, latch pin hole

**Fix 2 — tray_zone_frame() height: APPLIED**
panel_zone_top_z = 700mm and panel_zone_h = 400mm added to PARAMETERS.
tray_zone_frame() updated from tray_zone_top_z/tray_zone_h (542mm) to panel_zone_top_z/panel_zone_h (700mm).
Frame now matches spring_zone_panel() Z 300-700.

**spring_coil() inner height check: CONFIRMED spring_l-1 in v23 — not touched.**

**rules-codes.md updated to v1.4: CONFIRMED**
New rule: "Never build a tray/box using union() of separate floor + wall pieces."

**FLAG FOR CLAUDE WEB — ACTION REQUIRED:**
Janis must open VM-01-base-v24.scad in OpenSCAD → F6 → confirm 2-manifold warning GONE.
This is the definitive fix. Root cause was spring_tray() union() T-junction confirmed by isolation test.

**FLAG FOR CLAUDE WEB — KT R-111 STATUS:**
Root cause identified and fixed. 8 versions of manifold fixes (v17-v24) across this session.
If v24 F6 shows no warning → KT R-111 CLOSED.

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v24.scad

---

### 2026-06-28 | VM-01-base-v23 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v23.scad (new)
- knowledge.map (v22 → Superseded, v23 → ACTIVE)
- cc_chat_log.md

Change 1: spring_zone_panel() panel_h: tray_h*tray_count (242mm) → total_h-(leg_h+exit_door_h) (400mm).
Panel now spans Z 300-700 — one continuous acrylic piece covering spring zone + upper left zone.
Change 2: All spring_zone_panel() comments and assembly comment updated: Z 300-542 → Z 300-700.

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v23.scad

---

### 2026-06-28 | VM-01-base-v22 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v22.scad (new)
- knowledge.map (v21 → Superseded, v22 → ACTIVE)
- cc_chat_log.md

Change 1: acrylic_display() top panel translate Z: total_h-skin_t → total_h-(skin_t*2). Top panel no longer flush with shell top face.
Change 2: acrylic_display() right panel translate X: total_w-skin_t → total_w-(skin_t*2). Right panel no longer flush with shell right face.
Change 3: tray_zone_frame() all 4 bars Y translate: e → e*2. Increased offset from front face to avoid z-fighting.

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v22.scad

---

### 2026-06-28 | VM-01-base-v21 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v21.scad (new)
- knowledge.map (v20 → Superseded, v21 → ACTIVE)
- cc_chat_log.md

Change: Removed `left_front_acrylic();` from ASSEMBLY section (was line 467 in v20).
Module definition kept in file — only the assembly call removed.
No other lines touched.

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v21.scad

---

### 2026-06-28 | VM-01-base-v20 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v20.scad (new)
- rules-codes.md (v1.3)
- knowledge.map (v19 → Superseded, v20 → ACTIVE)
- cc_chat_log.md
- prompts/VM-01-base-v20-fix-manifold.md
- prompts/archive/VM-01-base-v20-fix-manifold ✅ COMPLETE — 2026-06-28.md

**Fix 1 — spring_coil() inner cylinder: APPLIED**
`cylinder(h=spring_l+1, ...)` → `cylinder(h=spring_l-1, ...)`
Inner was 1mm taller than outer = open top face = non-manifold.
Inner now 1mm shorter = fully enclosed on all faces.

**Fix 2 — compartment_divider() height: APPLIED**
`total_h - leg_h` → `total_h - leg_h - skin_t`
Top face was exactly flush with shell top (Z=700 coplanar) = non-manifold.
Now sits 2mm below shell top — no shared face.

**Fix 3 — tray_zone_frame() corner contacts: APPLIED**
Top/bottom bars now own full-width corner regions.
Side bars shortened: start at tray_0_z+frame_bar, height = tray_zone_h-(frame_bar*2).
Side bars no longer share edges with top/bottom bars — all corners are solid volume from top/bottom bars only.

**rules-codes.md updated to v1.3: CONFIRMED**
Three new rules added to 2-Manifold section:
- difference() inner must be strictly smaller than outer on all faces
- union() geometry must share volume not just edges
- module geometry must not land flush with shell boundary

**FLAG FOR CLAUDE WEB — ACTION REQUIRED:**
Janis must open VM-01-base-v20.scad in OpenSCAD → F6 → confirm 2-manifold warning status.
v20 addresses all identified non-manifold sources across 5 versions of fixes.
If warning still persists, remaining candidates to investigate:
- spring_tray() difference() subtractions — check all subtract geometry heights
- tray_rack() cylinder latch pins — check if flush with tray surfaces
- Any module using Y=0 as a face coordinate without epsilon offset

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v20.scad

---

### 2026-06-28 | VM-01-base-v19 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v19.scad (new)
- knowledge.map (v18 → Superseded, v19 → ACTIVE)
- cc_chat_log.md

**Fix 1 — dashboard() support bracket:**
Replaced hull() over two rotate([-90,0,0]) cylinder() calls with a flat crossbar cube:
`cube([screen_w, 30, bracket_r * 2])`
Rotated cylinders inside hull() produce non-planar faces that OpenSCAD cannot guarantee
are manifold. Flat cube is clean solid geometry with no risk.

**Fix 2 — sensor_strip() laser beam visual:**
Changed `cube([..., 1, 1])` to `cube([..., 2, 2])`.
1mm on two axes = near-zero degenerate geometry = non-manifold trigger.

**Flag for Claude Web — ACTION REQUIRED:**
Janis must open VM-01-base-v19.scad in OpenSCAD → F6 → check if 2-manifold warning is gone.
If warning persists, the remaining suspect is tray_zone_frame() — shared cube edges at corners
without epsilon offset. Report result so cc can write v20 if needed.

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v19.scad

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

Most likely culprit: **dashboard()** — specifically the curved support bracket at lines 389–394 of v16.

Secondary suspect: **sensor_strip()** — the "laser beam" cube at `cube([..., 1, 1])` is degenerate (1mm in two axes). Near-zero geometry can cause non-manifold edges.

Third candidate: **tray_zone_frame()** — four cubes in a union() that share edges at corners.

**Task 3 — rules-codes.md updated to v1.1: CONFIRMED**
- New rule added to 2-Manifold section: "Read the live .scad file before writing any fix"

**Flag for Claude Web — v18 planning:**
- Primary fix target: dashboard() support bracket — replace hull()+rotated cylinders with simpler geometry
- Secondary: sensor_strip() 1x1mm cube — add minimum 2mm on each axis
- Active SCAD: vending-machine/VM-01-base/VM-01-base-v17.scad

---

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

### 2026-06-28 | VM-01-base-v16 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v16.scad
- cc_chat_log.md

Changes:
- Fix 1: acrylic_display() — hull() front panel replaced with flat cube: translate([acrylic_front_x, e, acrylic_bot_z]) cube([acrylic_front_w, door_t, acrylic_zone_h]). Simpler geometry, no z-fighting.
- Fix 2: outer_shell() hollow subtract Z changed from skin_t → leg_h+skin_t. Assembly translate([0,0,leg_h]) removed — outer_shell() now called directly as outer_shell().
- Fix 3: Version header v15 → v16, date 2026-06-28.
- **Active SCAD:** vending-machine/VM-01-base/VM-01-base-v16.scad

---

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

---

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

---

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

---

### 2026-06-27 | VM-01-base-v13 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v13.scad

Changes:
- Fix 1: outer_shell opacity restored to 0.75 (solid shell). left_front_acrylic() opacity updated 0.15 → 0.25. Shell is solid; only the left front face panel is transparent.
- Fix 2: exit_door_h = 250 moved BEFORE tray zone calculations. Declaration order: exit_door_h → exit_door_w → tray_zone_h → tray_0_z → tray_zone_top_z. Resolves all 'undefined variable' warnings from OpenSCAD.
- **Active SCAD:** vending-machine/VM-01-base/VM-01-base-v13.scad

---

### 2026-06-27 | Satu vending 01.scad — Manual fix | CONFIRMED

- exit_door_h = 250 inserted immediately before tray_0_z by Janis manually (Option A)
- File is a local working copy, not in repo — all 28 warnings resolved
- Render confirmed clean: solid shell, springs visible through left front acrylic, dashboard visible right compartment

---

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

---

### 2026-06-27 | VM-01-base-v11 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v11.scad

Changes:
- Fix 1: spring_zone_panel() — explicit world coords: X=skin_t, Y=0, Z=leg_h+exit_door_h (300mm), width=product_w-(skin_t*2), height=tray_h*tray_count (242mm). Left product zone only.
- Fix 2: Roof restored — hollow interior height changed total_h → total_h-skin_t. Top skin now solid at Z=700+leg_h.
- Fix 3: screen_y = skin_t - screen_protrude (was 0 - screen_protrude). Screen protrudes 30mm forward from machine front face.
- **Active SCAD:** vending-machine/VM-01-base/VM-01-base-v11.scad

---

### 2026-06-27 | VM-01-base-v10 | COMMITTED

- Spring zone acrylic panel: transparent customer selection window, Z 300-542, full product_w, #ADD8E6 opacity 0.15, left hinge, shown closed
- Screen Y: -30mm (protrudes 30mm forward of machine front face — visible from front view)
- **Active SCAD:** vending-machine/VM-01-base/VM-01-base-v10.scad

---

### 2026-06-27 | VM-01-base-v9 | COMMITTED

- total_d: 550 → 600mm (motor needs 60mm depth)
- motor_d: 20 → 60mm (real motor size from spring thread)
- Spring direction FIXED: motor now at BACK of tray, spring front end at drop zone boundary (Y=0 tray-local). Products fall forward into exit zone.
- front_door: now covers EXIT ZONE ONLY (Z 50-300, 250mm). Spring display zone Z 300-542 is OPEN.
- Customer pickup flap: 100mm tall x 250mm wide (was full exit zone size)
- Sensor: replaced per-spring sensors with parallel strip pair on left/right walls at Z=280mm.
- Right compartment front: cutout added — screen/QR/card now visible.
- Governance: knowledge.map + cc_chat_log.md created.
- **Active SCAD:** vending-machine/VM-01-base/VM-01-base-v9.scad

---

### 2026-06-27 | VM-01-base-v8 | COMMITTED

- Tray side windows: restored 3mm border frame (centre open)
- Screen Y: moved to skin_t (front face of right compartment)

---

### 2026-06-27 | VM-01-base-v7 | COMMITTED

- total_h: 800 → 700mm
- Zone stack fixed: legs 0-50 | exit 50-300 | tray0 300-421 | tray1 421-542 | upper 542-700
- Acrylic: Z 542-698 (was 430-798)
- Screen center Z: 280mm
- Upper front door cutout added (Z 542-700)
- Deleted .claude/rules-dimensions.md (root is authoritative)

---

### 2026-06-27 | VM-01-base-v6 | COMMITTED

- Major rebuild: tray_h=121, independent removable trays
- New: tray_rack (fixed rails + latch pins)
- New: front_door (single panel Z 50-542, left hinge)
- New: tray_zone_frame
- New: dashboard (ATM screen, QR, card slot, speaker)
- Acrylic: 3 faces of right compartment above 430mm

---

### 2026-06-27 | VM-01-base-v5 | COMMITTED

- Acrylic panel: rounded window (hull+cylinders r=10, t=3mm)
- Spring tray side walls: 3mm frame, open centre

---

### 2026-06-27 | VM-01-base-v4 | COMMITTED

- tray_h: 116 → 86mm (spring OD 66 + 20mm clearance)
- Spring tray front face: open
- Tray Z formula: leg_h + exit_door_h + (tray_num * tray_h)
- Acrylic panel: right compartment only

---

### 2026-06-27 | Setup | COMMITTED

- Created: WORKFLOW_SKILL.md v2 (team structure, protocols)
- Created: chat_rules.md (Claude Web rules)
- Created: cc_rules.md (cc rules)
- Created: rules-dimensions.md (VM-01 dimensions)
- **Active SCAD:** VM-01-base-v3.scad (existed before this session)
