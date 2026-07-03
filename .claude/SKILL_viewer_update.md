# SKILL_viewer_update.md
# Viewer Update Procedure — Janis Product Design
# Version: 1.1 — 2026-07-03
# Changes: FILENAME CONVENTION rewritten (verbatim filename, no strip/rename step — 2026-07-03 STL-corruption incident) + a NEVER-rename-via-GitHub-web-UI line added to PROCEDURE — JANIS step 2.
# Location: .claude/SKILL_viewer_update.md
# Claude Web only — cc does NOT read this file.

## TRIGGER PHRASES
"Update the viewer", "new design released, update the viewer",
"add [project] to the viewer", "viewer needs the new version" — any
variant where Janis wants the live 3D viewer to reflect a new/changed
.scad version. Manual trigger only — Claude Web never does this
unprompted.

## PROCEDURE — CLAUDE WEB

1. Confirm which project + which version is now ACTIVE. Check
   knowledge.map first; if ambiguous, ask Janis — never assume.
2. Determine scope: (a) first-time wiring of a placeholder project entry,
   or (b) version bump on an already-wired project.
3. Write a standard 7-section cc prompt (WORKFLOW_SKILL.md template).
   TASK 1 is always: update that project's entry in the `PROJECTS`
   object in viewer/janis-product-viewer.html — `label`, `version`,
   `status`, `params[]`, `toggles[]`, `components[]`, and the STL
   key(s) (`stl` / `stlOpen` / `stlC2`) — every value read live from
   the actual .scad file(s), never copied from another project or
   guessed.
4. Require cc to state, verbatim in cc_chat_log: (a) the exact
   property key name(s) it added/changed (`stl` vs `stlOpen` vs
   `stlC2`), and (b) the exact filename expected at that URL.
5. Push prompt to /prompts/, Janis hands to cc, cc commits.

## PROCEDURE — JANIS (after cc commits)

1. Open the relevant .scad in OpenSCAD → F6 full render (correct
   render_mode variable first, if the project uses one — check
   cc_chat_log for which modes/filenames apply).
2. Export STL → filename EXACTLY matching what cc stated in
   cc_chat_log. Mismatched filenames are the #1 cause of "nothing
   shows up."
   NEVER use GitHub's web "Rename" or "Edit" on an existing STL/binary
   file — this can silently corrupt it (real incident, 2026-07-03: a
   renamed file collapsed to 2 bytes with no visible error). Always
   upload the real binary fresh via "Add file → Upload files", dragged
   directly from local disk, with the correct final filename set at
   upload time in one step.
3. Copy `viewer/janis-product-viewer.html` → Satu backend repo as
   `public/janis-product-viewer.html` (drop the `viewer/` prefix,
   keep the filename) — only needed if the HTML itself changed.
4. Copy the STL(s) → Satu backend repo `public/models/`.
5. Push Satu backend repo → Cloudflare auto-deploys, no other steps.
6. Confirm in the live viewer that the project loads and shows the
   correct model.

## QUICK REFERENCE — PROJECTS object shape

```javascript
'PROJECT-ID': {
  label: 'Display Name',
  version: 'vNN',
  status: 'text shown next to version',
  params: [ { id, label, value, min, max, step, locked } ],
  toggles: [ { id, label, default } ],
  components: [ { id, label, default, match } ],
  stl:     'https://api.janishammer.com/models/FILENAME.stl',   // fallback / cycle option
  stlOpen: 'https://api.janishammer.com/models/FILENAME.stl',   // loaded first if present
  stlC2:   'https://api.janishammer.com/models/FILENAME.stl',   // optional 3rd cycle mode
  scad: null   // null = STL-mode project, no in-browser WASM render
}
```
`switchProject()` checks `stlOpen` → `stl` → `scad`+autoRender → placeholder,
in that order. A project with no `stl`/`stlOpen` key always falls to the
placeholder even if `scad` is non-null but autoRender conditions aren't met.

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
