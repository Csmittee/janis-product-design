# cc Prompt — Pole Base Build: Bell Collar Lock Mechanism + Embedded Socket
# Date: 2026-07-02
# Session goal: FIRST production geometry pass on pole holder/socket.
# Replaces old external split-clamp collar (SUPERSEDED). No production
# geometry has touched the pole holder/socket before this prompt.

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order, state every file read before writing a single line:
1. cc_rules.md
2. knowledge.map
3. cc_chat_log.md (first 3 entries — newest at top)
4. WORKFLOW_SKILL.md (repo root copy)
5. chat_rules.md (repo root copy)
6. rules-dimensions.md — full Bell Collar + PR-01 sections
7. pilates-reformer/PR-01-base/pole_top.scad (current live version —
   confirm pole_cx/pole_cy fix is present: pole_cx=[90,2210,90,2210],
   pole_cy=[60,60,780,780])
8. PR-01-assembly-v28.scad (current active top-level includer, bed_w=840)
9. .claude/SKILL_local_render.md or equivalent multi-file-split governance
   entry (confirms the flat-folder module convention and the unversioned-module-
   file exception, plus the ghost-context preview requirement — read this
   before creating any new module file)

This repo uses a flat-file multi-file split, standing convention since
PR-01-flatten-modules-v26 (2026-07-01): PR-01-assembly-vXX.scad is a thin
top-level includer; real component logic lives in flat .scad files directly
under pilates-reformer/PR-01-base/ (a modules/ subfolder was tried in v25
and superseded by v26 — Janis's local download-only workflow does not
preserve subfolders). This prompt MUST follow the flat convention — do not
write new component geometry logic directly into the assembly file, and do
not reintroduce a modules/ subfolder. If the current module structure does
not match what TASK 1/2 below assume (e.g. module names, existing collar
module, folder layout), verify from the live files and adapt — do not
force-fit; state the discrepancy in cc_chat_log.

## 2. CONTEXT

Janis has confirmed, for the first time, two dimension sets via OpenSCAD
Customizer screenshots (not yet committed to production geometry):

1. A REVISED bell collar profile (supersedes the earlier 2026-07-02 CONFIRMED
   table in rules-dimensions.md — new screenshot values are now authoritative).
2. Socket/leg architecture — first-time lock, was PLACEHOLDER before this.

Lock mechanism (thread + bayonet + cap engagement specs) was NOT part of
either screenshot set — Janis explicitly delegated these to Claude Web as
engineering judgment based on standard practice for hand-assembled
quick-release fittings at this scale. These values are ENGINEER-PROPOSED,
NOT Janis-measured, NOT load-tested. Flag clearly in rules-dimensions.md
with that provenance, distinct from Janis-confirmed values.

This prompt replaces the old external split-clamp collar (cam-lock design,
seen in PR-01-base-v2/v3/v4.scad, already marked SUPERSEDED in
rules-dimensions.md) with the bell/mushroom collar + embedded leg socket —
pole pushes directly into the socket, no external bracket.

## 3. NEW FILES

Determine current live version numbers from the repo (do not assume — read
first). Per the flat-folder multi-file convention (module .scad files are unversioned,
only the top-level assembly file is version-incremented):

- `pilates-reformer/PR-01-base/pole_top.scad` → adds
  `bell_lock_collar()` module. Unversioned per the flat-file exception — same
  file, updated in place, tracked by git commit.
- `pilates-reformer/PR-01-base/leg_socket.scad` → NEW module file,
  adds `leg_socket()` module. Unversioned, same convention.
- `PR-01-assembly-vXX.scad` → next version increment from v28. Adds
  `include <leg_socket.scad>` alongside the existing pole_top
  include, and instantiates both `bell_lock_collar()` and `leg_socket()` at
  the 4 pole/leg positions. This is the only file in this prompt that gets a
  version bump.

Add `leg_socket.scad` and the new `PR-01-assembly-vXX.scad` to
knowledge.map once actual version number known.

## 4. TASKS

### TASK 1 — Add `bell_lock_collar(cx, cy)` module to `pole_top.scad`

Bell dome profile — REVISED CONFIRMED values (Janis screenshot,
`bell_holder_customizer.scad`, 2026-07-02 — supersedes the earlier
r_top=29/curve_power=1.4 table entry):

| Parameter | Value |
|---|---|
| r_base | 51mm |
| r_top | 25mm |
| foot_h | 8mm |
| dome_h | 35mm |
| dome_steps | 16 |
| curve_power | 2.2 |
| cap_h | 12mm |
| cap_knurl_count | 45 |
| washer_h | 5mm |
| washer_overhang | 4mm |
| pole_od | 40mm — LOCKED, unchanged |

