// VM-01 Base Vending Machine
// Janis Product Design
// Version: v56
// Date: 2026-07-07
// Units: mm
// Purpose: Smart donation vending machine — buddha ornaments
// Payment: Online only, no cash/coin mechanism
//
// Changes from v55 (vm01-v56-sensor-bracket-frame-joint-fix — direct
// response to Janis's QA screenshots on the merged v55 PR; OpenSCAD binary
// used for every finding below, real CGAL + real renders, not estimates):
//   FIX 1 (sensor "lifted out" of drop_zone_guards()): the v54 fix moved
//     sensor_strip()'s Z up (world 250->350mm) to clear a real collision
//     with exit_compartment_wall() -- correct move, but it stranded the
//     strip 50mm above drop_zone_guards()'s own top (world Z 300, sized
//     only to flank the shell's exit-chute cutout, never tied to the
//     sensor at all). Moving the sensor back down would reopen that
//     confirmed collision, so per Janis's own instruction ("if by design
//     sensor have to be here then the bracket to hold it must revise"):
//     hoisted the sensor's Z to a shared datum (sensor_strip_z0/
//     sensor_strip_h, DATUMS block -- both sensor_strip() and
//     drop_zone_guards() now read the SAME value, not two independently-
//     derived copies, per the v55 lesson on datum drift) and grew
//     drop_zone_guards()'s own height to cover whichever is taller, the
//     exit-chute flank or the sensor's own top. Verified: guard-vs-sensor
//     intersection is now real solid overlap (12 facets, Simple:yes,
//     properly enclosed); guard-vs-door 9-angle+ sweep still zero overlap
//     at every angle (re-verified fresh, taller guard is a new shape).
//   FIX 2 (tray_zone_frame() left vertical "bad joint"): Janis's
//     screenshot showed a visible kink where the curve met a straight
//     line -- "should be single piece curve...just like front door
//     curve". Root cause: v50 narrowed frame_bar 20mm->8mm (paired with a
//     radius-growth attempt to 19.01mm that was later reverted back to
//     14mm) but never revisited frame_bar itself -- left the curve
//     truncated early (X-bound) to dodge a self-intersection, with a
//     straight vertical segment picking up at a non-tangent angle (a
//     real C1 discontinuity, not a rendering artifact). Fixed: rebuilt
//     using the SAME concentric double-arc + radial-end-cap construction
//     left_zone_door() already uses for its own curve (arc_pts() helper,
//     reused directly) -- frame_bar itself untouched (still 8mm, so
//     tray_w_global/right_bar_inner_x/divider clearance are all
//     unaffected). Verified: frame-vs-door 9-angle+ sweep still zero
//     overlap; frame-alone CGAL Simple:yes; a direct probe at the
//     left-bar/crossbar junction confirms real (non-degenerate) overlap,
//     not a new touching-face risk. Visually confirmed via real render:
//     kink is gone, single continuous curve down to a clean vertical edge.
//   FLAGGED, NOT CHANGED (acrylic "double sheet" in door-open screenshot):
//     rendered the actual open-door top view this session (v52's own fix
//     here was arithmetic-only, "Janis F6 recheck required", never
//     actually confirmed via a live render until now). Confirmed: no
//     duplicate #ADD8E6 object exists (left_front_acrylic() is still dead
//     code, not called in ASSEMBLY -- same finding as v52). Initial
//     hypothesis (acrylic's own door_t recess reading as 2 lines) was
//     WRONG -- Janis re-tested with show_acrylic=false and the double
//     line was STILL there, ruling the acrylic out entirely. See TASK 3
//     below for the corrected finding.
//
// TASK 3 (same v56 round, added after Janis tested the above and reported
// back): 2 more findings from her live toggle testing on the fixes above.
//   MANIFOLD WARNING NOW FULLY RESOLVED: Janis's own toggle testing
//     (show_door=false clears it, show_shell_left=false clears it,
//     show_shell_top=false does NOT) pointed at a real door-vs-left-corner
//     touch, not the compartment_divider() issue v55 had flagged as the
//     sole remaining cause. Root-caused via a real CGAL intersection():
//     BOTH outer_shell()'s and outer_shell_debug()'s independently-
//     duplicated corner-pole cutout (v50 TASK 1) had a real X-Y coverage
//     gap with the left-side-wall recess cutout next to it -- the recess
//     only reached X<=3mm, the corner-pole cutout only reached Y<=21mm,
//     leaving a real (2mm x 4mm) sliver of the shell's floor-skin material
//     at world X3-5/Y21-25 that neither one removed. The door's own
//     return-flange footprint clips into exactly that sliver in the
//     floor-skin's own thin Z-band (51.99-52mm) -- confirmed via CGAL:
//     `Simple: yes`, a real non-degenerate 6-facet volume, an actual (if
//     tiny) physical interference, not a manifold-warning-class degenerate
//     touch. First fix attempt (nudging the cutout's Z-start by -e,
//     matching this file's usual Rule M-1 pattern) had ZERO effect,
//     confirmed via CGAL -- proved this was an X-Y gap, not a Z-boundary
//     coincidence. Fixed properly: BOTH cutouts' Y-reach extended from
//     `corner_r+2`(22) to `shell_hinge_y+2`(27), closing the gap (only
//     editing outer_shell()'s copy first and re-testing showed ZERO
//     change -- caught the SECOND independently-duplicated copy in
//     outer_shell_debug(), the one actually used in ASSEMBLY, same class
//     of bug as the v55 door-floor datum fix). RESULT: full assembly
//     manifold warning is COMPLETELY GONE at every angle (0-100 deg,
//     10-angle sweep, zero warnings) -- the first time in this file's
//     history the door-closed warning has been fully eliminated, not just
//     narrowed. The compartment_divider()-vs-shell touch flagged in v55
//     still exists in ISOLATION (re-confirmed, 7 facets + warning when
//     tested alone) but does NOT propagate into the full-assembly warning
//     -- left as-is, downgraded from "the sole remaining cause" to "an
//     isolated finding with no observed full-assembly impact."
//   ACRYLIC "DOUBLE SHEET" -- RE-DIAGNOSED (still flagged, not a bug):
//     Janis's own show_acrylic=false test disproved the recess theory
//     above. Re-checked with a clean isolation render: left_zone_door()
//     ALONE (no frame, no acrylic, no shell) still shows the same double
//     line at a grazing viewing angle. This is the door leaf's own
//     material thickness (door_t=3mm) -- any finite-thickness edge shows
//     2 parallel lines (front face boundary + back face boundary) when
//     viewed near edge-on, in ANY solid modeling viewer, for ANY single
//     part -- not a duplicate object, not a frame/acrylic interaction.
//     Confirmed by elimination, not guessed: reproduced with the door as
//     the ONLY object in the scene. If this doesn't match what Janis is
//     seeing (e.g. the 2nd line is a visibly different color/material),
//     needs a fresh screenshot with show_frame=false/show_acrylic=false
//     both set to confirm which specific surfaces she's looking at.
//
// Changes from v54 (vm01-v55-door-floor-datum-fix — Janis asked directly
// for a fix to the door-closed manifold warning that had persisted across
// several versions; OpenSCAD binary available, every finding below is a
// real CGAL boolean, not an estimate):
//   ROOT CAUSE (re-diagnosed from scratch, not assumed from the two
//     exact-tangency findings carried since v52/v53): those two findings
//     (door_top_z vs. shell roof skin; hinge-pivot cylinder vs. exterior
//     wall) were re-tested this session with a full 9-angle sweep against
//     the REAL assembly (not just an isolated slice at angle=0, which is
//     all that was tested when they were first found) -- BOTH came back
//     completely clean (empty, no warning) at every angle. Neither one is
//     actually the door-closed trigger; that earlier attribution was
//     wrong, corrected here rather than carried forward silently.
//     The REAL cause, found via a real CGAL intersection() of the FULL
//     (unsliced) door against the FULL shell: `door_bot_z` (and its 3
//     independently-re-derived copies -- `hinge_z` in left_zone_door(),
//     `shell_hinge_z` in both outer_shell()/outer_shell_debug()) was
//     defined as `FOOT_BASE_H + 0` -- the shell's ABSOLUTE base (bottom of
//     the floor skin itself, where the legs attach), not the interior
//     floor SURFACE the door should actually rest on
//     (`FOOT_BASE_H + skin_t`, the top of that same skin, where usable
//     interior space begins). This buried the door's bottom ~2mm INSIDE
//     the shell's own floor slab across almost its entire footprint -- a
//     real, substantial (12-facet, non-degenerate) collision, present
//     since at least v53, angle-dependent in exactly the way Janis
//     reported (present at 0°, mostly gone by 20°, fully clear by 25°+).
//   FIX: all 4 copies changed to `FOOT_BASE_H + skin_t - e` -- the correct
//     interior floor surface, nudged e below it for a real (not
//     degenerate) shared volume with the floor skin, this file's own
//     established Rule M-1 epsilon-nudge convention. `e`'s own declaration
//     MOVED earlier in PARAMETERS (was declared after door_bot_z, which
//     doesn't work for a top-level forward reference in OpenSCAD -- see
//     PARAMETERS comment). Re-verified: full door-vs-shell intersection at
//     door_open_deg=0 is now `Simple: yes`, a real overlap, no warning;
//     9-angle sweep (0/20/25/30/35/40/45/70/100) unchanged in character
//     from before (clear by 25°) but the 0°/20° facets are now real,
//     valid geometry instead of a degenerate touch.
//   SAME PATTERN, 2 MORE INSTANCES found via a systematic 3-way isolation
//     (door+shell+each other ASSEMBLY part, since pairwise tests alone
//     didn't reveal it): `leg()` and `compartment_divider()` both also sat
//     flush at world Z=leg_h, the exact same boundary as the shell's own
//     floor skin. `leg()` fixed (height +e, real overlap into the floor,
//     confirmed clean -- 276 real facets, no warning).
//     `compartment_divider()` given the SAME Z-nudge (bottom -e, height
//     +e) for consistency, but this did NOT fully resolve its own
//     SEPARATE touch with the shell (confirmed via direct shell-vs-divider
//     intersection() test, still 7 facets + warning, UNCHANGED even at
//     1mm of Z-overlap -- proving this specific one is NOT a Z-clearance
//     issue, more likely an X-Y edge alignment, the same class of problem
//     drop_zone_guards() turned out to have in v54). NOT resolved this
//     round -- flagged explicitly, not force-fitted; needs a dedicated
//     isolation pass, same discipline as the acrylic/guard fixes.
//   SIDE EFFECT (confirmed via direct render comparison, not assumed):
//     the v50 corner-pole cutout's own Z-start also reads `door_bot_z`
//     (both outer_shell()/outer_shell_debug()) -- raising it by ~skin_t
//     also lifted that cutout's bottom OFF the shell's floor skin,
//     independently CLOSING the bottom-left-corner floor hole isolated
//     (but explicitly not fixed) in an earlier session -- same root datum,
//     confirmed by direct before/after render comparison at the exact
//     hole location (v54: empty/hole: v55: 13 real facets/solid).
//   STATUS: full-assembly manifold warning at door_open_deg=0 STILL
//     PRESENT after this round -- entirely attributable now to the
//     remaining compartment_divider()-vs-shell touch (confirmed via
//     isolation, not assumed), NOT the door, NOT the legs, NOT the two
//     previously-suspected exact-tangency findings (both cleared this
//     session). This is real, substantial narrowing of the problem, not a
//     full resolution -- stated plainly rather than claiming done.
//
// Changes from v53 (vm01-v54-sensor-bracket-fix — 2 real fixes, both
// re-diagnosed from live geometry rather than taken on the source
// prompt's own framing; OpenSCAD binary WAS available and used for every
// check this session, including a real 9-angle CGAL sweep, not estimates):
//   TASK 1 (sensor_strip()): the prompt described this as a facing/
//     visibility bug ("sitting on the outside face... should face
//     inside"). Checking the actual code found something different and
//     more significant: `strip_z` referenced `tray_0_z` (270mm, the
//     PRE-v46 tray anchor kept ONLY for `tray_compartment_partition()`'s
//     own sealing reference, explicitly NOT the trays' live position) --
//     every other module needing the trays' actual position
//     (`spring_tray()`, `tray_rack()`) was switched to `tray_stack_z0` in
//     v46; this one was missed. Real CGAL intersection() confirmed a
//     genuine 12-facet SOLID overlap with `exit_compartment_wall()` (a
//     fixed safety-critical part) at the stale Z (250mm world) -- a real
//     collision, not a degenerate touch. Fixed: `strip_z` now references
//     `tray_stack_z0` (350mm, was 250mm) -- re-verified ZERO overlap vs
//     exit_compartment_wall(). Separately confirmed via render (oblique
//     exterior camera angle): the strip IS visible from outside in the
//     current model, but this traces to the already-flagged, out-of-scope
//     v50 corner-pole gap (same root feature behind the previously-found
//     bottom-left floor hole) -- NOT to this strip's own coordinates;
//     moving Z does not change that, stated explicitly rather than
//     claimed fixed.
//   TASK 2 (drop_zone_guards()): the prompt claimed this bracket was
//     "already known, oversized toward the front and in Z, prior session,
//     deprioritized as no harm" -- searched cc_chat_log.md and
//     rules-dimensions.md in full, found NO such record anywhere, not
//     acted on without a traceable source. What real CGAL DID confirm:
//     the v47 front-edge value (`world_arc_cy+e`=21.01mm) is an EXACT
//     zero-clearance tangent against the door's return-flange arc -- a
//     1-facet degenerate touch, the same signature as the v52/v53
//     exact-tangency findings, not caught by v47's own Python-approximated
//     sweep. A first correction (`world_arc_cy+skin_t`=23mm) was tested
//     and found INSUFFICIENT -- a SEPARATE 1-facet touch remained against
//     the door's INNER hinge-line straight segment (world X=5, Y=21-25).
//     Fixed instead: `HINGE_Y_OFFSET+skin_t` (27mm, was 21.01mm) -- reuses
//     the same reference point `sensor_strip()` already uses (confirmed
//     to clear the door's global max Y at any X) plus this file's own
//     "structural part to shell face: 2mm" clearance convention instead
//     of bare epsilon. Re-verified: real CGAL 9-angle sweep
//     (0/20/25/30/35/40/45/70/100), ZERO overlap at every angle. Z-range
//     (leg_h..+exit_door_h) left UNCHANGED -- no evidence found to justify
//     the prompt's claimed Z-oversizing.
//   TASK 3 (manifold re-check): full-assembly re-render after both fixes
//     -- door OPEN: clean, no warning (unchanged from before). Door
//     CLOSED (door_open_deg=0, default): warning STILL PRESENT. Neither
//     fix was the (sole) cause -- both resolved real, independently-
//     confirmed defects, but the door-closed warning persists, consistent
//     with the two SEPARATE, already-known, explicitly out-of-scope
//     exact-tangency findings from v52/v53 (door_top_z vs. roof skin;
//     hinge-pivot cylinder vs. exterior wall) -- neither touched this
//     round, per this prompt's own DO NOT TOUCH.
//
// Changes from v52 (vm01-clearance-zone-map-skill-and-application —
// diagnostic tool addition only, ZERO production geometry change):
//   New `clearance_zone_map()` module (permanent, reusable — see
//   .claude/SKILL_clearance_zone_map.md) added below, near the other
//   utility modules. NOT called anywhere in ASSEMBLY, not wired into any
//   render path — a diagnostic tool invoked on demand via a scratch
//   include, never committed as a live call.
//   OpenSCAD binary WAS available and used this session (real CGAL
//   minkowski()+intersection() renders, not arithmetic estimates) to
//   apply the skill to both of v52's open findings:
//   FINDING 1 (door_top_z vs. shell roof skin, isolated to the top-left
//     CORNER region specifically, world X/Y -5..25/-3..27, Z 690-710 —
//     the middle of the door's width, X 150-250, was separately tested
//     and confirmed CLEAN/empty, no touching there at all): 0mm band =
//     EMPTY (no volumetric overlap, confirmed via real CGAL, not
//     estimated) -- but 0.02mm band already shows a substantial, stable
//     facet count (~175-205, confirmed robust across 2 independently
//     placed bounding boxes) -- this jump-to-substantial-immediately
//     pattern (not a gradual small-to-large growth) is the CGAL signature
//     of an EXACT planar/tangent touch, not a genuine small real-world
//     gap (see SKILL_clearance_zone_map.md "Reading the result"). Real
//     measured clearance: 0.000mm exactly (true tangency), CGAL-confirmed
//     this session, not an arithmetic estimate as in v52. Still shows
//     overlap at 2mm and 5mm bands (bounded region, not infinite).
//   FINDING 2 (v50 hinge-pivot reinforcement cylinder vs. shell exterior
//     wall, tested both by slicing the real cylinder out of
//     left_zone_door() at mid-height Z=300-320 AND by reconstructing the
//     cylinder directly from its own named constants -- both methods
//     agree): 0mm band = EMPTY, 0.02mm band = substantial stable overlap
//     (5-9 facets, smaller feature than Finding 1, same signature) --
//     SAME exact-tangency pattern, real measured clearance 0.000mm
//     exactly, CGAL-confirmed.
//   Both findings independently robustness-checked by shifting the test
//   bounding box position/size and re-running -- same qualitative result
//   (empty at exactly 0, immediate substantial jump at any positive
//   offset) in both placements, ruling out a box-placement artifact.
//   NEITHER finding fixed this round -- still isolation-only per the
//   prior prompt's explicit scope; this session adds PRECISION (a real,
//   CGAL-confirmed 0.000mm measurement) to what was previously an
//   arithmetic-derived claim, nothing more. Diagnostic test scripts lived
//   in the scratchpad only, never in this committed file; the two
//   specific diagnostic CALLS are not present here, only the reusable
//   clearance_zone_map() module definition, per TASK 5's explicit
//   instruction.
//
// Changes from v51 (vm01-v52-acrylic-fix-side-shell-collision-isolation —
// TASK 1 real fix, TASK 2 diagnosis-only):
//   TASK 1 (double-layer acrylic regression): investigated the ACTUAL v51
//     geometry in full before assuming the hypothesis -- found NO
//     duplicate/sibling piece: the old top metal cap (v48 TASK 3b item d)
//     was cleanly deleted with zero residual code (grepped for a second
//     `#ADD8E6` object inside left_zone_door() -- none exists; the file's
//     only OTHER `#ADD8E6` object, left_front_acrylic(), is confirmed dead
//     code, never called in ASSEMBLY). What WAS found: v51's shrunk window
//     cutout landed its upper bound at EXACTLY `acrylic_top_limit_z` -- the
//     SAME Z value as the acrylic piece's own top -- with NO epsilon
//     overlap. The deleted cap always started ITS OWN fill at
//     `acrylic_top_limit_z - e` specifically for a real e-deep shared
//     volume with the acrylic (Rule M-1); v51's leaf-based replacement
//     dropped that nudge, leaving the leaf's resumed solid and the
//     acrylic's own top meeting at an exact zero-clearance plane --
//     arithmetic-confirmed both at world Z=682.99mm exactly. This
//     coincident-face condition is the established root cause class (per
//     this file's own repeated Rule M-1 usage) of seam/z-fighting render
//     artifacts, the most plausible explanation for what reads visually as
//     a "double layer." Fixed: cutout's upper bound nudged to
//     `acrylic_top_limit_z - e`, restoring the exact epsilon convention the
//     deleted cap always used at this boundary. No OpenSCAD binary this
//     session -- verified via arithmetic (exact Z-value comparison), not a
//     live render; Janis F6 re-check still required to confirm the visual
//     artifact is gone.
//   TASK 2 (isolation only, NOT fixed -- door_open_deg=0/closed):
//     no OpenSCAD binary available this session -- fell back to precise
//     coordinate/arithmetic overlap checking (same standard as the v51
//     self-check), stated explicitly per the prompt's own instruction.
//     TOP: door_top_z (=DATUM_ROOFLINE-skin_t=698mm world) lands EXACTLY on
//     the shell's own interior ceiling (bottom face of the top skin, also
//     698mm world, arithmetic-confirmed zero gap) -- an exact,
//     zero-clearance touching plane with NO epsilon buffer, unlike nearly
//     every other touching-face condition in this file. Responsible
//     sub-feature: `door_top_z`'s own definition vs. `outer_shell_debug()`'s
//     top-skin Z-range -- not tray_zone_frame() (already ruled out by
//     Janis), not the door leaf's shape itself.
//     LEFT: the v50 TASK 4 hinge-pivot reinforcement cylinder (diameter
//     hinge_od=12mm, centered world X=-6/Y=25) reaches EXACTLY to world
//     X=0 at its tangent edge -- arithmetic-confirmed EXACTLY coincident
//     with the shell's own flat exterior-wall plane at that Y (Y=25 is
//     past corner_r=20's curve, so the shell's true exterior boundary there
//     is the flat wall at X=0). Responsible sub-feature: the hinge-pivot
//     cylinder specifically (NOT the left-wall recess pocket or the v50
//     corner-pole cutout -- both independently confirmed, via arithmetic,
//     to already fully and correctly clear the door's return-flange
//     footprint with zero gap, Y -1..25 continuous coverage).
//     Both findings trace to the SAME underlying PATTERN (a design value
//     computed to align EXACTLY with a shell boundary, with no deliberate
//     epsilon buffer -- unlike every other touching-face condition in this
//     file) but are NOT the same physical feature -- top is `door_top_z`
//     vs. the roof skin; left is the hinge-pivot cylinder vs. the flat
//     exterior wall. Stated explicitly per the prompt's requirement, not
//     merged. RIGHT side confirmed clean: door_right_x=414mm vs. the right
//     wall interior face (total_w-skin_t=638mm) leaves 224mm clearance, no
//     proximity concern. NOT fixed this round -- isolation/reporting only,
//     per prompt scope; a fix (if warranted -- exact tangency may not even
//     be the true CGAL trigger, unconfirmed without a live render) is a
//     follow-up decision.
//
// Changes from v50 (vm01-shell-toggle-fix-and-hole-isolation — TASKS 1-2
// toggle-wiring, TASK 3 diagnosis-only, TASK 4 real fix):
//   TASK 1: show_shell_top was already wired to a real cutout inside
//     outer_shell_debug() (`if (!show_shell_top) ... cube(...)`), NOT an
//     orphaned/dead variable as the hypothesis suggested -- CONFIRMED via
//     direct read + arithmetic, not assumed. The real cause: the cutout's
//     Z-position used the WORLD constant `total_h` (700) as its reference,
//     but this module builds its own shell locally at `shell_h` (=
//     total_h-leg_h=650) and is only translated by leg_h in ASSEMBLY --
//     the same double-counting bug class v39 fixed for the two
//     rounded_box() calls, but this toggle cutout (added later, after that
//     v39 fix) was never updated to match. `total_h-skin_t-1`=697 (local)
//     sits entirely ABOVE the module's own local Z range (0-650) -- the
//     cube was always cutting empty space above the real shell, never the
//     actual top skin (local 648-650). Fixed: reference `shell_h` instead
//     of `total_h`, matching the local-frame convention already used
//     everywhere else in this module.
//   TASK 2: `show_shell_bottom` added, same declaration/comment convention
//     as show_shell_top ("set false for C2 export"), wired to a new cutout
//     in outer_shell_debug() removing ONLY the bottom skin (local Z -1..
//     skin_t+1, mirrors the left/right panels' own -1-start convention),
//     independent of the top/back/left/right toggles.
//   TASK 3 (ISOLATION ONLY, per prompt -- NOT fixed this round): traced the
//     bottom-left-corner hole to the v50 TASK 1 corner-pole cutout in
//     outer_shell()/outer_shell_debug() -- its Z-range starts at LOCAL Z=0
//     (door_bot_z-leg_h), the SAME local range as the shell's own bottom
//     skin (local Z 0-skin_t=0-2) -- confirmed via arithmetic this is a
//     full overlap, i.e. the cutout punches a real hole straight through
//     the floor plate at this corner (world Z50-52, X/Y -1..21), not just
//     the intended WALL material. The cutout's TOP end (local 648) lands
//     EXACTLY at the start of the top skin's own local range (648-650) --
//     a coincident boundary, zero overlap, so the roof skin is untouched --
//     this is the precise, confirmed reason the defect is a real opening
//     from below but only a visible "cut edge" (no opening) from above.
//     Present in BOTH door_open=true and door_open=false (the shell's own
//     static geometry, unrelated to the door leaf) -- NOT correlated with
//     the door-closed-only manifold warning. Same root cause/mechanism as
//     the already-flagged v50 "~5mm gap at Z50-55/693-698" note in
//     rules-dimensions.md -- treated as the same defect class (not two).
//     No separate committed record of an earlier "strange cut on bottom
//     left corner shell" QA finding pre-dating v50 was found in
//     cc_chat_log.md/rules-dimensions.md/prompts/archive/ (searched, not
//     assumed) -- stated explicitly per the prompt's own instruction not to
//     force an attribution. NOT patched/modified -- diagnosis only, see
//     cc_chat_log.md for the full write-up.
//   TASK 4 (real fix, root-caused by Janis): the door's top acrylic-zone
//     "metal cap" (v48 TASK 3b item (d), left_zone_door()) was confirmed
//     dependent on show_acrylic (it lived inside `if (show_acrylic) {...}`
//     alongside the acrylic pane itself) -- exactly matching Janis's own
//     observation that it vanishes when the acrylic is hidden, confirming
//     it was a cosmetic patch riding on the acrylic assembly, not
//     independent shell material. DELETED entirely. Root cause of the gap
//     it was patching: the leaf's own window/acrylic cutout extended all
//     the way to `win_z1` (693mm world) -- well past `acrylic_top_limit_z`
//     (682.99mm, where the acrylic itself already stops to clear
//     tray_zone_frame()'s top weld flange) -- leaving a 693-698mm-world
//     sliver of the leaf with NO material at all unless patched externally.
//     Fixed the same way the door's lower/flap zone already works (v49):
//     shrunk the cutout's own top bound from `win_z1` to
//     `acrylic_top_limit_z`, so the leaf's OWN continuous door_t skin
//     simply isn't cut there anymore -- real shell material fills the
//     space directly, no separate applied patch piece. BONUS (confirmed,
//     not assumed): this also ELIMINATES the fill-vs-frame overlap that
//     v49's cc_chat_log/PART_MANIFEST said was "entirely the unchanged top
//     cap's already-flagged residual" (~3757mm³, all from the cap's
//     ~1.01mm Y-depth overlap with the frame's front face) -- the leaf's
//     own Y-position (front_y..front_y+door_t) is the SAME already-proven
//     ~2mm-clear-of-frame band used everywhere else on the door, so this
//     specific collision is resolved. Whether this is the SAME bar Janis
//     suspects caused the door-close collision -- CONFIRMED YES for this
//     specific fill-vs-frame overlap (the numbers match exactly); the
//     SEPARATE, still-unresolved "frame trim/joggle line at the right body
//     edge" collision (v48 TASK 4 TODO, near outer_shell_debug()) is a
//     different, unrelated issue -- NOT claimed resolved by this fix.
//     No OpenSCAD binary in this sandbox this session -- verified via the
//     same arithmetic self-check method used in prior no-binary sessions
//     (exact Z-range/overlap arithmetic, not estimate), not a live CGAL
//     render. Janis F6 + CGAL manifold re-check still required.
//
// Changes from v49 (VM-01-corner-frame-redesign — left-front-corner
// rebuild: remove shell pole, rebuild frame to touch housing, clear
// spring-tray travel, reinforce door hinge pivot):
//   TASK 1: identified the "pole" -- the shell's own front-left ROUNDED
//     CORNER wall material (the curved wedge between the outer rounded_box
//     (r=corner_r) and the inner hollow rounded_box (r=corner_r-1), world
//     X/Y roughly 0-21/0-21) was NEVER actually removed by either existing
//     cutout: the "left product zone front" cutout only punches through
//     a FLAT wall starting at X=skin_t, and the "left-side-wall recess"
//     (v43) only punches a thin slot on the LEFT face (X -1..3). Neither
//     reaches into the CURVED transition between them -- that solid
//     curved wedge is the pole, confirmed colliding with the door leaf
//     (which occupies roughly the same footprint via its own return-
//     flange arc) once tray_zone_frame() is hidden. Removed entirely (not
//     inset/notched -- not practical in real sheet-metal forming) via a
//     new square cutout (X/Y -1..corner_r+2, full door height door_bot_z
//     ..door_top_z) in BOTH outer_shell()/outer_shell_debug(). Confirmed
//     via live OpenSCAD/CGAL render: shell remains a valid solid (same
//     single pre-existing manifold warning as v49, no new warning) -- this
//     is architecturally the SAME kind of aperture as the shell's existing
//     door/window/chute cutouts (closed by another part, not meant to be
//     watertight alone), not a broken manifold. FLAG: this also opens a
//     genuine ~5mm gap at the very top/bottom of the corner (Z 50-55 and
//     693-698, outside tray_zone_frame()'s own 55-693 envelope) where
//     NEITHER shell nor frame now has material -- noted, not resolved,
//     matches TASK 1(b)'s explicit permission to flag rather than force a
//     fix without Janis's input on how the corner should close up there.
//   TASK 2: tray_zone_frame() rebuilt -- frame_bar 20mm->8mm (both
//     verticals). LEFT vertical's curve grown from r=(corner_r-1)-
//     frame_inset=14mm (inset FROM the shell, floating with a gap) to
//     r=(corner_r-1)+e=19.01mm (reuses the SAME center as before,
//     world_arc_cx/cy=21,21 -- touches/overlaps the shell's own interior
//     wall by e, real contact not proximity). The curve's angle range is
//     no longer the full 180-270 span -- it now stops at the angle where
//     it reaches frame_y0 (DECOUPLED to a fixed 7mm, its own prior
//     already-verified value -- NOT re-derived from the bigger curve's own
//     endpoint, which would otherwise pull the crossbar/right-vertical's
//     shared Y-position down to ~2mm and re-collide them with the door's
//     own front panel; caught by re-verification, not assumed safe).
//     RIGHT vertical extended to touch compartment_divider() (world
//     X=product_w+e=416.01, real contact) instead of floating at the old
//     inset X1=409mm. Re-verified via live OpenSCAD/CGAL render across the
//     full door_open_deg sweep (0-100, 9-angle + fine 0.5 sweep): ZERO
//     overlap, both bars, at the new dimensions -- the old proof did not
//     carry over automatically, confirmed fresh.
//   TASK 3: Janis's instruction was to widen total_w/product_w for full
//     spring-tray clearance -- LIVE geometry check found this WOULD NOT
//     WORK, on TWO separate counts, both confirmed via live sweep/algebra
//     not assumed: (1) neither the left vertical's position (derived from
//     skin_t/corner_r only) nor either spring lane's absolute X position
//     (derived from spring_od/spring_gap/tray_wall_t + a hardcoded tray
//     offset, never from product_w) depends on total_w/product_w at all.
//     (2) the tray BOX's own right wall (not just the spring lanes) also
//     needs clearance from the new right vertical -- and that wall's
//     position (tray_x_inset + tray_w, where the old tray_w was
//     product_w-20) and the right vertical's own touch point
//     (product_w+e-frame_bar) both move together as product_w changes,
//     so the GAP between them is independent of product_w too -- widening
//     it can never open daylight between a wall and a touch-point that
//     both scale identically. total_w/product_w are therefore UNCHANGED
//     (0mm increase). The ACTUAL fix, two parts: promoted the tray's own
//     hardcoded X-inset (bare "10" in both spring_tray() and tray_rack())
//     to `tray_x_inset`=17mm -- the minimum value giving the box's LEFT
//     wall (and lane 0) a real 2mm clearance from the left vertical's max
//     reach (15mm); AND replaced the tray's own fixed-width formula
//     (`product_w-20`, both modules) with `tray_w_global`, sized so the
//     box's RIGHT wall gets the SAME real 2mm clearance from the right
//     vertical's own touch point, instead of assuming a symmetric 10mm
//     margin that no longer holds once the right vertical touches the
//     divider. Confirmed via a fine tray_out_pct sweep (0-1.0) -- ZERO
//     overlap, both walls and both outermost lanes, at every position.
//     A first attempt (tray_x_inset=14, tray_w unchanged) passed a
//     lanes-only check but was caught by a WIDER re-check (the tray box's
//     own walls, not just the springs) still colliding both verticals --
//     not silently accepted as "good enough," re-derived properly.
//     FLAG: this deviates from the prompt's literal "widen total_w/
//     product_w" instruction -- stated explicitly rather than forcing an
//     ineffective total_w change to check a box.
//   TASK 4: new hinge-pivot reinforcement -- a solid cylinder (diameter=
//     hinge_od=12mm, reused not invented) at the door's own LOCAL origin
//     (0,0), full door_h height, inside left_zone_door()'s existing
//     translate/rotate block (so it rotates WITH the door, "from the
//     door's side"). Sits exactly ON the rotation axis, so it is angle-
//     invariant in world space -- confirmed clear at one angle means clear
//     at all angles, verified via live CGAL render at 0/50/100 degrees.
//   Two v49-flagged open items carried forward, untouched, restated for
//   the record (not fixed this round, out of scope): acrylic/metal-vs-
//   frame fill overlap (was 22091mm^3 v48->3757mm^3 v49; re-measured this
//   round against the REBUILT frame, see cc_chat_log for the new number);
//   the new partition/exit-wall-weld protrusion past the shell's left wall
//   (screenshots from this session, explicitly NOT investigated here).
//
// Changes from v48 (VM-01-door-flap-acrylic-fix — standalone, ran against
// the live v48 frame geometry; the separate corner/frame/shell-width
// redesign prompt (VM-01-corner-frame-redesign.md) has NOT landed as of
// this version -- explicitly deferred to a later session per Janis, do
// NOT assume it's included here):
//   TASK 1: the lower flap-zone metal was built as a SEPARATELY-MOUNTED
//     sheet behind the leaf (same "applied sheet" pattern as the acrylic)
//     -- stacking with the leaf's own door_t skin gave a real front-to-
//     back thickness of door_t+door_t=6mm in that zone, not the single
//     door_t=3mm every other part of the door uses. Fixed: that separate
//     metal panel piece DELETED entirely. The window hole cut into the
//     leaf now only spans the ACRYLIC zone (from split_z_local up, not
//     win_z0) -- everything below split_z_local is simply the leaf's OWN
//     continuous door_t skin, same construction as the rest of the door,
//     with only the flap's own opening cut directly into it (unchanged
//     cutout, already independent of the window hole). Before/after
//     thickness: 6mm (door_t+door_t) -> 3mm (door_t only). Side effect
//     caught by re-verification, not assumed: the flap's own cutout in
//     the leaf had never needed to cover the flap's full SWEPT volume
//     before (the bigger window hole masked this) -- now extended to
//     flap_top_z+flap_t+e (183.01mm local) so the flap still opens
//     0-55° with zero collision against the newly-solid leaf material
//     just above its old, closed-position-only hole.
//   TASK 2: acrylic's mounting overshoot (previously win_x0-acrylic_border
//     .. win_x1+acrylic_border, reaching INTO tray_zone_frame()'s left/
//     right verticals -- the entire source of v48's flagged fill-vs-frame
//     volume regression) removed on LEFT/RIGHT -- acrylic pulled in to
//     win_x0+2+e .. win_x1-2-e (the project's own existing 2mm Global
//     Clearance Tolerance convention, not a new number, +e off the
//     vertical's own flat inner face). The vacated 2mm strips become
//     visible plain-metal borders (2 new pieces, door_t depth, spanning
//     the acrylic's own Z-range). TOP boundary (v48's acrylic_top_limit_z,
//     682.99mm) re-verified against the SAME live frame (unchanged, no
//     v49-frame-redesign has landed) -- still correct, restated not
//     recomputed from scratch. Window opening itself (window_x0/z0/w/h)
//     UNCHANGED throughout -- confirmed distinct from the acrylic's own
//     mounting border in the live code (not the same thing), so no flag
//     needed on that specific ambiguity. The metal TOP CAP piece (v48
//     TASK 3b) and its own already-flagged residual overlap are UNCHANGED
//     by this prompt -- out of THIS prompt's literal "the acrylic" scope.
//   Re-verified via an actual OpenSCAD/CGAL render this session (binary
//   still installed): flap sweep 0-55° vs the rebuilt continuous skin --
//   empty; acrylic (new X-range) vs tray_zone_frame() -- empty.
//
// Changes from v47 (VM-01-left-door-v47-fixes — 4 QA findings from Janis's
// own F5/F6 pass, all on the LEFT door assembly; known 2-manifold warning
// explicitly DEFERRED by Janis, untouched):
//   TASK 1: sensor_strip()'s front (Y) edge was never updated when
//     drop_zone_guards() got its door-clearance fix in v47 -- still poked
//     through the closed door. First attempt (reusing drop_zone_guards()'s
//     exact fix, world_arc_cy+e=21.01mm) checked against live geometry
//     (Python/shapely) and found INSUFFICIENT for the LEFT strip: its X
//     range (2.01-7.01mm) overlaps the door's hinge-line flange face
//     (world X 2-5mm), which reaches up to world Y=HINGE_Y_OFFSET(25mm)
//     there -- drop_zone_guards()'s own left guard sits clear of this X
//     range (X=5.01mm), which is why 21.01mm worked THERE but not here.
//     Fixed: HINGE_Y_OFFSET+e (25.01mm, an EXISTING constant, not new) --
//     confirmed the door polygon's global max Y at ANY X, so it clears
//     the leaf everywhere. Re-verified: 9-angle + fine 0.5° sweep, ZERO
//     overlap, both strips.
//   TASK 2: tray_compartment_partition()'s v47 pullback to Y=526mm (the
//     spring's own rearward extent) left the vacated tray-0 compartment
//     (world Y 21-526mm) with NO floor at all -- Janis confirmed via
//     render this must be a fully sealed compartment. Fixed: front edge
//     restored to drop_zone_d (138mm, the SAME constant
//     exit_compartment_wall() already uses for its own position) for real
//     contact (2mm genuine shared volume with that wall, not a touching
//     face). Checked against tray_zone_frame()'s REAL footprint (crossbar
//     + both verticals) at this Z-plane (270-275mm) -- max Y = 21mm
//     (computed live), 117mm clear of 138mm -- confirmed EMPTY, not a
//     blanket margin, no notch/difference() construction needed.
//   TASK 3 (left_zone_door() acrylic/metal split, v46 area):
//     3a: new door_acrylic_t=5mm constant (real acrylic sheet thickness)
//       applied ONLY to the acrylic piece's Y-depth. Metal panel unchanged
//       at door_t(3mm). door_t itself untouched (still used elsewhere).
//     3b: acrylic's top boundary (was win_z1+acrylic_border=698mm, the
//       door's own absolute top edge, zero clearance) pulled down to
//       clear tray_zone_frame()'s v46 top weld flange (world Z 683-693mm,
//       the ONLY frame material in the window's clear central X zone near
//       the door's own top). LIVE geometry check, verified via an actual
//       OpenSCAD/CGAL render in this session (not Python estimate): real
//       5mm acrylic mounted at its standard depth reaches world Y=10.01mm,
//       3.01mm past the flange's own front face (Y=7mm, frame_y0) --
//       confirmed collision. New acrylic top =
//       (door_top_z-frame_inset-FLANGE_T)-e = 682.99mm (reuses
//       tray_zone_frame()'s own named constants, now promoted to
//       PARAMETERS so both modules read the same source, never each
//       other's local vars) -- new top border = 15.01mm (was 5mm). A new
//       metal-only cap piece (door_t depth) fills 682.99-698mm instead.
//       FLAG (CGAL-measured, not fixed this round): isolating JUST the
//       acrylic+metal fill assembly (leaf/hinge-marks/flap excluded) and
//       intersecting with tray_zone_frame() gives 17412mm³ overlap on the
//       v47 baseline (PRE-EXISTING -- the fill's acrylic_border mounting
//       overlap onto the verticals at X 22-27/389-394, present at every Z
//       the fill occupies) vs 22091mm³ on this v48 fill (+4679mm³) -- the
//       INCREASE is entirely 3a's real 5mm acrylic depth extending that
//       SAME pre-existing edge condition 2mm deeper across the acrylic's
//       ~313mm height. 3b's fix removes the TOP-flange-specific overlap
//       (the thing Janis explicitly flagged) but does not touch this
//       separate, longstanding left/right mounting-edge condition -- not
//       in this round's scope (would need acrylic_border/mounting-depth
//       redesign, a Janis decision), flagged with real numbers rather
//       than silently letting it grow unmentioned.
//     3c: exit flap's full swept volume (0-55°, Python/shapely) found to
//       overlap the metal panel below by up to ~451mm² -- the fill was a
//       solid slab with no hole cut for the flap's own operating volume
//       (Janis: "the hidden acrylic paste on back blocking the flap
//       door"). Fixed: difference() notch cut from the metal panel,
//       X matching the leaf's own flap cutout exactly (flap doesn't move
//       in X), Z from exit_bot_local to flap_top_z+flap_t+e (analytic
//       bound on the free corner's own rotation radius, confirmed ≥ the
//       live-swept max). Re-verified: ZERO overlap across the full sweep.
//     3d: flap plane check -- flap's own Y-range (front_y..front_y+flap_t)
//       already exactly matches the door's structural panel plane
//       (front_y..front_y+door_t, flap_t==door_t numerically) -- CONFIRMED
//       already true, no additional inner-frame-style offset present,
//       zero change needed.
//   TASK 4: second door-closed collision (shell trim/joggle line, right
//     body edge) -- searched outer_shell_debug()/outer_shell() in full:
//     no existing sub-feature matches "a top sub-piece AND a bottom
//     sub-piece" distinct from tray_zone_frame()'s own (already
//     show_frame-toggled) v46 weld flanges, which Janis explicitly says
//     is NOT the cause. NOT force-fitting a guess -- FLAGGED in
//     cc_chat_log/PART_MANIFEST as genuinely unresolved; no toggle added.
//     See TODO comment near outer_shell_debug() below.
//
// Changes from v46 (VM-01-partition-depth-door-collision-fix — 2 confirmed
// manifold problems, Janis root-caused both, no diagnosis needed):
//   PROBLEM 1: tray_compartment_partition() (v46) reached all the way to
//     the front of the compartment, physically overlapping
//     tray_zone_frame() -- present regardless of door state (2 fixed
//     parts). Functional requirement, not just clearance: the partition
//     must stop short of the front so a dropped item keeps falling
//     through the compartment's front opening instead of landing on top
//     of the partition and getting stuck. Fixed: partition's front (Y)
//     edge moved from skin_t (2mm) to tray_start_d + (tray_d-motor_d-2)
//     (526mm world) -- the SAME expression spring_coil() already uses for
//     its own rearward extent (effectively spring_l-2), not a new magic
//     number. Rear edge (598mm) unchanged. This leaves the spring's own
//     operative/product-drop length (world Y 138-526) entirely open, and
//     the region actually needing the partition (526-598, under the motor
//     /rear structure) covered. Re-verified: intersection() vs
//     tray_zone_frame() now empty by construction (505mm gap).
//   PROBLEM 2: drop_zone_guards() (v43) poked through the door's own
//     surface plane at closed position (door_open_deg=0) -- confirmed by
//     Janis via direct visual render inspection, root cause not the hinge
//     geometry or frame inset. Janis's suggested formula ("frame's front
//     face minus material thickness") and explicit flat-10mm fallback
//     were BOTH checked against live geometry (Python/shapely) and BOTH
//     found insufficient -- the hinge-side guard sits close enough to the
//     door's curved flange (which reaches up to world Y=21 there) that
//     10mm of pullback still left a confirmed 7.6mm² overlap at
//     door_open_deg=0. Verified fix instead: guard's front-most Y raised
//     to world_arc_cy+e (21.01mm) -- the SAME shell-interior-corner-curve
//     constant already used identically by both left_zone_door() and
//     tray_zone_frame() (skin_t+(corner_r-1)), not a new invented number.
//     Confirmed empty at all 9 mandated angles + a fine 0.5° sweep.
//   tray_zone_frame(), hinge geometry, and the shell's hinge recess cutout
//     confirmed UNTOUCHED (not the cause of either problem).
//
// NAMING NOTE: prompts/VM-01-tray-access-acrylic-split-flange-v45.md said
// "save as VM-01-base-v45.scad" -- that name was already taken (the prior
// governance-batch prompt shipped v45 first, merged before this prompt was
// uploaded). Built on the REAL latest file (v45, = v44 + show_frame
// toggle, zero geometry change) and saved as v46 instead, per "never
// overwrite, always increment version." Flagged explicitly, not silently
// resolved -- see cc_chat_log.md.
//
// Changes from v45 (VM-01-tray-access-acrylic-split-flange — 3 fixes):
//   TASK 1 (tray compartment access gap): entire spring tray stack shifted
//     UP 100mm (TRAY_SHIFT_UP) from tray_0_z (270, UNCHANGED baseline) to
//     tray_stack_z0 (370) -- spring_tray()/tray_rack() now reference
//     tray_stack_z0, not tray_0_z. Only tray_count=2 exists in source (no
//     3-row/"3x5" variant to shift separately -- confirmed, not guessed).
//     New tray_compartment_partition() (fixed/welded, full compartment
//     width+depth) seals the vacated space at the OLD tray_0_z=270
//     baseline -- the anchor the trays moved away from. New
//     exit_compartment_wall() (NEW module -- no existing module literally
//     matched "vertical partition/side bracket that holds the flap
//     stopper", see cc_chat_log for reasoning) seals the Y-direction
//     reach-through at Y=drop_zone_d, floor to the partition, zero gap
//     (e-overlap). Top-tray clearance vs the physical roofline/door
//     boundary: +86/+88mm, positive. vs the OLD (untouched) DATUM_TRAY_TOP
//     tray-zone/upper-display divide (512mm, tautologically defined as
//     tray_0_z+tray_zone_h, itself never an independent physical ceiling):
//     -100mm -- flagged explicitly as a stale zone-label question for
//     Claude Web/Janis, NOT a real 3D collision (nothing physical occupies
//     that Z range on the left side).
//   TASK 2 (acrylic/metal split): door's single acrylic pane split into an
//     upper acrylic portion (unchanged top boundary) and a lower plain
//     metal panel, meeting at a LIVE reference to tray_stack_z0 (not a
//     duplicated magic number) -- the post-shift lowest-tray-floor Z.
//     Both pieces share the existing show_acrylic gate (v44 Finding B fix
//     untouched).
//   TASK 3 (H-frame flange): tray_zone_frame() gets 10mm top + 10mm bottom
//     flanges for spot-welding to the shell -- built from the SAME 2D
//     cross-section as the already-verified crossbar, placed WITHIN the
//     frame's existing (already door-clearance-verified) Z range, so no
//     new Z-boundary risk.
//   TASK 4: full 9-angle CGAL-equivalent collision sweep (Python/shapely)
//     re-run against the updated frame (incl. flanges) -- ALL EMPTY, plus
//     a fine 0.5° sweep, worst-case area 0.0.
//   DO NOT TOUCH (v44 QA-passed work, confirmed unchanged): sensor
//     deletion, acrylic render_mode toggle logic, H-frame curved/inset
//     left edge, door window resize, hinge datum logic.
//
// Changes from v44 (VM-01-governance-batch-post-v44 — TASK 3, toggle-wiring
// only, ZERO geometry change): added `show_frame` isolation toggle,
// gating tray_zone_frame() in ASSEMBLY — v44 shipped the H-frame rebuild
// with no toggle at all, the exact gap that let the old wrong-referenced
// frame go unnoticed for ~10 versions (new Toggle-Completeness Rule,
// cc_rules.md). Frame's shape/position/curve/dimensions untouched.
//
// Changes from v43 (VM-01-frame-window-rebuild-v44 — real-render QA, 6 findings):
//   Finding A: sensor_strip() had a fabricated red center-beam cube
//     spanning the gap between its 2 real strips -- Janis-confirmed never
//     part of the actual design. DELETED entirely (not toggled). New
//     `show_sensor` isolation toggle gates the 2 real strips.
//   Finding B: left_zone_door()'s acrylic pane was gated on
//     `render_mode=="full" && show_acrylic` -- inconsistent with its
//     siblings (show_door/show_flap aren't render_mode-gated), and since
//     render_mode defaults to "standard" the acrylic could never render
//     regardless of show_acrylic. Now gated on `show_acrylic` alone.
//     acrylic_display() (right compartment, unrelated part) untouched.
//   Finding C: tray_zone_frame() anchored every bar at world X=0/Y=0 (the
//     shell's theoretical SHARP EXTERIOR corner), never accounting for
//     skin_t/corner_r -- visually sat at/outside the shell's real interior
//     wall. SEPARATELY confirmed via CGAL boolean intersection (9-angle
//     sweep vs left_zone_door()): the old frame's bars physically clipped
//     the door leaf for door_open_deg 0-30. Full rebuild, H-shape (2
//     full-height verticals + 1 crossbar at tray_0_z, replaces the old
//     top+bottom+short-side-bar layout), repositioned off the shell's real
//     interior corner curve (same formula as left_zone_door()'s
//     arc_cx/arc_cy), left vertical's outer edge curved to match the
//     door's own flange arc (same center/radius, pulled back by the same
//     5mm inset for door clearance). Re-verified (Python/shapely, mirrors
//     the CGAL test) at all 9 mandated angles + a fine 0.5° sweep: ZERO
//     collision across the full 0-100° door_open_deg range.
//   Window/acrylic (Janis spec): resized to match the new H-frame's inner
//     clear opening -- window_x0/window_z0/window_w/window_h updated (was
//     the old tray-zone-only slice), acrylic resizes automatically via the
//     same formula (unchanged), giving a full view of the whole
//     compartment. Superseded v43 frozen values kept in rules-dimensions.md
//     for history.
//   Door-scoped Skeleton exception (v43) extended to cover this round's
//     tray_zone_frame() rebuild too -- still no other BOM item touched.
//
// Changes from v42 (VM-01-door-datum-rebuild-v43 — FRONT DOOR ASSEMBLY ONLY):
// GOVERNANCE NOTE: .claude/SKILL_product_design_skeleton.md grandfathers
// VM-01 out of the new Skeleton/Datum-Reference-Frame system. This is a
// Janis-approved, door-scoped EXCEPTION to that clause — the corrected
// datum logic below applies to the front door assembly only (left_zone_door,
// its shell recess pocket, drop_zone_visual). No other BOM item touched.
//   1. FOOT_BASE_H added as its own explicit named constant (was silently
//      folded into DATUM_LEG_TOP = leg_h) — door's Z-stack now shows it as
//      an explicit added term (door_bot_z = FOOT_BASE_H + 0).
//   2. Hinge center is now THE datum for the entire door assembly, world
//      coords: Z = FOOT_BASE_H + 0; Y = HINGE_Y_OFFSET (25mm, fixed
//      independent constant, measured from the shell's theoretical SHARP
//      corner — NOT corner_r+5 anymore, decoupled so retuning corner_r
//      later is a separate clearance check, not an input); X = 0 -
//      (hinge_od/2) — barrel exposed on the exterior, proud of the shell's
//      exterior wall face. left_zone_door() and outer_shell()/
//      outer_shell_debug()'s recess-pocket cutout each independently
//      re-derive this SAME point from shared named constants
//      (HINGE_Y_OFFSET/hinge_od/FOOT_BASE_H) — neither reads the other's
//      local variables. See commit message for the side-by-side numbers.
//   3. Window/acrylic frozen as the door's OWN local constants
//      (window_x0=38/window_z0=220/window_w=336/window_h=242) — numerically
//      identical to v42's DATUM_TRAY_BOT/TOP-derived values, but no longer
//      named/derived as if the window depended on the tray zone (Cousin
//      reference removed; the window is the door's own feature).
//   4. Curved flange: the flange/trim polygon's hard 90° bend replaced with
//      a 12-segment arc following the shell's actual rounded corner,
//      derived live from corner_r/skin_t (same center/radius as the shell's
//      own interior corner curve: center (skin_t+(corner_r-1), skin_t+
//      (corner_r-1)), radius corner_r-1).
//   5. Epsilon fixes (e=0.01) on 3 confirmed flush-coplanar-face root
//      causes: left_zone_door() front face (was flush at world Y=skin_t),
//      sensor_strip() both strips (were flush at X=skin_t), drop_zone_
//      guards() (new module, see #6).
//   6. drop_zone_visual() replaced by drop_zone_guards(): the 4 ghost faces
//      that blocked the actual product drop path (top/bottom/front/back)
//      removed entirely; the 2 side faces (genuine hand-access safety
//      guard) kept and rebuilt as solid 2mm panels, not translucent. Left
//      guard placed clear of the door's new hinge/flange footprint
//      (X 2-5mm, Y 2-25mm) — see contact-receipt comment at the module.
//   DEFERRED (Janis, not built this round): partition + back door for
//   spare storage under the trays — TODO comment added near spring_tray()/
//   tray_rack(), no geometry added.
//
// Changes from v41 (VM-01-door-fixes-v42 — 6 issues from Janis's v41 QA):
//   1. left_zone_door() rebuilt: the return flange + main panel were two
//      disconnected cubes (20mm gap, X 5-25) — replaced with ONE
//      linear_extrude() of a single bent L-shaped polygon. True single-
//      piece manifold solid, no seam/gap possible.
//   2. New left-side-wall recess cutout in outer_shell_debug()/outer_shell()
//      so the return flange/hinge line has a real pocket to sit in.
//   3. Stopper rod moved OUT of left_zone_door()'s door_open rotation into
//      its own static module, flap_stopper_rod() — a stop that swings with
//      the thing it's stopping isn't a stop. Acrylic pane correctly stays
//      inside the rotation (it should move with the door).
//   4. New isolation toggles: show_door, show_acrylic, show_flap.
//   5. Acrylic/window framing asymmetry was a side effect of issue #1, not a
//      separate acrylic-sizing bug — resolved by Task 1 alone, acrylic
//      formula untouched.
//   6. DATUMS block added — tray_0_z and the door's window_z0/z1 were each
//      independently derived and had drifted apart (window floated way above
//      the actual trays). Single source of truth now: DATUM_LEG_TOP/
//      DATUM_FLAP_TOP/DATUM_TRAY_BOT/DATUM_TRAY_TOP/DATUM_ROOFLINE. Also
//      applied left_zone_door()'s own LOCAL origin (hinge line at floor) per
//      .claude/SKILL_reference_point_first.md — the whole leaf places with
//      ONE translate(), door_open is a plain rotate() about that same origin.
//      spring_tray()/tray_rack() also fixed to reference tray_0_z directly
//      instead of re-deriving leg_h+exit_door_h locally (same bug class,
//      not explicitly named in the v42 prompt but required for the datum
//      fix to actually move the physical trays).
//   Janis-approved 2026-07-05: tray zone position is not independently
//   locked — real constraint is the door/flap staying close to the floor
//   for customer access, which the flap's own datum chain already
//   guarantees. See rules-dimensions.md/rules-codes.md zone-stack supersession.
//
// Changes from v40:
//   front_door()+flap_door()+spring_zone_panel() DELETED, replaced by one
//   new module left_zone_door(): full-height (50-698mm) left-zone door
//   with a concealed hinge on the flat left-side wall (off the rounded
//   front-left corner, via a return flange), an inset acrylic viewing
//   window, and a top-hinged 300x150mm exit flap that swings inward to a
//   static stopper rod. New viewer/export toggles: door_open, flap_open,
//   tray_out_pct (wired into spring_tray()'s Y offset). See TASK 1/2 below.
//
// Changes from v39:
//   outer_shell_debug() built its own rounded_box() using the full total_h
//   (700) as its own extrusion height, while ASSEMBLY also translates it
//   by +leg_h (50) — double-counting leg height so the shell's real world
//   Z range was 50-750, not the intended 50-700. Fixed: module now uses a
//   local shell_h = total_h - leg_h for both rounded_box() calls. See
//   TASK 1 below. outer_shell() (unused, non-debug twin) already had this
//   fix from v14 — outer_shell_debug() never received it.
//
// Changes from v38:
//   acrylic_display() right-side panel recessed to corner_r on both Y ends
//   (was skin_t) — fixes 7.28mm protrusion past the shell's curved corner
//   wall at the front-right (and rear-right) corner. See TASK 1 below.
//
// Changes from v37:
//   Three render_mode options for STL exports:
//     render_mode = "standard" → STANDARD VIEW: full shell + all internals, acrylic panels removed
//                                Shows interior through open window (same as transparent acrylic)
//                                Export as: VM-01-v42-std.stl
//
//     render_mode = "full"     → FULL EXTERIOR: everything including acrylic panels (fully opaque)
//                                Export as: VM-01-v42-full.stl
//
//     render_mode = "open"     → OPEN SHELL (C2): set show_shell_top/left = false below for inspection
//                                Export as: VM-01-v42-C2.stl
//
//   Workflow: set render_mode → set debug toggles if needed → F6 → File > Export > STL

