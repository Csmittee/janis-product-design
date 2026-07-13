CC PROMPT — bbq-offset-smoker-v1-init
=======================================
Repo location: bbq-offset-smoker/

TASK 1 — GOVERNANCE DOCS (create, do not skip)
------------------------------------------------
Create bbq-offset-smoker/design_scope_of_work_rule.md — customer-facing
scope only (owner vocabulary, features, envelope, appearance). Content
is finalized, use verbatim from this session's confirmed scope:

  Product Identity: Mobile wheeled octagonal-profile offset BBQ smoker,
  hobbyist-commercial grade, 2-3mm steel. V1 = pass-through smoke flow.

  Envelope: Cook chamber 915mm L x 610mm flat-to-flat cross-section.
  Grate height 700mm from ground (MASTER CONTROL VALUE, fixed).
  Firebox 457x457x457mm cube, floor 200mm below chamber floor
  [ASSUMPTION - Janis to confirm before final merge].

  Compartment Map / Functional Features / Appearance-DoNot / Made-Buy-Hire:
  [use full lists as confirmed across this session's chat log — pull from
  the two confirmed scope drafts, second one supersedes the first]

Create bbq-offset-smoker/rules-bbq-fab.md — technical/construction only,
NOT customer-facing:
  - Main chamber body: single flat blank, multi-bend press-brake
    (minimize weld seams vs. 8 separate flat panels)
  - All doors/access panels: 3mm joggle-step joint at opening edge for
    flush closure (material thickness = 3mm, joggle = 3mm)
  - File split: BBQ-chambers-v1.scad / BBQ-understructure.scad /
    BBQ-base-v1.scad (base includes both, handles final positioning)
  - Flat panels: design as 2D polygon -> linear_extrude for 3D view;
    same 2D geometry is the DXF export source for laser cutting
  - Formed panels (doors, end-caps): flat blank + marked fold line,
    bend allowance is supplier-verify, not computed here
  - Standard steel blank: 1250x2500mm (panels at this chamber size
    fit with no nesting/splitting needed)
  - Off-shelf placeholders (simple bbox/cylinder only, no detail):
    wheels, axle, wheel-axle joint, tow handle, spiral-wire firebox
    handle, toggle clamp latches, dome thermometer, drain valves
  - SIZING FORMULA (standing rule, reuse for all future firebox/window/
    chimney calcs on this product, do not re-derive per session):
      firebox_volume = chamber_volume / 3
      window_area = firebox_volume * 0.008
      intake_area = firebox_volume * 0.003
      chimney_volume = firebox_volume * 0.05  (diameter chosen for
        "fat over long" per Janis; built length by standard horizontal-
        smoker practice ~30-40in, NOT the raw volume/length formula;
        chimney top must stay <= 2.5m from ground)
      Source: feldoncentral.com/bbqcalculator.html, verified against its
      own worked example this session.

Create bbq-offset-smoker/SKELETON_WORKSHEET.md — Parts A/B/C exactly as
confirmed this session (grate-down consecutive-parent chain, BOM tree,
Kinetic Dual-View table). Copy verbatim from chat log.

TASK 2 — BBQ-chambers-v1.scad
------------------------------------------------
GLOBAL PARAMS (all mm, all locked this session):
  GRATE_Z = 700          // MASTER CONTROL VALUE
  grate_clearance = 100
  chamber_floor_z = GRATE_Z - grate_clearance   // 600
  chamber_L = 915
  chamber_W = 610
  chamber_H = 610
  chamfer = 150
  wall_t = 3
  firebox_size = 457
  firebox_drop = 200     // ASSUMPTION, flagged above, confirm w/ Janis
  firebox_floor_z = chamber_floor_z - firebox_drop
  window_w = 254
  window_h = 119
  intake_w = 107
  intake_h = 107
  chimney_d = 127
  chimney_len = 762      // built length, NOT the raw volume formula
  drop_tube_d = chimney_d - 20

DATUMS (per SKELETON_WORKSHEET Part A, consecutive chain, grate-down):
  1. Grill Grate plane — fixed at GRATE_Z, not derived
  2. Cook Chamber shell — parent: Grate plane, offset dZ=-100
  3. Firebox — parent: Cook Chamber back wall (Y=chamber_L), own floor
     parented independently per firebox_drop
  Local origin for this file: (0,0,0) at floor level, front-left,
  matches MASTER ORIGIN in SKELETON_WORKSHEET.

