# cc Prompt — Bed/Leg Height Reconciliation + Floor Pad Removal + Standalone Cutaways
# Date: 2026-07-02
# Session goal: fix 3 visual defects found on first render of PR-01-assembly-v29
#   (pole-base-bell-collar-socket-build), reported by Janis before any F6 was run.
# All geometry changes in this prompt (bed_h fix, pad removal, leg_socket
# cutaway) were prototyped and visually verified in Claude Web's local
# OpenSCAD sandbox BEFORE this prompt was written, per SKILL_local_render.md.
# A dormant bug (TASK 1a) was caught this way — the originally-planned bed_h
# change would have silently done nothing without it.

## 1. CC INTRO
git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → cc_chat_log.md (first 3 entries) → rules-dimensions.md →
PR-01-assembly-v29.scad → pole_top.scad → leg_socket.scad
State every file read before writing a single line.

## 2. CONTEXT

Janis reviewed a render of PR-01-assembly-v29 (the bell-collar/leg-socket build from
the previous session) before running F6. Three problems found, root-caused by Claude
Web against the live repo (not guessed):

1. **Bed reads as "sunk" below the new legs.** `leg_socket()` draws its own
   independent wood leg from Z=0 to `leg_h` (600mm). `bed_frame()` (existing,
   `pole_top.scad`) draws a separate, shorter leg (height = `bed_h - surface_t`,
   currently ~470mm) at the SAME `pole_cx`/`pole_cy` footprint, and the bed surface
   itself tops out at `bed_h` = 500mm. The two leg systems were never reconciled —
   this was an open interpretation flag from the prior session, now confirmed as a
   real visual defect. Janis's decision: **raise the bed surface to sit on top of
   the 600mm leg** (not shrink the new leg).
2. **Unexpected pad at the floor.** `leg_socket()` also draws a foot pad (`pad_t`=20mm
   tall, `pad_overhang`=50mm) at Z=0. This came from an earlier CONFIRMED dimensions
   table but had never actually been rendered/reviewed visually until now. Janis's
   decision, stated explicitly in chat: **remove it — not part of the intended
   design.** This explicitly supersedes the earlier CONFIRMED pad_t/pad_overhang
   entry — do not treat this as a silent reversal, it was a direct instruction.
3. **No way to inspect embedded details.** In full assembly, this is fine and should
   stay as-is. But when `pole_top.scad` or `leg_socket.scad` is opened standalone
   (i.e. `ghost_mode()` is true), the solid wood leg / pole body fully hides the
   internal bell-collar thread and the embedded socket bore — there's no way to see
   whether they're actually there. Janis's decision: **add a cutaway in the
   standalone ghost-preview context only** so internal geometry is visible when
   iterating on these files alone. Full-assembly render must be completely unaffected.

## 3. NEW FILES
None. All changes are in-place edits to existing flat files
(`pole_top.scad`, `leg_socket.scad`) plus a version-incremented assembly file.

## 4. TASKS

### TASK 1a — Fix a second dormant self-reassignment bug (`pole_top.scad`, in-place edit)

**Found and confirmed via local OpenSCAD render before writing this prompt** —
this is not a guess. `pole_top.scad` line 68 has the exact same bug class as the
already-fixed pole_cx/pole_cy ghost-leak (fix-pole-cx-cy-override-bug,
2026-07-02):
```
bed_h               = is_undef(bed_h)               ? 500   : bed_h;
```
Under include-flattening this collapses `bed_h` to the hardcoded fallback (500)
regardless of what the assembly sets — it has been dormant/invisible only
because the assembly's value (500) happened to equal the fallback. Local render
proved this: setting `bed_h=600` in the assembly produced a byte-identical
render to `bed_h=500` until this line was removed.

Fix, same pattern as the pole_cx/pole_cy fix — remove the reassignment, replace
with a comment, and add a LOCAL-only fallback inside the ghost-context stanza
(the only place in this file that uses `bed_h` outside a module body):

Remove:
```
bed_h               = is_undef(bed_h)               ? 500   : bed_h;
```
Replace with a comment noting removal and reason (state explicitly in
cc_chat_log that this was removed and why).

