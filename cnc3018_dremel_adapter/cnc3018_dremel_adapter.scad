/* 
 * adapter for dremel on cnc3018 52mm diameter z-carriage
 * dremel 398 - spindle ends approx. 28mm below adapter top.
 */
 
include <threads.scad> // https://www.dkprojects.net/openscad-threads/

eps1 = 0.001;
eps2 = eps1*2;
$fn = 128;

d1 = 52.0; // outside diameter
h1 = 25.0; // total height

d2 = 35.0; // diameter of hole for dremel 
h2 = 11.0; // height dremel thread

h3 = 2.0;  // lip to avoid adapter falling through
d3 = d1 + 2*h3;

text_h = 0.4; // text engraving = one layer

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

        // hole for Dremel body
        translate([0, 0, h2-eps1])
        cylinder(d = d2, h = h1);
    
        // Dremel thread
        translate([0, 0, -eps1])
        english_thread (diameter=0.75, threads_per_inch=12, length=h2/25.4+eps2, angle=55.0/2.0 /* Whitworth */, leadin=2, internal=true);  // Dremel BSF 3/4" thread
    
        // engrave diameter on body
        d4 = 0.75*2.54;
        translate([0, 0, -eps1])
        mirror([0, 1, 0])
        translate([0, -(d4+d1/4), 0])
        small_text(str(d1,"mm"));
    
        translate([0, 0, -eps1])
        mirror([0, 1, 0])
        translate([0, d4+d1/4, 0])
        small_text("Dremel"); 

}

module small_text(txt) {
    linear_extrude(text_h) text(txt, size = 6, halign = "center", valign = "center");
}

//if(0)
//rotate([0, 180, 0]) // orient for printing
dremel_cnc3018_adapter();

//dremel_cnc3018_body();
//dremel_cnc3018_holes();

// not truncated