MODULES (verified locally, use this exact construction method — do not
re-derive the extrude/rotate approach, a sign-flip bug was already
caught and fixed in local render):

  chamber_profile() — 2D hexagon/chamfered-coffin profile, points:
    [-W/2,0] [W/2,0] [W/2,H-chamfer] [W/2-chamfer,H]
    [-W/2+chamfer,H] [-W/2+chamfer,H-chamfer]...
    (6-point chamfered box, flat floor, vertical sides, chamfered top
    corners, flat ridge — confirmed correct proportions in local render)

  chamber_shell() — translate([0,chamber_L,chamber_floor_z])
    rotate([90,0,0]) linear_extrude(height=chamber_L) chamber_profile();
    THEN shell it (wall_t=3mm thick, hollow interior) — local render
    prototype was solid-for-proportion-check only, cc must produce the
    real hollow shelled version with wall_t applied.

  firebox() — cube [firebox_size]^3, positioned at
    translate([-firebox_size/2, chamber_L, firebox_floor_z]),
    shelled to wall_t, hinged door on the outward-facing wall (opposite
    the chamber), 3mm joggle joint per rules-bbq-fab.md, air-intake
    damper (intake_w x intake_h) on the door, internal welded bar fire
    grate (simple bars, Made, not yet detailed — flag as open item),
    slide-out ash tray below the fire grate.

  window_cut() — rectangular hole (window_w x window_h) through the
    chamber's Y=chamber_L wall AND the firebox's facing wall, low,
    starting at chamber_floor_z (confirmed correct position/size in
    local render — do not resize).

  chimney() + drop_tube() — chimney mounted on the front shoulder
    (~Y=200, on the chamfer), base recessed 40mm into the shell for a
    clean weld joint, foldable at the base hinge (kinetic: deployed/
    folded per Kinetic table), internal drop-tube from chimney base
    down to GRATE_Z so smoke circulates low across the food, not a
    short-circuit top vent.

  Lid assembly — full chamfered-top + flat-top panel, hinged along the
    rear top edge, toggle-clamp latch points x2+ (placeholder hardware),
    counterbalance lever: ~10kg weight, 400mm lever arm off the hinge
    pivot (per this session's torque calc, target ~85-90% of full
    balance for slight self-closing bias — do not balance to 100%),
    full-width lift handle rail, 150mm standoff via 2+ mounting posts,
    dome thermometer port (placeholder).

  Grill grate — 3-4 removable laser-cut steel segments (Made) resting
    on an internal support ledge welded into the chamber, grate top
    at GRATE_Z exactly.

  Floor drain valves x2+ — placeholder valve geometry + Made welded
    boss, positioned in the chamber floor, spacing at your discretion
    (front third / back third of chamber length is reasonable, flag
    as a design choice if you deviate).

TASK 3 — BBQ-understructure.scad (basic placeholder pass, low churn)
------------------------------------------------
  Corner-tube welded frame, styled directly on the reference plan
  images (no deviation, per confirmed scope) — leg length DERIVED from
  chamber_floor_z minus wheel/caster clearance, NOT independently set
  (per revised Skeleton chain). 2 fixed casters (firebox/back end) +
  2 swivel casters (chimney/tow end) [placeholder geometry]. Tow handle
  at the chimney end [placeholder]. Two fold-up (vertical-stowed /
  horizontal-deployed) prep shelves, left+right, front of chamber.

TASK 4 — BBQ-base-v1.scad
------------------------------------------------
  Thin assembly file, includes both above, positions Cook Chamber on
  Understructure's mounting plane per the confirmed consecutive-parent
  chain. Save as BBQ-offset-smoker-base-v1.scad on completion.

QA REQUIREMENTS (standard for this project):
  - Full CGAL manifold sweep, Simple: yes required on every solid
  - Screenshot QA: iso, front, side, rear — minimum 4 angles
  - Error-Log clean
  - Confirm window_cut and firebox overlap produce a real continuous
    opening (matches local-render verification above), not two
    separate holes that don't align

------------------------------------------------
OPEN FLAG BEFORE MERGE: firebox_drop = 200mm is Claude Web's assumption,
not yet Janis's explicit number. Confirm or correct after first render.
