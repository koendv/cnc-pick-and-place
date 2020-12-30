/* shaft mount for raspberry pi camera. 
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

camera_y = 21.0;
camera_x = 12.5;
camera_offset_x = width/2+camera_x/2+5.0/1+1;
camera_offset_y = width/4;

module down_facing_camera() {
    difference() {
        down_facing_camera_body();
        down_facing_camera_holes();
    }
}

module down_facing_camera_body() {
    endstop_body();
    translate([camera_offset_x, camera_offset_y,0])
    camera_body();
    translate([0,split/2,0])
    cube([width, (width-split)/2, height/2]);
}

module down_facing_camera_holes() {
    dia = 8.0;
    endstop_holes(dia);
    translate([camera_offset_x, camera_offset_y,0])
    camera_holes();
}

module endstop(dia) {
    difference() {
        endstop_body();
        endstop_holes(dia);
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
    cube([width+eps2, split, 3*height], center=true);
    translate([screw_offset, 0, height/2])
    endstop_screw();
    translate([-screw_offset, 0, height/2])
    endstop_screw();
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

module camera_screw_positions() {
     
    {
        translate([-camera_x/2, +camera_y/2,0])
        children();
        translate([+camera_x/2, +camera_y/2,0])
        children();
        translate([-camera_x/2, -camera_y/2,0])
        children();
        translate([+camera_x/2, -camera_y/2,0])
        children();
    }
}

module camera_body() {
    hull()
    camera_screw_positions()
    cylinder(d=10.0,h=height/2);
    
    translate([0,-camera_y/2-0.5,height/2])
    cube([camera_x-2.5,3.2,height],center=true);
    translate([0,+camera_y/2+0.5,height/2])
    cube([camera_x-2.5,3.2,height],center=true);

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

module down_facing_camera_a() {
    difference() {
        down_facing_camera();
        translate([-width/2-eps,-inf,-eps2])
        cube([width+eps2, inf, inf]);
    }
}

module down_facing_camera_b() {
    intersection() {
        down_facing_camera();
        translate([-width/2,-inf,0])
        cube([width, inf, inf]);
    }
}

down_facing_camera();
//down_facing_camera_a();
//down_facing_camera_b();