# CURRENT_STATE.md
# Janis Product Design — Where We Left Off
# Last updated: 2026-07-10 by cc (vm02-lower-shell-fill-and-retro-governance
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

## BBQ Offset Smoker (3–4 model variants planned) — NOT STARTED
Queued, no files exist yet.
