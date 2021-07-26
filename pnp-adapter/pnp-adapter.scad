/*
 * adapter for nema 8 pick-and-place head on cnc3018 52mm diameter z-carriage
 */

 /*
  * The optocoupler is a RepRap with TCST2103 on 1.6mm pcb.
  * TCST2103 clones may or may not fit.
  * Try changing tweak_optocoupler_pos, or replace the optocoupler with a TCST2103.
  */

 include <util.scad>
 include <reprap_opto_endstop.scad>

eps1 = 0.001;
eps2 = eps1*2;
$fn = $preview ? 32 : 128;
clearance_fit = 0.4;      // approx. 2 x layer z height
tight_fit = 0.2;          // approx. half clearance fit

d1 = 52.0;                // outside diameter
h1 = 35.5;                // total height

nema_body_width = 20.3;   // width of hole for nema stepper
nema_body_length = 30.0;  // height of hole for nema stepper
nema_body_corner_radius = 1.75;
nema_boss_dia = 16.0;     // dia boss around shaft
nema_screw_dist = 16.0;   // distance between two screw centers
nema_screw_dia = 2.2;     // M2 screw hole
nema_screw_head = 2.5;    // M2 screw head height
nema_washer_dia = 5.0;    // M2 washer dia

nema_connector_x = 2.0;
nema_connector_y = 12.5;
nema_connector_z = 8.5;

nema_clearance = 5.0;     // clearance around motor

h2 = 7.5;   // nema8 position
h3 = 2.0;  // lip to avoid adapter falling through
d3 = d1 + 2*h3;

text_h = 0.4; // text engraving = one layer

chamfer = 0.8;

// vane

vane_z = h2+nema_body_length+12.0;
vane_d1 = 7.5;
vane_x1 = 10.0;
vane_y1 = 4.0;
vane_z1 = 0.5;

/*
 * optical endstops
 */

optocoupler_axis_z = 3.1;     // z position of optical axis
optocoupler_axis_x = 10.8-2.6;     // x offset of optical axis wrt. optocoupler base
optocoupler_screw_spacing = 19.0;   // reprap std

optocoupler_x1=6.0;
optocoupler_y1=24.5;
optocoupler_z1=3.1;

//optocoupler_x2=6.3;
//optocoupler_y2=11.9;
//optocoupler_z2=11.1;

optocoupler_pcb_x = 1.6;
optocoupler_pcb_y = 10.5 + clearance_fit;
optocoupler_pcb_z = 33.0 + clearance_fit;
optocoupler_pillar = 1.6;

tweak_optocoupler_pos = 0.0; // tweak for optocoupler x position, e.g. if not using TCST2103.
// tweak_optocoupler_pos = 1.5; // moves optocoupler 1.5mm away from pnp axis.

optocoupler_w = 10.0;

optocoupler_x = 8.0 + tweak_optocoupler_pos;
optocoupler_z = vane_z;
optocoupler_pcb_x1 = 23.0 - 10.5/2 + tweak_optocoupler_pos;

m3_screw_dia = 3.2;
m3_washer_dia = 5.5;

module nema8_adapter() {
    difference() {
        nema8_body();
        nema8_holes();
    }
}

module nema8_body() {

        // 45 degree chamfer at bottom
        cylinder(d1 = d1-2*chamfer, d2 = d1, h = chamfer);

        // body
        translate([0, 0, chamfer-eps1])
        cylinder(d = d1, h = h1-chamfer);

        // lip at top to avoid adapter falling through
        translate([0, 0, h1-h3])
        cylinder(d = d3, h = h3);

        translate([0, 0, h1-2*h3])
        cylinder(d1 = d1, d2 = d3, h = h3);

        // optocoupler support
        optocoupler_body();

}

module nema8_screw_position(){
    translate([nema_screw_dist/2, nema_screw_dist/2, 0])
    children();
    translate([-nema_screw_dist/2, nema_screw_dist/2, 0])
    children();
    translate([nema_screw_dist/2, -nema_screw_dist/2, 0])
    children();
    translate([-nema_screw_dist/2, -nema_screw_dist/2, 0])
    children();
}

