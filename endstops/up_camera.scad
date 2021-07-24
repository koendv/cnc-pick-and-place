/* 
 * mounts upward-facing raspberry pi camera 
 * and led ringlight on cnc bed. 
 */
 
inch = 25.4;
eps = 0.001;
eps2 = 0.002;
inf = 10000;
nozzle_width=0.4;
$fn=64;

floor_z = 5.0;

camera_y = 21.0;
camera_x = 12.5;
camera_z = floor_z+5.0;

ringlight_d1 = 48;
ringlight_h  = 10;

screw_dist = 40;

module up_facing_camera() {
    difference() {
        up_facing_camera_body();
        up_facing_camera_holes();
    }
}

module up_facing_camera_body() {
    ringlight();
    camera_body();
    floor();
}

module up_facing_camera_holes() {
    camera_holes();
    screw_holes();
}

module camera_screw_positions() {
    rotate([0,0,-90])
    {
        translate([-camera_y/2, +camera_x,0])
        children();
        translate([+camera_y/2, +camera_x,0])
        children();
        translate([-camera_y/2, 0,0])
        children();
        translate([+camera_y/2, 0,0])
        children();
    }
}

module camera_body() {
    translate([camera_x/2,-camera_y/2-0.5,camera_z/2])
    cube([camera_x-2.5,3.2,camera_z],center=true);
    translate([camera_x/2,camera_y/2+0.5,camera_z/2])
    cube([camera_x-2.5,3.2,camera_z],center=true);
    screw_body();
}

module camera_holes() {
    camera_screw_positions()
    rotate([0,0,180/8])
    cylinder(d=2.5,h=50.0,$fn=8,center=true);
    camera_screw_positions()
    mirror([0,0,1])
    m2_heat_set_insert();
}

/* m3 heat set insert
 * 6.0 mm high
 * dia top 5.0 mm
 * dia bottom 4.0 mm
 * cone 8 degree taper angle, from 4.0mm - 0.2 mm = 3.8mm, height = 6.0 mm
 */

module m3_heat_set_insert() {
    hull() {
        rotate([0,0,180/8])
        cylinder(d=5.5,h=0.1,$fn=8);
        translate([0,0,-6])
        rotate([0,0,180/8])
        cylinder(d=3.8,h=0.1,$fn=8);
    }
}

// M2 X D3.6 X L4.0
// 4.0 mm high
// dia top 3.6 mm
// dia bottom 3.1 mm

module m2_heat_set_insert() {
    hull() {
        rotate([0,0,180/8])
        cylinder(d=3.5,h=0.1,$fn=8);
        translate([0,0,-4])
        rotate([0,0,180/8])
        cylinder(d=2.9,h=0.1,$fn=8);
    }
}

module ringlight() {
    for(alpha=[0:120:360])
        rotate([0,0,alpha])
        translate([ringlight_d1/2, 0, ringlight_h/2])
        cube(ringlight_h, center=true);
}

module floor() {
    linear_extrude(floor_z)
    hull()
    projection() {
        ringlight();
        camera_body();
    }
}

module screw_body() {
    translate([0,-screw_dist/2,0])
    cylinder(d=8.0+nozzle_width,h=floor_z);
    translate([0,screw_dist/2,0])
    cylinder(d=8.0+nozzle_width,h=floor_z);
}

module screw_holes() {
    translate([0,-screw_dist/2,0])
    cylinder(d=4.2+nozzle_width,h=3*floor_z,center=true);
    translate([0,screw_dist/2,0])
    cylinder(d=4.2+nozzle_width,h=3*floor_z,center=true);
}

up_facing_camera();
//camera_holes();
//ringlight();
//floor();