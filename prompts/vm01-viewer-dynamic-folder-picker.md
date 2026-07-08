# cc Prompt — Viewer: Dynamic Model-Folder File Picker (replace fixed
# stl/stlOpen/stlC2 keys with flexible, freely-named multi-file browsing)
# Date: 2026-07-09
# Session goal: wire VM-01's latest revision into the viewer AND rework
# the viewer's STL-loading system so future versions/views never require
# another cc prompt just to add a new render angle.

## 1. CC INTRO

git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → cc_chat_log.md (first 3 entries) →
knowledge.map → `.claude/SKILL_viewer_update.md` → the CURRENT committed
`VM-01-base-vXX.scad` on main → `viewer/janis-product-viewer.html`
(PROJECTS object + STL-loading logic only). State every file read and
the exact current VM-01 version number before writing a single line.

Also confirm and state explicitly: the Satu backend repo's actual GitHub
owner/name (needed for Task 1 below) — read it from wherever this repo
already references it (e.g. prior cc_chat_log entries mentioning "Satu
backend repo", or ask Janis directly if genuinely not findable in
source — do NOT guess a repo path).

Claude Web override: none.

## 2. CONTEXT

**Current limitation:** each project's viewer entry has exactly 3 fixed
STL slots (`stl`/`stlOpen`/`stlC2`), each requiring: cc edits the
PROJECTS object with the exact expected filename → Janis exports and
uploads an STL matching that exact filename → any NEW view (a 4th angle,
a different toggle combination) requires a whole new cc prompt just to
add a 4th key and wire a UI button for it. This has cost real cycles
every time Janis wanted one more view than the fixed 3 allowed.

**What Janis wants instead:** freedom to export as many STL renders as
she wants, name them however she wants (e.g. "full-assy", "open-top-
left", "door-open" — her own descriptive names, not a fixed cc-defined
set), drop them into a models subfolder, and have the viewer simply show
her a list of whatever's actually in that folder — no cc prompt required
to add, remove, or rename a view. Pick any file present, click, view it.

**Proposed mechanism (implement, verify feasibility as you go — flag
immediately if any part doesn't work as described, do not silently
force a broken approach):**

1. Move from per-project flat STL keys to a **per-project folder**:
   `public/models/<PROJECT-ID>/` (e.g. `public/models/VM-01/`) containing
   any number of freely-named `.stl` files.
2. At runtime, the viewer calls the **GitHub Contents API**
   (`https://api.github.com/repos/<owner>/<repo>/contents/public/models/<PROJECT-ID>`
   on the Satu backend repo) to get a LIVE listing of whatever files
   currently exist in that folder — this is what makes "just drop a file
   in the folder" work with zero code change: the listing is fetched
   fresh every time, not hardcoded.
3. For actually LOADING a selected STL's geometry, use the existing
   deployed URL pattern (`https://api.janishammer.com/models/<PROJECT-ID>/<filename>`)
   — NOT GitHub's raw content URL — so large STL transfers keep using the
   already-working Cloudflare-served path, not GitHub directly. The
   GitHub API call is ONLY for discovering what filenames exist, never
   for the actual mesh data.
4. UI: replace the current 2-3-way cycle button with a simple list/
   dropdown of whatever files the GitHub API listing returned, each
   entry labeled from its filename (strip `.stl`, replace `-`/`_` with
   spaces, capitalize — simple prettification, not a manifest Janis has
   to maintain). Clicking an entry loads that file.
5. **Backward compatibility, do not break existing projects**: if a
   project has NO `modelsFolder` key configured, fall back to the
   existing `stl`/`stlOpen`/`stlC2` behavior exactly as it works today —
   VM-01 and PR-01's CURRENT working URLs must keep working even as
   VM-01 (this session) moves to the new folder system.
