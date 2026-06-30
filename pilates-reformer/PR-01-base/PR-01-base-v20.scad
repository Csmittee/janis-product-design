// PR-01-base-v20.scad
// Janis Product Design — Pilates Reformer with Full Tower
// Version: v20 — pole_top_transition() rebuilt as an 8-step elbow loft (constant
// 47mm diameter, position+rotation interpolated from the neck's vertical Z-axis
// cross-section to the bell's horizontal X-axis cross-section) replacing the
// single hull() that produced the diagonal saddle-facet crease (v17-v19).
// Date: 2026-06-30
// Focus: Frame structure + joints only. No slider, no spring, no strap.
// Rules: rules-pr.md, rules-dimensions.md, .claude/rules-codes.md
//
// CONTEXT: v6 (one-piece continuous pole + taper) rejected by Janis (owner).
// v7 split pole into 4 SEPARATE physical components for self-assembly —
// TOP (crossbar lock/latch junction), BODY (constant-diameter D-profile
// shaft, no taper), BASE COLLAR (split-clamp sleeve to wood leg), WOOD
// SOCKET (shallow registration insert in drilled hole).
// v8 fixed crossbar seating gap + pole overshoot. v9 made pole_body() the
// full-height uniform D-profile and rebuilt pole_base_collar() as a
// split-clamp sleeve. v10 rebuilt pole_top() as an asymmetric foot/boot
// head+neck. v11 fixed the loft's elongation axis. v12 refined that
// silhouette. v13 rebuilt pole_top() as a true body-of-revolution bell/horn
// + external sleeve neck per Janis's sketch — but the bell's bore axis
// defaulted to Z (rotate_extrude's native axis) and never actually ended up
// horizontal along X, so the bell sat vertically like a chimney cap on top
// of the neck instead of forming a T-junction with the crossbar passing
// through it.
//
// v14 fixed the bell's bore axis (single rotate([0,90,0]) construction
// method) and switched the profile to wine-glass concave — but left a flag:
// the neck (anchored at the old independent z0 = bed_h+pole_h-top_boss_h
// formula) and the bell (anchored at xbar_z) were positioned independently,
// leaving an unverified ~24mm vertical gap between them, and the neck OD
// (built around the old pole_od=50mm) visually overpowered the bell's
// narrow waist.
//
// v15 — TWO FIXES per Janis's screenshot review of the v14 render:
//   ISSUE 1 (gap): pole_top_bell()'s local origin (its small face, local
//     Z=0) is translate()'d to world (cx,cy,xbar_z) BEFORE rotate/scale
//     reorient the rest of the solid around that fixed point — so the
//     bell's small (neck-side) face sits at world Z=xbar_z exactly. The
//     neck's top anchor is now DERIVED from that same point:
//       neck_top = xbar_z + neck_bell_overlap   (overlap = 0.2mm)
//     replacing the old independent z0 formula. This guarantees the neck's
//     top face overlaps 0.2mm into the bell's small-end face — both are
//     siblings inside the same color(){...} block (Rule M-1: implicit
//     union), so the 0.2mm volumetric overlap produces one continuous
//     manifold solid with no visible seam. pole_body()'s height was also
//     extended (body_h = neck_top - neck_h - bed_h) so its top reaches the
//     neck sleeve's new bottom with no gap there either (visual-contact
//     only — the 4 pole parts remain logically separate, not unioned).
//   ISSUE 2 (diameter/proportion): pole_od (pole_d) reduced 50mm→40mm
//     (Janis-approved this session, still above the 36mm market-standard
//     floor — an intentional upgrade, not a regression) specifically to
//     shrink the neck OD relative to the bell's waist. neck_wall_t reduced
//     6mm→3mm per side. neck_id kept at the unchanged v13/v14 formula
//     (pole_d+1 = 41mm, preserving the 0.5mm/side slip-fit clearance
//     mechanism) rather than being redefined directly off pole_od, so
//     neck_od = neck_id + 2*neck_wall_t = 47mm — ⚑ FLAG: 1mm more than
//     Janis's stated "pole_od + 2×3mm = 46mm" formula; see cc_chat_log.md
//     for the full discrepancy explanation (computed both ways).
//   ⚑ FLAG (computed via Python Bezier sampling, see cc_chat_log.md): the
//     bell's concave profile means its narrowest "waist" point is NOT at
//     the small end-face but partway along the curve (~22.25mm radius /
//     44.5mm diameter at z≈16.8mm out of head_h=90mm). The new neck_od
//     (47mm, or even Janis's stated 46mm) STILL EXCEEDS this waist by
//     ~1.5-2.5mm — proportion improved a lot (was much worse at the old
//     63mm neck_od) but not a clean fit yet. NOT resolved by reshaping the
//     bell's Bezier control points, since the bell exterior profile is
//     explicitly DO NOT TOUCH this round — flagged for Janis to confirm.
//   DO NOT TOUCH (per prompt) and left exactly as v14: bore diameter
//     (33mm), bore orientation (X-axis, re-verified unchanged — only the
//     neck's Z anchor formula changed, not pole_top_bell()'s rotate logic),
//     bell exterior profile (wine-glass concave taper), 2x M6 through-bolt
//     mechanism, pole_base_collar(), crossbar geometry. NOTE: pole_base_
//     collar()'s collar_id = pole_d+1 cascades automatically with the
//     global pole_d change (51mm→41mm) — its own code is untouched, this
//     is an automatic side effect of the approved dimension change, flagged
//     in cc_chat_log.md for Janis's awareness.
//   - ⚑ FLAG: pole_body() still has NO through-holes of its own to align the
//     neck's M6 bolt holes against (unchanged flag carried over from v13).
//   - $fn=64 still applied locally inside pole_top() only.
//
// v16 — Janis flagged two problems from the v15 render: (A) neck centerline
// appeared offset from the bell's axis, (B) neck unioned too far into the
// bell, plugging the bore opening so the 32mm bar would strike it.
//   ROOT CAUSE ANALYSIS (Issue A): coordinate check confirms pole_top_neck()
//     and pole_top_bell() were ALREADY both anchored at the same (cx,cy) —
//     there was never a true coordinate offset. The visible "offset" in the
//     v15 render is explained by Issue B: the old neck_top (xbar_z+0.2) put
//     ~16.7mm of solid neck material INSIDE the bore's void (bore spans
//     xbar_z±16.5), so the rendered bore opening read as asymmetric/
//     off-axis where the neck plugged it. Fixing B directly resolves what
//     was reported as A — verified by the math below, not invented as a
//     separate coordinate fix (no second bug found).
//   FIX (Issue B): neck_top repositioned from xbar_z+neck_bell_overlap to
//     xbar_z - top_bore_d/2 - neck_bore_clearance (2mm safety margin below
//     the bore's bottom edge). At x=cx (the bell's small face), the bell's
//     solid wall directly under the bore spans z=[xbar_z-head_small_r,
//     xbar_z-top_bore_d/2] (the 23.5mm exterior radius minus the 16.5mm
//     bore radius = a 7mm band of solid material below the bore). New
//     neck_top=xbar_z-18.5 sits inside that band — verified via Python:
//     5mm solid overlap depth with the bell wall, 2mm clear of the bore
//     void. Bolt hole z-positions (still neck_h*0.3/0.7 from neck_top)
//     recompute to xbar_z-53.5 and xbar_z-33.5 — both well below the bore's
//     bottom edge (xbar_z-16.5), so the M6 mounting zone clears the bore
//     with large margin automatically, no separate adjustment needed.
//   DEFENSIVE GUARANTEE: in addition to the repositioning above, an
//     explicit bore-envelope cylinder (top_bore_d, world-X axis, centered
//     on the bore's true position) is now subtracted from the neck as well
//     as the bell — this makes "no neck geometry crosses into the bore"
//     a code-provable guarantee rather than a position-tuning assumption,
//     so it holds even if future dimension changes shift the numbers above.
//   Unchanged: bore diameter (33mm), bore axis (X), bell wine-glass profile,
//     pole_od=40mm / neck_od=47mm from v15, 2x M6 through-bolt mechanism,
//     pole_body(), pole_base_collar(), crossbar geometry.
//
// v17 — Janis QA'd v16 via F5/F6: FAIL, two issues, both alignment/clearance
// (not a redesign):
//   TASK 1 (true centerline re-derivation, not assumed): re-derived from the
//     actual transform chain rather than trusting v16's stated conclusion.
//     Bell's bore axis: pole_top_bell() builds the bore along local Z at
//     (x,y)=(0,0), then applies rotate([0,90,0]) -> scale([dir,1,1]) ->
//     translate([cx,cy,xbar_z]) (innermost-to-outermost). rotate([0,90,0])
//     maps local Z to local X, so the axis becomes the line {y=0,z=0,
//     x∈[0,head_h]}; scale([dir,1,1]) keeps that line (y=0,z=0); translate
//     places it at world {y=cy, z=xbar_z, x∈[cx, cx+dir*head_h]}.
//     Neck's central axis: pole_top_neck() is translate([cx,cy,...])
//     cylinder(...) (default Z-axis) -> world line {x=cx, y=cy, z∈ℝ}.
//     These two lines intersect at exactly (cx, cy, xbar_z) — COINCIDENT,
//     confirmed by direct derivation, not assumption. No discrepancy found;
//     v16's stated conclusion holds for this specific check. (The v15/v16
//     visual "offset" Janis saw was the bore-plug issue, already fixed in
//     v16 — re-verified unchanged here.)
//   TASK 2 (seam blend — NEW pole_top_transition() module): the neck
//     (vertical cylinder, axis Z) meets the bell (horizontal lofted
//     body-of-revolution, axis X) at a right-angle T-junction — even though
//     neck_od (47mm) already equals head_small_r*2 (47mm, no diameter step),
//     the abrupt change from a straight vertical wall to the curving bell
//     profile read as a hard seam in Janis's render. Added
//     pole_top_transition(cx,cy,dir,neck_top): hull() between a thin disc at
//     the neck's top cross-section (axis Z, centered (cx,cy,neck_top)) and a
//     short same-diameter cylinder slice at the bell's small face (axis X,
//     centered (cx,cy,xbar_z)) over neck_bell_transition_h (TBD, 8-12mm
//     range — 10mm chosen, flagged for Janis's aesthetic confirmation, not
//     final). hull() of these two cross-sections produces a smooth tapered
//     fillet bridging the vertical-to-horizontal junction instead of a hard
//     corner. Placed inside the SAME difference() that already subtracts
//     the bore-envelope cylinder from the neck (re-using v16's defensive
//     bore cut verbatim, not duplicated) — so the transition is bore-safe
//     by construction: it cannot intrude the bore void regardless of its
//     hull geometry, the same guarantee already proven for the neck. Neck,
//     transition, and bell remain siblings in the same color() block ->
//     Rule M-1 implicit union -> one continuous manifold solid.
//   TASK 3 (bolt edge clearance): neck_h increased 50mm -> 70mm (within the
//     65-70mm suggested range) to create real margin. Bolt hole Z-positions
//     recomputed explicitly against the new neck_h (NOT the old 0.3/0.7
//     fraction split): holes placed at neck_top-20 and neck_top-50. neck
//     spans [neck_top-70, neck_top], so:
//       hole 1 (neck_top-20): 20mm from top/seam edge, 50mm from bottom edge
//       hole 2 (neck_top-50): 50mm from top/seam edge, 20mm from bottom edge
//     Both holes clear the 15mm TBD minimum (pending real fastener/casting
//     spec) with 5mm extra margin each. pole_body()'s body_h formula
//     (= (neck_top - neck_h) - bed_h) already derives from the neck_h
//     global, so it automatically shortens to keep meeting the neck's new
//     (lower) bottom with no gap — no code change needed in pole_body().
// DO NOT TOUCH (per prompt, re-verified unchanged): bore diameter (33mm),
//   bore axis (X), bell wine-glass exterior profile, pole_od (40mm),
//   neck_od (47mm), pole_base_collar(), pole_wood_socket(), crossbar
//   geometry, latch/cam/lever mechanism (Stage 2, still deferred).
// ⚠ No OpenSCAD binary in this sandbox — this is a code-review + coordinate-
// math verification only. Janis must F5/F6 render and confirm visually
// before this is treated as PASS.
//
// v18 — Janis flagged two ROOT-CAUSE problems from the v17 render (inline
// chat message + 5 screenshots), both unresolved since earlier versions:
//   PROBLEM 1 (cone datum point wrong): pole_top_bell()'s small face — its
//     local-origin anchor — was being placed directly at (cx,cy,xbar_z), so
//     the bell's ENTIRE head_h-length body extended outward from that point
//     in the dir direction. The neck (at x=cx) was therefore only ever
//     touching the bell's small-face EDGE, not its centerline/body — the
//     cone read as bolted on sideways instead of mounted T-style. FIX:
//     re-anchor so the bell's MIDPOINT along its bore axis (not its small
//     face) sits at (cx,cy,xbar_z) — translate([cx,cy,xbar_z]) changed to
//     translate([cx - dir*head_h/2, cy, xbar_z]) in pole_top_bell(). Proof
//     this creates a true T-junction: the bore's local axial midpoint
//     (local Z = head_h/2 before the single rotate([0,90,0])) maps to local
//     X = head_h/2 after rotate, then scale([dir,1,1]) keeps it at
//     dir*head_h/2, then the new translate places it at world X =
//     (cx - dir*head_h/2) + dir*head_h/2 = cx exactly — i.e. the bore's own
//     center now sits on the neck's centerline (x=cx), perpendicular to it,
//     which is the actual T-junction Janis described (horizontal bar
//     mounted through a vertical post, not balanced on the post's tip).
//     The defensive bore-envelope cut in pole_top() (translate([cx,cy,
//     xbar_z]) rotate([0,90,0]) cylinder(center=true,...)) was ALREADY
//     centered at (cx,cy,xbar_z) — no change needed there, it now matches
//     the recentered bore automatically. pole_top_transition()'s bell-side
//     anchor DID need updating: it previously assumed the bell's small face
//     sat at (cx,cy,xbar_z); now that the bell is recentered, its small
//     face sits at world X = cx - dir*head_h/2, so the transition's far
//     anchor moved from translate([cx,cy,xbar_z]) to
//     translate([cx - dir*head_h/2, cy, xbar_z]) to keep hulling against
//     the bell's actual (now-shifted) small face instead of empty space.
//   PROBLEM 2 (D-profile mismatch at neck/body joint): pole_body() is a
//     D-section (round cylinder with one flat face cut via a cube at
//     cut_x0 = dir>0 ? 0.7*pole_r : -(pole_r+1)), but pole_top_neck() has
//     always been a plain round tube, so the round neck bottom could never
//     seat flush against pole_body()'s flat top face — a visible gap/step
//     at the joint. FIX: pole_top_neck() now carries the SAME flat-cut
//     plane (flat_x = dir*0.7*pole_r, identical formula to pole_body(), so
//     the planes are guaranteed coplanar, not just visually close) down
//     through a new lower "fully-D" zone of height d_zone_h = neck_h -
//     neck_round_taper_h (= 70-15 = 55mm), flush against pole_body()'s flat
//     face with zero gap by construction. Above that, a hull()-tapered cut
//     (full flat_x cut width at z=d_zone_h, shrinking linearly to a 0-width
//     sliver at z=neck_h) blends the flat face back to a clean round
//     cross-section over neck_round_taper_h (15mm, new global param) so the
//     neck still reads as round where it meets pole_top_transition()/the
//     bell — matching the existing (unchanged) round-to-round geometry of
//     pole_top_transition() and pole_top_bell() exactly; neither of those
//     modules needed any change for this fix.
//   BOLT CHANGE: 2x M6 through-bolts moved from the round wall to the new
//     flat D-face — more stable tightening surface, naturally available
//     once the D-profile reaches the neck. Rotation changed from
//     rotate([90,0,0]) (bolt axis along Y, through the round side wall) to
//     rotate([0,90,0]) (bolt axis along X, perpendicular through the flat
//     face — the same axis convention pole_top_bell()'s bore already uses).
//     Z-positions kept inside the fully-D zone [neck_top-70, neck_top-15]:
//     neck_top-25 (25mm from top edge / 45mm from bottom edge / 10mm from
//     the flat-zone's own top boundary) and neck_top-50 (50mm from top edge
//     / 20mm from bottom edge) — both still clear bolt_edge_clearance_min
//     (15mm TBD) against the neck's OUTER edges, same numbers as v17 (only
//     the rotation axis changed, not the Z positions).
// DO NOT TOUCH (re-verified unchanged): bore diameter (33mm), bell wine-
//   glass exterior profile/control points, pole_od (40mm), neck_od (47mm),
//   pole_base_collar(), pole_wood_socket(), crossbar geometry, latch/cam/
//   lever mechanism (Stage 2, still deferred).
// ⚠ No OpenSCAD binary in this sandbox — code-review + coordinate-math
// verification only. Janis must F5/F6 render and confirm visually before
// this is treated as PASS.
//
// ⚠ Stage 1 of 2 — architecture and resizing only. Detailed quick-release
// latch/cam/lever mechanism is Stage 2 (separate future prompt) — NOT built
// here. Wall thickness around the bore kept generous so that future stage
// isn't geometrically blocked.
// ⚠ REGRESSION CHECK: no lattice/truss/wireframe geometry anywhere — body
// is a solid D-profile only (v4 removed it, v6 mistakenly reintroduced it).
// Foldable hinge geometry explicitly deferred — not built here.
//
// v19 — TWO INDEPENDENT ITEMS (per SKILL_joint_construction.md, handled differently):
//   ITEM A (pole_top_transition() coordinate dump — DIAGNOSTIC ONLY, NO CHANGE):
//     v17/v18's single hull() between the neck's top disc (axis Z) and the bell's
//     small-face cylinder slice (axis X) is the exact pattern flagged WRONG by
//     SKILL_joint_construction.md Rule 2 — confirmed by Janis's screenshots as
//     crossed diagonal facet creasing. Per the skill file's ISOLATION-TEST-FIRST
//     discipline, this version only DUMPS the actual coordinates (see
//     cc_chat_log.md for the full numeric report) — pole_top_transition() itself
//     is byte-for-byte unchanged from v18. Claude Web reviews those numbers next.
//   ITEM B (bell profile wine-glass both ends + head_large_r -6mm):
//     pole_top_bell()'s control point p2 changed from
//     [head_large_r*0.60, head_h*0.70] (pulled in sharply only 30mm before the
//     large face -> reads as a last-instant horn flare) to
//     [head_large_r*0.80, head_h*0.65] — same 80%-pull-in proportion AND same
//     35%-of-head_h offset-from-its-own-end as p1 already uses at the small end
//     (p1 = [head_small_r*0.80, head_h*0.35]) — i.e. now a true mirror-symmetric
//     wine-glass curve, not a one-sided fix. head_large_r reduced 46mm -> 40mm
//     (exactly 6mm per Janis's request); still > head_small_r (23.5mm) by 16.5mm
//     margin. Python Bezier sampling (11 points, t=0..1, see cc_chat_log.md)
//     confirms curve_r < chord_r at every interior t — concave at both ends, no
//     interior convex bulge. Bore (33mm, X axis), pole_top_transition(),
//     pole_top_neck(), pole_top() bolt geometry, neck_od, all DO NOT TOUCH items
//     — unchanged, this is an exterior-profile-only edit to pole_top_bell().
//
// v20 — pole_top_transition() ELBOW LOFT FIX (Prompt 2 of 2, per v19's coordinate-
// dump root cause): the seam crease since v17 was never a shape/size mismatch
// (both ends already round, both 47mm = neck_od) — it was a 90 degree AXIS-
// ORIENTATION mismatch (neck top disc on Z-axis vs bell small-face disc on
// X-axis) plus a 3D position offset, bridged by a single hull() — that twisted,
// non-coplanar, non-parallel-axis jump is what produced the diagonal saddle
// facet. FIX: pole_top_transition() now lofts 8 intermediate cross-sections
// (constant neck_od=47mm diameter throughout, zero diameter drift) between the
// neck-top anchor (cx,cy,neck_top) and the bell-small-face anchor
// (bell_small_face_x,cy,xbar_z), derived from the SAME existing variables (no
// hardcoded 45/18.5 numbers). Position is interpolated with a smoothstep ease
// (t_eased = t*t*(3-2*t)) so the tangent stays vertical near the neck and
// horizontal near the bell (no kink at either end); rotation is interpolated
// linearly (rotate([0, 90*t, 0])) from 0 deg (neck's default Z-axis cylinder
// orientation) to 90 deg (bell's existing rotate([0,90,0]) orientation). The 7
// adjacent step pairs are each hull()'d (smooth local transitions, never a
// single hull() spanning the full 90 deg / 48.65mm twist) then union()'d into
// the final solid. Exact numeric (x,y,z,rotation_deg) for all 8 steps, the t=0/
// t=1 zero-delta match against the neck/bell's existing cross-sections, and the
// bore-envelope clearance distance at every step are stated in cc_chat_log.md
// (not just "looks smooth"). The bore-envelope subtraction in pole_top()'s
// outer difference() already wraps the ENTIRE union(pole_top_neck(),
// pole_top_transition()) both before and after this change — no edit needed
// there, the cut is inherited automatically across all 8 new steps, same
// defensive guarantee already proven for the neck (v16+) and the bell's own
// small face. DO NOT TOUCH items re-verified unchanged: bore (33mm, X axis),
// bell wine-glass profile (both ends, v19), head_large_r (40mm)/head_small_r
// (23.5mm), pole_od (40mm), neck_od (47mm), neck_h, D-profile zone, bolt
// positions/orientation, pole_body(), pole_base_collar(), pole_wood_socket(),
// crossbar geometry.
// ⚠ No OpenSCAD binary in this sandbox — code-review + coordinate-math
// verification only. Janis must F5/F6 render to confirm visually (specifically:
// confirm the diagonal crease is gone) before this is treated as PASS. Per
// SKILL_joint_construction.md isolation discipline this is Prompt 2 of 2 — if
// this fails QA, R-111 fires again and escalates to Janis directly.

