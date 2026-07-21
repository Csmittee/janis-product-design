// BBQ Offset Smoker — Base Assembly
// Version: v1
// Date: 2026-07-13
// Changes from: N/A (first version)
//
// SOURCE: prompts/bbq-offset-smoker-v1-init-cc-prompt.md, TASK 4.
// Thin assembly file — positions Cook Chamber on Understructure's
// mounting plane per the confirmed consecutive-parent chain
// (SKELETON_WORKSHEET.md Part A). No extra translate is needed: both
// files already share MASTER ORIGIN (0,0,0 at floor level, front-left)
// as their own local origin, and BBQ-understructure.scad's leg_h is
// DERIVED from BBQ-chambers-v1.scad's chamber_floor_z directly (not a
// second independent copy) — so the two are already co-registered in
// world space by construction.
//
// Only the understructure file is included here (not a chambers file
// directly too) — it already `include`s the chambers file itself for its
// own datum access, and OpenSCAD has no include-guard, so including both
// here would render the chamber assembly twice (harmless to CGAL manifold
// status but wasteful/confusing) — R-009 duplication-check caught this
// before it shipped, see cc_chat_log.md.
//
// 2026-07-17: include target updated BBQ-understructure.scad ->
// BBQ-understructure-v2.scad (bbq-understructure-v2-axles-swivel-handle —
// the understructure file now follows the same versioned-filename
// convention the chambers files already use; v1 kept unchanged as
// BBQ-understructure-v1.scad, per file-versioning convention).
//
// 2026-07-17: include target updated v2->v3 (bbq-understructure-v3-wheel-
// height-tray-handle — wheel size/count, GROUND_OFFSET height lift, tray
// reattachment, coupled-steering T-bar handle; v2 kept unchanged, on
// record, as BBQ-understructure-v2.scad).
//
// 2026-07-17: include target updated v3->v4 (bbq-chambers-v12-firebox-
// rebuild-understructure-v4-wheel — firebox rebuilt to real insulated-
// jacket dimensions + new internal fuel cylinder (BBQ-chambers-v12.scad,
// source v11), 18" wheel size correction + real world-Z=0 wheel-ground
// anchor fix (BBQ-understructure-v4.scad, source v3, itself includes
// BBQ-chambers-v12.scad). v3 kept unchanged, on record, as
// BBQ-understructure-v3.scad. REAL, CONFIRMED, UNRESOLVED ISSUE carried
// into this include (see both source files' own headers and
// cc_chat_log.md): the wheel-size/anchor fix causes a real, CGAL-confirmed
// ~6mm collision between the front wheels and the (explicitly frozen this
// round) front bracket legs/caster plate/tow triangle — flagged, not
// fixed, blocking real fabrication until a follow-up prompt reworks the
// front bracket.
//
// 2026-07-20: include target updated v4->v5 (bbq-understructure-v5-
// trackwidth-fender-tbar — pointer bump to BBQ-chambers-v14.2.scad (was
// still wired to v13 through 3 chamber rounds), shared 1080mm TRACK_WIDTH
// front+rear (resolves the ~6mm front-wheel/bracket collision noted above,
// real CGAL-confirmed), round front-bracket tip, rear wheel reposition +
// new fender, front U-bracket drop length = firebox_floor_z, T-bar real
// live length + 90deg default-vertical fix (BBQ-understructure-v5.scad,
// source v4, itself includes BBQ-chambers-v14.2.scad). v4 kept unchanged,
// on record, as BBQ-understructure-v4.scad. See BBQ-understructure-v5.scad's
// own header + cc_chat_log.md for the real flagged T-bar/roof-clearance
// variance found this round (unrelated to the collision this include
// resolves).

// 2026-07-20: bbq-chambers-v15-square-shell-cylinder-firebox — real
// structural firebox redesign (outer shell rebuilt as a true 580x580x580
// cube, inner rectangular duct replaced by a 456mm-dia fire cylinder) —
// BBQ-chambers-v15.scad exists and is real-CGAL-verified standalone.
//
// 2026-07-20: include target updated v5->v6 (bbq-understructure-v6-
// fitment-fixes — v6's own TASK 0 bumps its own include to
// BBQ-chambers-v15.scad, wiring v15 into the full assembly chain for the
// first time. 4 real fitment fixes from Janis's live desktop review of
// v5: prep shelf multi-point flush mount (was cantilevered from a single
// point), track width recomputed to 980mm (100mm wheel-to-firebox gap,
// was 150mm), rear fender rebuilt as a short flared wing (was a long
// straight panel), T-bar bracket now mounts at the front axle's own real
// plane with a curved gusset (was floating 100mm above it). Real,
// automatic consequences of v15's own firebox reanchor: LEG_DROP/
// REAR_BRACKET_H/FRONT_SPACER_LEN/REAR_AXLE_X all recompute via their own
// unchanged live formulas. Real, CGAL-confirmed: the standing front-wheel/
// bracket collision re-check (TASK 8) remains resolved at the new
// geometry. v5 kept unchanged, on record, as BBQ-understructure-v5.scad.
// See BBQ-understructure-v6.scad's own header + cc_chat_log.md for full
// detail.

// 2026-07-21: include target updated v6->v7 (Janis's own DIRECT feedback
// round, not a new CC prompt — real fixes to 4 firebox defects (v7's own
// include bumps to BBQ-chambers-v16.scad: passage shape now derived from
// the chamber's real available octagon material instead of an independent
// circle formula, fire_cylinder_end_cap()/outer_shell flange rebuilt
// two-zone octagon-top/native-shape-bottom, FLANGE_LEN 20->50mm additive)
// plus a real rear-fender rebuild (flat plate + tangent-arc flare,
// grounded in the ORIGINAL v5 prompt's own written spec text — v6's own
// full-arc-from-the-wall design was still the wrong shape per Janis's
// direct annotated feedback). v6 kept unchanged, on record, as
// BBQ-understructure-v6.scad. See BBQ-understructure-v7.scad's own header
// + cc_chat_log.md for full detail.

