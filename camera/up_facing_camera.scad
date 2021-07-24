/* 
 * mounts upward-facing raspberry pi camera 
 * and led ringlight on cnc bed. 
 */
 
include <rpicam_mount.scad>

ringlight_d1 = 55;
ringlight_h  = 10;
ringlight_screw_dist = 40;
ringlight_screw_offset_x = (ringlight_d1/2 + (rpicam_pcb_w/2+wall_thickness+rpicam_clearance))/2;
ringlight_screw_dia = 4.2;

 module up_facing_camera() {
    difference() {
        up_facing_camera_body();
        up_facing_camera_holes();
    }
}

module up_facing_camera_body() {
    ringlight_body();
    camera_body();
    //floor();
}

module up_facing_camera_holes() {
    camera_holes();
    ringlight_holes();
}

module ringlight_body() {
    cylinder(d=ringlight_d1, h=base_h);
    intersection() {
        for(alpha=[90:120:360])
            rotate([0,0,alpha])
            translate([ringlight_d1/2-ringlight_h/2, 0, ringlight_h/2])
            cube(ringlight_h, center=true);
        translate([0, 0, base_h])
        difference() {
            cylinder(d=ringlight_d1, h=ringlight_h-base_h-eps);
            cylinder(d1=ringlight_d1-ringlight_h, d2=ringlight_d1-ringlight_h/2, h=ringlight_h-base_h+eps);
        }
    }
}

module ringlight_holes() {
    translate([-ringlight_screw_offset_x, 0, -ringlight_h/4])
    cylinder(d=ringlight_screw_dia, h=2*ringlight_h);
    translate([ringlight_screw_offset_x, 0, -ringlight_h/4])
    cylinder(d=ringlight_screw_dia, h=2*ringlight_h);
}

if (0)
camera();
 
up_facing_camera();

if(0)
difference() {
    projection(cut=true)
translate([0, 0, -3])
up_facing_camera();
projection(cut=true)
translate([0, 0, -6])
up_facing_camera();


}