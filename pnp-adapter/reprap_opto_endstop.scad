eps1=0.001;
eps2=0.002;

/*
 * model of reprap optical endstop.
 */
 
module tcst2103() {
    
    x1=24.5;
    y1=6.0;
    z1=3.1;
    z2=11.1;
    r1=1.5;
    x2=x1/2-r1;
    y2=y1/2-r1;
    x3=19.0;
    d1=3.3;
    x4=11.9;
    y4=6.3;
    z4=10.8;
    x5=3.1;
    y5=6.3;
    z5=10.8-3.1;
    x6=1.0;
    y6=6.3;
    z6=1.0;
    
    difference() {
        hull() {
            translate([x2, y2, 0])
            cylinder(r=r1, h=z1);
            translate([x2, -y2, 0])
            cylinder(r=r1, h=z1);
            translate([-x2, y2, 0])
            cylinder(r=r1, h=z1);
            translate([-x2, -y2, 0])
            cylinder(r=r1, h=z1);
        }
        
        translate([-x3/2, 0, -eps1])
        cylinder(d=d1, h=z1+eps2);
        
        translate([x3/2, 0, -eps1])
        cylinder(d=d1, h=z1+eps2);
    }

    difference() {
        translate([-x4/2, -y4/2, 0])
        cube([x4, y4, z4]);
        
        translate([-x5/2-eps1, -y5/2-eps1, z1-eps1])
        cube([x5+eps2, y5+eps2, z5+eps2]);
        
        hull() {
            translate([-x4/2-eps1, -y6/2-eps1, z4])
            cube([x6+eps2, y6+eps2, eps2]);
            translate([-x4/2-eps1, -y6/2, z4-z6])
            cube([eps2, y6+eps2, eps2]);
        }
    }
}

module reprap_pcb() {
    x1=33.0;
    y1=10.5;
    z1=1.6;
    x2=(33.0-24.5)/2;
    x3=19.0;
    d1=3.3;
    difference() {
        translate([-x1/2+x2, -y1/2, -z1])
        cube([x1, y1, z1]);
        
        translate([-x3/2, 0, -z1-eps1])
        cylinder(d=d1, h=z1+eps2);
        
        translate([x3/2, 0, -z1-eps1])
        cylinder(d=d1, h=z1+eps2);
    }
}

module reprap_opto_endstop() {
    // translate optical center to origin.
    z1=10.8-2.6;
    translate([0, 0, -z1]) {
        color("Darkgrey")
        render()
        tcst2103();
        color("Darkgreen")
        render()
        reprap_pcb();
    }
}

//reprap_opto_endstop();
// not truncated
