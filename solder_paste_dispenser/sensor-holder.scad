include <param.scad>
include <util.scad>

/*
 * adapter for 3dtouch sensor. clips onto syringe body.
 */

adapter_height = 15.0;
adapter_int_dia = syringe_ext_dia;
adapter_dia = adapter_int_dia + 20.0;

sensor_width = 11.53;
sensor_offset = syringe_ext_dia/2+sensor_width/2+3*clearance_fit;

screw_hole_height = 5.0;
adapter_split = 2.0;
    
screw_x_offset = syringe_ext_dia/2 + (adapter_dia - syringe_ext_dia)/4;
screw_y_offset = 10;
screw_z_offset = adapter_height/2;

inf = sensor_width * 10;
    
module sensor_adapter() {
    difference() {
        sensor_adapter_body();
        sensor_adapter_holes();
    }
}

module sensor_adapter_body() {
    hull() {
        adapter_body();
        translate([0, sensor_offset, 0])
        sensor_body();
    }
}

module sensor_adapter_holes() {
    adapter_holes();
    sensor_holes();
}

module adapter_body() {
    cylinder(d = adapter_dia, h = adapter_height);
}

module adapter_holes() {
    // hole for syringe body
    translate([0, 0, -adapter_height/2])
    cylinder_outer(d = adapter_int_dia, h = 2*adapter_height, fn = 6);
    cube([2*adapter_dia, adapter_split, 3*adapter_height], center=true);
    screw_holes();
}

module sensor_body() {
    linear_extrude(screw_hole_height)
    sensor_profile();
}

module sensor_profile() {
    hull()
    offset(clearance_fit)
    union(){
        square([7.0, 11.53], center = true);
        translate([-9.0, 0, 0])
        circle(r=4.0);
        translate([9.0, 0, 0])
        circle(r=4.0);
    };
}

module sensor_holes() {
    translate([0,sensor_offset,-eps1])
    linear_extrude(2*adapter_height)
    union() {
        translate([-9.0, 0, 0])
        circle(r=1.6);
        translate([9.0, 0, 0])
        circle(r=1.6);
        circle(r=2.0);
    };
    x1 = 5.5+clearance_fit;
    d1 = 5.4; // washer dia
    hull() {
        translate([0,sensor_offset,screw_hole_height]) {
            translate([-9.0-x1/2, 0])
            cube([x1, x1, 2*adapter_height]);
            translate([-9.0, 0, 0])
            cylinder(d=x1, h=2*adapter_height);
        }
        translate([-screw_x_offset-d1/2, adapter_dia/4, screw_hole_height])
        cube([d1,adapter_height,2*adapter_height]);
    }
    hull() {
        translate([0,sensor_offset,screw_hole_height]) {    
            translate([9.0-x1/2, 0])
            cube([x1, x1, 2*adapter_height]);
            translate([9.0, 0, 0])
            cylinder(d=x1, h=2*adapter_height);
    
        }
        translate([screw_x_offset-d1/2, adapter_dia/4, screw_hole_height])
        cube([d1,adapter_height,2*adapter_height]);
    }
}


module screw_holes() {
    screw_z_offset = adapter_height/2;
    translate([screw_x_offset,0,screw_z_offset])
    rotate([-90,0,0])
    screw_hole();
    translate([-screw_x_offset,0,screw_z_offset])
    rotate([-90,0,0])
    screw_hole();
}
 
module screw_hole() {
    d1=5.4;
    rotate([0,0,180/8])
    cylinder(d=3.2,h=2*adapter_dia,$fn=8,center=true);
    translate([0,0,adapter_dia/4]) {
        rotate([0,0,180/8])
        cylinder(d=d1,h=2*adapter_dia, $fn=8);
        m3_heat_set_insert();
    }
    mirror([0,0,1])
    translate([0,0,adapter_dia/4])
    rotate([0,0,180/8])
    cylinder_outer(d=d1,h=2*adapter_dia, fn=8);

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

/* 
3d touch sensor.
pin: 6.7 mm min, 11.0 mm max, 8.0 mm to nozzle tip.
*/
   
module 3dtouch() {
    h1=26.3;
    d1=13.0;
    h2=5.0;
    d2=7.0;
    h3=10.0;
    d3=11.0;
    h4 = 2.3;
    color("White")
    translate([0,0,-h1-h3])
    union() {
        difference() {
            intersection(){
                union() {
                    cylinder(h=h1+h3, d=d3);
                    cylinder(h=h1, d=d1);
                    translate([-6.5,0,0])
                    cube([13.0,11.53/2,h1]);
                    }  
                cylinder(h=h1+h3,d1=d2,d2=d1/h2*h1+h3);
            }
            translate([-6.5,11.53/2,+eps2])
            cube([13.0,13.0,h1+h3]);
            translate([-6.5,-13.0-11.53/2,+eps2])
            cube([13.0,13.0,h1+h3]);
        };
        translate([-6.5,0,15])
        cube([13.0,11.53/2+3.7,5.75]);
        translate([0,0,h1+h3-h4-eps1])
        linear_extrude(h4)
        difference() {
            hull()
            union(){
                square([7.0, 11.53], center = true);
                translate([-9.0, 0, 0])
                    circle(r=4.0);
                translate([9.0, 0, 0])
                    circle(r=4.0);
            };
            union() {
                translate([-9.0, 0, 0])
                    circle(r=1.6);
                translate([9.0, 0, 0])
                    circle(r=1.6);
                circle(r=2.0);
            };
        }
        translate([0,0,-8.0-eps1])
        cylinder(h=8.0,d=1.5);
    }
}

module sensor_adapter_a() {
    intersection() {
        translate([-inf,0,0])
        cube([2*inf, inf, inf]);
        sensor_adapter();
    }
}

module sensor_adapter_b() {
    intersection() {
        sensor_adapter();
        translate([-inf,-inf,0])
        cube([2*inf, inf, inf]);
    }
}

module syringe_body() {
    translate([0, 0, - adapter_height/2])
    cylinder(d = syringe_ext_dia, h = 2 * adapter_height);
}

module assembly() {
    sensor_adapter();
    translate([0,sensor_offset,0])
    3dtouch();
    syringe_body();
}


//sensor_adapter();
//sensor_adapter_a();
//sensor_adapter_b();
assembly();

// not truncated
