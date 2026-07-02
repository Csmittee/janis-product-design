# PR-01-viewer-integration.md
# Prompt for cc — Wire PR-01 into janis-product-viewer.html
# Written by: Claude Web
# Date: 2026-07-03
# Save to: /prompts/PR-01-viewer-integration.md

---

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order before touching anything. State every file read:
1. cc_rules.md
2. cc_chat_log.md (first 3 entries — newest at top)
3. knowledge.map
4. CURRENT_STATE.md
5. viewer/janis-product-viewer.html (full file, not just the VM-01 PROJECTS block)
6. pilates-reformer/PR-01-base/PR-01-assembly-v31.scad
7. pole_top.scad
8. leg_socket.scad
9. rules-dimensions.md (PR-01 section) / rules-pr.md if it exists

---

## 2. CONTEXT

PR-01 (Pilates Reformer) currently shows only a placeholder in the
viewer's project dropdown. PR-01-assembly-v31.scad (base-file-consolidation,
PR #74, geometry-identical to v30 via CSG-dump checksum) has never been
wired into the viewer. VM-01's viewer entry loads pre-exported STL files
from the Satu backend (api.janishammer.com/models/) — NOT the OpenSCAD
WASM path, which prior sessions found unreliable via CDN. This prompt wires
PR-01 into the viewer using that same STL-loading pattern, populated with
PR-01's actual current parameters and components — read from the live
files, not copied from VM-01 or guessed.

Constraint: this sandbox has no OpenSCAD binary (confirmed in multiple
past sessions — code-review/arithmetic verification only). cc cannot
generate the STL itself. Janis must export it from local OpenSCAD and
push it to the Satu backend at the exact filename cc specifies below.

---

## 3. NEW FILES

None. `viewer/janis-product-viewer.html` is edited in place.
If PR-01 dimensions exist that aren't yet captured in rules-dimensions.md
or a rules-pr.md, do NOT create a new rules file here — flag it in
cc_chat_log instead, that's a separate governance task.

---

## 4. TASKS

### TASK 1 — Add a PR-01 entry to the `PROJECTS` registry

Mirror the exact object shape already used for the VM-01 entry — read the
live VM-01 object first, do not assume its shape from memory.

- `label`: `"PR-01 Pilates Reformer"`
- `version`: the actual active filename, stated verbatim (expected
  `PR-01-assembly-v31`, confirm against the real file)
- `status`: pulled verbatim from CURRENT_STATE.md's PR-01 entry —
  "PAUSED, awaiting customer" plus a short note that the socket-not-cut-
  into-wood item is open/undecided. Do not invent different wording.
- `params[]`: every parametric value actually declared in
  PR-01-assembly-v31.scad + its two includes (pole_top.scad,
  leg_socket.scad) — bed_l, bed_w, bed_h, pole diameter, leg/socket
  dimensions, etc. Use real current values. If no explicit min/max exists
  elsewhere, use a sensible range around the real value and flag each
  guessed range explicitly in cc_chat_log. Cross-check rules-dimensions.md
  for any OWNER-LOCKED value (e.g. spring_gap is locked for VM-01 — check
  if PR-01 has an equivalent) and set `locked: true` to match.
- `components[]`: real module names actually called from the PR-01
  assembly (e.g. bed_frame, pole_body, bell_lock_collar, leg_socket,
  crossbar — confirm exact names from the files, do not guess), same
  pattern as VM-01's visibility-toggle component list.
- `stl`: single URL `https://api.janishammer.com/models/PR-01-v31.stl`
  — PR-01 currently has no multi-mode toggle equivalent to VM-01's
  std/full/C2. Confirm this by checking for any `show_*` render-mode
  toggle in the assembly file. If one exists, build a multi-mode stl
  object instead (mirroring VM-01's pattern) and state that explicitly
  in cc_chat_log instead of using a single URL.
  **The live PR-01 object currently has no `stl`/`stlOpen` key at all —
  this task ADDS one, it doesn't rename one. `switchProject()` checks
  `proj.stlOpen` first, falling back to `proj.stl`. Use the exact
  property name(s) it already checks for — state the literal key name(s)
  used, verbatim, in cc_chat_log so Janis can confirm the filename before
  exporting/uploading.**

### TASK 2 — Confirm the viewer's project-switch logic is generic

Check `switchProject()` / `loadSTL()` / param-slider rendering for any
VM-01-specific hardcoding (default project on load, assumptions about
param count/names, etc.). If found, generalize it so a new PROJECTS entry
needs no code changes beyond the registry object. State explicitly what,
if anything, was hardcoded and fixed.

### TASK 3 — Update `knowledge.map` VIEWER section

Add PR-01's STL file(s) to the existing STL table, same row format as the
VM-01 entries (filename | description).

---

## 5. DO NOT TOUCH

- Any `.scad` file — read-only in this prompt, zero geometry change
- VM-01's existing PROJECTS entry, STL URLs, or param values
- `rules-dimensions.md` — read only
- Any `prompts/` file not created by this prompt

---

## 6. QA VERIFICATION

- [ ] PR-01 entry added to `PROJECTS`, every value read from the live
      PR-01-assembly-v31.scad + includes — not copied from VM-01, not
      guessed (confirm explicitly in cc_chat_log)
- [ ] Each param's `locked` status checked against rules-dimensions.md
      OWNER-LOCKED list — state which, if any, are locked
- [ ] `components[]` matches actual module names called in the PR-01
      assembly (list them in cc_chat_log)
- [ ] `stl` URL(s) stated exactly, including single- vs multi-mode and why
- [ ] Literal property key name(s) added (`stl` and/or `stlOpen`) stated
      verbatim in cc_chat_log, along with the exact filename expected at
      that URL
- [ ] Confirm no VM-01 values or behavior altered
- [ ] Selecting PR-01 in the dropdown no longer shows placeholder text and
      attempts `loadSTL()` from the stated URL — a 404 is EXPECTED until
      Janis uploads the file, state this explicitly, not a bug
- [ ] `knowledge.map` VIEWER section updated with PR-01 row(s)

---

## 7. MANDATORY CLOSING

1. Prepend `cc_chat_log.md` — newest entry at TOP, under 10 lines
2. Archive this prompt → `/prompts/archive/PR-01-viewer-integration ✅ COMPLETE — [date]`
3. `knowledge.map` updated in TASK 3
4. Bump version on `viewer/janis-product-viewer.html` and `knowledge.map`
5. Commit all → merge to main

---

## JANIS ACTION REQUIRED AFTER cc COMMITS

1. Open `PR-01-assembly-v31.scad` in local OpenSCAD → F6 full render
2. Export STL → save as the exact filename cc confirms in cc_chat_log
   (expected `PR-01-v31.stl` — verify against the actual entry, not this
   prompt, since cc may have found a multi-mode toggle and changed the plan)
3. Push that STL to the Satu backend `public/models/`
4. Confirm Cloudflare picked it up, then test the PR-01 selection in the
   live viewer
