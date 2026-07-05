# cc Prompt — Partition Depth Fix + Drop-Zone-Guard Overextension Fix
# Date: 2026-07-05
# Session goal: fix confirmed partition/frame collision; fix confirmed
# drop_zone_guards() overextension through the door plane at closed position
# (both root causes confirmed by Janis, no diagnosis needed).
# Built on real merged PR #88 (VM-01-base-v46.scad).

## 1. CC INTRO
git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → cc_chat_log.md (first 3 entries) → rules-dimensions.md
→ VM-01-base-v46.scad (confirm this is actually the tip of main — state the result)

Do NOT assume the next version number is v47. Check main for the actual current
tip filename and increment from there. State the resulting new filename
explicitly in cc_chat_log — do not let this drift again (v45→v46 naming
mismatch happened once already this project, do not repeat it).

## 2. CONTEXT

Janis ran manual isolation testing on v46 (toggle true/false, confirmed correct
per Toggle-Completeness wiring) and found TWO INDEPENDENT manifold problems,
not one. Do not conflate them or attempt one blind combined fix — diagnose and
fix each separately, in the order below.

**Problem 1 — confirmed root cause, fix now:**
`tray_compartment_partition()` (added v46) currently extends too far toward
the front of the compartment and physically overlaps `tray_zone_frame()`.
Present regardless of door open/closed state (confirms it's a static,
door-independent collision between two fixed parts). Janis confirmed via
testing: removing the partition removes this specific error.

Functional requirement, not just a clearance fix: the partition must stop at
the REAR-facing extent of the spring mechanism (i.e. "just below the spring
end") — it must NOT reach all the way to the front frame. If it extends to
the front, a dropped item lands on top of the partition instead of falling
through the compartment's front opening and gets physically stuck. This is a
functional dimension, not an arbitrary clearance number — identify the actual
existing constant for the spring's rearward extent in source (do not invent a
new magic number) and reference it directly.

**Problem 2 — ROOT CAUSE CONFIRMED by Janis via visual render, fix directly:**
With the partition entirely removed (isolating Problem 1 out of the picture):
- Door OPEN → zero manifold error
- Door CLOSED (door_open_deg = 0) → manifold error PERSISTS

Janis confirmed by direct visual inspection (closed-door render, close-up on
the hinge-side edge) that `drop_zone_guards()` (v43 §2.6) physically pokes
through the door's surface plane when the door is closed — visible as the
guard's edge protruding past the door face in the render. This is the sole
cause of Problem 2. It is NOT the hinge geometry and NOT the frame inset —
do not touch either of those.

Required fix: reduce `drop_zone_guards()`'s front-most (Y-axis, toward-door)
extent so it does not exceed `tray_zone_frame()`'s own front-most face minus
that frame's material thickness — i.e. the guard's edge must stay at or
behind (never past) the inner frame's front face, accounting for the frame's
own wall thickness, not just its centerline. Use the frame's actual material-
thickness constant already in source (do not invent a new one). If for any
reason that exact reference can't be cleanly derived, Janis's explicit
fallback is acceptable: pull the guard's front-most extent back by a flat
10mm as a safe margin — but prefer deriving it from the frame's real face
+ thickness if straightforward.

## 3. NEW FILES
None — modifications to the new version of VM-01-base only.

## 4. TASKS

### TASK 1 — Fix tray_compartment_partition() depth overrun

Identify the actual variable/constant in source that defines the spring
mechanism's rearward-most extent (search for the spring length / travel
constant already used elsewhere in the tray module — do not introduce a new
one). Change `tray_compartment_partition()`'s forward (Y-axis, toward-door)
extent to stop at that reference point, instead of its current extent that
reaches `tray_zone_frame()`.

Add a comment at the change stating the actual functional reason (gift-drop
clearance), plus a Rule M-3-style contact-receipt comment showing the gap to
`tray_zone_frame()` in mm.

Re-verify via CGAL: `intersection(){ tray_compartment_partition();
tray_zone_frame(); }` — must be empty. State the result explicitly.

Confirm unchanged: full width/depth-otherwise, fixed/welded, zero gap to
`exit_compartment_wall()` (from v46 Task 1) — do not regress that fix while
correcting the depth.

### TASK 2 — Fix drop_zone_guards() over-extension (root cause confirmed)

`drop_zone_guards()` currently extends far enough in the front (Y) direction
that its edge pokes through the door's surface plane at closed position —
confirmed by Janis via direct visual render inspection, not a guess. Do not
re-diagnose; go straight to the fix.

Identify `tray_zone_frame()`'s own front-most face position and its material
thickness constant (already in source — use it, do not invent a new one).
Reduce `drop_zone_guards()`'s front-most extent so it never exceeds that
frame face minus the frame's own wall thickness — the guard's edge must sit
at or behind the frame's real front face, not just its centerline. If that
exact reference can't be cleanly derived from existing constants, Janis's
explicit fallback is acceptable: pull the guard back by a flat 10mm as a
safe margin. State in cc_chat_log which approach was used and the resulting
gap in mm.

Add a Rule M-3 contact-receipt comment at the change showing the corrected
gap to the door at closed position (door_open_deg = 0).

Do NOT touch `tray_zone_frame()`, the hinge geometry, or the shell's hinge
recess cutout — none of these are the cause, confirmed by Janis's render.

## 5. DO NOT TOUCH
- `show_acrylic` / metal-panel split, `show_sensor`, `show_frame` wiring —
  already confirmed correct in v46, do not regress
- H-frame flange (10mm top/bottom) — already correct in v46
- `exit_compartment_wall()` position — already correct, only the partition's
  depth is wrong
- `rules-dimensions.md` — only add the new spring-end reference note and the
  corrected gap value; do not touch unrelated rows
- Any VM-1.1/VM-1.2/Satu variant or PR-01 files

## 6. QA VERIFICATION
- [ ] `tray_compartment_partition()` now stops at the spring's rearward
      extent — state the exact reference constant used and resulting Y depth
- [ ] `intersection(){ tray_compartment_partition(); tray_zone_frame(); }`
      confirmed empty
- [ ] `drop_zone_guards()` front-most extent reduced to at/behind
      `tray_zone_frame()`'s front face minus its material thickness (or the
      flat 10mm fallback) — state which approach was used and the resulting
      gap in mm at door_open_deg = 0
- [ ] `tray_zone_frame()`, hinge geometry, and shell hinge recess confirmed
      UNTOUCHED (not the cause, do not modify)
- [ ] Full re-run: 9-angle sweep (0,20,25,30,35,40,45,70,100) for
      `intersection(){ left_zone_door(); drop_zone_guards(); }` — zero
      non-empty at all angles, explicitly stated per angle
- [ ] Partition-frame pair also re-confirmed empty in the same sweep
- [ ] No undefined-variable or manifold warnings on full render
- [ ] New version number determined from actual main tip, stated explicitly,
      not assumed

## 7. MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP, under 10 lines, MUST include
   the spring-end reference used, the door-closed root cause finding, and the
   full pairwise sweep result summary
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Update knowledge.map
4. Bump version on all changed files
5. Commit all → merge to main
