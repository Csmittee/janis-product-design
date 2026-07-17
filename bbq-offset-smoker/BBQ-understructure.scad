// BBQ Offset Smoker — Understructure
// Version: v1
// Date: 2026-07-13
// Changes from: N/A (first version)
//
// SOURCE: prompts/bbq-offset-smoker-v1-init-cc-prompt.md, TASK 3.
// Basic placeholder pass, low churn, per the prompt's own instruction —
// simple corner-tube frame + placeholder casters/handle/shelves, not a
// fully detailed weld drawing.
//
// SKELETON — Parent: BBQ-chambers-v4.scad's own DATUM_GRATE_Z chain (leg
// length is DERIVED from chamber_floor_z, not independently set, per the
// prompt's explicit "revised Skeleton chain" instruction). This file
// reads the chambers file's DATUM_* / chamber_* constants directly
// rather than re-deriving a second copy (R-009 duplication-check pattern
// — see cc_chat_log.md).
//
// 2026-07-14: include target updated v3->v4 (direct-cc color/opacity fix,
// R-011 pattern, no prompt file), same flagged-not-silent mechanical
// pattern as v1->v2 and v2->v3 above. v4 changed ONLY color()/opacity at
// the chambers file's own ASSEMBLY call sites (no dimension/datum
// changed), so nothing here in the understructure is affected either way
// — updated purely to keep this file pointed at the live chambers file.
//
// 2026-07-14: include target updated v4->v5 (direct-cc fix, R-011
// pattern, no prompt file — 3 real defects found+fixed: lid-territory end
// gap closure, grill grate Y-range vs the real chamfer boundary, firebox
// passage resize). None of v5's changes touch chamber_floor_z or any
// other datum this file reads (leg_h etc. unaffected) — same
// flagged-not-silent mechanical update pattern as v1->v2->v3->v4 above.
//
// 2026-07-14: include target updated v5->v6 (direct-cc fix, R-011
// pattern, no prompt file — end-cap rebuilt hollow, lid margin widened,
// firebox passage inset widened, GRATE_Z REPOSITIONED 700->750 to align
// with the lid parting line). CHECKED explicitly (not assumed): GRATE_Z's
// own change does NOT affect chamber_floor_z (grate_clearance moved
// 100->150 in lockstep specifically to keep chamber_floor_z at exactly
// 600, unchanged) — and leg_h here derives from chamber_floor_z alone,
// never from GRATE_Z/grate_clearance directly, so leg_h is genuinely
// unaffected, confirmed by reading the live formula below, not assumed.
// Janis's own note ("if 700mm can't be kept, we adjust the
// understructure") does NOT apply here — 700 was NOT kept exactly (now
// 750), but no understructure adjustment was needed as a result.

include <BBQ-chambers-v9.scad>

// ───────────────────────────────
// PARAMETERS — understructure-specific only (chamber datums come from
// the included file above, not re-declared here)
// ───────────────────────────────
LEG_TUBE = 40;              // square tube corner leg, mm
CASTER_CLEARANCE = 50;      // ground clearance under leg bottom
CASTER_D = 100;
LEG_INSET = 30;             // legs inset from chamber footprint corners
SHELF_D = 300;              // fold-up prep shelf depth
SHELF_T = 20;

// leg_h DERIVED from chamber_floor_z, not independently set (per prompt)
leg_h = chamber_floor_z - CASTER_CLEARANCE;   // 600-50=550

// ───────────────────────────────
// legs() — 4 corner-tube legs under the chamber footprint.
// Parent: chamber_floor_z (DERIVED leg_h), DATUM_X_FRONT/REAR, DATUM_Y.
// ───────────────────────────────
module legs() {
    // +LEG_WELD_OVERLAP: legs top out exactly at chamber_floor_z by
    // definition (leg_h is derived from it) -- real shared volume needed
    // for a clean union() with chamber_shell() in the base assembly file,
    // per Rule M-1 (touching faces alone are non-manifold). Real weld
    // joints overlap physically too, not just a mathematical nicety.
    LEG_WELD_OVERLAP = 2;
    for (xp = [DATUM_X_FRONT + LEG_INSET, DATUM_X_REAR - LEG_INSET])
        for (yp = [DATUM_Y_LEFT + LEG_INSET, DATUM_Y_LEFT + chamber_W - LEG_INSET])
            translate([xp - LEG_TUBE/2, yp - LEG_TUBE/2, CASTER_CLEARANCE])
                cube([LEG_TUBE, LEG_TUBE, leg_h + LEG_WELD_OVERLAP]);
}

// ───────────────────────────────
// casters — 2 fixed (firebox/back end) + 2 swivel (chimney/tow end),
// placeholder geometry only, per prompt.
// ───────────────────────────────
module caster(swivel = false) {
    cylinder(d = CASTER_D, h = 30);
    if (swivel) translate([0, 0, 30]) cylinder(d = 20, h = 20);
}
module casters() {
    for (yp = [DATUM_Y_LEFT + LEG_INSET, DATUM_Y_LEFT + chamber_W - LEG_INSET]) {
        translate([DATUM_X_REAR - LEG_INSET, yp, 0]) caster(false);   // fixed, firebox/back end
        translate([DATUM_X_FRONT + LEG_INSET, yp, 0]) caster(true);   // swivel, chimney/tow end
    }
}

// ───────────────────────────────
// tow_handle() — placeholder, at the chimney/front end.
// ───────────────────────────────
module tow_handle() {
    translate([DATUM_X_FRONT - 250, DATUM_Y_CENTER, CASTER_CLEARANCE + leg_h*0.3])
        rotate([0, 90, 0]) cylinder(d = 25, h = 250);
}

// ───────────────────────────────
// prep_shelves() — 2 fold-up shelves, left+right, front of chamber.
// Kinetic: shelf_deployed true (horizontal) / false (vertical-stowed).
// Hinge along the chamber's own side edge, at leg-top height.
// ───────────────────────────────
module prep_shelf(side_y, shelf_deployed = true) {
    translate([DATUM_X_FRONT + LEG_INSET, side_y, CASTER_CLEARANCE + leg_h])
        rotate([shelf_deployed ? 0 : -90, 0, 0])
            cube([chamber_L*0.35, SHELF_D, SHELF_T]);
}
module prep_shelves(shelf_deployed = true) {
    translate([0, -SHELF_D, 0]) prep_shelf(DATUM_Y_LEFT, shelf_deployed);
    translate([0, chamber_W, 0]) mirror([0,1,0]) translate([0,-SHELF_D,0]) prep_shelf(DATUM_Y_LEFT, shelf_deployed);
}

// ───────────────────────────────
// DEBUG TOGGLES
// ───────────────────────────────
show_legs = true;
show_casters = true;
show_tow_handle = true;
show_shelves = true;
shelf_deployed = true;

// ───────────────────────────────
// ASSEMBLY
// ───────────────────────────────
if (show_legs) legs();
if (show_casters) casters();
if (show_tow_handle) tow_handle();
if (show_shelves) prep_shelves(shelf_deployed);
