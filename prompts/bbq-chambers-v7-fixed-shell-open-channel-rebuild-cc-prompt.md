# CC PROMPT — bbq-chambers-v7-fixed-shell-open-channel-rebuild
# Date: 2026-07-15
# Repo location: bbq-offset-smoker/BBQ-chambers-v7.scad (new, source v6)
# Single-focus fix prompt. This is R-111 territory — 3 confirmed real
# failures on "chamber reads solid, not hollow" (PR #119 color/opacity —
# FAIL; v5's own end-cap gap — separate bug, fixed but didn't resolve
# this; PR #121's lid_territory_end_caps() hollow rebuild — FAIL, wrong
# module). Root cause below was found and verified via LOCAL OpenSCAD
# render (SKILL_local_render.md) before writing this — not a 4th guess.

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order, state every file read before writing a single line:
1. cc_rules.md
2. knowledge.map
3. cc_chat_log.md (first 3 entries — newest at top, includes PR #121's
   own entry — read it, this prompt fixes a DIFFERENT module than that
   one touched)
4. bbq-offset-smoker/rules-bbq-fab.md
5. bbq-offset-smoker/SKELETON_WORKSHEET.md
6. bbq-offset-smoker/BBQ-chambers-v6.scad — the LIVE file, in full.
   Pay specific attention to `fixed_shell_profile()`, `chamber_outer_tube()`,
   `chamber_inner_cavity()`, `chamber_shell()`, and `lid_territory_end_caps()`
   — state the exact current line ranges for each.
7. .claude/rules-codes.md

Claude Web override: none.

Before writing any fix (per R-009): confirm whether `fixed_shell_profile()`'s
point list is referenced anywhere else in the file besides
`chamber_outer_tube()`/`chamber_inner_cavity()` — state this explicitly.

## 2. CONTEXT

**Root cause (confirmed via local OpenSCAD render, not guessed):**
`fixed_shell_profile()` is a 7-point CLOSED polygon. Points 3→4 (its own
comments call this "PARTING START" / "PARTING END" — apex A to ridge
midpoint) are NOT a real edge of the octagon — they're a straight line
added only so the profile could close as a valid extrudable polygon. The
file's own header comment rationalizes this as "the internal seam face
only (hidden when lid is closed)" — true when closed, but this profile
is extruded the FULL length of the lid's open territory
(`chamber_outer_tube()`/`chamber_inner_cavity()`), so that "seam" becomes
a real, permanent, wall_t-thick panel spanning the entire open-lid
sightline. That's exactly what Janis found: "a flat surface cover from
apex A to mid of face C-D at every angle of glaze."

PR #121's fix targeted `lid_territory_end_caps()` (a different, smaller
module covering only the 100mm end margins) — that fix was real and
correct for what it touched, but it never touched
`fixed_shell_profile()`/`chamber_outer_tube()`, which is why the symptom
persisted after that PR merged.

**Verified fix (local render, 5 angles, confirmed no diagonal panel,
confirmed independent end-cap visibility):** build the TRUE closed
8-point octagon (real edges only, no fake diagonal — points below), form
the wall_t hollow ring the normal way (extrude outer, subtract
offset(-wall_t) inner, same pattern this file already uses everywhere
else), THEN split fixed-vs-lid territory using a flat CUTTING PLANE
(intersection() with a wedge) through the real apex-A-to-ridge-midpoint
line — not by giving the profile itself a fake closing edge. A plane
cutting through a real hollow ring exposes only the wall's true
wall_t cross-section at the cut — never a spanning panel.

## 3. NEW FILES

None. New `BBQ-chambers-v7.scad` (source v6), per file-versioning
convention.

## 4. TASKS

### TASK 1 — Rebuild the true octagon profile (no fake diagonal)

Add a new module — real edges only, no parting-line point:

```openscad
// TRUE octagon — 8 real vertices, no fake diagonal edge anywhere.
// Replaces fixed_shell_profile()'s closed-with-seam approach for the
// main tube. Same hex_pt(h,w) encoding already used in this file.
module true_octagon_profile() {
    polygon(points=[
        hex_pt(0, chamber_W - chamfer),           // floor, right end
        hex_pt(0, chamfer),                       // floor, left end
        hex_pt(chamfer, 0),                        // apex A — real wall/chamfer corner
        hex_pt(chamber_H - chamfer, 0),             // left wall top
        hex_pt(chamber_H, chamfer),                 // ridge, left end
        hex_pt(chamber_H, chamber_W - chamfer),      // ridge, right end
        hex_pt(chamber_H - chamfer, chamber_W),      // right wall top
        hex_pt(chamfer, chamber_W),                  // right wall bottom
    ]);
}
```

Verify this against the file's own real dimensions
(chamber_W/chamber_H/chamfer) before proceeding — confirm it's a valid,
non-self-intersecting 8-point polygon (state boundary check result).

