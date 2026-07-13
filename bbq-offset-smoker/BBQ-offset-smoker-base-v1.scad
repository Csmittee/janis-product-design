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
// Only BBQ-understructure.scad is included here (not BBQ-chambers-v1.scad
// directly too) — it already `include`s the chambers file itself for its
// own datum access, and OpenSCAD has no include-guard, so including both
// here would render the chamber assembly twice (harmless to CGAL manifold
// status but wasteful/confusing) — R-009 duplication-check caught this
// before it shipped, see cc_chat_log.md.

include <BBQ-understructure.scad>

// ASSEMBLY — the included file already calls both its own geometry AND
// (transitively) the chamber's, at include time (see each file's own
// DEBUG TOGGLES / ASSEMBLY section). This file adds no further geometry.
