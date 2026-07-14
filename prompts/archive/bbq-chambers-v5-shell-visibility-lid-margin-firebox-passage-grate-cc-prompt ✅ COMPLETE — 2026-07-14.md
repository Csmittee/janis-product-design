# CC PROMPT — bbq-chambers-v5-shell-visibility-lid-margin-firebox-passage-grate
# Date: 2026-07-15
# Repo location: bbq-offset-smoker/BBQ-chambers-v5.scad (new, source v4)
# Build prompt — 4 real findings from Janis's live OpenSCAD QA session,
# ONE of which is a re-diagnosis (PR #119's color/opacity fix did NOT
# resolve what Janis is seeing — both F5 preview AND F6 render still
# read solid/opaque, and a new symptom appeared that PR #119's own probe
# (X=400, mid-span only) never checked: missing octagon profile edges at
# the front/rear ends). Loop count on the "shell reads solid" issue is
# now 1 confirmed FAIL (PR #119) — this prompt is FAIL-loop 2. If TASK 1
# does not resolve it, R-111 triggers on the next round — do not treat
# this attempt casually.

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order, state every file read before writing a single line:
1. cc_rules.md
2. knowledge.map
3. cc_chat_log.md (first 3 entries — newest at top)
4. bbq-offset-smoker/rules-bbq-fab.md (Standing Orientation Convention +
   construction method)
5. bbq-offset-smoker/SKELETON_WORKSHEET.md
6. bbq-offset-smoker/BBQ-chambers-v4.scad — the LIVE file, in full. State
   the exact version/filename you find on main right now — this matters,
   see TASK 1.
7. .claude/rules-codes.md (color/opacity convention, coordinate rules)

Claude Web override: none.

Before writing any fix (per R-009): confirm whether the value/logic
being changed exists in more than one place in the file (or any other
file in the same part's module group) — state this explicitly in
cc_chat_log, even if "no duplicates found."

## 2. CONTEXT

PR #119 (direct-cc, color/opacity fix) investigated the "solid octagon
mass" complaint, found via a real CGAL cross-section probe at X=400 that
the shell WAS genuinely hollow there, concluded the visual problem was
missing color()/opacity, and applied it. Janis confirms this did NOT
fix what she's seeing: **both F5 preview and F6 render still show the
chamber as solid/opaque** — not just an F6 alpha-compositing limitation
(which would explain F6 looking solid but not F5). She also separately
found, this session, that the octagon profile's edges are missing at
the front and rear ends when the lid is open, and that the current lid
covers nearly the full chamber length (LID_X0=10, LID_X1=905 — only
10mm margin at each end), when it should stop ~100mm short of each end.
These two symptoms may share a root cause in the same end-zone — X=400
was never a relevant probe location for either.

Also found, separately, this session:
- The firebox-to-chamber passage (`window_cut()`/`rear_window_hole()`,
  currently a fixed 254x119mm rectangle) is too small. Janis wants it
  reshaped to follow the chamber's own octagon (8-face, per locked
  SKELETON_WORKSHEET A→H vocabulary) cross-section
  profile at that wall, offset 10mm inward from the profile's true
  edges — not a separate arbitrary rectangle.
- `grill_grate()`'s 3 segments sit too low and collide with the shell.

Janis has explicitly asked for ONE prompt covering all of this — she is
holding the understructure prompt (`bbq-understructure-v2...`) until
these are resolved and confirmed.

## 3. NEW FILES

None. New `BBQ-chambers-v5.scad` (source v4), per file-versioning
convention — v4 kept, not overwritten.

## 4. TASKS

### TASK 1 — RE-DIAGNOSE shell-reads-solid + missing end-profile (do this FIRST, real investigation before any fix)

This is not a repeat of PR #119's fix — it's a fresh diagnosis, because
PR #119's own probe was at X=400 (mid-span) and Janis's symptom includes
the END zones specifically, which were never checked.