6. **Error handling, required, not optional**: if the GitHub API call
   fails (rate limit — unauthenticated requests are capped at 60/hour
   per IP, folder doesn't exist yet, network error), show a clear
   message in the UI rather than a silent blank viewer — state exactly
   what error-handling was implemented in cc_chat_log.

## 3. NEW FILES

None in the Janis repo beyond what's already planned. Note for Janis
(state clearly in cc_chat_log, this is NOT something cc does): she will
need to CREATE the `public/models/VM-01/` folder in the Satu backend
repo (GitHub allows creating a folder by uploading a file into a new
path) and move/upload her VM-01 STL exports there going forward, instead
of directly into the flat `public/models/` folder.

## 4. TASKS

### TASK 1 — Add dynamic folder-listing capability to the viewer

Implement the GitHub Contents API fetch described in CONTEXT above as a
reusable function (e.g. `fetchModelFolder(projectId)`), returning an
array of `{filename, label, url}` for whatever `.stl` files are present.
State the exact confirmed Satu backend repo owner/name used, and confirm
via a live test call (or clearly state if a live test wasn't possible
this session and flag it for Janis to verify after deploy) that the API
call actually returns results for at least one existing folder.

### TASK 2 — Add `modelsFolder` config + wire VM-01 to the new system

Add a `modelsFolder: 'VM-01'` key to VM-01's PROJECTS entry (alongside,
not replacing, its existing `stl`/`stlOpen`/`stlC2` keys — keep those as
the fallback per CONTEXT point 5). Update VM-01's `version`/`status`
fields to the current confirmed version number from CC INTRO's read.
Do NOT touch PR-01's entry this session — VM-01 only.

### TASK 3 — Replace the fixed cycle button with a dynamic file list/dropdown

When a project has a `modelsFolder` key, the UI should call
`fetchModelFolder()` and render a list/dropdown of whatever comes back,
instead of the old fixed 2-3-way cycle button. When a project has no
`modelsFolder` key (e.g. PR-01, unchanged this session), the OLD cycle-
button behavior must still work exactly as before — confirm this
explicitly, do not regress PR-01.

### TASK 4 — Update `.claude/SKILL_viewer_update.md` for the new flow

Rewrite the "PROCEDURE — JANIS" section to reflect the new, much
simpler flow for any project using `modelsFolder`:
1. Export STL with any descriptive filename you want (recommend, don't
   force, a pattern like `<project>-vNN-<view-description>.stl` for a
   clean auto-generated label).
2. Upload it into `public/models/<PROJECT-ID>/` in the Satu backend repo
   (create the folder the first time).
3. Push. That's it — no cc prompt needed for a new view, no editing the
   viewer's PROJECTS object, no exact-filename coordination with cc.
Keep the OLD procedure documented too, clearly labeled as "LEGACY —
for projects without a modelsFolder (e.g. PR-01, until it's migrated)."
Bump this file's version per its own header convention.

## 5. DO NOT TOUCH

- Any `.scad` file
- PR-01's PROJECTS entry — unchanged this session, stays on the legacy
  fixed-key system
- `rules-dimensions.md`
- Existing `stl`/`stlOpen`/`stlC2` behavior for any project — must
  continue working identically as a fallback

## 6. QA VERIFICATION

- [ ] Satu backend repo owner/name confirmed from real source, not
      guessed — stated explicitly
- [ ] `fetchModelFolder()` implemented, tested (or flagged if untestable
      this session), returns `{filename, label, url}` array
- [ ] VM-01 PROJECTS entry has `modelsFolder: 'VM-01'` added, old keys
      kept as fallback, version/status updated to current confirmed
      version
- [ ] Dynamic file list/dropdown renders when `modelsFolder` is present
- [ ] Legacy cycle-button behavior confirmed UNCHANGED for projects
      without `modelsFolder` (PR-01 explicitly re-tested)
- [ ] Error handling for GitHub API failure (rate limit / missing
      folder / network error) implemented and described
- [ ] `.claude/SKILL_viewer_update.md` updated with the new simplified
      procedure, legacy procedure kept and clearly labeled
- [ ] knowledge.map updated if any new function/pattern warrants a note
- [ ] Zero `.scad` files touched — confirmed explicitly

## 7. MANDATORY CLOSING

1. Prepend `cc_chat_log.md` — newest entry at TOP, under 10 lines:
   confirm the new folder-listing mechanism works (or flag what needs
   Janis's post-deploy verification), confirm PR-01/legacy behavior
   unchanged, state the exact folder path Janis needs to create/use
2. Archive this prompt → `/prompts/archive/`
3. Update `knowledge.map`
4. Commit all → merge to main
