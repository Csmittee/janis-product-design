# Design Scope of Work — VM-01 Smart Donation Vending Machine
# Last updated: 2026-07-06 — updated whenever a NEW feature/goal is confirmed
# by the owner in any session, same session it's confirmed, not deferred.
#
# CORE FILTER (owner's own words, 2026-07-06 — governs every future edit
# to this file, VM-01 and PR-01 alike): "The focus of this file contain
# mainly feature that customer recognize or marketing headline that we
# need to stick to. No one care if i spot or weld, no one care how long
# sensor i use, thats more on the bom rule, dim rule, and other technical
# rule that i have." This file holds ONLY features/facts a customer would
# recognize or that could appear as a marketing headline. It NEVER holds
# construction/assembly method (weld vs. bolt, etc.), exact component
# specs (part lengths, sensor models, etc.), BOM, or dimensional/technical
# rules — those live in rules-dimensions.md, rules-codes.md,
# rules-materials.md, or BOM files, never here.
#
# EXTRACTION NOTE: built from the original product brief
# (prompts/archive/VM-01-base-prompt-v1), rules-dimensions.md (OWNER-LOCKED
# DIMENSIONS table + all VM-01 sections), PART_MANIFEST.md, CURRENT_STATE.md,
# and cc_chat_log.md, plus a representative sample of archived VM-01 prompts
# (not a literal line-by-line read of all ~24 of them — session time
# constraints; two research agents tasked with an exhaustive archive scan
# both failed on a session usage limit mid-run). Treat this as a solid first
# pass, not a guaranteed-complete one — a follow-up pass reading every
# remaining archived VM-01 prompt individually would be worth doing before
# treating any gap below as final.

## Product Identity

A compact smart donation vending machine that dispenses buddha ornaments.
Stainless steel skin, modern sleek look with rounded corners "like a
monitor/microwave." Payment is online only — no cash or coin mechanism,
ever (OWNER-LOCKED). [Source: VM-01-base-prompt-v1; rules-dimensions.md
OWNER-LOCKED table; rules-dimensions.md "Machine Purpose"]

## Envelope Targets

**Owner-confirmed 2026-07-06**: the envelope is target guidance only, not
a fixed external/regulatory requirement — there is no market or
regulatory sizing constraint forcing a specific envelope, and sizing may
be adjusted as needed. Both sets of numbers below are understood as
targets, not a locked requirement: the ORIGINAL owner brief (prompt v1,
2026-06-27) stated total width 620mm, total height 800mm, total depth
410mm, corner radius 20mm; the BUILT machine (current) uses width 640mm,
height 700mm, depth 600mm, corner radius 20mm. Depth grew over the build
to accommodate the real motor's physical size (`motor_d`=60mm) — an
engineering necessity, not a target change, and consistent with sizing
being adjustable as needed. Corner radius (20mm) has stayed consistent
since the original brief.

