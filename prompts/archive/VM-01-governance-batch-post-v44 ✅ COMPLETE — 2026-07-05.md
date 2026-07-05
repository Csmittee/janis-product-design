# cc Prompt — Governance Batch: Project-Leave Trigger + Part Manifest + Toggle-Completeness
# Date: 2026-07-05
# Scope: documentation/governance ONLY. Zero .scad geometry change.
# Sequencing: run this AFTER v44 (frame/window/acrylic rebuild) is merged
# and QA'd clean — do not run concurrently, keep the two changes separable
# in cc_chat_log.

## 1. CC INTRO
git fetch --all && git checkout main && git pull origin main
CONFIRM VM-01-base-v44.scad is merged and its cc_chat_log entry shows QA
PASS (all CGAL sweep angles empty, sensor beam confirmed deleted, frame
reference-point fix confirmed) before starting this prompt. If v44 isn't
merged/passed yet, STOP and flag it — this prompt assumes v44 is done.
Read in order: cc_rules.md → cc_chat_log.md (first 3 entries) →
knowledge.map → WORKFLOW_SKILL.md is NOT read by cc (Claude Web only) —
skip it, but note its content is being changed by Janis separately in
Project Knowledge.

## 2. CONTEXT

Three governance gaps surfaced during the v43/v44 QA sessions:

1. **CURRENT_STATE.md trigger ambiguity.** Earlier wording (MID-SESSION
   PROJECT SWITCH) didn't explicitly rule out "resuming a dormant/paused
   project" as a false trigger, which caused a session to incorrectly
   flag VM-01/PR-01 staleness as a bug when it wasn't. This section lives
   in WORKFLOW_SKILL.md/chat_rules.md — files cc does NOT read — so cc has
   no action item here. Janis is updating those files directly in Project
   Knowledge; nothing for cc to do except be aware the wording changed (no
   effect on cc's own read list).

2. **Part identity confusion (the acrylic/frame mixup).** The v43/v44 QA
   sessions spent significant cycles because `tray_zone_frame()` (a
   structural reinforcement sheet) was repeatedly mistaken for the
   acrylic viewing pane — nobody had ever written down, in one place,
   "here is every part, here is what it actually is, here is what it is
   NOT." This is a naming/identity gap, separate from the Datum Reference
   Frame discipline (DRF fixes WHERE things are measured from; this fixes
   WHAT people believe they're looking at).

3. **Toggle-completeness gap.** `tray_zone_frame()` had zero isolation
   toggle from the day it was written — nobody could turn it off
   independently to notice it was wrong-referenced. This is exactly why
   it went unnoticed for ~10 versions.

## 3. NEW FILES

### File: `vending-machine/VM-01-base/PART_MANIFEST.md`
One-time retroactive audit — list EVERY module called in VM-01's ASSEMBLY
section (v44), one entry each:
```
# PART_MANIFEST.md — VM-01
# What every ASSEMBLY-called module actually IS, in plain language.
# Read by: Claude Web + cc, before any QA session and before adding any
# new part. Update this file in the SAME prompt that adds/renames/removes
# any ASSEMBLY-called module — never let it drift from the real file.

Module | What it IS | What it is NOT (only if real confusion risk exists) | Toggle
-------|-----------|----------------------------------------------------|-------
legs() | 4 support legs | | (none — always on)
outer_shell_debug() | main cabinet shell | | show_shell_top/left/back/right
compartment_divider() | wall between product zone and system/dashboard zone | | (none — always on)
tray_rack() | fixed rails + latch pins holding trays | | (none — always on)
spring_tray() x2 | removable trays holding springs/product | | (none — always on)
left_zone_door() | the main hinged front door, includes window+acrylic+flap+flange | | show_door
flap_stopper_rod() | fixed rod that stops the exit flap at full-open | | (none — always on, static)
tray_zone_frame() | structural sheet-metal reinforcement, H-shaped, NOT viewable/acrylic | the acrylic viewing pane — that lives INSIDE left_zone_door() instead | show_frame (ADD in v44/this prompt if not already present)
drop_zone_guards() | solid hand-safety side guards at the exit/drop zone | the old ghost/visual placeholder faces (removed in v43) | (none — always on, safety-critical)
sensor_strip() | 2 independent left/right sensor strips capturing product fall | a connecting center beam — that never existed in the real design, deleted in v44 | show_sensor
dashboard() | ATM screen + QR + card reader + speaker | | (none — always on)
acrylic_display() | RIGHT-compartment upper acrylic panel (separate from the door's own acrylic) | the door's acrylic (different part, different module) | gated on render_mode=="full" only, no isolation toggle yet — FLAG in cc_chat_log if this should get one too, don't add without confirming
rear_service_door() | rear access panel | | (none — always on)
```
Confirm this list against the ACTUAL v44 ASSEMBLY block — add/remove rows
if the real file differs from this draft (this draft was written from the
pre-v44 source, v44 may have changed names/toggles).

### File: `pilates-reformer/PR-01-base/PART_MANIFEST.md`
Same format, PR-01's modules (bed_frame, pole_body, bell_lock_collar,
leg_socket, crossbar, etc. — confirm exact module names from the real
file, do not guess). Lower priority than VM-01's — PR-01 is currently
paused, do this only after the VM-01 file above is done. If time-limited,
flag this second file as NOT YET DONE in cc_chat_log rather than rushing
a guessed version.

## 4. TASKS

### TASK 1 — Toggle-completeness rule (add to `cc_rules.md`)
Add new subsection under "Coding Rules":
```
## Toggle-Completeness Rule (added 2026-07-05)

Every module called directly in a product's ASSEMBLY section MUST have
its own `show_*` isolation toggle, with ONE exception: modules that are
safety-critical and must never be hidden (e.g. `drop_zone_guards()`) may
be marked "(none — always on, safety-critical)" in that product's
PART_MANIFEST.md instead — this exception must be explicit and named in
the manifest, never silent.

Before every commit that adds a new ASSEMBLY-called module: grep the
ASSEMBLY block, confirm every call is either gated by a show_* toggle or
explicitly listed as a safety-critical exception in PART_MANIFEST.md.
Report this check's result in cc_chat_log ("N modules in ASSEMBLY, N
toggled, 0 untoggled-and-unexplained" or flag the gap).

Root cause this prevents: tray_zone_frame() had zero toggle for ~10
versions, made it impossible to isolate/inspect independently, and it
sat wrong-referenced against the shell's exterior corner the entire time
without anyone noticing. See PART_MANIFEST.md for the plain-language part
identity this rule pairs with.
```
Bump cc_rules.md version.

### TASK 2 — Wire PART_MANIFEST.md into knowledge.map
Add both new files to knowledge.map FILE LOCATIONS, maintained-by cc,
description: "Plain-language part identity registry — what each
ASSEMBLY-called module actually is/is not. Updated in the same prompt as
any module add/rename/remove. Read by Claude Web + cc before QA sessions."
Bump knowledge.map version.

### TASK 3 — Add `show_frame` toggle to `tray_zone_frame()` if v44 didn't
already add one
Confirm v44's frame rebuild included an isolation toggle for the new
H-frame. If it did, just reference its existing name in
PART_MANIFEST.md (Task in File section above may need its placeholder
name corrected to match). If it did NOT, add `show_frame` now, default
true, gating the entire `tray_zone_frame()` call in ASSEMBLY — same
pattern as the others. State explicitly in cc_chat_log which case applied.

## 5. DO NOT TOUCH
- Any `.scad` GEOMETRY — this prompt is toggle-wiring + documentation
  only. Do not touch the frame's shape, position, curve, or dimensions —
  that's v44's scope, already done.
- `WORKFLOW_SKILL.md`, `chat_rules.md` — Janis is updating the
  PROJECT-LEAVE TRIGGER wording in these directly via Project Knowledge,
  not via cc. Do not touch them in this prompt.
- `rules-dimensions.md` — unrelated to this prompt
- `.claude/rules-waivers.md`, `CURRENT_STATE.md` — unrelated

## 6. QA VERIFICATION
- [ ] `vending-machine/VM-01-base/PART_MANIFEST.md` created, matches the
      REAL v44 ASSEMBLY block exactly (row added/removed/corrected as
      needed vs. this draft)
- [ ] `pilates-reformer/PR-01-base/PART_MANIFEST.md` created OR explicitly
      flagged as deferred in cc_chat_log — not silently skipped
- [ ] cc_rules.md: Toggle-Completeness Rule added, version bumped
- [ ] knowledge.map: both manifest files added, version bumped
- [ ] `show_frame` toggle confirmed present (added here, or already in
      v44 — state which)
- [ ] Grep-confirm: every ASSEMBLY-called module in v44 is either
      show_*-toggled or listed as a named safety-critical exception —
      report the count explicitly (N toggled / N exceptions / 0 gaps)
- [ ] Zero geometry/dimension changes — confirm via diff against v44

## 7. MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP, under 10 lines
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date run]
3. knowledge.map updated in TASK 2
4. Bump version on all changed files
5. Commit all → merge to main
