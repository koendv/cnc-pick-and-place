/*
 * magazine to hold juki smd nozzles
 */

use <juki502.scad>;

eps1 = 0.01;
eps2 = 2*eps1;
$fn = $preview ? 32 : 64;

pitch = 25.0;
slots = 4; // number of slots; 2 is minimum.

nozzle_width = 0.4;
wall = 2.4;

// base
x1 = 27.5;
z1 = 30.0;
r1 = 3.0; // corner curvature
yc = pitch/2;

// lip 1
x2 = x1;
z2 = wall + 19.5;
z3 = 1.6;
z4 = 3.2;
x3 = x2 - (z4-z3)*tan(60);
d1 = 10.5 + nozzle_width;
d2 = 16.0 + nozzle_width;
y1 = pitch - d1;

// lip 2
x4 = x2-3;
d4 = 10.0 + nozzle_width;
y2 = pitch - d4;
z5 = z1 - z4;
x5 = x4 - (z4-z3)*tan(60);
zslot = 1.0+eps2;

xc = wall+(x4-wall)/2; // center of nozzle

module array(count) {
    for ( i = [0:1:count])
        translate([0, i*pitch, 0])
        children();
}

module juki_holder() {
    difference() {
        array(slots+1)
        juki_holder_body();
        array(slots)
        juki_holder_holes();
        translate([-x1, slots*pitch+wall/2, -z1])
        cube([3*x1, 2*pitch, 3*z1]);
        translate([-x1, -pitch-wall/2, -z1])
        cube([3*x1, pitch, 3*z1]);
    }
}
    
module juki_holder_body() {
    cube([x1, pitch, wall]);
    cube([wall, pitch, z1]);
    lip1_body();
    lip2_body();
}

module juki_holder_holes() {
    lip1_hole();
    lip2_hole();
    screw_hole();
}

module lip1_body () {
    translate([0,-y1/2,z2]) {
        hull() {    
            linear_extrude(z4)
            offset(r1)
            offset(-r1)
            square([x3, y1]);
            
            linear_extrude(z3)
            offset(r1)
            offset(-r1)
            square([x2, y1]);
        }
        cube([xc,pitch,z4]);
    }
    translate([0, -wall/2, 0])
    linear_extrude(z2)
    offset(wall/3)
    offset(-wall/3)
    square([x2, wall]);
}

module lip1_hole() {
    translate([xc, yc, z2-eps1])
    cylinder(d=d1, h=z4+eps2);
   
    translate([xc,yc,z2+z4-zslot+eps1])
    cylinder(d1=d2, d2=d2+2*zslot, h=zslot); // 45 degree slope
}

module lip2_body() {
    translate([0,-y2/2,z1-z4]) {
        hull() {
            linear_extrude(z4)
            offset(r1)
            offset(-r1)
            square([x5, y2]);
            
            translate([0,0,z4-z3])
            linear_extrude(z3)
            offset(r1)
            offset(-r1)
            square([x4, y2]);
        }
        cube([xc,pitch,z4]);
    }
    translate([0, -wall/2, 0])
    linear_extrude(z1) 
    union() {
        offset(wall/3)
        offset(-wall/3)
        square([x5, wall]);
        square(wall);
    }
}

module lip2_hole() {
    translate([xc, yc, z5-eps1])
    cylinder(d=d4, h=z4+eps2);
    
    translate([xc,yc,z1-zslot+eps1])
    cylinder(d1=d2, d2=d2+2*zslot, h=zslot); // 45 degree slope
}

module screw_hole() {
    translate([xc, yc+pitch/4, -eps1])
    rotate([0, 0, 180/8])
    cylinder(d=3.4, h= z1, $fn = 8, center=true); // M3
    translate([xc, yc-pitch/4, -eps1])
    rotate([0, 0, 180/8])
    cylinder(d=3.4, h= z1, $fn = 8, center=true); // M3   
}

module printer_ready() {
    rotate([0,-90,0])
    juki_holder();
}

module assembly() {
    juki_holder();

    if(1)
    translate([x3,yc,z5])
    juki502_ring_down();
    
    if(1)
    translate([xc,yc+pitch,z5])
    juki502_ring_down();
    
    if(1)
    translate([xc,yc+2*pitch,z2+z4-zslot])
    juki502_ring_up();
}

//juki_holder();
assembly();
//printer_ready();
