// VM-01 Base Vending Machine
// Janis Product Design
// Version: v32
// Date: 2026-06-29
// Units: mm
// Purpose: Smart donation vending machine — buddha ornaments
// Payment: Online only, no cash/coin mechanism
//
// Changes from v31:
//   Fix 1: tray_rack() latch pin length 15 → 10mm. Pin was reaching outer back shell at 600mm.
//           Pin now ends at tray_start_d+tray_d-tray_wall_t+10 = 595mm, 3mm clear of shell inner face.
//           Acts as tray-push stopper, stays inside machine cavity. No hole needed in outer shell.
//   Fix 2: Debug toggles moved from PARAMETERS section to just above ASSEMBLY — easier to find and flip.

$fn = 64;

// ─────────────────────────────
// PARAMETERS
// ─────────────────────────────

total_w = 640;
total_h = 700;
total_d = 600;
corner_r = 20;
skin_t = 2;

// Legs
leg_h = 50;
leg_od = 25;
leg_inset = 40;

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

// Tray zone
tray_zone_h = tray_h * tray_count;         // 242mm
exit_door_h = 250;
tray_0_z = leg_h + exit_door_h;            // 300mm
tray_zone_top_z = tray_0_z + tray_zone_h;  // 542mm
upper_display_h = total_h - tray_zone_top_z; // 158mm
panel_zone_top_z = total_h;                  // 700mm
panel_zone_h = panel_zone_top_z - tray_0_z;  // 400mm (Z 300-700)

// Zones
drop_zone_d = 138;
tray_start_d = drop_zone_d;

// Exit zone
exit_door_w = 400;

// Customer pickup flap
flap_h = 100;
flap_w = 250;
flap_t = 3;

// Tray rack
rail_w = 10;
rail_h = 10;
latch_pin_d = 8;
latch_pin_l = 10;   // 15 → 10: pin stays inside cavity, clears outer shell back face at 598mm

// Door / panel
door_t = 3;
hinge_od = 12;
hinge_h = 20;

// Frame bars
frame_bar = 20;

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

// Epsilon — prevents z-fighting on coincident front faces
e = 0.01;

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

module leg() {
    color("#AAAAAA")
    cylinder(h=leg_h, d=leg_od);
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
    cylinder(h=spring_l - 2, d=spring_od);  // -2mm clears motor face, visual only
}

// Motor at BACK. Spring front end at Y=0 (drop zone boundary). Products fall forward.
module spring_tray(tray_num) {
    tray_w = product_w - 20;
    z = leg_h + exit_door_h + (tray_num * tray_h);

    translate([10, tray_start_d, z]) {
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

            // Motor: lifted e off floor, rear face at tray_d-tray_wall_t-2e (fully inside hollow)
            color("#555555")
            translate([x-10, tray_d - motor_d - tray_wall_t - e, tray_floor_t + e])
                cube([20, motor_d - e, 35]);

            // Spring coil: lifted e off floor, pulled e from rear wall
            color("#999999")
            translate([x, spring_l + e, tray_floor_t + spring_od/2 + e])
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
    tray_w = product_w - 20;
    color("#AAAAAA")
    for (t = [0:tray_count-1]) {
        z = leg_h + exit_door_h + (t * tray_h);
        translate([10, tray_start_d, z - rail_h])
            cube([rail_w, tray_d, rail_h]);
        translate([10 + tray_w - rail_w, tray_start_d, z - rail_h])
            cube([rail_w, tray_d, rail_h]);
        translate([10 + tray_w/2, tray_start_d + tray_d - tray_wall_t, z + tray_h/2])
            rotate([-90, 0, 0])
                cylinder(d=latch_pin_d, h=latch_pin_l);
    }
}

module outer_shell() {
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
    }
}

