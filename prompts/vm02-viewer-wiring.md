# cc Prompt — Wire VM-02 Into the Viewer (modelsFolder system)
# Date: 2026-07-10
# Viewer/docs only. Zero .scad geometry changes.

## 1. CC INTRO

git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → knowledge.map → cc_chat_log.md (first 3
entries) → `.claude/SKILL_viewer_update.md` (in full — this is the
authoritative procedure for this task) → `viewer/janis-product-viewer.html`
(PROJECTS object only) → whatever is the CURRENT latest
`vending-machine/VM-02-base/VM-02-base-vNN.scad` on main at the time you
run this (state exactly which version number you found — VM-02 may have
moved past v1 by the time this runs, depending on whether the other
pending VM-02 prompt has landed; use whatever is actually live, don't
assume v1).

State every file read before writing anything.

## 2. CONTEXT

Janis wants VM-02 wired into the viewer the same flexible way VM-01
already is (per `vm01-viewer-dynamic-folder-picker`, 2026-07-09): a
`modelsFolder` key so she can upload any freely-named `.stl` into
`public/models/VM-02/` on the Satu backend repo and have it appear live
in the viewer, with no cc prompt needed for future view uploads. This is
a first-time wiring — VM-02 has no PROJECTS entry at all yet.

This is independent of the other pending VM-02 prompt (metal panel fix +
retroactive governance docs) — that prompt may or may not have landed on
main by the time this one runs. Read whatever VM-02 file is actually
current; do not block on the other prompt's completion.

## 3. NEW FILES

None. Edit to `viewer/janis-product-viewer.html` only.

## 4. TASKS

### TASK 1 — Add VM-02 PROJECTS entry

Add a new `'VM-02'` entry to the `PROJECTS` object, following the same
`modelsFolder`-based shape as VM-01's current entry (see
`SKILL_viewer_update.md`'s QUICK REFERENCE) — NOT the legacy fixed-key
(`stl`/`stlOpen`/`stlC2`) shape:

- `label`: `'VM-02'`
- `version`: the exact version string of whichever `VM-02-base-vNN.scad`
  you actually found live on main (state it)
- `status`: read from `CURRENT_STATE.md` if VM-02 has an entry there yet;
  if not, use a short accurate description (e.g. "IN PROGRESS") — do not
  invent a status that implies more completeness than confirmed
- `modelsFolder`: `'VM-02'` (matching the GitHub folder name convention
  VM-01 uses)
- `params[]`: a curated subset of the live file's key parameters,
  mirroring VM-01/PR-01's existing curation approach (not literally every
  global). Include at minimum: `tray_count` (now a live [1:5] Customizer
  parameter — real, not cosmetic), `system_w`, `product_w`, `total_w`,
  `total_h` (note in cc_chat_log that this is DERIVED, not a raw literal,
  same as VM-02's own source comments explain), `leg_od`.
- `toggles[]`: real toggle names confirmed against the live file's own
  `show_*` parameters (see `PART_MANIFEST.md`'s Toggle column for VM-02 —
  do not guess, several modules are explicitly flagged there as having NO
  toggle).
- `components[]`: real module names confirmed against the live file.
- `scad: null` (STL-mode project, same as VM-01/PR-01 — no in-browser
  WASM autorender).

**Open question, your judgment call, state your answer explicitly in
cc_chat_log:** `tray_out_pct` is now a length-5 vector (independent
per-tray slide), not a single scalar VM-01 ever had. Check whether the
existing `params[]` structure/UI supports an array-type slider. If yes,
implement it. If no, do NOT silently flatten it to a single shared value
— either (a) expose it as `tray_out_pct[0]` through `[4]` as 5 separate
named params if the structure allows multiple params cleanly, or (b) if
neither is clean within today's structure, state exactly why and leave
it out of `params[]` for now rather than misrepresenting per-tray
independence as a single global slider. This is a real UI question, not
a formality — flag your reasoning either way.

### TASK 2 — Confirm empty-folder handling

`public/models/VM-02/` does not exist yet on the Satu backend repo —
Janis hasn't uploaded any STL there. This is a genuinely new scenario:
every existing `modelsFolder` project (VM-01) has always had at least one
file present when tested. Confirm (or test if possible) that the
folder-listing code added in `vm01-viewer-dynamic-folder-picker` handles
a *missing or empty* folder gracefully — a clear "no models uploaded yet"
state, not a silent blank screen or an unhandled error indistinguishable
from a real API failure (403/429, already handled). If this case isn't
already handled, fix it as part of this prompt — it directly blocks
Janis's first VM-02 upload from working cleanly.

## 5. DO NOT TOUCH

- Any `.scad` file
- VM-01's or PR-01's existing PROJECTS entries
- `rules-dimensions.md`

## 6. QA VERIFICATION

- [ ] VM-02 PROJECTS entry added, `modelsFolder: 'VM-02'`, all values
      read live (state exact source file/version), none guessed or
      copied from VM-01/PR-01
- [ ] `tray_out_pct` vector question answered explicitly, with reasoning,
      not silently resolved either way
- [ ] Empty/missing-folder case confirmed handled gracefully (or fixed)
- [ ] Dynamic file-list dropdown renders for VM-02 the same way it does
      for VM-01
- [ ] VM-01/PR-01 behavior confirmed unchanged (re-test both explicitly)
- [ ] Zero `.scad` files touched — confirmed explicitly

## 7. MANDATORY CLOSING

1. Prepend `cc_chat_log.md` — newest entry at TOP, under 10 lines: confirm
   VM-02 entry added, which version it points at, the `tray_out_pct`
   decision + reasoning, empty-folder handling result, exact folder path
   Janis needs to upload into
2. Archive this prompt → `/prompts/archive/`
3. Update `knowledge.map` if warranted
4. Commit all → merge to main
5. Tell Janis: exact folder path (`public/models/VM-02/`) to upload her
   first STL into, and confirm the viewer shows a sensible empty state
   until she does
