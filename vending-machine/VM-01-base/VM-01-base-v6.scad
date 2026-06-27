// VM-01 Base Vending Machine
// Janis Product Design
// Version: v6
// Date: 2026-06-27
// Units: mm
// Purpose: Smart donation vending machine — buddha ornaments
// Payment: Online only, no cash/coin mechanism
// Changes from v5:
//   - Tray: full redesign — independent removable units, tray_h=121,
//     floor 5mm, open top, open front, framed side windows, rear latch
//   - New: tray_rack — fixed rails + rear latch pin
//   - New: front_door — single panel, left hinge, z 50-542mm
//   - New: tray_zone_frame — structural frame around tray zone opening
//   - New: dashboard — ATM style right compartment, recessed 30deg screen,
//     QR scanner, ID card slot, speaker grille
//   - Acrylic: 3 faces of right compartment above 430mm to roof
//   - rules-dimensions.md updated

$fn = 64;

// ─────────────────────────────
// PARAMETERS
// ─────────────────────────────

total_w = 620;
total_h = 800;
total_d = 550;
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
motor_d = 20;
spring_gap = 20;
spring_lanes = 5;
tray_count = 2;
tray_floor_t = 5;          // floor thickness — weight bearing
tray_wall_t = 3;           // side and rear wall thickness
spring_clearance = 50;     // space above spring top
tray_h = 121;              // tray_floor_t(5) + spring_od(66) + spring_clearance(50)
tray_gap = 0;
partition_h = 40;

// Tray zone
tray_zone_h = tray_h * tray_count;   // 242mm

// Zones from inside floor
drop_zone_d = 138;
tray_start_d = drop_zone_d;

// Exit door
exit_door_h = 250;
exit_door_w = 400;

// Derived heights
tray_0_z = leg_h + exit_door_h;       // 300mm — tray 0 floor
tray_zone_top_z = tray_0_z + tray_zone_h;  // 542mm

// Tray rack rails
rail_w = 10;
rail_h = 10;
latch_pin_d = 8;
latch_pin_l = 15;

// Front door
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
screen_angle = 30;
screen_center_z = 320;
screen_recess = screen_w * 0.3;    // 30% recess into front panel
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

// Acrylic zone
acrylic_bot_z = 430;
acrylic_top_z = total_h - skin_t;
acrylic_zone_h = acrylic_top_z - acrylic_bot_z;    // 368mm
acrylic_r = 8;
acrylic_t = skin_t;

// IR sensor
sensor_d = 15;
sensor_h = 8;
sensor_gap = 10;

// Lock rod
rod_d = 8;
rod_h = 60;

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

// Independent removable tray unit.
// Front = OPEN, Top = OPEN, sides = framed window, rear = wall with latch hole.
module spring_tray(tray_num) {
    tray_w = product_w - 20;
    tray_d = spring_l + motor_d;
    z = leg_h + exit_door_h + (tray_num * tray_h);