// 2026-07-21: include target updated v7->v8 (Janis's own SECOND round of
// direct feedback on the same day — 2 real chamber defects the v7 round's
// own fixes introduced/left unaddressed, plus a real pre-existing
// understructure bug found this round: (1) the outer shell's own flange
// (v16 TASK C's own octagon-clip) was found via a real CGAL probe to
// solid-fill ~48.5mm of the chamber's own real hollow interior bore — a
// genuine, un-asked-for wall blocking the chamber's interior, confirmed
// non-empty via `intersection()` against the chamber's own real hollow
// cavity solid. (2) that same octagon-clip was ALSO found, via re-
// rendering before shipping, to carve a real hole with NO material from
// either part wherever the firebox's own 580mm square exceeds the
// octagon's real width — matching Janis's own separate "missing...end
// cap that should stretch to fuse with the chamber shell" finding. Both
// fixed via one real redesign in BBQ-chambers-v17.scad: the flange's own
// OUTER boundary is now always the full continuous square (matches the
// main body everywhere, zero notches) with ONLY the chamber's own real
// hollow-bore shape cut out of it (not clipped to the octagon's outer
// edge at all) — re-verified via CGAL: EMPTY vs the chamber's own hollow
// cavity (2mm real margin), NON-EMPTY vs the chamber's own real wall
// material. (3) `prep_shelves()`'s own right-side shelf used `mirror()`
// AFTER an already-applied `translate()`, reflecting the pre-positioned
// geometry back around Y=0 instead of onto the opposite side — both
// shelves landed on the same (left) side (real Y-extent [-610,0],
// confirmed via a real STL vertex probe), matching Janis's own "bad tray
// stack in each other" — fixed in BBQ-understructure-v8.scad by dropping
// the unnecessary mirror() and translating directly to the chamber's own
// right edge. Also NEW this round: 4 real firebox sub-part toggles
// (`show_fire_cylinder`/`show_fire_cylinder_end_cap`/`show_outer_shell`/
// `show_outer_shell_end_cap`) per Janis's own explicit request, so future
// issues can be isolated and reported precisely. v7 kept unchanged, on
// record, as BBQ-understructure-v7.scad. See BBQ-understructure-v8.scad's
// own header + cc_chat_log.md for full detail.

// 2026-07-21: include target updated v8->v9 (pure pointer bump, Janis's own
// SAME-DAY QA-simulation round following the new "Dual End-Cap
// Independence Convention" governance lock in rules-bbq-fab.md — v9's own
// understructure geometry UNCHANGED from v8, its `include` bumped to
// BBQ-chambers-v18.scad, whose own real fix rebuilds
// outer_shell_flange_footprint_2d() via `union()` (square + true octagon
// profile, then subtract the chamber's own real hollow-cavity hole) —
// NOT the `intersection()` v16 originally tried (created a real missing-
// material gap, since the chamber has zero material outside the octagon's
// own true edge) nor v17's own always-plain-square dodge (avoided the two
// known CGAL-confirmed bugs but never actually satisfied Rule 1's own
// "meets the octagon face" requirement). Confirmed via a direct walkthrough
// of Janis's own 4-step QA simulation, then re-verified via CGAL: EMPTY vs
// the chamber's own hollow cavity, NON-EMPTY vs the chamber's own real
// wall material. v8 kept unchanged, on record, as
// BBQ-understructure-v8.scad. See BBQ-chambers-v18.scad's own header +
// cc_chat_log.md for full detail.

// 2026-07-21: include target updated v9->v10 (pure pointer bump — Janis's
// own closer visual inspection of v18/v9 found 2 real remaining issues:
// (1) fire_cylinder_end_cap_2d() still had a real, visible hole — same
// failure class as the outer shell's own Rule 1 fix (intersection() with
// the octagon clips the circle down wherever the octagon is locally
// narrower, and the chamber has zero material outside its own true edge
// to fill what gets clipped away) — v18's own QA Step 2 never actually
// checked this specific end cap for the same defect. Fixed via the SAME
// Dual End-Cap Footprint Pattern (rules-codes.md/.claude/SKILL_joint_
// construction.md RULE 4): union(circle, octagon) bounded by the
// cylinder's own real diameter box, minus the shared passage cut — real
// CGAL/STL re-verified: end cap now always ≥ the native circle (2mm real
// margin), real weld contact with the chamber's own wall material
// preserved, own real bbox exactly matches the cylinder's own diameter
// envelope (no overreach). (2) `ash_tray()` RETIRED entirely, per Janis's
// own explicit instruction ("just remove this tray, keep cylinder
// clean") — R-009, zero remaining consumers confirmed via grep before
// removing (module + its own ASH_TRAY_* constants + the
// `ash_tray_out_pct` parameter threading through firebox()/DEBUG TOGGLES,
// all retired together). v9 kept unchanged, on record, as
// BBQ-understructure-v9.scad. See BBQ-chambers-v19.scad's own header +
// cc_chat_log.md for full detail.

include <BBQ-understructure-v10.scad>

// ASSEMBLY — the included file already calls both its own geometry AND
// (transitively) the chamber's, at include time (see each file's own
// DEBUG TOGGLES / ASSEMBLY section). This file adds no further geometry.
