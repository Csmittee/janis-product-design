# SKILL_local_render.md
# Local OpenSCAD Render Verification — Janis Product Design
# Version: 1.2 — 2026-07-27
# Changes: bbq-lid-hinge-v11 aftermath — Janis ran a real cross-chat A/B:
# a render technique note that worked very well for one chat session
# (the BBQ frontal-lid-rib round) still produced messy/confusing views
# when handed to a DIFFERENT chat, because it was never wired into this
# governance file — a new session had no automatic reason to read it.
# Folded its real, working content in here (the ONLY place both cc and
# Claude Web read before rendering) and fixed 2 real, standing gaps in
# this file's own prior content: (1) "KNOWN GOOD CAMERA ANGLES" was a
# fixed preset hardcoded for ~100mm-scale VM/PR parts — silently wrong
# for BBQ's 600-1500mm scale (the actual, confirmed root cause of past
# "flat"/clipped renders), replaced with a real bounding-box-derived
# formula, scale-independent by construction. (2) no standing rule
# existed for a labeled cut-section view (numbered control points, the
# technique that made the BBQ rib profile easy for Janis to confirm at a
# glance) — new section added. Also codifies Janis's own explicit,
# recurring complaint: renders presented in an arbitrarily rotated local
# frame, or a degenerate single-plane "iso" that reads as flat with no
# real information — new WORLD-COORDINATES-ONLY section states this as a
# hard rule, not a style preference. X.Y bump (detail/structure addition
# to existing sections, the skill's own scope/purpose unchanged).
# Previous: 1.1 — 2026-07-16
# Location: .claude/SKILL_local_render.md
# Read when: any geometry design or fix session is starting, any time a
# new module shape is being designed before sending to cc, or any time
# ANY render/screenshot is about to be shown to Janis — camera setup,
# section-view labeling, and world-coordinate framing (below) are not
# optional extras, they are the default presentation for every render.
# Also read when R-111 has triggered (2+ failed loops on the same
# human-reported symptom) — see that section further below.

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

## CAMERA SETUP — COMPUTE FROM THE REAL GEOMETRY, EVERY TIME

**This project spans wildly different physical scales** (VM/PR parts
~100mm, BBQ ~600-1500mm) — a fixed camera preset from one product is
silently wrong on another. The single most common cause of a "flat" or
badly-framed render in this project's own history was reusing a preset
tuned for the wrong scale. Never copy a camera number from an old
render — always derive it fresh from the CURRENT geometry's own real
bounding box, every time, using the formula below.

### The formula (6-value eye/center form)

`--camera=eyeX,eyeY,eyeZ,centerX,centerY,centerZ`

1. **Find the real center** — the midpoint of the bounding box of
   whatever you're actually looking at (the whole assembly for an
   overview, or just the sub-region of interest for a detail shot — see
   "Full view of the area of interest" below). Use real project
   coordinates, read from the actual constants/formulas, never eyeballed.
2. **Pick a real 3-axis direction for iso views** — a direction vector
   with a genuine, non-degenerate component in all three axes, e.g.
   `dir = (1, -1, 0.6)` (normalize it). A camera offset in only two of
   the three axes (one axis left at 0) reads as a flat elevation, not a
   true iso — this is the single most common cause of a "meaningless
   flat surface" render Janis has flagged before. For a pure side or
   front view (not iso), the camera legitimately sits on ONE axis,
   looking straight at the center — that's correct there, just not for
   an iso shot.
3. **Pick distance = roughly 2-3x the object's largest bounding-box
   dimension.** Too close clips into the geometry or loses context; too
   far makes small features unreadable. Neither "too deep zoomed" nor
   "too wide zoomed out" — frame the actual area of interest snugly.
4. `eye = center + dir * distance`.

Worked example, an object ~900mm long x 600mm wide x 800mm tall
(center ~450,300,1000):
```
--camera=1900,-1150,2050,450,300,1000 --projection=ortho
```
Worked example, an object ~100mm x 80mm x 60mm (center ~52,0,5) — the
project's own older small-part convention, still valid at its own
scale:
```
--camera=300,260,160,52,0,5 --projection=ortho
```
Same formula, different inputs — never reuse the numbers, always
recompute the inputs (center + scale) from the CURRENT part.

