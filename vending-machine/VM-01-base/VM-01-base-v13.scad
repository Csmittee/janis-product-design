// VM-01 Base Vending Machine
// Janis Product Design
// Version: v13
// Date: 2026-06-27
// Units: mm
// Purpose: Smart donation vending machine — buddha ornaments
// Payment: Online only, no cash/coin mechanism
//
// Changes from v12:
//   Fix 1: outer_shell opacity restored to 0.75 (solid shell).
//           left_front_acrylic() opacity updated to 0.25 (front face only transparent).
//   Fix 2: exit_door_h declared BEFORE tray_0_z — resolves 'undefined variable' warnings.

$fn = 64;

// ─────────────────────────────
// PARAMETERS
// ─────────────────────────────

total_w = 620;
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
system_w = 185;
divider_t = 19;

// Spring / Tray
spring_od = 66;
spring_l = 390;
motor_d = 60;
spring_gap = 20;
spring_lanes = 5;
tray_count = 2;
tray_floor_t = 5;
tray_wall_t = 3;
spring_clearance = 50;
tray_h = 121;           // floor(5) + spring_od(66) + clearance(50)
partition_h = 40;
tray_d = spring_l + motor_d;  // 450mm

// Exit zone — declared here so tray zone calculations below can reference it
exit_door_h = 250;
exit_door_w = 400;

// Tray zone — depends on exit_door_h
tray_zone_h = tray_h * tray_count;         // 242mm
tray_0_z = leg_h + exit_door_h;            // 300mm
tray_zone_top_z = tray_0_z + tray_zone_h;  // 542mm
upper_display_h = total_h - tray_zone_top_z; // 158mm

// Zones
drop_zone_d = 138;
tray_start_d = drop_zone_d;

// Customer pickup flap
flap_h = 100;
flap_w = 250;
flap_t = 3;

// Tray rack
rail_w = 10;
rail_h = 10;
latch_pin_d = 8;
latch_pin_l = 15;

// Door / panel
door_t = 3;
hinge_od = 12;
hinge_h = 20;

// Frame bars
frame_bar = 20;

// Dashboard
dash_x = product_w + divider_t + skin_t;
dash_w = system_w - divider_t - (skin_t * 2);
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
    color("#888888")
    difference() {
        cylinder(h=spring_l, d=spring_od);
        cylinder(h=spring_l+1, d=spring_od-10);
    }
}

// Motor at BACK. Spring front end at Y=0 (drop zone boundary). Products fall forward.
module spring_tray(tray_num) {
    tray_w = product_w - 20;
    z = leg_h + exit_door_h + (tray_num * tray_h);

