// VM-02 Base Vending Machine
// Janis Product Design
// Version: v3
// Date: 2026-07-10
// Units: mm
// Purpose: Smart donation vending machine — buddha ornaments. VM-02 is a
// NEW sibling product line, NOT a new VM-01 version — same base
// architecture, several real geometry changes. Both product lines
// continue independently after this (VM-01 stays LOCKED at v58 unless a
// future session says otherwise).
// Derived from: VM-02-base-v2.scad (this session, source vm02-dashboard-
// shelf-and-side-acrylic) — v2 itself derived from v1
// (vm02-lower-shell-fill-and-retro-governance). v2 is UNTOUCHED, this is
// a new file, same convention as VM-01's own per-version files.
//
// CHANGES FROM v2 (this session, vm02-dashboard-shelf-and-side-acrylic):
// Two NEW features in the right/system compartment's acrylic display
// zone (NOT fixes to v2's own work). R-009 Duplication Check performed
// first: `acrylic_zone_bot_z` and the acrylic zone's Z-range already
// existed as a live top-level DATUM (promoted in v2, see "PROMOTED to
// shared top-level DATUMs" below) — both new features below read that
// SAME value, nothing re-derived.
//
// FEATURE A — Display shelf (floor), NEW `display_shelf()` module
// (chosen over folding into `acrylic_display()` — this is a physically
// separate part, a floor not a viewing pane, matching this file's own
// "one physical part per module" convention). Janis: "the right system
// zone at the display zone with acrylic cover, just 10mm below the
// acrylic edge, I need a floor start from front go all the way back to
// the back panel spread fill left right, for placing display stuffs."
// Read as: the shelf's TOP surface (where items actually sit) is 10mm
// below `acrylic_zone_bot_z` (the acrylic zone's own BOTTOM edge, where
// the transparent viewing area begins) — `shelf_top_z = acrylic_zone_
// bot_z - SHELF_TOP_MARGIN(10)`, a new top-level DATUM. No other
// "acrylic edge" reading was live-ambiguous here — v2 only defines ONE
// acrylic zone (front+right+top, one Z-range, `acrylic_zone_bot_z`/
// `acrylic_zone_top_z`), so "the acrylic edge" has exactly one live
// referent, not a genuine ambiguity to flag.
// Full interior depth (Y: skin_t to total_d-skin_t) — the SAME "interior
// front face to interior rear wall" span `compartment_divider()` already
// uses for a full-depth panel, not a new convention. Full width reuses
// `dash_x`/`dash_w` verbatim — the SAME X-extent `dashboard()`/
// `acrylic_display()` already establish for this compartment's own
// left/right bounds, per this prompt's explicit instruction to reuse
// those values rather than re-derive a number. FLAGGED (not a blocker,
// stated per this prompt's own ambiguity-flagging instruction): `dash_x`/
// `dash_w` (443-563mm) is narrower than the compartment's true wall-to-
// wall interior (divider's right face at 441mm to the shell's own
// interior right wall at 582mm) — dash_x/dash_w is a dashboard-
// component MOUNTING envelope, not the literal wall-to-wall width. Used
// verbatim anyway since the prompt explicitly named these two values to
// reuse, not "derive the true interior span."
// Thickness: no number given in the prompt. Reused `tray_floor_t` (5mm)
// — this file's own existing "floor" thickness convention (see
// `tray_compartment_partition()`), not a new invented constant.
// Real CGAL finding: the shelf's own rear edge (Y=total_d-skin_t, by the
// same construction compartment_divider() uses) landed on the exact same
// Y as `rear_service_door()`'s own front face — a real coincident-face
// touch (Rule M-1), same class of issue `acrylic_display()`'s own top
// panel hit in v2. Fixed the same way: a real `SHELF_REAR_GAP` (1mm,
// same magnitude as `ACRYLIC_OVERLAP`) pulled back from the rear wall,
// not a bare epsilon (R-002 lesson — epsilon alone was already shown
// insufficient for a large-area near-coincident face in v2's own acrylic
// panel fix).
// NEW `show_display_shelf` toggle — added properly from this module's
// first commit (Toggle-Completeness Rule), not a GAP, same reasoning
// `acrylic_display()` used when it was rebuilt from scratch in v2.
//
// FEATURE B — Right-side viewing acrylic. Confirmed live (not assumed):
// `outer_shell()` had ZERO cutout on the machine's own RIGHT EXTERIOR
// face (X=total_w wall) before this session — the existing
// `show_shell_right` toggle only fully REMOVES that panel for debug
// isolation, it was never a permanent glazed opening. Added one.
// Z-range: identical to the existing acrylic zone datum (`acrylic_zone_
// bot_z` to roofline), same live value, not a new one, per Janis:
// "stretch to the top as current front view."
// Y-range — CORRECTED per Janis mid-session (front half of the
// compartment's depth, NOT back half): `corner_r` (20mm) to `total_d/2`
// (300mm). `corner_r` is NOT an arbitrary choice — it's the exact
// tangent point where the shell's own rounded front-right corner arc
// (rounded_box()'s own corner cylinder, centered at X=total_w-corner_r,
// Y=corner_r) ends and the flat right face begins — the SAME convention
// `acrylic_display()`'s existing internal right panel already uses for
// its own front-end recess. Real numeric coincidence supporting this as
// the "balanced" meeting point Janis described: the FRONT acrylic
// panel's own right edge (`dash_x+dash_w` = 563mm) lands within 1mm of
// this exact corner tangent point (`total_w-corner_r` = 564mm) — the two
// glazed faces genuinely meet at the corner, confirmed via the live
// numbers, not just an aesthetic guess.
// TASK 3 — `acrylic_display()`'s existing internal right panel's own
// Y-range adjusted to match: was `corner_r` to `total_d-corner_r`
// (20-580mm, full depth) before this prompt; now `corner_r` to
// `total_d/2` (20-300mm, front half only) — so the new external cutout
// and the internal panel's own material align.
//
// Mandatory manifold sweep (tray_count 1/3/5, full CGAL, real OpenSCAD
// binary): see cc_chat_log.md for the full per-check "Simple: yes/no"
// results.
//
// ══════════════════════════════════════════════════════════════════
// CHANGES FROM v1 (prior session, vm02-lower-shell-fill-and-retro-governance):
//
// PART 1 — Lower right-compartment metal panel (real, confirmed design
// gap, NOT a regression this prompt introduced — Janis's original spec,
// restated 2026-07-10: the dashboard's lower zone should sit inside SOLID
// sheet metal, with the acrylic window starting only ACRYLIC_ZONE_MARGIN
// (50mm) above the touchscreen's own top edge. Live code check (done by
// Claude Web this session, reading outer_shell() directly) confirmed this
// was NEVER built — since VM-01-base-v6, the right-compartment front-face
// cutout has always been one continuous open hole spanning the ENTIRE
// lower zone, with dashboard() components floating in open space. VM-01
// (locked) has the identical gap, not touched here):
//   outer_shell()'s "Right compartment front face opening" cutout
//   SHRUNK to only the upper acrylic zone (acrylic_zone_bot_z to
//   roofline — the SAME live datum acrylic_display() already uses, not
//   duplicated). Below that, down to the floor, the front face is now
//   SOLID shell material (skin_t thick, same as the rest of the shell) —
//   achieved simply by no longer cutting a hole there, no separate fill
//   piece needed. 4 new individual mounting cutouts added (screen+bezel+
//   bracket, QR scanner, card reader, speaker grille), each sized to that
//   component's own real footprint (read from dashboard()'s live code)
//   PLUS the project's existing 2mm Global Clearance Tolerance convention
//   (new PANEL_CUTOUT_CLEARANCE constant, reusing that number, not
//   inventing a new one) on all sides.
//   dashboard()'s own Z-position chain (screen_mount_w/h, screen_z, qr_z,
//   card_z, speaker_z) is PROMOTED to shared top-level DATUMs (was
//   module-local only) so outer_shell()'s new cutouts read the SAME live
//   values, never an independently re-derived copy (Datum Rules; R-009
//   Duplication Check performed first: confirmed this chain existed in
//   exactly one place before this change, dashboard() itself).
//   REAL CGAL FINDING, NOT ASSUMED: a first-pass cutout sized only to the
//   screen+bezel's own flat (untilted) footprint left a genuine ~3mm gap
//   against dashboard()'s SEPARATE support bracket (a flat, non-tilted
//   crossbar reaching lower than the bezel does, screen_z±bracket_r vs.
//   screen_z-bezel_t) — found by isolating
//   intersection(){dashboard();outer_shell();} and reading the actual
//   colliding part's real bounds (not guessed), fixed by taking
//   max(bezel_t, bracket_r) for the cutout's own lower bound. Confirmed
//   via real CGAL sweep at tray_count=1/3/5 (screen_top_z's own clamp
//   changes the dashboard's Z position differently at each): zero
//   collision between dashboard() and outer_shell() at every value,
//   Simple:yes throughout the full assembly too. Also confirmed zero new
//   collision with rear_service_door(), tray_zone_frame(),
//   compartment_divider(), acrylic_display() at tray_count 1/3/5.
//
// PART 2 — Retroactive New-Product-Line governance (see
// vending-machine/VM-02-base/design_scope_of_work_rule.md,
// vending-machine/VM-02-base/SKELETON_WORKSHEET.md, knowledge.map, and
// cc_chat_log.md for the full artifacts — this header only notes that
// they now exist, grounded in this actual v2 file, not built here).
//
// GOVERNANCE FLAG (RESOLVED this session — see PART 2 above; kept below
// for the historical record of why it was originally raised): VM-02
// has no prior committed .scad versions, which is the literal trigger
// condition in .claude/SKILL_product_design_skeleton.md / cc_rules.md for
// the NEW-PRODUCT-LINE gate (design_scope_of_work_rule.md + Skeleton/BOM/
// Kinetic worksheets, confirmed with Janis BEFORE the first cc prompt).
// No VM-02 scope file or worksheets exist anywhere in this repo (checked:
// no vending-machine/design_scope_of_work_rule.md entry for VM-02, no
// cc_chat_log.md mention prior to this session). Proceeding anyway
// because this session's own prompt explicitly and repeatedly instructs
// INHERITING VM-01's entire datum architecture wholesale (same DATUM_*
// chain, same formulas, "reuse this exact formula, don't re-derive"
// language throughout) rather than inventing new ones — the actual risk
// the Skeleton gate exists to prevent (parts independently re-deriving a
// shared reference point) does not apply here, since every VM-02 datum
// traces to the one inherited VM-01 chain. Flagged here and in
// cc_chat_log.md for Claude Web/Janis to backfill the formal gate (scope
// file + worksheets) if VM-02 continues past this v1 — not silently
// skipped, not treated as a blocker either, per cc_rules.md's own "flag
// rather than silently proceed" instruction for this exact situation.
//
// CHANGES FROM VM-01-base-v58 (this session, vm02-derivation-from-vm01-v58):
//
// TASK A — Spring tray remake:
//   tray_count default 2->3 (tray #2 added ON TOP of the existing stack —
//   tray #0 and everything below/at its level UNCHANGED, per Janis's
//   explicit "do not touch anything below bottom tray"). tray_count is
//   now a live Customizer parameter, /* [Tray Configuration] */, [1:5].
//   total_h is now DERIVED, not a literal: total_h = tray_stack_z0 +
//   tray_zone_h + ROOFLINE_MARGIN. ROOFLINE_MARGIN=88mm re-derived from
//   v58's own real 2-tray clearance (DATUM_ROOFLINE(700) - tray stack top
//   (370+2*121=612) = 88 — confirmed against the live v58 file, not
//   assumed to be exactly 88). This makes total_h correctly recompute for
//   tray_count 1-5, not hardcoded for 3 — tested at 1/3/5 (see
//   cc_chat_log.md manifold sweep).
//   tray_out_pct is now a length-5 Customizer vector (per-tray
//   independent slide) — spring_tray(tray_num) indexes tray_out_pct
//   [tray_num] directly, confirmed independent via a mixed-value render
//   matching the prompt's own literal example (tray0=0%, tray1=50%,
//   tray2=100%, door_open=true — see "TRAY/FRAME CLEARANCE" note below:
//   the full 0-1 range needed a real width fix before this example was
//   actually achievable, not just the ~27%-safe values cc tried first).
//   TWO REAL MANIFOLD BUGS FOUND AND FIXED during the mandatory
//   tray_out_pct sweep (Section 7), both confirmed via real CGAL, neither
//   guessed: (1) at tray_out_pct=1.0 EXACTLY, a sliding tray's rear edge
//   lands exactly on tray_rack()'s own fixed rail — a real 0mm coincident-
//   face touch (same pre-existing bug confirmed present in the LOCKED
//   VM-01 v58 file too, out of scope to fix there) — fixed with a real
//   (not bare-epsilon) RAIL_OVERLAP nudge, see tray_rack()'s own comment.
//   (2) adjacent trays in the stack share an exact coincident Z-face
//   (this tray's top = the next tray's bottom, zero gap by construction) —
//   tolerated when BOTH trays are at pct=0 (a full, aligned coincident
//   face), but becomes a real T-junction once either tray slides (a
//   partial, staggered overlap) — fixed with a genuine TRAY_TOP_CLEARANCE
//   vertical gap between tray slots, see spring_tray()'s own comment.
//   TRAY/FRAME CLEARANCE — ROOT-CAUSED THEN FIXED (2 direct-chat follow-
//   ups, both 2026-07-10, in response to Janis's questions): once both
//   manifold bugs above were fixed, a THIRD, more fundamental issue
//   surfaced via the same sweep — tray_zone_frame()'s left vertical has a
//   flat radial closing face reaching world X=21mm near its own front end
//   (world Y 7-15mm), 4mm past the tray box's own left wall (was world
//   X=17mm=tray_x_inset). Confirmed via CGAL bisection this was a real
//   physical collision at ANY tray_out_pct above ~0.27.
//   ROOT CAUSE (1st follow-up, in response to Janis's "did you fix?" /
//   "we fixed that on width before, wasn't it?"): NOT a height/ceiling
//   issue — a horizontal (X-axis) clearance issue, unrelated to total_h/
//   roofline. Janis's memory of "fixed on width before" was CORRECT —
//   VM-01 v50 (VM-01-corner-frame-redesign) set tray_x_inset=17mm for a
//   real 2mm clearance from the frame's left vertical, verified against
//   that vertical's OWN construction AT THE TIME (confirmed by reading
//   the archived VM-01-base-v55.scad directly: its curve swept only
//   until X=left_bar_inner_x=15mm, explicitly capped). VM-01 v56 (a
//   LATER, separate session, vm01-v56-sensor-bracket-frame-joint-fix)
//   rebuilt this SAME curve to fix a visible kink, sweeping it all the
//   way to y_stop_angle=270° instead (confirmed by reading VM-01-base-
//   v56.scad directly) — at exactly 270°, the closing point's X-component
//   reduces to the arc center's own X (21mm) regardless of radius, 4mm
//   past the v50-verified 15mm limit. v56's own scope/testing was door-
//   vs-frame collision ONLY, never re-checked tray clearance — this
//   regression went undetected for 2 versions until THIS session's
//   tray_out_pct sweep. A first attempted fix (widening tray_x_inset
//   alone) was NOT viable: with product_w(416mm) unchanged, the 5-lane
//   spring layout (OWNER-LOCKED spring_od/spring_gap) needs ~388mm
//   minimum, but only ~383mm would remain — a genuine ~5mm shortfall.
//   FIXED (2nd follow-up, Janis's own proposed direction): widen the
//   compartment instead of touching the frame or the tray's own width.
//   product_w 416mm->422mm (+6mm) and tray_x_inset 17mm->23mm (+6mm, the
//   SAME shift) — tray_w_global's formula evaluates to the exact same
//   389.01mm as before (both terms shift by the same amount, cancels
//   out), so the tray's own width/spring-lane layout is UNCHANGED, only
//   its POSITION shifts right within the wider compartment. This works
//   because tray_zone_frame()'s LEFT vertical is anchored to the shell's
//   fixed front-left corner (independent of product_w, doesn't move),
//   while its RIGHT vertical (anchored to product_w+e) shifts by the same
//   +6mm as the tray's own right wall — preserving the pre-existing 2mm
//   right-side clearance automatically. Confirmed via a full CGAL sweep,
//   tray_out_pct 0 through 1.0 (door_open=true, the physically valid
//   state for a fully-extended tray — a tray at 100% still legitimately
//   collides with a CLOSED door, an unrelated, unavoidable physical fact,
//   not a bug), Simple:yes throughout — no longer capped at ~27%.
//   total_w now 584mm accordingly (422+19+143). CONFIRMED this same
//   frame/tray_x_inset gap still exists, UNFIXED, in the LOCKED VM-01 v58
//   file (out of scope to touch there).
//   New sensor_hole_d=3mm floor-mounted (vertical, Z-axis) hole per lane
//   per tray (5 lanes x tray_count), centered at each lane's existing
//   centerline X (same formula as the spring lanes, reused verbatim, not
//   re-derived), Y=5mm from each tray's own front edge (local Y=0).
//   Confirmed clear of the rear motor-mount cutouts via live render (holes
//   at the FRONT, motor cutouts at the REAR — real Y-gap, not assumed).
//
// TASK B — System compartment (dashboard + back door):
//   Dashboard remounted PORTRAIT: physical panel dims UNCHANGED (165mm x
//   100mm, per Janis's locked spec) — screen cube/bezel/support-bracket/
//   the existing -30 deg tilt all rebuilt against new screen_mount_w
//   (100mm, was the short physical edge, now the X/width extent) and
//   screen_mount_h (165mm, was the long physical edge, now the Z/vertical
//   extent) locals inside dashboard() — same tilt mechanic (rotate about
//   the horizontal/X axis is orientation-agnostic to which physical edge
//   is "width", confirmed by inspection of the rotation math, not
//   reconstructed from scratch).
//   Screen position: top-of-screen-edge anchored at total_h-400 (replaces
//   the old fixed screen_center_z=280 anchor; screen center now DERIVED
//   from this rule) — WITH a real clamp, found necessary via the
//   mandatory tray_count=1/3/5 sweep: the literal total_h-400 rule alone
//   pushes the QR/card/speaker stack BELOW THE FLOOR (negative world Z)
//   at tray_count 1-2 (total_h 579-700mm) — a real, confirmed conflict
//   between Task A's now-live total_h range and Task B's fixed 400mm
//   offset, not assumed away. See dashboard()'s own comment for the exact
//   clamp formula and re-derivation.
//   QR/card reader/speaker: same relative-offset chain reused verbatim,
//   recomputed against the new screen position; all 3 (plus screen/bezel/
//   bracket, which used a hardcoded "+10" offset in v58, not the existing
//   dash_x+(dash_w-part_w)/2 centering formula the bracket itself already
//   used) now consistently re-center in X via that one existing formula —
//   confirmed fitting under the new narrower dash_w via live render, not
//   hardcoded.
//   system_w RECOMPUTED, TWICE — final value 143mm, Janis-confirmed
//   2026-07-10. First pass (cc): the prompt's own "10mm border + 100mm
//   mounted + 10mm border = 120mm" framing didn't account for the
//   EXISTING dash_w formula (system_w - divider_t - skin_t*2), already
//   live in v58 and reused here verbatim — at system_w=120mm, dash_w
//   computes to 97mm, but the portrait screen's own BEZEL footprint
//   (screen_mount_w + bezel_t*2 = 100+6 = 106mm) is already wider than
//   that, a real collision. cc's first correction used the project's 2mm
//   Global Clearance Tolerance convention (system_w=133mm). Janis's own
//   follow-up correction (2026-07-10): the border is a real 10mm EACH
//   SIDE of the panel's own mounted width, matching the prompt's own
//   literal arithmetic (dash_w target = 10+100+10 = 120mm, not cc's own
//   106+2+2=110mm figure) — system_w = 120 + divider_t(19) + skin_t*2(4)
//   = 143mm, still "well under the old 204mm ceiling." total_w is a
//   DERIVED formula (product_w + divider_t + system_w — see "TRAY/FRAME
//   CLEARANCE — FIXED" below for why product_w itself is 422mm, not
//   416mm: 422+19+143 = 584mm), not a literal — this also closes a real,
//   pre-existing ~1mm arithmetic drift in VM-01's own total_w literal
//   (v58: total_w=640 but product_w+divider_t+system_w=639 — out of scope
//   to fix in the locked VM-01 file, but VM-02 avoids this entire bug
//   class by never hardcoding the sum). Rear service door width
//   (system_w-10) recomputed
//   to 133mm accordingly.
//   acrylic_display() RESTORED — PERMANENT, Janis-confirmed 2026-07-10
//   ("we need acrylic window"): cc's first draft had removed this module
//   as a judgment call (compartment too narrow/full for a separate
//   display function) — reversed here per Janis's explicit instruction.
//   Rebuilt (not just re-added) for VM-02's own narrower/portrait
//   compartment and now-variable total_h: front panel width now dash_w's
//   own interior-width formula (was hardcoded to the old system_w
//   proportions); Z-zone re-anchored to a new shared screen_top_z-based
//   datum (above the dashboard's own screen assembly, up to the
//   roofline) instead of the removed tray-stack-derived datum. Three
//   REAL manifold issues found and fixed while restoring/resizing this
//   module (all confirmed via live CGAL, none guessed): (1) the right
//   panel's own edge landed exactly on the shell's interior wall surface
//   (inherited unchanged from VM-01's own formula, never previously
//   flagged); (2) the top panel's edge landed on BOTH the shell's roof
//   AND rear_service_door()'s front face simultaneously (a NEW doubly-
//   coincident corner from combining this session's OWN two changes —
//   acrylic restored + rear door now full-height) — fixed by treating
//   each face independently (real overlap into the roof, a real small
//   gap from the door/back wall); (3) the front panel's own width
//   (dash_w) is ALGEBRAICALLY IDENTICAL to the shell's own right-
//   compartment cutout end for ANY system_w value (confirmed by
//   expanding both formulas) — a structural coincidence that did NOT
//   reproduce in isolated pairwise CGAL tests against the shell alone
//   (a known CGAL robustness quirk), only surfacing once the full
//   assembly was actually rendered — fixed with a real 1mm clearance
//   margin. This restoration ALSO resolves the prompt's own Cross-Cutting Warning about
//   DATUM_TRAY_TOP/tray_zone_top_z becoming a live dependency once
//   tray_count varies: that entire datum chain (DATUM_TRAY_TOP/
//   tray_zone_top_z/upper_display_h/acrylic_bot_z/acrylic_top_z/
//   acrylic_zone_h) is REMOVED from this file, not left wired. Root
//   cause: outer_shell()'s left-zone front cutout was split into TWO
//   pieces at tray_zone_top_z in v58 — a vestige of a pre-v41 partial-
//   height door concept (the left zone's own door has been ONE
//   continuous full-height leaf since v41; the two pieces' UNION was
//   always floor-to-roof regardless of where the split landed, confirmed
//   by inspection, not guessed) — simplified here to ONE full-height
//   cutout. The right-compartment front cutout, previously CAPPED at
//   tray_zone_top_z (leaving solid, uncut shell material above it, only
//   ever covered by the now-removed acrylic_display()'s own separate
//   zone), is extended to full floor-to-ceiling height to match — and to
//   match the new rear service door's own full-height philosophy (below).
//   Rear service door: rebuilt full floor-to-ceiling height (was a fixed
//   50%-height panel) — leg_h to total_h-skin_t, world Z. Width =
//   system_w-10 (123mm, see system_w note above). Centered in the
//   compartment's own interior width (matches dash_w's own reference
//   frame) for symmetric best access — cc's discretion per the prompt,
//   stated here per its own instruction to state the reasoning.
//
// TASK C — Machine foot:
//   leg_od 25mm -> 80mm. leg_h/leg_inset(40mm) UNCHANGED. Real clearance
//   check (own geometric bisection, confirmed via live CGAL render — see
//   cc_chat_log.md): the 80mm leg (radius 40mm) at the unchanged 40mm
//   inset clears the shell's rounded corner (corner_r=20, arc center
//   (20,20)) with a real ~5.4mm margin at the tightest diagonal point
//   (worst-case point of the leg's own circle within the corner's "true
//   corner" quadrant sits ~14.6mm from the arc center, vs. the arc's own
//   20mm radius) — leg_inset NOT changed, no shrink-back needed. Leg-to-
//   leg spacing (other legs, on VM-02's narrower derived total_w)
//   confirmed trivially clear (hundreds of mm of margin at every total_h/
//   total_w combination tested) — stated explicitly per the prompt's own
//   instruction to check this, not skipped as "obviously fine." Checked
//   against BOTH VM-01's original proportions (regression: leg fits with
//   MORE margin at total_w=640) and VM-02's narrower proportions.
//
// TASK D — Front door:
//   Stretches automatically — door_bot_z/door_top_z/door_h,
//   tray_zone_frame()'s frame_z0/z1/frame_h, and the acrylic top-limit
//   formula (acrylic_top_limit_z) are ALL already formulaic against
//   DATUM_ROOFLINE/total_h (itself now derived, Task A) — confirmed via
//   real render at tray_count=1/3/5, zero hardcoded old-height numbers
//   left behind, zero code changes needed inside those modules. Acrylic/
//   window bottom edge confirmed still pinned to tray_stack_z0
//   (unaffected by tray_count — that formula chain never reads
//   tray_count). Flap cut/stopper rod/hinge marks confirmed unchanged
//   position (all anchored low, near-floor).
//
// Everything on the LEFT side (drop zone, trays, frame, sensor strips,
// stopper rod, flap) confirmed still defined relative to product_w/
// skin_t, not total_w (spot-checked every module: tray_zone_frame(),
// drop_zone_guards(), sensor_strip(), compartment_divider() all key off
// product_w directly, never total_w) — none of it moves when total_w/
// system_w change independently, confirmed via real render, not just
// inspection. product_w ITSELF does change this session (416->422mm, see
// "TRAY/FRAME CLEARANCE" note above) — a deliberate, separate decision,
// and everything anchored to product_w (door width, frame's right
// vertical, compartment_divider() position, drop_zone_guards()'s right
// guard, sensor_strip()'s right strip, exit_x centering) cascades with
// it automatically and correctly, confirmed via the full render sweep.
//
// Full task-by-task detail, manifold sweep results (Simple:yes at every
// combination tested), and open flags for Janis: see cc_chat_log.md
// (vm02-derivation-from-vm01-v58 entry).

