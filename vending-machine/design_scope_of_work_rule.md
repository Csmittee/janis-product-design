# Design Scope of Work — VM-01 Smart Donation Vending Machine
# Last updated: 2026-07-06 — updated whenever a NEW feature/goal is confirmed
# by the owner in any session, same session it's confirmed, not deferred.
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

The ORIGINAL owner brief (prompt v1, 2026-06-27) stated explicit target
dimensions: total width 620mm, total height 800mm, total depth 410mm,
corner radius 20mm. The BUILT machine (current, v49) uses: width 640mm,
height 700mm (OWNER-LOCKED — "drives all zone stack calculations"), depth
600mm, corner radius 20mm. Height and depth both diverged from the
original brief's numbers over the course of the build (700mm height is
explicitly locked as of the current dimensions file; depth grew from
410mm to 600mm, per rules-dimensions.md's own comment, "Increased for
motor_d=60" — i.e. driven by the real motor's physical size once specced).
**Gap**: no session in the read history shows Janis explicitly re-confirming
NEW target numbers for height/depth after the original brief — the current
600/700mm values appear to have been arrived at by downstream engineering
necessity (motor size, zone-stack math) rather than a fresh owner-stated
cap. Flagged here rather than presented as if 700/600mm were an original
target. Corner radius (20mm) is the one dimension that has stayed
consistent since the original brief.

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
3. Spring-coil dispense mechanism: motor at the BACK of each tray, spring
   at the FRONT (Y=0, the drop-zone boundary) — products fall FORWARD out
   of the coil into the customer pickup path when dispensed (OWNER-LOCKED
   direction).
4. Spring trays are physically independent, removable units — lift and
   pull forward to remove, with a rear latch for transit/shipping safety
   (OWNER-LOCKED: "Tray construction: Independent removable units").
5. Tray top and front are open — hand access from above, and the springs/
   product are visible through the front (OWNER-LOCKED: "Tray front OPEN
   — Springs and product visible from front").
6. The lowest tray needs real hand-access clearance behind/below it so it
   can be lifted off its mounting notch without interference — this drove
   a mid-project 100mm upward shift of the whole tray stack (session
   2026-07-05) after Janis found a customer could otherwise reach under
   the lowest tray into the mechanism from the exit zone; two new fixed
   internal parts (a sealing partition + a rear wall) were added
   specifically to close that hand-access gap, not to change how trays
   are used.
7. A viewing window in the front door (with acrylic upper pane + plain
   metal lower panel) lets the customer see the whole compartment — the
   springs, the trays, everything — not just a slice.
8. Right-compartment dashboard: 7" TFT touchscreen tilted ~30° toward the
   user, QR code scanner, ID card reader, speaker grille — for
   payment/identity/audio feedback during a transaction.
9. Parallel IR sensor strip pair (left + right walls of the drop zone) —
   two independent pieces, no connecting element between them — presumably
   detects a product falling through the drop zone (exact sensing purpose
   not separately re-confirmed in the read history beyond "sensor type:
   parallel IR strip pair").
10. Rear service door on the right compartment for circuit board / power
    access by a technician, not the customer.

[Source: VM-01-base-prompt-v1; rules-dimensions.md OWNER-LOCKED table,
"Spring direction", "Motor position", "Tray..." rows, "Sensors" section;
cc_chat_log.md 2026-07-05 entries on the tray-access hand-safety gap]

## Appearance / Do-Not Features

- Must look like a modern, sleek consumer appliance — explicitly compared
  to a monitor or microwave in the original brief — rounded corners, not
  boxy/industrial. [VM-01-base-prompt-v1]
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

- **Envelope target drift** (see Envelope Targets above): current built
  height (700mm, locked) and depth (600mm) were not traced to an explicit
  fresh owner-approval session distinct from the original 800mm/410mm
  brief numbers — they appear to be engineering-driven (motor size,
  zone-stack math), not a restated owner target. Worth Janis confirming
  explicitly whether 640×700×600mm is now the accepted target envelope.
- **Shell trim/joggle collision (v48 TASK 4, still open)**: Janis reported
  a second door-closed collision near the right body edge, described as
  having "a top sub-piece and a bottom sub-piece." This was searched for
  in the shell code and could not be matched to any existing modeled
  feature — genuinely unresolved as of v49, needs a screenshot pointing at
  the specific edge before it can be fixed. This is a build-defect item,
  not a product-concept gap, but it's flagged here since it's still open.
- **Corner/frame/shell-width redesign**: a prompt exists
  (prompts/VM-01-corner-frame-redesign.md) describing Janis's finding that
  removing the internal frame reveals a leftover "pole" of shell material
  colliding with the door, plus the frame's own bars overlapping the
  outermost spring coils — this has NOT been executed yet (explicitly
  deferred to a session with fresh context). It may reshape the shell's
  left-front corner and possibly the shell's own width — worth tracking
  since it could change the envelope numbers above once it lands.
- **Sensor strip's actual purpose**: rules-dimensions.md only states the
  physical description (parallel IR strip pair, no connecting beam) — no
  session in the read history states explicitly what customer-facing
  behavior the sensor enables (e.g., dispense confirmation, jam
  detection). NOT YET SPECIFIED BY OWNER in terms the owner has stated
  directly, as opposed to inferred from the part's name.
- **Stainless shell structure**: whether the "future: welded reinforcement
  shell" mentioned in the original brief has actually been decided/adopted
  is NOT YET SPECIFIED in anything read this session — flagged rather than
  assumed either way.
- This document itself is a first pass built under a time-constrained
  session (see extraction note at top) — a follow-up read of the
  remaining archived VM-01 prompts not covered this session (particularly
  the early v6–v29 build-out prompts) may surface additional confirmed
  owner decisions not captured here.