module nema8_holes() {


        // holes for screws
        nema8_screw_position()
        cylinder(d = nema_screw_dia+clearance_fit, h = h1);

        // hole for boss
        cylinder(d = nema_boss_dia, h = h1, center = true);

        // hole for stepper
        translate([0,0,h2])
        cylinder(r=optocoupler_pcb_x1+optocoupler_pillar, h=h1-h2+eps2);

        // screws for optocoupler
        optocoupler_holes();

        // engrave diameter on body
        d4 = 0.75*2.54;
        translate([0, 0, -eps1])
        mirror([0, 1, 0])
        translate([0, -(d4+d1/4), 0])
        small_text(str(d1,"mm"));

        translate([0, 0, -eps1])
        mirror([0, 1, 0])
        translate([0, d4+d1/4, 0])
        small_text("nema8");
}

module small_text(txt) {
    linear_extrude(text_h) text(txt, size = 6, halign = "center", valign = "center");
}

module vane_body() {
    translate([0,0,vane_z - vane_z1/2])
    color("Grey") {
        cylinder(d=vane_d1,h=vane_z1);
        translate([0,-vane_y1/2,0])
        cube([vane_x1, vane_y1, vane_z1]);
        cylinder(d=8/cos(180/6), h = 10, center = true);
    }
}

module optocoupler_body() {

    hull() {
        translate([0,0,optocoupler_z+14])//XXX
        linear_extrude(eps1) {
            intersection() {
                translate([optocoupler_pcb_x1+optocoupler_pillar,-optocoupler_pcb_y/2])
                square(optocoupler_pcb_y);
                circle(d=d3);
            }
            translate([d3/2,0])
            square([eps1, m3_washer_dia+clearance_fit], center=true); // flat surface for screw head
        }

        translate([0,0,h1])
        linear_extrude(eps1) {
            intersection() {
                translate([optocoupler_pcb_x1+optocoupler_pillar,-d3])
                square(2*d3);
                circle(d=d3);
            }
            translate([d3/2,0])
            square([eps1, m3_washer_dia+clearance_fit], center=true); // flat surface for screw head
        }

    }
    dia1 = m3_washer_dia;
    dia2 = m3_washer_dia + 2 * optocoupler_pillar;
    translate([optocoupler_pcb_x1,0,optocoupler_z])
    rotate([0,90,0]) {
        translate([optocoupler_screw_spacing/2,0,0])
        rotate([0,0,180/6])
        cylinder(d1 = dia1, d2 = dia2, h = optocoupler_pillar);

        translate([-optocoupler_screw_spacing/2,0,0])
        rotate([0,0,180/6])
        cylinder(d1 = dia1, d2 = dia2, h = optocoupler_pillar);
    };
}

module optocoupler_holes() {
    translate([optocoupler_x,0,optocoupler_z])
    rotate([0,90,0]) {
        // hole for M3 mounting screws
        translate([optocoupler_screw_spacing/2,0,0])
        rotate([0,0,180/6])
        cylinder_outer(d = m3_screw_dia+tight_fit, h = d3, fn = 6);

        translate([-optocoupler_screw_spacing/2,0,0])
        rotate([0,0,180/6])
        cylinder_outer(d = m3_screw_dia+tight_fit, h = d3, fn = 6);
    }
}

/*
 * assembly model of reprap optical endstop
 */

module optocoupler_assembly() {
    translate([optocoupler_x,0,optocoupler_z])
    rotate([0, -90, 0]) {
        /* slotted optocoupler */
        reprap_opto_endstop();

        /* optical axis */
        color("Fuchsia")
        cube([optocoupler_axis_z, 0.6, 0.6], center = true);
    }
}

module nema8_stepper() {
    // from https://grabcad.com/library/nema-8-stepper-motor-3
    translate([0,0,-6])
    import("nema8.stl");
}

module assembly() {
    nema8_adapter();
    translate([0,0,h2])
    mirror([0,0,1])
    nema8_stepper();
    vane_body();
    optocoupler_assembly();
}

//nema8_adapter();
assembly();

// not truncated