1. Confirm you are actually looking at `BBQ-chambers-v4.scad` as merged
   in PR #119 (not a stale copy) — state the exact `color()` calls
   present at the ASSEMBLY call sites, verbatim, as currently committed.
2. Run real CGAL cross-section probes near BOTH ends — not just X=400.
   Suggested: X=15 and X=900 (near the current LID_X0=10/LID_X1=905
   boundaries), plus X=50 and X=865 for a second data point further in.
   State the boundary-point count and structure at each, same method as
   PR #119's own X=400 probe.
3. Check whether `color()`/opacity is actually reaching the rendered
   geometry — is there any downstream `color()` call (inside a module
   definition, not just at the ASSEMBLY site) that could be silently
   overriding the 0.75-alpha call with a full-opacity default? State
   explicitly yes/no, with the actual call sites checked.
4. State a REAL root cause for BOTH symptoms (solid-in-both-F5-and-F6,
   AND missing front/rear octagon profile edges) — they may be the same
   cause or two different ones. Do not assume they're connected just
   because they were reported together; check the geometry and say
   which is which.
5. Fix based on what's actually found — do not reapply PR #119's same
   color fix again without a new finding to justify it.

### TASK 2 — Lid margin: 10mm → 100mm each end

```
LID_X0 = 100                    // was 10
LID_X1 = chamber_L - 100        // 815, was 905
LID_LENGTH = LID_X1 - LID_X0    // 715, was 895
```

Re-verify `lid_opening_cut()`'s overshoot/HINGE_CLEARANCE logic (see
v2's own header comment on this) still functions correctly against the
new, shorter margins — re-run the full kinetic sweep (`lid_open_deg`
0–120°, real CGAL, `Simple: yes` at every step) and re-confirm zero
collision against every fixed part (shell, firebox, exhaust room, pipe,
grate, drains), same discipline as the v3 mirror fix. State whether this
change alone resolves the missing-end-profile symptom from TASK 1, or
whether TASK 1's own fix was the actual cause — don't assume, check.

### TASK 3 — Firebox passage: reshape to profile-derived cut AND verify area against the standing sizing formula

Current: `window_cut()`/`rear_window_hole()` is a fixed 254x119mm
rectangle (30,226 mm² / 46.85 in²). Replace with a passage shaped as the
chamber's own OCTAGON (8-face, per SKELETON_WORKSHEET's locked A→H
vocabulary — NOT hexagon) cross-section profile at that shared wall
(X=chamber_L), offset 10mm inward from the profile's true edges (reuse
the same `offset(delta=-10)` pattern already used elsewhere in this file
for wall insetting — don't invent a new one).

