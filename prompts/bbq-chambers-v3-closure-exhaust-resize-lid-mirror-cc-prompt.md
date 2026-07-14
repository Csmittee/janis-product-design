CC PROMPT — bbq-chambers-v3-closure-exhaust-resize-lid-mirror
================================================================
Repo location: bbq-offset-smoker/BBQ-chambers-v2.scad (edit in place,
save as v3)

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order, state every file read before writing a single line:
1. cc_rules.md
2. knowledge.map
3. cc_chat_log.md (first 3 entries — newest at top, including your own
   v2 entry — read your own prior findings before changing anything)
4. bbq-offset-smoker/rules-bbq-fab.md
5. bbq-offset-smoker/SKELETON_WORKSHEET.md
6. bbq-offset-smoker/BBQ-chambers-v2.scad (the LIVE file, in full —
   read your own actual built values, do not assume v2's prompt
   numbers are what's still in the file; you made real corrections
   during v2's build that this prompt doesn't have visibility into)
7. .claude/SKILL_joint_construction.md
8. .claude/rules-codes.md

## 2. CONTEXT

Janis reviewed the merged v2 build (real hardware photos + labeled
diagrams) and found 3 issues. This prompt also locks a standing
orientation convention that was previously undocumented — add it to
governance so it's never re-guessed in a future session.

Two of your own v2 PR findings are directly relevant here, read them
before starting:
- You correctly found the endcap opening is a RECTANGLE, not a
  semicircle (the prompt's language was wrong, you built the real
  shape). Keep using "rectangular opening" terminology going forward.
- You correctly proved a 127mm pipe cannot be inscribed in a 200mm
  room's semicircular footprint (max inscribable = 100mm) and had to
  route around it with real overhang. TASK 2 below fixes this at the
  source (bigger room) rather than continuing to route around it.

## 3. NEW FILES

None. Editing bbq-offset-smoker/BBQ-chambers-v2.scad in place.

## 4. TASKS

### TASK 1 — Close the firebox-to-chamber bottom gap

