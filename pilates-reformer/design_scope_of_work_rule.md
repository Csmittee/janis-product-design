# Design Scope of Work — PR-01 Pilates Reformer
# Last updated: 2026-07-06 — updated whenever a NEW feature/goal is confirmed
# by the owner in any session, same session it's confirmed, not deferred.
#
# EXTRACTION NOTE: built from rules-dimensions.md (all PR-01 sections),
# PART_MANIFEST.md, CURRENT_STATE.md, cc_chat_log.md, and a representative
# sample of archived PR-01 prompts (not a literal line-by-line read of all
# ~20 of them — session time constraints; a research agent tasked with an
# exhaustive archive scan failed on a session usage limit mid-run). Treat
# this as a solid first pass, not a guaranteed-complete one — a follow-up
# pass reading every remaining archived PR-01 prompt individually (especially
# the early v8–v24 pole/housing build-out prompts) would be worth doing
# before treating any gap below as final.

## Product Identity

A Pilates reformer — a piece of home exercise equipment: a wood-legged bed
frame with a sliding surface, connected at each corner to a vertical pole,
with two horizontal crossbars the user grips. PR-01 is the base/fixed
version; a foldable variant is explicitly deferred to later, not part of
this product's current scope. [Source: rules-dimensions.md PR-01 sections;
PART_MANIFEST.md]

## Envelope Targets

- **Bed width (Y)**: 840mm — Janis-confirmed 2026-07-02, derived from a
  stated TARGET: a 720mm clear gap between the two long crossbars
  (bed_w = 720 + leg_t, leg_t=120mm unchanged). This 720mm crossbar-gap
  figure IS an explicit owner target (the bed width itself is the derived
  engineering consequence, not the primary target). Supersedes an earlier
  670mm PENDING value.
- **Pole diameter**: 40mm constant, no taper — this superseded an earlier
  ~50mm value (changed 2026-06-30 to proportionally fit the pole-top's
  neck within the bell-collar waist) and, before that, a full taper
  concept (varying radius base-to-top) that Janis rejected outright as
  "the wrong direction." 40mm sits above what's described as a "36mm
  market-standard floor" for reformer poles.
- **Crossbar grip diameter**: 32mm — OWNER-LOCKED, unchanged across every
  redesign of the pole itself.
- **Leg height**: 600mm (reconciled 2026-07-02 so the bed surface sits
  flush on top of the full-height leg, was 500mm before reconciliation —
  see Open Questions for how this interacted with a separate, shorter
  bed_frame() leg that had never been reconciled).
- No owner-stated overall LENGTH (X-axis, foot-to-head) target was found
  in the files read this session — NOT YET SPECIFIED BY OWNER, distinct
  from whatever bed_l happens to be in the current file.
[Source: prompts/archive/bed-width-720-crossbar-gap;
prompts/archive/PR-01-base-v7-4part-split-stage1;
prompts/archive/PR-01-bed-height-pad-cutaway-fix; rules-dimensions.md]

## Compartment / Section Map

Not a compartment-based product — the physical breakdown is by
sub-assembly:

- **Bed**: a frame + flat sliding surface (where the user lies), sized to
  the envelope targets above.
- **Legs (x4, one per pole)**: wood, with an embedded socket sleeve
  drilled through the leg (a pass-through channel, not a shallow bonded
  pocket) that the pole's base pushes directly into.
- **Poles (x4)**: constant-diameter (40mm) D-profile shafts — the "D"
  flat face lets a crossbar glide flush against it. Each pole is built
  from separately-assembled physical pieces (see Functional Features),
  not one continuous molded/printed part.
- **Pole-top junction**: where the crossbar locks/latches onto each pole
  — a smooth "vintage car side-mirror" form, bar attaches here, not
  through the pole's body.
- **Bell-shaped collar (copper/brass)**: the visible hardware where each
  pole meets its wood leg — pole pushes directly into the embedded leg
  socket, no external clamp/bracket.
- **Crossbars (x2, front + rear)**: horizontal tubes the user grips,
  spanning between the front pole pair and the rear pole pair.
