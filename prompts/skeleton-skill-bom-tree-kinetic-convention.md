# cc Prompt — Add BOM Subassembly Tree + Mandatory Kinetic Dual-View
# Convention to SKILL_product_design_skeleton.md
# Date: 2026-07-07
# Documentation/governance only. Zero .scad files touched. Applies to
# NEW product lines only — same grandfather clause as the rest of this
# skill file (VM-01/PR-01 explicitly exempt).

## 1. CC INTRO

Session continuity check: main has changed since the last merge — treat
as FRESH regardless of your own session state.
git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → knowledge.map → cc_chat_log.md (first 3
entries) → .claude/SKILL_product_design_skeleton.md (full, current
version) → chat_rules.md → WORKFLOW_SKILL.md (CC PROMPT TEMPLATE section
+ TRIGGER table). State every file read before writing a single line.

Claude Web override: none.

## 2. CONTEXT

`SKILL_product_design_skeleton.md` currently establishes the Datum
Reference Frame / Skeleton Worksheet discipline (geometric parent-child
coordinate referencing) as the mandatory first step for any new product
line. It does NOT currently require two related things Janis has now
confirmed as equally mandatory, for the same reason the DRF worksheet
exists: without them defined up front, dynamic/moving-part coordinate
transforms get "stacked" — patched on after the fact — the exact pattern
behind this session's VM-01 bugs (a mode-gated toggle that silently did
nothing, a steel-bar patch added instead of real parented material,
toggles declared but never wired to the geometry they were meant to
control).

The two additions:

1. **BOM Subassembly Tree** — a hierarchical Bill of Materials (what
   parts/subassemblies exist and how they nest for procurement/assembly)
   is a DIFFERENT artifact from the Datum Skeleton (which is about
   geometric coordinate reference, not parts hierarchy) — but must be
   defined with the same day-one timing discipline, before any component
   sizing.
2. **Kinetic Dual-View Convention** — any part identified as moving
   (opens/closes, slides in/out, rotates, articulates in any way) must
   have BOTH of its states — e.g. tray-in AND tray-out, door-closed AND
   door-open, slide-retracted AND slide-extended — established as
   explicit toggle variables and confirmed renderable from the very first
   version of that part's geometry, not added later as an afterthought.

## 3. NEW FILES
None. Edit to existing `.claude/SKILL_product_design_skeleton.md`, plus
wiring updates to `cc_rules.md`, `chat_rules.md`, `WORKFLOW_SKILL.md`,
`knowledge.map` — same rollout pattern used when this skill file was
originally created (2026-07-05).

## 4. TASKS

### TASK 1 — Add "BOM Subassembly Tree" section to
### `SKILL_product_design_skeleton.md`

Add a new section, positioned alongside (not replacing) the existing
Skeleton Definition Worksheet, since both are completed together before
any component sizing. Content:

```markdown
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
```

### TASK 2 — Add "Kinetic Dual-View Convention" section

Add a new section:

```markdown
## PROCEDURE — CLAUDE WEB + CC (Kinetic Dual-View Convention)

For every part identified in the BOM tree (Task 1) that moves in any way
— opens/closes, slides in/out, rotates, extends/retracts, or otherwise
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
```

### TASK 3 — Update the SCOPE section

Confirm the existing SCOPE/grandfather clause language already covers
both new additions without change (VM-01/PR-01 exempt, new products
only) — state explicitly that no wording change was needed there, or
make the minimal edit if it doesn't already read that way.

### TASK 4 — Wire into governance files (same rollout pattern as
### 2026-07-05's original skill creation)

- `cc_rules.md`: add a one-line pointer under the existing new-product
  trigger, noting the BOM tree + kinetic table are now part of that same
  gate
- `chat_rules.md`: extend the existing "New Product Design Discipline"
  section (added 2026-07-05) with the BOM tree + kinetic convention as
  additional mandatory steps in the same worksheet-completion gate —
  do not create a new separate section, extend the existing one
- `WORKFLOW_SKILL.md`: update the TRIGGER → ACTION → VALIDATOR row for
  new product design to mention both new artifacts
- `knowledge.map`: update the GOVERNANCE section note on
  `SKILL_product_design_skeleton.md` to mention the expanded scope

Bump versions on all four files touched (detail addition — X.Y, not
X.0 — confirm this is consistent with the Document Versioning Rule
before deciding).

## 5. DO NOT TOUCH

- Any `.scad` file — zero geometry change
- The existing Datum Skeleton / DRF worksheet content — additive only,
  do not remove or reword existing sections
- The VM-01/PR-01 grandfather clause — confirm it still applies to both
  new sections, do not weaken or remove it
- `rules-dimensions.md`, `.claude/rules-codes.md` — unrelated to this
  governance addition
- `PART_MANIFEST.md` for VM-01/PR-01 — this prompt only establishes the
  convention for future products; existing files untouched

## 6. QA VERIFICATION

- [ ] BOM Subassembly Tree procedure added, positioned alongside (not
      replacing) the Skeleton Worksheet
- [ ] Explicitly distinguishes BOM tree (parts hierarchy) from Datum
      Skeleton (coordinate reference) — no conflation
- [ ] Kinetic Dual-View Convention added, both-states requirement stated
      clearly with concrete examples (tray, door, slide)
- [ ] VM-01's `show_shell_top` incident referenced as the concrete
      rationale, not an abstract justification
- [ ] Grandfather clause confirmed to still cover both new sections
- [ ] All four governance files (cc_rules.md, chat_rules.md,
      WORKFLOW_SKILL.md, knowledge.map) updated with consistent
      cross-references, versions bumped correctly per the Document
      Versioning Rule
- [ ] No `.scad` files touched — confirmed explicitly

## 7. MANDATORY CLOSING

1. Prepend `cc_chat_log.md` — newest entry at TOP, under 10 lines: BOM
   tree + kinetic convention added to skeleton skill, which governance
   files were updated and their version bumps
2. Archive this prompt → `/prompts/archive/` ✅ COMPLETE — 2026-07-07
3. Update `knowledge.map`'s own GOVERNANCE section entry for this skill
4. No dimension/SCAD files changed — confirm explicitly
5. Commit all → merge to main