FLAG (not resolved here, out of this document's own scope): `total_h`
(700mm) is listed as OWNER-LOCKED in `rules-dimensions.md` ("drives all
zone stack calculations"), which reads as a stricter constraint than
"target guidance, adjustable as needed." Noted for awareness — reconciling
the two is a `rules-dimensions.md` question, not a change to this file.

## Compartment / Section Map

Two main compartments, left and right, separated by a divider panel:

- **Left compartment (product zone, ~416mm wide)**: split into two
  functional layers —
  - **Storage (upper/rear)**: two stacked spring trays, each holding 5
    lanes of springs (donation-vending coil mechanism), holding the buddha
    ornaments before dispense.
  - **Exit (lower/front)**: the customer pickup/drop zone, behind the
    front door's hinged exit flap — where a dispensed item lands and the
    customer reaches in to collect it.
- **Right compartment (system zone)**: split into two functional layers —
  - **Lower**: the dashboard — ATM-style recessed touchscreen, QR
    scanner, ID card slot, speaker grille.
  - **Upper**: a 3-sided acrylic product display window (front + right
    side + top), showing product without customer access.
- A rear service door, right compartment, back wall, single-side hinge —
  for circuit board / power access.

[Source: VM-01-base-prompt-v1 "Compartments"/"Doors"; rules-dimensions.md
"VM-01 Base — Compartments", "Dashboard", "Acrylic Display Zone"]

## Functional Features

1. Customer pays online only — no cash or coin mechanism ever accepted
   (OWNER-LOCKED).
2. A left-compartment front door (full left-zone height) conceals a
   hinged exit flap; the flap swings inward/open toward the customer side
   when a product is dispensed, then the customer reaches through it into
   the exit zone to retrieve the item.
3. Door opens and closes smoothly and safely: no significant gaps, no
   hard/rough resistance on push or pull, no abnormal noise (owner-
   confirmed 2026-07-06). NOTE: this is the customer-facing standard the
   door/corner build must meet — it does NOT mark the still-open "shell
   trim/joggle collision" technical defect (see Open Questions) as
   resolved; that remains a separate, unresolved build item tracked
   elsewhere.
4. Door includes a separately-installed lock mechanism (hardware, not yet
   designed) — required for the final product (owner-confirmed
   2026-07-06, new feature, not yet present in the current build).
5. Spring-coil dispense mechanism: motor at the BACK of each tray, spring
   at the FRONT (Y=0, the drop-zone boundary) — products fall FORWARD out
   of the coil into the customer pickup path when dispensed (OWNER-LOCKED
   direction).
6. Spring trays are physically independent, removable units — lift and
   pull forward to remove, with a rear latch for transit/shipping safety
   (OWNER-LOCKED: "Tray construction: Independent removable units").
7. Tray top and front are open — hand access from above, and the springs/
   product are visible through the front (OWNER-LOCKED: "Tray front OPEN
   — Springs and product visible from front").
8. The lowest tray needs real hand-access clearance behind/below it so it
   can be lifted off its mounting notch without interference — this drove
   a mid-project 100mm upward shift of the whole tray stack (session
   2026-07-05) after Janis found a customer could otherwise reach under
   the lowest tray into the mechanism from the exit zone; two new fixed
   internal parts (a sealing partition + a rear wall) were added
   specifically to close that hand-access gap, not to change how trays
   are used.
9. A viewing window in the front door (with acrylic upper pane + plain
   metal lower panel) lets the customer see the whole compartment — the
   springs, the trays, everything — not just a slice.
10. Right-compartment dashboard: 7" TFT touchscreen tilted ~30° toward the
    user, QR code scanner, ID card reader, speaker grille — for
    payment/identity/audio feedback during a transaction.
11. Two sensors, facing each other side-to-side across the drop zone,
    together covering the FULL WIDTH of the fall/drop space in a single
    detection zone — NOT one sensor per spring lane (a prior assumption,
    corrected 2026-07-06: the supplier's actual product works as a facing
    pair, not per-lane units). Current implementation uses a 120mm-spec
    version. Known dependency: this affects drop-zone depth (no specific
    mm value stated here beyond the 120mm spec noted).
12. Rear service door on the right compartment for circuit board / power
    access by a technician, not the customer.

[Source: VM-01-base-prompt-v1; rules-dimensions.md OWNER-LOCKED table,
"Spring direction", "Motor position", "Tray..." rows, "Sensors" section;
cc_chat_log.md 2026-07-05 entries on the tray-access hand-safety gap;
prompts/vm01-design-scope-update-owner-answers.md (owner answers,
2026-07-06, round 2) for items 3, 4, and the corrected item 11]

## Appearance / Do-Not Features

- Must look like a modern, sleek consumer appliance — explicitly compared
  to a monitor or microwave in the original brief — rounded corners, not
  boxy/industrial. [VM-01-base-prompt-v1]
- Corner and frame construction must present a smooth, uniform, modern
  appearance, consistent with the "sleek, like a monitor/microwave"
  direction above — not just a technical fit (owner-confirmed 2026-07-06).
  This is the appearance angle of the ongoing corner-frame-redesign work;
  see Functional Feature 3 (door safety/smoothness) for the related UX
  angle — a poorly integrated corner/frame could itself cause the gaps or
  rough operation that feature requires the door to avoid.
- Must NEVER include a cash or coin mechanism, under any circumstance
  (OWNER-LOCKED, "Payment: Online only"). [rules-dimensions.md]
- Stainless steel skin is the stated finish/material direction for the
  shell. [VM-01-base-prompt-v1] The prototype used L-brackets for
  structure with a stated future intent to move to a welded reinforcement
  shell — NOT YET SPECIFIED whether that transition has actually happened
  in the current build; not confirmed one way or the other in the files
  read this session.
- NOT YET SPECIFIED BY OWNER: any branding, color scheme (beyond the
  render's placeholder greys/blues), or lighting requirements.

## Open Questions / Gaps Found During This Extraction

- **Shell trim/joggle collision (v48 TASK 4, still open)**: Janis reported
  a second door-closed collision near the right body edge, described as
  having "a top sub-piece and a bottom sub-piece." This was searched for
  in the shell code and could not be matched to any existing modeled
  feature — genuinely unresolved as of v49, needs a screenshot pointing at
  the specific edge before it can be fixed. This is a build-defect item,
  not a product-concept gap, but it's flagged here since it's still open.
  See Functional Feature 3 and the Appearance section for the
  customer-facing standard this fix must eventually meet — those do NOT
  mark this technical item itself as resolved.
- **Corner/frame/shell-width redesign**: a prompt exists
  (prompts/VM-01-corner-frame-redesign.md) describing Janis's finding that
  removing the internal frame reveals a leftover "pole" of shell material
  colliding with the door, plus the frame's own bars overlapping the
  outermost spring coils — this has NOT been executed yet (explicitly
  deferred to a session with fresh context). It may reshape the shell's
  left-front corner and possibly the shell's own width — worth tracking
  since it could change the envelope numbers above once it lands.
- This document itself is a first pass built under a time-constrained
  session (see extraction note at top) — a follow-up read of the
  remaining archived VM-01 prompts not covered this session (particularly
  the early v6–v29 build-out prompts) may surface additional confirmed
  owner decisions not captured here.