Lock mechanism geometry — ENGINEER-PROPOSED (Claude Web, market-standard
practice, NOT physically validated, flag in code comments accordingly):

- **Thread:** single-start, pitch=3mm, radial depth=1.5mm, cut on neck OD
  (2×r_top = 50mm), engagement length=8mm (of the cap's 12mm total height —
  remaining ~4mm sits proud as knurled grip reveal).
- **Bayonet:** 3 lugs at 120° spacing, lug width=5mm, engagement depth=3mm,
  30° rotation to lock.
- Comment block above this geometry must state verbatim: "Lock mechanism
  dimensions are engineering estimates based on standard quick-release
  fitting practice — NOT physically validated, NOT production-ready. Requires
  prototype fit-test before tooling."

Instantiate `bell_lock_collar()` at all 4 confirmed pole positions:
pole_cx=[90,2210,90,2210], pole_cy=[60,60,780,780].

Retire the old split-clamp `pole_top_collar()` cam-lock module if still
present/called anywhere in the live assembly — confirm from repo whether it's
still referenced; if yes, comment out the call site with a note pointing to
the SUPERSEDED entry in rules-dimensions.md, do not delete the module outright
without confirming nothing else depends on it.

### TASK 2 — New `leg_socket.scad`: `leg_socket()` module (embedded pass-through sleeve)

Create as a new, separate flat-file module per the flat-folder multi-file
convention — this is a distinct physical component (leg + embedded socket),
not part of pole_top's geometry. Unversioned per the flat-file exception.

Add the ghost-context preview block at the top of this new file, following
the CURRENT (post-fix) convention — NOT the original v25/v26 pattern. That
original self-reassigning pattern (`$is_assembly = is_undef($is_assembly) ?
false : $is_assembly;`) caused two separate bugs once flattened into the
assembly's scope via `include` (ghost-leak into every full-assembly render,
fixed in PR-01-fix-ghost-leak-toggle-relocate-v27; the identical bug class
recurred on pole_cx/pole_cy, fixed separately 2026-07-02). Use the
CURRENT live pattern instead: a read-only `function ghost_mode() =
is_undef($is_assembly) || !$is_assembly;`, with `if (ghost_mode())` gating
the stand-in geometry — read the exact current implementation from the live
`pole_top.scad` file and mirror it exactly, do not reconstruct from this
description. Gray, 30%-opacity stand-in for the mating pole stub, shown only
when this file is opened standalone, suppressed when included from the real
assembly (`$is_assembly = true` set before the include).

Also — per the v26 TASK 2 convention — guard every global this file's
ghost-context call path references (not just `$is_assembly`) with
`is_undef()` fallback defaults sourced from rules-dimensions.md, so a
standalone open of `leg_socket.scad` produces zero undefined-variable
warnings without needing the assembly file's globals already in scope.

First-time CONFIRMED values (Janis screenshot, `pole_top_housing_customizer`
leg/bed panel, 2026-07-02):

| Parameter | Value |
|---|---|
| leg_h | 600mm |
| leg_w | 180mm |
| leg_t | 120mm |
| pad_t | 20mm |
| pad_overhang | 50mm |
| socket_depth | 400mm (pass-through sleeve, replaces old shallow bonded pocket) |
| socket_od | 46mm |
| socket_wall_t | 2.5mm |
| pole_od | 40mm — LOCKED |

Derived: socket_id = socket_od - 2×socket_wall_t = 41mm. Radial clearance
against pole_od(40mm) = 0.5mm. State this explicitly in cc_chat_log — tight
tolerance, not a blocker, but Janis should be aware for print/fit tolerance.

Embed the socket sleeve inside each leg, aligned under each pole position,
oriented for the >300mm pass-through sleeve Janis specified (vertical bore
through the leg, socket_depth=400mm, NOT the old shallow bonded pocket).

### TASK 3 — Assembly integration (top-level includer only)

In the new `PR-01-assembly-vXX.scad`:
- Add `include <leg_socket.scad>` alongside the existing
  `pole_top.scad` include.
- Set `$is_assembly = true;` before both includes (existing convention —
  suppresses ghost-context stand-ins in the real assembly render).
- Instantiate `bell_lock_collar(cx, cy)` at all 4 pole_cx/pole_cy positions.
- Instantiate `leg_socket()` at each of the 4 leg positions, vertically
  aligned so the pole's lower end seats into the socket bore.
