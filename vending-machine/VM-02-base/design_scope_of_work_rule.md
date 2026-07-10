# Design Scope of Work — VM-02 Smart Donation Vending Machine
# Last updated: 2026-07-10 — updated whenever a NEW feature/goal is confirmed
# by the owner in any session, same session it's confirmed, not deferred.
#
# FILE LOCATION NOTE: VM-01's own scope file lives at
# `vending-machine/design_scope_of_work_rule.md` (the shared `vending-
# machine/` root) — that path made sense when VM-01 was the only product
# in this folder. VM-02 gets its OWN file, placed at
# `vending-machine/VM-02-base/design_scope_of_work_rule.md` instead of
# reusing VM-01's generic root-level name/location, to (a) avoid
# overwriting/colliding with VM-01's file, and (b) match the ALREADY-
# established per-product-subfolder convention this project uses for
# every other VM-02 governance doc (PART_MANIFEST.md and the .scad
# versions themselves both already live in `vending-machine/VM-02-base/`,
# not the shared root). VM-01's own file is left at its existing location
# unchanged — this is a deliberate divergence for a second product, not
# an inconsistency to "fix" retroactively on VM-01.
#
# CORE FILTER (same filter VM-01's own file uses, owner's own words,
# 2026-07-06 session: "The focus of this file contain mainly feature that
# customer recognize or marketing headline that we need to stick to. No
# one care if i spot or weld, no one care how long sensor i use, thats
# more on the bom rule, dim rule, and other technical rule that i have."
# This file holds ONLY features/facts a customer would recognize or that
# could appear as a marketing headline. It NEVER holds construction/
# assembly method, exact component specs, BOM, or dimensional/technical
# rules — those live in rules-dimensions.md, `.claude/rules-codes.md`,
# `.claude/rules-materials.md`, PART_MANIFEST.md, or BOM files, never here.
#
# EXTRACTION NOTE: this is a RETROACTIVE scope file (VM-02's design work
# happened first, as a direct-cc-chat session, before this governance
# chain was run — Janis's own explicit decision, confirmed 2026-07-10:
# "let the derivation + direct-chat fixes finish, then run this chain
# retroactively — confirming against what was actually built, not a blind
# pre-spec"). Built from the ACTUAL built VM-02-base-v2.scad, PART_
# MANIFEST.md, rules-dimensions.md's VM-02 sections, and every VM-02 entry
# in cc_chat_log.md (2026-07-10, 5 entries total, all read in full — not
# just the usual first-3-entries rule, a deliberate full retroactive
# extraction). Where no source confirms a fact, this file says so
# explicitly rather than inventing one, same convention VM-01's file uses.

## Product Identity

A NEW sibling product line to VM-01 (not a new VM-01 version) — same core
concept: a compact smart donation vending machine dispensing buddha
ornaments, stainless steel skin, rounded "monitor/microwave" modern look,
online-only payment (OWNER-LOCKED, inherited from VM-01, never a cash/coin
mechanism). VM-01 continues independently, locked at its own v58.
[Source: VM-02-base-v2.scad header; VM-01's own design_scope_of_work_rule.md,
same product-family identity]

## Envelope Targets

Total depth (600mm) and corner radius (20mm) are unchanged from VM-01.
Total width and total height are both real changes from VM-01, and — a
genuine new characteristic worth noting as its own feature, not just a
number — total height is no longer a single fixed value: it is designed
to grow or shrink automatically with the tray-count feature below (see
Functional Features). At the default tray configuration, the machine
stands taller than VM-01; at its smallest tray configuration, shorter.
Total width is also somewhat wider than VM-01, to give the taller/more-
adjustable tray stack real physical clearance to slide out from its own
storage compartment.
[Source: rules-dimensions.md "VM-02 Base — Overall" table; cc_chat_log.md
2026-07-10 entries]

## Compartment / Section Map

Two main compartments, left and right, separated by a divider panel —
same overall concept as VM-01:

