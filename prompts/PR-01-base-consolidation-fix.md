# cc Prompt — Base File Consolidation: Move bell_lock_collar() to leg_socket.scad
# Date: 2026-07-03
# Session goal: fix a file-organization deviation from the original
# PR-01-multifile-split-v25 plan, found by Janis during a full child-file
# review. Zero visual/dimensional change — confirmed via local render,
# checksums identical before/after.

## 1. CC INTRO
git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → cc_chat_log.md (first 3 entries) → rules-dimensions.md →
PR-01-assembly-v30.scad → pole_top.scad → leg_socket.scad
State every file read before writing a single line.

## 2. CONTEXT

The original PR-01-multifile-split-v25 plan (2026-07-01) established one base
file, planned in advance for when it would actually be built: an entire base
system (bell cover + embedded socket + pole holder/leg) in a single child
file, independently reviewable with ghost leg + ghost pole context — mirroring
the pole_top.scad pattern already established for the top joint. Foldable
base was explicitly deferred, not part of this file.

When the bell-collar-socket build actually happened (2026-07-02),
`bell_lock_collar()` and its five helper functions/modules were added to
`pole_top.scad` (the file already open in that session) instead of the new
`leg_socket.scad` — a deviation from the v25 plan that went uncaught. Result:
the collar had zero standalone preview anywhere. It was never called from
`pole_top()`'s own ghost stanza, never called from `leg_socket.scad`'s ghost
stanza — only reachable via full assembly. Janis caught this doing a full
child-file review before pausing the project for an extended period and
needs the file organization to actually match the documented plan before
that pause, not just work by coincidence.

**Everything in this prompt was prototyped and verified in Claude Web's local
OpenSCAD sandbox before being written** — the exact code below, not a
description of intent. Full-assembly render confirmed pixel-identical
(md5sum match) before and after this change.

## 3. NEW FILES
None. In-place edits to `pole_top.scad` and `leg_socket.scad`, plus the usual
version-incremented assembly file.

## 4. TASKS

### TASK 1 — Remove the bell collar bundle from `pole_top.scad`

Remove this entire block (currently lines ~311–408 — confirm exact lines
against your own checkout, do not assume the line numbers are unchanged):
- The `// BELL LOCK COLLAR` section header comment
- `function bell_dome_pts(...)`
- `module bell_dome(...)`
- `module bell_thread(...)`
- `module bell_bayonet(...)`
- `module bell_cap(...)`
- `module bell_lock_collar(...)`

Replace the whole removed block with exactly this pointer comment:
```
// BELL LOCK COLLAR — moved to leg_socket.scad (base-file-consolidation,
// 2026-07-03). This module physically belongs to the base/leg system, not
// the top-joint housing this file covers — was misplaced here during the
// 2026-07-02 bell-collar-socket-build. bell_lock_collar() and its helpers
// (bell_dome_pts, bell_dome, bell_thread, bell_bayonet, bell_cap) now live
// in leg_socket.scad. Global scope unaffected (still include-flattened
// alongside this file by the assembly), only the file location changed.
```
Do not touch anything else in `pole_top.scad` — the `pole_base_collar()`
retirement comment (which references `bell_lock_collar()` by name, not by
location) stays exactly as-is, it's still accurate.

### TASK 2 — Add the bell collar bundle to `leg_socket.scad`

Insert the exact block removed in TASK 1 (all six items) immediately after
the closing `}` of `module leg_socket(cx, cy)`, before the
`GHOST-CONTEXT PREVIEW` section header. Use this exact section header in
place of the original (documents the move, not just the content):
```
// ═════════════════════════════════════════════════════════════════════
// BELL LOCK COLLAR — pole-base bell/mushroom collar + quick-release cap
// Moved here from pole_top.scad (base-file-consolidation, 2026-07-03) —
// this module belongs to the base/leg system per the original
// PR-01-multifile-split-v25 plan (one base file: bell cover + socket +
// pole holder, independently reviewable with ghost leg + ghost pole).
// It was misplaced in pole_top.scad during the 2026-07-02
// bell-collar-socket-build and had no standalone preview anywhere as a
// result — this fixes both the location and that gap. Pole pushes
// directly into leg_socket()'s embedded sleeve above; this collar is the
// visible dome+cap that sits flush at the wood surface where pole meets
// leg. Dome profile REVISED CONFIRMED via Customizer screenshot
// 2026-07-02 (r_top=25/curve_power=2.2). All r_base/r_top/foot_h/dome_h/
// dome_steps/curve_power/cap_h/cap_knurl_count/washer_h/washer_overhang/
// leg_h globals are supplied by the assembly file and referenced
// directly (not reassigned here) — same no-reassignment discipline as
// the fix-pole-cx-cy-override-bug / bed_h fixes.
// ═════════════════════════════════════════════════════════════════════
```
(function/module bodies themselves are byte-identical to what was removed
in TASK 1 — do not alter any dimension, formula, or parameter name)

