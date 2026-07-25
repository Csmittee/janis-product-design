# CURRENT_STATE.md
# Janis Product Design — Where We Left Off
# Last updated: 2026-07-25 by cc (bbq-lid-hinge-v10 direct-cc — Janis
# confirmed a pause to hand off to Claude Web for rib-construction
# planning: "i keep saying... should we quickly create a new hing
# construction md file immediatly now... this must not be lost")
# Previous update: 2026-07-10 by cc (vm02-lower-shell-fill-and-retro-governance
# — Janis confirmed this is the LAST round for VM-02: "After finish this
# will be last so clean up any pending status and close session")
#
# UPDATE TRIGGER — read this before touching this file:
# This file is updated ONLY when Janis explicitly confirms a pause is
# starting (on any single product line, or the whole project). That
# confirmation is the ONLY trigger — never update this file just because
# a session or task ended, that would turn it into a second log. When
# Janis confirms a pause, cc (or Claude Web, if drafting a handoff) MUST
# update this file immediately, before the pause is considered complete.
#
# FORMAT — deliberately NOT one rigid line per product. Each entry holds
# whatever it takes to reconstruct exactly where things were left,
# including unfinished threads, open questions, things started but not
# decided. Structure below is a floor, not a ceiling.
#
# For raw session-by-session history, see cc_chat_log.md.
# For known-and-DELIBERATELY-ACCEPTED issues, see .claude/rules-waivers.md.
# Anything unresolved/undecided lives HERE, not in rules-waivers.md — a
# waiver requires Janis's explicit accept, an open item here does not.

## Vending Machine (VM-01) — GENERATION 1 LOCKED, v58, 2026-07-09
Active: VM-01-base-v58.scad | Last confirmed good: v58, PASS (real CGAL
11-angle sweep, Simple:yes throughout, zero manifold warnings)

- VM-01 is now LOCKED as Generation 1 — final design, Janis-confirmed
  2026-07-09 planning session. v58 is the version going to the supplier
  (China) for a prototype build quote.
- Construction reference drawing (5-page PDF, front/side/top/iso +
  tray/drop-zone/door/dashboard/back-door detail) delivered to Janis same
  session.
- No further structural/geometry changes expected on this generation
  unless prompted by physical-prototype feedback or firmware integration
  — a future session proposing a geometry change here should treat that
  as a deliberate exception, not routine iteration.

No open items.

## Vending Machine (VM-02) — v2 CLOSED, Janis-confirmed 2026-07-10 ("this will be last")
Active: VM-02-base-v2.scad | Last confirmed good: v2, real CGAL sweep clean
throughout — tray_count 1/3/5, 11-angle door_open_deg sweep, full
tray_out_pct 0-1 range (door open), flap_open true/false, leg clearance,
dashboard-vs-shell/reardoor/frame/divider/acrylic isolation checks at all 3
tray_count values. Session ran across 5 rounds total, all direct-cc-chat
(R-011, RULES.md) except the final round (a real Claude Web prompt,
`vm02-lower-shell-fill-and-retro-governance.md`, archived) — cc_chat_log.md's
5 VM-02 entries (2026-07-10) are the full record.

Summary of what VM-02 v2 actually is: NEW sibling product line derived from
VM-01-base-v58 (VM-01 itself untouched, stays locked). Live tray_count
(1-5, default 3) with derived total_h; per-tray independent slide
(tray_out_pct vector, full 0-1 range achievable with the door open);
new per-lane floor sensor holes; portrait dashboard mount, NOW enclosed in
solid sheet metal below the acrylic zone (a real gap since VM-01-base-v6,
fixed here, VM-01 itself untouched); resized system compartment
(system_w=143mm, total_w=584mm) with a restored acrylic display window;
resized legs (80mm); product_w widened 416->422mm for tray/frame
clearance. GOVERNANCE CHAIN NOW COMPLETE (retroactive, per Janis's own
decision): `vending-machine/VM-02-base/design_scope_of_work_rule.md` and
`vending-machine/VM-02-base/SKELETON_WORKSHEET.md` both exist, grounded in
the real v2 file. Full detail: VM-02-base-v2.scad's own header changelog,
rules-dimensions.md's "VM-02 Base" sections, PART_MANIFEST.md.

