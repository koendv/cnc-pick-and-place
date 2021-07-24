
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

// M2 X D3.6 X L4.0
// 4.0 mm high
// dia top 3.6 mm
// dia bottom 3.1 mm

module m2_heat_set_insert() {
    hull() {
        rotate([0,0,180/8])
        cylinder(d=3.5,h=0.1,$fn=8);
        translate([0,0,-4])
        rotate([0,0,180/8])
        cylinder(d=2.9,h=0.1,$fn=8);
    }
}