- This file stays a thin includer — no new geometry logic written directly
  here, only includes + global params + instantiation calls, per the
  existing flat-file split convention (standing since v26).
- No change to bed_w=840, xbar_y_front=60, xbar_y_rear=780 (unrelated to
  this prompt — verify unchanged after edit via diff).

### TASK 4 — Update `rules-dimensions.md`

Update the existing "PR-01 Base — Pole Holder, Bell Collar" section:
mark it superseded by a new entry below it titled "REVISED — CONFIRMED via
Customizer screenshot, 2026-07-02" containing the new r_top=25,
curve_power=2.2, cap_h=12, washer_overhang=4 values (full table, all
params). Keep the old entry for history per file's existing convention —
do not delete.

Add a new section "PR-01 Base — Socket/Leg Architecture (CONFIRMED,
first-time lock, 2026-07-02)" with the full leg_h/leg_w/leg_t/pad_t/
pad_overhang/socket_depth/socket_od/socket_wall_t table, plus the derived
socket_id=41mm and 0.5mm clearance note.

Add a new section "PR-01 Base — Lock Mechanism (ENGINEER-PROPOSED, NOT
Janis-measured, NOT validated, 2026-07-02)" with thread_pitch,
thread_depth, thread_engagement_l, bayonet_lug_count, bayonet_spacing,
bayonet_rotation, bayonet_lug_w, bayonet_engagement_depth — explicitly
labeled as requiring physical validation before production tooling.

## 5. DO NOT TOUCH

- `pole_top_housing_customizer.scad` and any top-joint housing tuning —
  explicitly deferred this session, to be resumed later as one-piece fusion.
  Zero changes to housing_* parameters.
- `PR-01-base-showcase-v1.scad` — local file, not in repo, no action needed.
  Note for the record only: its r_top=25 is now CORRECT per the revised
  table above, no longer a bug — but this is a local-only file, do not
  touch it from this prompt.
- Old split-clamp collar values already marked SUPERSEDED in
  rules-dimensions.md — do not resurrect or re-edit that historical entry.
- bed_w, leg_t as used in bed/crossbar geometry (v28) — unchanged, verify
  via diff.
- VM-01-base — untouched, out of scope.
- .claude/SKILL_customizer_profile.md and its toggle-mandate rules — already
  merged, no change needed here, but new geometry added by this prompt
  should still honor the mandatory visibility/cutaway toggle rules if this
  work also touches any Customizer-enabled prototype file.

## 6. QA VERIFICATION

- [ ] Bell collar renders at all 4 pole positions with REVISED values
      (r_top=25, curve_power=2.2, cap_h=12, washer_overhang=4)
- [ ] Thread + bayonet + cap geometry present, manifold-clean, comment
      block with the engineer-estimate disclaimer present verbatim
- [ ] Socket sleeve embedded in all 4 legs: socket_od=46, wall_t=2.5,
      depth=400, aligned under each pole
- [ ] cc_chat_log states socket_id=41mm and 0.5mm radial clearance explicitly
- [ ] No undefined variable warnings in SCAD
- [ ] No 2-manifold warnings — if any appear, do NOT attempt a fix in this
      same prompt; report to Claude Web per manifold triage protocol
- [ ] bed_w=840, xbar_y_front=60, xbar_y_rear=780 confirmed unchanged (diff)
- [ ] Old split-clamp collar call site handled per TASK 1 instructions —
      state what was found and what action was taken
- [ ] Only `PR-01-assembly-vXX.scad` version-incremented; `pole_top.scad`
      and `leg_socket.scad` remain unversioned per the flat-file
      exception (confirmed understanding stated in cc_chat_log, same as v26)
- [ ] `leg_socket.scad` standalone render shows gray ghost stand-in
      for mating pole stub; assembly render suppresses it (`$is_assembly=true`)
- [ ] `leg_socket.scad` uses the CURRENT `ghost_mode()` read-only-function
      pattern (matching live `pole_top.scad`), NOT the original self-
      reassigning `$is_assembly` pattern that caused the v27 ghost-leak and
      pole_cx/pole_cy bugs — confirm explicitly in cc_chat_log
- [ ] rules-dimensions.md has all 3 new/updated sections with correct
      provenance labels (REVISED-CONFIRMED / CONFIRMED-first-lock /
      ENGINEER-PROPOSED)

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at TOP, under 10 lines
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-02
3. Update knowledge.map with actual new filenames/versions
4. Bump version on all changed files
5. Commit all → merge to main
