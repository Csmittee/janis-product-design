// VM-01 Base Vending Machine
// Janis Product Design
// Version: v3
// Date: 2026-06-27
// Units: mm

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

// Spring/Tray
spring_od = 66;
spring_l = 390;
motor_d = 20;
spring_gap = 20;
spring_lanes = 5;
tray_count = 2;
tray_h = 116;
tray_wall = 3;
partition_h = 40;

// Zones from inside floor
drop_zone_d = 138;  // front of machine
tray_start_d = drop_zone_d; // tray starts behind drop zone

// Exit door
exit_door_h = 250;
exit_door_w = 400;
exit_door_from_floor = 0; // at base of product zone

// Heights from ground
product_zone_floor = leg_h;
tray_zone_floor = leg_h;
tray_zone_h = tray_h * tray_count;

// Screen
screen_angle = 30;
screen_w = 165;
screen_h = 100;
screen_top_pct = 0.4;

// IR sensor
sensor_d = 15;
sensor_h = 8;
sensor_gap = 10; // from tray bottom

// Flap
flap_t = 3;
flap_h = exit_door_h;
flap_w = exit_door_w;

// Lock rod
rod_d = 8;
rod_h = 60;

// ─────────────────────────────
// MODULES
// ─────────────────────────────

module rounded_box(w, h, d, r) {
    hull() {
        translate([r, r, 0])
            cylinder(r=r, h=h);
        translate([w-r, r, 0])
            cylinder(r=r, h=h);
        translate([r, d-r, 0])
            cylinder(r=r, h=h);
        translate([w-r, d-r, 0])
            cylinder(r=r, h=h);
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
        translate([p[0], p[1], 0])
            leg();
}

module spring_coil() {
    color("#888888")
    difference() {
        cylinder(h=spring_l, d=spring_od);
        cylinder(h=spring_l+1, d=spring_od-10);
    }
}

module spring_tray(tray_num) {
    tray_w = product_w - 20;
    tray_d = spring_l + motor_d;
   z = leg_h + exit_door_h + (tray_num * tray_h);

    translate([10, tray_start_d, z]) {
        
        // Tray body
        color("#CCCCCC")
        difference() {
            cube([tray_w, tray_d, tray_h]);
            translate([tray_wall, tray_wall, tray_wall])
                cube([tray_w-(tray_wall*2),
                      tray_d-(tray_wall*2),
                      tray_h+1]);
        }

        // Springs + motors + partitions
        for (i = [0:spring_lanes-1]) {
            x = tray_wall + spring_od/2 +
                i*(spring_od + spring_gap);

            // Motor at back
            color("#555555")
            translate([x-10, 0, tray_wall])
                cube([20, motor_d, 30]);

            // Spring along Y (back to front)
            color("#999999")
            translate([x,
                       motor_d + spring_l,
                       tray_wall + spring_od/2])
                rotate([90, 0, 0])
                    spring_coil();

            // Lane partitions
            if (i < spring_lanes-1) {
                color("#BBBBBB")
                translate([x + spring_od/2 +
                           spring_gap/2,
                           tray_wall, tray_wall])
                    cube([2,
                          tray_d-(tray_wall*2),
                          partition_h]);
            }
        }
    }
}

module outer_shell() {
    color("#C8C8C8", 0.75)
    difference() {
        rounded_box(total_w, total_h, total_d, corner_r);

        // Hollow interior
        translate([skin_t, skin_t, skin_t])
            rounded_box(
                total_w-(skin_t*2),
                total_h,
                total_d-(skin_t*2),
                corner_r-1);

        // Main front door cutout (left product zone)
        translate([skin_t, -1, leg_h + tray_zone_h])
            cube([product_w-(skin_t*2),
                  skin_t+2,
                  total_h - leg_h - tray_zone_h]);

        // Exit door cutout (front face, base of product zone)
        translate([(product_w - exit_door_w)/2,
                   -1,
                   leg_h])
            cube([exit_door_w,
                  skin_t+2,
                  exit_door_h]);
    }
}

module compartment_divider() {
    color("#AAAAAA", 0.9)
    translate([product_w, skin_t, leg_h])
        cube([divider_t,
              total_d-(skin_t*2),
              total_h-leg_h]);
}

// IR sensor pair on side walls
module ir_sensors() {
    sensor_z = leg_h + tray_h - sensor_gap - sensor_h;
    
    // Left sensor
    color("#222222")
    translate([skin_t + 5,
               skin_t + drop_zone_d/2,
               sensor_z])
        cube([sensor_d, sensor_h, sensor_h]);

    // Right sensor (pair)
    color("#222222")
    translate([product_w - skin_t - 5 - sensor_d,
               skin_t + drop_zone_d/2,
               sensor_z])
        cube([sensor_d, sensor_h, sensor_h]);

    // IR beam line (visual only)
    color("#FF0000", 0.3)
    translate([skin_t + 5 + sensor_d,
               skin_t + drop_zone_d/2 + sensor_h/2,
               sensor_z + sensor_h/2])
        cube([product_w - (skin_t*2) - 10 - (sensor_d*2),
              1, 1]);
}

// Flap door (shown closed)
module flap_door() {
    color("#B0B0B0", 0.9)
    translate([(product_w - flap_w)/2,
               skin_t,
               leg_h])
        cube([flap_w, flap_t, flap_h]);
}

// Lock rod (connects flap to top acrylic lock)
module lock_rod() {
    color("#666666")
    translate([product_w/2,
               skin_t + flap_t,
               leg_h + flap_h])
        cylinder(h=rod_h, d=rod_d);
}

module screen_mount() {
    screen_z = leg_h + (total_h * screen_top_pct * 0.5);
    color("#1A1A1A")
    translate([product_w + divider_t + 10,
               total_d * 0.2,
               screen_z])
        rotate([-screen_angle, 0, 0])
            cube([screen_w, 5, screen_h]);
    
    // Screen bezel
    color("#333333", 0.8)
    translate([product_w + divider_t + 8,
               total_d * 0.2 - 2,
               screen_z - 2])
        rotate([-screen_angle, 0, 0])
            cube([screen_w+4, 3, screen_h+4]);
}

module acrylic_panel() {
    acrylic_z = leg_h + tray_zone_h;
    acrylic_h = total_h - acrylic_z - skin_t;

    color("#ADD8E6", 0.2)
    translate([skin_t, skin_t, acrylic_z])
        cube([product_w-(skin_t*2),
              total_d-(skin_t*2),
              acrylic_h]);
}

module drop_zone_visual() {
    color("#F0F0F0", 0.15)
    translate([skin_t, skin_t, leg_h])
        cube([product_w-(skin_t*2),
              drop_zone_d,
              tray_zone_h]);
}

module rear_service_door() {
    door_w = system_w - divider_t;
    door_h = total_h * 0.5;
    color("#B8B8B8", 0.6)
    translate([product_w + divider_t,
               total_d - skin_t,
               leg_h + (total_h*0.25)])
        cube([door_w, skin_t*2, door_h]);
}

// ─────────────────────────────
// ASSEMBLY
// ─────────────────────────────

// Legs
legs();

// Main shell
translate([0, 0, leg_h])
    outer_shell();

// Internal divider
compartment_divider();

// Spring trays (tray 0 = bottom, tray 1 = top)
for (t = [0:tray_count-1])
    spring_tray(t);

// Drop zone visual guide
drop_zone_visual();

// IR sensors
ir_sensors();

// Flap exit door
flap_door();

// Lock rod
lock_rod();

// Screen + bezel
screen_mount();

// Acrylic display panel
acrylic_panel();

// Rear service door
rear_service_door();