// ── Global ────────────────────────────────────────────────────────────
e           = 0.01;   // epsilon — z-fight prevention
$fn         = 32;     // default resolution (use 64 for final render)

// ── Bed dimensions ────────────────────────────────────────────────────
bed_l       = 2300;   // total bed length (longitudinal) — PENDING Janis confirm
bed_w       = 670;    // total bed width — PENDING Janis confirm
bed_h       = 500;    // floor to top of bed surface — PENDING Janis confirm
leg_w       = 180;    // bed leg width — unchanged from v6
leg_t       = 120;    // bed leg depth — unchanged from v6
frame_rail_t = 60;    // bed rail thickness (wood) — PENDING
frame_rail_h = 120;   // bed rail height — PENDING

// ── Pole body — constant D-profile, NO TAPER (rules-dimensions.md v6, PR-01) ──
pole_d        = 40;   // body diameter (pole_od) — v15: 50mm→40mm, Janis-approved this session to proportionally fit the neck within the bell's waist; see rules-dimensions.md
pole_r        = pole_d / 2;
pole_h        = 1600;  // exposed pole height above bed surface — PENDING

// ── Pole TOP — bell/horn body-of-revolution head + external sleeve neck ────
// Per Janis hand sketch (BAR/POLE annotated): small circular end-face (tail/
// neck side) smoothly tapers to a large circular end-face (pipe-entry side),
// constant-diameter horizontal through-bore for crossbar, neck is now a
// slip-fit sleeve over pole_body() fastened via 2x M6 through-bolts.
neck_h         = 70;    // v17: 50mm->70mm (within 65-70mm suggested range) — creates real bolt-hole-to-edge margin, see header for math
neck_wall_t    = 3;     // v15: 6mm→3mm per side, Janis-specified this round
neck_id        = pole_d + 1;       // = 41mm — slip-fit clearance over pole_od (40mm), 0.5mm/side, unchanged mechanism from v13/v14
neck_od        = neck_id + 2 * neck_wall_t;  // = 47mm — ⚑ FLAG: 1mm more than Janis's stated 46mm (pole_od + 2×3mm) because this keeps the unchanged 1mm slip-fit clearance formula from v13/v14 rather than building neck_od directly off pole_od; see cc_chat_log for the actual-vs-stated comparison
neck_or        = neck_od / 2;      // = 23.5mm — also doubles as head_small_r (continuous, no step)
neck_bell_overlap = 0.2; // v15 — superseded as pole_top()'s neck_top anchor in v16 (see neck_bore_clearance below), kept only for reference/history
neck_bore_clearance = 2; // v16 NEW — safety margin (mm) kept between the neck's top face and the bore's bottom edge (xbar_z - top_bore_d/2), so neck_top = xbar_z - top_bore_d/2 - neck_bore_clearance never crosses into the bore's clear envelope
neck_bell_transition_h = 10; // v17 NEW — TBD (8-12mm range), height of the hull() blend zone bridging the neck's top cross-section into the bell's small face, flagged for Janis's aesthetic confirmation, not final
bolt_edge_clearance_min = 15; // v17 NEW — TBD placeholder minimum (mm) pending real fastener/casting spec, each M6 bolt hole must clear both neck edges by at least this much
neck_round_taper_h = 15; // v18 NEW — TBD, height (mm) of the hull()-tapered blend zone at the TOP of the neck where the D-profile flat cut shrinks back to round, so the neck still meets pole_top_transition()/pole_top_bell() as a clean round section
head_h         = 90;    // head height (Z) — compact/short per v12 direction, reshaped into bell taper
top_boss_h     = neck_h + head_h;  // = 140mm — unchanged role, still drives xbar_z only (crossbar geometry untouched)
head_small_r   = neck_or;          // = 23.5mm — small end-face radius, matches neck OD (continuous transition)
head_large_r   = 40;    // v19: 46mm -> 40mm, Janis-requested 6mm reduction, still > head_small_r (23.5mm) by 16.5mm margin — large end-face radius (pipe-entry side), not tied to pole_od
head_loft_steps = 12;   // number of Bezier sample steps for the outer revolve curve, 13 points total
top_bore_d     = 33;    // TBD — grip_od(32) + 1mm/-0mm clearance, pending physical fit test vs real 32mm pipe, unchanged from v10-v14 (DO NOT TOUCH per v15 prompt)
neck_bolt_d    = 6.5;   // TBD — M6 through-bolt clearance hole diameter (bolt + nut, not a blind/threaded hole)