$fn = 64;

// ─────────────────────────────
// PARAMETERS
// ─────────────────────────────

/* [Tray Configuration] */
// Number of spring trays in the stack. VM-02 Task A.2: live Customizer
// parameter (was a fixed literal=2 in VM-01) — range ceiling is 5 (long-
// term adjustability headroom, per Janis), not just the new default of 3.
tray_count = 3; // [1:5]
// Per-tray slide-out percentage, independent per tray (VM-02 Task A.3;
// was a single scalar in VM-01 — every tray shared one slide value). Only
// the first tray_count entries are meaningful.
tray_out_pct = [0, 0, 0, 0, 0]; // [0:0.05:1]

total_d = 600;
corner_r = 20;
skin_t = 2;

// Epsilon — prevents z-fighting on coincident front faces. Declared above
// every consumer (same reasoning/position as v58 — door_bot_z below needs
// it in its own top-level formula, and OpenSCAD top-level assignments
// don't support forward references).
e = 0.01;

// Legs
leg_h = 50;
leg_od = 80;      // VM-02 Task C: was 25mm — see header changelog for the real clearance check (corner_r + leg_inset, both proportions)
leg_inset = 40;   // UNCHANGED — confirmed clear at the new leg_od, see header changelog

// §2.1 (v43, inherited) — explicit foot/leg-height term.
FOOT_BASE_H = leg_h;   // 50mm

