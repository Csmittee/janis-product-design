# cc Prompt — VM-01 File Cleanup Pass: Remove Debug/Experimental Code,
# Truncate Version History, Merge Duplicate Shell Modules
# Date: 2026-07-09
# Session goal: reduce VM-01-base's ~2400 lines by removing non-essential
# accumulated content, WITHOUT changing any real geometry. This is a
# PARALLEL, SEPARATE session from the acrylic/curve/rod/lock fix prompt
# (vm01-acrylic-curve-hinge-lock-fix.md) — do not combine them, do not
# assume that prompt's changes are present unless git confirms they are.
# Active file: whatever is on main when this runs — confirm exact version.

## 1. CC INTRO

Session continuity check: treat as FRESH. This may be running concurrently
with another cc session working on the acrylic/curve/rod/lock fixes on
the same file — check `git fetch --all` carefully, and if that other
session's PR has already merged, pull it in as your real starting point
rather than working from a stale version.

git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → knowledge.map → cc_chat_log.md (first 3
entries) → rules-dimensions.md → PART_MANIFEST.md (VM-01) → the current
committed `VM-01-base-vXX.scad` on main. State every file read and the
exact current version number AND current total line count before writing
a single line.

Claude Web override: none.

## 2. CONTEXT

The file has grown to ~2400 lines across 30+ versions of accumulated
history. Janis's instruction: **try a cleanup pass first, staying in ONE
file.** Only if the file is still unreasonably large/slow after cleanup
should any structural multi-file split be considered — that split (if
still needed) is a SEPARATE follow-up prompt, modeled on the existing
PR-01 flat-file multi-module convention already documented in
`.claude/rules-codes.md` — do NOT attempt a file split in this session,
cleanup only.

This is a **zero-geometry-change** session. Every task below must result
in the exact same rendered output as before — this is trimming
accumulated non-geometry content, not redesigning anything. If any task
turns out to require an actual geometry change to complete safely, STOP
and flag it rather than making the change — report back to Janis instead.

## 3. NEW FILES

None expected. If cc judges any content is worth preserving somewhere
before deletion (e.g., historical rationale someone might need later),
move it to `cc_chat_log.md` or a new file under `prompts/archive/` rather
than silently discarding it — state clearly what was moved and where.

## 4. TASKS

### TASK 1 — Audit and remove dead/one-off debug scaffolding ("spy" code)

Go through the file's toggle/debug sections (e.g. the "ISOLATION TOGGLES
— for manifold-debug inspection" block and any similar scratch-diagnostic
additions accumulated across the manifold-hunting sessions) and sort each
one into exactly one of these two categories — do NOT guess, check actual
usage:

**KEEP — actively referenced/used:** any toggle whose name appears in a
QA checklist item in `rules-dimensions.md`, in a recent `cc_chat_log.md`
entry's QA verification, or that is clearly a standard render-mode
control used regularly (e.g. `show_door`, `show_acrylic`, `show_shell_*`,
`door_open`, `flap_open`, `tray_out_pct` — these are NOT candidates for
removal, they're the project's normal viewer controls).

**REMOVE — genuinely dead/orphaned:** toggles or code blocks that were
added for a single specific bug hunt that is now fully resolved (e.g. a
one-off isolation variable created only to test one specific hypothesis
that's since been confirmed/ruled out), commented-out old geometry
attempts, leftover debug print-style constructs, or any code with no
remaining reference anywhere in the file's own logic.

State explicitly in cc_chat_log EVERY item removed and EVERY item kept
with a one-line reason each — do not do this silently. If genuinely
unsure whether something is dead, err on the side of flagging it for
Janis rather than deleting it.

### TASK 2 — Investigate and address "dashboard experimental" code

Janis flagged possible leftover experimental code related to dashboard
rendering ("dashoff" — exact scope unclear from her instruction, DO NOT
GUESS). Locate `dashboard()` and any related right-compartment rendering
code. If you find experimental/scratch/half-finished code there that
isn't part of the confirmed design (e.g. disabled/dead branches, unused
parameters, placeholder geometry never wired into ASSEMBLY), report
exactly what you found in cc_chat_log with enough detail that Janis can
confirm removal — do NOT delete anything in this specific area without
that explicit description being clear enough to approve after the fact.
If nothing matching this description is found, state that plainly rather
than force-fitting something.

### TASK 3 — Truncate the accumulated version-history header comments