### TASK 2 — Rebuild chamber_outer_tube() / chamber_inner_cavity() using a real cutting plane, not a fake edge

Replace the body of `chamber_outer_tube()` and `chamber_inner_cavity()`
(the ones that extrude `fixed_shell_profile()` across the LID_X0..LID_X1
open-lid span — NOT `lid_territory_end_caps()`, which stays untouched)
with:

1. Full wall_t hollow ring of `true_octagon_profile()`, extruded across
   the same X-range these modules already use.
2. A cutting wedge polygon that keeps only the FIXED (non-lid) side of
   the real apex-A → ridge-midpoint line:

```openscad
// Cutting wedge — keeps the FIXED side (floor + apex A + left wall +
// left chamfer + half ridge). Ridge midpoint is used here only as a
// cut-plane reference point, NOT as a profile vertex (see TASK 1 — it's
// not a real corner).
module fixed_side_wedge() {
    polygon(points=[
        hex_pt(chamfer, 0),              // apex A
        hex_pt(0, 0),
        hex_pt(0, chamber_W),
        hex_pt(chamber_H, chamber_W),
        hex_pt(chamber_H, chamber_W/2),   // ridge midpoint (cut reference only)
    ]);
}
```

Intersect the true octagon ring with this wedge (extruded across the
same X-range) to produce the fixed shell. State the real CGAL result —
`Simple: yes` — and confirm via cross-section probe at 3 points along the
span (not just one, per the earlier PR #119 lesson about single-point
probes) that no material exists spanning the apex-to-ridge-midpoint line
anywhere in the LID_X0..LID_X1 range.

Preserve the existing `window_hole()` and `exhaust_room_opening()`
subtractions exactly as they are now — apply them the same way, after
this rebuild, no change to those two modules.

### TASK 3 — Confirm lid_territory_end_caps() is untouched and still correct

State explicitly that `lid_territory_end_caps()` (PR #121's fix) is
unchanged by this prompt, and re-verify it still correctly joins to the
NEW true-octagon-based main tube at the LID_X0/LID_X1 boundary — a real
`intersection()` probe at both boundary planes, confirming no gap and no
overlap between the rebuilt main tube and the (unchanged) end caps.

## 5. DO NOT TOUCH

- `lid_territory_end_caps()` — PR #121's fix, already correct, do not
  rebuild
- `lid_profile()` / lid geometry itself — unchanged
- `window_hole()`, `exhaust_room_opening()` — unchanged, only re-applied
  to the new tube
- `firebox_shell()`, `fire_grate()`, `ash_tray()`, `firebox_door()` —
  unchanged
- `firebox_passage()` profile-derived cut (PR #121) — unchanged, separate
  open item
- `grill_grate()` Z-position (PR #121's GRATE_Z=750) — unchanged, separate
  open item
- `firebox_drop = 200mm` — still open, not this prompt
- `lid_hardware()` — still disabled, not this prompt
- Exhaust room position — separate open item (not this prompt — Claude
  Web has a follow-up for this)
- Understructure — separate file, out of scope
- rules-dimensions.md, cc_rules.md — read only

## 6. QA VERIFICATION

- [ ] TASK 1: true_octagon_profile() confirmed valid (non-self-intersecting,
      8 real points), boundary check stated
- [ ] TASK 2: real CGAL `Simple: yes` on the rebuilt fixed shell
- [ ] TASK 2: cross-section probes at 3 points along LID_X0..LID_X1 (not
      just one) confirm NO material spans apex-A-to-ridge-midpoint at any
      of them
- [ ] TASK 3: boundary probe at both LID_X0 and LID_X1 confirms clean
      join to the unchanged `lid_territory_end_caps()` — no gap, no
      overlap
- [ ] Full kinetic sweep (lid 0/15/30/60/90/120°) — `Simple: yes` at
      every step, re-verified after rebuild
- [ ] Full `BBQ-offset-smoker-base-v1.scad` assembly chain render —
      `Simple: yes`
- [ ] Visual: lid-open render (iso angle AND a straight-on angle looking
      directly into the opening — both, not just one) must clearly show
      the grate and the far interior wall through the opening, with NO
      diagonal panel visible from either angle
- [ ] No undefined variable warnings

## 7. MANDATORY CLOSING

1. Prepend `cc_chat_log.md` — newest entry at TOP, under 10 lines: state
   plainly that this fixes a DIFFERENT module than PR #121 (name both:
   `fixed_shell_profile()`/`chamber_outer_tube()` here vs
   `lid_territory_end_caps()` there), state the 3-point probe result
2. Archive this prompt → `/prompts/archive/` ✅ COMPLETE — 2026-07-15
3. Update `knowledge.map` if any new files created (none expected)
4. Bump version — `BBQ-chambers-v7.scad`, v6 kept unchanged
5. Update `BBQ-understructure.scad` / `BBQ-offset-smoker-base-v1.scad`
   include v6→v7
6. Commit all → merge to main