[Source: rules-dimensions.md "4-Part Split Architecture", "Pole Holder,
Bell Collar — REVISED", "Socket/Leg Architecture"; PART_MANIFEST.md]

## Functional Features

1. Customer/owner self-assembles the pole from separate physical
   components — it is explicitly NOT a single continuous molded/printed
   pole. The 4 conceptual parts are: TOP (crossbar lock/latch junction),
   BODY (constant-diameter D-profile shaft, no taper), BASE COLLAR
   (connects body to the wood socket via an insert pin), WOOD SOCKET
   (cylindrical insert through the drilled leg hole).
2. The pole pushes directly into an embedded socket drilled through the
   wood leg — no external bracket/clamp holds it (this replaced an
   earlier external split-clamp collar concept, which Janis abandoned).
3. The bell-shaped collar (copper/brass) is the visible connection
   hardware at the pole-to-leg junction — an aesthetic/material choice
   confirmed live by Janis using an OpenSCAD Customizer session (dragging
   sliders for foot ring radius, dome height/curve character, knurled cap,
   copper washer reveal) rather than by verbal description — this was
   explicitly adopted as the preferred workflow for any future
   artistic/proportional decision on this product.
4. Crossbar passes through a hole drilled near the top of each pole (not
   through a separate bolt-on top collar) — the pole's own top acts as
   the collar.
5. A "tooth zone" (rack/gear adjustment strip) exists on the pole's flat
   face for a future glider-height adjustment mechanism — explicitly
   modeled as a placeholder groove only, not functional teeth yet (Stage
   2, not yet built as of the files read this session).
6. Foldable-hinge geometry is explicitly deferred — this product (PR-01)
   is the FIXED (non-folding) version only.
7. Lock/latch mechanism at the collar (thread + bayonet + knurled cap) is
   ENGINEER-PROPOSED, not Janis-measured or load-tested — built as
   simplified representative geometry pending a physical prototype
   fit-test, explicitly not a final manufacturing spec.
[Source: prompts/archive/PR-01-base-v7-4part-split-stage1;
prompts/archive/pr01-pole-redesign-and-coordinate-rule-v1;
prompts/archive/customizer-skill-and-bell-collar-confirm;
rules-dimensions.md "Lock Mechanism"]

## Appearance / Do-Not Features

- Bell collar hardware: copper/brass, bell-shaped, with a knurled brass
  cap and a copper washer reveal at the top — an explicit material/finish
  choice, Customizer-confirmed by Janis (not just an engineering
  placeholder color).
- Pole body: NO taper, NO lattice/truss/wireframe structure anywhere —
  both explicitly rejected by Janis after being tried in earlier versions
  (v6 reintroduced a lattice by mistake and was flagged as a regression to
  avoid repeating). Solid/shelled D-profile shaft only.
- NOT YET SPECIFIED BY OWNER: bed surface material/upholstery, overall
  color scheme, branding.

## Open Questions / Gaps Found During This Extraction

- **PR-01 is currently PAUSED, awaiting customer** (per CURRENT_STATE.md)
  — active/confirmed file is PR-01-assembly-v31.scad, visually/
  dimensionally identical to v30 (a file-consolidation-only change).
- **Socket not physically cut into the wood leg** — `leg_socket()` draws
  the wood leg as one solid cube and the socket sleeve as a separate tube
  occupying the same space, with no boolean difference actually removing
  wood to make room for the sleeve. Looks correct in a colored render but
  would not be physically manufacturable as-is. Found 2026-07-03, QA'd by
  Janis, explicitly NOT YET decided whether to fix now or accept as a
  known limitation — do not treat as resolved.
- **`pole_wood_socket()` (old, ~20mm shallow bonded-pocket design) is
  still actively called alongside the new `leg_socket()`** (>300mm
  pass-through sleeve) — flagged repeatedly across sessions as a likely
  redundancy, never resolved by any prompt read this session. Worth a
  decision on whether the old module should be retired.
- **Internal lock mechanism** (thread+cam single bezel vs. a 3-part
  reference system) was explicitly left undecided as of the bell-collar
  Customizer session — NOT YET SPECIFIED BY OWNER which approach is
  preferred.
- **Overall product length (bed_l, foot-to-head)**: no explicit owner
  target found in the files read this session, distinct from whatever
  value is currently in the .scad file.
- This document itself is a first pass built under a time-constrained
  session (see extraction note at top) — a follow-up read of the
  remaining archived PR-01 prompts not covered this session (the early
  pole/neck/housing/elbow-loft build-out prompts, v8 through v24) may
  surface additional confirmed owner decisions not captured here.