- **Left compartment (product zone, somewhat wider than VM-01's)**:
  - **Storage (upper/rear)**: spring trays holding the buddha ornaments,
    same 5-lanes-of-springs mechanism as VM-01. NEW: the tray count is
    now an adjustable feature (see Functional Features) rather than a
    fixed two trays, and each tray now has its own independent slide-out
    position rather than sharing one slide setting across the whole
    stack. NEW: each tray floor also has small sensor holes (per lane)
    added underneath.
  - **Exit (lower/front)**: same customer pickup/drop-zone concept as
    VM-01, behind the front door's hinged exit flap.
- **Right compartment (system zone, noticeably NARROWER than VM-01's)**:
  narrower because the touchscreen is now mounted PORTRAIT instead of
  landscape (same physical screen size, just turned 90°), which needs
  less side-to-side room.
  - **Lower**: the dashboard — touchscreen, QR scanner, ID card slot,
    speaker grille — same functional set as VM-01, just portrait-
    oriented. This lower zone is enclosed in solid sheet metal (this was
    always the intended design, confirmed by Janis this session, and had
    never actually been built correctly in either VM-01 or VM-02 until
    this session's fix — see Open Questions).
  - **Upper**: a 3-sided acrylic product display window (front + right
    side + top) — same concept as VM-01, confirmed by Janis this session
    as a feature that stays ("we need acrylic window"), positioned above
    the touchscreen with a real gap between the screen and the window.
- A rear service door, right compartment, back wall — same purpose as
  VM-01 (circuit board/power access for a technician), but NOW spans the
  full compartment height (floor to ceiling) instead of only half of it.

[Source: VM-02-base-v2.scad header + `outer_shell()`/`dashboard()`/
`acrylic_display()`/`rear_service_door()` comments; PART_MANIFEST.md;
rules-dimensions.md "VM-02 Base" sections; cc_chat_log.md 2026-07-10]

## Functional Features

1. Same core dispense mechanism as VM-01: motor at the back of each tray,
   spring at the front, products fall forward into the customer pickup
   path (OWNER-LOCKED direction, inherited).
2. Online-only payment, no cash/coin mechanism ever (OWNER-LOCKED,
   inherited from VM-01).
3. **NEW — adjustable tray count**: the number of spring trays in the
   stack is now a genuinely adjustable feature (a range of 1 to 5 trays,
   defaulting to 3), not fixed at two the way VM-01 is. The machine's
   overall height adjusts automatically to whichever tray count is
   chosen.
4. **NEW — independent tray positioning**: each tray in the stack can now
   be sled out to its own position independently of the others (VM-01
   only supports sliding the whole stack together at one shared amount).
5. **NEW — portrait touchscreen**: the same physical touchscreen panel
   VM-01 uses is now mounted in portrait orientation (turned 90°) instead
   of landscape.
6. Same acrylic viewing-window concept as VM-01 (3-sided display window
   above the dashboard, product visible but not customer-accessible) —
   confirmed by Janis this session as a feature to keep, not drop.
7. Rear service door for technician access to circuit board/power — same
   purpose as VM-01, now full floor-to-ceiling height rather than a
   half-height panel.
8. A REAL, confirmed physical limitation, not a defect: a tray can only
   be slid out to its full extent while the front door is open — trying
   to slide a tray out fully with the door closed will physically
   collide with the closed door, an ordinary and expected mechanical
   constraint (you open the door to access the trays), not something
   that needs fixing.

[Source: VM-02-base-v2.scad header (Tasks A/B); PART_MANIFEST.md;
rules-dimensions.md "VM-02 Base — Trays"/"System Compartment"; cc_chat_log.md
2026-07-10 entries, all 5]

## Appearance / Do-Not Features

- Same modern, sleek, rounded-corner "monitor/microwave" appearance
  direction as VM-01 — no change in this design language for VM-02.
  [VM-02-base-v2.scad header; VM-01's own scope file, same product family]
- Must NEVER include a cash or coin mechanism, under any circumstance
  (OWNER-LOCKED, inherited from VM-01).
- Stainless steel skin is the stated finish/material direction, same as
  VM-01. [rules-materials.md]
- NOT YET SPECIFIED BY OWNER: any branding, color scheme, or lighting
  requirements specific to VM-02 (same gap noted in VM-01's own file, not
  separately addressed for VM-02 this session).

## Open Questions / Gaps Found During This Extraction

- **Governance chain itself is retroactive**: this scope file, and the
  Skeleton/BOM/Kinetic worksheets alongside it, were built AFTER VM-02's
  actual design/build work (a direct-cc-chat session, R-011), not before
  it — Janis's own explicit, confirmed decision for this specific
  product, not an oversight. Flagged here as the retroactive-extraction
  convention this file follows, per this session's own prompt.
- **Tray slide full-range needs the door open** (see Functional Feature
  8) — a real, physical, expected constraint, not a defect, but worth
  keeping in mind for any future customer-facing description of "how far
  can a tray come out."
- **system_w (right-compartment width) was corrected twice this
  session** before Janis's final confirmation (143mm) — the exact number
  isn't a marketing fact, but the PROCESS is worth noting here: an early
  cc-proposed correction used a different clearance assumption than what
  Janis actually wanted (a real 10mm border on each side of the
  touchscreen panel), corrected once Janis clarified it directly.
- **A real, currently-unresolved technical limitation exists on the
  tray/frame clearance** (root-caused this session as a carry-over
  regression from an earlier VM-01 fix, then FIXED for VM-02 by widening
  the left compartment) — VM-01 itself still has this same limitation,
  unfixed, since VM-01 is locked and out of scope to touch. Not a VM-02
  gap, but worth knowing VM-01 and VM-02 now differ here.
- **No web-viewer presence for VM-02 yet** — Janis has explicitly
  accepted this for now (see `.claude/rules-waivers.md` W-002): the
  kinetic features described above (adjustable tray count, independent
  tray slide, portrait screen) are only currently viewable by opening the
  .scad file directly in the OpenSCAD desktop application, not through
  the web-based product viewer.
- **Minor cosmetic note, not a functional gap**: the front door's viewing
  window is very slightly (a few mm) less centered within its
  surrounding frame than it was before this session's compartment-
  widening fix — still fully clear on both sides, just a small visual
  proportion detail worth a look on the next visual QA pass, not
  something flagged as needing correction.
