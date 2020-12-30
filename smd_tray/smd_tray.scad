/*
 * tray for smd cut tape and components
 */
 
include <util.scad>

eps1=0.001;
eps2=2*eps1;
$fn = $preview ? 16 : 64;

/*
tape_rows = 9;
ic_rows = 2;
ic_cols = 8;
*/


// main tuning parameters for tray
tape_rows = 5; // number of rows of cut tape
ic_rows = 2;   // number of rows for ics
ic_cols = 7;   // number of columns per row of ics
tab_pitch = 45.0; // place tab holes at multiple of tab_pitch

border = 2.0;

cut_tape_x = 8.5;
tape_pin_dia = 1.4;

ic_x = 11.0;
ic_y = ic_x;

tray_x = border + tape_rows * (cut_tape_x + border) + ic_rows * (ic_x + border);
tray_y = border + ic_cols * (ic_y + border);
tray_z = 3.2;
tray_depth = 1.6;

echo (str("tray: ", tray_x , " x ", tray_y, "mm"));

m4_screw_dia = 3.2;
tab_dia = 12.0;

tab_xdist = ceil(tray_x/tab_pitch)*tab_pitch; // distance along x axis between tab holes 
tab_ydist = floor((tray_y-tab_dia)/tab_pitch)*tab_pitch; // distance along y axis between tab holes 

echo (str("tabs: ", tab_xdist , " x ", tab_ydist, "mm"));

tab_x1 = -(tab_xdist-tray_x)/2;
tab_x2 = tray_x + (tab_xdist - tray_x)/2;
tab_y1 = (tray_y-tab_ydist)/2;
tab_y2 = (tray_y+tab_ydist)/2;

// fiducials.
// pcb 16mm dia with a fiducial at the centre.
// the same fiducials can also be used in the nozzle holder.

fid_d1=16.0+0.4;
fid_d2=16.0+2*border;
fid_d3=16.0-2*border;
fid_z=1.6; // pcb height

module smd_tray() {
    difference() {
        smd_tray_body();
        smd_tray_holes();
    }
    smd_tray_pins();
}

module smd_tray_body() {
    cube([tray_x, tray_y, tray_z]);
    // mounting tabs
    hull() {
        translate([tab_x1, tab_y1, 0])
        cylinder(d = tab_dia, h = tray_z);
        
        translate([tab_x2, tab_y1, 0])
        cylinder(d = tab_dia, h = tray_z);
    }
    
    hull() {
        translate([tab_x1, tab_y2, 0])
        cylinder(d = tab_dia, h = tray_z);
        
        translate([tab_x2, tab_y2, 0])
        cylinder(d = tab_dia, h = tray_z);
    }
    
    // fiducials
    hull() {
        translate([-fid_d2/2,fid_d2/2,0])
        cylinder(d=fid_d2,h=tray_z);
        translate([tray_x+fid_d2/2,fid_d2/2,0])
        cylinder(d=fid_d2,h=tray_z);
    }
    
    hull() {
        translate([-fid_d2/2,tray_y-fid_d2/2,0])
        cylinder(d=fid_d2,h=tray_z);
        translate([tray_x/2,tray_y-fid_d2/2,0])
        cylinder(d=fid_d2,h=tray_z);
    } 
}

module smd_tray_holes() {
    translate([0,  0, tray_z-tray_depth]) {
        // strips 
        rect_array(rows = tape_rows, pitch = cut_tape_x + border)
        translate([border, -eps1, -eps1])
        cube([cut_tape_x, tray_y+eps2, tray_depth+eps2]);
        // ics
        translate([tape_rows * (cut_tape_x + border), 0, 0])
        rect_array(rows = ic_rows, cols = ic_cols, pitch = ic_x + border)
        translate([border, border, -eps1])
        cube([ic_x, ic_y, tray_depth+eps2]);
        // big ic
        translate([tape_rows * (cut_tape_x + border)+border, border, 0])
        cube([2*ic_x+border, 2*ic_y+border, tray_depth+eps2]);
        
    }
    // mounting tabs
    translate([tab_x1, tab_y1, -eps1])
    cylinder(d = m4_screw_dia, h = tray_z+eps2);
    
    translate([tab_x2, tab_y1, -eps1])
    cylinder(d = m4_screw_dia, h = tray_z+eps2);
    
    translate([tab_x1, tab_y2, -eps1])
    cylinder(d = m4_screw_dia, h = tray_z+eps2);

    translate([tab_x2, tab_y2, -eps1])
    cylinder(d = m4_screw_dia, h = tray_z+eps2);
    
    // fiducials
    translate([0,0,tray_z-fid_z]) {
        translate([-fid_d2/2,fid_d2/2,0])
        cylinder(d=fid_d1,h=tray_z);
        translate([tray_x+fid_d2/2,fid_d2/2,0])
        cylinder(d=fid_d1,h=tray_z);
        translate([-fid_d2/2,tray_y-fid_d2/2,0])
        cylinder(d=fid_d1,h=tray_z);
        translate([-fid_d2/2,fid_d2/2,0])
        cylinder(d=fid_d3,h=3*tray_z,center=true);
        translate([tray_x+fid_d2/2,fid_d2/2,0])
        cylinder(d=fid_d3,h=3*tray_z,center=true);
        translate([-fid_d2/2,tray_y-fid_d2/2,0])
        cylinder(d=fid_d3,h=3*tray_z,center=true);
    }
    
}

module smd_tray_pins() {
    translate([border, 0, 0])
    rect_array(rows = tape_rows, pitch = cut_tape_x + border) {
        translate([6.5, 7.0, 0])
        smd_tape_pin();
        
        translate([6.5, 11.0, 0])
        smd_tape_pin();
        
        translate([6.5, 26.0, 0])
        smd_tape_pin();
        
        translate([6.5, 30.0, 0])
        smd_tape_pin();
    }
}

module smd_tape_pin() {
    rotate([0, 0, 180/8])
    cylinder(h = tray_z+eps1, d = tape_pin_dia, $fn=8);
    
    translate([0, 0, tray_z])
    rotate([0, 0, 180/8])
    cylinder(h = tape_pin_dia/2, d1 = tape_pin_dia, d2=tape_pin_dia/2, $fn=8);
}

smd_tray();

// not truncated
