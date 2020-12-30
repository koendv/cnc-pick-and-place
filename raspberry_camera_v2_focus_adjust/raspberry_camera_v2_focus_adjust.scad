/*
 * Hex screwdriver bit to adjust focus of raspberry pi camera v2.
 */

eps1 = 0.001;
$fn = 64;
clearance_fit = 0.2; // Increase if hex bit does not fit screwdriver, decrease if hex bit waggles.

// to fit camera lens
driver_dia1 = 8.8;
driver_dia2 = 6.0;
driver_dia3 = 5.0;
driver_h = 6.0;
driver_segment_angle = 56.0;

bit_dia = 25.4/4 - clearance_fit; // 1/4" - tweak for printing
transition_h = (driver_dia1 - bit_dia) / 2 ; // height of transition region between hex shank and round driver
bit_h = 25.4 - driver_h - transition_h; // total height 25.4mm = 1"

module focus_screwdriver() {
    difference() {
        focus_screwdriver_body();
        focus_screwdriver_holes();
    }
}

module focus_screwdriver_body() {
    hull() {
        translate([0, 0, bit_h + transition_h - eps1])
        cylinder(h = driver_h, d = driver_dia1);
        
        translate([0, 0, bit_h - eps1])
        cylinder_outer(h = transition_h, d = bit_dia, fn = 6);
    }
    
    intersection() {
        cylinder_outer(h = bit_h, d = bit_dia, fn = 6);
        
        hull() {
            translate([0, 0, bit_h])
            cylinder(d = 7.5, h = eps1);
            translate([0, 0, 2.5])
            sphere(d = 7.5);
        }
    }
}

module focus_screwdriver_holes() {
       
    translate([0, 0, bit_h + transition_h - eps1]) {
        cylinder(h = bit_h, d = driver_dia3);
            
        circ_array(4)
        rotate_extrude(angle = driver_segment_angle, convexity = 10)
        square([driver_dia2/2, driver_h + eps1]);
    }
}


// create n copies, rotated over 360/n degrees

module circ_array(copies) {
    for (i = [0:1:copies-1])
        rotate([0, 0, 360/copies * i])
        children();
}

/* circumscribed (outer) cylinders */

module cylinder_outer(h = 0, r = 0, d = 0, fn = $fn) {
   fudge = 1/cos(180/fn);
   rotate([0, 0, 180/fn])
   if (r == 0) cylinder(h=h, d=d*fudge, $fn=fn);
   else cylinder(h=h, r=r*fudge, $fn=fn);
}

focus_screwdriver();

// not truncated