### Required view set — every render round, not just one iso

For ANY geometry being shown to Janis: **iso (full view of the area of
interest, not too tight/not too wide) + a straight side view + a
straight front view**, at minimum. Add a top/back/bottom or a tight
detail shot only when the specific question needs it. One iso alone is
never enough to confirm shape, fit, or a gap — this matches the
project's own long-standing "render 3+ angles" rule, now stated as a
hard minimum rather than a suggestion.

### Other settings that matter as much as the camera

- **Always `--projection=ortho`** for any view used to check dimensions,
  alignment, or shape — perspective distorts true proportions and hides
  misalignments. Drop `ortho` only for a final presentation shot where
  no measurement/alignment claim is being made.
- **Color every distinct component differently** — a monochrome render
  is unreadable in 3D even with a perfect camera. Convention: structural/
  fixed housing in steel blue, the moving/lid part in orange, the part
  actually being designed/verified in solid red or full opacity, hubs/
  pivots/bores in gold, off-the-shelf hardware in brass.
- **Opacity for context, full opacity for focus** — background/context
  parts (shell, lid) at alpha ~0.5-0.6 so what's happening behind/inside
  is visible, the part actually being verified fully opaque.
- `--imgsize=1200,900` (small parts) or `1400,1100` (BBQ-scale, more
  detail to fit) is the standard resolution — bump higher for a detail
  crop.

---

## WORLD COORDINATES ONLY — NO ROTATED OR DEGENERATE VIEWS

**Never rotate the OBJECT to make a render look nicer.** Every render
shown to Janis presents the geometry in its own real, live project world
coordinates — the CAMERA moves to frame it (per the formula above), the
object never does. A render is only useful for confirming or discussing
real construction if its coordinates map directly to the actual project
constants — an object rotated for framing convenience breaks that
mapping and makes the image impossible to reason about together (Janis's
own recurring complaint: "many chat present me with rotate angle,
difficult to understand image").

This also rules out the degenerate case Janis has flagged directly: an
"iso" view built with a camera direction that has zero offset on one
axis renders as a flat, meaningless plane, not a real 3D shape — this is
the SAME root cause named in the camera formula above (a direction
vector needs real components in all three axes), stated again here as
its own explicit rule because it's a distinct failure mode from picking
a bad distance/center: a degenerate iso can have a perfectly reasonable
center and distance and still be worthless if the direction vector is
flat.

If a rotated or cropped view is genuinely necessary to show something
(e.g. a cross-section, see below), the RENDER PIPELINE may rotate/cut —
but the underlying object and any coordinates discussed in text must
still refer to real world coordinates, and the render's own caption must
say explicitly what cut/rotation was applied and why.

---

## LABELED CUT-SECTION VIEWS FOR COMPLEX GEOMETRY

When designing or discussing any non-trivial profile (a rib, a bracket,
any multi-point traced shape) — not just a bounding-box check — produce
a labeled 2D cross-section with each real control point numbered, in
the SAME numbering the accompanying `.scad` code uses (e.g. `t1`..`t6`
labeled as `1`..`6`). This is the single technique that made the BBQ
door-rib profile easy for Janis to confirm at a glance across multiple
chat sessions — treat it as the default presentation for this class of
geometry, not an occasional extra.

### Preferred technique: a real Python/matplotlib diagram, not a raw OpenSCAD screenshot

A raw OpenSCAD render of a 2D profile is hard to label cleanly (text()
placement/rendering varies by version, no easy per-point callouts). Where
Python is available in the sandbox, compute the SAME real control-point
coordinates the `.scad` file uses (port the exact formulas — do not
hand-approximate them) and plot with matplotlib:
- The relevant fixed/reference geometry (e.g. the real octagon wall) as
  context, in a muted color.
- The profile itself as a solid/filled shape in a clear accent color.
- Each real control point marked and numbered, matching the `.scad`
  variable names/numbering exactly.
- Axis labels in real project units (mm), aspect ratio locked equal
  (`ax.set_aspect('equal')`) so proportions read correctly.

### Fallback if Python/matplotlib is unavailable

Render the isolated 2D profile in OpenSCAD (`projection()` or a thin
`linear_extrude` viewed top-down per the camera formula above), then
mark points via small spheres/circles at each control-point coordinate,
colored distinctly (e.g. gold) so they're visible against the profile,
plus a SEPARATE plain-text list in the same message stating each
numbered point's real coordinates — the numbering must still match the
`.scad` code exactly even without inline text labels on the image
itself.

### Always cross-check against the real live file

Whichever technique is used, the control-point coordinates must come
from the ACTUAL project's live constants (read via `echo()` or by
importing/porting the real formulas), never from memory, a comment, or
a prior session's write-up — see `docs/hinge-construction.md` Section
4.5 for a real, caught instance of exactly this mistake costing a whole
extra round.