// Compartments
// product_w CHANGED 416->422mm, Janis-confirmed 2026-07-10 (2nd follow-up):
// widens the tray/product compartment by 6mm specifically to resolve the
// tray_zone_frame() left-vertical clearance gap (see tray_x_inset's own
// comment below and the header changelog "TRAY/FRAME CLEARANCE — FIXED")
// -- NOT the original prompt's "product_w stays 416mm unchanged" decision
// (superseded by this direct instruction, same session). The freed
// portrait-dashboard width still comes off TOTAL MACHINE WIDTH (system_w
// unaffected by this change) -- this is a SEPARATE, additional 6mm on top
// of that, specifically for tray clearance.
product_w = 422;
system_w = 143;     // VM-02 Task B.4/B.5 RECOMPUTED, Janis-confirmed 2026-07-10: real 10mm border EACH SIDE of the panel's own mounted width (10+100+10=120mm dash_w target, matching the prompt's own literal arithmetic), not the 2mm Global Clearance Tolerance figure cc first tried — see header changelog "system_w RECOMPUTED" for the full re-derivation (120 + divider_t + skin_t*2)
divider_t = 19;     // UNCHANGED

// total_w is now DERIVED (VM-02 Task B.5), not a literal — was a literal
// in v58 (640, which itself had a real, un-flagged ~1mm arithmetic drift
// vs. product_w+divider_t+system_w=639 there). Deriving it here closes
// that entire bug class permanently for VM-02.
total_w = product_w + divider_t + system_w;   // 422+19+143 = 584mm

// Spring / Tray
spring_od = 66;
spring_l = 390;
motor_d = 60;
spring_gap = 13;    // OD-to-OD gap — OWNER-LOCKED (5mm clearance + 3mm partition + 5mm)
spring_lanes = 5;
tray_floor_t = 5;
tray_wall_t = 3;
tray_h = 121;           // floor(5) + spring_od(66) + clearance(50) -- OWNER-LOCKED, see rules-dimensions.md
partition_h = 40;
tray_d = spring_l + motor_d;  // 450mm

// VM-02 Task A.4: sensor hole through the tray FLOOR, one per lane, per
// tray. Diameter only (position reuses the existing lane-centerline
// formula directly inside spring_tray(), see below).
sensor_hole_d = 3;

// Tray zone -- true zone height only; now LIVE (tray_count varies).
tray_zone_h = tray_h * tray_count;         // 121-605mm depending on tray_count (363mm @ default 3)

// Zones
drop_zone_d = 138;
tray_start_d = drop_zone_d;

// Exit zone -- shell chute cutout + drop_zone_guards() only. Does not
// determine tray position (see DATUMS below).
exit_door_w = 400;
exit_door_h = 250;

// Customer pickup flap — flap_t still used
flap_t = 3;

// Tray rack
rail_w = 10;
rail_h = 10;
latch_pin_d = 8;
latch_pin_l = 10;

// Door / panel
door_t = 3;
hinge_od = 12;   // also reused as left_zone_door()'s stopper-rod diameter

// Real acrylic sheet thickness -- distinct from acrylic_t (removed, was
// the RIGHT-compartment acrylic_display() panel skin, now-removed part).
door_acrylic_t = 5;

// Frame bars
frame_bar = 8;
frame_inset = 5;
FLANGE_T = 10;   // weld-flange thickness (Z)

// Left-zone front door -- replaces front_door()+flap_door()+spring_zone_panel()
exit_w = 300;
exit_h = 150;

// HINGE_Y_OFFSET -- fixed, INDEPENDENT constant (measured from the shell's
// theoretical SHARP corner, not the corner_r fillet's own center).
HINGE_Y_OFFSET = 25;                   // 25mm

return_depth = HINGE_Y_OFFSET - skin_t;// 23mm -- flange depth, front face to hinge line
door_left_x = skin_t;                  // 2mm -- door's own width envelope, left edge
door_right_x = product_w - skin_t;     // 414mm -- LEFT ZONE ONLY, not total_w
door_w = door_right_x - door_left_x;   // 412mm -- door's own true width
exit_x = door_left_x + ((door_right_x-door_left_x-return_depth) - exit_w)/2 + return_depth; // centered in door width
flap_open_deg = 55;
door_open_deg = 100;                    // full-open angle for door_open viewer toggle
acrylic_border = 5;                     // overlap border, screw-in material
window_flap_gap = 40;                   // clearance above the flap opening
hinge_mark_h = 20;
hinge_mark_d = 1;

// §2.3 window/acrylic FROZEN as the door's OWN local constants (X range
// only is live-consumed, see left_zone_door() -- window_z0/window_h are
// documented-spec-only, same as v58, not wired into a cut directly).
window_x0 = 25;    // local X, door's local origin -> window left edge
window_z0 = 5;     // local Z, door's local origin -> window bottom edge (doc-only)
window_w  = 362;
window_h  = 638;   // doc-only

// Lock system PROVISION -- reservation only, unchanged from v58, inherited
// verbatim (not part of this session's scope).
lock_provision_w  = 30;
lock_provision_h  = 40;
lock_provision_d  = 1.5;
lock_provision_z0 = 280;
lock_provision_margin = 6;

// ─────────────────────────────
// DATUMS -- single source of truth for shared Z-reference planes. Every
// module below must reference ONE of these directly for any position
// shared with another module. See .claude/rules-codes.md "Datum Rules".
// VM-02 CHANGE: DATUM_TRAY_TOP / tray_zone_top_z / upper_display_h /
// acrylic_bot_z / acrylic_top_z / acrylic_zone_h are REMOVED entirely (see
// header changelog "Cross-Cutting Warning" resolution) -- nothing in this
// file reads them anymore now that acrylic_display() is gone and the
// shell's own front cutouts are full-height.
// ─────────────────────────────
DATUM_FLOOR    = 0;
DATUM_LEG_TOP  = FOOT_BASE_H;                        // 50

