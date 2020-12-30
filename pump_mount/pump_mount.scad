/*
 * mount for vacuum pump. Motor length 30mm, motor diameter 25mm.
 */
include <util.scad>
eps1 = 0.001;
eps2 = 2*eps1;
$fn=32;
motor_dia = 25.0;
motor_l = 30.0;
wall = 2.4;

module pump_mount() {
    difference() {
        pump_mount_body();
        pump_mount_holes();
    }
}

module pump_mount_body() {
    translate([-motor_dia/2,-motor_l/2,-6])
    cube([motor_dia, motor_l, motor_dia/2]);
}

module pump_mount_holes() {
    translate([0,-motor_l,motor_dia/2])
    rotate([-90,0,0])
    rotate([0,0,180/8])
    cylinder_outer(d=motor_dia+eps2, h = 2*motor_l /*, fn = 8 */ ); 
    
    cylinder(d=3.2,h=motor_dia, center=true);
    translate([0,0,-3])
    cylinder(d=5.0,h=motor_dia);
    
    /* tie-wraps to attach motor */
    translate([0,-motor_l/4,-6])
    cube([2*motor_dia, 5, 1.6], center=true);
    translate([0,motor_l/4,-6])
    cube([2*motor_dia, 5, 1.6], center=true);
}

pump_mount();