In the `if (ghost_mode()) { ... }` block, change:
```
    ghost_cx = is_undef(pole_cx) ? 90 : pole_cx[0];
    ghost_cy = is_undef(pole_cy) ? 60 : pole_cy[0];
    pole_top(ghost_cx, ghost_cy);
    ghost_neck_top = xbar_z - housing_r_circ;
    ghost_body_h   = (ghost_neck_top - neck_h) - bed_h;
    color("gray", 0.3)
        translate([ghost_cx, ghost_cy, bed_h])
            cylinder(h = ghost_body_h, d = pole_d, $fn = 32);
```
To:
```
    ghost_cx = is_undef(pole_cx) ? 90 : pole_cx[0];
    ghost_cy = is_undef(pole_cy) ? 60 : pole_cy[0];
    ghost_bed_h = is_undef(bed_h) ? 500 : bed_h;
    pole_top(ghost_cx, ghost_cy);
    ghost_neck_top = xbar_z - housing_r_circ;
    ghost_body_h   = (ghost_neck_top - neck_h) - ghost_bed_h;
    color("gray", 0.3)
        translate([ghost_cx, ghost_cy, ghost_bed_h])
            cylinder(h = ghost_body_h, d = pole_d, $fn = 32);
```
Confirm in cc_chat_log that `pole_top.scad` still renders cleanly standalone
(no undefined-variable warnings) after this change — Claude Web already
verified this locally, cc should confirm independently, not just trust this note.

**Do not treat this as license to fix other globals** — this project has a
PENDING open item ("TASK 2 audit — remaining ~23 flagged globals") for a
systematic sweep. This task fixes only the one instance proven dormant by
this session's render test. Leave the rest for that dedicated audit.

### TASK 1b — Reconcile bed height to leg height (`PR-01-assembly-v29.scad` → save as `PR-01-assembly-v30.scad`)

Change:
```
bed_h       = 500;    // floor to top of bed surface — PENDING Janis confirm
```
To:
```
bed_h       = 600;    // floor to top of bed surface — Janis-confirmed 2026-07-02,
                       // reconciled to leg_socket.scad's leg_h(600mm) so the bed
                       // surface sits flush on top of the new embedded-socket leg
                       // instead of appearing sunk below it. Requires TASK 1a's
                       // fix to actually take effect — verify local render proof
                       // in Claude Web's session before assuming this alone works.
```
Verify and state explicitly in cc_chat_log the new derived values:
- `xbar_z = bed_h + pole_h - housing_r_circ - housing_camber_rise`
- `collar_z0 = bed_h - collar_wrap_h / 2`
- `body_h = (neck_top - neck_h) - bed_h` (pole_body height)
- `bed_frame()`'s own per-corner leg height = `bed_h - surface_t`

Do not hand-adjust any of these — they must fall out of the formula change alone.
If any of them do NOT change as expected, stop and report — do not force a value.

### TASK 2 — Remove the leg foot pad (`leg_socket.scad`, in-place edit)

In `module leg_socket(cx, cy)`, comment out (do not delete) the pad cube:
```
        translate([cx - leg_w / 2 - pad_overhang, cy - leg_t / 2 - pad_overhang, 0])
            cube([leg_w + 2 * pad_overhang, leg_t + 2 * pad_overhang, pad_t]);
```
Replace with a commented-out version plus a one-line note above it:
```
        // Foot pad removed — Janis-confirmed 2026-07-02, was never part of the
        // intended design, only surfaced on first visual render. pad_t/
        // pad_overhang variables kept (unused) for history; do not resurrect
        // this call without Janis re-confirming.
        // translate([cx - leg_w / 2 - pad_overhang, cy - leg_t / 2 - pad_overhang, 0])
        //     cube([leg_w + 2 * pad_overhang, leg_t + 2 * pad_overhang, pad_t]);
```
Leave the `pad_t`/`pad_overhang` variable declarations at the top of the file as-is
(unused is fine, matches project convention of commenting out rather than deleting).

### TASK 3 — Standalone-only cutaway for `leg_socket.scad` (VERIFIED via local render)

