# CC PROMPT — VM-01-base-v13 Export
> Version 1.0 — 2026-06-28
> Task: STL export + 4-angle PNG renders
> Save this file to: /prompts/VM-01-base-v13-export.md

---

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order before touching anything:
1. `cc_rules.md`
2. `cc_chat_log.md` (last 3 entries)
3. `rules-dimensions.md`
4. `vending-machine/VM-01-base/VM-01-base-v13.scad`

State every file read before writing a single line.

---

## 2. CONTEXT

VM-01-base-v13 has passed QA. Janis needs supplier deliverables:
- STL file for physical fabrication reference
- 4-angle PNG renders so supplier can visually understand the design intent

This is a prototype — supplier will use their own tools for final dimensions.
No DXF, no PDF required at this stage.

---

## 3. NEW FILES

The following files will be created:

**STL:**
- `exports/for-supplier/VM-01-base-v13.stl`

**PNG renders (4 angles):**
- `renders/VM-01-base-v13-front.png`
- `renders/VM-01-base-v13-side.png`
- `renders/VM-01-base-v13-top.png`
- `renders/VM-01-base-v13-perspective.png`

Add all 5 files to `knowledge.map` under VM-01-base exports.

---

## 4. TASKS

### TASK 1 — STL Export

Run OpenSCAD headless CLI to export STL:

```bash
openscad -o exports/for-supplier/VM-01-base-v13.stl \
  vending-machine/VM-01-base/VM-01-base-v13.scad
```

If OpenSCAD CLI is not available at `openscad`, try:
- `openscad-nightly`
- `/usr/bin/openscad`
- `/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD`

If CLI is not available on this system, create a shell script instead:
`exports/for-supplier/export-vm01-v13.sh` with the correct command,
and note this in cc_chat_log.md so Janis can run it manually.

---

### TASK 2 — 4-angle PNG Renders

Run OpenSCAD headless CLI with `--render` flag for each angle.

Camera format: `--camera=eyeX,eyeY,eyeZ,centerX,centerY,centerZ`
Image size: `--imgsize=1920,1080`

Machine center reference (from rules-dimensions.md):
- Total W=620, H=700, D=600
- Center of machine: X=310, Y=300, Z=350

**FRONT view** (looking from Y- toward machine front face):
```bash
openscad --render \
  --camera=310,-1200,350, 310,300,350 \
  --imgsize=1920,1080 \
  -o renders/VM-01-base-v13-front.png \
  vending-machine/VM-01-base/VM-01-base-v13.scad
```

**SIDE view** (right side, looking from X+ toward machine):
```bash
openscad --render \
  --camera=1800,300,350, 310,300,350 \
  --imgsize=1920,1080 \
  -o renders/VM-01-base-v13-side.png \
  vending-machine/VM-01-base/VM-01-base-v13.scad
```

**TOP view** (looking down from Z+):
```bash
openscad --render \
  --camera=310,300,1800, 310,300,350 \
  --imgsize=1920,1080 \
  -o renders/VM-01-base-v13-top.png \
  vending-machine/VM-01-base/VM-01-base-v13.scad
```

**PERSPECTIVE view** (front-right-above):
```bash
openscad --render \
  --camera=1400,-900,1200, 310,300,350 \
  --imgsize=1920,1080 \
  -o renders/VM-01-base-v13-perspective.png \
  vending-machine/VM-01-base/VM-01-base-v13.scad
```

If CLI renders fail, create a shell script:
`renders/render-vm01-v13.sh` with all 4 commands,
and note in cc_chat_log.md so Janis can run manually.

---

## 5. DO NOT TOUCH

- `rules-dimensions.md` — read only, never edit
- `vending-machine/VM-01-base/VM-01-base-v13.scad` — read only, source file only
- All other `.scad` files not listed above
- `WORKFLOW_SKILL.md`
- `chat_rules.md`

---

## 6. QA VERIFICATION

Before closing:
- [ ] STL file exists at correct path OR export script created with note in log
- [ ] All 4 PNG files exist at correct paths OR render script created with note in log
- [ ] No OpenSCAD errors reported during render/export
- [ ] File sizes are non-zero (STL > 1KB, each PNG > 10KB)
- [ ] knowledge.map updated with all 5 new files

---

## 7. MANDATORY CLOSING

1. Append `cc_chat_log.md` — newest entry at BOTTOM. Include:
   - Which files were successfully exported
   - Whether CLI ran directly or scripts were created for Janis
   - Any warnings from OpenSCAD during export
2. Archive this prompt → `prompts/archive/` stamped ✅ COMPLETE — 2026-06-28
3. Update `knowledge.map` — add all new export/render files
4. Bump version header on any file changed
5. Commit all → merge to main

Confirm what you changed after commit.
