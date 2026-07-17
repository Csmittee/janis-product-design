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

include <BBQ-understructure-v2.scad>

// ASSEMBLY — the included file already calls both its own geometry AND
// (transitively) the chamber's, at include time (see each file's own
// DEBUG TOGGLES / ASSEMBLY section). This file adds no further geometry.