$fn = 64;

// ─────────────────────────────
// PARAMETERS
// ─────────────────────────────

total_w = 640;
total_h = 700;
total_d = 600;
corner_r = 20;
skin_t = 2;

// Epsilon — prevents z-fighting on coincident front faces. MOVED HERE
// (v55, vm01-v55-door-floor-datum-fix) from its old spot further down the
// PARAMETERS block -- door_bot_z (below) now needs it in its OWN top-level
// formula, and OpenSCAD's top-level assignment resolution does NOT support
// a forward reference to a variable declared later in the same file
// (confirmed via a live "Ignoring unknown variable 'e'" warning when first
// attempted at the old declaration order) -- unlike a global referenced
// INSIDE a module body, which resolves at call time after the whole file
// is parsed. Moved above every consumer instead of duplicating the literal.
e = 0.01;

// Legs
leg_h = 50;
leg_od = 25;
leg_inset = 40;

// §2.1 (v43) -- explicit foot/leg-height term. DATUM_LEG_TOP used to be
// `= leg_h` directly, silently absorbing this 50mm into a datum LABEL —
// any part built on DATUM_LEG_TOP looked "floor-referenced" but was really
// one hidden addition away from true ground. FOOT_BASE_H makes that
// addition explicit; every ground-referenced Z-stack in the door assembly
// below shows it as `FOOT_BASE_H + <term>`, never folds it into a name.
FOOT_BASE_H = leg_h;   // 50mm