// ── Pole BASE COLLAR — split-clamp sleeve (Stage 2 = precision fit) ────
// Wraps BOTH the lower pole_body() and the top of the wood leg, spanning
// across the bed_h surface line. Split into 2 halves (front/back, cut along
// the Y centerline), joined by 3 bolt bosses per split face (6 total).
// Clamp carries the holding force — the registration pin below is
// alignment-only, not load-bearing. All values TBD — see cc_chat_log.
collar_wrap_h       = 120;            // TBD — total wrap height, split evenly above/below bed_h
collar_wall_t       = 8;              // TBD — wrap wall thickness
collar_bolt_d       = 4;              // TBD — bolt clearance hole diameter
collar_bolt_boss_d  = 10;             // TBD — boss diameter around each bolt hole
collar_id           = pole_d + 1;     // inner clearance around pole_body (0.5mm/side)
collar_od           = collar_id + 2 * collar_wall_t;
collar_z0           = bed_h - collar_wrap_h / 2;  // split roughly evenly above/below bed_h line
pin_d               = 16;             // unchanged — registration pin diameter
pin_h               = 18;             // TBD — reduced for new shallow socket, must be <= socket_depth

// ── Pole WOOD SOCKET — shallow registration insert (rules-dimensions.md v6, PR-01) ──
// Registration/alignment only — NOT load-bearing (split-clamp collar carries the holding force).
socket_od     = 60;    // ~60mm fixed-version OD — Janis-confirmed, unchanged
socket_depth  = 20;     // TBD — shallow registration depth, see cc_chat_log
socket_bore_d = pin_d + 0.5;  // bore clearance for registration pin — M-PR-1, never exact pin_d

