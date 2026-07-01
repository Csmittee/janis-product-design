# CC PROMPT — PR-01-base Multi-File Split + Option B Skill File Wiring
# Date: 2026-07-01
# Save to: /prompts/PR-01-multifile-split-v25.md

---

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order before touching anything. State every file read:
1. cc_rules.md
2. cc_chat_log.md (last 3 entries)
3. rules-dimensions.md
4. knowledge.map
5. pilates-reformer/PR-01-base/PR-01-base-v24.scad (current monolithic source)
6. .claude/SKILL_option_b_unified_loft.md (Janis pushed this 2026-07-01 — read in full,
   this prompt wires it into governance but does not act on its contents)
7. .claude/rules-codes.md (will be appended to in Task E)

This prompt has ONE structural task (file split + ghost-context preview
convention) and FOUR governance-wiring tasks. Complete ALL tasks. Do not
commit until all done.

---

## 2. CONTEXT

PR-01-base is about to grow: foldable base, poles, and gear teeth modules are
coming next (none started yet). The current single-file structure already
takes ~5 min to render with just the pole_top T-joint. If remaining parts are
added to the same file, every iteration loop (including future Option B seam
work) pays full-assembly render cost. This split must happen BEFORE any new
module is built, not after — that is the whole point of doing it now while
only one part exists.

This is a PURE FILE REORGANIZATION for the real geometry. No geometry,
dimension, or module logic change. pole_top_housing(), pole_top_neck(),
profile_pts(), and all other v24 module bodies move into a separate file
unchanged — same code, same parameters, same output.

**One addition beyond pure reorg**: when a module file is opened standalone
for fast isolated iteration (the whole point of this split), Janis loses
visual context of the parts it mates to — e.g. pole_top needs to show where
the horizontal pipe and vertical pole stub sit, even though those aren't
pole_top's own geometry. Without this, standalone renders float in empty
space and joint/fit decisions can't be judged visually. This split
establishes a ghost-context preview convention NOW, on the first module
file, so it's consistent when base/poles/gears are built next — not
retrofitted later across multiple files.

Separately: Option B (unified neck+collar loft, the T-junction seam fix) is
CONFIRMED as the eventual required architecture but is DEFERRED this session
in favor of completing the rest of the assembly for a customer review pass.
Its full technical spec now lives in .claude/SKILL_option_b_unified_loft.md.
This prompt's governance tasks (2-4 below) make sure that file is actually
read by future sessions — Claude Web and cc — rather than relying on chat
memory or CHAT_HANDOFF, which is single-use and gets overwritten.

---

## 3. NEW FILES

- pilates-reformer/PR-01-base/PR-01-assembly-v25.scad (new top-level includer —
  versioned, this is the file Janis opens in OpenSCAD for full-assembly F5/F6)
- pilates-reformer/PR-01-base/modules/pole_top.scad (new — moved content,
  NOT individually versioned — see Task A note on why)

Add both to knowledge.map.

---

## 4. TASKS

---

### TASK A — Split PR-01-base-v24.scad into assembly + modules structure

Create folder pilates-reformer/PR-01-base/modules/.

Move ALL module definitions currently in PR-01-base-v24.scad into
modules/pole_top.scad: pole_top_housing(), pole_top_neck(), profile_pts(),
and any other function/module currently in that file. Copy exactly —
zero logic changes, zero parameter changes, zero renamed variables.

Create pilates-reformer/PR-01-base/PR-01-assembly-v25.scad as the new
top-level file:
- `include <modules/pole_top.scad>`
- Global parameters (read from rules-dimensions.md, same as v24 — do not
  hardcode changed values)
- Assembly call(s) — same final geometry call as v24's bottom-of-file
  assembly section