// Compartments
product_w = 416;
system_w = 204;    // screen board 180mm + bezel×2 + margin
divider_t = 19;

// Spring / Tray
spring_od = 66;
spring_l = 390;
motor_d = 60;
spring_gap = 13;    // OD-to-OD gap — OWNER-LOCKED (5mm clearance + 3mm partition + 5mm)
spring_lanes = 5;
tray_count = 2;
tray_floor_t = 5;
tray_wall_t = 3;
spring_clearance = 50;
tray_h = 121;           // floor(5) + spring_od(66) + clearance(50)
partition_h = 40;
tray_d = spring_l + motor_d;  // 450mm

// Tray zone -- true zone height only; Z-position now comes from DATUMS below
tray_zone_h = tray_h * tray_count;         // 242mm

// Zones
drop_zone_d = 138;
tray_start_d = drop_zone_d;

// Exit zone -- shell chute cutout + drop_zone_guards() only. No longer
// determines tray position (v42) -- see DATUMS block.
exit_door_w = 400;
exit_door_h = 250;

// Customer pickup flap — flap_w/flap_h superseded by exit_w/exit_h (v41, see below), flap_t still used
flap_t = 3;

// Tray rack
rail_w = 10;
rail_h = 10;
latch_pin_d = 8;
latch_pin_l = 10;   // 15 → 10: pin stays inside cavity, clears outer shell back face at 598mm