// ── Grip bar (crossbar) ───────────────────────────────────────────────
grip_od     = 32;     // OWNER-LOCKED — do not change without Janis approval
grip_l      = bed_l - leg_w;  // pole-center to pole-center (X-axis), not bed edge to edge
grip_offset = 0;       // lateral offset from pole centerline — TBD

// ── Debug toggles ─────────────────────────────────────────────────────
show_bed           = true;
show_pole_tops     = true;
show_pole_bodies   = true;
show_base_collars  = true;
show_wood_sockets  = true;
show_crossbars     = true;

// ── Derived ───────────────────────────────────────────────────────────
surface_t   = 30;     // bed surface platform thickness

// Pole corner X positions — [front-left, front-right, rear-left, rear-right]
pole_cx = [leg_w/2, bed_l - leg_w/2, leg_w/2, bed_l - leg_w/2];
// Pole corner Y positions
pole_cy = [leg_t/2, leg_t/2, bed_w - leg_t/2, bed_w - leg_t/2];

// Crossbar Y positions — front row / rear row
xbar_y_front = pole_cy[0];
xbar_y_rear  = pole_cy[2];

// Crossbar Z — seats mid-height inside the pole_top() boss (does NOT bore through pole_body())
xbar_z = bed_h + pole_h - top_boss_h * 0.5;

