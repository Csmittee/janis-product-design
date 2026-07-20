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

include <BBQ-understructure-v5.scad>

// ASSEMBLY — the included file already calls both its own geometry AND
// (transitively) the chamber's, at include time (see each file's own
// DEBUG TOGGLES / ASSEMBLY section). This file adds no further geometry.