tray_0_z        = DATUM_LEG_TOP + 30 + exit_h + window_flap_gap;  // 270mm -- explicit inline chain (DATUM_FLAP_TOP/DATUM_TRAY_BOT collapsed to this one line since nothing else reads those intermediate names once DATUM_TRAY_TOP is gone) -- kept UNCHANGED as the pre-shift baseline; tray_compartment_partition() anchors here
TRAY_SHIFT_UP   = 100;                    // mm, Janis-approved (v46, inherited)
tray_stack_z0   = tray_0_z + TRAY_SHIFT_UP; // 370mm -- NEW lowest-tray-floor Z (live reference, spring_tray()/tray_rack()/door acrylic split all read this)

// VM-02 Task A.2/Cross-Cutting Warning: total_h is now DERIVED from the
// LIVE tray stack, not a literal. ROOFLINE_MARGIN re-derived exactly from
// v58's own real 2-tray design: DATUM_ROOFLINE(700) - stack top
// (370+2*121=612) = 88mm -- confirmed against the live v58 file, not
// assumed to be a round number.
ROOFLINE_MARGIN = 88;
total_h = tray_stack_z0 + tray_zone_h + ROOFLINE_MARGIN;   // 821mm @ default tray_count=3 (370+363+88)

DATUM_ROOFLINE = total_h;                            // now itself derived -- absolute top

// sensor_strip()'s own Z, shared datum (unaffected by tray_count -- this
// chain never reads it, per DO-NOT-TOUCH).
sensor_strip_z0 = tray_stack_z0 - 20;    // 350mm world, constant across all tray_count values
sensor_strip_h  = 8;

// Left-zone door Z range -- from DATUMS. door_bot_z uses the interior
// floor SURFACE (FOOT_BASE_H+skin_t-e), not the floor SKIN's absolute
// base (Rule M-1 shared volume, root-caused in VM-01 v55).
door_bot_z = FOOT_BASE_H + skin_t - e;   // 51.99mm
door_top_z = DATUM_ROOFLINE - skin_t;    // total_h - 2 -- now scales with tray_count via total_h
door_h     = door_top_z - door_bot_z;
exit_bot_z = door_bot_z + 30;

// Dashboard
dash_x = product_w + divider_t + skin_t;
dash_w = system_w - divider_t - (skin_t * 2);  // 143-19-4 = 120mm (10+100+10 border, Janis-confirmed) -- see header changelog "system_w RECOMPUTED"
screen_w = 165;    // physical panel LONG edge -- UNCHANGED per Task B.1, do not change this number
screen_h = 100;    // physical panel SHORT edge -- UNCHANGED per Task B.1, do not change this number
screen_protrude = 30;   // screen protrudes this far forward of front face
screen_y = skin_t - screen_protrude;   // -28mm — 30mm forward of front skin
bracket_r = 8;
bezel_t = 3;
qr_w = 40;
qr_h = 30;
qr_d = 10;
card_w = 85;
card_h = 8;
card_d = 15;
speaker_w = 60;
speaker_h = 20;
speaker_slots = 5;

// Task B.2: top-of-screen anchored total_h-400 (replaces the old fixed
// screen_center_z=280 -- screen center now DERIVED from this rule).
// CLAMPED: the mandatory tray_count=1/3/5 sweep found the literal
// total_h-400 rule alone pushes the QR/card/speaker stack BELOW THE
// FLOOR at tray_count 1-2 (total_h 579-700mm) -- a real, confirmed
// conflict between Task A's now-live total_h range and Task B's fixed
// offset. DASH_STACK_H is the exact vertical span from screen_top_z down
// to the speaker's own bottom edge (same chained offsets dashboard()
// uses below: screen_w(=screen_mount_h, portrait) + 50+qr_h + 30+card_h +
// 20+speaker_h). DASH_MIN_Z is the minimum world Z allowed for the
// speaker's own bottom edge (leg_h+10, a real 10mm clearance above the
// true floor). max() means: use the 400mm-from-top rule whenever the
// machine is tall enough for it to clear the floor; otherwise push the
// whole stack up just enough to stay valid. PROMOTED to a shared
// top-level DATUM (was module-local inside dashboard() only) so
// acrylic_display() can anchor its own lower zone boundary to the SAME
// value, not an independently re-derived copy (Datum Rules,
// .claude/rules-codes.md).
DASH_STACK_H = screen_w + 50+qr_h + 30+card_h + 20+speaker_h;  // 165+50+30+30+8+20+20 = 323mm
DASH_MIN_Z = leg_h + 10;   // 60mm
screen_top_z = max(total_h - 400, DASH_MIN_Z + DASH_STACK_H);   // 421mm @ default tray_count=3 (unclamped); clamps to 383mm at tray_count 1-2

// PROMOTED to shared top-level DATUMs (2026-07-10,
// vm02-lower-shell-fill-and-retro-governance, Part 1): dashboard()'s own
// Z-position chain (screen_z/qr_z/card_z/speaker_z) and its screen_mount_
// w/h aliases were module-local only in v1 -- outer_shell() now ALSO
// needs these same values for its new dashboard mounting cutouts (Task
// 1.3), so they're hoisted here and both modules read the SAME live
// datum, never an independently re-derived copy (Datum Rules; R-009
// Duplication Check performed before this edit: grepped the v1 file for
// this chain -- confirmed it existed in exactly ONE place, dashboard(),
// no other copy to fix).
screen_mount_w = screen_h;   // 100mm -- short physical edge, now the X extent
screen_mount_h = screen_w;   // 165mm -- long physical edge, now the Z extent
screen_center_z = screen_top_z - screen_mount_h/2;
screen_z        = screen_center_z - screen_mount_h/2;   // bottom-front translate anchor, same convention v58 used

qr_z      = screen_z - 50 - qr_h;
card_z    = qr_z - 30 - card_h;
speaker_z = card_z - 20 - speaker_h;

// Reuses this project's existing 2mm Global Clearance Tolerance
// convention (rules-dimensions.md) for the new dashboard-component
// mounting cutouts below -- not a new/invented tolerance value, per Task
// 1.3's explicit instruction.
PANEL_CUTOUT_CLEARANCE = 2;

// Acrylic display zone (upper right compartment) -- RESTORED 2026-07-10,
// Janis-confirmed: "we need acrylic window", the acrylic viewing feature
// stays PERMANENT, not removed (VM-02's first draft had dropped it as a
// judgment call -- reversed here). Resized for VM-02's narrower/portrait
// compartment and now-variable total_h: sits ABOVE the dashboard's own
// screen assembly (screen_top_z + a real clearance margin) up to the
// roofline, same "upper display, above the functional controls" concept
// VM-01's own acrylic_display() used (there: fixed Z 542-698, above
// tray_zone_top_z) -- just re-anchored to the live screen_top_z datum
// instead of the removed tray-stack-derived datum.
ACRYLIC_ZONE_MARGIN = 50;   // clearance above the screen assembly's own top edge before the acrylic zone starts
acrylic_zone_bot_z = screen_top_z + ACRYLIC_ZONE_MARGIN;
acrylic_zone_top_z = total_h - skin_t;
acrylic_zone_h = acrylic_zone_top_z - acrylic_zone_bot_z;   // 348mm @ default tray_count=3; 144mm @ tray_count=1 (both confirmed positive across the full 1-5 range, see cc_chat_log)

// Display shelf -- NEW (2026-07-10, vm02-dashboard-shelf-and-side-
// acrylic, Feature A). Shared top-level DATUM (Datum Rules) since
// display_shelf() is the only consumer today but this is a real
// world-Z reference point, same convention as acrylic_zone_bot_z above.
SHELF_TOP_MARGIN = 10;   // Janis: "just 10mm below the acrylic edge"
shelf_top_z = acrylic_zone_bot_z - SHELF_TOP_MARGIN;   // shelf's own TOP surface -- where display items sit
// Real gap pulling the shelf's rear edge off rear_service_door()'s own
// front face -- same magnitude/reasoning as ACRYLIC_OVERLAP below (a
// bare epsilon already shown insufficient for this class of large-area
// near-coincident face, R-002).
SHELF_REAR_GAP = 1;

// Tray's own X-inset / width -- CHANGED 2026-07-10 (2nd Janis follow-up):
// tray_x_inset 17mm->23mm, the SAME +6mm shift as product_w's own change
// above, so tray_w_global's formula below (product_w+e-frame_bar-2-
// tray_x_inset) evaluates to EXACTLY the same 389.01mm as before -- tray
// width/spring-lane layout is UNCHANGED, per Janis's own instruction
// ("keep the tray width"), only the tray's POSITION shifts right within
// the now-wider compartment. This is the real fix for the tray_zone_
// frame() left-vertical clearance gap (see header changelog "TRAY/FRAME
// CLEARANCE — FIXED"): the frame's LEFT vertical is anchored to the
// shell's own fixed front-left corner (independent of product_w) and
// doesn't move: shifting the tray's own left wall from X=17mm to X=23mm
// gives it a real 2mm clearance from the curve's actual 21mm reach
// (confirmed via CGAL, not assumed). The frame's RIGHT vertical (anchored
// to product_w+e) shifts by the same +6mm as the tray's own right wall,
// so the pre-existing 2mm right-side clearance is preserved automatically
// -- confirmed via a full tray_out_pct=0-1 CGAL sweep (door_open=true,
// the physically valid state for a fully-extended tray), Simple:yes
// throughout, not just the old ~27% range.
tray_x_inset = 23;
tray_w_global = (product_w + e - frame_bar - 2) - tray_x_inset;  // 389.01mm -- UNCHANGED numeric value (both terms shifted +6mm, cancels out)

// ─────────────────────────────
// MODULES
// ─────────────────────────────

module rounded_box(w, h, d, r) {
    hull() {
        translate([r, r, 0]) cylinder(r=r, h=h);
        translate([w-r, r, 0]) cylinder(r=r, h=h);
        translate([r, d-r, 0]) cylinder(r=r, h=h);
        translate([w-r, d-r, 0]) cylinder(r=r, h=h);
    }
}

// Height extended by e past leg_h so the top reaches e INTO the shell's
// floor skin -- a real (not degenerate) shared volume, Rule M-1.
module leg() {
    color("#AAAAAA")
    cylinder(h=leg_h + e, d=leg_od);
}

module legs() {
    positions = [
        [leg_inset, leg_inset],
        [total_w-leg_inset, leg_inset],
        [leg_inset, total_d-leg_inset],
        [total_w-leg_inset, total_d-leg_inset]
    ];
    for (p = positions)
        translate([p[0], p[1], 0]) leg();
}

module spring_coil() {
    color("#888888", 0.8)
    cylinder(h=spring_l - 2, d=spring_od - 2);  // d-2: 1mm clearance each side, clears tray wall tangent touch
}

// Motor at BACK. Spring front end at Y=0 (drop zone boundary). Products fall forward.
module spring_tray(tray_num) {
    tray_w = tray_w_global;
    z = tray_stack_z0 + (tray_num * tray_h);   // reference tray_stack_z0 (shifted +100mm), not tray_0_z directly
    // VM-02 Task A.3: per-tray independent slide -- indexes this tray's
    // OWN entry in the tray_out_pct vector, not a shared scalar.
    tray_y = tray_start_d - (tray_d * tray_out_pct[tray_num]);