    translate([10, tray_start_d, z]) {

        color("#CCCCCC")
        difference() {
            // Outer tray shell (no top face — open)
            union() {
                // Floor
                cube([tray_w, tray_d, tray_floor_t]);
                // Rear wall
                translate([0, tray_d - tray_wall_t, 0])
                    cube([tray_w, tray_wall_t, tray_h]);
                // Left side wall (full perimeter frame)
                cube([tray_wall_t, tray_d, tray_h]);
                // Right side wall (full perimeter frame)
                translate([tray_w - tray_wall_t, 0, 0])
                    cube([tray_wall_t, tray_d, tray_h]);
            }

            // Window cutout — left side wall (3mm frame, open centre)
            translate([-1, tray_wall_t, tray_floor_t + tray_wall_t])
                cube([tray_wall_t + 2,
                      tray_d - (tray_wall_t * 2),
                      tray_h - tray_floor_t - (tray_wall_t * 2)]);

            // Window cutout — right side wall (3mm frame, open centre)
            translate([tray_w - tray_wall_t - 1, tray_wall_t, tray_floor_t + tray_wall_t])
                cube([tray_wall_t + 2,
                      tray_d - (tray_wall_t * 2),
                      tray_h - tray_floor_t - (tray_wall_t * 2)]);

            // Rear wall — motor mount cutouts (one per lane)
            for (i = [0:spring_lanes-1]) {
                x = tray_wall_t + spring_od/2 + i*(spring_od + spring_gap);
                translate([x - 11, tray_d - tray_wall_t - 1, tray_floor_t])
                    cube([22, tray_wall_t + 2, 32]);
            }

            // Rear wall — latch pin hole (d=8mm, centered)
            translate([tray_w/2, tray_d - tray_wall_t - 1, tray_h/2])
                rotate([-90, 0, 0])
                    cylinder(d=latch_pin_d, h=tray_wall_t + 2);
        }

        // Springs + motors + lane partitions (unchanged from v5)
        for (i = [0:spring_lanes-1]) {
            x = tray_wall_t + spring_od/2 + i*(spring_od + spring_gap);

            color("#555555")
            translate([x-10, 0, tray_floor_t])
                cube([20, motor_d, 30]);

            color("#999999")
            translate([x, motor_d + spring_l, tray_floor_t + spring_od/2])
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

// Fixed rack — two horizontal rails per tray slot, plus rear latch pin.
module tray_rack() {
    tray_w = product_w - 20;
    tray_d = spring_l + motor_d;

    color("#AAAAAA")
    for (t = [0:tray_count-1]) {
        z = leg_h + exit_door_h + (t * tray_h);

        // Left rail
        translate([10, tray_start_d, z - rail_h])
            cube([rail_w, tray_d, rail_h]);

        // Right rail
        translate([10 + tray_w - rail_w, tray_start_d, z - rail_h])
            cube([rail_w, tray_d, rail_h]);

        // Rear latch pin (catches tray latch hole)
        translate([10 + tray_w/2, tray_start_d + tray_d - tray_wall_t, z + tray_h/2])
            rotate([-90, 0, 0])
                cylinder(d=latch_pin_d, h=latch_pin_l);
    }
}

module outer_shell() {
    color("#C8C8C8", 0.75)
    difference() {
        rounded_box(total_w, total_h, total_d, corner_r);

        // Hollow interior
        translate([skin_t, skin_t, skin_t])
            rounded_box(total_w-(skin_t*2), total_h, total_d-(skin_t*2), corner_r-1);

        // Front door opening — left product zone, tray zone and above
        translate([skin_t, -1, leg_h])
            cube([product_w-(skin_t*2), skin_t+2, tray_zone_top_z - leg_h]);

        // Exit door cutout (front face, base of product zone)
        translate([(product_w - exit_door_w)/2, -1, leg_h])
            cube([exit_door_w, skin_t+2, exit_door_h]);
    }
}

module compartment_divider() {
    color("#AAAAAA", 0.9)
    translate([product_w, skin_t, leg_h])
        cube([divider_t, total_d-(skin_t*2), total_h-leg_h]);
}

// Single-panel front door — left hinge, shown closed.
module front_door() {
    door_h = tray_zone_top_z - leg_h;   // 50 to 542 = 492mm tall

    color("#C0C0C0", 0.6)
    translate([skin_t, 0, leg_h])
        cube([product_w-(skin_t*2), door_t, door_h]);

    // 3 hinges evenly spaced on left edge
    hinge_positions = [
        leg_h + door_h * 0.15,
        leg_h + door_h * 0.5,
        leg_h + door_h * 0.85
    ];
    for (hz = hinge_positions) {
        color("#888888")
        translate([skin_t, 0, hz])
            cylinder(d=hinge_od, h=hinge_h);
    }
}

// Structural frame around the tray zone opening (visible when door open).
module tray_zone_frame() {
    zone_h = tray_zone_h;   // 242mm

    color("#AAAAAA")
    union() {
        // Top bar
        translate([0, 0, tray_zone_top_z - frame_bar])
            cube([product_w, skin_t, frame_bar]);
        // Bottom bar
        translate([0, 0, tray_0_z])
            cube([product_w, skin_t, frame_bar]);
        // Left bar
        translate([0, 0, tray_0_z])
            cube([frame_bar, skin_t, zone_h]);
        // Right bar
        translate([product_w - frame_bar, 0, tray_0_z])
            cube([frame_bar, skin_t, zone_h]);
    }
}

// ATM-style dashboard on right compartment front face.
module dashboard() {
    // Recessed screen mount (pushed 30% into body)
    screen_z = screen_center_z - screen_h/2;
    qr_z = screen_z - 50 - qr_h;
    card_z = qr_z - 30 - card_h;
    speaker_z = card_z - 20 - speaker_h;

    // Screen backing — recessed into front panel
    color("#1A1A1A")
    translate([dash_x + (dash_w - screen_w)/2, screen_recess, screen_z])
        cube([screen_w, 5, screen_h]);

    // Screen bezel
    color("#333333", 0.8)
    translate([dash_x + (dash_w - screen_w)/2 - bezel_t,
               screen_recess - 2, screen_z - bezel_t])
        cube([screen_w + (bezel_t*2), 3, screen_h + (bezel_t*2)]);

    // Curved support bracket under screen (hull between two cylinders)
    color("#444444")
    translate([dash_x + dash_w/2, screen_recess, screen_z])
        hull() {
            translate([-screen_w/2, 0, 0])
                rotate([-90, 0, 0]) cylinder(r=10, h=4);
            translate([screen_w/2, 0, 0])
                rotate([-90, 0, 0]) cylinder(r=10, h=4);
        }

    // QR scanner cutout
    color("#222222")
    translate([dash_x + (dash_w - qr_w)/2, 0, qr_z])
        cube([qr_w, qr_d, qr_h]);

    // ID card reader slot
    color("#333333")
    translate([dash_x + (dash_w - card_w)/2, 0, card_z])
        cube([card_w, card_d, card_h]);

    // Speaker grille — 5 horizontal slots
    slot_h = 2;
    slot_gap = 2;
    color("#444444")
    for (s = [0:speaker_slots-1]) {
        translate([dash_x + (dash_w - speaker_w)/2,
                   0,
                   speaker_z + s*(slot_h + slot_gap)])
            cube([speaker_w, 3, slot_h]);
    }
}

// Acrylic display zone — 3 faces of right compartment above 430mm.
module acrylic_display() {
    acrylic_front_w = system_w - divider_t - skin_t;
    acrylic_front_x = product_w + divider_t;

    // Front face panel — rounded corners (hull + cylinders, r=8)
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

    // Right side panel
    color("#ADD8E6", 0.3)
    translate([total_w - skin_t, skin_t, acrylic_bot_z])
        cube([skin_t, total_d-(skin_t*2), acrylic_zone_h]);

    // Top panel — covers right compartment roof
    color("#ADD8E6", 0.3)
    translate([acrylic_front_x, skin_t, total_h - skin_t])
        cube([acrylic_front_w, total_d-(skin_t*2), skin_t]);
}

module ir_sensors() {
    sensor_z = leg_h + tray_h - sensor_gap - sensor_h;

    color("#222222")
    translate([skin_t + 5, skin_t + drop_zone_d/2, sensor_z])
        cube([sensor_d, sensor_h, sensor_h]);

    color("#222222")
    translate([product_w - skin_t - 5 - sensor_d,
               skin_t + drop_zone_d/2, sensor_z])
        cube([sensor_d, sensor_h, sensor_h]);

    color("#FF0000", 0.3)
    translate([skin_t + 5 + sensor_d,
               skin_t + drop_zone_d/2 + sensor_h/2,
               sensor_z + sensor_h/2])
        cube([product_w - (skin_t*2) - 10 - (sensor_d*2), 1, 1]);
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

// Structure
legs();
translate([0, 0, leg_h]) outer_shell();
compartment_divider();

// Tray system
tray_rack();
for (t = [0:tray_count-1]) spring_tray(t);

// Front zone
front_door();
tray_zone_frame();
drop_zone_visual();

// Sensors
ir_sensors();

// Right compartment
dashboard();
acrylic_display();
rear_service_door();