// Door / panel
door_t = 3;
hinge_od = 12;   // v41: also reused as left_zone_door()'s stopper-rod diameter

// v48 TASK 3a: real acrylic sheet thickness -- distinct from acrylic_t
// (above, the RIGHT-compartment acrylic_display() panel skin, unrelated
// part) -- applied ONLY to left_zone_door()'s acrylic fill piece.
door_acrylic_t = 5;

// Frame bars
// v50 TASK 2: reduced 20mm->8mm -- both verticals now extend by CURVE/
// touch-contact to reach the housing (shell corner / compartment_divider())
// instead of floating with a frame_inset gap, so less raw bar width is
// needed to still reach the door-clearance boundary. See tray_zone_frame().
frame_bar = 8;

// v48 TASK 3b: promoted from tray_zone_frame()'s own local scope to a
// shared PARAMETER -- left_zone_door()'s acrylic-vs-top-flange clearance
// calc needs the SAME values tray_zone_frame() uses for its border inset
// and weld-flange thickness, per this file's established "independently
// re-derive from shared named constants, never read another module's
// local variable" convention -- not a duplicated/guessed number.
frame_inset = 5;
FLANGE_T = 10;   // weld-flange thickness (Z), v46 TASK 3

// Left-zone front door (v41/v42/v43) — replaces front_door()+flap_door()+spring_zone_panel()
exit_w = 300;                          // supersedes old flap_w=250
exit_h = 150;                          // supersedes old flap_h=100

// §2.2 (v43) -- HINGE_Y_OFFSET is now a fixed, INDEPENDENT constant (was
// `corner_r + 5`). Measured from the shell's theoretical SHARP corner (the
// invisible intersection of the front-face plane and left-face plane,
// extended past corner_r's rounded fillet -- NOT the fillet's own center
// at (corner_r, corner_r)). Does not move if corner_r is retuned later for
// cosmetic reasons -- corner_r becomes a separate clearance check ("does
// 25mm still clear the curve"), never an input to this formula. Both
// left_zone_door() and the shell's recess-pocket cutout independently
// re-derive the hinge center from this same named constant -- see each
// module for its own local hinge_x/y/z computation.
HINGE_Y_OFFSET = 25;                   // 25mm

return_depth = HINGE_Y_OFFSET - skin_t;// 23mm -- flange depth, front face to hinge line (general-purpose, e.g. exit_x centering below; the shell's OWN recess-pocket cutout does NOT read this global -- it re-derives its own copy, see outer_shell()/outer_shell_debug())
door_left_x = skin_t;                  // 2mm -- door's own width envelope, left edge
door_right_x = product_w - skin_t;     // 414mm -- LEFT ZONE ONLY, not total_w
door_w = door_right_x - door_left_x;   // 412mm -- door's own true width
exit_x = door_left_x + ((door_right_x-door_left_x-return_depth) - exit_w)/2 + return_depth; // centered in door width
flap_open_deg = 55;                    // Janis-approved, was targeting "~60 or less"
door_open_deg = 100;                   // full-open angle for door_open viewer toggle
acrylic_border = 5;                    // overlap border, screw-in material
window_flap_gap = 40;                  // clearance above the flap opening
hinge_mark_h = 20;                     // hinge seam indicator mark height
hinge_mark_d = 1;                      // hinge seam indicator mark depth (Y), flush placeholder only

// §2.3 (v43)/v44 TASK 4 -- window/acrylic FROZEN as the door's OWN local
// constants. RESIZED 2026-07-05 (v44): now matches the new H-frame's inner
// clear opening (TASK 3) instead of the old tray-zone slice -- world X
// 27-389mm (between the frame's two verticals) and world Z 55-693mm
// (near-floor to near-roof, same frame envelope), giving a full view of
// the whole compartment. Superseded values (v43): window_x0=38/
// window_z0=220/window_w=336/window_h=242 (world Z 270-512mm).
window_x0 = 25;    // local X, door's local origin -> window left edge
window_z0 = 5;     // local Z, door's local origin -> window bottom edge
window_w  = 362;
window_h  = 638;

// ─────────────────────────────
// DATUMS (v42, FOOT_BASE_H term added v43 §2.1) — single source of truth
// for shared Z-reference planes. Every module below must reference ONE of
// these directly for any position shared with another module. Never derive
// a new "local" version of one of these values inside a module — reference
// the datum itself. Root cause this prevents: tray_0_z and the door's
// window_z0/z1 were each independently derived in v41 and drifted apart
// (window floated ~170mm above the actual trays). See .claude/rules-codes.md
// "Datum Rules" + .claude/SKILL_reference_point_first.md.
// ─────────────────────────────
DATUM_FLOOR    = 0;
DATUM_LEG_TOP  = FOOT_BASE_H;                        // 50 -- explicit foot-base term (§2.1), was silently `= leg_h`
DATUM_FLAP_TOP = DATUM_LEG_TOP + 30 + exit_h;        // 230 -- exit flap hinge line
DATUM_TRAY_BOT = DATUM_FLAP_TOP + window_flap_gap;   // 270 -- tray zone starts here
DATUM_TRAY_TOP = DATUM_TRAY_BOT + tray_zone_h;       // 512 -- 242mm of trays
DATUM_ROOFLINE = total_h;                            // 700 -- absolute top

// Zone stack — derived from DATUMS (was independently re-derived pre-v42;
// Janis-approved 2026-07-05: position isn't independently locked, the real
// constraint is the door/flap staying close to the floor for customer
// access, which DATUM_FLAP_TOP's own chain already guarantees).
tray_0_z        = DATUM_TRAY_BOT;                    // 270mm -- v46: kept UNCHANGED as the pre-shift baseline; tray_compartment_partition() anchors here (the point the trays moved away from). Do NOT use this for the trays' own live position -- see tray_stack_z0 below.
tray_zone_top_z = DATUM_TRAY_TOP;                    // 512mm -- v46: deliberately UNCHANGED (shell/right-compartment zone-stack datum, out of this prompt's scope) -- see tray_stack_z0 clearance note below for why this no longer equals the physical tray-stack top
upper_display_h = DATUM_ROOFLINE - tray_zone_top_z;  // 188mm
// v44: panel_zone_top_z/panel_zone_h deleted -- fully dead code, both only
// ever consumed by the old tray_zone_frame() (TASK 3 rebuild, see below),
// same "avoid dormant globals" precedent as v41's flap_w/flap_h/hinge_h removal.

// v46 TASK 1 -- tray compartment access gap fix. A hand could reach under
// the lowest spring tray into the tray compartment from the exit zone; no
// wall/floor blocked it. Fix: shift the entire tray stack UP, and seal the
// vacated space with a fixed partition (see tray_compartment_partition()/
// exit_compartment_wall() below). tray_0_z itself is NOT touched (stays
// the pre-shift anchor); spring_tray()/tray_rack() use tray_stack_z0.
TRAY_SHIFT_UP  = 100;                    // mm, Janis-approved
tray_stack_z0  = tray_0_z + TRAY_SHIFT_UP; // 370mm -- NEW lowest-tray-floor Z (live reference, spring_tray()/tray_rack()/door acrylic split all read this, not a duplicated number)

// v56 (vm01-v56-sensor-bracket-frame-joint-fix): sensor_strip()'s own Z,
// hoisted here as a SHARED datum -- was computed locally inside that
// module only (`strip_z = tray_stack_z0 - 20`). drop_zone_guards() now
// also needs this value (see FIX below) -- per this file's own lesson
// from the v55 manifold bug (a datum independently re-derived in 4 places
// drifted out of sync), this is declared ONCE here and read by both
// modules, not recomputed.
sensor_strip_z0 = tray_stack_z0 - 20;    // 350mm world
sensor_strip_h  = 8;                     // matches sensor_strip()'s own strip_h

// Mandatory clearance check (top tray vs the physical roofline/door
// boundary, only tray_count=2 exists in source -- no 3-row/"3x5" variant
// to check separately, confirmed via grep, not guessed):
//   top tray (index tray_count-1) floor  = tray_stack_z0 + (tray_count-1)*tray_h = 491mm
//   top tray ceiling                      = 491 + tray_h = 612mm
//   clearance vs door_top_z (698mm)       = 86mm  -- POSITIVE, confirmed
//   clearance vs DATUM_ROOFLINE (700mm)   = 88mm  -- POSITIVE, confirmed
// FLAG (not a 3D collision, no geometry silently changed to compensate):
// vs the UNCHANGED DATUM_TRAY_TOP (512mm) the shifted stack is -100mm
// "over" -- but DATUM_TRAY_TOP is tautologically defined as
// DATUM_TRAY_BOT+tray_zone_h (i.e. it only ever meant "wherever the
// unshifted stack's own top happens to be"), not an independent physical
// ceiling -- nothing else physically occupies world Z 512-612 on the left
// side. Whether the "upper display" zone LABEL should be redefined is a
// separate documentation question for Claude Web/Janis, out of this
// prompt's DO NOT TOUCH scope (shell/right-compartment datums untouched).

// Left-zone door Z range — from DATUMS
// v55 FIX (vm01-v55-door-floor-datum-fix): was `FOOT_BASE_H + 0` (50mm) --
// the shell's ABSOLUTE base (bottom of the floor SKIN itself, where the
// legs attach), not the interior floor SURFACE the door should actually
// rest on (FOOT_BASE_H + skin_t = 52mm, the top of that same skin, where
// the usable interior space begins). The old value buried the door's
// bottom 2mm INSIDE the shell's own floor slab across almost its entire
// footprint -- root-caused via a real CGAL intersection() this session
// (12 non-degenerate facets + a manifold warning between the full door
// and the full shell at door_open_deg=0, confirmed present since at least
// v53, likely the actual cause of the door-closed manifold warning long
// attributed to two other exact-tangency findings that a real 9-angle
// sweep now shows are NOT angle-dependent the way the reported symptom
// is). Fixed to `FOOT_BASE_H + skin_t - e` -- the interior floor surface,
// nudged e below it for a real (not degenerate) shared volume with the
// floor skin, matching this file's own Rule M-1 epsilon-nudge convention
// used everywhere else for exactly this "structural part meets a shell
// face" class of touch. Re-verified: full door-vs-shell intersection at
// door_open_deg=0 now `Simple: yes`, real (non-degenerate) volume, NO
// manifold warning; 9-angle sweep 0/20/25/30/35/40/45/70/100 all valid.
// SIDE EFFECT (confirmed, not just hoped for): this same constant also
// sets the v50 corner-pole cutout's own Z-start (both outer_shell()/
// outer_shell_debug(), see below) -- raising it by ~skin_t also lifts
// that cutout's bottom OFF the shell's floor skin, closing the
// bottom-left-corner floor hole isolated (not fixed) in an earlier
// session -- same root datum, confirmed via render, see cc_chat_log.md.
door_bot_z = FOOT_BASE_H + skin_t - e;   // 51.99mm -- was FOOT_BASE_H+0 (50mm)
door_top_z = DATUM_ROOFLINE - skin_t;    // 698mm
door_h     = door_top_z - door_bot_z;    // 646.01mm -- was 648mm, shared with the shell's left-wall recess cutout AND the corner-pole cutout (both re-derive door_bot_z/door_h independently, see below)
exit_bot_z = door_bot_z + 30;            // 81.99mm -- was 80mm, 30mm clearance off the (correct) interior floor surface

