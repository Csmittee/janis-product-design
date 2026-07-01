## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order, state every file read before writing a single line:
1. cc_rules.md
2. knowledge.map
3. cc_chat_log.md (first 3 entries — newest at top)
4. .claude/rules-codes.md
5. pilates-reformer/PR-01-base/PR-01-assembly-v26.scad
6. pilates-reformer/PR-01-base/pole_top.scad

## 2. CONTEXT

Two issues found and CONFIRMED by Claude Web via direct local OpenSCAD
render (real committed v26 files, not simulated) during Janis's manifold
isolation testing session:

**Issue 1 — ghost-context leak into full assembly (blocking).** Janis set
`show_pole_tops = false; show_pole_bodies = false; show_base_collars =
false;` and re-rendered — one pole (front-left, pole_cx[0]/pole_cy[0])
stayed visible regardless. Root cause: `pole_top.scad` line 25 —
`$is_assembly = is_undef($is_assembly) ? false : $is_assembly;` — was
meant to only supply a default when the file is opened standalone, but
OpenSCAD does not correctly evaluate a self-referential `is_undef()` guard
when the same variable name was already assigned earlier in the same
flattened scope (proven true for BOTH `$`-prefixed and plain variable
names, confirmed via direct render test — this is a general OpenSCAD
behavior, not specific to special variables). Effect: the reassignment
always wins, `$is_assembly` evaluates `false` even after the assembly file
correctly set it `true`, so the standalone-preview ghost stanza
(`pole_top()` + gray ghost `pole_body()` stand-in for pole index 0 only)
renders unconditionally in every full-assembly render, completely outside
the control of any `show_*` flag. This is corrupting Janis's isolation
test results (every render has this uncontrolled extra geometry regardless
of toggle state) and may itself be contributing to the reported 2-manifold
warning (real geometry + rough placeholder primitive as union siblings is
a known manifold-warning pattern in this project).

Fix validated by Claude Web: replace the redeclare with a function that
only ever READS `$is_assembly`, never reassigns it. Confirmed via direct
render of the real files: ghost stanza correctly suppressed in assembly
mode after this change, zero new warnings introduced (warning count on
this file's checks drops from 24 to 23 — the `$is_assembly` "was
assigned...but overwritten" warning is gone; the other 23 are the
untouched, separately-tracked Issue 2 below, not part of this fix).

**Issue 2 — toggle-block location (usability, non-blocking).** The
`show_bed` / `show_pole_tops` / `show_pole_bodies` / `show_base_collars` /
`show_wood_sockets` / `show_crossbars` flags exist and work, but are
declared in the PARAMETERS block (~line 103 of the assembly file) rather
than near the bottom by the render call. Janis's own established working
pattern (her local `Iflex_full_tower_reformmer.scad` scratch file) keeps
these at the bottom, immediately visible, for fast visual on/off testing.
Relocating for discoverability — zero logic change.

**NOT in scope for this prompt** (see DO NOT TOUCH): the ~23 remaining
"assigned...but overwritten" warnings. Claude Web confirmed via controlled
test that these are NOT merely cosmetic — every global `pole_top.scad`
re-declares a standalone-safe default for (`pole_d`, `bed_l`, `bed_h`,
`grip_od`, `xbar_z`, all `housing_*`, `pole_cx`, `pole_cy`, etc.) is
CURRENTLY being silently overridden by pole_top.scad's hardcoded fallback
value when included from the assembly, not by the assembly's real
declared value — it only looks correct today because the fallback numbers
happen to numerically match today's design values. This is a real latent
defect (especially risky given `grip_od` is OWNER-LOCKED and `bed_l`/
`bed_h` are marked "PENDING Janis confirm" in the assembly file's own
comments) but fixing it correctly requires rewriting how every module in
pole_top.scad resolves these globals (per-module local-variable
resolution, since OpenSCAD has no reliable "set global only if not already
set" mechanism when the same name may be declared in two places in one
flattened scope) — too large and too risky to fold into this prompt
blind. Tracked as its own open item for a dedicated future prompt.

## 3. NEW FILES

- `pilates-reformer/PR-01-base/PR-01-assembly-v27.scad` (new — content
  identical to v26 except the toggle-block relocation per Task 2; v26's
  `pole_top.scad` fix per Task 1 is an in-place edit, not a new file, per
  the established modules-file unversioned exception)

Add to knowledge.map, mark v26 → Superseded.

## 4. TASKS

### TASK 1 — Fix `$is_assembly` ghost-leak (in-place edit to `pole_top.scad`)

In `pilates-reformer/PR-01-base/pole_top.scad`, replace line 25:
```scad
$is_assembly = is_undef($is_assembly) ? false : $is_assembly;
```
with:
```scad
function ghost_mode() = is_undef($is_assembly) || !$is_assembly;
```

