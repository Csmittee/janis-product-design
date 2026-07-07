# cc Prompt — Fix show_shell_top/show_shell_bottom Toggles + Isolate
# Bottom-Left-Corner Hole + Remove Door Top Steel-Bar Patch (v50 QA)
# Date: 2026-07-07
# Source: vending-machine/VM-01-base/VM-01-base-v50.scad (current ACTIVE)
# Scope: DEBUG TOGGLES (Tasks 1-2, no geometry change) + ISOLATION/
# DIAGNOSIS ONLY, NO FIX (Task 3) + REAL FIX, already root-caused by
# Janis (Task 4). Task 4 is the only structural geometry change in this
# prompt.

## 1. CC INTRO
git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → cc_chat_log.md (first 3 entries) →
rules-dimensions.md → PART_MANIFEST.md (VM-01) →
vending-machine/VM-01-base/VM-01-base-v50.scad (current committed source).
State every file read before writing anything.

## 2. CONTEXT

Janis ran her own spy test in "open" (C2) render mode, toggling each
`show_shell_*` boolean to false one at a time and rendering:

- `show_shell_back = false` → back panel correctly removed. Confirmed
  working.
- `show_shell_left = false` → left panel correctly removed. Confirmed
  working.
- `show_shell_right = false` → right panel correctly removed. Confirmed
  working.
- `show_shell_top = false` → **top panel does NOT disappear.** Screenshot
  confirms geometry unchanged, annotated "can not remove top."
- `show_shell_bottom` → **this variable does not exist in the file at
  all.** Only `show_shell_back/top/left/right` are declared near line
  1710-1714; there is no bottom equivalent, so there is nothing to set.

This blocks Janis's ability to visually inspect the interior for the
still-open door-closed-only manifold warning (flagged in a prior QA
round) — she cannot see inside from above or below without these two
working.

Separately, and NOT yet explained: with several shell panels removed in
this test, a small unexplained hole/gap became visible at the BOTTOM-LEFT
corner of the model — NOT the top (correction from an earlier draft of
this prompt). Janis describes it as sandwiched/hidden when viewed from
above (a highlighted cut edge is visible from the top, but no actual
opening shows there), and only visible as a real hole when viewed from
underneath, at the bottom-left corner. This is very likely the SAME
defect Janis flagged in a prior QA round as "strange cut on the bottom
left corner shell" (unexplained notch/cutout, screenshot from that
session showed the same general area) — treat these as one defect to
diagnose together, not two. This may or may not be related to the door-
closed manifold warning. It has NOT been diagnosed. This prompt asks for
isolation and reporting only — do not attempt a fix this round.

## 3. NEW FILES
None. Edits to existing VM-01-base file, new version v50→v51.

## 4. TASKS

### TASK 1 — Root-cause and fix `show_shell_top`

Locate where `show_shell_top` is declared and trace whether ANY cutout
inside `outer_shell_debug()` (or wherever the top panel geometry lives)
actually references it. Per file history: `outer_shell_debug()` was
substantially rewritten from scratch in v43 (door-datum rebuild); it's
suspected this variable was never reconnected to the geometry after that
rewrite and has been a dead/orphaned parameter since. Confirm this
explicitly — state in cc_chat_log whether it was found disconnected, or
whether the real cause is something else (e.g., wrong condition, wrong
panel referenced) — do not assume the hypothesis is correct without
checking.

Fix it so `show_shell_top = false` correctly removes ONLY the top panel,
mirroring how `show_shell_back/left/right` already work correctly
(same construction pattern — find and reuse it).

### TASK 2 — Add `show_shell_bottom`

Add a new `show_shell_bottom` boolean, declared alongside the existing
`show_shell_*` toggles, following the exact same naming/comment
convention ("set false for C2 export"). Wire it to remove the bottom
panel only, using the same construction pattern as Task 1's fix. State
in cc_chat_log the exact geometry/cutout this now controls.

### TASK 3 — Isolate (do NOT fix) the bottom-left-corner hole

With Tasks 1-2 done, render with `show_shell_top = false` and
`show_shell_bottom = false` (plus back/left/right as needed) in "open"
mode, and separately check both `door_open = true` and `door_open =
false`. Look specifically at the BOTTOM-LEFT corner of the shell — this
is very likely the same defect as a prior QA round's "strange cut on the
bottom left corner shell" finding; check both descriptions against the
same geometry rather than treating them as unrelated. Report:

- Confirm (or rule out) whether this is in fact the same defect as the
  prior "bottom left corner" finding — state which
- Why it's only visible from underneath and not from above — Janis
  describes a cut edge/highlight visible from the top with no actual
  opening showing there, but a real hole visible from below; identify
  what's "sandwiching"/covering it from the top view
- Whether the hole Janis found is present in both door states or only
  one (this determines whether it's related to the door-closed-only
  manifold warning or is an unrelated, always-present opening)
- Which module/feature actually produces the opening — do not guess; if
  uncertain after a real search, state that explicitly rather than
  naming the nearest plausible module
