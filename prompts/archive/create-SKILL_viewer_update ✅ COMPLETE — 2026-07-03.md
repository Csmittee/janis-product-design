# create-SKILL_viewer_update.md
> Save this prompt to: /prompts/create-SKILL_viewer_update.md

## 1. CC INTRO
git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → cc_chat_log.md (first 3 entries) → knowledge.map →
WORKFLOW_SKILL.md → viewer/janis-product-viewer.html (PROJECTS object only)
State every file read before writing a single line.

## 2. CONTEXT
Viewer updates are infrequent enough that Janis has to re-derive the procedure
from scratch each time. This creates a skill file so saying "update the viewer,
new design released" is enough for Claude Web to act immediately, same pattern
as the existing manifold/joint-construction/customizer-profile skill files.

## 3. NEW FILES
- `.claude/SKILL_viewer_update.md`
Add to knowledge.map under a new `.claude/` row.

## 4. TASKS

### TASK 1 — Create `.claude/SKILL_viewer_update.md`

```
# SKILL_viewer_update.md
# Version: 1.0 — [date]

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

## FILENAME CONVENTION
Drop `base`/`assembly` from the source filename, keep the version number.
Example: `VM-01-base-v38.scad` → `VM-01-v38-full.stl` (+ `-std`/`-C2` for
multi-mode). `PR-01-assembly-v31.scad` → `PR-01-v31.stl`.
```

### TASK 2 — Add trigger row to WORKFLOW_SKILL.md

In the `## TRIGGER → ACTION → VALIDATOR` table, add one row:

| Trigger | Action | Validator |
|---|---|---|
| Janis says "update the viewer" / "new design released" | Read `.claude/SKILL_viewer_update.md`, follow its procedure before writing any cc prompt | Claude Web states which project/version this targets before drafting the prompt |

### TASK 3 — Update FILE STRUCTURE — REPO section

Add `.claude/SKILL_viewer_update.md` to the `.claude/` block, one line,
matching the existing style of the other SKILL_ entries.

Bump WORKFLOW_SKILL.md version per the DOCUMENT VERSIONING RULE at the
top of that file — this is a same-structure addition (X.Y → X.Y+1).

## 5. DO NOT TOUCH
- Any `.scad` file
- `viewer/janis-product-viewer.html` — read only, no PROJECTS changes in this prompt
- `rules-dimensions.md`
- Any other `.claude/` skill file

## 6. QA VERIFICATION
- [ ] `.claude/SKILL_viewer_update.md` created with all sections above
- [ ] WORKFLOW_SKILL.md trigger table has the new row, verbatim wording
- [ ] WORKFLOW_SKILL.md version bumped (X.Y → X.Y+1), changelog line added
- [ ] FILE STRUCTURE section lists the new file
- [ ] knowledge.map updated with the new file

## 7. MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. knowledge.map updated in TASK 1
4. Commit all → merge to main