Open items (unresolved, not yet decided by Janis, genuinely deferred, not
things to silently re-flag as new in a future session):
- W-002 (VM-02 web-viewer/STL-export gap) — see `.claude/rules-waivers.md`,
  already a formal waiver (Janis-accepted 2026-07-10: viewer's WASM path
  isn't ready yet, manual OpenSCAD simulation is sufficient for now),
  cross-referenced here for visibility.
- **Real Kinetic Dual-View gap found during the retroactive pass**
  (`SKELETON_WORKSHEET.md` Finding 3): `rear_service_door()` has NO open/
  close toggle or hinge/rotate geometry at all — drawn as a single static
  flat panel despite being a real hinged door in the product concept. Not
  fixed this session (out of this session's own scope) — a real,
  worthwhile candidate for a future prompt.
- Minor COSMETIC note, not a manifold/collision issue (real CGAL sweep
  confirmed clean either way): widening `product_w` (+6mm, for the tray/
  frame clearance fix) shifted `tray_zone_frame()`'s right vertical +6mm
  too, but `left_zone_door()`'s window opening (fixed local constants,
  unrelated to `product_w`) did not move — the window is now ~6mm less
  centered within the frame's own opening than it was pre-widen. Purely a
  visual proportion drift, not flagged as needing a fix, just noted for
  whoever next reviews a render.
- Toggle-Completeness gaps (8 of 15 ASSEMBLY modules with no `show_*`
  toggle) — same pre-existing pattern as VM-01's own manifest, not
  retroactively fixed, see PART_MANIFEST.md's own count section.
- 2 real retroactive-skeleton findings, both cosmetic/documentation-level,
  not functional gaps (`SKELETON_WORKSHEET.md` Findings 1-2): VM-02's real
  Parent pattern is "shared named constants" (a 3rd pattern beyond the
  Skeleton skill's own described 2 types), and its `DATUM_*` naming
  predates that skill's own convention. Neither corrected — both are
  proven, working, inherited-from-VM-01 patterns, not bugs.

Next if resumed: read this entry + cc_chat_log.md's 5 VM-02 entries
(2026-07-10) in full before doing anything else — do not assume what
happened from a paraphrase. VM-02 is CLOSED as of this session, not
paused mid-task — any future work here is a genuinely new session/prompt,
not a continuation of an interrupted one.

## Pilates Reformer (PR-01) — PAUSED, awaiting customer
Active (confirmed): PR-01-assembly-v31.scad — base-file-consolidation
(PR #74) merged, zero visual/dimensional change from v30 (CSG-dump
md5sum-identical), so v30's F5/F6 confirmation still stands for v31.

Open items (unresolved, not yet decided by Janis):
- Socket is NOT physically cut into the wood leg. `leg_socket()` draws the
  wood leg as one fully solid cube and the socket sleeve as a separate
  tube occupying the same space — no boolean difference removes wood to
  make room for the sleeve. Looks correct in a colored render, would not
  be physically manufacturable as-is (no real cavity exists in the model).
  Found 2026-07-03, QA'd by Janis, NOT YET decided whether to fix now or
  waive — do not treat as accepted until Janis says so explicitly.
- W-001 dormant global-override pattern (44 instances) — see
  .claude/rules-waivers.md, already a formal waiver, cross-referenced here
  for visibility.

Next if resumed: read WORKFLOW_SKILL.md session-open steps, then the most
recent CHAT_HANDOFF file for specific open items, then this file for
anything that predates the handoff.

## Vending Machine variants (Satu, VM-1.1, VM-1.2) — NOT STARTED
Queued, no files exist yet.

## BBQ Offset Smoker — PAUSED, Janis-confirmed 2026-07-25, handing off to Claude Web for rib-construction planning

Active chambers: `BBQ-chambers-v26.scad` | Active understructure:
`BBQ-understructure-v19.scad` | Last CLEAN/committed base assembly:
`BBQ-offset-smoker-base-v9.scad` (PR #154, merged 2026-07-25) | **WIP,
uncommitted-as-final: `BBQ-offset-smoker-base-v10.scad`** — do not treat
as a clean version, see Open Items below.

This entire product line went through 10 real base-assembly rounds
(v1-v10) plus many chambers/understructure rounds — this entry only
covers the CURRENT state as of the 2026-07-25 pause; full history is
`cc_chat_log.md`'s many BBQ entries (not restated here).

**What is CONFIRMED CORRECT and LOCKED** (full detail:
`docs/hinge-construction.md`, new 2026-07-25 — read this file first on
resume, before anything else):
1. Real shared hinge-pivot rotation center (`HINGE_PIVOT_Y`/
   `HINGE_PIVOT_Z`, `BBQ-chambers-v26.scad`, read live by both `lid()`
   and the base file's `FC_Y`/`FC_Z`) — retires the whole v8 sink/float
   bug class (two rigid bodies can't rotate correctly about two
   different centers).
2. Real hinge location, Janis's own hands-on numbers: the "end margin
   zone" concept (hinge mounts outside the door's own real X-span, where
   the pivot's Y can sit exactly on the parting line with zero gap),
   real UCP204-12 spec (L=127/A=38/H0=64mm), 25mm gap from the door
   boundary.
3. The "open-then-freeze" construction method for positioning any rib/
   link point against a real physical target: rotate to the TRUE
   open-world position, build against the real target there, convert
   back to native/closed frame. Confirmed correct by catching a real bug
   (item 1 below) the same day it was written down.

**Open items (unresolved, not yet decided/completed — genuinely
deferred, not silently accepted):**
- **Real CB1 counterbalance-pipe position bug, found + corrected in math
  only, NOT yet coded**: the existing `CB1_OPEN` formula (unchanged
  since v6, always marked "LOCKED — do not recompute") applies a
  spurious extra rotation, landing CB1 at a physically wrong closed-frame
  position (380.9, 1801.3 — floating ~420mm above the ridge). Correct
  value, derived via the open-then-freeze method: closed-frame
  (598.64, 1307.09). Needs to be written into the base file.
- **Door-side rib spine flagged STALE, needs a full rebuild**: Janis's
  own words, "still look like old copy... refer to something not
  relevant" — the current `RIB_SPLIT_PT`/`RIB_B_OFFSET`/
  `SPLIT_STANDOFF`/`B_STANDOFF` construction re-derives placeholder
  offsets from scratch instead of directly tracing the real lid panel
  shape already defined in `BBQ-chambers-v26.scad` (ridge → apex B → AB
  wall). Plan: copy that real shape directly, connect to the handle,
  wipe the old placeholder points.
- **Not yet checked**: whether the door-side rib (built near apex B/C,
  which are on the FIXED side of `RIDGE_SPLIT_Y`, unlike apex D which is
  lid-side) needs a genuine angle-sweep clearance check against the
  fixed structure — the shared-pivot fix only guarantees rib-vs-LID-
  surface consistency across the sweep, not rib-vs-FIXED-structure,
  since the fixed structure doesn't rotate. Real, separate, open
  question.
- CB1/counterbalance/stopper geometry beyond the link (the prong/wrap
  stopper touching the DE face) still needs re-verification against the
  corrected CB1 position once it's coded.
- The Section 3 moment/force swept curve
  (`docs/lid-hinge-counterbalance-calc.md`) is stale against every pivot
  change since it was written — explicitly deferred by Janis, fix
  imbalance later with added/removed counterweight material rather than
  block on a full recompute.
- No PR open for v10 — Janis explicitly said "let me approve from here
  first," do not open one without new confirmation.

Next if resumed: read `docs/hinge-construction.md` in full, then
`cc_chat_log.md`'s 2026-07-25 entries (newest first) — do not assume
what happened from a paraphrase. The rib rebuild (door-side spine +
CB1 fix) is the next real task, per Janis's own planned sequencing with
Claude Web.