    // VM-02 FIX (found via the mandatory tray_out_pct sweep, Section 7,
    // second real cause besides the rail contact above): adjacent trays
    // in the stack share an EXACT coincident Z-face (this tray's own top,
    // local Z=tray_h, lands exactly on the next tray's own bottom, zero
    // gap by construction of z=tray_stack_z0+tray_num*tray_h). At
    // tray_out_pct=0 for both, this is a FULL, corner-to-corner-aligned
    // coincident face (confirmed tolerated -- every tray_count=1/3/5
    // default render is clean) -- but once ONE of the two trays slides,
    // the same coincident Z-plane becomes a PARTIAL, staggered overlap: a
    // real T-junction (this file's own rules-codes.md "Never build a
    // tray/box using union() of separate floor+wall pieces... CGAL
    // detects T-junction topology = non-manifold" -- same class, not a
    // new one). Confirmed via real CGAL isolation: removing the tray
    // ABOVE a slid tray (spring_tray(tray_num+1)) alone clears the
    // warning; the rail-contact fix above is a SEPARATE, independent
    // real cause, not sufficient by itself. Fixed with a genuine (not
    // epsilon) vertical clearance between adjacent tray slots -- the
    // tray's own solid body stops TRAY_TOP_CLEARANCE short of the next
    // slot's floor, permanently removing the coincident plane regardless
    // of slide position on either tray. tray_h itself (the SLOT spacing,
    // OWNER-LOCKED) is unchanged -- only the physical tray body's own
    // height shrinks by this amount, invisible headroom at the very top
    // (the tray's usable interior floor/wall/spring geometry below is
    // untouched).
    TRAY_TOP_CLEARANCE = 2;   // mm, matches this file's own established 2mm Global Clearance Tolerance convention (rules-dimensions.md)
    tray_body_h = tray_h - TRAY_TOP_CLEARANCE;

    translate([tray_x_inset, tray_y, z]) {
        // Single solid box with hollow subtracted — no union() T-junctions, always manifold
        color("#CCCCCC")
        difference() {
            // Outer solid box — full tray footprint (see TRAY_TOP_CLEARANCE note above)
            cube([tray_w, tray_d, tray_body_h]);

            // Hollow interior — open top (+1 overshoot)
            translate([tray_wall_t, tray_wall_t, tray_floor_t])
                cube([tray_w - (tray_wall_t * 2),
                      tray_d - (tray_wall_t * 2),
                      tray_h - tray_floor_t + 1]);

            // Open front face (Y=0) — springs and products visible from front
            translate([tray_wall_t, -1, tray_floor_t])
                cube([tray_w - (tray_wall_t * 2),
                      tray_wall_t + 2,
                      tray_h - tray_floor_t + 1]);

            // Left side wall window
            translate([-1, tray_wall_t * 2, tray_floor_t + tray_wall_t])
                cube([tray_wall_t + 2,
                      tray_d - (tray_wall_t * 4),
                      tray_h - tray_floor_t - (tray_wall_t * 2)]);

            // Right side wall window
            translate([tray_w - tray_wall_t - 1, tray_wall_t * 2, tray_floor_t + tray_wall_t])
                cube([tray_wall_t + 2,
                      tray_d - (tray_wall_t * 4),
                      tray_h - tray_floor_t - (tray_wall_t * 2)]);

            // Rear motor mount cutouts — height 36: motor top = tray_floor_t+e+35 = 40.01mm, cutout top = 41mm ✓
            for (i = [0:spring_lanes-1]) {
                x = tray_wall_t + spring_od/2 + i*(spring_od + spring_gap);
                translate([x - 11, tray_d - tray_wall_t - 1, tray_floor_t])
                    cube([22, tray_wall_t + 2, 36]);
            }

            // Rear latch pin hole
            translate([tray_w/2, tray_d - tray_wall_t - 1, tray_h/2])
                rotate([-90, 0, 0])
                    cylinder(d=latch_pin_d, h=tray_wall_t + 2);

            // VM-02 Task A.4: sensor hole through the tray FLOOR (vertical,
            // Z-axis), one per lane, centered at the SAME lane centerline
            // X formula as the springs above (reused verbatim, not
            // re-derived), Y=5mm from this tray's own front edge (local
            // Y=0). Front-mounted -- confirmed clear of the rear
            // motor-mount cutouts above (those start at Y=tray_d-
            // tray_wall_t-1, this hole is at Y=5, a large real Y-gap for
            // any tray_d used in this file) and clear of the lane
            // partitions (which sit at the lane BOUNDARIES, not the lane
            // centerlines this hole is drilled at).
            for (i = [0:spring_lanes-1]) {
                x = tray_wall_t + spring_od/2 + i*(spring_od + spring_gap);
                translate([x, 5, -1])
                    cylinder(d=sensor_hole_d, h=tray_floor_t + 2);
            }
        }

        // Springs + motors — motor at back, spring front at Y=0
        // All objects offset by e from tray body faces to prevent coplanar non-manifold
        for (i = [0:spring_lanes-1]) {
            x = tray_wall_t + spring_od/2 + i*(spring_od + spring_gap);

            // Motor
            color("#555555")
            translate([x-9, tray_d - motor_d - tray_wall_t - e, tray_floor_t + e])
                cube([18, motor_d - 2, 33]);

            // Spring coil: Z centre +2mm above floor (clears $fn=64 polygon facet dip), d-2 clears walls
            color("#999999")
            translate([x, tray_d - motor_d - 2, tray_floor_t + spring_od/2 + 2])
                rotate([90, 0, 0])
                    spring_coil();

            if (i < spring_lanes-1) {
                // Partition: lifted e off floor, offset e from front wall, shortened e from rear wall inner face
                color("#BBBBBB")
                translate([x + spring_od/2 + spring_gap/2, tray_wall_t + e, tray_floor_t + e])
                    cube([2, tray_d-(tray_wall_t*2) - e, partition_h]);
            }
        }
    }
}

module tray_rack() {
    tray_w = tray_w_global;
    color("#AAAAAA")
    for (t = [0:tray_count-1]) {
        z = tray_stack_z0 + (t * tray_h);
        // VM-02 FIX (found via the mandatory tray_out_pct sweep, Section 7):
        // at tray_out_pct=1.0 EXACTLY, the sliding tray's rear edge
        // (world Y = tray_start_d + tray_d*(1-pct)) lands EXACTLY on this
        // rail's own front edge (tray_start_d) -- a real, confirmed 0mm
        // coincident-face touch (CGAL intersection dropped from a
        // genuine 26-facet shared volume at pct=0 to a degenerate
        // 2-facet touch at pct=1, isolated via a real CGAL render, not
        // guessed), the same Rule M-1 class this file has hit repeatedly
        // elsewhere (v52/v53/v55/v56). Same pre-existing bug confirmed
        // present in the locked VM-01 v58 file too (tray_out_pct=1 there
        // also renders Simple:no) -- out of scope to fix in that locked
        // file, but fixed here since VM-02's own mandatory testing
        // requires zero manifold warnings at every combination tested.
        // Fix: rail's front edge nudged back and its depth/height both
        // grown, guaranteeing a real (non-degenerate) shared volume with
        // the tray's own bottom face at ANY tray_out_pct 0-1, not just the
        // previously-tested values. A bare epsilon (e=0.01mm) nudge was
        // tried first and confirmed INSUFFICIENT here (real CGAL test:
        // still Simple:no in the full assembly even though the isolated
        // intersection alone reported valid) -- same lesson as R-002
        // ("epsilon is NOT enough" for some real contact classes,
        // originally stated for cylinder-to-face, applies here too for a
        // large-area near-coincident face pair). RAIL_OVERLAP=1mm
        // (visually negligible on an 8-10mm rail) gives CGAL real
        // floating-point margin instead of a razor's-edge coincidence.
        RAIL_OVERLAP = 1;
        translate([tray_x_inset, tray_start_d - RAIL_OVERLAP, z - rail_h])
            cube([rail_w, tray_d + RAIL_OVERLAP, rail_h + RAIL_OVERLAP]);
        translate([tray_x_inset + tray_w - rail_w, tray_start_d - RAIL_OVERLAP, z - rail_h])
            cube([rail_w, tray_d + RAIL_OVERLAP, rail_h + RAIL_OVERLAP]);
        translate([tray_x_inset + tray_w/2, tray_start_d + tray_d - tray_wall_t, z + tray_h/2])
            rotate([-90, 0, 0])
                cylinder(d=latch_pin_d, h=latch_pin_l);
    }
}

// Fixed/welded horizontal panel sealing the space vacated by the 100mm
// tray-stack shift (TRAY_SHIFT_UP) -- spans the full width of the tray/
// product compartment, NOT a removable/access panel. Positioned at the
// pre-shift tray_0_z, the anchor the trays moved away from. Front edge at
// drop_zone_d for a real 2mm-deep shared volume with exit_compartment_
// wall() (Rule M-1). Safety-critical, always on (see PART_MANIFEST.md).
module tray_compartment_partition() {
    partition_t = tray_floor_t;
    partition_y0 = drop_zone_d;
    partition_y1 = total_d - skin_t;

    color("#AAAAAA")
    translate([skin_t, partition_y0, tray_0_z])
        cube([product_w - (skin_t*2), partition_y1 - partition_y0, partition_t]);
}

// Rear-facing wall sealing the Y-direction reach-through at the drop-zone/
// tray-compartment boundary. Safety-critical, always on (see PART_MANIFEST.md).
module exit_compartment_wall() {
    partition_t = tray_floor_t;
    wall_t = skin_t;
    color("#AAAAAA")
    translate([skin_t, drop_zone_d, leg_h])
        cube([product_w - (skin_t*2), wall_t, (tray_0_z + partition_t + e) - leg_h]);
}

// Single shell module (inherited convention from VM-01 v58's own
// outer_shell()/outer_shell_debug() merge). VM-02 CHANGE: the left-zone
// front cutout (previously split at tray_zone_top_z, a vestige of a
// pre-v41 partial-height door concept) is now ONE full-height cutout, and
// the right-compartment front cutout (previously capped at tray_zone_top_z)
// is now ALSO full-height -- see header changelog for the full reasoning.
// This removes any dependency on DATUM_TRAY_TOP/tray_zone_top_z entirely.
module outer_shell() {
    shell_h = total_h - leg_h;

    // Shell independently re-derives the hinge center from its own datum
    // chain -- never reads left_zone_door()'s local variables, kept in
    // sync by hand (same convention as VM-01).
    shell_hinge_x = 0 - (hinge_od / 2);        // -6mm world
    shell_hinge_y = HINGE_Y_OFFSET;             // 25mm world
    shell_hinge_z = FOOT_BASE_H + skin_t - e;   // 51.99mm world
    shell_return_depth = shell_hinge_y - skin_t; // 23mm

