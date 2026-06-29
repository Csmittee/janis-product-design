# janis-product-viewer.md
# Prompt for cc — Janis Product Design Viewer
# Written by: Claude Web
# Date: 2026-06-29
# Save to: /prompts/janis-product-viewer.md

---

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order before touching anything. State every file read:
1. cc_rules.md
2. cc_chat_log.md (first 3 entries — newest at top)
3. knowledge.map
4. vending-machine/VM-01-base/VM-01-base-v36.scad (PARAMETERS section only — top 80 lines)

This prompt creates one new HTML file. No SCAD changes. No rules changes.

---

## 2. CONTEXT

Janis needs a browser-based 3D viewer for all Janis Product Design models.
Deployment: Satu backend public/ folder → served at api.janishammer.com/janis-product-viewer.
Cloudflare auto-serves public/ by filename — no wrangler.toml change needed.

The viewer must:
- Run entirely in browser — no server, no build step
- Use OpenSCAD WebAssembly to render .scad files (same engine as CADAM)
- Show a Three.js 3D canvas with orbit controls (zoom, rotate, pan)
- Let Janis pick any available project from a dropdown
- Expose key parameters as sliders (from active project)
- Visibility toggles matching debug toggles already in v36
- STL export, screenshot, print view
- Gold/dark theme matching Satu HTML tools

cc builds the file in Janis repo at /viewer/janis-product-viewer.html.
Janis manually copies to Satu backend public/ and pushes. No other repo changes by cc.

---

## 3. NEW FILES

- `viewer/janis-product-viewer.html` — NEW — self-contained, all CSS and JS inline

Add to knowledge.map under new `## VIEWER` section.

---

## 4. TASKS

### TASK 1 — Create `/viewer/janis-product-viewer.html`

Single self-contained HTML file. All CSS and JS inline.
External CDN libraries only — no npm, no build step.

---

#### CDN LIBRARIES

```html
<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/controls/OrbitControls.js"></script>
<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/loaders/STLLoader.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@openscad/wasm@0.0.3/dist/openscad.js"></script>
```

---

#### COLORS — match Satu gold/dark theme

```css
--bg-dark:     #0a0a0a;
--bg-panel:    #111111;
--bg-card:     #1a1a1a;
--border:      #2a2a2a;
--gold:        #d4a843;
--gold-dim:    #8a6a2a;
--text:        #cccccc;
--text-dim:    #666666;
--text-bright: #ffffff;
--green:       #27ae60;
--red:         #c0392b;
```

---

#### LAYOUT — 3 column

```
┌──────────────────────────────────────────────────────────────────┐
│  HEADER: ⛮ JANIS PRODUCT DESIGN · Viewer v1.0 · [project ▼]   │
├──────────┬───────────────────────────────────┬───────────────────┤
│ LEFT     │  3D CANVAS                        │ RIGHT             │
│ 220px    │  Three.js + OrbitControls         │ 260px             │
│          │  Dark bg, grid floor              │                   │
│ Project  │  Rotate/zoom/pan                  │ Parameters        │
│ selector │                                   │ sliders           │
│          │                                   │                   │
│ View     │                                   │ Visibility        │
│ presets  │                                   │ toggles           │
│          │                                   │                   │
│ Render   │                                   │ Status + log      │
│ quality  │                                   │                   │
│          │                                   │                   │
│ Actions  │                                   │                   │
└──────────┴───────────────────────────────────┴───────────────────┘
```

---

#### PROJECT REGISTRY — JS object at top of script

cc reads knowledge.map + v36 PARAMETERS section and fills exact values:

```javascript
const PROJECTS = {
  'VM-01': {
    label: 'VM-01 Vending Machine',
    version: 'v36',
    status: 'Manifold clean',
    params: [
      { id: 'total_w',      label: 'Width (mm)',     value: 640, min: 500, max: 800, step: 10, locked: false },
      { id: 'total_h',      label: 'Height (mm)',    value: 700, min: 600, max: 900, step: 10, locked: true  },
      { id: 'total_d',      label: 'Depth (mm)',     value: 600, min: 450, max: 700, step: 10, locked: false },
      { id: 'tray_count',   label: 'Tray Count',     value: 2,   min: 1,   max: 4,   step: 1,  locked: false },
      { id: 'spring_gap',   label: 'Spring Gap (mm)',value: 13,  min: 13,  max: 13,  step: 1,  locked: true  },
      { id: 'spring_lanes', label: 'Spring Lanes',   value: 5,   min: 3,   max: 8,   step: 1,  locked: false },
    ],
    toggles: [
      { id: 'show_shell_left',  label: 'Left Shell',  default: true },
      { id: 'show_shell_right', label: 'Right Shell', default: true },
      { id: 'show_shell_back',  label: 'Back Shell',  default: true },
      { id: 'show_shell_top',   label: 'Top Shell',   default: true },
    ],
    // cc embeds full v36 SCAD content here as template literal
    scad: `// PASTE FULL CONTENT OF VM-01-base-v36.scad HERE`
  },
  'PR-01': {
    label: 'PR-01 Pilates Reformer',
    version: null,
    status: 'Not started',
    params: [],
    toggles: [],
    scad: null
  }
};
```

**CRITICAL:** cc reads vending-machine/VM-01-base/VM-01-base-v36.scad in full and
pastes its complete content as the template literal value for VM-01.scad above.
This makes the viewer fully self-contained — no GitHub fetch needed, works offline.

---

#### LEFT SIDEBAR

**Project selector:**
```
PROJECTS
[VM-01 Vending Machine ▼]
Version: v36  Status: ✅ Manifold clean
```

**View presets:**
```
VIEW
[Front] [Back] [Top]
[Left] [Right] [ISO]
```
Each button sets camera position to a standard angle. ISO is default on load.

**Render quality:**
```
RENDER QUALITY
(•) Fast fn=16   ( ) Normal fn=32   ( ) Fine fn=64
```
Injects `$fn = N;` override at top of SCAD before rendering.
Default: Fast (fn=16) — quick iteration. Janis switches to Fine for final screenshot.

**Actions:**
```
[⬇ Export STL]
[📷 Screenshot]
[🖨 Print View]
```

Export STL: trigger download of last rendered STL binary from WASM output.
Screenshot: THREE.js renderer.domElement.toDataURL() → PNG download.
Print View: hide all panels, white bg, show model + param table, window.print(), restore.

---

#### 3D CANVAS

- Background: #111111
- THREE.GridHelper on floor — grey lines, gold accent every 500mm (5 units at 1:100 scale)
- THREE.AmbientLight #ffffff intensity 0.4
- THREE.DirectionalLight #ffffff intensity 0.8 from top-front-right
- THREE.DirectionalLight #aaaaff intensity 0.3 from left (fill)
- OrbitControls: left drag = rotate, right drag = pan, scroll = zoom
- [⌂] camera reset button — top-right corner of canvas — returns to ISO view
- Axis indicator bottom-right — small XYZ arrows in red/green/blue
- Render stats bottom-left — triangle count + render time — small, dimmed text

On model load:
- Parse STL → THREE.BufferGeometry
- Apply THREE.MeshPhongMaterial color #CCCCCC, shininess 40
- computeVertexNormals()
- Center geometry on grid (translate so bounding box center = origin)
- Camera auto-fit to bounding box

When PR-01 selected (scad: null):
- Clear scene
- Show centered text overlay: "PR-01 not started yet" (gold, large)
- Subtitle: "Dimensions pending from Janis" (dim, small)

---

#### RIGHT SIDEBAR

**Parameters panel:**

For each param in active project:
```
Width (mm)
[════════════════════] 640        (unlocked — interactive)

Spring Gap (mm)  🔒
[════════════════════] 13         (locked — disabled, gold lock icon)
```

- Locked params: slider disabled, gold 🔒 icon, value display only
- Unlocked params: range input, shows current value live as you drag
- Debounce: 800ms after last slider move → auto-render if [Auto-render] is ON

**[Apply Changes]** — gold full-width button — triggers WASM render immediately
**[Reset Defaults]** — text link button — resets all params to project defaults
**Auto-render** — small toggle — ON = render on slider release, OFF = manual only

**Visibility Toggles panel:**

```
VISIBILITY
[✓ Left Shell]  [✓ Right Shell]
[✓ Back Shell]  [✓ Top Shell]
```

Toggle buttons: gold border + gold text when ON, dim border + dim text when OFF.
On toggle → inject new value into SCAD → re-render (respects Auto-render setting).

**Status / Log panel:**

```
STATUS
● Rendering...    or    ✅ Ready (2.3s)    or    ❌ Error