// ═════════════════════════════════════════════════════════════════════
// MODULES — BED
// ═════════════════════════════════════════════════════════════════════

module bed_frame() {
    color("#C8A96E", 1.0) {
        for (i = [0:3]) {
            translate([pole_cx[i] - leg_w/2, pole_cy[i] - leg_t/2, 0])
                cube([leg_w, leg_t, bed_h - surface_t]);
        }
        translate([0, 0, bed_h - surface_t - frame_rail_h])
            cube([bed_l, frame_rail_t, frame_rail_h]);
        translate([0, bed_w - frame_rail_t, bed_h - surface_t - frame_rail_h])
            cube([bed_l, frame_rail_t, frame_rail_h]);
        translate([0, 0, bed_h - surface_t - frame_rail_h])
            cube([frame_rail_t, bed_w, frame_rail_h]);
        translate([bed_l - frame_rail_t, 0, bed_h - surface_t - frame_rail_h])
            cube([frame_rail_t, bed_w, frame_rail_h]);
    }
}

module bed_surface() {
    color("#222222", 1.0)
        translate([0, 0, bed_h - surface_t])
            cube([bed_l, bed_w, surface_t]);
}

// ═════════════════════════════════════════════════════════════════════
// MODULES — POLE COMPONENTS (4 separate, logically distinct solids)
// ═════════════════════════════════════════════════════════════════════