---

## ISOLATION-TEST DISCIPLINE (same as manifold triage)

If a joint/transition has failed QA once on real renders:
1. Local-render first: prototype the fix in the sandbox.
2. Only if local render confirms the fix visually: write the cc prompt.
3. Never write a cc fix prompt for a joint/seam/blend issue without
   first verifying it locally. This is how v17–v20 wasted 4 versions —
   the hull() orientation mismatch would have been caught immediately in
   local render.

---

## INDEPENDENT POST-FIX VERIFICATION (R-111 ESCALATION)

Origin: bbq-chambers "reads solid, not hollow" — 3 real fix attempts (PR
#119, v5's end-cap gap fix, PR #121) all failed the same human visual
check despite each one's own CGAL/manifold checks passing. Resolved only
once Claude Web stopped trusting cc_chat_log/PR text at face value and
independently re-rendered the ACTUAL merged file.

### SCOPE — THIS IS A VERIFICATION RULE, NOT A DESIGN RULE

This section governs ONLY read-only fact-checking: fetching a file that
already exists on `main` and rendering it to confirm or deny a claim
about it. It does NOT authorize Claude Web to prototype fixes, iterate
on construction methods, or do any other sandbox design/coding work by
default — that remains governed by the standing rule at the top of this
file (sandbox design use only when Janis explicitly asks, or cc is
genuinely stuck — and even then, ask before proceeding rather than
deciding unilaterally that a case qualifies).

The two are easy to tell apart: verification never produces a new
`.scad` construction or a new instruction for cc — it only produces a
render of something that already exists, and a true/false answer about
whether it matches what was claimed. If Claude Web is writing new
OpenSCAD logic in the sandbox, that's design work and needs Janis's
go-ahead first, independent of whether R-111 has triggered.

### THE GAP THIS CLOSES

A cc PR can be entirely honest and entirely wrong at the same time: real
CGAL checks, real probes, `Simple: yes` — and still miss the actual
defect, because manifold validity and visual correctness are different
properties. A closed hollow ring with a spurious flat panel inside it is
perfectly manifold. Three real, good-faith fix attempts in this project
passed every check they ran and still didn't fix what Janis was seeing,
because each one tested the wrong thing (color/opacity, then a different
end-cap module, then a different module again) without anyone rendering
the actual result and looking at it independently.

### THE RULE

Once R-111 triggers (2+ failed loops on the same human-reported symptom):

1. **Before proposing a fix:** don't just re-read the code and reason
   about it. Fetch the actual live file
   (`raw.githubusercontent.com/.../main/<path>`, already an allowed
   domain) and render it locally (this skill's existing Steps 1-4 above).
   Reproduce the symptom yourself, in a real render, before writing a
   diagnosis.
2. **After cc reports a fix:** the same independent check applies before
   telling Janis it's resolved. Fetch the newly merged file (not the
   prompt, not the PR description — the actual `.scad` file from `main`)
   and render it locally, at the same angle(s) that showed the original
   symptom. Only confirm resolution after seeing it fail to reproduce in
   an independent render Claude Web generated itself.
3. A clean cc_chat_log entry and passing CGAL checks are necessary but
   NOT sufficient to close an R-111 item. They confirm the geometry is
   valid. They do not confirm it looks like what the human is asking
   for. Only an independent render (or the human's own live check)
   confirms that.

### WHEN THIS APPLIES

Not every fix needs this — most single-loop fixes are fine with the
normal cc_chat_log review. This specifically applies once R-111 has
triggered, because that's the signal that the normal
report-check-trust loop has already failed at least twice, and
continuing to trust the same channel a third time without an
independent check is how it fails a third time.