`leg_socket.scad` ghost block — replace the plain `leg_socket(ghost_cx, ghost_cy)`
call with:
```
    difference() {
        leg_socket(ghost_cx, ghost_cy);
        translate([ghost_cx - leg_w, ghost_cy, -e])
            cube([leg_w * 2, leg_t, leg_h + 2 * e]);
    }
```
This is the exact code Claude Web tested locally (iso/side/front/bottom renders,
pad-removed, bore visible in section) — not a description, the confirmed
geometry. Applies ONLY inside `ghost_mode()`. Confirm in cc_chat_log that a
full `pr01_assembly()` render (`$is_assembly=true` context) is unaffected —
byte-identical geometry calls to before this task.

**`pole_top.scad` standalone cutaway — NOT included in this prompt.**
Local render testing found that `bell_lock_collar()` (the module with the
thread/bayonet/washer detail Janis wants to inspect) is never called from
`pole_top()` or its ghost stanza at all — it's a fully separate module in the
same file, invoked only at assembly level, with zero standalone preview
anywhere today. Cutting into `pole_top()`'s own ghost geometry (the upper
housing/neck, a different part of the pole entirely) would not have shown
what was asked for. This needs a scoping decision from Janis before it's
written as a task — see message to Janis, not guessed here.

## 5. DO NOT TOUCH

- `pole_wood_socket()` / `show_wood_sockets` in `pole_top.scad` — still-flagged
  redundant old placeholder, separate open item, not part of this fix
- `bell_lock_collar()` dimensional parameters (r_top, curve_power, cap_h,
  washer_overhang, thread/bayonet values) — already CONFIRMED, zero change
- `bed_w`, `leg_t`, `xbar_y_front`, `xbar_y_rear` — must remain 840/120/60/780
- `leg_h` (600, in `leg_socket.scad`) — this is the reference value TASK 1 aligns
  `bed_h` to; do not also change `leg_h` itself
- `leg_socket_od`/`leg_socket_wall_t`/`leg_socket_depth` — unrelated to this fix
- `housing_*` parameters — explicitly deferred, do not touch
- VM-01-base — untouched, out of scope
- rules-dimensions.md — read for context, but do not edit any section other
  than the ones TASK 6 (QA) asks you to update

## 6. QA VERIFICATION

- [ ] `pole_top.scad` line 68 self-reassignment removed, `ghost_bed_h` local
      added in its place inside the ghost stanza only (TASK 1a)
- [ ] `pole_top.scad` still renders standalone with no undefined-variable
      warnings (TASK 1a) — confirm independently, don't just cite this prompt
- [ ] `bed_h = 600` exactly, comment updated as specified (TASK 1b)
- [ ] cc_chat_log states the four re-derived values from TASK 1b explicitly
      (xbar_z, collar_z0, body_h, bed_frame per-corner leg height) — these
      MUST differ from their v29 values; if any are unchanged, the TASK 1a
      fix didn't take and this needs to stop and be reported, not forced
- [ ] Foot pad draw call commented out (not deleted), one-line note present
- [ ] `pad_t`/`pad_overhang` variable declarations untouched/still present
- [ ] `leg_socket.scad` ghost-context cutaway added exactly as specified in
      TASK 3, strictly inside `ghost_mode()`
- [ ] cc_chat_log confirms full-assembly render path (`$is_assembly=true`)
      produces byte-identical geometry calls to before this prompt for the
      cutaway (no leakage into assembly context) — state how this was verified
- [ ] No `pole_top.scad` cutaway attempted — explicitly out of scope this prompt
- [ ] rules-dimensions.md: bed_h entry updated to 600 with provenance note;
      pad_t/pad_overhang entry marked SUPERSEDED (not deleted) with reason
- [ ] No undefined variable warnings in SCAD
- [ ] File saved as `PR-01-assembly-v30.scad`, v29 untouched
- [ ] No 2-manifold warnings — if any appear, do NOT attempt a fix in this same
      prompt; report to Claude Web per manifold triage protocol instead
- [ ] Flag (do not fix): confirm whether `bed_frame()`'s own per-corner leg cube
      and `leg_socket()`'s leg cube are now two overlapping solids at each of the
      4 corners (same footprint, both drawn) — state your finding, no action

## 7. MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP, under 10 lines
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-02
3. Update knowledge.map (PR-01-assembly-v30.scad new, v29 superseded)
4. Bump version on all changed files (rules-dimensions.md v10→v11, knowledge.map v20→v21)
5. Commit all → merge to main