// pole_wood_socket() — plain cylindrical insert pushed through drilled hole in wood leg.
// Sits inside the bed leg, below pole_base_collar(). Plain cylinder, no taper, no thread.
module pole_wood_socket(cx, cy) {
    color("#888888", 1.0)
        translate([cx, cy, bed_h - socket_depth])
            cylinder(h = socket_depth, d = socket_od, $fn = 64);
}

// pole_base_collar_half() — one half of the split-clamp sleeve (front or back).
// side = +1 → back half (y >= cy seam), -1 → front half (y <= cy seam).
// Wraps both pole_body() and the wood leg top, spanning across bed_h. 3 bolt
// bosses on this half's split face — mating half carries the other 3 (6 total).
module pole_base_collar_half(cx, cy, side) {
    half_h = collar_wrap_h;
    color("#2C3E50", 1.0)
        translate([cx, cy, collar_z0])
            difference() {
                union() {
                    difference() {
                        cylinder(h = half_h, d = collar_od, $fn = 64);
                        translate([0, 0, -e])
                            cylinder(h = half_h + 2 * e, d = collar_id, $fn = 64);
                    }
                    // 3 bolt bosses along the split (seam) face, evenly spaced in height
                    for (bz = [half_h * 0.2, half_h * 0.5, half_h * 0.8])
                        translate([0, side * (collar_bolt_boss_d / 2 - e), bz])
                            rotate([90, 0, 0])
                                cylinder(h = collar_bolt_boss_d, d = collar_bolt_boss_d, $fn = 32, center = true);
                }
                // keep only this half — cut away material on the far side of the seam plane
                translate([-collar_od, side > 0 ? -collar_od : 0, -e])
                    cube([collar_od * 2, collar_od, half_h + 2 * e]);
                // bolt through-holes at the same 3 heights
                for (bz = [half_h * 0.2, half_h * 0.5, half_h * 0.8])
                    translate([0, 0, bz])
                        rotate([90, 0, 0])
                            cylinder(h = collar_bolt_boss_d * 2, d = collar_bolt_d, $fn = 32, center = true);
            }
}

// pole_base_collar() — split-clamp sleeve: 2 visually separate halves (not unioned,
// consistent with how the other pole components are kept logically separate) +
// a single registration pin protruding into the shallow pole_wood_socket().
module pole_base_collar(cx, cy) {
    pole_base_collar_half(cx, cy, 1);   // back half
    pole_base_collar_half(cx, cy, -1);  // front half
    color("#2C3E50", 1.0)
        translate([cx, cy, bed_h - pin_h])
            cylinder(h = pin_h + e, d = pin_d, $fn = 64);
}

// pole_body() — D-profile shaft, constant 50mm diameter, FULL exposed pole height
// (single uniform extrusion, no base-zone offset). No bar-insert bore — crossbar
// no longer passes through the body (that is pole_top()'s job).
// dir: front pole flat faces +X (rear); rear pole flat faces -X (front) — rules-pr.md
module pole_body(cx, cy) {
    dir = (cx < bed_l / 2) ? 1 : -1;
    cut_x0 = dir > 0 ? 0.7 * pole_r : -(pole_r + 1);
    // v16: neck_top formula updated to match pole_top()'s new bore-clearance anchor
    // (xbar_z - top_bore_d/2 - neck_bore_clearance, replacing v15's xbar_z+overlap)
    // so pole_body()'s top still reaches the neck sleeve's new (lower) bottom with no
    // visible gap. Visual-contact requirement only; components remain logically
    // separate (not unioned) per the established 4-part architecture.
    neck_top = xbar_z - top_bore_d / 2 - neck_bore_clearance;
    body_h = (neck_top - neck_h) - bed_h;
    color("#CCCCCC", 1.0)
        translate([cx, cy, bed_h])
            difference() {
                cylinder(h = body_h, r = pole_r, $fn = 64);
                translate([cut_x0, -pole_r - 1, -e])
                    cube([0.3 * pole_r + 1, pole_r * 2 + 2, body_h + 2 * e]);
            }
}

// pole_top_neck() — external sleeve, hollow tube (neck_id slip-fit clearance over
// pole_od, neck_wall_t wall) that slides OVER the top neck_h of pole_body() from
// outside (NOT an insert pin like v10-v12). z_top = head base (= top of pole_body(),
// unchanged anchor) — sleeve spans downward from z_top so it overlaps the top
// neck_h-length of the existing pole_body() cylinder. pole_body() itself is untouched.
// v18 NEW: carries pole_body()'s D-profile flat-cut plane (flat_x, identical formula
// to pole_body()'s cut_x0) down through the lower d_zone_h of the neck so it seats
// flush (coplanar, not just close) against pole_body()'s flat top face — then
// hull()-tapers that flat cut back to a clean round cross-section over the top
// neck_round_taper_h so the neck still meets pole_top_transition()/pole_top_bell()
// as round, unchanged from v17.
module pole_top_neck(cx, cy, z_top) {
    dir = (cx < bed_l / 2) ? 1 : -1;
    flat_x = dir * 0.7 * pole_r;   // same flat-face plane as pole_body()'s cut_x0 — guarantees coplanar seating, not just visual proximity
    d_zone_h = neck_h - neck_round_taper_h;  // lower fully-D zone, flush against pole_body()
    cut_x0  = dir > 0 ? flat_x : -(neck_or + 1);
    cut_far = dir > 0 ? (neck_or + 1) : flat_x;
    cut_w   = cut_far - cut_x0;
    translate([cx, cy, z_top - neck_h])
        difference() {
            cylinder(h = neck_h, d = neck_od, $fn = 64);
            translate([0, 0, -e])
                cylinder(h = neck_h + 2 * e, d = neck_id, $fn = 64);
            // fully-D flat cut, lower d_zone_h only — flush with pole_body()'s flat face
            translate([cut_x0, -neck_or - 1, -e])
                cube([cut_w, neck_or * 2 + 2, d_zone_h + e]);
            // hull()-tapered blend: full cut width at d_zone_h shrinks to ~0 at neck_h,
            // both anchored at flat_x (the fixed flat-face plane) so the cut vanishes
            // into a clean round cross-section by the top of the neck
            hull() {
                translate([cut_x0, -neck_or - 1, d_zone_h - e])
                    cube([cut_w, neck_or * 2 + 2, 2 * e]);
                translate([dir > 0 ? flat_x : flat_x - e, -neck_or - 1, neck_h - e])
                    cube([e, neck_or * 2 + 2, e]);
            }
        }
}