### TASK 3 — Add standalone-safe defaults for the newly-arrived globals

In `leg_socket.scad`'s existing "Standalone-safe defaults" block, add these
16 lines immediately after the existing `leg_socket_depth` line, matching
the file's own established is_undef() convention exactly:
```
// Bell collar standalone defaults — added base-file-consolidation,
// 2026-07-03, alongside the module move. Previously these had NO
// standalone fallback anywhere, because bell_lock_collar() was never
// called from any file's own ghost stanza. Values match the CONFIRMED
// rules-dimensions.md table exactly (dome profile via Customizer
// 2026-07-02; thread/bayonet are ENGINEER-PROPOSED, not physically
// validated — same caveat applies here as in the real assembly).
r_base                      = is_undef(r_base)                      ? 51   : r_base;
r_top                       = is_undef(r_top)                       ? 25   : r_top;
foot_h                      = is_undef(foot_h)                      ? 8    : foot_h;
dome_h                      = is_undef(dome_h)                      ? 35   : dome_h;
dome_steps                  = is_undef(dome_steps)                  ? 16   : dome_steps;
curve_power                 = is_undef(curve_power)                 ? 2.2  : curve_power;
cap_h                       = is_undef(cap_h)                       ? 12   : cap_h;
cap_knurl_count              = is_undef(cap_knurl_count)              ? 45   : cap_knurl_count;
washer_h                    = is_undef(washer_h)                    ? 5    : washer_h;
washer_overhang             = is_undef(washer_overhang)             ? 4    : washer_overhang;
thread_pitch                = is_undef(thread_pitch)                ? 3    : thread_pitch;
thread_depth                = is_undef(thread_depth)                ? 1.5  : thread_depth;
thread_engagement_l         = is_undef(thread_engagement_l)         ? 8    : thread_engagement_l;
bayonet_lug_w                = is_undef(bayonet_lug_w)                ? 5    : bayonet_lug_w;
bayonet_engagement_depth    = is_undef(bayonet_engagement_depth)    ? 3    : bayonet_engagement_depth;
bayonet_lug_count            = is_undef(bayonet_lug_count)            ? 3    : bayonet_lug_count;
```
**This inherits the file's own already-documented dormant-override risk**
(see TASK 5 flag below) — do not attempt to fix that pattern here, it is
explicitly out of scope for this prompt.

### TASK 4 — Add the collar to `leg_socket.scad`'s standalone ghost preview

In the `if (ghost_mode()) { ... }` block, change:
```
    difference() {
        leg_socket(ghost_cx, ghost_cy);
        translate([ghost_cx - leg_w, ghost_cy, -e])
            cube([leg_w * 2, leg_t, leg_h + 2 * e]);
    }
    color("gray", 0.3)
        translate([ghost_cx, ghost_cy, leg_h])
            cylinder(h = 200, d = pole_d, $fn = 32);
```
To:
```
    difference() {
        leg_socket(ghost_cx, ghost_cy);
        translate([ghost_cx - leg_w, ghost_cy, -e])
            cube([leg_w * 2, leg_t, leg_h + 2 * e]);
    }
    // Real bell_lock_collar() geometry (base-file-consolidation,
    // 2026-07-03) — was previously invisible in any standalone preview
    // since the module lived in pole_top.scad with no ghost call of its
    // own. Solid, not cut — matches its appearance in full assembly.
    bell_lock_collar(ghost_cx, ghost_cy);
    color("gray", 0.3)
        translate([ghost_cx, ghost_cy, leg_h])
            cylinder(h = 200, d = pole_d, $fn = 32);
```

### TASK 5 — Flag only, do NOT fix: dormant global-override count is far
### larger than previously tracked