    color("#C8C8C8", 0.75)
    difference() {
        rounded_box(total_w, shell_h, total_d, corner_r);

        // Hollow interior
        translate([skin_t, skin_t, skin_t])
            rounded_box(total_w-(skin_t*2), shell_h-(skin_t*2), total_d-(skin_t*2), corner_r-1);

        // Left product-zone front cutout -- VM-02: now ONE full-height
        // cutout (0..shell_h), see header changelog. left_zone_door() has
        // been a single continuous full-height leaf since VM-01 v41, so
        // the old two-piece split's union was always floor-to-roof
        // regardless of the split value -- simplified here, and this
        // removes the tray_zone_top_z/DATUM_TRAY_TOP dependency entirely.
        translate([skin_t, -1, 0])
            cube([product_w-(skin_t*2), skin_t+2, shell_h]);

        // Exit zone chute cutout
        translate([(product_w - exit_door_w)/2, -1, 0])
            cube([exit_door_w, skin_t+2, exit_door_h]);

        // Right compartment UPPER opening (acrylic display zone only) --
        // CHANGED 2026-07-10 (vm02-lower-shell-fill-and-retro-governance,
        // Part 1): was full floor-to-ceiling since VM-02 v1 (and the
        // IDENTICAL open hole existed in every VM-01 version since v6,
        // confirmed by Claude Web reading outer_shell() directly this
        // session -- a genuine, long-standing gap, not a regression this
        // prompt introduced). Janis's original spec (restated today):
        // the dashboard's lower zone sits inside SOLID sheet metal, with
        // the acrylic window starting only above it. Cutout now spans
        // ONLY from acrylic_zone_bot_z (the SAME live datum
        // dashboard()/acrylic_display() already use, not re-derived) up
        // to the roofline -- matching acrylic_display()'s own Z-zone
        // exactly, one cutout per one glazed opening.
        translate([product_w + divider_t, -1, acrylic_zone_bot_z - leg_h])
            cube([system_w - divider_t - skin_t, skin_t+2, shell_h - (acrylic_zone_bot_z - leg_h)]);

        // Right compartment LOWER zone -- NEW 2026-07-10 (Part 1): below
        // acrylic_zone_bot_z, down to the compartment floor, the front
        // face is now SOLID shell material (same skin_t thickness as the
        // rest of the shell) by simply NOT cutting a hole there -- the
        // base rounded_box()/hollow difference() above already provides
        // this skin wherever nothing else cuts it, no separate "fill"
        // piece needed. Individual mounting cutouts below, one per
        // dashboard component, each sized to that component's own real
        // footprint (read from dashboard()'s live code, reusing the
        // SAME shared datums, not re-derived) PLUS PANEL_CUTOUT_CLEARANCE
        // (2mm, this project's existing Global Clearance Tolerance
        // convention) on all sides. The screen/bezel assembly is TILTED
        // (-30deg) -- its cutout uses the assembly's full flat (untilted)
        // envelope (screen_mount_w/h + bezel_t border) rather than the
        // exact diagonal sliver where the tilted surface crosses this
        // thin skin_t skin, a deliberately generous superset confirmed
        // via real CGAL (Part 1 Task 1.5) to clear the ACTUAL tilted
        // geometry with zero collision, not just the flat approximation.

        // Screen + bezel + support-bracket mounting cutout. FOUND VIA REAL
        // CGAL (not assumed): a first pass sized only to the bezel's own
        // flat envelope (screen_z-bezel_t as the lower bound) left a real
        // ~3mm gap against dashboard()'s support bracket -- the bracket
        // is a SEPARATE, flat (non-tilted) crossbar (screen_z±bracket_r)
        // that reaches LOWER than the bezel does (bracket_r=8 > bezel_t=3),
        // confirmed by isolating intersection(){dashboard();outer_shell();}
        // and reading the actual colliding part's real X/Y/Z bounds, not
        // guessed. Lower bound now takes whichever of the two protrudes
        // furthest (max(bezel_t, bracket_r)), so both the bezel's own
        // flat footprint AND the bracket's real reach are covered.
        screen_cutout_z0 = screen_z - max(bezel_t, bracket_r) - PANEL_CUTOUT_CLEARANCE;
        screen_cutout_z1 = (screen_z - bezel_t) + screen_mount_h + (bezel_t*2) + PANEL_CUTOUT_CLEARANCE;
        translate([dash_x + dash_w/2 - screen_mount_w/2 - bezel_t - PANEL_CUTOUT_CLEARANCE,
                   -1,
                   screen_cutout_z0 - leg_h])
            cube([screen_mount_w + (bezel_t*2) + (PANEL_CUTOUT_CLEARANCE*2),
                  skin_t+2,
                  screen_cutout_z1 - screen_cutout_z0]);

        // QR scanner mounting cutout
        translate([dash_x + (dash_w - qr_w)/2 - PANEL_CUTOUT_CLEARANCE,
                   -1,
                   (qr_z - PANEL_CUTOUT_CLEARANCE) - leg_h])
            cube([qr_w + (PANEL_CUTOUT_CLEARANCE*2), skin_t+2, qr_h + (PANEL_CUTOUT_CLEARANCE*2)]);

        // ID card reader mounting cutout
        translate([dash_x + (dash_w - card_w)/2 - PANEL_CUTOUT_CLEARANCE,
                   -1,
                   (card_z - PANEL_CUTOUT_CLEARANCE) - leg_h])
            cube([card_w + (PANEL_CUTOUT_CLEARANCE*2), skin_t+2, card_h + (PANEL_CUTOUT_CLEARANCE*2)]);

        // Speaker grille mounting cutout -- speaker_h is this file's own
        // established total-footprint-height allocation for the 5-slot
        // grille (used identically in DASH_STACK_H's own chain above),
        // reused here rather than computing each slot's own sub-mm span.
        translate([dash_x + (dash_w - speaker_w)/2 - PANEL_CUTOUT_CLEARANCE,
                   -1,
                   (speaker_z - PANEL_CUTOUT_CLEARANCE) - leg_h])
            cube([speaker_w + (PANEL_CUTOUT_CLEARANCE*2), skin_t+2, speaker_h + (PANEL_CUTOUT_CLEARANCE*2)]);

        // Right-side viewing acrylic cutout -- NEW 2026-07-10 (vm02-
        // dashboard-shelf-and-side-acrylic, Feature B). CONFIRMED before
        // adding: no cutout existed on the machine's own RIGHT EXTERIOR
        // face (X=total_w wall) anywhere in this module before this
        // change -- show_shell_right only fully removes the whole panel
        // for debug isolation, never a permanent glazed opening.
        // Z-range: SAME live acrylic_zone_bot_z-to-roofline datum the
        // upper front cutout above already uses, not a new one (Janis:
        // "stretch to the top as current front view").
        // Y-range: corner_r to total_d/2 -- FRONT HALF of the
        // compartment's depth only (Janis-corrected mid-session, was
        // read backwards as the back half in an earlier draft). corner_r
        // is the exact tangent point where the shell's own rounded
        // front-right corner arc ends and this flat right face begins
        // (rounded_box()'s own corner-cylinder center sits at X=total_w-
        // corner_r, Y=corner_r) -- the SAME convention acrylic_display()'s
        // existing internal right panel already uses for its own
        // front-end recess, not an arbitrary split. Real numeric
        // coincidence supporting this as the "balanced" corner meeting
        // point Janis described: the FRONT acrylic panel's own right
        // edge (dash_x+dash_w=563mm) lands within 1mm of this exact
        // tangent point (total_w-corner_r=564mm) -- the two glazed faces
        // genuinely meet at the corner.
        translate([total_w - skin_t - 1, corner_r, acrylic_zone_bot_z - leg_h])
            cube([skin_t + 2, (total_d/2) - corner_r, shell_h - (acrylic_zone_bot_z - leg_h)]);

        // Left-side-wall recess for left_zone_door()'s return flange/hinge line.
        translate([-1, skin_t, shell_hinge_z - leg_h])
            cube([skin_t + 2, shell_return_depth, door_h]);

        // Front-left corner "pole" removal (VM-01 v50, inherited
        // unchanged) -- closed by the door leaf's own return flange, not
        // meant to be watertight on its own.
        translate([-1, -1, door_bot_z - leg_h])
            cube([corner_r + 2, shell_hinge_y + 2, door_h]);

        // Back panel — removed when show_shell_back = false
        if (!show_shell_back)
            translate([0, total_d - skin_t - 1, 0])
                cube([total_w, skin_t + 2, total_h]);

        // Top panel — removed when show_shell_top = false.
        if (!show_shell_top)
            translate([0, 0, shell_h - skin_t - 1])
                cube([total_w, total_d, skin_t + 2]);

        // Bottom panel — removed when show_shell_bottom = false
        if (!show_shell_bottom)
            translate([0, 0, -1])
                cube([total_w, total_d, skin_t + 2]);

        // Left panel — removed when show_shell_left = false
        if (!show_shell_left)
            translate([-1, 0, 0])
                cube([skin_t + 2, total_d, total_h]);

        // Right panel — removed when show_shell_right = false
        if (!show_shell_right)
            translate([total_w - skin_t - 1, 0, 0])
                cube([skin_t + 2, total_d, total_h]);
    }
}

// Bottom nudged e below world Z=leg_h (real shared volume, Rule M-1).
module compartment_divider() {
    color("#AAAAAA", 0.9)
    difference() {
        translate([product_w, skin_t, leg_h - e])
            cube([divider_t, total_d-(skin_t*2), total_h - leg_h - skin_t + e]);

        // Lock/latch STRIKE provision, inherited unchanged from v58.
        if (show_lock_provision)
            translate([product_w - e, skin_t - e, lock_provision_z0 - e])
                cube([lock_provision_d + e, lock_provision_w, lock_provision_h + 2*e]);
    }
}

// Samples `segs+1` points on a circle -- builds the door's curved flange
// and the frame's own curved left vertical.
function arc_pts(cx, cy, r, a0, a1, segs) =
    [for (i = [0:segs]) let(a = a0 + i*(a1-a0)/segs) [cx + r*cos(a), cy + r*sin(a)]];

// Left-zone front door — inherited unchanged from VM-01 v58 (Task D:
// stretches automatically, all Z-features already formulaic against
// door_bot_z/door_top_z, which now scale with VM-02's own derived
// total_h). LOCAL ORIGIN: (0,0,0) = the HINGE CENTER.
module left_zone_door() {
    hinge_x = 0 - (hinge_od / 2);      // -6mm
    hinge_y = HINGE_Y_OFFSET;          // 25mm
    hinge_z = FOOT_BASE_H + skin_t - e;  // 51.99mm

    door_x_offset = door_left_x - hinge_x;    // 8mm

    door_open_angle = door_open ? door_open_deg : 0;
    front_y = -(hinge_y - skin_t) + e;
    flap_top_z = (DATUM_LEG_TOP + 30 + exit_h) - hinge_z;      // 180mm local -- flap hinge line (DATUM_FLAP_TOP inlined, see DATUMS note)
    flap_angle = flap_open ? flap_open_deg : 0;

    lock_x1_local = (door_right_x - lock_provision_margin) - hinge_x;
    lock_x0_local = lock_x1_local - lock_provision_w;
    lock_z0_local = lock_provision_z0 - hinge_z;

    win_x0 = door_x_offset + window_x0;             // 46mm local
    win_x1 = door_x_offset + window_x0 + window_w;  // 382mm local

    exit_x_local = door_x_offset + (exit_x - door_left_x);
    exit_bot_local = exit_bot_z - hinge_z;

    // Acrylic/metal split point -- LIVE reference to tray_stack_z0
    // (unaffected by tray_count, confirmed).
    split_z_local = tray_stack_z0 - hinge_z;   // 320mm local -- world 370mm

    // acrylic_top_limit_z: pulled down to clear tray_zone_frame()'s own
    // top weld flange -- now scales with VM-02's derived door_top_z
    // (Task D, confirmed via render across tray_count 1/3/5).
    acrylic_top_limit_z = (door_top_z - frame_inset - FLANGE_T - e) - hinge_z;

    acrylic_pane_top_z = acrylic_top_limit_z - 2 - e;

    flap_cut_z1 = flap_top_z + flap_t + e;

    acrylic_x0 = win_x0 + 2 + e;
    acrylic_x1 = win_x1 - 2 - e;

    arc_cx = (skin_t + (corner_r - 1)) - hinge_x;
    arc_cy = (skin_t + (corner_r - 1)) - hinge_y;
    arc_r_outer = corner_r - 1;
    arc_r_inner = arc_r_outer - door_t;
    arc_segs = 12;

