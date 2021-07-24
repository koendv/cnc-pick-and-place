/*
 * mount of raspberry pi camera 
 * and raspberry pi camera 2 model 
 */

include <heat_set_insert.scad>

$fn = $preview ? 16 : 64;
nozzle_width =0.4;
wall_thickness = 4 * nozzle_width;
eps=0.001;
eps2=2*eps;

tie_wrap_w = 4.6;
tie_wrap_h = 1.25;

base_h = 5.0;

rpicam_pcb_w = 25.0;
rpicam_pcb_h = 23.862;
rpicam_pcb_z = 1.0;
rpicam_radius = 2.0;
rpicam_offset = 9.462;

rpicam_screw_x = 21.0;
rpicam_screw_y = 12.5;
rpicam_screw_dia = 2.2;

rpicam_cam_x = 8.5;
rpicam_cam_z1 = 3.6;
rpicam_cam_z2 = 5.5;
rpicam_conn_x = 20.8;
rpicam_conn_y = 5.5;
rpicam_conn_z = 2.5;

rpicam_h = rpicam_conn_z + rpicam_pcb_z + rpicam_cam_z2;

rpicam_clearance = 1.0;
cable_slot = 16.0 + 2*rpicam_clearance;

rpicam_screws = [
    [-rpicam_screw_x/2, 0],
    [rpicam_screw_x/2, 0],
    [-rpicam_screw_x/2, rpicam_screw_y],
    [rpicam_screw_x/2, rpicam_screw_y]
    ];

module rpicam_pcb() {
    translate([-rpicam_pcb_w/2, -rpicam_offset])
    // unofficial rpi camera boards are rectangular
    //offset(rpicam_radius)
    //offset(-rpicam_radius)
    square([rpicam_pcb_w, rpicam_pcb_h]);
}

module rpicam_holes() {
    for (p = rpicam_screws)
        translate(p)
        circle(d = rpicam_screw_dia);   
}

module rpicam_optics() {
    translate([-rpicam_cam_x/2, -rpicam_cam_x/2, rpicam_pcb_z])
    cube([rpicam_cam_x, rpicam_cam_x, rpicam_cam_z1]);
    translate([0, 0, rpicam_pcb_z])
    cylinder(d=rpicam_cam_x, h=rpicam_cam_z2);
}

module rpicam_connector() {
    translate([-rpicam_conn_x/2, -rpicam_offset, -rpicam_conn_z])
    cube([rpicam_conn_x, rpicam_conn_y, rpicam_conn_z]);
}

module rpicam_heat_set_inserts() {
    for (p = rpicam_screws)
    translate(p)
    mirror([0, 0, 1])
    m2_heat_set_insert();
}

module rpicam() {
    color("Green")
    linear_extrude(rpicam_pcb_z)
    difference() {   
        rpicam_pcb();
        rpicam_holes();
        }
    color("DarkGrey")
    rpicam_optics();
    color("White")
    rpicam_connector();
}

module camera() {
    difference() {
        camera_body();
        camera_holes();
    }
}

module camera_body() {
    linear_extrude(base_h)
    offset(wall_thickness+rpicam_clearance)
    rpicam_pcb();
    translate([0, 0, base_h])
    linear_extrude(rpicam_h+rpicam_clearance)
    difference() {
        offset(wall_thickness+rpicam_clearance)
        rpicam_pcb();
        offset(rpicam_clearance)
        rpicam_pcb();
    };
    translate([(rpicam_screw_x-rpicam_screw_dia)/2, rpicam_screw_dia/2, base_h])
    cube([(rpicam_pcb_w-rpicam_screw_x), rpicam_screw_y-rpicam_screw_dia, rpicam_conn_z + rpicam_clearance]);
    mirror([1,0,0])
    translate([(rpicam_screw_x-rpicam_screw_dia)/2, rpicam_screw_dia/2, base_h])
    cube([(rpicam_pcb_w-rpicam_screw_x), rpicam_screw_y-rpicam_screw_dia, rpicam_conn_z + rpicam_clearance]);
}


module camera_holes() {
    translate([0,0,-base_h])
    linear_extrude(3*base_h)
    rpicam_holes();
    rpicam_heat_set_inserts();
    translate([-cable_slot/2,-rpicam_offset-cable_slot/2, base_h+eps])
    cube(cable_slot);
}

if (0) {
    camera();
    if (1)
    translate([0, 0, base_h+rpicam_conn_z+rpicam_clearance])
    rpicam();
}

// not truncated