LOG                                              [Clear]
> WASM loaded
> Rendering VM-01-base-v36 fn=16...
> ✅ Complete: 2.3s — 48,221 triangles
> ⬇ STL exported (2.1 MB)
```

Scrollable. Max 50 lines. Newest at bottom.

---

#### SCAD RENDERING FLOW

```javascript
async function renderScad() {
  const proj = PROJECTS[activeProject];
  if (!proj.scad) return; // PR-01 not started

  // 1. Build param override block
  let overrides = '';
  proj.params.forEach(p => {
    overrides += `${p.id} = ${currentValues[p.id]};\n`;
  });
  proj.toggles.forEach(t => {
    overrides += `${t.id} = ${currentToggles[t.id]};\n`;
  });

  // 2. Inject overrides at top — OpenSCAD uses last assignment
  const scadWithOverrides = overrides + '\n' + proj.scad;

  // 3. Run OpenSCAD WASM
  log('Rendering ' + proj.label + ' fn=' + currentFn + '...');
  const startTime = Date.now();
  const result = await openscad.render(scadWithOverrides);

  // 4. Parse STL → Three.js
  const geometry = new THREE.STLLoader().parse(result.stl.buffer);
  geometry.computeVertexNormals();
  geometry.center();

  // 5. Update scene
  updateScene(geometry);

  // 6. Log result
  const elapsed = ((Date.now() - startTime) / 1000).toFixed(1);
  log('✅ Complete: ' + elapsed + 's — ' + geometry.attributes.position.count/3 + ' triangles');
}
```

---

#### HEADER

```html
<header>
  ⛮ JANIS PRODUCT DESIGN
  <span class="subtitle">3D Model Viewer</span>
  <span class="version">v1.0</span>
  <select id="project-select-header">...</select>  <!-- mirrors left sidebar -->
</header>
```

Header height: 52px. Gold on "JANIS PRODUCT DESIGN". Version badge right-aligned.
Project dropdown in header synced with left sidebar dropdown — both trigger same renderScad().

---

#### PRINT VIEW

On [🖨 Print View]:
1. Store current UI state
2. Hide all panels — canvas only, white background
3. Add print overlay below canvas:
   - Project name + version
   - Date: today
   - Parameter table (2 columns: label | value | locked?)
   - "Generated by Janis Product Design Viewer"
4. window.print()
5. On afterprint event: restore dark UI

---

## 5. DO NOT TOUCH

- All .scad files in vending-machine/ or pilates-reformer/
- All rules files
- prompts/ existing files
- knowledge.map existing content — append only
- Nothing in Satu backend repo — Janis handles the copy manually

---

## 6. QA VERIFICATION

cc confirms all before committing:

- [ ] File at viewer/janis-product-viewer.html
- [ ] Opens via file:// in browser — no console errors on load
- [ ] Three.js canvas visible — dark bg + grid floor
- [ ] OpenSCAD WASM loads — log shows "WASM loaded"
- [ ] VM-01 selected by default — full SCAD embedded (not empty string)
- [ ] [Apply Changes] triggers render — log updates with time + triangle count
- [ ] STL geometry appears in canvas after render
- [ ] Orbit controls work: rotate / pan / zoom
- [ ] View preset buttons change camera angle
- [ ] Parameter sliders: spring_gap and total_h show 🔒 and are disabled
- [ ] Unlocked sliders change value live as dragged
- [ ] Visibility toggles change appearance (ON=gold, OFF=dim)
- [ ] Render quality radio changes $fn (fn=16 default)
- [ ] [Export STL] downloads a file
- [ ] [Screenshot] downloads PNG of canvas
- [ ] [Print View] hides UI, shows print layout, restores after
- [ ] PR-01 selection shows placeholder text — no JS error
- [ ] Project dropdown in header + left sidebar stay in sync
- [ ] knowledge.map updated with viewer entry

---

## 7. MANDATORY CLOSING

1. Prepend new entry to cc_chat_log.md at TOP — max 10 lines
2. Archive prompt → /prompts/archive/janis-product-viewer ✅ COMPLETE — 2026-06-29
3. Update knowledge.map — add viewer/janis-product-viewer.html
4. Bump version on all modified .md files
5. Commit all → merge to main

---

## JANIS ACTION AFTER cc COMMITS

1. Download viewer/janis-product-viewer.html from Janis repo
2. Copy to Satu backend repo: public/janis-product-viewer.html
3. git push Satu backend → Cloudflare auto-deploys
4. Open: api.janishammer.com/janis-product-viewer ✅
