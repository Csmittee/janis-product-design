# SKILL_product_design_skeleton.md
# Claude Web + cc — Top-Down Skeleton & Datum Reference Frame Design Logic
# Version: 2.1 — 2026-07-07
# Changes: Added a PREREQUISITE section (before TRIGGER PHRASES) pointing
# to design_scope_of_work_rule.md — this skill's worksheets did not
# previously state that a scope file must exist/be read FIRST, so a
# future session could complete the worksheets without one ever being
# created, or in the wrong order. Detail/sequencing addition (a pointer
# to an existing artifact, not a new procedure of its own) — X.Y bump,
# not X.0, per wire-kickoff-chain-scope-to-skeleton's explicit framing.
# Previous: 2.0 — 2026-07-07
# Changes: Added two new mandatory procedures, same day-one timing as the
# Skeleton Definition Worksheet — BOM Subassembly Tree (parts hierarchy,
# a DIFFERENT artifact from the Datum Skeleton, seeds that product's
# PART_MANIFEST.md) and Kinetic Dual-View Convention (every moving part
# from the BOM tree gets BOTH end states as explicit toggles from its
# FIRST committed version, rationale: VM-01's show_shell_top toggle
# existed in name but was never wired to the geometry it was meant to
# control, undiagnosed for several sessions — the exact failure mode this
# convention prevents). New sections, not detail edits — X.0 bump per the
# Document Versioning Rule. SCOPE section confirmed to already cover both
# additions without wording change (it's a blanket "this skill applies to
# new product lines only" statement, not tied to specific named
# procedures) — VM-01/PR-01 grandfather clause unchanged.
# Previous: 1.0 — 2026-07-05
# Owner: FIRST skill read for any NEW product design. See SCOPE below.
# Supersedes: .claude/SKILL_reference_point_first.md (kept for history —
# this file absorbs and formalizes its "ask the reference point first"
# habit into a full Skeleton / Datum Reference Frame / Parent-Child system).

---

## SCOPE — READ THIS FIRST

This skill applies to **new product lines only**, starting 2026-07-05.

**VM-01 (vending machine) and PR-01 (pilates reformer) are explicitly
grandfathered — do NOT retrofit either product to this system.**
Janis's direct instruction: "we do not want to redo entirely the vending
machine and my pilates, we apply this new system to later project only."

---

## PREREQUISITE — Read This Before the Worksheets Below

This skill's worksheets (Skeleton, BOM Tree, Kinetic Table) all consume
a `design_scope_of_work_rule.md` for this product — create that file
FIRST if it doesn't already exist for this product, using the customer-
requirement interview with Janis (owner-vocabulary features, envelope
target, appearance/UX — see the file's own filter: customer-recognizable/
marketing-headline content only, never implementation detail). Do not
begin the Skeleton Definition Worksheet until the scope file exists and
Janis has confirmed it. If a scope file already exists for this product
(e.g., a later design phase for an already-scoped product), read it in
full before starting the worksheets — every worksheet answer should
trace back to something the scope file actually says, not be invented
independently of it.

---

## TRIGGER PHRASES

- Janis requests a new product design, a new model line, or a new physical
  assembly that is not a continuation of VM-01 or PR-01
- "Let's design [new thing]" / "new product" / "new project" for anything
  outside the two grandfathered lines above
- Any time a NEW `.scad` file is about to be created for a product that
  doesn't already have committed versions in this repo

When triggered: this is the FIRST file read — before rules-dimensions.md,
before any component-sizing conversation, before any cc prompt.

---

## THE CORE STORY — read this before anything else

Janis, 2026-07-05: "You are designing where to put the left wheel on a
car that's parked in a soccer field. You do not measure the right wheel
from the right field edge, then compute right-wheel-position +
wheel-thickness + axle-beam-length = distance to put the left wheel. All
you need is: where is the coordinate of the right wheel? Set it (0,0).
Then put the left wheel at X = -250. Later, you put in a new axle design
that breaks into a 2-piece system and it creates a gap/mismatch problem.
Nothing happens to your left wheel. Fix the axle — the wheel stays where
it is."

**The field boundary is a Stranger. The right wheel is the Parent. The
left wheel is the Child.** A Child never measures itself from a Stranger
— only from its Parent.

This is not a hypothetical risk. VM-01-base-v41 hit exactly this bug:
`tray_0_z` and the door's `window_z0`/`window_z1` were each independently
measured from different starting points (leg height vs. flap geometry).
When the flap height changed, the window silently drifted ~170mm away
from the actual trays. Nobody had asked "what is this actually measured
FROM" before building it.

---

## THE FOUR RULES