Then find every remaining usage of `!$is_assembly` as a condition in this
file (there are two: the standalone-defaults guard block near the top, and
the ghost-context preview stanza near the bottom) and replace each with
`ghost_mode()`. Do not change anything else in either conditional block —
this is a condition-expression swap only, zero geometry change.

Verify (state actual result in cc_chat_log, do not just assert):
- Standalone open of `pole_top.scad` still shows real part + gray ghost
  stand-ins (ghost_mode() correctly evaluates true when `$is_assembly` is
  genuinely undefined)
- Full-assembly open shows NO ghost stand-ins for any pole, including pole
  index 0 (ghost_mode() correctly evaluates false when assembly set
  `$is_assembly = true` before the include)

### TASK 2 — Relocate toggle block (new file `PR-01-assembly-v27.scad`)

Copy `PR-01-assembly-v26.scad` to `PR-01-assembly-v27.scad`. Move the 6
`show_*` boolean declarations (currently ~line 103–108, in the PARAMETERS
block) to a new clearly-labeled section immediately before the final
`pr01_assembly();` render call at the bottom of the file — e.g.:
```scad
// ── Debug toggles — flip to false to hide for visual inspection ────────
show_bed           = true;
show_pole_tops      = true;
show_pole_bodies    = true;
show_base_collars   = true;
show_wood_sockets   = true;
show_crossbars      = true;

// ── RENDER — full assembly ──────────────────────────────────────────
pr01_assembly();
```
Copy-paste relocation only — same 6 names, same default values (`true`),
no other content change anywhere else in the file. Update the version
header comment to note v27 = ghost-leak fix (via v26.5-equivalent
pole_top.scad edit) + toggle-block relocation, zero geometry change from
v26.

### TASK 3 — Codify toggle-block-at-bottom as standing convention

In `.claude/rules-codes.md`, under the existing "Rule M-4 — Debug Toggle
Rule" section, add (do not remove existing content):
```
Debug toggle block MUST be located immediately before the final assembly
render call at the bottom of the file — never buried in the PARAMETERS
block. This applies to every current and future assembly file (PR-01,
foldable base, and any module requiring show_* flags for visual isolation
inspection) from Day 1 of that file's creation.
```
Bump `.claude/rules-codes.md` version per its own header convention.

## 5. DO NOT TOUCH

- The ~23 remaining "assigned...but overwritten" warnings for `pole_d`,
  `bed_l`, `bed_h`, `grip_od`, `xbar_z`, `pole_cx`, `pole_cy`, all
  `housing_*`, `neck_*`, `top_bore_d`, `e` — confirmed real but separately
  tracked, not in scope here. Do not attempt to fix as part of this prompt.
- `rules-dimensions.md` — read only
- Any module logic, parameter VALUES, or geometry in `pole_top()`,
  `pole_body()`, `housing_*`, `profile_pts()` — this is a condition-
  expression fix + file reorg only, zero geometry change
- `PR-01-assembly-v26.scad`, `PR-01-base-v24.scad` — untouched, historical
- `chat_rules.md` — Claude Web only
- VM-01-base files — out of scope
- Option B unified loft — still deferred, do not touch pole_top seam work

## 6. QA VERIFICATION

Before committing, confirm ALL:

- [ ] `pole_top.scad` line 25 replaced with `ghost_mode()` function,
      both `!$is_assembly` usages replaced with `ghost_mode()`
- [ ] No other lines in `pole_top.scad` changed
- [ ] `PR-01-assembly-v27.scad` created, toggle block relocated to bottom,
      all 6 flags present with same names/defaults, diffed against v26 to
      confirm ONLY the toggle-block location changed
- [ ] `.claude/rules-codes.md` Rule M-4 amended with the location
      requirement, version bumped
- [ ] `knowledge.map` updated: v26 → Superseded, v27 → ACTIVE
- [ ] State in cc_chat_log: confirm zero geometry/dimension change

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at TOP. Include:
   - Confirm ghost-leak root cause + fix, state the verification result
     (standalone still shows ghosts, assembly shows none, including pole 0)
   - Confirm toggle-block relocated, zero logic change
   - Confirm the ~23 remaining warnings are explicitly OUT of scope here —
     do not let this get silently marked "fixed", it is a separate open item
2. Archive this prompt → /prompts/archive/PR-01-fix-ghost-leak-toggle-relocate-v27 ✅ COMPLETE — 2026-07-02
3. Update knowledge.map
4. Bump version on every changed file
5. Commit all in correct order → merge to main

Confirm every file committed after merge.