    translate([10, tray_start_d, z]) {
        color("#CCCCCC")
        difference() {
            union() {
                cube([tray_w, tray_d, tray_floor_t]);
                translate([0, tray_d - tray_wall_t, 0])
                    cube([tray_w, tray_wall_t, tray_h]);
                cube([tray_wall_t, tray_d, tray_h]);
                translate([tray_w - tray_wall_t, 0, 0])
                    cube([tray_wall_t, tray_d, tray_h]);
            }

            // Left side wall window
            translate([-1, tray_wall_t, tray_floor_t + tray_wall_t])
                cube([tray_wall_t + 2,
                      tray_d - (tray_wall_t * 2),
                      tray_h - tray_floor_t - (tray_wall_t * 2)]);

            // Right side wall window
            translate([tray_w - tray_wall_t - 1, tray_wall_t, tray_floor_t + tray_wall_t])
                cube([tray_wall_t + 2,
                      tray_d - (tray_wall_t * 2),
                      tray_h - tray_floor_t - (tray_wall_t * 2)]);

            // Rear motor mount cutouts
            for (i = [0:spring_lanes-1]) {
                x = tray_wall_t + spring_od/2 + i*(spring_od + spring_gap);
                translate([x - 11, tray_d - tray_wall_t - 1, tray_floor_t])
                    cube([22, tray_wall_t + 2, 35]);
            }

            // Rear latch pin hole
            translate([tray_w/2, tray_d - tray_wall_t - 1, tray_h/2])
                rotate([-90, 0, 0])
                    cylinder(d=latch_pin_d, h=tray_wall_t + 2);
        }

        // Springs + motors — motor at back, spring front at Y=0
        for (i = [0:spring_lanes-1]) {
            x = tray_wall_t + spring_od/2 + i*(spring_od + spring_gap);

            color("#555555")
            translate([x-10, tray_d - motor_d, tray_floor_t])
                cube([20, motor_d, 35]);

            color("#999999")
            translate([x, tray_d - motor_d, tray_floor_t + spring_od/2])
                rotate([90, 0, 0])
                    spring_coil();

            if (i < spring_lanes-1) {
                color("#BBBBBB")
                translate([x + spring_od/2 + spring_gap/2, tray_wall_t, tray_floor_t])
                    cube([2, tray_d-(tray_wall_t*2), partition_h]);
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

// FIX 1: opacity restored to 0.75 — solid shell, all faces opaque.
// Left front face is cut out; left_front_acrylic() provides the transparent front.
module outer_shell() {
    color("#C8C8C8", 0.75)
    difference() {
        rounded_box(total_w, total_h, total_d, corner_r);

        // Hollow interior — height total_h-skin_t preserves roof skin at top
        translate([skin_t, skin_t, skin_t])
            rounded_box(total_w-(skin_t*2), total_h-skin_t, total_d-(skin_t*2), corner_r-1);

        // Left product zone front: full height Z 50-700 (covered by left_front_acrylic)
        translate([skin_t, -1, leg_h])
            cube([product_w-(skin_t*2), skin_t+2, tray_zone_top_z - leg_h]);

        // Exit zone internal chute cutout (Z 50-300)
        translate([(product_w - exit_door_w)/2, -1, leg_h])
            cube([exit_door_w, skin_t+2, exit_door_h]);

        // Upper front display cutout (Z 542-700)
        translate([skin_t, -1, tray_zone_top_z])
            cube([product_w-(skin_t*2), skin_t+2, upper_display_h]);

        // Right compartment front face opening — dashboard visible
        translate([product_w + divider_t, -1, leg_h])
            cube([system_w - divider_t - skin_t, skin_t+2, tray_zone_top_z - leg_h]);
    }
}

module compartment_divider() {
    color("#AAAAAA", 0.9)
    translate([product_w, skin_t, leg_h])
        cube([divider_t, total_d-(skin_t*2), total_h - leg_h]);
}

// Front door — EXIT ZONE ONLY (Z 50-300). Spring zone above is open.
module front_door() {
    door_h = exit_door_h;   // 250mm

    color("#C0C0C0", 0.6)
    translate([skin_t, 0, leg_h])
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

// Acrylic customer selection panel — left product zone, Z 300-542.
module spring_zone_panel() {
    panel_x = skin_t;
    panel_w = product_w - (skin_t * 2);     // 412mm
    panel_z = leg_h + exit_door_h;          // 300mm world Z
    panel_h = tray_h * tray_count;          // 242mm (Z 300-542)
    panel_t = door_t;                       // 3mm

    color("#ADD8E6", 0.15)
    translate([panel_x, 0, panel_z])
        cube([panel_w, panel_t, panel_h]);

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

// FIX 1: Left front acrylic panel — full left product zone, Z 50-700.
// opacity 0.25 — customer sees springs, trays, products through front face.
module left_front_acrylic() {
    panel_x = skin_t;
    panel_w = product_w - (skin_t * 2);     // 412mm
    panel_z = leg_h;                         // Z=50mm
    panel_h = total_h - leg_h;              // 650mm (Z 50-700)
    panel_t = door_t;                        // 3mm

    color("#ADD8E6", 0.25)
    translate([panel_x, 0, panel_z])
        cube([panel_w, panel_t, panel_h]);
}

// Structural frame around spring display zone.
module tray_zone_frame() {
    color("#AAAAAA")
    union() {
        translate([0, 0, tray_zone_top_z - frame_bar])
            cube([product_w, skin_t, frame_bar]);
        translate([0, 0, tray_0_z])
            cube([product_w, skin_t, frame_bar]);
        translate([0, 0, tray_0_z])
            cube([frame_bar, skin_t, tray_zone_h]);
        translate([product_w - frame_bar, 0, tray_0_z])
            cube([frame_bar, skin_t, tray_zone_h]);
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
        cube([product_w - (skin_t*2) - (strip_t*2), 1, 1]);
}

// ATM dashboard — right compartment.
// screen_y = -30mm (protrudes 30mm forward of front face).
module dashboard() {
    screen_z = screen_center_z - screen_h/2;  // 230mm
    qr_z     = screen_z - 50 - qr_h;          // 150mm
    card_z   = qr_z - 30 - card_h;            // 112mm
    speaker_z = card_z - 20 - speaker_h;       // 72mm

    color("#1A1A1A")
    translate([product_w + divider_t + 10, screen_y, screen_z])
        rotate([-30, 0, 0])
            cube([screen_w, 5, screen_h]);

    color("#333333", 0.8)
    translate([product_w + divider_t + 10 - bezel_t,
               screen_y - 2, screen_z - bezel_t])
        rotate([-30, 0, 0])
            cube([screen_w + (bezel_t*2), 3, screen_h + (bezel_t*2)]);

    color("#444444")
    translate([dash_x + dash_w/2, screen_y, screen_z])
        hull() {
            translate([-screen_w/2, 0, 0])
                rotate([-90, 0, 0]) cylinder(r=bracket_r, h=30);
            translate([screen_w/2, 0, 0])
                rotate([-90, 0, 0]) cylinder(r=bracket_r, h=30);
        }

    color("#222222")
    translate([dash_x + (dash_w - qr_w)/2, 0, qr_z])
        cube([qr_w, qr_d, qr_h]);

    color("#333333")
    translate([dash_x + (dash_w - card_w)/2, 0, card_z])
        cube([card_w, card_d, card_h]);

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
    translate([acrylic_front_x, skin_t, acrylic_bot_z])
        hull() {
            translate([acrylic_r, 0, acrylic_r])
                rotate([-90,0,0]) cylinder(r=acrylic_r, h=acrylic_t);
            translate([acrylic_front_w-acrylic_r, 0, acrylic_r])
                rotate([-90,0,0]) cylinder(r=acrylic_r, h=acrylic_t);
            translate([acrylic_r, 0, acrylic_zone_h-acrylic_r])
                rotate([-90,0,0]) cylinder(r=acrylic_r, h=acrylic_t);
            translate([acrylic_front_w-acrylic_r, 0, acrylic_zone_h-acrylic_r])
                rotate([-90,0,0]) cylinder(r=acrylic_r, h=acrylic_t);
        }

    color("#ADD8E6", 0.3)
    translate([total_w - skin_t, skin_t, acrylic_bot_z])
        cube([skin_t, total_d-(skin_t*2), acrylic_zone_h]);

    color("#ADD8E6", 0.3)
    translate([acrylic_front_x, skin_t, total_h - skin_t])
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
// ASSEMBLY
// ─────────────────────────────

legs();
translate([0, 0, leg_h]) outer_shell();
compartment_divider();

tray_rack();
for (t = [0:tray_count-1]) spring_tray(t);

front_door();           // exit zone only, Z 50-300
flap_door();            // customer pickup, 100mm x 250mm
spring_zone_panel();    // acrylic customer selection panel, Z 300-542
left_front_acrylic();   // full left zone acrylic front face, Z 50-700 (#ADD8E6 0.25)
tray_zone_frame();      // structural frame around spring display zone
drop_zone_visual();

sensor_strip();         // parallel strips left+right at Z=280

dashboard();            // screen protrudes 30mm forward
acrylic_display();
rear_service_door();
