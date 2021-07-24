/* 
 * mounts upward-facing raspberry pi camera 
 * and led ringlight on cnc bed. 
 */
 
include <rpicam_mount.scad>
include <util.scad>

l1 = 38.1;
dia1 = 10.0;
dia2 = 8.0;
offs1 = 10.0;
offs2 = 0.4;
slot = 2.0;
h1 = 10.0;
m3_screw_dia = 3.2;
camera_x = -50.0;
camera_y = -2.75;

module down_facing_camera() {
    difference() {
        down_facing_camera_body();
        down_facing_camera_holes();
    }
}

module down_facing_camera_body() {
    translate([camera_x, camera_y])
    camera_body();
}

module down_facing_camera_holes() {
    translate([camera_x, camera_y])
    camera_holes();
}
 
module bracket() {
    difference() {
        linear_extrude(h1)
        difference() {
            bracket_body();
            bracket_holes();
        }
        screw_holes();
    }
}

module bracket_body() {
    hull()
    offset(offs1) {
        translate([l1/2, 0, 0])
        square(dia1, center=true);
        translate([-l1/2, 0, 0])
        square(dia1, center=true);
    };
}

module bracket_holes() {
    union() {
        hull() {
            translate([l1, 0, 0])
            circle_outer(d=dia2, fn=6);       
            translate([l1/2, 0, 0])
            circle_outer(d=dia2, fn=6);
        }
        offset(offs2)
        circle(d=dia1);
        hull() {
            translate([-l1, 0, 0])
            circle_outer(d=dia2, fn=6);
            translate([-l1/2, 0, 0])
            circle_outer(d=dia2, fn=6);
        }
        circle(d=dia1);
    }
    half_bracket();
}

module half_bracket() {   
    wx1 = l1*2;
    wy1 = dia1+offs1;

    translate([-wx1/2, -slot/2])
    square([wx1, wy1]);
}

module screw_holes() {
    translate([l1/4, 0, h1/2])
    rotate([90, 0, 0])
    cylinder_outer(d = m3_screw_dia, h = l1, fn = 6);
    translate([-l1/4, 0, h1/2])
    rotate([90, 0, 0])
    cylinder_outer(d = m3_screw_dia, h = l1, fn = 6);
}

module cam_bracket() {
    difference() {
        union() {
        linear_extrude(h1)
        difference() {
            cam_bracket_body();
            cam_bracket_holes();
        }
        down_facing_camera_body();
    }
        down_facing_camera_holes();
        screw_holes();
    }
}

module cam_bracket_body() {
    bracket_body();
    cam_to_bracket();
}

module cam_bracket_holes() {
    bracket_holes();
}

module cam_to_bracket() {
    difference() {
        hull() {
            rpicam_floorplan();
            projection()
            bracket();
        }
        rpicam_floorplan();
    }
}

module rpicam_floorplan() {
    translate([camera_x, camera_y])
    offset(wall_thickness+rpicam_clearance)
    rpicam_pcb();
}

module pillars() {
    color("Grey") {
        mirror([0, 0, 1])
        linear_extrude(5)
        translate([0, 5.89])
        square([60.54, 25.14], center=true);
        linear_extrude(15) {
            circle(d=dia2);
            translate([l1/2, 0, 0])
            circle(d=dia2);
            translate([-l1/2, 0, 0])
            circle(d=dia2);
        }
    }
}


//projection()
cam_bracket();
rotate([0, 0, 180])
bracket();
pillars();