### 1. Skeleton Layout First
Before proposing ANY component size, define the assembly's **Skeleton** —
an invisible map of the critical datums, centerlines, and planes that
everything else hangs off of. Individual parts do not reference each
other directly; they reference the Skeleton. In OpenSCAD this is a named
`DATUM_*` constant block (the same mechanism proven in
`VM-01-base-v42`'s DATUMS block — see `.claude/rules-codes.md` "Datum
Rules"). The difference for new products is TIMING: the Skeleton is
written FIRST, before any part is dimensioned — not bolted on afterward
once parts have already drifted apart from each other.

### 2. Every Coordinate Has a Defined Parent
A part's position is never a raw world-space number computed on the
spot. It is always `Parent's origin + offset (ΔX, ΔY, ΔZ)`. If the
Parent moves, the Child moves with it automatically, because the Child's
own coordinate IS that offset — not an independently re-derived absolute
value that happens to currently match. A Child can be parented to:
  - (a) the Skeleton itself (a `DATUM_*`), or
  - (b) another part's own local origin — a true parent-child
    relationship (e.g. a spring parented to its tray, not to the
    machine's world origin).
A Child can **never** reference a Cousin (a sibling part with no direct
relationship to it) or a Stranger (an unrelated global feature — "the far
wall," "the total width" — when the real relationship is local, e.g. "my
own hinge line").

### 3. The Football Field Rule
If a car moves across a field, the wheels move with the chassis, not the
field boundaries. Do not anchor a local component to a global or
unrelated edge just because that edge is convenient to measure from right
now. If a primary dimension changes, every child component must shift
automatically via its own local offset — never require a second,
independent edit somewhere else in the file to keep up. If you find
yourself writing "and also update X to match," the design isn't
Parent-Child yet — fix the reference, don't just fix the number.

### 4. Datums Before Sizes — Datum Reference Frame (DRF)
Before writing down a single component size, state the assembly's Datum
Reference Frame explicitly:
  - **Primary datum** — usually a plane. Establishes one axis's zero and
    prevents the whole assembly from "tipping" (e.g. the floor).
  - **Secondary datum** — a second plane or line, perpendicular to the
    primary. Locks two more degrees of freedom (e.g. a centerline or a
    back wall).
  - **Tertiary datum** — the third constraint. Fully locates everything
    (e.g. a side wall or a hinge line).
This is the same Primary/Secondary/Tertiary structure as mechanical
GD&T — formalized here because informal "measure from whatever's nearby"
is what caused the v41 desync bug. (Full GD&T remains explicitly out of
scope until this simpler version stops being enough — see
`.claude/SKILL_reference_point_first.md`'s "Not in scope yet" note.)

---

## PROCEDURE — CLAUDE WEB (Skeleton Definition Worksheet)

Before writing the FIRST cc prompt for a new product, complete this with
Janis in chat. Do not skip it, and do not infer answers without asking:

```
MASTER ORIGIN: (0, 0, 0) is at ___________________________
PRIMARY DATUM:   _______________ (plane) — locks _______ axis
SECONDARY DATUM: _______________ (plane/line) — locks _______ axis
TERTIARY DATUM:  _______________ (plane/line) — locks _______ axis

MAJOR SUB-ASSEMBLIES (one line each):
  [Name] — Parent: [SKELETON.DATUM_x / another sub-assembly] — offset: (ΔX, ΔY, ΔZ)
```

State the completed worksheet back to Janis explicitly and get
confirmation before any component sizing or the first cc prompt is
written. This is the Validator referenced in WORKFLOW_SKILL.md's
TRIGGER → ACTION → VALIDATOR table.

Ongoing discipline, every prompt after the first: before a build prompt's
TASKS section introduces a new shared reference point, ask — does this
belong in the Skeleton (2+ parts need it), or is it a true local
Parent-Child offset (only one part needs it, measured from its actual
Parent)? Never let a "just this once" absolute number back in.

---

## PROCEDURE — CLAUDE WEB (BOM Subassembly Tree)

Before writing the FIRST cc prompt for a new product, complete this
alongside the Skeleton Definition Worksheet — same timing, same
mandatory status. This is a DIFFERENT artifact from the Datum Skeleton:
the Skeleton answers "where is everything, geometrically, relative to
each other" — the BOM tree answers "what parts and subassemblies exist,
and how do they nest." Do not conflate the two, and do not skip one
because the other is done.

Build the tree to at least the subassembly level (not necessarily every
fastener, but every distinct part or grouped subassembly a supplier or
Janis would refer to by name):

```
[PRODUCT NAME] (top assembly)
├── [Major subassembly 1]
│   ├── [Part/sub-subassembly]
│   └── [Part/sub-subassembly]
├── [Major subassembly 2]
│   └── ...
└── [Major subassembly N]
```

State the completed tree back to Janis explicitly and get confirmation
before any component sizing or the first cc prompt is written — same
Validator discipline as the Skeleton Worksheet.

This tree becomes the seed for that product's `PART_MANIFEST.md` (plain-
language part identity registry, same convention already used for
VM-01/PR-01) — create it at this stage, not retrofitted later.

---

## PROCEDURE — CLAUDE WEB + CC (Kinetic Dual-View Convention)

For every part identified in the BOM tree above that moves in any way —
opens/closes, slides in/out, rotates, extends/retracts, or otherwise
articulates — BOTH end states must be established as explicit toggle
variables from that part's FIRST committed version, not added after the
fact:

- A tray or drawer: both fully-in AND fully-out (a percentage/travel
  variable is acceptable if the geometry genuinely needs a continuous
  range, but the confirmed-working end states are mandatory at minimum)
- A door, flap, or lid: both fully-closed AND fully-open
- A slide, rail, or telescoping part: both retracted AND extended

Claude Web's job before the first cc prompt: identify every kinetic part
from the BOM tree and list it in a simple table, confirmed with Janis:

```
KINETIC PART           | STATE A       | STATE B        | Notes
[part name]             [in/closed/…]   [out/open/…]     [range or discrete?]
```

cc's job, every time a kinetic part's geometry is authored or changed:
render/verify BOTH states before considering that part done — a part
that only demonstrably works in its default (usually closed/in) state is
NOT complete, regardless of how clean that single render looks. State
explicitly in cc_chat_log which states were actually verified, not just
which one was rendered by default.

**Why this is mandatory, not optional:** a toggle that exists in name but
was never wired to the actual geometry controlling it (or wired to the
wrong render-mode branch) produces a state that LOOKS like it works from
the default view and silently doesn't in the other — this already
happened once in VM-01 (`show_shell_top`, several sessions undiagnosed)
and is the exact failure mode this convention prevents by requiring both
states be checked from a part's very first version, not discovered as a
bug months later.

---

## PROCEDURE — CC (Skeleton Block + Parent Declarations)

Every new product's `.scad` file starts with a SKELETON block — the
`DATUM_*` convention from `.claude/rules-codes.md`, written FIRST, before
any module is drafted, not retrofitted after parts already exist:

```
// ─────────────────────────────
// SKELETON — single source of truth. Every part below declares its
// Parent explicitly (a DATUM_* below, or another part's local origin).
// No part may reference a Cousin or a Stranger. See
// .claude/SKILL_product_design_skeleton.md.
// ─────────────────────────────
DATUM_PRIMARY____   = ...;   // e.g. floor plane
DATUM_SECONDARY____ = ...;   // e.g. centerline
DATUM_TERTIARY____  = ...;   // e.g. side wall / hinge line
```

Every module gets a one-line Parent declaration comment immediately
inside its definition:

```
module wheel_left() {
    // Parent: wheel_right() local origin. Offset: X = -250 (fixed track width).
    ...
}
```

If a part contains sub-parts (a tray containing springs, a door
containing an acrylic pane and a flap), the sub-parts are dimensioned
relative to the PARENT part's own local origin — never the Skeleton
directly, and never a different part's origin. Move the parent, the
children move with it. This is the exact mechanism proven in
`VM-01-base-v42`'s `left_zone_door()`: local origin at the hinge line, all
sub-parts (window, flap, acrylic) offset from that one point, placed in
world space with a single `translate()`.

---

## ANTI-PATTERNS — NEVER DO THESE

- Never compute a part's position as `(global edge) ± (sum of other
  parts' sizes)`. That is measuring the left wheel from the field edge.
- Never let two parts independently re-derive the same shared reference
  point via separate formula chains — even if the values currently
  match. Reference the Skeleton datum directly.
- Never introduce a "temporary" hardcoded offset "just for now" during
  first-draft dimensioning — establish the Parent relationship correctly
  from the start, even in a rough first pass.
- Never let a Child module read a Cousin's local variable directly.

---

## RELATIONSHIP TO EXISTING FILES

- Supersedes `.claude/SKILL_reference_point_first.md` (kept for history
  — its "ask what's the reference point first" habit is the seed this
  file formalizes into the full Skeleton / DRF / Parent-Child system).
- `.claude/rules-codes.md` "Datum Rules" section is the CODE-LEVEL
  mechanism (`DATUM_*` naming, no independent re-derivation) — this file
  is the DESIGN-LEVEL discipline that must happen BEFORE any code is
  written for a new product.
- Does not change any VM-01 or PR-01 file or process. New products only.