// Dashboard
dash_x = product_w + divider_t + skin_t;
dash_w = system_w - divider_t - (skin_t * 2);  // 204 - 19 - 4 = 181mm ✓
screen_w = 165;
screen_h = 100;
screen_center_z = 280;
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

// v50 TASK 3: tray's own X-inset -- was a bare hardcoded "10" in BOTH
// spring_tray() and tray_rack() (two places, same magic number). LIVE
// geometry check found widening total_w/product_w (as the corner-frame-
// redesign prompt's literal instruction said) has ZERO effect on the
// lane-0-vs-left-vertical collision (neither depends on total_w/
// product_w) -- the REAL fix is this inset. First attempt (14mm, giving
// lane 0 a real 2mm clearance) was caught by a WIDER re-check as
// insufficient: the TRAY'S OWN BOX (not just the spring lanes -- its
// side walls) also needs clearance from both verticals, and its RIGHT
// wall position depends on product_w the SAME way the right vertical's
// touch-point does (both move together, so widening product_w cannot
// open a gap between them either -- confirmed algebraically and via
// live render, not assumed). 17mm is the minimum value giving the box's
// LEFT wall a real 2mm clearance from the left vertical's max reach
// (15mm); tray_w (below, both modules) is now sized so the box's RIGHT
// wall gets the SAME real 2mm clearance from the right vertical's touch
// point, instead of the old fixed "product_w-20" formula. Was 10
// (uninset, hardcoded, unnamed) pre-v50.
tray_x_inset = 17;

// v50 TASK 3: tray width, derived from the SAME real 2mm clearance
// convention on the box's right wall vs the right vertical's own touch
// point (product_w+e-frame_bar, see tray_zone_frame()) -- was the fixed
// "product_w - 20" (assumed a symmetric 10mm margin each side, which no
// longer fits since the right vertical now touches the divider). Both
// spring_tray() and tray_rack() reference this instead of re-deriving
// their own copy.
tray_w_global = (product_w + e - frame_bar - 2) - tray_x_inset;  // 389.01mm, was tray_w=396mm (product_w-20)

// Acrylic display zone (upper right compartment)
acrylic_bot_z = tray_zone_top_z;               // 542mm
acrylic_top_z = total_h - skin_t;              // 698mm
acrylic_zone_h = acrylic_top_z - acrylic_bot_z; // 156mm
acrylic_r = 8;
acrylic_t = skin_t;

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

// v55 FIX (vm01-v55-door-floor-datum-fix): leg's own top (world Z=leg_h,
// unchanged) sits EXACTLY flush against the shell's floor skin's own
// bottom (also world Z=leg_h, since outer_shell_debug() is translated by
// leg_h in ASSEMBLY) -- the SAME "everything touches the floor at the
// exact same boundary" pattern the door had, confirmed via a real 3-way
// CGAL intersection() (door+shell+legs) this session, isolated after the
// door's own fix alone didn't clear the full-assembly warning. Fixed:
// height extended by e so the leg's top reaches e INTO the floor skin --
// a real (not degenerate) shared volume, this file's own Rule M-1
// convention, not a new pattern.
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

// TODO(Janis, deferred): partition + back door for spare storage under trays

// Motor at BACK. Spring front end at Y=0 (drop zone boundary). Products fall forward.
module spring_tray(tray_num) {
    tray_w = tray_w_global;  // v50 TASK 3: was product_w-20, see PARAMETERS for the new derivation
    z = tray_stack_z0 + (tray_num * tray_h);   // v46: reference tray_stack_z0 (shifted +100mm), not tray_0_z directly -- tray_0_z is now the fixed pre-shift anchor for tray_compartment_partition() only
    tray_y = tray_start_d - (tray_d * tray_out_pct);   // v41: slides toward the front opening

