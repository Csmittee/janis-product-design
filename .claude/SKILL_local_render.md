# SKILL_local_render.md
# Local OpenSCAD Render Verification — Janis Product Design
# Version: 1.0 — 2026-07-01
# Location: .claude/SKILL_local_render.md
# Read when: any geometry design or fix session is starting, or any time
# a new module shape is being designed before sending to cc.

---

## WHAT THIS IS

Claude Web has access to a bash sandbox where it can install and run
OpenSCAD headlessly (no display needed — xvfb-run provides a virtual
framebuffer). This allows Claude Web to prototype geometry, render PNG
screenshots at multiple angles, and visually verify shape before writing
a single cc prompt.

This eliminates the screenshot→guess→fix loop (which burned v10–v20 on
PR-01-base, 11 versions and 5+ chat sessions for one part). Use it every
time a new module shape is designed.

---

## HOW TO USE

### Step 1 — Install OpenSCAD (first time only per session)
```bash
rm -f /etc/apt/sources.list.d/nodesource.sources
apt-get update -qq
apt-get install -y -qq openscad xvfb
```

Verify: `xvfb-run -a openscad --version`

### Step 2 — Write a prototype .scad file
Build only the module being designed — use real project dimensions from
rules-dimensions.md (not guessed numbers). Keep it isolated: one module,
correct global params, nothing else.

Save to `/home/claude/proto/concept.scad` (working dir, not output).

### Step 3 — Render multiple angles
Always render at minimum: iso, side (ortho), front (ortho).
For complex shapes also render: top, bottom, rear.

```bash
mkdir -p /home/claude/proto
xvfb-run -a openscad -o iso.png \
  --imgsize=1200,900 --projection=ortho \
  --camera=300,260,160,52,0,5 \
  --colorscheme=Tomorrow concept.scad

xvfb-run -a openscad -o side.png \
  --imgsize=1200,900 --projection=ortho \
  --camera=52,350,10,52,0,5 \
  --colorscheme=Tomorrow concept.scad

xvfb-run -a openscad -o front.png \
  --imgsize=1200,900 --projection=ortho \
  --camera=350,0,5,52,0,5 \
  --colorscheme=Tomorrow concept.scad
```

### Step 4 — View and iterate
Use `view` tool to inspect each PNG. Identify issues visually. Fix the
.scad file. Re-render. Repeat until shape is confirmed correct across
all angles BEFORE writing any cc prompt.

### Step 5 — Only then write the cc prompt
Once shape is visually confirmed: save the approved .scad as a reference
file, then write the cc prompt using the confirmed geometry as the spec
(not a description of intent — actual coordinates, module names, and
construction method verified locally).

---

## CRITICAL RULES

- ALWAYS use real project dimensions — read rules-dimensions.md first.
  Never use placeholder numbers that differ from the project's locked values.
- ALWAYS render at least 3 angles before calling a shape "confirmed."
- NEVER write a cc geometry prompt for a new module shape without local
  render verification first. The whole point is to catch misunderstandings
  BEFORE cc burns a version on them.
- Use `--projection=ortho` for diagnostic views (true shape without
  perspective distortion). Use perspective (omit flag) for presentation/
  aesthetic views only.
- If OpenSCAD reports errors in stderr, fix them before rendering further.
  A render with geometry errors is not a valid verification.
- Multi-component assemblies: color each component separately so individual
  parts are identifiable in renders. Red for levers/actuators, brass for
  mechanical components, dark blue for structural housing.

---

## KNOWN GOOD CAMERA ANGLES (for this project's scale ~100mm parts)

```
Iso:   --camera=300,260,160,52,0,5
Side:  --camera=52,350,10,52,0,5
Front: --camera=350,0,5,52,0,5
Top:   --camera=52,0.01,280,52,0,5
Back:  --camera=-250,0,5,52,0,5
Bottom:--camera=52,0.001,-150,52,0,5
```

Adjust distance (first 3 values) based on part size.
`--imgsize=1200,900` is the standard resolution.

---

## ISOLATION-TEST DISCIPLINE (same as manifold triage)

If a joint/transition has failed QA once on real renders:
1. Local-render first: prototype the fix in the sandbox.
2. Only if local render confirms the fix visually: write the cc prompt.
3. Never write a cc fix prompt for a joint/seam/blend issue without
   first verifying it locally. This is how v17–v20 wasted 4 versions —
   the hull() orientation mismatch would have been caught immediately in
   local render.