The file's header currently carries a long chain of "Changes from vNN"
narrative blocks, version after version. Per the same precedent already
used for `knowledge.map` (2026-07-07 rebuild — full history preserved in
git + `cc_chat_log.md`, only the embedded copy was stripped from the
file itself): truncate the in-file header to the current version's own
changes only (the most recent "Changes from v[current-1]" block), plus a
single line pointing to `cc_chat_log.md`/git history for anything older
— e.g. "Full version history: see cc_chat_log.md and git log."

Do NOT delete this history — it must remain fully readable via
`cc_chat_log.md` and git, which it already is. This task only removes
the DUPLICATED copy that's been growing inside the source file itself.

Apply the same truncation logic to any individual module's own inline
comment blocks that have accumulated multi-version narrative history
(e.g. `left_zone_door()`'s comments currently document v42 through v56
inline) — keep only the CURRENT rationale for why the geometry is what
it is now, not the full chronological narrative of how it got there.
That chronological detail lives in `cc_chat_log.md` already.

### TASK 4 — Merge `outer_shell()` and `outer_shell_debug()` into one module

This is the highest-value fix in this session, not just cleanup: these
two modules have independently duplicated the same cutout logic at least
twice (root cause of both the v55 door-floor datum bug and the v56
corner-cutout gap — the SAME class of bug, "a value re-derived in
multiple places, one copy missed"). As long as two separate modules
exist, this bug class WILL recur.

Investigate why two separate modules exist in the first place (state the
actual reason found in the file/history, do not assume) and merge them
into ONE module with a single source of truth for every cutout — if a
debug-only rendering mode is the reason (e.g. one shows cutout outlines,
one doesn't), implement that as a parameter/toggle on the SAME module
rather than a second copy of the geometry.

This is a real geometry-logic change (even though the RENDERED OUTPUT
must stay identical) — re-verify with a full 10-angle manifold sweep
after the merge, exactly as rigorously as any other geometry change in
this project's history. Do not skip this check because it's "just a
merge."

### TASK 5 — Report final state, do NOT attempt a file split

State the final total line count vs. the starting ~2400 lines. State
render time before/after if measurable. **Do not split the file into
multiple files this session, regardless of the resulting line count** —
that decision is Janis's to make based on this session's actual result,
via a separate follow-up prompt if still needed.

## 5. DO NOT TOUCH

- Any actual part geometry, dimension, or parameter value — this session
  is non-geometry cleanup + the Task 4 shell-module merge only, and even
  Task 4 must produce IDENTICAL rendered output, verified
- The acrylic/curve/rod/lock work from the parallel session — if that
  PR has merged before you start, treat its result as the new baseline;
  if it hasn't merged yet, do not attempt to guess or replicate it
- `tray_zone_frame()`, `compartment_divider()`, `tray_compartment_partition()`,
  `exit_compartment_wall()`, `drop_zone_guards()`, `sensor_strip()`,
  `spring_tray()`/`tray_rack()` geometry — cleanup of surrounding comments
  only if they have the same accumulated-history problem, NO logic changes
- Any PR-01 file

## 6. QA VERIFICATION

- [ ] Starting line count and version stated explicitly
- [ ] Every removed toggle/debug block listed individually with reason
- [ ] Every kept toggle listed individually with its active-use reference
- [ ] Dashboard experimental code investigated — findings reported in
      enough detail for Janis to approve removal, OR removed only if
      unambiguously dead code with zero references anywhere
- [ ] Version-history header truncated, current version's own changes
      preserved, pointer to cc_chat_log.md/git added
- [ ] Per-module inline changelog comments truncated to current
      rationale only, same pointer convention
- [ ] `outer_shell()`/`outer_shell_debug()` merged into one module,
      reason for original duplication stated
- [ ] Full 10-angle manifold sweep after the merge — zero warnings,
      explicitly confirmed identical to pre-merge state
- [ ] Rendered output (F5/F6) visually identical to pre-cleanup version —
      confirmed via real render comparison, not assumed
- [ ] Final line count reported, compared to starting ~2400
- [ ] No file split attempted this session
- [ ] Version incremented correctly, old version untouched

## 7. MANDATORY CLOSING

1. Prepend `cc_chat_log.md` — newest entry at TOP, under 10 lines: what
   was removed (categories + counts), shell-module merge confirmation +
   manifold re-verification result, final line count vs. starting count,
   explicit recommendation on whether a future file split is still
   warranted given the actual result
2. Archive this prompt → `/prompts/archive/`
3. Update `knowledge.map` if any module name changed (e.g.
   `outer_shell_debug()` no longer exists)
4. Bump `rules-dimensions.md` only if any dimension reference changed
   (should be none)
5. Commit all → merge to main
