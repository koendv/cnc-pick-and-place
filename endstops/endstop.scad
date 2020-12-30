/* shaft mount for end stops. 
 * diameter in mm.abs
 * 19mm = 3/4" between screw centers
 */
inch = 25.4;
eps = 0.001;
eps2 = 0.002;
inf = 10000;
nozzle_width=0.4;
$fn=64;

height = 10.0;
width = 30.0;
split = 0.8;
screw_offset = 3/4*inch / 2.0;

module endstop(dia) {
    difference() {
        endstop_body();
        endstop_holes(dia+2*nozzle_width);
    }
}

module endstop_body() {
    {
        cylinder(h=height,d=width);
        translate([-width/2,-width/4,0])
        cube([width, 3/4*width, height]);
    }
}
    
module endstop_holes(dia) {
    cylinder(h=3*height, d=dia, center=true);
    cube([2*width, split, 3*height], center=true);
    translate([screw_offset, 0, height/2])
    endstop_screw();
    translate([-screw_offset, 0, height/2])
    endstop_screw();
    translate([0,width/2,height])
    rotate([45,0,0])
    cube([14,2,3], center=true);
}

module endstop_screw() {
    rotate([-90,0,0])
    rotate([0,0,180/8])
    cylinder(d=3.2,h=2*width,$fn=8,center=true);
    rotate([90,0,0])
    translate([0,0,width/4]) {
        rotate([0,0,180/8])
        cylinder(d=5.4,h=2*width, $fn=8);
        m3_heat_set_insert();
    }
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

module endstop_a(dia) {
    intersection() {
        translate([-inf,0,0])
        cube([2*inf, inf, inf]);
        endstop(dia);
    }
}

module endstop_b(dia) {
    intersection() {
        endstop(dia);
        translate([-inf,-inf,0])
        cube([2*inf, inf, inf]);
    }
}

//endstop(8.0);
//endstop_a(8.0);
//endstop_b(8.0);

endstop(12.0);
//endstop_a(12.0);
//endstop_b(12.0);

// not truncated