Real defect, confirmed visually by Janis: firebox_floor_z sits
firebox_drop (200mm) below chamber_floor_z. The firebox's chamber-
facing wall is currently open for its FULL height (per the existing
no-double-wall precedent, which is correct for the portion that
actually faces the chamber's own window_hole) — but for the portion
BELOW chamber_floor_z, there is no chamber wall behind it at all (the
chamber doesn't extend below its own floor), so that strip is a real
unclosed hole, not a designed opening.

Fix: add a solid wall_t panel closing the firebox's chamber-facing wall
specifically for the range Z: firebox_floor_z to chamber_floor_z (the
200mm step). Leave the existing opening UNCHANGED for Z ≥
chamber_floor_z (that portion correctly stays open, matching
window_hole). State the exact Z-range of the new closing panel in
cc_chat_log, and confirm via a real intersection() probe that no gap
remains anywhere on that face.

### TASK 2 — Resize the exhaust room (too small, too thick)

Your own v2 analysis proved the 127mm pipe cannot fit the 200mm room's
inscribed circle. Resize:
```
ROOM_D = 360   // was 200 — inscribes a ~180mm circle, real margin over
               // the 127mm pipe, no forced overhang needed
ROOM_H = 100   // was 200 — halves the "thickness" complaint
```
Re-derive every position/coordinate that depended on the old ROOM_D/
ROOM_H (room placement on the wall, the endcap rectangular opening
size, the pipe's mounting hole and its overhang fix from v2) — do not
leave stale numbers computed from the old 200/200 values. Re-verify the
pipe now sits within the room's real inscribed-circle margin — state
the actual numbers (inscribed diameter vs pipe diameter) in cc_chat_log,
not just "fits now."

Endcap opening: confirm again it's a rectangle (ROOM_D wide x ROOM_H
tall) per your own v2 finding — keep that terminology, don't revert to
"semicircle."

### TASK 3 — Mirror the lid to the correct side

New standing rule (see TASK 4 — lock this in governance too): when a
person faces the smoker, the exhaust end is on their LEFT, the firebox
end is on their RIGHT, and the lid must open TOWARD the user. The
current lid (v2) opens on the wrong side per Janis's review.

Mirror the lid's Y-placement: swap every `chamber_W` / `chamber_W -
chamfer` term for its `0` / `chamfer` mirror in both the fixed-shell
profile and the lid's own profile (and vice versa) — i.e. flip which
side (Y=0 vs Y=chamber_W) is fixed shell and which is lid. The parting
point moves from its current vertex to the mirrored vertex on the
opposite wall; the hinge stays at the ridge midpoint (unchanged — the
midpoint doesn't move under a Y-mirror). Re-verify the same acute-angle
concern you already solved in v2 (flat cube() panels, not offset()) —
confirm it's still clean after the mirror, don't assume symmetry
guarantees it.

State explicitly in cc_chat_log which world-Y side is now fixed shell
and which is lid, referencing "the side nearer Y=0" / "the side nearer
Y=chamber_W" in addition to any A/B/C/D-style labels, so this is
unambiguous for future sessions.

## 5. DO NOT TOUCH

- `firebox_shell()`, `fire_grate()`, `ash_tray()`, `firebox_door()`
  geometry itself — only the NEW closing panel from TASK 1 is added,
  nothing else in firebox() changes
- `rear_window_hole()` size/position — unchanged
- `firebox_drop = 200` — still not resolved by this prompt
- True octagon profile, end-cap closure fix, hinge line Z-position —
  all correct from v2, unchanged
- `grill_grate()`, `floor_drains()` — unchanged
- `lid_hardware()` — stays disabled, still not respecified
- Understructure — separate file, not in scope
- rules-dimensions.md, cc_rules.md — read only

## 6. QA VERIFICATION

- [ ] Full CGAL manifold sweep, `Simple: yes` on every solid
- [ ] Firebox-to-chamber face confirmed fully closed except the
      existing window_hole opening — real intersection() probe stated,
      not assumed
- [ ] Exhaust room: ROOM_D=360, ROOM_H=100 confirmed; pipe's real
      clearance margin within the inscribed circle stated numerically
- [ ] Rectangular endcap opening confirmed matches new ROOM_D x ROOM_H
- [ ] Lid mirrored: state which Y-side is now fixed vs lid; confirm
      acute-angle join still clean at 0-160deg after the mirror
- [ ] 4-angle screenshots (iso/front/side/rear) + 1 lid-open(120°) angle
      — front view must clearly show the door opening toward the
      correct (Y=0-ish, "customer") side
- [ ] Error-Log clean

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at top, under 10 lines: confirm
   closure fix, state real ROOM_D/ROOM_H/pipe-clearance numbers, confirm
   which Y-side the lid now opens toward, QA results
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-14
3. Update knowledge.map, PART_MANIFEST.md, SKELETON_WORKSHEET.md to
   reflect v3 (same pattern as your own v1→v2 update)
4. Save as BBQ-chambers-v3.scad (v2 kept, per file-versioning
   convention); update BBQ-understructure.scad's include v2→v3 (same
   flagged-not-silent pattern you used for v1→v2)
5. Commit all → merge to main

================================================================
## TASK 4 — GOVERNANCE: lock the orientation convention (rules-bbq-fab.md)

Add a new section to bbq-offset-smoker/rules-bbq-fab.md:

```
## Standing Orientation Convention (locked 2026-07-14)

When a person faces the smoker (the customer/user-facing view):
- The EXHAUST end is always on their LEFT.
- The FIREBOX end is always on their RIGHT.
- The LID/DOOR always opens TOWARD the user (the near side, facing them)
  — never the far side.

In world coordinates (per SKELETON_WORKSHEET.md's MASTER ORIGIN):
exhaust = DATUM_X_FRONT (X=0), firebox = DATUM_X_REAR (X=chamber_L).
"Toward the user" = the side nearer Y=0 (confirm/update this line if
TASK 3 above places it differently — state the final confirmed side
here explicitly, do not leave both this doc and the code silently
assuming opposite things).

This convention applies to ALL future BBQ product work — do not
re-derive or re-ask per session.
```

Bump rules-bbq-fab.md's version header accordingly.
