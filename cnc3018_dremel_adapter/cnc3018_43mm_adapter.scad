/* 
 * adapter for dremel on cnc3018 52mm diameter z-carriage
 * dremel 398 - spindle ends approx. 28mm below adapter top.
 */

eps1 = 0.001;
eps2 = eps1*2;
$fn = 128;

d1 = 52.0; // outside diameter
h1 = 25.0; // total height

h3 = 2.0;  // lip to avoid adapter falling through
d3 = d1 + 2*h3;

d2 = 43.0 + 0.4; // diameter of inner hole
h2 = h1 + h3; // height dremel thread

slot_w = 2.5; 
chamfer = 0.8;

module dremel_cnc3018_adapter() {
    difference() {
        dremel_cnc3018_body();
        dremel_cnc3018_holes();
    }
}

module dremel_cnc3018_body() {

        // 45 degree chamfer at bottom
        cylinder(d1 = d1-2*chamfer, d2 = d1, h = chamfer);
    
        // body
        translate([0, 0, chamfer-eps1])
        cylinder(d = d1, h = h1-chamfer+eps2);
   
        // lip at top to avoid adapter falling through
        translate([0, 0, h1-h3])
        cylinder(d = d3, h = h3);

        translate([0, 0, h1-2*h3])
        cylinder(d1 = d1, d2 = d3, h = h3);

}

module dremel_cnc3018_holes() {

        
        translate([0, 0, -eps1]) {
            // hole for 43mm "eurohals"
            cylinder(d = d2, h = 2 * h2, center = true);
            // slot
            cube([d1, slot_w, h2]);
        }
}

//if(0)
//rotate([0, 180, 0]) // orient for printing
dremel_cnc3018_adapter();

//dremel_cnc3018_body();
//dremel_cnc3018_holes();

// not truncated
