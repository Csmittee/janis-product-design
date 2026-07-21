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

include <BBQ-understructure-v7.scad>

// ASSEMBLY — the included file already calls both its own geometry AND
// (transitively) the chamber's, at include time (see each file's own
// DEBUG TOGGLES / ASSEMBLY section). This file adds no further geometry.