    // v50 TASK 3: was hardcoded "10" -- promoted to tray_x_inset (14mm),
    // see PARAMETERS. Live sweep across the full tray_out_pct range
    // confirmed lane 0's swept footprint clears tray_zone_frame()'s
    // rebuilt left vertical (real 2mm margin) at this value.
    translate([tray_x_inset, tray_y, z]) {
        // Single solid box with hollow subtracted — no union() T-junctions, always manifold
        color("#CCCCCC")
        difference() {
            // Outer solid box — full tray footprint
            cube([tray_w, tray_d, tray_h]);

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
        }

        // Springs + motors — motor at back, spring front at Y=0
        // All objects offset by e from tray body faces to prevent coplanar non-manifold
        for (i = [0:spring_lanes-1]) {
            x = tray_wall_t + spring_od/2 + i*(spring_od + spring_gap);

            // Motor: confirmed innocent by isolation test — restored
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
    tray_w = tray_w_global;  // v50 TASK 3: was product_w-20, see PARAMETERS for the new derivation
    color("#AAAAAA")
    for (t = [0:tray_count-1]) {
        z = tray_stack_z0 + (t * tray_h);   // v46: reference tray_stack_z0 (shifted +100mm), same fix as spring_tray()
        // v50 TASK 3: was hardcoded "10" (3 places) -- promoted to
        // tray_x_inset (14mm), matching spring_tray()'s own value so the
        // rails/latch stay aligned with the tray body.
        translate([tray_x_inset, tray_start_d, z - rail_h])
            cube([rail_w, tray_d, rail_h]);
        translate([tray_x_inset + tray_w - rail_w, tray_start_d, z - rail_h])
            cube([rail_w, tray_d, rail_h]);
        translate([tray_x_inset + tray_w/2, tray_start_d + tray_d - tray_wall_t, z + tray_h/2])
            rotate([-90, 0, 0])
                cylinder(d=latch_pin_d, h=latch_pin_l);
    }
}

// v46 TASK 1: fixed/welded horizontal panel sealing the space vacated by
// the 100mm tray-stack shift -- spans the FULL width of the tray/product
// compartment, NOT a removable/access panel. Positioned at the pre-shift
// tray_0_z (270mm) -- the anchor the trays moved away from, NOT the
// post-shift tray_stack_z0. Works together with exit_compartment_wall()
// (below) to fully close the reach-through path from the exit zone into
// the tray compartment.
//
// v48 TASK 2 fix: v47's pullback to Y=526mm (the spring's own rearward
// extent, to avoid overlapping tray_zone_frame()) left the vacated tray-0
// compartment (world Y 21-526mm) with NO floor at all at this Z-plane --
// Janis confirmed via render this must be a FULLY SEALED compartment, not
// just safe-by-margin. Fixed: front edge restored to drop_zone_d (138mm)
// -- the SAME constant exit_compartment_wall() already uses for its own
// Y-position, not a new number -- giving REAL contact (not just
// proximity): exit_compartment_wall() is wall_t(skin_t=2mm) deep at this
// same Y, so partition_y0==drop_zone_d creates a genuine 2mm-deep shared
// volume with that wall (world Y 138-140), not a touching face (Rule
// M-1). Checked against tray_zone_frame()'s REAL footprint (crossbar +
// both verticals, computed live -- not assumed) at this Z-plane: max Y
// anywhere = 21mm (the left vertical's own curved arc, at X=7) -- 117mm
// clear of 138mm, confirmed EMPTY. A plain full-width panel already
// achieves zero overlap with real margin to spare, so no notch/
// difference() construction is needed. Rear edge (total_d-skin_t)
// unchanged.
module tray_compartment_partition() {
    partition_t = tray_floor_t;   // 5mm, reuses the tray floor's own thickness convention
    partition_y0 = drop_zone_d;              // 138mm -- was 526mm (v47); real contact with exit_compartment_wall()
    partition_y1 = total_d - skin_t;          // 598mm -- rear wall, unchanged

    // Contact receipt (Rule M-3):
    //   vs exit_compartment_wall(): real 2mm-deep shared volume (world Y
    //     138-140mm), confirmed via its own wall_t -- not proximity.
    //   vs tray_zone_frame()'s REAL footprint at this Z-plane (270-275mm):
    //     max Y = 21mm (crossbar+both verticals, computed live) -- gap to
    //     partition_y0(138mm) = 117mm, confirmed EMPTY.
    color("#AAAAAA")
    translate([skin_t, partition_y0, tray_0_z])
        cube([product_w - (skin_t*2), partition_y1 - partition_y0, partition_t]);
}

// v46 TASK 1: NEW module -- no existing v45 module literally matched "the
// vertical partition/side bracket that holds the flap stopper" (checked:
// drop_zone_guards() are 2 thin SIDE panels within the drop zone's own
// depth, Y 2-140mm, and don't block front-to-back reach past Y=drop_zone_d;
// flap_stopper_rod() is a bare rod with no bracket geometry at all).
// Flagging this explicitly rather than force-fitting an existing module.
// Rear-facing wall at Y=drop_zone_d (the drop-zone/tray-compartment
// boundary), full width, floor to Z=tray_0_z+partition_t+e -- this module
// UNCHANGED by v47/v48 (position already correct, confirmed by Janis).
// v48 NOTE: tray_compartment_partition()'s front edge is now back at
// drop_zone_d (138mm, v48 TASK 2 fix, see that module) -- SAME Y as this
// wall's own position, giving a real 2mm-deep shared-volume overlap
// (world Y 138-140mm) between the two, not just proximity. The v47-era
// note above (that the two no longer shared a seam once the partition
// pulled back to 526mm) is now stale/superseded -- see cc_chat_log.
module exit_compartment_wall() {
    partition_t = tray_floor_t;   // matches tray_compartment_partition()
    wall_t = skin_t;
    color("#AAAAAA")
    translate([skin_t, drop_zone_d, leg_h])
        cube([product_w - (skin_t*2), wall_t, (tray_0_z + partition_t + e) - leg_h]);
}

module outer_shell() {
    // §2.2 (v43): shell independently re-derives the hinge center from ITS
    // OWN datum chain -- own sharp-corner reference (world X=0/Y=0, the
    // front-face-plane x left-face-plane intersection, extended past
    // corner_r's fillet) + FOOT_BASE_H + HINGE_Y_OFFSET + hinge_od -- never
    // reads left_zone_door()'s local variables. See commit message for the
    // side-by-side comparison against the door's own calculation.
    shell_hinge_x = 0 - (hinge_od / 2);        // -6mm world
    shell_hinge_y = HINGE_Y_OFFSET;             // 25mm world
    shell_hinge_z = FOOT_BASE_H + skin_t - e;   // 51.99mm world -- v55 FIX, was FOOT_BASE_H+0 (50mm), see door_bot_z comment in PARAMETERS for the full root-cause writeup (this independently-re-derived copy must match, per this file's own no-cross-module-reads convention)
    shell_return_depth = shell_hinge_y - skin_t; // 23mm -- independently derived

    color("#C8C8C8", 0.75)
    difference() {
        rounded_box(total_w, total_h, total_d, corner_r);

        // Hollow interior — local Z=skin_t preserves bottom skin; shell placed at leg_h in assembly
        translate([skin_t, skin_t, skin_t])
            rounded_box(total_w-(skin_t*2), total_h-(skin_t*2), total_d-(skin_t*2), corner_r-1);

        // Left product zone front: local Z 0-492 (world Z 50-542)
        translate([skin_t, -1, 0])
            cube([product_w-(skin_t*2), skin_t+2, tray_zone_top_z - leg_h]);

        // Exit zone internal chute cutout: local Z 0-250 (world Z 50-300)
        translate([(product_w - exit_door_w)/2, -1, 0])
            cube([exit_door_w, skin_t+2, exit_door_h]);

        // Upper front display cutout: local Z 492-650 (world Z 542-700)
        translate([skin_t, -1, tray_zone_top_z - leg_h])
            cube([product_w-(skin_t*2), skin_t+2, upper_display_h]);

        // Right compartment front face opening: local Z 0-492 (world Z 50-542)
        translate([product_w + divider_t, -1, 0])
            cube([system_w - divider_t - skin_t, skin_t+2, tray_zone_top_z - leg_h]);

        // v43 TASK 3 (§2.2): left-side-wall recess for left_zone_door()'s
        // return flange/hinge line, independently derived above.
        translate([-1, skin_t, shell_hinge_z - leg_h])
            cube([skin_t + 2, shell_return_depth, door_h]);

        // v50 TASK 1: front-left corner "pole" removal -- the solid curved
        // wedge of shell wall between the outer rounded_box (r=corner_r)
        // and the inner hollow (r=corner_r-1) at this corner, world X/Y
        // roughly 0-21/0-21, was never actually cut by either cutout above
        // (the front cutout assumes a FLAT wall from X=skin_t; the recess
        // above only slots the flat LEFT face) -- confirmed colliding with
        // the door leaf's own return-flange arc once tray_zone_frame() is
        // hidden. Removed via a square cut (not inset/notched -- not
        // practical in real sheet-metal forming) spanning the full corner
        // footprint (X/Y -1..corner_r+2) at the door's own full height
        // (door_bot_z..door_top_z, local 0..door_h). This is architecturally
        // the same kind of aperture as the door/window/chute cutouts above
        // -- closed by the door leaf's own return flange (already modeled)
        // plus the new hinge-pivot reinforcement (v50 TASK 4), not meant to
        // be watertight on its own.
        // v56 FIX (vm01-v56-sensor-bracket-frame-joint-fix, TASK 3): Janis's
        // own toggle testing on the merged v55 PR found the door-closed
        // manifold warning clears when EITHER show_door=false OR
        // show_shell_left=false, but NOT show_shell_top=false -- pointing
        // at a real door-vs-left-corner touch, not the compartment_divider()
        // issue v55 had flagged as the sole remaining cause. Root-caused via
        // a real CGAL intersection(): this cutout's own Y-reach (-1..21,
        // `corner_r+2`) and the recess pocket's above (Y 2..25) leave a
        // real X-Y GAP neither one covers -- X 3..21 (past the recess
        // pocket's X=3 limit) crossed with Y 21..25 (past THIS cutout's
        // Y=21 limit). A first fix attempt (nudging this cutout's Z-start
        // by -e, matching the file's usual Rule M-1 pattern) had ZERO
        // effect, confirmed via CGAL -- proving this is an X-Y coverage
        // gap, not a Z-boundary coincidence. The door's own return-flange
        // footprint clips into exactly that gap (world X3-5/Y21-25, but
        // only in the floor-skin's own Z-band 51.99-52mm, since above
        // Z=52 the interior-hollow cut already voids this X-Y spot
        // independently) -- confirmed via CGAL: `Simple: yes`, a real
        // non-degenerate 6-facet volume, not a manifold-warning-class
        // degenerate touch, an actual (if tiny, 2x4x0.01mm) physical
        // interference. Fixed: this cutout's Y-reach extended from
        // `corner_r+2`(22, i.e. -1..21) to `shell_hinge_y+2`(27, i.e.
        // -1..26) -- reuses the recess pocket's own Y-limit reference
        // (`shell_hinge_y`=`HINGE_Y_OFFSET`=25mm) with a +1 margin, not a
        // new invented number -- closing the gap with real overlap instead
        // of an exact shared boundary.
        translate([-1, -1, door_bot_z - leg_h])
            cube([corner_r + 2, shell_hinge_y + 2, door_h]);
    }
}

// TODO(Claude Web/Janis, v48 TASK 4 -- NOT resolved): a second door-closed
// collision (frame trim/joggle line at the right body edge, screenshots
// from Janis's v47 QA session) has not been root-caused. Janis suspects it
// originates HERE (this module's recess pocket / hinge-side trim), not
// tray_zone_frame() or drop_zone_guards() (both already fixed, confirmed
// clean in v47) -- she describes a top sub-piece AND a bottom sub-piece,
// neither independently controllable from show_frame/show_door. Searched
// this module and outer_shell() in full: no existing sub-feature actually
// matches that description (the only "top+bottom sub-piece" pair in the
// whole file is tray_zone_frame()'s own v46 weld flanges, already
// show_frame-toggled, and Janis explicitly says it isn't the frame). NOT
// force-fitting a guessed toggle onto the wrong geometry -- flagged in
// cc_chat_log/PART_MANIFEST.md as genuinely unresolved; needs a render/
// screenshot pointing at the specific edge before a toggle can be wired
// correctly.
module outer_shell_debug() {
    shell_h = total_h - leg_h;

    // §2.2 (v43): shell independently re-derives the hinge center from ITS
    // OWN datum chain -- own sharp-corner reference (world X=0/Y=0, the
    // front-face-plane x left-face-plane intersection, extended past
    // corner_r's fillet) + FOOT_BASE_H + HINGE_Y_OFFSET + hinge_od -- never
    // reads left_zone_door()'s local variables. See commit message for the
    // side-by-side comparison against the door's own calculation.
    shell_hinge_x = 0 - (hinge_od / 2);        // -6mm world
    shell_hinge_y = HINGE_Y_OFFSET;             // 25mm world
    shell_hinge_z = FOOT_BASE_H + skin_t - e;   // 51.99mm world -- v55 FIX, was FOOT_BASE_H+0 (50mm), see door_bot_z comment in PARAMETERS for the full root-cause writeup (this independently-re-derived copy must match, per this file's own no-cross-module-reads convention)
    shell_return_depth = shell_hinge_y - skin_t; // 23mm -- independently derived

    color("#C8C8C8", 0.75)
    difference() {
        rounded_box(total_w, shell_h, total_d, corner_r);

        // Hollow interior
        translate([skin_t, skin_t, skin_t])
            rounded_box(total_w-(skin_t*2), shell_h-(skin_t*2), total_d-(skin_t*2), corner_r-1);

        // Left product zone front cutout
        translate([skin_t, -1, 0])
            cube([product_w-(skin_t*2), skin_t+2, tray_zone_top_z - leg_h]);

        // Exit zone chute cutout
        translate([(product_w - exit_door_w)/2, -1, 0])
            cube([exit_door_w, skin_t+2, exit_door_h]);

        // Upper front display cutout
        translate([skin_t, -1, tray_zone_top_z - leg_h])
            cube([product_w-(skin_t*2), skin_t+2, upper_display_h]);

        // Right compartment front face opening
        translate([product_w + divider_t, -1, 0])
            cube([system_w - divider_t - skin_t, skin_t+2, tray_zone_top_z - leg_h]);

        // v43 TASK 3 (§2.2): left-side-wall recess for left_zone_door()'s
        // return flange/hinge line, independently derived above.
        translate([-1, skin_t, shell_hinge_z - leg_h])
            cube([skin_t + 2, shell_return_depth, door_h]);

        // v50 TASK 1: front-left corner "pole" removal -- see outer_shell()
        // above for the full explanation (same fix, both modules kept in
        // sync per this file's established parallel-maintenance convention).
        // v56 FIX (vm01-v56-sensor-bracket-frame-joint-fix, TASK 3): Y-reach
        // extended `corner_r+2`(22)->`shell_hinge_y+2`(27) -- SAME real
        // X-Y-gap fix as outer_shell()'s copy above (this module is the one
        // actually used in ASSEMBLY -- editing only outer_shell() first and
        // re-testing showed ZERO change, which is what caught this second,
        // independently-duplicated copy having been missed).
        translate([-1, -1, door_bot_z - leg_h])
            cube([corner_r + 2, shell_hinge_y + 2, door_h]);

        // Back panel — removed when show_shell_back = false
        if (!show_shell_back)
            translate([0, total_d - skin_t - 1, 0])
                cube([total_w, skin_t + 2, total_h]);

        // Top panel — removed when show_shell_top = false
        // v51 TASK 1 FIX: was `total_h - skin_t - 1` (697, local) -- this
        // module builds its own shell at local height `shell_h`
        // (=total_h-leg_h=650), only translated by +leg_h in ASSEMBLY, so
        // `total_h` is the WRONG reference frame here (same double-
        // counting class as the v39 rounded_box() bug) -- 697 sits above
        // this module's own local Z range (0-650) entirely, so the cutout
        // never reached the real top skin (local 648-650). Fixed to
        // reference `shell_h`, matching every other Z-quantity in this module.
        if (!show_shell_top)
            translate([0, 0, shell_h - skin_t - 1])
                cube([total_w, total_d, skin_t + 2]);

        // Bottom panel — removed when show_shell_bottom = false
        // v51 TASK 2 (NEW): mirrors the left/right panels' own -1-start
        // convention -- bottom skin occupies local Z 0-skin_t, so this
        // starts 1mm below (local -1) and extends skin_t+2 to fully clear it.
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

// v55 FIX (vm01-v55-door-floor-datum-fix): same "flush at the shell's own
// floor boundary" pattern as leg()/left_zone_door() -- this module's own
// bottom face sat EXACTLY at world Z=leg_h, coincident with the shell's
// floor skin's own bottom, confirmed via a real 3-way CGAL intersection()
// (door+shell+compartment_divider()) this session. Fixed the same way:
// bottom nudged e lower (real shared volume with the floor, Rule M-1),
// height extended by the same e so the TOP (total_h-skin_t) stays exactly
// where it was -- only the bottom boundary changes.
module compartment_divider() {
    color("#AAAAAA", 0.9)
    translate([product_w, skin_t, leg_h - e])
        cube([divider_t, total_d-(skin_t*2), total_h - leg_h - skin_t + e]);
}

// §2.4 (v43) helper -- samples `segs+1` points on a circle, used to build
// the curved flange below (replaces the old hard 90° polygon corner with
// an arc that follows the shell's actual rounded interior corner).
function arc_pts(cx, cy, r, a0, a1, segs) =
    [for (i = [0:segs]) let(a = a0 + i*(a1-a0)/segs) [cx + r*cos(a), cy + r*sin(a)]];

// v43: Left-zone front door — replaces front_door()+flap_door()+spring_zone_panel().
// LOCAL ORIGIN (§2.2): (0,0,0) = the HINGE CENTER, the referential datum for
// the entire door assembly, world coords Z=FOOT_BASE_H+0, Y=HINGE_Y_OFFSET,
// X=0-(hinge_od/2) (barrel proud of the shell's exterior wall). Computed
// independently below from shared named constants -- the shell's own
// recess-pocket cutout (outer_shell()/outer_shell_debug()) computes the
// SAME point independently too, never by reading these local variables.
// door_open is a plain rotate() about this same origin. Every sub-part
// (flange/panel, window, acrylic, flap, hinge marks) is re-expressed
// relative to this origin via `door_x_offset` below -- their WORLD-SPACE
// geometry is unchanged from v42, only what they're measured FROM changed.
//
// Stopper rod lives in its own module, flap_stopper_rod() — a stop that
// swings with the thing it's stopping isn't a stop. Called separately in
// ASSEMBLY, fixed to the cabinet, unaffected by door_open. The acrylic
// pane correctly stays IN this rotation (it's mounted to the door, so it
// should move with it).
module left_zone_door() {
    // §2.2 -- hinge center, independently computed (own local vars, not
    // shared with the shell's separate calc below -- both read the same
    // named constants, never each other's variables).
    hinge_x = 0 - (hinge_od / 2);      // -6mm -- barrel proud of exterior wall (world X=0), outward by half OD
    hinge_y = HINGE_Y_OFFSET;          // 25mm
    hinge_z = FOOT_BASE_H + skin_t - e;  // 51.99mm -- v55 FIX, was FOOT_BASE_H+0 (50mm), see door_bot_z comment in PARAMETERS for the full root-cause writeup

    // door_x_offset: local-X distance from the hinge center (new origin) to
    // the door's own left-edge world position (door_left_x) -- keeps the
    // flange/panel/window/flap physically unchanged from v42 (world X moved
    // 2mm -> -6mm for the origin only; Y/Z origin values are unchanged, so
    // no compensation needed on those axes).
    door_x_offset = door_left_x - hinge_x;    // 2 - (-6) = 8mm

    door_open_angle = door_open ? door_open_deg : 0;
    front_y = -(hinge_y - skin_t) + e;   // §2.5 epsilon -- nudged e off the shell's interior front-wall face (was flush at world Y=skin_t)
    flap_top_z = DATUM_FLAP_TOP - hinge_z;      // 180mm local -- flap hinge line
    flap_angle = flap_open ? flap_open_deg : 0;

    // §2.3 frozen window constants, re-anchored to the corrected local-X origin
    win_x0 = door_x_offset + window_x0;             // 46mm local
    win_x1 = door_x_offset + window_x0 + window_w;  // 382mm local
    win_z0 = window_z0;                              // 220mm local -- Z origin unchanged, no compensation
    win_z1 = window_z0 + window_h;                   // 462mm local

    exit_x_local = door_x_offset + (exit_x - door_left_x);  // local X of the exit-flap opening
    exit_bot_local = exit_bot_z - hinge_z;                   // 30mm local

    // v46 TASK 2: acrylic/metal split point -- a LIVE reference to
    // tray_stack_z0 (the same constant driving the tray stack's actual
    // position), not a duplicated magic number. If TRAY_SHIFT_UP ever
    // changes again, this boundary moves with it automatically.
    split_z_local = tray_stack_z0 - hinge_z;   // 320mm local -- world 370mm, matches tray_stack_z0 exactly

    // v48 TASK 3b: acrylic's own top Z, pulled down to clear
    // tray_zone_frame()'s v46 top weld flange (world Z frame_z1-FLANGE_T
    // .. frame_z1 = 683-693mm -- computed the SAME way tray_zone_frame()
    // computes them, reusing those now-shared PARAMETERS, not a
    // duplicated number). LIVE geometry check (Python/shapely): real 5mm
    // acrylic (door_acrylic_t) mounted at its standard depth
    // (front_y+door_t .. +door_t+door_acrylic_t, world Y 5.01-10.01mm)
    // overlaps the flange's own front face (world Y=frame_y0=7mm) by
    // 3.01mm wherever their Z ranges share space -- the flange is the
    // ONLY frame material in the window's clear central X zone (27-389mm)
    // near the door's own top edge (698mm, the OLD acrylic top -- zero
    // clearance from the door's own boundary). Fixed: acrylic stops e
    // below the flange's own bottom edge, clearing it (and the crossbar/
    // bottom flange, both already outside this range) entirely.
    acrylic_top_limit_z = (door_top_z - frame_inset - FLANGE_T - e) - hinge_z;  // 632.99mm local -- world 682.99mm

    // v49 TASK 1 (VM-01-door-flap-acrylic-fix): the flap's own cutout in
    // the LEAF (not the removed metal panel, see below) must now clear
    // the flap's FULL SWEPT volume, not just its closed-position
    // footprint -- previously the bigger WINDOW hole (down to win_z0)
    // masked this, since the flap's whole swing stayed inside that larger
    // opening regardless. Now that the window hole only cuts the ACRYLIC
    // zone (see win_z0 removed from the cut below), the region just above
    // the flap's own static hole (world Z 230-232.46, the free corner's
    // own rotation overshoot) would be SOLID leaf material again unless
    // the cutout's own top is extended to match: flap_top_z+flap_t is the
    // analytic bound on that rotation radius about the top hinge line
    // (+e for real clearance) -- confirmed ≥ the live-computed sweep max
    // (232.46mm world at flap_open_deg=55).
    flap_cut_z1 = flap_top_z + flap_t + e;    // 183.01mm local -- was exit_bot_local+exit_h (150mm local worth, i.e. 180mm)

    // v49 TASK 2: acrylic's own X-extent, pulled IN from the window's own
    // edges (win_x0/win_x1 -- UNCHANGED, see DO NOT TOUCH) rather than
    // overshooting OUTWARD by acrylic_border as before. LIVE geometry
    // check (this session, same v48 frame -- no v49 frame redesign has
    // landed): tray_zone_frame()'s left/right verticals reach EXACTLY to
    // win_x0(27mm)/win_x1(389mm) world -- the window was already sized to
    // the frame's own clear inner opening (v44). The OLD acrylic_border
    // overshoot (win_x0-5..win_x1+5 = 22-394mm) reached PAST those edges
    // directly into the verticals' own footprint -- confirmed via CGAL
    // this is the entire source of the v48-flagged fill-vs-frame volume
    // regression. Fixed: acrylic pulled in by the SAME 2mm the project's
    // own Global Clearance Tolerance table already specifies for "display
    // object to any structural face" (rules-dimensions.md) -- not a new
    // invented number -- plus e so it doesn't touch the vertical's own
    // flat inner face exactly. The vacated 2mm strip on each side becomes
    // a visible plain-metal border (see acrylic_x0/x1 use below).
    acrylic_x0 = win_x0 + 2 + e;   // 29.01mm local -- was win_x0-acrylic_border (reached to 22mm, INTO the left vertical)
    acrylic_x1 = win_x1 - 2 - e;   // was win_x1+acrylic_border (reached to 394mm, INTO the right vertical)

    // §2.4 -- curved flange: same center/radius as the shell's own actual
    // rounded interior corner (rounded_box(..., corner_r-1) in outer_shell()),
    // sampled live from corner_r/skin_t, not hardcoded. Center in local
    // coords = shell's world corner-curve center minus the hinge origin.
    arc_cx = (skin_t + (corner_r - 1)) - hinge_x;   // local X of shell's interior corner curve center
    arc_cy = (skin_t + (corner_r - 1)) - hinge_y;   // local Y of same
    arc_r_outer = corner_r - 1;                      // matches shell's interior fillet radius
    arc_r_inner = arc_r_outer - door_t;              // concentric, offset inward by wall thickness
    arc_segs = 12;                                   // >= 12 per spec

    outer_arc = arc_pts(arc_cx, arc_cy, arc_r_outer, 180, 270, arc_segs);
    inner_arc = arc_pts(arc_cx, arc_cy, arc_r_inner, 270, 180, arc_segs);

    door_poly = concat(
        [[door_x_offset, 0]],                                    // hinge line, top
        outer_arc,                                                // hinge line -> front face, following shell's rounded corner
        [[door_x_offset + door_w, front_y],                       // front-right corner
         [door_x_offset + door_w, front_y + door_t]],             // front-right, inner face
        inner_arc,                                                 // inner front face -> inner hinge line, following same curve
        [[door_x_offset + door_t, 0]]                             // inner hinge line, top
    );

    translate([hinge_x, hinge_y, hinge_z])
    rotate([0, 0, -door_open_angle]) {

        // 1+2+4+6. Single-piece L-shaped leaf: return flange + front panel in
        // ONE linear_extrude() of a bent 2D cross-section, curved corner per
        // §2.4, with the top window + exit-flap openings cut from it. True
        // manifold solid — no gap/seam possible.
        // v49 TASK 1: window hole's bottom edge raised from win_z0 to
        // split_z_local -- the hole now only spans the ACRYLIC zone. Below
        // split_z_local the leaf stays fully solid (its own continuous
        // door_t skin) -- this IS the "lower flap-zone metal" now, not a
        // separately-mounted sheet (that piece is deleted, see below).
        // Flap cutout's own top extended to flap_cut_z1 (was
        // exit_bot_local+exit_h) so the flap's full 0-55° swept volume
        // still clears the now-solid leaf material above its old,
        // closed-position-only hole (see flap_cut_z1's derivation above).
        color("#888888", 0.9)
        difference() {
            linear_extrude(height = door_h)
                polygon(door_poly);

            // v51 TASK 4 FIX: top bound shrunk from win_z1 (693mm world) to
            // acrylic_top_limit_z (682.99mm world, where the acrylic panel
            // itself already stops to clear tray_zone_frame()'s top weld
            // flange) -- the leaf's own solid door_t skin now simply isn't
            // cut in the 682.99-698mm-world sliver above it, filling that
            // space directly instead of via the deleted metal "top cap"
            // patch piece (see acrylic block below). Mirrors the door's
            // lower/flap zone (v49): shell material IS the fill, not an
            // applied add-on.
            // v52 TASK 1 FIX: upper bound nudged to `acrylic_top_limit_z - e`
            // (was exactly `acrylic_top_limit_z`, no epsilon) -- the DELETED
            // top cap always started its own fill at `acrylic_top_limit_z-e`
            // specifically to get a real e-deep SHARED VOLUME with the
            // acrylic (Rule M-1: "nudged e down into the acrylic's own top
            // for real shared volume, not a touching face") -- v51 restored
            // the leaf's own material in this zone but dropped that same
            // epsilon nudge, leaving the leaf's resumed solid and the
            // acrylic's own top meeting at an EXACT zero-clearance plane
            // (arithmetic-confirmed: both at world Z=682.99mm exactly) --
            // this coincident-face condition is the established root cause
            // of visible seam/z-fighting artifacts everywhere else in this
            // file. Restoring the same -e nudge here gives the leaf and the
            // acrylic a genuine shared sliver, same convention, no gap/seam.
            translate([win_x0, front_y - 1, split_z_local])
                cube([win_x1 - win_x0, door_t + 2, (acrylic_top_limit_z - e) - split_z_local]);

            translate([exit_x_local, front_y - 1, exit_bot_local])
                cube([exit_w, door_t + 2, flap_cut_z1 - exit_bot_local]);
        }

        // 3. Hinge seam indicators — pulled strictly INSIDE the flange body
        // (not touching its own hinge-line face) to avoid T-junction
        // contact. Concept placeholder only, NOT a protruding hinge barrel —
        // hinge hardware spec is an open item (rules-dimensions.md).
        for (pct = [0.1, 0.5, 0.9])
            color("#333333")
            translate([door_x_offset - e, -(hinge_mark_d + e), door_h*pct - hinge_mark_h/2])
                cube([door_t + e*2, hinge_mark_d, hinge_mark_h]);

        // v50 TASK 4: hinge-pivot reinforcement -- a solid pole-like member
        // AT the door's own local origin (0,0), the rotation axis itself,
        // full door_h height. Replaces the structural role the removed
        // shell corner "pole" (v50 TASK 1) used to serve, from the DOOR's
        // side rather than the shell's -- rotates WITH the door (inside
        // this same translate/rotate block), unlike the old fixed shell
        // pole. Diameter reuses hinge_od (12mm, the barrel's own already-
        // established size at this exact location) rather than inventing a
        // new number. Sitting exactly on the rotation axis makes this
        // member ANGLE-INVARIANT in world space (a point on the axis
        // doesn't move under rotation) -- confirmed clear at one
        // door_open_deg means clear at all of them, verified via live CGAL
        // render at 0/50/100 degrees. Overlaps the flange's own material
        // where their footprints coincide -- harmless, both are children
        // of this same union (Rule M-1 doesn't apply to intentional
        // same-body merges, only to separate top-level objects touching).
        color("#888888", 0.9)
        cylinder(d = hinge_od, h = door_h);

        // 5. Acrylic viewing pane — mounted door_t further inside than the
        // door face; correctly moves WITH the door leaf. v44 Finding B: was
        // gated on `render_mode=="full" && show_acrylic`, inconsistent with
        // its siblings (show_door/show_flap are NOT render_mode-gated) —
        // since render_mode defaults to "standard", the acrylic could never
        // render regardless of show_acrylic. Now gated on show_acrylic alone.
        // v46 TASK 2: split into an upper ACRYLIC portion and a lower plain
        // METAL sheet at split_z_local (live reference to tray_stack_z0).
        // v48 TASK 3: metal top cap added near the frame's top flange.
        // v49 TASK 1 (VM-01-door-flap-acrylic-fix): the separately-mounted
        // LOWER metal panel is DELETED -- that zone is now the leaf's own
        // continuous door_t skin (see the difference() above). v51 TASK 4:
        // the top metal cap (d) is ALSO DELETED -- Janis confirmed it
        // vanished with show_acrylic=false (it lived in this same
        // if-block), proving it was a cosmetic patch on the acrylic
        // assembly, not independent shell material; the leaf's own window-
        // cutout bound was shrunk to acrylic_top_limit_z instead (see
        // difference() above), so real shell material fills that zone
        // directly. Three pieces remain, all sharing show_acrylic:
        //   (a) upper acrylic (3a: real door_acrylic_t depth; 3b: top at
        //       acrylic_top_limit_z; v49 TASK 2: X pulled in to
        //       acrylic_x0/x1, clear of the frame's verticals)
        //   (b)+(c) v49 TASK 2: 2 new visible plain-metal border strips
        //       (left/right) filling the vacated space between the
        //       window's own edge and the pulled-in acrylic
        if (show_acrylic) {
            // (a) Upper acrylic — v48 TASK 3a: real door_acrylic_t depth
            // (was door_t, same as metal). v48 TASK 3b: top boundary at
            // acrylic_top_limit_z (682.99mm world), clear of
            // tray_zone_frame()'s top weld flange -- re-verified against
            // the SAME live v48 frame this session (no v49-frame-redesign
            // has landed), unchanged. v49 TASK 2: X range pulled in to
            // acrylic_x0/acrylic_x1 (see derivation above) -- was
            // win_x0-acrylic_border..win_x1+acrylic_border, which reached
            // directly into the frame's left/right verticals.
            color("#ADD8E6", 0.3)
            translate([acrylic_x0, front_y + door_t, split_z_local])
                cube([acrylic_x1 - acrylic_x0, door_acrylic_t, acrylic_top_limit_z - split_z_local]);

            // (b)/(c) v49 TASK 2: visible plain-metal border strips filling
            // the space vacated by the acrylic's pulled-in edges -- from
            // the window's own opening (win_x0/win_x1, UNCHANGED) to the
            // acrylic's new edges (acrylic_x0/acrylic_x1). door_t depth,
            // same Z-range as the acrylic (split_z_local..acrylic_top_limit_z).
            // CAUGHT via live CGAL re-check (not assumed): a naive
            // win_x0..acrylic_x0 span touches tray_zone_frame()'s left
            // vertical EXACTLY at win_x0(27mm, its own inner face) and the
            // acrylic EXACTLY at acrylic_x0 -- two coincident-face risks
            // (Rule M-1), confirmed as a zero-volume degenerate CGAL
            // intersection, not a real collision but the same "touching
            // face" class this file always epsilon-nudges. Fixed: outer
            // edge nudged +e off the frame (real gap, not touching), inner
            // edge nudged +e past the acrylic (real shared volume).
            color("#999999")
            translate([win_x0 + e, front_y + door_t, split_z_local])
                cube([(acrylic_x0 + e) - (win_x0 + e), door_t, acrylic_top_limit_z - split_z_local]);

            color("#999999")
            translate([acrylic_x1 - e, front_y + door_t, split_z_local])
                cube([(win_x1 - e) - (acrylic_x1 - e), door_t, acrylic_top_limit_z - split_z_local]);

            // (d) Top metal cap — DELETED v51 TASK 4. This was a separately-
            // mounted "patch" piece (v48 TASK 3b) covering the zone the
            // acrylic pulled back from to clear tray_zone_frame()'s top weld
            // flange -- Janis confirmed it disappeared along with
            // show_acrylic=false (it lived inside this same if-block),
            // proving it was riding on the acrylic assembly rather than
            // being independent shell material, and that it was a cosmetic
            // "fake it's steel" patch, not a structural fill. Its own FLAG
            // (carried v48->v49->v50: ~1.01mm Y-depth overlap with the
            // frame's front face, the entire remaining fill-vs-frame
            // residual per v49's cc_chat_log) is RESOLVED by its removal --
            // see TASK 4 note in the header and the shrunk window-cutout
            // bound above (acrylic_top_limit_z), which lets the leaf's own
            // door_t skin fill this zone directly instead.
        }

        // 7. Exit flap — hinged at TOP, swings inward (+Y) toward flap_open_deg.
        // Independent show_flap toggle.
        // v48 TASK 3d (CONFIRMED, no change needed): flap's own Y-range
        // (front_y..front_y+flap_t) already exactly matches the door's
        // structural panel plane (front_y..front_y+door_t, flap_t==door_t
        // numerically) -- no additional inner-frame-style offset/stacking
        // is present at the flap's location, confirmed via live geometry.
        if (show_flap)
            color("#B0B0B0", 0.9)
            translate([0, front_y, flap_top_z])
            rotate([flap_angle, 0, 0])
            translate([0, -front_y, -flap_top_z])
                translate([exit_x_local, front_y, exit_bot_local])
                    cube([exit_w, flap_t, exit_h]);
    }
}

// v42 TASK 2: static stopper rod for the exit flap — moved OUT of
// left_zone_door()'s door_open rotation (a stop that swings with the thing
// it's stopping isn't a stop). Fixed to the cabinet in world coordinates,
// matching the door's CLOSED-state geometry; stops the flap regardless of
// whether the main door is open or closed. No proximity switch/sensor
// geometry — explicitly deferred (Janis).
module flap_stopper_rod() {
    stop_y = skin_t + exit_h * sin(flap_open_deg);          // flap's fully-open Y position (world, door closed)
    stop_z = DATUM_FLAP_TOP - exit_h * cos(flap_open_deg);  // flap's fully-open Z position (world)

    color("#555555")
    translate([door_left_x, stop_y, stop_z])
        rotate([0, 90, 0])
            cylinder(d=hinge_od, h=door_right_x - door_left_x);
}

// FIX 2: Left front acrylic panel — full left product zone, Z 50-700.
// Customer sees springs, trays, products. Replaces visual of solid front face.
module left_front_acrylic() {
    panel_x = skin_t;                        // X=skin_t
    panel_w = product_w - (skin_t * 2);      // 412mm
    panel_z = leg_h;                         // Z=50mm
    panel_h = total_h - leg_h;              // 650mm (Z 50-700)
    panel_t = door_t;                        // 3mm

    color("#ADD8E6", 0.15)
    translate([panel_x, e, panel_z])
        cube([panel_w, panel_t, panel_h]);
}

// v44 TASK 3 (Finding C): full rebuild, H-frame. The old design started
// every bar at translate([0, e*2, ...]) -- world X=0/Y=0, the shell's
// THEORETICAL SHARP EXTERIOR corner -- never accounting for skin_t or
// corner_r at all, so it visually sat at/outside the shell's actual
// interior wall. Separately CONFIRMED via CGAL boolean intersection
// (isolation-tested against left_zone_door(), 9-angle sweep 0-100deg):
// the old frame's top/bottom/right bars physically clipped the door leaf
// for door_open_deg 0-30 -- a SEPARATE issue from the wrong reference
// point, both required fixing.
//
// v46 TASK 3: 10mm top + bottom weld flanges added, for spot-welding the
// frame to the shell -- built from the SAME 2D cross-section as the
// crossbar (already proven clear of the door leaf at every angle), placed
// WITHIN the existing frame_z0..frame_z1 range, no new Z-boundary risk.
//
// New H-shape: 2 full-height verticals (frame_bar wide) + 1 crossbar
// (10mm thick) at tray_0_z -- replaces the old top+bottom+short-side-bar
// layout entirely. Repositioned off the shell's REAL interior corner
// curve (world (skin_t+(corner_r-1), skin_t+(corner_r-1)) -- SAME formula
// as left_zone_door()'s arc_cx/arc_cy, reused here independently since
// this module has no hinge-relative local origin). The left vertical's
// outer edge is curved to match that SAME curve (same center, same
// corner_r-1 radius formula) but pulled back by the SAME 5mm border inset
// already used for the frame's X/Z insets -- radius (corner_r-1)-inset =
// 14mm -- so it clears the door's hinge/flange swept volume at every
// angle. Verified (Python/shapely, mirrors the CGAL intersection() test):
// ZERO overlap at door_open_deg 0,20,25,30,35,40,45,70,100, and a finer
// 0.5-degree sweep across the full 0-100deg range -- see commit message
// for the full result table.
// v50 TASK 2: rebuilt to make both verticals reach as far toward the
// housing as physically possible (Janis-confirmed via screenshots: "inner
// frame gap to left shell corner", "inner frame gap to top shell").
// RIGHT vertical: extended to genuine real contact with
// compartment_divider() (world X=product_w+e=416.01mm, was floating at
// the old inset X1=409mm) -- ACHIEVED, confirmed via live CGAL render
// (empty intersection with the door across the full sweep, and with
// spring lane 4's swept footprint, see TASK 3).
// LEFT vertical: attempted the SAME "grow to touch the shell's interior
// wall" treatment (radius (corner_r-1)+e=19.01mm, same center as the
// shell's own corner curve) -- LIVE CGAL bisection found this is NOT
// ACHIEVABLE: the door's own return-flange arc uses the IDENTICAL center
// and an outer radius of the SAME value (corner_r-1=19mm, by design, for
// a snug closed fit against the shell), so any frame radius above
// ~15.96mm re-collides with the door's flange (confirmed empirically,
// door_open_deg=0 is the tightest case) -- there is no radius that both
// touches the shell AND clears the door, because the door's own flange
// physically occupies that exact space when closing. Separately: v50
// TASK 1 removes the shell's own corner wall material across this whole
// region anyway (to clear the door) -- so even without the door-clearance
// conflict, there would be no remaining shell wall left immediately
// adjacent for the frame to weld to. Net result: frame_arc_r stays at the
// OLD, already-proven-safe value ((corner_r-1)-frame_inset=14mm) --
// numerically UNCHANGED from pre-v50, confirmed via live sweep this is
// still the maximum the door's own clearance allows. What DOES change:
// frame_bar (20mm->8mm) still narrows the bar's own inner edge, and the
// curve's angle range is now DELIBERATELY NOT the full 180-270 span --
// it stops at whatever angle first reaches frame_y0 (kept as a DECOUPLED
// fixed constant, 7mm, its own prior already-verified value, not
// re-derived from the curve's own endpoint -- at frame_arc_r=14 this
// naturally lands at angle=270 anyway, so the shape is numerically
// identical to the pre-v50 curve; the decoupling matters if frame_arc_r
// is ever revisited, so it's kept explicit rather than silently relying
// on this coincidence). FLAG for Janis: "left vertical touches the shell"
// is not achievable as stated without recolliding the door; the closest
// achievable outcome (unchanged 14mm reach, sole reinforcement at the
// vacated corner) is what's implemented, stated explicitly rather than
// silently forcing a number that would reopen the door collision.
module tray_zone_frame() {
    frame_z0 = door_bot_z + frame_inset;    // 55mm
    frame_z1 = door_top_z - frame_inset;    // 693mm
    frame_h  = frame_z1 - frame_z0;         // 638mm

    // Shell's real interior corner curve, WORLD coords -- same formula as
    // left_zone_door()'s arc_cx/arc_cy (this module has no hinge-relative
    // local origin, so no further offset is needed).
    world_arc_cx = skin_t + (corner_r - 1);      // 21mm
    world_arc_cy = skin_t + (corner_r - 1);      // 21mm
    frame_arc_r  = (corner_r - 1) - frame_inset; // 14mm -- v50: UNCHANGED from pre-v50 -- see module comment above (growing this re-collides the door, confirmed via live bisection; not a guess)
    frame_y0     = 7;                             // v50: DECOUPLED fixed constant -- see module comment above
    frame_depth  = skin_t;                        // 2mm

    left_bar_inner_x = door_left_x + frame_inset + frame_bar;  // 15mm (was 27mm) -- X0(=door_left_x+frame_inset=7) + frame_bar(8) -- still used by crossbar/flanges below (unchanged, see v56 note on the left bar itself)

    // v56 (vm01-v56-sensor-bracket-frame-joint-fix): Janis QA screenshot
    // flagged a visible "bad joint" here -- "should be single piece curve
    // from front frame just like front door curve". Root cause found: the
    // v50 fix above (single arc, early-truncated at X=left_bar_inner_x to
    // avoid self-intersection) leaves the OUTER boundary as an arc that
    // abruptly meets a straight vertical line at a non-tangent angle -- a
    // real C1 discontinuity (visible kink), not just a rendering artifact.
    // Real fix: rebuild as a genuine concentric double-arc band -- SAME
    // construction left_zone_door() itself already uses (outer_arc +
    // inner_arc, both swept together, closed with straight RADIAL end
    // segments) -- literally "just like front door curve", not a new
    // technique. Outer radius unchanged (frame_arc_r=14mm, the
    // already-proven max that clears the door, see module comment above).
    // Inner radius = frame_arc_r-frame_bar = 6mm (same frame_bar=8mm,
    // UNCHANGED -- this does not touch tray_w_global/right_bar_inner_x,
    // which independently read the shared frame_bar constant elsewhere).
    // Sweep both arcs to y_stop_angle (270deg) -- the angle where the
    // OUTER arc reaches frame_y0 exactly (world_arc_cy-frame_arc_r=7=
    // frame_y0, an existing, already-documented exact coincidence at
    // frame_arc_r=14, not a new assumption). The inner arc physically
    // cannot reach frame_y0 at this radius (max reach world_arc_cy-
    // inner_r=15mm) -- it doesn't need to: the radial end-cap segment
    // (straight line between the two arcs' endpoints at the SAME angle)
    // closes the band exactly like the door's own front-face/inner-face
    // closing segments do. No self-intersection risk (concentric arcs at
    // the same angle range never cross), so the old x_stop_angle
    // self-intersection guard is no longer needed for this shape.
    inner_r = frame_arc_r - frame_bar;  // 6mm
    y_stop_angle = 180 + asin((world_arc_cy - frame_y0) / frame_arc_r);  // 270deg
    arc_segs = 24;

    // arc_pts() -- same helper left_zone_door() itself uses for its own
    // outer_arc/inner_arc. Outer forward (180->y_stop_angle), inner
    // REVERSED (y_stop_angle->180) so concat(outer, inner) traces a
    // closed loop directly, identical idiom to door_poly below.
    left_outer_arc = arc_pts(world_arc_cx, world_arc_cy, frame_arc_r, 180, y_stop_angle, arc_segs);
    left_inner_arc = arc_pts(world_arc_cx, world_arc_cy, inner_r, y_stop_angle, 180, arc_segs);

    // v50 TASK 2: right vertical extended to touch compartment_divider()
    // (starts at world X=product_w) instead of floating at the old inset
    // X1=door_right_x-frame_inset=409mm. Real contact: +e overlap.
    divider_touch_x  = product_w + e;                    // 416.01mm
    right_bar_inner_x = divider_touch_x - frame_bar;     // 408.01mm

    color("#AAAAAA")
    union() {
        // Left vertical bar -- curved outer edge wraps the corner where
        // the removed shell "pole" (v50 TASK 1) used to sit, now the sole
        // structural reinforcement there. Constant cross-section for the
        // full frame height (Z-invariant).
        translate([0, 0, frame_z0])
            linear_extrude(height = frame_h)
                polygon(concat(left_outer_arc, left_inner_arc));

        // Right vertical bar -- extended to touch compartment_divider()'s wall.
        translate([right_bar_inner_x, frame_y0, frame_z0])
            cube([divider_touch_x - right_bar_inner_x, frame_depth, frame_h]);

        // Crossbar -- 10mm thick (Z), spans left-to-right between the verticals, at tray_0_z
        translate([left_bar_inner_x, frame_y0, tray_0_z])
            cube([right_bar_inner_x - left_bar_inner_x, frame_depth, 10]);

        // v46 TASK 3: top + bottom flanges, 10mm each, for spot-welding to
        // the shell. Built from the SAME 2D cross-section as the crossbar
        // above (already proven clear of the door's swept volume at every
        // mandated angle) -- reused here rather than a new shape, and
        // placed WITHIN the frame's existing, already-verified Z range
        // (frame_z0..frame_z1), not extending past it, so no new
        // Z-boundary risk is introduced.
        translate([left_bar_inner_x, frame_y0, frame_z1 - FLANGE_T])
            cube([right_bar_inner_x - left_bar_inner_x, frame_depth, FLANGE_T]);
        translate([left_bar_inner_x, frame_y0, frame_z0])
            cube([right_bar_inner_x - left_bar_inner_x, frame_depth, FLANGE_T]);
    }
}

// Parallel sensor strips — left and right walls, just below the ACTUAL
// tray 0 floor.
// v44 Finding A: the old module also drew a red 2x2mm cube spanning the
// FULL GAP between the two strips, reading as a connecting beam/rod —
// Janis-confirmed this center element was never part of the actual
// design (2 independent side pieces only, nothing bridging them).
// Deleted entirely, not just hidden. `show_sensor` gates both real strips.
//
// v54 FIX (vm01-v54-sensor-bracket-fix): `strip_z` referenced `tray_0_z`
// (270mm) -- the PRE-v46 tray anchor, kept unchanged since v46 ONLY as
// `tray_compartment_partition()`'s own sealing reference, explicitly NOT
// the trays' live position (see that module's comment and the DATUMS
// block). Every other module that needs the trays' ACTUAL position
// (`spring_tray()`, `tray_rack()`) was updated in v46 to reference
// `tray_stack_z0` instead -- this module was missed. Root-caused via a
// real CGAL intersection() this session: at the stale Z (250mm world),
// this strip has a genuine 12-facet SOLID overlap with
// `exit_compartment_wall()` (world Z 50-275.01mm), a fixed safety-critical
// part -- not a degenerate touch, a real collision. Fixed to reference
// `tray_stack_z0` (the live tray-position datum), restoring "just below
// the actual tray 0 floor" as the rules-dimensions.md-documented intent.
// Re-verified via real CGAL: ZERO overlap vs exit_compartment_wall() at
// the corrected Z. NOTE: this does NOT address the separate "visible from
// outside" symptom Janis also flagged -- confirmed via render this
// traces to the already-flagged, out-of-scope v50 corner-pole gap (same
// root feature behind the previously-found bottom-left floor hole), not
// to this strip's own coordinates; moving Z does not change that.
module sensor_strip() {
    // v56: reads the shared sensor_strip_z0/sensor_strip_h datum (see
    // DATUMS block) instead of its own local copy -- drop_zone_guards()
    // now reads the SAME datum to size its own bracket around this strip.
    strip_z = sensor_strip_z0;
    strip_t = 5;
    strip_h = sensor_strip_h;

    // §2.5 (v43) epsilon fix -- both strips were flush at X=skin_t (left
    // strip's own face, right strip's own face) against the shell's
    // interior left/right walls. Nudged e inward (away from each wall) to
    // kill the coplanar-face condition.
    strip_x0 = skin_t + e;                        // left strip left edge
    strip_x1 = product_w - skin_t - strip_t - e;   // right strip left edge

    // v48 TASK 1: front (Y) edge was still hardcoded at skin_t (2mm) --
    // never updated when drop_zone_guards() got its door-clearance fix in
    // v47, so it still poked through the closed door. First attempt
    // (reusing drop_zone_guards()'s exact fix, world_arc_cy+e=21.01mm)
    // checked against live geometry (Python/shapely, mirrors the CGAL
    // intersection() test) and found INSUFFICIENT for the LEFT strip
    // specifically: its X range (strip_x0..+strip_t = 2.01-7.01mm)
    // overlaps the door's hinge-line flange face (world X 2-5mm), which
    // reaches all the way up to world Y=HINGE_Y_OFFSET(25mm) there --
    // drop_zone_guards()'s own left guard sits clear of this X range
    // (X=5.01mm), which is why 21.01mm was sufficient THERE but not here
    // -- 11.93mm² confirmed overlap at door_open_deg=0 with that value.
    // Fixed instead: HINGE_Y_OFFSET+e (25.01mm, an EXISTING constant, not
    // a new invented number) -- confirmed via live geometry to be the
    // door polygon's global maximum Y at ANY X, so it clears the leaf
    // everywhere, not just outside the flange region. Rear edge (was
    // skin_t+drop_zone_d=140mm, no epsilon) unchanged. Re-verified:
    // 9-angle sweep (0/20/25/30/35/40/45/70/100) + fine 0.5° sweep, ZERO
    // overlap for BOTH strips at every angle.
    strip_y0 = HINGE_Y_OFFSET + e;          // 25.01mm -- was skin_t (2mm)
    strip_y1 = skin_t + drop_zone_d;        // 140mm -- rear edge, unchanged

    if (show_sensor) {
        color("#222222")
        translate([strip_x0, strip_y0, strip_z])
            cube([strip_t, strip_y1 - strip_y0, strip_h]);

        color("#222222")
        translate([strip_x1, strip_y0, strip_z])
            cube([strip_t, strip_y1 - strip_y0, strip_h]);
    }
}

// ATM dashboard — right compartment.
// screen_y = -30mm (protrudes 30mm forward of front face).
module dashboard() {
    screen_z = screen_center_z - screen_h/2;  // 230mm
    qr_z     = screen_z - 50 - qr_h;          // 150mm
    card_z   = qr_z - 30 - card_h;            // 112mm
    speaker_z = card_z - 20 - speaker_h;       // 72mm

    // Screen — protrudes forward (screen_y = -30mm)
    color("#1A1A1A")
    translate([product_w + divider_t + 10, screen_y, screen_z])
        rotate([-30, 0, 0])
            cube([screen_w, 5, screen_h]);

    // Screen bezel
    color("#333333", 0.8)
    translate([product_w + divider_t + 10 - bezel_t,
               screen_y - 2, screen_z - bezel_t])
        rotate([-30, 0, 0])
            cube([screen_w + (bezel_t*2), 3, screen_h + (bezel_t*2)]);

    // Support bracket — flat crossbar cube (replaced hull+rotated cylinders, non-manifold risk)
    color("#444444")
    translate([dash_x + dash_w/2 - screen_w/2, screen_y, screen_z - bracket_r])
        cube([screen_w, 30, bracket_r * 2]);

    // QR scanner
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

// Acrylic display — 3 faces of right compartment, Z 542-698.
module acrylic_display() {
    acrylic_front_w = system_w - divider_t - skin_t;
    acrylic_front_x = product_w + divider_t;

    color("#ADD8E6", 0.3)
    translate([acrylic_front_x, e, acrylic_bot_z])
        cube([acrylic_front_w, door_t, acrylic_zone_h]);

    // FIXED v39: recessed to corner_r on both Y ends — was skin_t, which put
    // the panel inside the shell's rounded-corner region (front AND rear),
    // causing a 7.28mm protrusion past the curved wall at the front corner.
    // Panel now starts/ends exactly where the shell wall goes flat.
    color("#ADD8E6", 0.3)
    translate([total_w - (skin_t*2), corner_r, acrylic_bot_z])
        cube([skin_t, total_d - (corner_r*2), acrylic_zone_h]);

    color("#ADD8E6", 0.3)
    translate([acrylic_front_x, skin_t, total_h - (skin_t*2)])
        cube([acrylic_front_w, total_d-(skin_t*2), skin_t]);
}

// §2.6 (v43): drop_zone_visual() removed entirely -- its top/bottom/front/
// back faces were ghost surfaces that blocked the ACTUAL product drop path
// (vertical fall-through and front-to-back access). Only the 2 side faces
// (left/right, constant X, spanning Y-Z) were a genuine safety guard against
// a hand reaching in sideways toward the mechanism above -- kept below,
// rebuilt as solid opaque panels (skin_t thick), not translucent.
//
// LEFT panel receipt: left_zone_door()'s return flange occupies world
// X = door_left_x .. door_left_x+door_t = 2..5mm, Y = skin_t .. HINGE_Y_OFFSET
// = 2..25mm (§2.2). Left guard placed just past the flange's right edge:
// X0 = skin_t + door_t + e = 5.01mm -- clears the flange, no intersection.
// RIGHT panel: no hinge on this side (hinge is LEFT edge only, rules-
// dimensions.md) -- placed symmetric to the old drop_zone_visual() box's
// right face, X1 = product_w - skin_t - skin_t - e = 411.99mm.
//
// v47 PROBLEM 2 fix: at door_open_deg=0 (closed), both guards' OLD
// front-most Y (skin_t+e = 2.01mm) poked through the door's own surface
// plane -- confirmed by Janis via direct visual render inspection. Both
// of Janis's suggested references were checked against live geometry
// (Python/shapely) and found INSUFFICIENT for the hinge-side guard: the
// "frame face minus thickness" formula and the flat 10mm fallback both
// still left a confirmed overlap (10mm pullback -> 7.6mm² overlap at
// door_open_deg=0), because that guard sits close to the door's curved
// flange, which reaches up to world Y=world_arc_cy(21mm) there -- not
// just to tray_zone_frame()'s own front face (7mm). Fixed instead: guard
// front-most Y raised to world_arc_cy+e (21.01mm) -- the SAME shell-
// interior-corner-curve constant (skin_t+(corner_r-1)) already used
// identically by both left_zone_door() and tray_zone_frame(), not a new
// invented number. Rear edge (skin_t+e+drop_zone_d = 140.01mm) UNCHANGED.
// Re-verified: 9-angle sweep (0/20/25/30/35/40/45/70/100) + fine 0.5°
// sweep, ZERO overlap at every angle -- see cc_chat_log.md.
// v54 FIX (vm01-v54-sensor-bracket-fix): the prompt's own claim that this
// guard is "already known, oversized toward the front and in Z, prior
// session, deprioritized as no harm" could NOT be confirmed anywhere in
// cc_chat_log.md or rules-dimensions.md (searched in full) -- not acted
// on without a traceable source. What real CGAL DID confirm this session:
// `guard_y0`'s front edge (world_arc_cy+e = 21.01mm) sits at an EXACT
// zero-clearance tangent against the door's return-flange curve (same
// circle, same center/radius, by construction) -- a 1-facet degenerate
// touch (manifold-warning class, not a real overlap), the same signature
// as the v52/v53 exact-tangency findings. This reads as "squeezed" in a
// render even though it's not a volumetric collision.
// First attempt (world_arc_cy+skin_t=23mm, pulling back from the arc)
// checked via real CGAL and found INSUFFICIENT -- a SEPARATE 1-facet
// touch remained at world X=5.01/Y~24, Z~105-125: the guard's own front-X
// face (5.01mm) sitting 0.01mm off the door's INNER hinge-line straight
// segment (world X=5, Y=21-25 -- a DIFFERENT door surface than the outer
// arc, confirmed present in v53 too, pre-existing, not introduced by this
// fix). Guard's own Y-range needs to clear Y=21-25 entirely, not just
// pull back from Y=21. Fixed instead: `HINGE_Y_OFFSET + skin_t` (27mm) --
// reuses the SAME reference point (`HINGE_Y_OFFSET`) `sensor_strip()`
// already uses and confirms is "the door polygon's global maximum Y at
// ANY X" (clears the inner hinge-line segment entirely, not just the
// arc), plus this file's own "Structural part to shell face: skin_t(2mm)"
// Global Clearance Tolerance convention for real clearance instead of
// bare epsilon -- both already-established values, nothing invented. NOT
// the Z-range change the prompt assumed (no evidence found for that
// claim; Z-range left UNCHANGED). Re-verified: 9-angle sweep
// (0/20/25/30/35/40/45/70/100), ZERO overlap at every angle -- see
// cc_chat_log.md for the real clearance result.
// v56 (vm01-v56-sensor-bracket-frame-joint-fix): Janis QA screenshot
// showed sensor_strip() "lifted out" of this guard -- confirmed the real
// cause: the guard's own height (exit_door_h=250mm, world Z 50-300) was
// never tied to the sensor at all, it was sized only to flank the shell's
// exit-chute cutout. The v54 fix moved the sensor strip's Z UP (to clear
// a real collision with exit_compartment_wall(), see that module's own
// header) to world Z 350-358 -- 50mm above the guard's old 300mm top,
// stranding it outside the guard's own Z-span entirely. Moving the
// sensor back down would reopen that confirmed 12-facet collision, so
// per Janis's own instruction ("if by design sensor have to be here then
// the bracket to hold it must revise") -- fixed the bracket: its own
// height now covers whichever is taller, the original exit-chute flank
// (exit_door_h) or the sensor's own top (sensor_strip_z0+sensor_strip_h,
// the SAME shared datum sensor_strip() itself now reads, see DATUMS
// block -- not a second independently-derived copy). Guard is now one
// continuous rail (world Z 50-358) instead of stopping short.
module drop_zone_guards() {
    // v54: no longer references the shell-corner-curve constant
    // (world_arc_cy) at all -- HINGE_Y_OFFSET clears both the door's arc
    // AND its inner hinge-line segment, see module comment above. Avoids
    // a now-dormant local (was `world_arc_cy_local`, only used by the
    // superseded formula) per this file's own precedent against dead vars.
    guard_y0 = HINGE_Y_OFFSET + skin_t;        // 27mm -- was world_arc_cy_local+e (21.01mm, exact-tangent touch vs the door's arc AND its inner hinge-line segment, no real clearance from either)
    guard_y1 = skin_t + e + drop_zone_d;       // 140.01mm -- rear edge, unchanged
    guard_depth = guard_y1 - guard_y0;          // 113mm
    guard_h = max(exit_door_h, (sensor_strip_z0 + sensor_strip_h) - leg_h); // 308mm -- was exit_door_h(250) alone, see module comment above

    color("#DDDDDD")
    translate([skin_t + door_t + e, guard_y0, leg_h])
        cube([skin_t, guard_depth, guard_h]);

    color("#DDDDDD")
    translate([product_w - skin_t - skin_t - e, guard_y0, leg_h])
        cube([skin_t, guard_depth, guard_h]);
}

module rear_service_door() {
    door_w = system_w - divider_t;
    door_h = total_h * 0.5;
    color("#B8B8B8", 0.6)
    translate([product_w + divider_t, total_d - skin_t, leg_h + (total_h*0.25)])
        cube([door_w, skin_t*2, door_h]);
}

// ─────────────────────────────
// DIAGNOSTIC TOOLS — on-demand only, never called from ASSEMBLY
// ─────────────────────────────
// v53 (vm01-clearance-zone-map-skill-and-application): targeted clearance
// color map for a named suspect pair. See .claude/SKILL_clearance_zone_map.md
// for the full procedure, band definitions, and the OpenSCAD children()
// idiom this uses instead of the unsupported "pass a module as a value"
// pattern. NOT wired into ASSEMBLY — invoke only via a scratch include
// during active diagnosis, per that skill file's own "Do NOT" list.
module clearance_zone_map(bands=[[0,"red"],[0.5,"orange"],[2,"yellow"]]) {
    // children(0) = part A (the one that gets inflated), children(1) = part B
    for (b = bands) {
        offset = b[0]; col = b[1];
        color(col, 0.85)
        intersection() {
            if (offset == 0) {
                children(0);   // sphere(r=0) is degenerate -- skip minkowski at 0mm
            } else {
                minkowski() {
                    children(0);
                    sphere(r=offset, $fn=16);   // low $fn -- diagnostic inflation, not final geometry
                }
            }
            children(1);
        }
    }
}

// ─────────────────────────────
// ─────────────────────────────
// RENDER MODE — set before export
// ─────────────────────────────
// "standard" → STANDARD: shell intact, acrylic panels removed → see through window → VM-01-v38-std.stl
// "full"     → FULL EXTERIOR: everything including acrylic (fully opaque) → VM-01-v38-full.stl
// "open"     → OPEN/C2: set show_shell_top/left=false below for inspection → VM-01-v38-C2.stl
render_mode = "standard";

// DEBUG TOGGLES — used in "open" (C2) mode to remove shell panels
// ─────────────────────────────
show_shell_back   = true;
show_shell_top    = true;   // set false for C2 export
show_shell_bottom = true;   // set false for C2 export -- NEW v51 TASK 2
show_shell_left   = true;   // set false for C2 export
show_shell_right  = true;

// VIEWER TOGGLES (v41) — for multi-state STL export
// ─────────────────────────────
door_open    = false;   // true -> left_zone_door() leaf swung open (door_open_deg) for viewer STL
flap_open    = false;   // true -> exit flap swung open (flap_open_deg) for viewer STL
tray_out_pct = 0;        // 0-1, e.g. 0.3 -> tray slid 30% of tray_d out the front

// ISOLATION TOGGLES (v42/v44/v45) — for manifold-debug inspection
// ─────────────────────────────
show_door    = true;   // false -> hide left_zone_door() entirely, for inspecting the shell's left-wall cutout underneath
show_acrylic = true;   // false -> hide the acrylic pane independent of render_mode (v44: no longer render_mode-gated, see TASK 2)
show_flap    = true;   // false -> hide the exit flap independent of show_door
show_sensor  = true;   // v44 TASK 1: false -> hide both real sensor strips (fabricated center beam removed entirely, not toggled)
show_frame   = true;   // v45: false -> hide tray_zone_frame() entirely, for inspecting/isolating the H-frame independent of the door and shell (Toggle-Completeness Rule, cc_rules.md)

// ─────────────────────────────
// ASSEMBLY
// ─────────────────────────────

legs();

// Outer shell — shown in all modes (debug toggles control which panels visible)
translate([0, 0, leg_h]) outer_shell_debug();

compartment_divider();

tray_rack();
for (t = [0:tray_count-1]) spring_tray(t);

// Acrylic panels — only in "full" mode (removing them = see-through window effect)
// left_zone_door()'s inset acrylic window (v44: gated on show_acrylic alone, see TASK 2 — no longer tied to render_mode)
if (render_mode == "full") {
    acrylic_display();      // acrylic right upper zone (unrelated part, unchanged)
}

if (show_door) left_zone_door();  // v42: full-height left-zone door — isolable via show_door
flap_stopper_rod();               // v42: static, always visible regardless of show_door/show_flap
if (show_frame) tray_zone_frame();  // v45: isolable via show_frame — structural frame
drop_zone_guards();     // v43 §2.6: real solid side guards, replaces drop_zone_visual()
tray_compartment_partition();  // v46 TASK 1: fixed/welded, safety-critical (PART_MANIFEST.md) — always on
exit_compartment_wall();       // v46 TASK 1: fixed/welded, safety-critical (PART_MANIFEST.md) — always on

sensor_strip();         // parallel strips at Z=280

dashboard();            // screen + QR + card reader
rear_service_door();
