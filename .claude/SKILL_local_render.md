# SKILL_local_render.md
# Local OpenSCAD Render Verification — Janis Product Design
# Version: 1.1 — 2026-07-16
# Changes: SKILL_local_render_addendum_independent_verification. New
# "INDEPENDENT POST-FIX VERIFICATION (R-111 ESCALATION)" section added —
# origin: bbq-chambers "reads solid, not hollow" took 3 real fix attempts
# (PR #119, v5's end-cap gap fix, PR #121) that each passed their own
# CGAL/manifold checks but still failed the same human visual check,
# resolved only once the ACTUAL merged file was independently re-rendered
# rather than trusted from cc_chat_log/PR text. Extends this skill's
# existing pre-fix render discipline (Steps 1-5 above) with a matching
# post-fix discipline, scoped specifically to R-111 (2+ failed loops on
# the same symptom) — this is a read-only VERIFICATION rule, not a new
# design-work authorization (see that section's own SCOPE note). Detail
# addition, not a restructure of the existing content — X.Y bump.
# Previous: 1.0 — 2026-07-01
# Location: .claude/SKILL_local_render.md
# Read when: any geometry design or fix session is starting, or any time
# a new module shape is being designed before sending to cc. Also read
# when R-111 has triggered (2+ failed loops on the same human-reported
# symptom) — see the new section below.

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