module outer_shell_debug() {
    color("#C8C8C8", 0.75)
    difference() {
        rounded_box(total_w, total_h, total_d, corner_r);

        // Hollow interior
        translate([skin_t, skin_t, skin_t])
            rounded_box(total_w-(skin_t*2), total_h-(skin_t*2), total_d-(skin_t*2), corner_r-1);

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

        // Back panel — removed when show_shell_back = false
        if (!show_shell_back)
            translate([0, total_d - skin_t - 1, 0])
                cube([total_w, skin_t + 2, total_h]);

        // Top panel — removed when show_shell_top = false
        if (!show_shell_top)
            translate([0, 0, total_h - skin_t - 1])
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

module compartment_divider() {
    color("#AAAAAA", 0.9)
    translate([product_w, skin_t, leg_h])
        cube([divider_t, total_d-(skin_t*2), total_h - leg_h - skin_t]);
}

// Front door — EXIT ZONE ONLY (Z 50-300). Spring zone above is open.
module front_door() {
    door_h = exit_door_h;   // 250mm

    color("#888888", 0.9)
    translate([skin_t, e, leg_h])
        cube([product_w-(skin_t*2), door_t, door_h]);

    hinge_positions = [
        leg_h + door_h * 0.2,
        leg_h + door_h * 0.5,
        leg_h + door_h * 0.8
    ];
    for (hz = hinge_positions) {
        color("#888888")
        translate([skin_t, 0, hz])
            cylinder(d=hinge_od, h=hinge_h);
    }
}

// Customer pickup flap — bottom of exit zone.
module flap_door() {
    color("#B0B0B0", 0.9)
    translate([(product_w - flap_w)/2, skin_t, leg_h])
        cube([flap_w, flap_t, flap_h]);
}

// Acrylic customer selection panel — left product zone, Z 300-700 (full left zone above exit door).
module spring_zone_panel() {
    panel_x = skin_t;                       // left edge of product zone
    panel_w = product_w - (skin_t * 2);     // 412mm — left product zone only
    panel_z = leg_h + exit_door_h;          // 300mm world Z
    panel_h = total_h - (leg_h + exit_door_h); // 400mm (Z 300-700)
    panel_t = door_t;                       // 3mm

    // See-through acrylic panel — left product zone front, Z 300-700
    color("#ADD8E6", 0.15)
    translate([panel_x, e, panel_z])
        cube([panel_w, panel_t, panel_h]);

    // 3 hinges on left edge
    hinge_zs = [
        panel_z + panel_h * 0.2,
        panel_z + panel_h * 0.5,
        panel_z + panel_h * 0.8
    ];
    for (hz = hinge_zs) {
        color("#888888")
        translate([panel_x, 0, hz])
            cylinder(d=hinge_od, h=hinge_h);
    }
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

// Structural frame — matches spring_zone_panel() Z 300-700.
// Top/bottom bars span full width and own the corner regions.
// Side bars span only the middle — no shared edges at corners.
module tray_zone_frame() {
    color("#AAAAAA")
    union() {
        // Top bar — full width, owns top corners — Z 700
        translate([0, e*2, panel_zone_top_z - frame_bar])
            cube([product_w, skin_t, frame_bar]);
        // Bottom bar — full width, owns bottom corners — Z 300
        translate([0, e*2, tray_0_z])
            cube([product_w, skin_t, frame_bar]);
        // Left bar — middle only, Z 300+frame to 700-frame
        translate([0, e*2, tray_0_z + frame_bar])
            cube([frame_bar, skin_t, panel_zone_h - (frame_bar * 2)]);
        // Right bar — middle only, Z 300+frame to 700-frame
        translate([product_w - frame_bar, e*2, tray_0_z + frame_bar])
            cube([frame_bar, skin_t, panel_zone_h - (frame_bar * 2)]);
    }
}

// Parallel sensor strips — left and right walls at Z=280mm.
module sensor_strip() {
    strip_z = tray_0_z - 20;   // 280mm
    strip_t = 5;
    strip_h = 8;

    color("#222222")
    translate([skin_t, skin_t, strip_z])
        cube([strip_t, drop_zone_d, strip_h]);

    color("#222222")
    translate([product_w - skin_t - strip_t, skin_t, strip_z])
        cube([strip_t, drop_zone_d, strip_h]);

    color("#FF0000", 0.3)
    translate([skin_t + strip_t,
               skin_t + drop_zone_d/2,
               strip_z + strip_h/2])
        cube([product_w - (skin_t*2) - (strip_t*2), 2, 2]);
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

    color("#ADD8E6", 0.3)
    translate([total_w - (skin_t*2), skin_t, acrylic_bot_z])
        cube([skin_t, total_d-(skin_t*2), acrylic_zone_h]);

    color("#ADD8E6", 0.3)
    translate([acrylic_front_x, skin_t, total_h - (skin_t*2)])
        cube([acrylic_front_w, total_d-(skin_t*2), skin_t]);
}

module drop_zone_visual() {
    color("#F0F0F0", 0.15)
    translate([skin_t, skin_t, leg_h])
        cube([product_w-(skin_t*2), drop_zone_d, exit_door_h]);
}

module rear_service_door() {
    door_w = system_w - divider_t;
    door_h = total_h * 0.5;
    color("#B8B8B8", 0.6)
    translate([product_w + divider_t, total_d - skin_t, leg_h + (total_h*0.25)])
        cube([door_w, skin_t*2, door_h]);
}

// ─────────────────────────────
// DEBUG TOGGLES — flip to false to hide a panel and inspect interior zones
// ─────────────────────────────
show_shell_back  = true;   // false → inspect motor/rear wall contact
show_shell_top   = true;   // false → inspect tray zone from above
show_shell_left  = true;   // false → inspect spring lanes from left
show_shell_right = true;   // false → inspect dashboard/screen from right

// ─────────────────────────────
// ASSEMBLY
// ─────────────────────────────

legs();
translate([0, 0, leg_h]) outer_shell_debug();
compartment_divider();

tray_rack();
for (t = [0:tray_count-1]) spring_tray(t);

front_door();           // exit zone only, Z 50-300
flap_door();            // customer pickup, 100mm x 250mm
spring_zone_panel();    // acrylic customer selection panel, Z 300-700
tray_zone_frame();      // structural frame around spring display zone
drop_zone_visual();

sensor_strip();         // parallel strips left+right at Z=280

dashboard();            // screen protrudes 30mm forward
acrylic_display();
rear_service_door();
