CC PROMPT — bbq-base-chain-recalibration
================================================================
Repo locations:
- bbq-offset-smoker/BBQ-understructure-v13.scad (new, source v12)
- bbq-offset-smoker/BBQ-offset-smoker-base-v3.scad (new, source v2's
  real tray content + v1's original single-path include rule)

REVISION NOTE: LINKAGE-ONLY FIX. PR #143 (merged) shipped two real,
independently-correct pieces of work — BBQ-understructure-v12.scad
(tray removal/fender/track-width, correct) and
BBQ-offset-smoker-base-v2.scad (chambers-v21 parting-line shift + tray,
correct) — but they never got connected into one chain. Round 1
(understructure-v12) never touched the base file's include pointer.
Round 2 (base-v2) had no updated understructure to build on yet, so it
included BBQ-chambers-v21.scad directly instead — bypassing
understructure entirely. Result, confirmed from PR #143's own test
plan: two separate valid assemblies (base-v1's understructure chain,
base-v2's chambers/tray chain), each `Simple: yes` on its own, never
merged into a single real assembly. This prompt's ONLY job is to
reconnect them into one chain. ZERO geometry values, module content, or
design decisions from either round are to be touched, re-derived, or
"improved" — every tray/fender/lid/hinge number that shipped in PR #143
is correct and stays exactly as built.

## 1. CC INTRO

Session continuity check (cc self-determines):
Are cc_rules.md, knowledge.map, and cc_chat_log.md already loaded in
your active context from earlier in THIS session, with no git
pull/merge to main since?
→ YES: CONTINUATION. Skip re-reading those three. State "Continuation —
  governance already current" and go straight to TASKS.
→ NO: FRESH. `git fetch --all && git checkout main && git pull origin
  main`. Read cc_rules.md → knowledge.map → cc_chat_log.md (first 3
  entries). State every file read before writing a line.

Claude Web override: none

Per R-014 (RULES.md) / chat_rules.md v3.13: state the SPECIFIC real
check performed for every QA item below, not a generic "confirmed
working."

**MANDATORY FIRST CHECK** — confirm the real current state of all 4
files this prompt touches or depends on, exactly as PR #143 left them
(do not assume, read live):
- `BBQ-understructure-v12.scad` — confirm its real current `include`
  target (expect `BBQ-chambers-v20.scad`)
- `BBQ-chambers-v21.scad` — confirm real and merged, confirm the new
  fixed-band top edge (expect Z=1000mm) and hinge mount Z (expect
  980mm) per its own header
- `BBQ-offset-smoker-base-v1.scad` — confirm its real current `include`
  target (state whatever it actually is — this file was NOT touched by
  PR #143, so it may still point at an old understructure version)
- `BBQ-offset-smoker-base-v2.scad` — confirm its real current content:
  state its actual `include` target (expect `BBQ-chambers-v21.scad`
  directly, NOT an understructure file — this is the defect this
  prompt fixes) and confirm the tray module(s)/hinge parameters it
  contains, verbatim, before copying anything forward

## 2. CONTEXT

Two real, independently-correct pieces of work exist but were never
joined:
- Understructure's real fix (tray removal, rear fender, 880mm track
  width) — lives in `BBQ-understructure-v12.scad`, currently still
  wired to `BBQ-chambers-v20.scad` (correct at the time it was built —
  v21 didn't exist yet).
- Chambers' real fix (+50mm parting-line shift) and the new tray
  geometry that depends on it — live in `BBQ-chambers-v21.scad` and
  `BBQ-offset-smoker-base-v2.scad` respectively.

The single-path rule this project has used since base-v1's own header
comment (2026-07-13) still applies and is the reason this needs fixing,
not just leaving as two files: "Only the understructure file is
included here (not a chambers file directly too) — it already
`include`s the chambers file itself for its own datum access... OpenSCAD
has no include-guard, so including both here would render the chamber
assembly twice." Base-v2 currently violates that rule by including
chambers directly. The fix is not to add understructure alongside
chambers in base-v2 (that would double-include chambers, the exact
thing the rule exists to prevent) — it's to make understructure itself
current (pointing at v21), then have base include ONLY understructure,
same single path as always.

## 3. NEW FILES

- `BBQ-understructure-v13.scad` (source v12) — pure pointer-only bump,
  zero understructure geometry changed, same category as the v9→v10,
  v10→v11 pointer-only bumps already in this project's history.
- `BBQ-offset-smoker-base-v3.scad` (source: v2's real tray content,
  restructured onto v1's original single-include-path pattern) — the
  one real assembly file going forward, superseding both v1 and v2
  (both kept, unmodified, on record — per file-versioning convention).

## 4. TASK 1 (BBQ-understructure-v13.scad) — Pointer-only bump to chambers-v21

Change ONLY the `include <BBQ-chambers-v20.scad>` line to
`include <BBQ-chambers-v21.scad>`. Nothing else in this file changes.

Per R-009 (duplication/consequence check): confirm every real datum
this file consumes from the chambers file (`firebox_floor_z`,
`FIREBOX_W`, `firebox_y0`/`firebox_y1`, and any other real consumed
value — grep for the actual list, do not assume it's only these) has
the SAME value in v21 as it had in v20. `BBQ-chambers-v21.scad`'s own
DO NOT TOUCH list states apex A, `chamber_floor_z`, `chamfer`, and
general chamber body datums were unchanged by the parting-line shift —
confirm this live, do not take it on faith from that file's own header
comment alone.

**Mandatory real check**: full understructure-v13 render (fender,
track width, wheels, tow handle — everything from v12, now against
v21's geometry) — `Simple: yes`, and confirm by real CGAL/measurement
that nothing shifted position (the fender/track-width/wheel geometry
should be pixel-identical to v12's own render, since none of the
consumed datums changed).

## 5. TASK 2 (BBQ-offset-smoker-base-v3.scad) — Reconnect into one chain

Real construction, in this order:

1. Start from `BBQ-offset-smoker-base-v1.scad`'s original structure:
   ONE `include <BBQ-understructure-v13.scad>` line, nothing else
   included directly (per the single-path rule in Section 2 above —
   restores the original rule, does not reinvent it).
2. Copy forward `BBQ-offset-smoker-base-v2.scad`'s real tray content
   (both tray modules, their hinge mounts, their independent angle
   parameters, and the header note about the counterbalance mechanism
   being the next planned addition) VERBATIM — same module code, same
   parameter names, same values. This is a relocation, not a rewrite —
   state explicitly in cc_chat_log that you diffed the tray module(s)
   before/after the copy and confirm zero content changed.
3. Remove base-v2's own direct `include <BBQ-chambers-v21.scad>` line
   entirely — chambers access now comes transitively through
   understructure-v13, same pattern as every prior base version.

**Mandatory real checks, each with its specific probe (per R-014)**:
- Full assembly `Simple: yes` — ONE render, confirming fender + track
  width + wheels (from understructure) AND lid parting-line shift +
  both trays (from chambers/tray) are ALL present together in the same
  single render. This is the check that was missing from PR #143 —
  state explicitly that this is a genuinely unified assembly, not two
  chains rendered separately.
- Zero double-render of chamber geometry — confirm chambers appears
  exactly once in the facet/volume count (the exact defect the
  single-path rule prevents)
- Both trays' full angle sweep (−90° to 0°) re-verified against the
  NOW-PRESENT understructure geometry (wheels, front bracket) in the
  same render — PR #143's own tray sweep only checked this against a
  bare chambers file, not the real full assembly; state the real
  result here, EMPTY expected, with margin
- Full kinetic sweep: steer/fold (understructure) + lid angle + both
  tray angles (chambers/tray), combined — `Simple: yes` throughout

## 6. DO NOT TOUCH

- Every module's actual geometry, dimensions, and kinetic parameters
  from BOTH `BBQ-understructure-v12.scad` and
  `BBQ-offset-smoker-base-v2.scad` — this prompt moves and reconnects
  files, it does not redesign, re-tune, or "improve" anything already
  built. If a real conflict is found during reconnection (e.g. a true
  geometric collision that only appears once both are actually
  combined), STOP and flag it — do not silently resolve it by changing
  a dimension.
- `BBQ-chambers-v21.scad` — read only, zero changes
- `BBQ-offset-smoker-base-v1.scad` and `BBQ-offset-smoker-base-v2.scad`
  — both kept unchanged, on record (superseded by v3, not deleted or
  edited)
- `BBQ-understructure-v12.scad` — kept unchanged, on record (superseded
  by v13, not deleted or edited)

## 7. QA VERIFICATION

- [ ] TASK 1: real pointer-only bump confirmed (diff shows only the
      include line changed), all consumed datums confirmed unchanged
      value, real render confirmed pixel-identical to v12
- [ ] TASK 2: real single-include-chain structure confirmed (base-v3 →
      understructure-v13 → chambers-v21, one path), tray content
      confirmed verbatim (diffed), old direct chambers include removed
- [ ] Full assembly `Simple: yes` on the TRUE combined chain — fender +
      track width + wheels + lid shift + both trays all present in one
      render, explicitly confirmed (this is the check PR #143 was
      missing)
- [ ] Zero double-rendered chamber geometry confirmed
- [ ] Full kinetic sweep (steer/fold/lid/both tray angles combined) —
      `Simple: yes` throughout
- [ ] Screenshots: iso/front/side/rear showing fender+wheels+lid+trays
      together in one view
- [ ] Error-Log clean
- [ ] Explicit confirmation: zero geometry values changed from either
      PR #143 round

## 8. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at top, under 10 lines: state
   plainly this was a linkage-only fix (PR #143 shipped two correct but
   disconnected assemblies), real single-chain confirmation, real
   combined CGAL result.
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Update knowledge.map, PART_MANIFEST.md, SKELETON_WORKSHEET.md — base
   file's real current version is now v3 (single chain), understructure
   v13, chambers v21 — update whatever rows reference the old
   two-chain state
4. Update `bbq-offset-smoker/design_scope_of_work_rule.md` only if any
   line references a stale file version — content itself unchanged
5. Save both new files (v12 and base-v1/base-v2 kept, unmodified, on
   record)
6. Commit all → merge to main