This is Claude Web's interpretation of Janis's shape instruction ("follow
the intersect of the octagon profile but offset from edge -10mm around
the cut profile") — stated back for her to correct if this reading is
wrong, but proceed on this basis rather than blocking. Verify the
resulting opening does NOT breach the chamber's own structural corners
(chamfer zones) — if the 10mm-inset profile would cut into the chamfer
transition in a way that looks structurally wrong, flag it explicitly
rather than forcing it through silently.

**AREA CHECK — real numbers required, not just the shape:**
`rules-bbq-fab.md`'s own standing sizing formula states
`firebox_volume = chamber_volume / 3` and
`window_area = firebox_volume * 0.008`. Two candidate readings of
"firebox_volume" exist and give different targets — state the resulting
area of your new profile-derived cut against BOTH, do not silently pick
one:
- Reading A (document's own literal formula): `firebox_volume =
  chamber_volume / 3` ≈ 6,507 in³ → target area ≈ 52.05 in²
  (≈33,585 mm²)
- Reading B (actual built firebox box, `firebox_size^3` = 457mm cube)
  ≈ 5,824 in³ → target area ≈ 46.59 in² (≈30,066 mm², which the OLD
  254x119mm rectangle already matched almost exactly)
State the new profile-derived cut's real computed area (shoelace or
equivalent, not estimated) and report which reading it lands closer to,
or whether it falls short of both — Janis will confirm which basis is
correct, do not resolve the ambiguity yourself.

Cross-check against `firebox()`'s own facing wall — the opening must
still work as a shared passage between the two compartments, matching on
both sides (chamber wall AND firebox wall), same as the current
rectangle does.

### TASK 4 — Grill grate: fix low position / shell collision

`grill_grate()`'s 3 segments currently collide with the shell and sit
too low. Read the LIVE current Z-position/support-ledge logic from
`BBQ-chambers-v4.scad` directly (do not use any value Claude Web might
imply above — none were given, verify from the real file). Real CGAL
collision check required: confirm the grate's resting Z clears the
shell's own inner wall surface (post-`wall_t` inset) with positive
clearance, not a zero-clearance tangent. State the actual clearance
value found and the fix applied.

## 5. DO NOT TOUCH

- `firebox_shell()`, `fire_grate()`, `ash_tray()`, `firebox_door()` —
  unchanged, already CGAL-verified
- `firebox_drop = 200mm` — still an open flag, not resolved by this
  prompt
- Exhaust room / chimney pipe geometry (v3's resize) — unchanged
- `lid_hardware()` — still disabled (`show_lid_hardware=false`), still
  a follow-up prompt, not this one
- Understructure — separate file, explicitly out of scope this round
  per Janis's own sequencing instruction
- rules-dimensions.md, cc_rules.md — read only

## 6. QA VERIFICATION

- [ ] TASK 1: real root cause stated for BOTH symptoms (solid-in-both-
      modes, missing end-profile) — not assumed, not a repeat of PR
      #119's fix without new evidence
- [ ] TASK 1: probes at X=15/50/865/900 stated with boundary-point
      structure, same rigor as PR #119's X=400 probe
- [ ] TASK 2: full kinetic sweep 0–120°, `Simple: yes` throughout, zero
      collision against every fixed part, re-verified after margin change
- [ ] TASK 3: passage shape confirmed profile-derived, not a rectangle;
      chamfer-zone conflict explicitly checked and stated either way
- [ ] TASK 4: real clearance value stated for grate-vs-shell after fix
- [ ] No undefined variable warnings in SCAD
- [ ] Version incremented — `BBQ-chambers-v5.scad`, v4 kept unchanged
- [ ] `BBQ-understructure.scad` / `BBQ-offset-smoker-base-v1.scad`
      include bump (v4→v5) re-verified clean, same flagged-not-silent
      pattern as prior version bumps
- [ ] 4-angle screenshots (iso/front/side/rear) + 1 lid-open view
      showing both ends of the chamber clearly (not just center span)

## 7. MANDATORY CLOSING

1. Prepend `cc_chat_log.md` — newest entry at TOP, under 10 lines:
   state the TASK 1 root cause finding explicitly (this is the most
   important line in the entry — Janis needs to know definitively why
   PR #119 didn't work), plus one line each for TASK 2/3/4 results.
2. Archive this prompt → `/prompts/archive/` ✅ COMPLETE — 2026-07-15
3. Update `knowledge.map` if any new files created (none expected)
4. Bump version on all changed files
5. **Update `CURRENT_STATE.md`** — two entries:
   - BBQ Offset Smoker: replace the stale (currently BBQ-absent) entry
     with the real current state — chambers at v5 pending this prompt's
     result, understructure still v1-placeholder (v2 prompt written,
     intentionally held by Janis until chambers is confirmed clean),
     `firebox_drop=200mm` still open, `lid_hardware()` still disabled.
   - VM-02: add an entry — paused at v3 on main, PASS, no open items,
     Janis-confirmed pause as of 2026-07-15. (This did not have a proper
     paused entry before — add it now, this is not optional.)
6. Commit all → merge to main
