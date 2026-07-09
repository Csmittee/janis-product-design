# SKILL_viewer_update.md
# Viewer Update Procedure — Janis Product Design
# Version: 1.2 — 2026-07-09
# Changes: Added the dynamic modelsFolder system (vm01-viewer-dynamic-
# folder-picker) — a project with a `modelsFolder` key no longer needs a
# cc prompt to add/remove/rename a view; Janis just uploads a freely-named
# .stl into public/models/<PROJECT-ID>/ and the viewer discovers it live
# via the GitHub Contents API. PROCEDURE — JANIS split into NEW (for
# modelsFolder projects) and LEGACY (fixed stl/stlOpen/stlC2 keys, kept
# for projects not yet migrated, e.g. PR-01). QUICK REFERENCE updated
# with the modelsFolder key. Old procedure fully preserved, not deleted.
# Previous: 1.1 — 2026-07-03
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
   (b) version bump on an already-wired project, or (c) migrating a
   project from the legacy fixed-key system to `modelsFolder` (a one-time
   change per project — see NEW FILES note below).
3. Write a standard 7-section cc prompt (WORKFLOW_SKILL.md template).
   TASK 1 is always: update that project's entry in the `PROJECTS`
   object in viewer/janis-product-viewer.html — `label`, `version`,
   `status`, `params[]`, `toggles[]`, `components[]`, and either:
   - **modelsFolder projects**: confirm the `modelsFolder` key is present
     and correct (normally just `'PROJECT-ID'`, matching the GitHub
     folder name) — no exact filename to track, cc does not need to know
     what STL Janis will eventually export.
   - **legacy projects**: the STL key(s) (`stl` / `stlOpen` / `stlC2`),
     every value read live from the actual .scad file(s), never copied
     from another project or guessed.
4. For legacy projects only: require cc to state, verbatim in
   cc_chat_log: (a) the exact property key name(s) it added/changed
   (`stl` vs `stlOpen` vs `stlC2`), and (b) the exact filename expected
   at that URL. modelsFolder projects skip this — there's no fixed
   filename to coordinate.
5. Push prompt to /prompts/, Janis hands to cc, cc commits.

## PROCEDURE — JANIS (after cc commits) — NEW: for projects with `modelsFolder`

This is the simplified flow. No cc prompt needed for a new view, no
editing the viewer's PROJECTS object, no exact-filename coordination.

1. Open the relevant .scad in OpenSCAD → F6 full render (correct
   render_mode variable first, if the project uses one).
2. Export STL with ANY descriptive filename you want. Recommended (not
   forced) pattern for a clean auto-generated label:
   `<project>-vNN-<view-description>.stl` — e.g.
   `VM-01-v58-door-open.stl` becomes the label "VM 01 V58 Door Open" in
   the viewer's dropdown automatically (strip `.stl`, `-`/`_` → spaces,
   capitalize — simple prettification, not a manifest you maintain).
3. Upload it into `public/models/<PROJECT-ID>/` in the Satu backend repo
   (`Csmittee/Satu-vending-backend`) — create the folder the first time
   via GitHub's "Add file → Upload files" into that new path.
   NEVER use GitHub's web "Rename" or "Edit" on an existing STL/binary
   file — this can silently corrupt it (real incident, 2026-07-03: a
   renamed file collapsed to 2 bytes with no visible error). Always
   upload the real binary fresh, dragged directly from local disk, with
   the correct final filename set at upload time in one step.
4. Push. The viewer's dropdown for that project now lists every .stl
   present in that folder, live, on next load — add, remove, or rename a
   file in the folder at any time, no code change, no cc prompt.
5. Confirm in the live viewer that the project loads and the new view
   appears in the dropdown.

Note: the viewer's GitHub Contents API call is unauthenticated, capped
at 60 requests/hour per IP (GitHub's own limit) — if the dropdown shows
a rate-limit error, wait and reload; this does not affect the actual STL
transfer (that always goes through the already-working Cloudflare-served
`api.janishammer.com` path, never GitHub directly).

## PROCEDURE — JANIS (after cc commits) — LEGACY: for projects WITHOUT `modelsFolder`

Applies to any project not yet migrated to the dynamic system (e.g.
PR-01, as of 2026-07-09).

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
4. Copy the STL(s) → Satu backend repo `public/models/` (flat — legacy
   projects use this shared folder directly, not a per-project subfolder).
5. Push Satu backend repo → Cloudflare auto-deploys, no other steps.
6. Confirm in the live viewer that the project loads and shows the
   correct model.

## QUICK REFERENCE — PROJECTS object shape

```javascript
'PROJECT-ID': {
  label: 'Display Name',
  version: 'vNN',
  status: 'text shown next to version',
  modelsFolder: 'PROJECT-ID',   // NEW — presence of this key switches the
                                 // whole project to the dynamic picker;
                                 // omit entirely for legacy fixed-key mode
  params: [ { id, label, value, min, max, step, locked } ],
  toggles: [ { id, label, default } ],
  components: [ { id, label, default, match } ],
  stl:     'https://api.janishammer.com/models/FILENAME.stl',   // legacy fallback / cycle option — kept even on modelsFolder projects during migration
  stlOpen: 'https://api.janishammer.com/models/FILENAME.stl',   // legacy — loaded first if present AND no modelsFolder
  stlC2:   'https://api.janishammer.com/models/FILENAME.stl',   // legacy — optional 3rd cycle mode
  scad: null   // null = STL-mode project, no in-browser WASM render
}
```
`switchProject()` checks `modelsFolder` FIRST (dynamic picker owns its
own loading) → `stlOpen` → `stl` → `scad`+autoRender → placeholder, in
that order. A project with `modelsFolder` never falls through to the
legacy stl/stlOpen/stlC2 auto-load, even if those keys are also present
(kept only as the manual "Reload" button's own fallback if
`currentSTLUrl` is somehow unset). A project with no `modelsFolder` AND
no `stl`/`stlOpen` key always falls to the placeholder even if `scad` is
non-null but autoRender conditions aren't met.

## FILENAME CONVENTION (v1.1 — 2026-07-03, supersedes v1.0's rule) — LEGACY PROJECTS ONLY

modelsFolder projects have NO filename convention to follow — any
descriptive name works, see the NEW procedure above. This section
applies only to legacy fixed-key projects (e.g. PR-01).

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

EXCEPTION — grandfathered, do not touch: VM-01's original v38 URLs
(`VM-01-v38-std.stl`, `VM-01-v38-full.stl`, `VM-01-v38-C2.stl`) and
PR-01's current `PR-01-v31.stl` predate this rule and are already
deployed/working — kept as VM-01's own legacy fallback (see QUICK
REFERENCE above) even after its 2026-07-09 migration to `modelsFolder`.