- Whether it appears to be a genuine gap in the shell's own watertight
  boundary (i.e., could plausibly cause a 2-manifold warning) or is
  something else (e.g., a debug-cutout artifact, an already-intentional
  vent/access opening, a rendering artifact of the toggle removal itself)

Do not patch, close, or modify this opening in this prompt. Isolation and
reporting only — a fix (if one is even appropriate; it may be
intentional) comes in a follow-up prompt once the cause is confirmed.

### TASK 4 — Door top steel-bar patch: remove and fill shell material instead

Already root-caused by Janis (screenshots this QA round) — this task can
be fixed directly, not just isolated. When the acrylic pane was shortened
and pushed down from the top edge in a prior round (v47's acrylic-fix
work), the gap this created at the top of the door was patched with a
steel bar sitting on top of the acrylic — a cosmetic "fake it's steel"
patch, not a real structural fill. Janis's own words: "he should add
shell material on this space, not patch it with a steel bar on top of the
acrylic." Confirm first: when `show_acrylic = false`, does the steel bar
disappear too (i.e., is it actually attached to/dependent on the acrylic
piece rather than being its own independent shell feature)? Janis
observed exactly this — the bar vanishing along with the acrylic — as
evidence it's a patch, not real shell material.

The door's lower section (near the flap) already handles this correctly
— shell material fills that zone directly, with no separate patch piece.
Find that construction and mirror it: remove the steel bar entirely, and
extend the door's own shell/metal-panel material to fill the space
instead, so that in the finished door, the acrylic pane is the only
material visible/attached at the back in that zone — no redundant steel
strip layered on top of it.

Also check (per your own v48/v49 TODO note on this exact area): whether
this steel bar is the same object suspected of causing the door-close
collision ("suspect this bar left over from acrylic adjustment cause the
collision on door close," Janis's annotation this round). If removing it
and filling with real shell material also resolves that collision, state
so explicitly; if the collision persists after this fix, say so rather
than assuming it's resolved.

## 5. DO NOT TOUCH

- `tray_zone_frame()`, `left_zone_door()`, `drop_zone_guards()`,
  `tray_compartment_partition()`, `exit_compartment_wall()` — all
  previously verified geometry, out of scope
- `show_shell_back`, `show_shell_left`, `show_shell_right` — already
  confirmed working, do not modify
- Any dimension in `rules-dimensions.md` — this prompt is toggle-wiring
  + diagnosis only
- The still-open door-closed-only manifold warning itself — Task 3 only
  gathers evidence toward it; Task 4 may resolve it as a side effect but
  do not force-claim resolution if the collision persists after the fix
- The door's lower/flap-area shell fill (Task 4's reference pattern) —
  read and mirror it, do not modify it
- Any PR-01 file

## 6. QA VERIFICATION

- [ ] Root cause of `show_shell_top` malfunction stated explicitly
      (confirmed disconnected geometry, or actual real cause if different)
- [ ] `show_shell_top = false` now correctly removes the top panel only —
      confirmed via render
- [ ] `show_shell_bottom` added, follows existing naming convention,
      correctly removes bottom panel only — confirmed via render
- [ ] `show_shell_back/left/right` behavior unchanged — confirmed
- [ ] Bottom-left-corner hole checked in BOTH `door_open = true` and
      `door_open = false` — result stated for each
- [ ] Confirmed (or ruled out) as the same defect as the prior "strange
      cut on bottom left corner shell" finding
- [ ] Explained why the hole is invisible from above but real from below
- [ ] Responsible module/feature for the hole identified, or explicitly
      flagged as unresolved — no guessed attribution
- [ ] Hole NOT modified/patched this round — confirmed untouched
- [ ] Confirmed whether the top steel bar disappears with
      `show_acrylic = false` (i.e., was dependent on the acrylic piece)
- [ ] Steel bar removed, door's own shell material extended to fill the
      space instead — mirrored from the flap-area's existing correct
      pattern, exact reference construction stated
- [ ] Confirmed whether this also resolves the suspected door-close
      collision from this same bar — stated explicitly either way
- [ ] No NEW manifold warnings introduced by Tasks 1-4 (pre-existing
      warning explicitly out of scope unless Task 4 is confirmed to
      resolve it)
- [ ] Version incremented v50 → v51, v50 untouched

## 7. MANDATORY CLOSING

1. Prepend `cc_chat_log.md` — newest entry at TOP, under 10 lines: root
   cause of show_shell_top, confirmation both toggles now work, hole
   isolation findings (door-state dependency + responsible
   module-or-flagged-unresolved), steel-bar removal + shell-fill
   confirmation, and whether the door-close collision is resolved
2. Archive this prompt → `/prompts/archive/` ✅ COMPLETE — 2026-07-07
3. Update `knowledge.map` with the show_shell_bottom addition
4. No dimension file changes expected — confirm explicitly if none needed
5. Commit all → merge to main