// pole_top_transition(cx, cy, dir, neck_top) — v20 REBUILT as an 8-step elbow loft
// (v17-v19's single hull() between the neck's Z-axis disc and the bell's X-axis
// disc produced a diagonal saddle facet — root cause confirmed in v19's coordinate
// dump: NOT a shape/size mismatch, both ends are round/47mm, it's a 90deg
// axis-orientation + 3D position twist that a single hull() cannot bridge cleanly).
// Constant neck_od (47mm) diameter circle, swept along a smoothstep-eased path from
// the neck-top anchor (cx,cy,neck_top, axis Z / 0deg) to the bell-small-face anchor
// (bell_small_face_x,cy,xbar_z, axis X / 90deg), with rotation interpolated linearly
// in parallel. Adjacent step pairs are each hull()'d individually (local, near-planar
// transitions only) then union()'d — never one hull() across the full twist. Caller
// (pole_top()) wraps this inside the same difference() that already subtracts the
// bore-envelope cylinder from the union(neck, transition) — that cut is inherited
// unchanged here, automatically covering all 8 new steps, same guarantee as v16+.
module pole_top_transition(cx, cy, dir, neck_top) {
    // bell-side anchor — unchanged formula since v18 (bell recentered on neck axis)
    bell_small_face_x = cx - dir * head_h / 2;

    loft_steps = 8;  // v20 NEW — minimum per SKILL_joint_construction.md Rule 2

    // smoothstep ease for POSITION only (keeps tangent vertical near the neck,
    // horizontal near the bell) — ROTATION is interpolated linearly (plain t),
    // per the v20 prompt's explicit split between position easing and rotation.
    function transition_ease(t) = t * t * (3 - 2 * t);

    // 8 (x,y,z,rotation_deg) steps, t = 0, 1/7, ... 1. step0 == neck's existing
    // top cross-section exactly (te=0 -> x=cx,z=neck_top, rot=0deg = identity,
    // matching cylinder()'s default Z-axis orientation, 0mm/0deg delta). step7 ==
    // bell's existing small-face cross-section exactly (te=1 -> x=bell_small_face_x,
    // z=xbar_z, rot=90deg = rotate([0,90,0]), 0mm/0deg delta) — see cc_chat_log.md
    // for the full numeric table.
    transition_pts = [
        for (i = [0 : loft_steps - 1])
            let(
                t  = i / (loft_steps - 1),
                te = transition_ease(t),
                x  = cx + (bell_small_face_x - cx) * te,
                z  = neck_top + (xbar_z - neck_top) * te,
                rot = 90 * t
            )
            [x, cy, z, rot]
    ];

    union() {
        for (i = [0 : loft_steps - 2])
            hull() {
                translate([transition_pts[i][0], transition_pts[i][1], transition_pts[i][2]])
                    rotate([0, transition_pts[i][3], 0])
                        cylinder(h = e, d = neck_od, $fn = 64);
                translate([transition_pts[i + 1][0], transition_pts[i + 1][1], transition_pts[i + 1][2]])
                    rotate([0, transition_pts[i + 1][3], 0])
                        cylinder(h = e, d = neck_od, $fn = 64);
            }
    }
}

// cubic_bezier() — samples a smooth point on a cubic Bezier curve through 4 control
// points. Used by pole_top_bell() to build the bell's outer (radius, height) revolve
// curve as a continuous sweep instead of straight polygon segments.
function cubic_bezier(t, p0, p1, p2, p3) =
    let(u = 1 - t)
    [ u*u*u*p0[0] + 3*u*u*t*p1[0] + 3*u*t*t*p2[0] + t*t*t*p3[0],
      u*u*u*p0[1] + 3*u*u*t*p1[1] + 3*u*t*t*p2[1] + t*t*t*p3[1] ];

// pole_top_bell(cx, cy, dir) — v14 orientation fix. Per the required construction
// method: the COMPLETE solid (wine-glass exterior via rotate_extrude + the bore
// cylinder) is built first in OpenSCAD's natural/default orientation — bore running
// along local Z, the same axis rotate_extrude already uses — then the entire
// difference() result is wrapped in exactly ONE rotate([0,90,0]) as the literal last
// operation before scale/translate position it. The exterior and the bore are never
// rotated separately — this is what v10 and v13 got wrong both times.
// Profile is now wine-glass CONCAVE (curves inward from the straight small-to-large
// line) instead of v13's horn/convex bulge — control points p1/p2 pull inside the
// chord per Janis's note 2.
// After the single rotate([0,90,0]): local Z=0 (small face) -> local X=0,
// local Z=head_h (large face) -> local X=head_h. scale([dir,1,1]) then mirrors which
// world-X direction the bell extends in per pole corner (same dir convention used in
// pre-v13 versions) so the large (entrance) face always points toward bed center /
// the opposite pole, matching the crossbar's actual span — small (exit) face stays
// anchored at the pole/neck.
module pole_top_bell(cx, cy, dir) {
    p0 = [head_small_r,        0];
    p1 = [head_small_r * 0.80, head_h * 0.35];   // pulled INSIDE the chord — concave dip near small face
    p2 = [head_large_r * 0.80, head_h * 0.65];   // v19: mirror of p1 (same 80% pull-in, same 35%-of-head_h offset from its own end) — concave dip near large face, was *0.60 @ 0.70 (one-sided horn flare)
    p3 = [head_large_r,        head_h];

    outer_curve = [ for (i = [0 : head_loft_steps]) cubic_bezier(i / head_loft_steps, p0, p1, p2, p3) ];
    // close the half-profile back to the revolve axis (x=0) at both ends so
    // rotate_extrude() produces a solid (not a shell) — bore is cut from it below.
    bell_profile = concat([[0, 0]], outer_curve, [[0, head_h]]);