**Versioning note (read before objecting to unversioned module file):**
modules/pole_top.scad is NOT given a version suffix. Rationale: it is an
organizational component, not a standalone deliverable Janis opens directly —
its history is tracked by git commit + the version number of whichever
assembly file includes it. Only PR-01-assembly-vXX.scad (the file Janis
actually opens for F5/F6) gets version-incremented going forward. This is a
deliberate exception to the "never overwrite, always version" rule, scoped
ONLY to files under modules/. Confirm you understand this exception in
cc_chat_log — do not silently apply it elsewhere without asking.

**Do NOT delete PR-01-base-v24.scad** — leave it in place as historical
record, same as all prior versions (v18-v23 etc. presumably still in repo).

Render PR-01-assembly-v25.scad locally if your environment allows, or at
minimum confirm brace/paren/bracket balance and no undefined-variable
references across the include boundary (module file must not reference
globals that aren't passed in or declared before the include).

**Ghost-context preview (add to modules/pole_top.scad):**

At top of file:
```scad
$is_assembly = is_undef($is_assembly) ? false : $is_assembly;
```

At bottom of file, after all module/function definitions:
```scad
if (!$is_assembly) {
    pole_top_body();  // or equivalent v24 assembly call for this module's real geometry
    color("gray", 0.3) cylinder(d=pole_od, h=200);
    color("gray", 0.3) translate([0,0,housing_z]) rotate([0,90,0]) cylinder(d=pipe_od, h=200);
}
```
Use the ACTUAL variable names and approximate mating positions from
rules-dimensions.md / v24 for pole_od, pipe_od, housing_z (or equivalent —
verify exact names from the source file, do not guess). These are simple
stand-in primitives (cylinder/box), NOT real geometry — they exist only to
show where the mating pipe and pole sit relative to pole_top, at 30% opacity
gray so they're visually distinct from the real part.

In PR-01-assembly-v25.scad, before any include:
```scad
$is_assembly = true;
include <modules/pole_top.scad>
```
This suppresses the ghost stand-ins in full-assembly view — assembly shows
only real parts, no duplicate/ghost geometry.

Verify: standalone render of modules/pole_top.scad shows real part + gray
ghost stubs. Full assembly render (PR-01-assembly-v25.scad) shows real part
ONLY, no gray ghosts, identical to v24 output.

---

### TASK B — Add trigger row to WORKFLOW_SKILL.md

In the `## TRIGGER → ACTION → VALIDATOR` table, add:

```
| pole_top seam/T-junction work resumes (Option B) | Read .claude/SKILL_option_b_unified_loft.md in full before any prompt — STATUS block must be updated first | Claude Web states file was read + confirms STATUS block matches current repo state |
```

Bump WORKFLOW_SKILL.md version (X.Y+1, same file, same rules as any other
detail change — see DOCUMENT VERSIONING RULE at top of that file). Update
its own changelog header line.

---

### TASK C — Add pointer in cc_rules.md

Add a line (find the appropriate "read when task requires" section matching
the pattern already used for other .claude/ files):

```
- .claude/SKILL_option_b_unified_loft.md — read in full BEFORE touching
  pole_top_body(), pole_top_housing(), pole_top_neck(), or any pole_top
  seam/joint geometry. Do not reconstruct Option B architecture from memory.
```

Bump cc_rules.md version per its own header convention.

---

### TASK D — Update knowledge.map

Add rows:
```
| pilates-reformer/PR-01-base/PR-01-assembly-v25.scad | pilates-reformer/PR-01-base/ | cc — top-level PR-01 assembly, versioned |
| pilates-reformer/PR-01-base/modules/pole_top.scad   | pilates-reformer/PR-01-base/modules/ | cc — NOT individually versioned, see Task A note |
| .claude/SKILL_option_b_unified_loft.md | .claude/ | Claude Web + cc — Option B unified loft spec. Read before pole_top seam work. Pushed by Janis 2026-07-01. |
```

Mark PR-01-base-v24.scad → Superseded (structure only — its geometry is
still the reference until Option B changes it). PR-01-assembly-v25 → ACTIVE.

Bump knowledge.map version and date.

---

### TASK E — Document ghost-context convention in .claude/rules-codes.md

Add a new section (do not remove/edit existing content — append):

```
## MULTI-FILE MODULE CONVENTION — GHOST-CONTEXT PREVIEW

Every module file under any /modules/ folder MUST follow this pattern,
established PR-01-multifile-split-v25 (2026-07-01):

1. Top of file: `$is_assembly = is_undef($is_assembly) ? false : $is_assembly;`
2. Bottom of file (after all module/function defs): if (!$is_assembly),
   call the module's own real geometry PLUS gray (30% opacity) simple
   primitive stand-ins for whatever mating parts this module joins to —
   sourced from rules-dimensions.md, positioned approximately correct,
   never the real geometry of the neighboring part.
3. Top-level assembly file sets `$is_assembly = true;` BEFORE any include,
   so full-assembly renders show only real parts, never ghost stand-ins.

Applies to every future module file: pole_mesh/gear_teeth (show pole
context), base_foldable (show pole + wood base context), pole_mid_clamp
(show pole context), etc. Do not skip this when creating new module files —
it is the reason isolated fast-render iteration remains usable as parts
increase.
```

Bump .claude/rules-codes.md version per its own header convention.

---

## 5. DO NOT TOUCH

- `rules-dimensions.md` — read only, never edit
- Any module logic, parameter values, or geometry in pole_top_housing(),
  pole_top_neck(), profile_pts() — copy exactly, zero changes
- `.claude/SKILL_option_b_unified_loft.md` — read only, do not edit contents
  (this task wires references TO it, does not modify it)
- `.claude/rules-codes.md` existing content — Task E is APPEND ONLY, do not
  edit or remove any existing rule in this file
- `chat_rules.md` — Claude Web only, cc never touches
- VM-01-base files — untouched, out of scope
- Do not begin any Option B geometry work — that is explicitly deferred

---

## 6. QA VERIFICATION

Before committing, confirm ALL:

- [ ] PR-01-assembly-v25.scad renders identical geometry to PR-01-base-v24.scad
      (same F5 visual result — this is a reorg, any visual difference is a bug)
- [ ] modules/pole_top.scad contains all moved modules, zero logic changes
- [ ] modules/pole_top.scad standalone render shows real part + gray (30%
      opacity) ghost stand-ins for mating pipe + pole, correctly positioned
- [ ] PR-01-assembly-v25.scad render shows NO gray ghost stand-ins (confirms
      $is_assembly=true correctly suppresses them)
- [ ] Brace/paren/bracket balance confirmed on both new files
- [ ] No undefined-variable warnings across the include boundary
- [ ] PR-01-base-v24.scad still exists in repo (not deleted)
- [ ] WORKFLOW_SKILL.md — new trigger row present, version bumped
- [ ] cc_rules.md — new pointer line present, version bumped
- [ ] .claude/rules-codes.md — new MULTI-FILE MODULE CONVENTION section
      present, version bumped
- [ ] knowledge.map — all rows present, version bumped
- [ ] cc_chat_log entry explicitly confirms understanding of the
      modules/-folder unversioned-file exception (Task A note)

---

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at TOP. Include:
   - Confirm split complete, geometry identical to v24 (or flag any diff)
   - Confirm ghost-context preview works (standalone shows ghosts, assembly
     suppresses them)
   - Confirm Tasks B, C, D, E done — name the exact files changed
   - FLAG: "Janis must re-upload WORKFLOW_SKILL.md to Project Knowledge —
     repo copy changed, PK copy now stale"
2. Archive this prompt → /prompts/archive/PR-01-multifile-split-v25 ✅ COMPLETE — 2026-07-01
3. Update knowledge.map (Task D — confirm done as part of main tasks, not
   duplicate work)
4. Bump version on every file changed (PR-01-assembly-v25.scad,
   WORKFLOW_SKILL.md, cc_rules.md, .claude/rules-codes.md, knowledge.map,
   cc_chat_log.md)
5. Commit all in correct order → merge to main

Confirm every file committed after merge, and restate the FLAG above so
Janis doesn't miss the Project Knowledge re-upload step.
