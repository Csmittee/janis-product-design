# viewer-turntable-measure-and-filename-rule.md
> Save this prompt to: /prompts/viewer-turntable-measure-and-filename-rule.md

## 1. CC INTRO
git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → cc_chat_log.md (first 3 entries) → knowledge.map →
.claude/SKILL_viewer_update.md → viewer/janis-product-viewer.html (full file)
State every file read before writing a single line.

## 2. CONTEXT
Three related additions to the viewer ecosystem, one session:
1. A real production incident (2026-07-03): renaming an STL in GitHub's web
   UI silently corrupted it to 2 bytes. Root cause was a filename-stripping
   convention that required a manual rename step. Fixing the convention
   removes the rename step entirely, going forward.
2. Turntable video recorder — self-contained in-browser 360° capture for
   social/marketing use, no external tools needed.
3. Point-to-point distance measurement — click two points on the loaded
   model, read the distance. First iteration only: single active
   measurement, no persistent list (that's a possible future task, not
   this one).

## 3. NEW FILES
None. Edits to `viewer/janis-product-viewer.html` and
`.claude/SKILL_viewer_update.md` only.

## 4. TASKS

### TASK 1 — Fix filename convention in `.claude/SKILL_viewer_update.md`

Replace the `## FILENAME CONVENTION` section with:

```
## FILENAME CONVENTION (v1.1 — 2026-07-03, supersedes v1.0's rule)
Going forward: output filename = source `.scad` filename VERBATIM, only
the extension changes (`.scad` → `.stl`), plus an optional `-modename`
suffix before the extension for multi-mode exports (e.g. `-std`, `-full`,
`-C2`). NEVER strip, abbreviate, or drop words from the source filename.
Example: `PR-01-assembly-v32.scad` → `PR-01-assembly-v32.stl`.

Reason: the old "drop base/assembly" rule required a manual rename step
after export. On 2026-07-03, renaming an already-uploaded STL through
GitHub's web UI silently replaced its binary content with 2 bytes —
the file looked correctly named but was empty. Naming the export
correctly at export/upload time, with zero rename step, removes the
failure mode entirely.

EXCEPTION — grandfathered, do not touch: VM-01's existing URLs
(`VM-01-v38-std.stl`, `VM-01-v38-full.stl`, `VM-01-v38-C2.stl`) and
PR-01's current `PR-01-v31.stl` predate this rule and are already
deployed/working. Do not rename or retrofit them. The new rule applies
to PR-01-v32 onward and any new project wired into the viewer after
2026-07-03.
```

Also add one line to `## PROCEDURE — JANIS`, step 2:

```
NEVER use GitHub's web "Rename" or "Edit" on an existing STL/binary
file — this can silently corrupt it (real incident, 2026-07-03: a
renamed file collapsed to 2 bytes with no visible error). Always
upload the real binary fresh via "Add file → Upload files", dragged
directly from local disk, with the correct final filename set at
upload time in one step.
```

Bump `.claude/SKILL_viewer_update.md` version 1.0 → 1.1 in its header,
changelog line describing this fix.

### TASK 2 — Turntable video recorder

Add a new action button in the left sidebar ACTIONS panel, alongside
Export STL / Screenshot / Print View: **[⏺ Record Turntable]**

Behavior on click:
- Disable the button (prevent double-trigger), show recording state
  (e.g. label changes to "⏺ Recording...").
- Temporarily take over camera rotation: rotate the model/camera a full
  360° around the vertical (Y) axis over a fixed duration (~8 seconds is
  a reasonable default — cc can tune). Pause OrbitControls user input
  during recording, restore it after.
- Use `renderer.domElement.captureStream(30)` (30fps) with `MediaRecorder`
  (`video/webm` mime type) to record exactly one full rotation.
- On completion: assemble the recorded chunks into a Blob, trigger a
  browser download named `{activeProject}-{version}-turntable.webm`
  (use the project's actual `label`/`version` fields, not hardcoded).
- Re-enable OrbitControls and the button afterward.
- Log entries consistent with existing log style: "Recording
  turntable...", then "✅ Turntable recorded: Xs — downloaded" (or an
  error entry if `captureStream`/`MediaRecorder` isn't supported in the
  browser — fail gracefully with a clear log message, don't crash).

### TASK 3 — Point-to-point distance measurement (first iteration, single measurement only)

Add a new toggle button in the left sidebar ACTIONS panel: **[📏 Measure]**

Behavior:
- Toggling ON enters "measure mode": next two clicks on the loaded model
  (raycaster against the current mesh) each drop a small marker (e.g. a
  tiny sphere) at the exact intersection point.
- After the second click: compute Euclidean distance between the two
  intersection points. STL units are mm (OpenSCAD default, confirm this
  assumption holds for both VM-01 and PR-01 exports — state confirmation
  in cc_chat_log). Display the result in the right sidebar or as a small
  overlay near the two points — cc's choice, keep it simple and legible
  against the dark theme, consistent with existing gold/dark styling.
- A **[Clear]** control removes the markers/line and resets state so a
  new measurement can be taken.
- Measure mode does not persist across project switches — reset on
  `switchProject()`.
- Explicitly out of scope this pass: multiple simultaneous measurements,
  a saved measurement list, or exporting measurements — single active
  measurement only. Note this scope boundary in cc_chat_log so it reads
  as a deliberate first iteration, not an oversight.

## 5. DO NOT TOUCH
- Any `.scad` file
- VM-01's or PR-01's existing STL URLs, filenames, or PROJECTS values
- `rules-dimensions.md`
- Any other `.claude/` skill file besides `SKILL_viewer_update.md`

## 6. QA VERIFICATION
- [ ] `.claude/SKILL_viewer_update.md` FILENAME CONVENTION section replaced
      exactly as specified, version bumped to 1.1
- [ ] VM-01 and current PR-01 STL URLs/filenames confirmed untouched (diff)
- [ ] Turntable button records exactly one full rotation, downloads a
      named `.webm`, restores OrbitControls after, fails gracefully (with
      a log message) if the browser doesn't support `captureStream`
- [ ] Measure mode: two clicks produce a correct mm distance reading,
      Clear resets cleanly, mode resets on project switch
- [ ] STL unit assumption (mm) explicitly confirmed in cc_chat_log
- [ ] No changes to any PROJECTS registry values — this prompt only adds
      UI/interaction features, confirm explicitly

## 7. MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP, under 10 lines
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Update knowledge.map if applicable (viewer version bump)
4. Bump version on viewer/janis-product-viewer.html and
   .claude/SKILL_viewer_update.md
5. Commit all → merge to main

## JANIS ACTION REQUIRED AFTER cc COMMITS
1. Copy updated `viewer/janis-product-viewer.html` → Satu backend
   `public/janis-product-viewer.html` (drop `viewer/` prefix), push.
2. Test Record Turntable and Measure on both VM-01 and PR-01 in the live
   viewer, confirm both work before considering this done.