    // v18 FIX (Problem 1): re-anchored from the small face (cx,cy,xbar_z) to the
    // bell's MIDPOINT along its bore axis, so the bore's own center lands on the
    // neck's centerline (x=cx) — a true T-junction — instead of the neck only
    // touching the bell's small-face edge. See file header for the full derivation.
    translate([cx - dir * head_h / 2, cy, xbar_z])
        scale([dir, 1, 1])
            rotate([0, 90, 0])
                difference() {
                    rotate_extrude($fn = 64)
                        polygon(points = bell_profile);
                    // bore — still built along local Z here, same axis as the
                    // rotate_extrude above; the single rotate([0,90,0]) wrapping this
                    // whole difference() is what puts it on world X afterward
                    translate([0, 0, -e])
                        cylinder(h = head_h + 2 * e, d = top_bore_d, $fn = 48);
                }
}

// pole_top() — wine-glass bell + external sleeve neck assembly, forming a literal
// T-junction: the vertical neck sleeve is the stem, the horizontal bell (oriented
// along X via pole_top_bell()'s single rotate) is the crossbar of the T, matching
// the crossbar's actual bore axis. v16: neck_top anchor repositioned below the bore
// (see in-function comment) to fix the v15 bore-intrusion flag — bell construction/
// orientation unchanged. No latch/cam/lever geometry — Stage 2 scope only.
module pole_top(cx, cy) {
    $fn = 64;  // local resolution bump for this module only (neck/bore/bolt cylinders + revolve); rest of file stays at the global $fn=32 default
    // v16 ISSUE A+B FIX: neck centerline was already at (cx,cy), matching the bell's
    // axis (the bell's small face — pole_top_bell()'s local origin — is translate()'d
    // to world (cx,cy,xbar_z) before rotate/scale reorient around that fixed point, so
    // its axis runs through y=cy,z=xbar_z). The v15 visual "offset" is explained by
    // Issue B below, not a real coordinate mismatch — no separate alignment fix needed.
    // neck_top repositioned from v15's xbar_z+neck_bell_overlap (which put ~16.7mm of
    // neck material INSIDE the bore void, plugging it) to sit BELOW the bore with a
    // safety margin: neck_top = xbar_z - top_bore_d/2 - neck_bore_clearance. Verified
    // via Python: this lands inside the bell's solid wall band directly under the bore
    // (xbar_z-head_small_r to xbar_z-top_bore_d/2), giving 5mm of solid union overlap
    // while staying 2mm clear of the bore's void. Bolt-hole z-positions (still
    // neck_h*0.3/0.7 below neck_top) land far below the bore's bottom edge too.
    neck_top = xbar_z - top_bore_d / 2 - neck_bore_clearance;
    dir = (cx < bed_l / 2) ? 1 : -1;
    color("#2C3E50", 1.0) {
        difference() {
            union() {
                pole_top_neck(cx, cy, neck_top);
                pole_top_transition(cx, cy, dir, neck_top);
            }
            // v18: bolt axis changed from rotate([90,0,0]) (through the round side
            // wall, along Y) to rotate([0,90,0]) (through the new flat D-face, along
            // X — same axis convention as pole_top_bell()'s bore) per Janis's request
            // for a more stable tightening surface. Z-positions unchanged from v17,
            // both still fall inside the neck's fully-D zone (pole_top_neck()'s
            // d_zone_h = neck_h - neck_round_taper_h = 55mm, i.e. [neck_top-70,
            // neck_top-15]):
            //   neck_top-25: 25mm from top/seam edge, 45mm from bottom/pole edge
            //   neck_top-50: 50mm from top/seam edge, 20mm from bottom/pole edge
            // both exceed bolt_edge_clearance_min (15mm TBD) with margin to spare
            for (bz = [neck_top - 25, neck_top - 50])
                translate([cx, cy, bz])
                    rotate([0, 90, 0])
                        cylinder(h = neck_od + 2 * e, d = neck_bolt_d, center = true, $fn = 24);
            // DEFENSIVE GUARANTEE (v16 NEW): explicit bore-envelope cut applied to the
            // neck as well as the bell, so "no neck geometry crosses into the 33mm bore"
            // is code-provable regardless of position tuning or future dimension changes.
            translate([cx, cy, xbar_z])
                rotate([0, 90, 0])
                    cylinder(h = neck_od * 4, d = top_bore_d, center = true, $fn = 48);
        }
        pole_top_bell(cx, cy, dir);
    }
}

// ═════════════════════════════════════════════════════════════════════
// MODULES — CROSSBAR (X-axis: longitudinal along bed length)
// Seats against pole_top() junctions only — does not pass through pole_body().
// ═════════════════════════════════════════════════════════════════════

module crossbar_body(y_pos) {
    color("#DDDDDD", 1.0)
        translate([leg_w/2, y_pos, xbar_z])
            rotate([0, 90, 0])
                cylinder(h = grip_l, d = grip_od);
}

module crossbar_end_cap(x_pos, y_pos) {
    color("#AAAAAA", 1.0)
        translate([x_pos, y_pos, xbar_z])
            sphere(d = grip_od + 4);
}

// ═════════════════════════════════════════════════════════════════════
// SUB-ASSEMBLIES — 4 pole parts kept logically separate (not unioned)
// ═════════════════════════════════════════════════════════════════════

module bed_assembly() {
    if (show_bed) {
        bed_frame();
        bed_surface();
    }
}

module pole_assembly(i) {
    cx = pole_cx[i];
    cy = pole_cy[i];
    if (show_wood_sockets) pole_wood_socket(cx, cy);
    if (show_base_collars) pole_base_collar(cx, cy);
    if (show_pole_bodies)  pole_body(cx, cy);
    if (show_pole_tops)    pole_top(cx, cy);
}

module crossbar_assembly() {
    if (show_crossbars) {
        crossbar_body(xbar_y_front);
        crossbar_body(xbar_y_rear);
        crossbar_end_cap(pole_cx[0], xbar_y_front);
        crossbar_end_cap(pole_cx[1], xbar_y_front);
        crossbar_end_cap(pole_cx[2], xbar_y_rear);
        crossbar_end_cap(pole_cx[3], xbar_y_rear);
    }
}

// ═════════════════════════════════════════════════════════════════════
// FULL ASSEMBLY (combined preview render — components visually aligned,
// logically separate solids, NOT unioned into one continuous pole)
// ═════════════════════════════════════════════════════════════════════

module pr01_assembly() {
    bed_assembly();
    for (i = [0:3]) pole_assembly(i);
    crossbar_assembly();
}

// ── RENDER ────────────────────────────────────────────────────────────
pr01_assembly();
