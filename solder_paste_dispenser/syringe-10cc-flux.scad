// 10cc "Mechanic" solder paste/flux syringe.
//include <param.scad>

syringe_volume = 10.0; // ml (or cc)
syringe_flange_dia = 34.1;
syringe_flange_width = 22.5;
syringe_flange_thickness = 3.25;
syringe_ext_dia = 18.5;
syringe_int_dia = 15.5;
syringe_barrel_length = 91.2;
syringe_empty_length = 77.5;
syringe_luer_dia = 10.40;

// Piston for 10cc solder paste/flux syringe. 

    chamfer = 0.5; // chamfer at bottom
plunger_h0 = 10.0;
plunger_d0 = syringe_int_dia - 2*clearance_fit;   // diameter at base. 
plunger_h1 = 2.0;
plunger_d1 = 13.5;
plunger_h2 = 3.0;
plunger_d2 = 10.0;
plunger_w1 = 1.0+tight_fit;
plunger_d3 = 4.0;

    
module plunger_slots() {
    h=plunger_h1+plunger_h2;
    difference() {
        union() 
        translate([0, 0, h/2]) {
            cube([syringe_int_dia*2, plunger_w1, h], center=true);
            rotate([0, 0, 60])
            cube([syringe_int_dia*2, plunger_w1, h], center=true);
            rotate([0, 0, 120])
            cube([syringe_int_dia*2, plunger_w1, h], center=true);
        }
        cylinder(h=2*h, d=plunger_d3);
    }
}    

module plunger_body() {
    translate([0, 0, plunger_h0-eps1])
    difference() {
        union() {
            cylinder(h=plunger_h1, d=plunger_d1);
            translate([0, 0, plunger_h1-eps1])
            cylinder(h=plunger_h2, d=plunger_d2);
        }
        plunger_slots();
    }
    cylinder(h=plunger_h0, d1=plunger_d0, d2=plunger_d1);
}

if (0) {
    projection(cut = true)
    rotate([0, 90, 0])
    rotate([0, 0, 45])
    plunger_body();
}
  
//plunger_slots();
//plunger_body();
 
// not truncated 