    outer_arc = arc_pts(arc_cx, arc_cy, arc_r_outer, 180, 270, arc_segs);
    inner_arc = arc_pts(arc_cx, arc_cy, arc_r_inner, 270, 180, arc_segs);

    door_poly = concat(
        [[door_x_offset, 0]],
        outer_arc,
        [[door_x_offset + door_w, front_y],
         [door_x_offset + door_w, front_y + door_t]],
        inner_arc,
        [[door_x_offset + door_t, 0]]
    );

    translate([hinge_x, hinge_y, hinge_z])
    rotate([0, 0, -door_open_angle]) {

        color("#888888", 0.9)
        difference() {
            linear_extrude(height = door_h)
                polygon(door_poly);

            translate([win_x0, front_y - 1, split_z_local])
                cube([win_x1 - win_x0, door_t + 2, (acrylic_top_limit_z - e) - split_z_local]);

            translate([exit_x_local, front_y - 1, exit_bot_local])
                cube([exit_w, door_t + 2, flap_cut_z1 - exit_bot_local]);

            if (show_lock_provision)
                translate([lock_x0_local, front_y - e, lock_z0_local])
                    cube([lock_provision_w, lock_provision_d + e, lock_provision_h]);
        }

        for (pct = [0.1, 0.5, 0.9])
            color("#333333")
            translate([door_x_offset - e, -(hinge_mark_d + e), door_h*pct - hinge_mark_h/2])
                cube([door_t + e*2, hinge_mark_d, hinge_mark_h]);

        if (show_acrylic) {
            color("#ADD8E6", 0.3)
            translate([acrylic_x0, front_y + door_t, split_z_local])
                cube([acrylic_x1 - acrylic_x0, door_acrylic_t, acrylic_pane_top_z - split_z_local]);

            color("#999999")
            translate([win_x0 + e, front_y + door_t, split_z_local])
                cube([(acrylic_x0 + e) - (win_x0 + e), door_t, acrylic_top_limit_z - split_z_local]);

            color("#999999")
            translate([acrylic_x1 - e, front_y + door_t, split_z_local])
                cube([(win_x1 - e) - (acrylic_x1 - e), door_t, acrylic_top_limit_z - split_z_local]);

            color("#999999")
            translate([acrylic_x0, front_y + door_t, acrylic_pane_top_z - e])
                cube([acrylic_x1 - acrylic_x0, door_t, (acrylic_top_limit_z - e) - (acrylic_pane_top_z - e)]);
        }

        if (show_flap)
            color("#B0B0B0", 0.9)
            translate([0, front_y, flap_top_z])
            rotate([flap_angle, 0, 0])
            translate([0, -front_y, -flap_top_z])
                translate([exit_x_local, front_y, exit_bot_local])
                    cube([exit_w, flap_t, exit_h]);
    }
}

// Static stopper rod for the exit flap -- fixed to the cabinet in world
// coordinates, unaffected by door_open. Inherited unchanged.
module flap_stopper_rod() {
    stop_y = skin_t + exit_h * sin(flap_open_deg);
    stop_z = (DATUM_LEG_TOP + 30 + exit_h) - exit_h * cos(flap_open_deg);  // DATUM_FLAP_TOP inlined, see DATUMS note

    color("#555555")
    translate([door_left_x, stop_y, stop_z])
        rotate([0, 90, 0])
            cylinder(d=hinge_od, h=door_right_x - door_left_x);
}

// H-frame: 2 full-height verticals + 1 crossbar + top/bottom weld flanges.
// Inherited unchanged from VM-01 v58 -- Task D: frame_z0/z1/frame_h are
// already formulaic against door_bot_z/door_top_z, stretch automatically
// with VM-02's derived total_h. Confirmed via render at tray_count 1/3/5,
// zero collision with the (now up to 5) trays -- the frame's own Y-range
// (7-9mm) never overlaps the trays' Y-range (tray_start_d=138mm onward).
module tray_zone_frame() {
    frame_z0 = door_bot_z + frame_inset;
    frame_z1 = door_top_z - frame_inset;
    frame_h  = frame_z1 - frame_z0;

    world_arc_cx = skin_t + (corner_r - 1);      // 21mm
    world_arc_cy = skin_t + (corner_r - 1);      // 21mm
    frame_arc_r  = (corner_r - 1) - frame_inset; // 14mm -- confirmed maximum, growing this re-collides the door (VM-01 v50/v57 finding, unchanged geometry here)
    frame_y0     = 7;
    frame_depth  = skin_t;

    left_bar_inner_x = door_left_x + frame_inset + frame_bar;  // 15mm

    inner_r = frame_arc_r - frame_bar;  // 6mm
    y_stop_angle = 180 + asin((world_arc_cy - frame_y0) / frame_arc_r);  // 270deg
    arc_segs = 24;

    left_outer_arc = arc_pts(world_arc_cx, world_arc_cy, frame_arc_r, 180, y_stop_angle, arc_segs);
    left_inner_arc = arc_pts(world_arc_cx, world_arc_cy, inner_r, y_stop_angle, 180, arc_segs);

    divider_touch_x  = product_w + e;                    // 422.01mm -- shifts +6mm with product_w's own 2026-07-10 change, preserving the tray's own right-side clearance automatically (see tray_x_inset's comment)
    right_bar_inner_x = divider_touch_x - frame_bar;

    color("#AAAAAA")
    union() {
        translate([0, 0, frame_z0])
            linear_extrude(height = frame_h)
                polygon(concat(left_outer_arc, left_inner_arc));

        translate([right_bar_inner_x, frame_y0, frame_z0])
            cube([divider_touch_x - right_bar_inner_x, frame_depth, frame_h]);

        // Crossbar -- at tray_0_z (fixed, unaffected by tray_count)
        translate([left_bar_inner_x, frame_y0, tray_0_z])
            cube([right_bar_inner_x - left_bar_inner_x, frame_depth, 10]);

        translate([left_bar_inner_x, frame_y0, frame_z1 - FLANGE_T])
            cube([right_bar_inner_x - left_bar_inner_x, frame_depth, FLANGE_T]);
        translate([left_bar_inner_x, frame_y0, frame_z0])
            cube([right_bar_inner_x - left_bar_inner_x, frame_depth, FLANGE_T]);
    }
}

// Parallel sensor strips -- left and right walls, just below the ACTUAL
// tray 0 floor. Inherited unchanged -- Z references sensor_strip_z0/h
// (DATUMS block), constant across all tray_count values (DO NOT TOUCH).
module sensor_strip() {
    strip_z = sensor_strip_z0;
    strip_t = 5;
    strip_h = sensor_strip_h;

    strip_x0 = skin_t + e;
    strip_x1 = product_w - skin_t - strip_t - e;

    strip_y0 = HINGE_Y_OFFSET + e;
    strip_y1 = skin_t + drop_zone_d;

    if (show_sensor) {
        color("#222222")
        translate([strip_x0, strip_y0, strip_z])
            cube([strip_t, strip_y1 - strip_y0, strip_h]);

        color("#222222")
        translate([strip_x1, strip_y0, strip_z])
            cube([strip_t, strip_y1 - strip_y0, strip_h]);
    }
}

// ATM dashboard — right compartment. VM-02 Task B.1/B.2/B.3: rebuilt for
// PORTRAIT mount. Physical panel dims UNCHANGED (screen_w=165/screen_h=
// 100, per Janis's locked spec) -- screen_mount_w/screen_mount_h below are
// the MOUNTED-ORIENTATION extents (swapped from landscape): the SHORT
// physical edge (100mm) now mounts along X (width), the LONG physical
// edge (165mm) now mounts along Z (vertical). The existing -30deg tilt
// (rotate about the X/horizontal axis) is orientation-agnostic to which
// physical edge is "width" -- same tilt mechanic, just fed the swapped
// dims, confirmed by inspecting the rotation math (not reconstructed from
// scratch).
module dashboard() {
    // screen_mount_w/h, screen_z, qr_z/card_z/speaker_z are now shared
    // top-level DATUMs (see PARAMETERS, "PROMOTED to shared top-level
    // DATUMs") -- outer_shell()'s new dashboard mounting cutouts (Task
    // 1.3) read the SAME values, never an independently re-derived copy.
    // No local re-declaration here (would shadow the global and silently
    // reintroduce the exact duplication this promotion was meant to remove).

    // Screen -- protrudes forward (screen_y = -30mm, unchanged mechanic).
    // X centered in dash_w via the SAME dash_x+dash_w/2-part_w/2 formula
    // the support bracket already used in v58 (the screen/bezel
    // themselves used a hardcoded "+10" offset in v58 -- fixed here for
    // consistency while rebuilding this geometry for portrait mount, a
    // bonus fix discovered in the same pass).
    color("#1A1A1A")
    translate([dash_x + dash_w/2 - screen_mount_w/2, screen_y, screen_z])
        rotate([-30, 0, 0])
            cube([screen_mount_w, 5, screen_mount_h]);

    // Screen bezel
    color("#333333", 0.8)
    translate([dash_x + dash_w/2 - screen_mount_w/2 - bezel_t,
               screen_y - 2, screen_z - bezel_t])
        rotate([-30, 0, 0])
            cube([screen_mount_w + (bezel_t*2), 3, screen_mount_h + (bezel_t*2)]);

    // Support bracket — flat crossbar cube, width now screen_mount_w
    color("#444444")
    translate([dash_x + dash_w/2 - screen_mount_w/2, screen_y, screen_z - bracket_r])
        cube([screen_mount_w, 30, bracket_r * 2]);

    // QR scanner -- same formula, re-centered via dash_w automatically
    color("#222222")
    translate([dash_x + (dash_w - qr_w)/2, 0, qr_z])
        cube([qr_w, qr_d, qr_h]);

    // ID card reader
    color("#333333")
    translate([dash_x + (dash_w - card_w)/2, 0, card_z])
        cube([card_w, card_d, card_h]);

    // Speaker grille — 5 slots
    slot_h = 2;
    slot_gap = 2;
    color("#444444")
    for (s = [0:speaker_slots-1]) {
        translate([dash_x + (dash_w - speaker_w)/2, 0,
                   speaker_z + s*(slot_h + slot_gap)])
            cube([speaker_w, 3, slot_h]);
    }
}

// Acrylic display — RESTORED 2026-07-10 (Janis: "we need acrylic
// window", the acrylic viewing feature is PERMANENT, not removed — a
// reversal of this file's own first-draft judgment call, see header
// changelog). 3 faces of the right compartment (front + right side +
// top, same concept as VM-01's own acrylic_display()), resized/re-
// anchored for VM-02's narrower/portrait compartment: front panel width
// now dash_w's own interior-width formula (was hardcoded to the old
// system_w proportions), Z-zone now anchored to the shared
// acrylic_zone_bot_z/acrylic_zone_top_z datums (above the dashboard's own
// screen assembly, up to the roofline) instead of the removed tray-
// stack-derived datum (DATUM_TRAY_TOP/tray_zone_top_z — see the earlier
// Cross-Cutting Warning resolution note). Right-side panel UNCHANGED
// (spans corner_r to total_d-corner_r in Y, at the machine's own far
// right edge — independent of the compartment's own interior width).
module acrylic_display() {
    // VM-02 FIX (found via real CGAL render on the FULL assembly -- this
    // one did NOT reproduce in isolated pairwise intersection tests
    // against the shell alone, a known CGAL robustness quirk; only
    // surfaced once the full boolean union was actually computed, so
    // isolation alone would have missed it): dash_x+dash_w is
    // ALGEBRAICALLY IDENTICAL to the shell's own right-compartment cutout
    // end (product_w+system_w-skin_t, confirmed by expanding both
    // formulas), for ANY system_w value -- meaning the front panel's own
    // right edge always lands EXACTLY on the boundary where the shell's
    // cutout stops and solid material resumes. Pulled the panel's width
    // in by a real ACRYLIC_OVERLAP margin (reusing the same constant/
    // convention as the right/top panels below) so it sits with genuine
    // clearance inside the cutout instead of touching its exact edge.
    ACRYLIC_OVERLAP = 1;
    acrylic_front_w = dash_w - ACRYLIC_OVERLAP;
    acrylic_front_x = dash_x;

