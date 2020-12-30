// bracket for mounting bigtreetech skr 1.3 on cnc 3018 pro.
// print two.

$fn = $preview ? 32 : 64;

bracket_y = 76.10;
rail_y = 70.0;

pillar_r = 3.75;
pillar_h = 7.5;
wall = 2.5;
screw_r=1.6;

pos_x = 2*pillar_r+wall;

module section() {
    hull() {
        translate([-pos_x/2, bracket_y/2])
        circle(pillar_r);
        translate([-pos_x/2, -bracket_y/2])
        circle(pillar_r);
    }
    hull() {
        translate([-pos_x/2, bracket_y/2])
        circle(pillar_r);
        translate([pos_x/2, bracket_y/2])
        circle(pillar_r);
    }
    hull() {
        translate([-pos_x/2, -bracket_y/2])
        circle(pillar_r);
        translate([pos_x/2, -bracket_y/2])
        circle(pillar_r);
    }
}


module bracket() {
    difference() {
        bracket_body();
        bracket_holes();
    }
}

module bracket_body() {
    linear_extrude(wall)
    section();
    translate([-pos_x/2, rail_y/2])
    cylinder(r=pillar_r,h=pillar_h);
    translate([-pos_x/2, -rail_y/2])
    cylinder(r=pillar_r,h=pillar_h);
}


module bracket_holes() {
    translate([-pos_x/2, rail_y/2])
    cylinder(r=screw_r,h=3*pillar_h,center=true);
    translate([-pos_x/2, -rail_y/2])
    cylinder(r=screw_r,h=3*pillar_h,center=true);
    translate([pos_x/2, bracket_y/2])
    cylinder(r=screw_r,h=3*pillar_h,center=true);
    translate([pos_x/2, -bracket_y/2])
    cylinder(r=screw_r,h=3*pillar_h,center=true);
}

module rack_holes() {
}

//projection()
bracket();
// not truncated