**Found via actual OpenSCAD compiler warnings during this session's local
verification, not estimated.** Running the assembly produces explicit
`WARNING: <name> was assigned on line N of "PR-01-assembly-v30.scad" but
was overwritten in file <file>.scad, line M` for every affected variable.
Full counted list, captured this session:

- `pole_top.scad`: 20 globals (e, bed_l, pole_d, pole_r, neck_h, neck_id,
  neck_od, neck_bolt_d, top_bore_d, housing_len, housing_r_circ,
  housing_camber_rise, housing_peak_t, housing_bump_w, housing_steps,
  housing_neck_t, housing_bulge_rise, housing_bulge_w, xbar_z, grip_od)
- `leg_socket.scad`, pre-existing: 8 globals (leg_w, leg_t, leg_h, pad_t,
  pad_overhang, leg_socket_od, leg_socket_wall_t, leg_socket_depth)
- `leg_socket.scad`, newly added by TASK 3 above: 16 more globals (the
  full bell-collar/thread/bayonet parameter set)

**Total: 44 dormant-override warnings currently present**, not the ~23
previously estimated in the open PENDING "TASK 2 audit" item. All are
currently harmless because every fallback value happens to match the
assembly's real confirmed value (same masking pattern that hid the bed_h
bug until it actually needed to change). State this exact count in
cc_chat_log verbatim — do not round or approximate it.

**Do not attempt to fix any of these in this prompt.** This is a single
consolidated data point for the existing PENDING audit item, which should
be treated as higher priority given the count is roughly double what was
assumed, and given Janis is pausing this project for an extended period —
an ungated landmine of this size sitting through a long pause is exactly
what that audit item exists to prevent.

## 5. DO NOT TOUCH

- Do not rename `leg_socket.scad` — Janis explicitly locked this filename
  this session; if a rename to something like `pr01_base.scad` is wanted
  later, that is a separate, explicit decision, not part of this prompt
- Do not fix any of the 44 dormant-override warnings — flag only, per TASK 5
- `bell_lock_collar()` dimensional parameters — zero change, byte-identical
  move only
- `pole_wood_socket()` / `show_wood_sockets` — still-flagged separate
  redundancy, unrelated to this prompt
- `housing_*` parameters — explicitly deferred, do not touch
- `bed_h`, pad removal, leg_socket cutaway — already fixed and merged
  (PR #73), do not re-touch
- VM-01-base — untouched, out of scope

## 6. QA VERIFICATION

- [ ] `pole_top.scad`: bell collar bundle removed, replaced with the exact
      pointer comment specified in TASK 1, nothing else changed
- [ ] `leg_socket.scad`: bell collar bundle present, byte-identical module
      bodies to what was removed, only the section header comment differs
      as specified in TASK 2
- [ ] `leg_socket.scad`: 16 new standalone-default lines added exactly as
      specified in TASK 3
- [ ] `leg_socket.scad`: ghost stanza calls `bell_lock_collar(ghost_cx, ghost_cy)`
      as specified in TASK 4
- [ ] `leg_socket.scad` opened fully standalone renders without errors —
      confirm independently, Claude Web already verified this locally
- [ ] `pole_top.scad` opened fully standalone still renders without errors
      after the removal
- [ ] Full assembly (`$is_assembly=true` context) render is confirmed
      byte-identical (same visual output) to before this prompt — Claude
      Web verified this via matching md5sum locally; cc must confirm
      independently, not just cite this note
- [ ] cc_chat_log states the exact 44-warning count from TASK 5 verbatim
- [ ] No NEW undefined-variable warnings introduced beyond the pre-existing
      pattern described in TASK 5
- [ ] No 2-manifold warnings — if any appear, do not attempt a fix in this
      same prompt, report per manifold triage protocol instead
- [ ] File saved as `PR-01-assembly-v31.scad`, v30 untouched
- [ ] rules-dimensions.md: no changes needed (no dimension changed, only
      file location) — confirm this explicitly rather than silently skip it

## 7. MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP, under 10 lines, but MUST
   include the exact 44-warning count from TASK 5
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-03
3. Update knowledge.map (PR-01-assembly-v31.scad new, v30 superseded)
4. Bump version on all changed files (knowledge.map only — rules-dimensions.md
   unchanged per TASK 6 confirmation above)
5. Commit all → merge to main