    color("#ADD8E6", 0.3)
    translate([acrylic_front_x, e, acrylic_zone_bot_z])
        cube([acrylic_front_w, door_t, acrylic_zone_h]);

    // Right panel — recessed to corner_r on both Y ends (clears the
    // shell's rounded corner, same VM-01 v39 fix, unchanged reasoning).
    // VM-02 FIX (found via real CGAL render, restoring this module):
    // this panel's own right edge (X = total_w-skin_t, by construction)
    // landed EXACTLY on the shell's own interior wall surface (same X) --
    // a real, substantial coincident-face touch (Rule M-1), inherited
    // unchanged from VM-01's own formula but never actually flagged there
    // since it was hidden by more prominent issues. Nudged +e so the
    // panel reaches e INTO the shell's own wall, a real (non-degenerate)
    // shared volume. A bare epsilon (e=0.01mm) was tried first and
    // confirmed INSUFFICIENT here (same R-002 lesson as tray_rack()'s own
    // fix above -- epsilon is not always enough for a large-area
    // near-coincident face); ACRYLIC_OVERLAP=1mm (cosmetically invisible
    // on a 2mm-thick acrylic panel, declared once at the top of this
    // module) gives CGAL real margin instead.
    // Y-RANGE CHANGED 2026-07-10 (vm02-dashboard-shelf-and-side-acrylic,
    // TASK 3): was corner_r to total_d-corner_r (20-580mm, full depth) --
    // now the FRONT HALF only, to match the new right-exterior viewing
    // cutout added to outer_shell() this session (Feature B) so the
    // glazing material and its opening align.
    // REAL CGAL FINDING: sizing this panel's Y-range to EXACTLY match the
    // new cutout's own Y-range (corner_r to total_d/2, both ends) landed
    // both boundaries exactly on the cutout's own edges -- a real
    // coincident-edge touch (Rule M-1, confirmed via isolating
    // intersection(){outer_shell();acrylic_display();}, 6 facets/2
    // volumes non-manifold). Fixed the same way this module's other two
    // panels already do: a real ACRYLIC_OVERLAP (1mm) past the cutout's
    // own boundary on EACH Y end, into solid shell material either side
    // (the rounded corner surface on the front end, plain wall skin on
    // the rear end) -- not a bare touch.
    color("#ADD8E6", 0.3)
    translate([total_w - (skin_t*2), corner_r - ACRYLIC_OVERLAP, acrylic_zone_bot_z])
        cube([skin_t + ACRYLIC_OVERLAP, (total_d/2) - corner_r + (ACRYLIC_OVERLAP*2), acrylic_zone_h]);

    // VM-02 FIX (same session, found via real CGAL render): this panel
    // originally touched TWO different faces at once -- its own rear edge
    // (Y=total_d-skin_t, by construction) landed exactly on BOTH
    // rear_service_door()'s front face AND the shell's own back-wall
    // inner surface (same Y, a NEW interaction from combining this
    // session's own two changes: acrylic restored + rear door now full
    // floor-to-ceiling, Task B.6 -- VM-01's original half-height door
    // never reached this high) -- AND its own top edge (Z=total_h-skin_t)
    // simultaneously touched the shell's interior roof surface. A simple
    // +overlap on the Y side alone (tried first) made it overlap the
    // shell's solid back-wall skin WHILE still exactly touching the roof
    // in Z -- a doubly-coincident corner, confirmed via CGAL to still be
    // non-manifold (9 vertices on what should be an 8-vertex box, the
    // signature of a degenerate shared edge, not a clean shared volume).
    // Fixed by treating each face independently: Z gets a real
    // ACRYLIC_OVERLAP into the roof (matches the right panel's own fix
    // above); Y gets a small real GAP instead (pulls back, doesn't touch
    // the back wall/door at all) -- a 1mm reveal, cosmetically invisible.
    color("#ADD8E6", 0.3)
    translate([acrylic_front_x, skin_t, total_h - (skin_t*2)])
        cube([acrylic_front_w, total_d-(skin_t*2)-ACRYLIC_OVERLAP, skin_t+ACRYLIC_OVERLAP]);
}

// Display shelf -- NEW 2026-07-10 (vm02-dashboard-shelf-and-side-acrylic,
// Feature A). Physical floor for display items, sitting just below the
// acrylic display zone's own bottom edge (see shelf_top_z's own comment
// in PARAMETERS/DATUMS above). Separate module from acrylic_display() --
// this is a different physical part (a floor, not a viewing pane), same
// "one physical part per module" convention this file already follows.
// Own show_* toggle from this module's first commit (Toggle-
// Completeness Rule) -- not left as a GAP.
module display_shelf() {
    shelf_t = tray_floor_t;   // 5mm, reused floor-thickness convention (see tray_compartment_partition())

    // REAL CGAL FINDING: this panel's own rear edge (Y=total_d-skin_t,
    // same construction compartment_divider() uses for a full-depth
    // panel) landed exactly on rear_service_door()'s own front face --
    // same coincident-face class acrylic_display()'s top panel hit
    // above. Pulled back by SHELF_REAR_GAP (1mm, real, not bare epsilon
    // -- R-002) instead of touching it.
    shelf_y0 = skin_t;
    shelf_y1 = (total_d - skin_t) - SHELF_REAR_GAP;

    color("#AAAAAA")
    translate([dash_x, shelf_y0, shelf_top_z - shelf_t])
        cube([dash_w, shelf_y1 - shelf_y0, shelf_t]);
}

// Solid opaque hand-safety side guards -- inherited unchanged. Height
// covers whichever is taller, the shell's exit-chute flank or the sensor
// strip's own top (unaffected by tray_count, DO NOT TOUCH zone). Safety-
// critical, always on (see PART_MANIFEST.md).
module drop_zone_guards() {
    guard_y0 = HINGE_Y_OFFSET + skin_t;        // 27mm
    guard_y1 = skin_t + e + drop_zone_d;       // 140.01mm
    guard_depth = guard_y1 - guard_y0;
    guard_h = max(exit_door_h, (sensor_strip_z0 + sensor_strip_h) - leg_h);

    color("#DDDDDD")
    translate([skin_t + door_t + e, guard_y0, leg_h])
        cube([skin_t, guard_depth, guard_h]);

    color("#DDDDDD")
    translate([product_w - skin_t - skin_t - e, guard_y0, leg_h])
        cube([skin_t, guard_depth, guard_h]);
}

// VM-02 Task B.6: rear service door rebuilt full floor-to-ceiling height
// (was a fixed 50%-height panel in v58). Width = system_w-10 (123mm, see
// header changelog "system_w RECOMPUTED"). Centered in the compartment's
// own interior width (system_w-divider_t, matching dash_w's own reference
// frame) for symmetric best access -- cc's discretion per the prompt,
// stated here per its own instruction.
module rear_service_door() {
    door_w = system_w - 10;                          // 123mm
    door_h = (total_h - skin_t) - leg_h;              // full compartment interior, floor to ceiling, world Z
    door_x = product_w + divider_t + ((system_w - divider_t) - door_w)/2;  // centered in the compartment's interior width
    color("#B8B8B8", 0.6)
    translate([door_x, total_d - skin_t, leg_h])
        cube([door_w, skin_t*2, door_h]);
}

// ─────────────────────────────
// DIAGNOSTIC TOOLS — on-demand only, never called from ASSEMBLY
// ─────────────────────────────
// Inherited from VM-01 v58 (.claude/SKILL_clearance_zone_map.md). NOT
// wired into ASSEMBLY -- invoke only via a scratch include during active
// diagnosis, per that skill file's own "Do NOT" list.
module clearance_zone_map(bands=[[0,"red"],[0.5,"orange"],[2,"yellow"]]) {
    for (b = bands) {
        offset = b[0]; col = b[1];
        color(col, 0.85)
        intersection() {
            if (offset == 0) {
                children(0);
            } else {
                minkowski() {
                    children(0);
                    sphere(r=offset, $fn=16);
                }
            }
            children(1);
        }
    }
}

// ─────────────────────────────
// ─────────────────────────────
// EXPORT MODES — set toggles below before export
// ─────────────────────────────
// STANDARD: shell intact → see through window → VM-02-v1-std.stl
// FULL EXTERIOR: set show_acrylic=false (leaf's own skin fills the window
//   instead) → VM-02-v1-full.stl
// OPEN/C2: set show_shell_top/left=false below for inspection → VM-02-v1-C2.stl
// (render_mode removed -- VM-02's only render_mode-gated consumer,
// acrylic_display(), no longer exists; see header changelog.)

// DEBUG TOGGLES — used in "open" (C2) mode to remove shell panels
// ─────────────────────────────
show_shell_back   = true;
show_shell_top    = true;
show_shell_bottom = true;
show_shell_left   = true;
show_shell_right  = true;

// VIEWER TOGGLES — for multi-state STL export
// ─────────────────────────────
door_open    = false;   // true -> left_zone_door() leaf swung open (door_open_deg) for viewer STL
flap_open    = false;   // true -> exit flap swung open (flap_open_deg) for viewer STL

// ISOLATION TOGGLES — for manifold-debug inspection
// ─────────────────────────────
show_door    = true;
show_acrylic = true;
show_flap    = true;
show_sensor  = true;
show_frame   = true;
show_lock_provision = true;
show_acrylic_display = true;   // NEW (VM-02): isolation toggle for acrylic_display() -- VM-01's own equivalent had NO show_* toggle (render_mode-gated only, a confirmed Toggle-Completeness gap per its own PART_MANIFEST.md); added properly here since the module was rebuilt from scratch this session anyway
show_display_shelf = true;   // NEW 2026-07-10 (vm02-dashboard-shelf-and-side-acrylic): isolation toggle for display_shelf(), added from this module's first commit -- Toggle-Completeness Rule

// ─────────────────────────────
// ASSEMBLY
// ─────────────────────────────

legs();

// Outer shell — shown in all modes (show_shell_* toggles control which panels visible)
translate([0, 0, leg_h]) outer_shell();

compartment_divider();

tray_rack();
for (t = [0:tray_count-1]) spring_tray(t);

if (show_acrylic_display) acrylic_display();   // RESTORED 2026-07-10, Janis-confirmed permanent — see header changelog
if (show_display_shelf) display_shelf();   // NEW 2026-07-10, vm02-dashboard-shelf-and-side-acrylic

if (show_door) left_zone_door();
flap_stopper_rod();
if (show_frame) tray_zone_frame();
drop_zone_guards();
tray_compartment_partition();
exit_compartment_wall();

sensor_strip();

dashboard();
rear_service_door();
