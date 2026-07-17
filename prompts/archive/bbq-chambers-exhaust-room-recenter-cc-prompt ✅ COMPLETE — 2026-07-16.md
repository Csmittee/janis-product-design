# CC PROMPT — bbq-chambers-exhaust-room-recenter
# Date: 2026-07-16
# Repo location: bbq-offset-smoker/BBQ-chambers-vN.scad (source = latest
# merged version on main at run time — if v9 firebox-passage fix has
# already merged, source that; otherwise source v8. State which.)
# Small, single-focus fix — exhaust room vertical position only.

## 1. CC INTRO

Session continuity check (cc self-determines): if this runs in the same
session as the firebox-passage fix (v9) with no git pull since, treat as
CONTINUATION — skip re-reading cc_rules.md/knowledge.map/cc_chat_log.md,
state "Continuation" and go straight to TASKS. Otherwise FRESH:

```
git fetch --all && git checkout main && git pull origin main
```
Read cc_rules.md → knowledge.map → cc_chat_log.md (first 3 entries) →
the live BBQ-chambers file (latest version on main) in full. State the
exact current `ROOM_BASE_Z`/`ROOM_TOP_Z` values and formula found.

Claude Web override: none.

R-009 duplication check: confirm `ROOM_BASE_Z`/`ROOM_TOP_Z` aren't
referenced or duplicated anywhere else in the file before changing them.

## 2. CONTEXT

The exhaust room has never actually sat where Janis wanted — every prior
placement (v3's original formula, and Claude Web's own v8 "max-flush"
recompute) used a wrong assumption about where the octagon's flat
vertical wall zone starts. Corrected math:

The flat vertical wall zone is `[chamber_floor_z + chamfer,
chamber_floor_z + chamber_H - chamfer]` — NOT `[chamber_floor_z,
chamber_floor_z + trough_h]` as every prior formula assumed. The bottom
chamfer sits BELOW the flat wall zone, not included in it. With the
corrected chamfer (178.665mm) and chamber_H=610:
```
real wall zone = [778.665, 1031.335]
```
Janis wants the room's own vertical center aligned to the octagon's true
center — `chamber_floor_z + chamber_H/2` = **905** — which sits
comfortably inside the real wall zone (855–955 room span, well within
778.665–1031.335). No angled mounting face, no redesign — this is a pure
position correction.

## 3. NEW FILES

None. Bump version by one from whatever the source file is (state
source and new filename explicitly in your response).

## 4. TASKS

### TASK 1 — Recenter the exhaust room

Change:
```
ROOM_BASE_Z = chamber_floor_z + chamber_H/2 - ROOM_H/2   // 855
ROOM_TOP_Z  = ROOM_BASE_Z + ROOM_H                          // 955
```
(Real formula, not hardcoded numbers — so it stays correct if chamber_H
or ROOM_H ever change.)

Verify: confirm both values land inside the real flat wall zone (state
the zone boundaries you compute, don't just trust this prompt's numbers
— recompute from the live file's own chamfer/chamber_H). If they don't
fit for any reason (e.g. ROOM_H has changed since this prompt was
written), flag it — do not silently force the position.

Re-verify `exhaust_room_opening()`'s cut into the end cap still aligns
correctly at the new Z position — real CGAL check, not assumed.

## 5. DO NOT TOUCH

- `ROOM_D`, `ROOM_H` — unchanged, position only
- Everything from the firebox-passage fix (if run in the same session) —
  don't re-touch `firebox_passage_profile()`, `true_octagon_profile()`,
  `fixed_side_wedge()`
- Chimney pipe construction — verify it still sits correctly on the
  relocated room's top face, but don't redesign it
- Everything else — unchanged

## 6. QA VERIFICATION

- [ ] Real wall zone boundaries recomputed from the live file, stated
- [ ] ROOM_BASE_Z/ROOM_TOP_Z confirmed formula-derived, not hardcoded
- [ ] Both values confirmed inside the real wall zone
- [ ] `exhaust_room_opening()` cut re-verified against new position
- [ ] Chimney pipe still sits correctly on the room's new top face
- [ ] Full kinetic sweep (0-120°) — `Simple: yes`
- [ ] Full assembly chain render — `Simple: yes`
- [ ] Render showing the room's new position relative to the end cap
      (side view, similar angle to Janis's own reference screenshot)
- [ ] No undefined variable warnings

## 7. MANDATORY CLOSING

1. Prepend `cc_chat_log.md` — newest entry at top, under 10 lines: state
   the corrected wall-zone math, new ROOM_BASE_Z/ROOM_TOP_Z, confirm this
   is a position-only change
2. Archive this prompt → `/prompts/archive/` ✅ COMPLETE — 2026-07-16
3. Bump version on the changed file; update includes
4. Commit all → merge to main
