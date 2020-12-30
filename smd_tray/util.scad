/* circumscribed (outer) polygons, polygonal cylinders, and cones */

module cylinder_outer(h = 0, r = 0, d = 0, fn = $fn) {
   fudge = 1/cos(180/fn);
   rotate([0, 0, 180/fn])
   if (r == 0) cylinder(h=h, d=d*fudge, $fn=fn);
   else cylinder(h=h, r=r*fudge, $fn=fn);
}

module cone_outer(h = 0, r1 = 0, r2 = 0, d1 = 0, d2 = 0, fn = $fn) {
   fudge = 1/cos(180/fn);
   rotate([0, 0, 180/fn])
   if ((r1 == 0) && (r2 == 0)) cylinder(h=h, d1=d1*fudge, d2=d2*fudge, $fn=fn);
   else cylinder(h=h, r1=r1*fudge, r2=r2*fudge, $fn=fn);
}

module circle_outer(d = 0, r = 0, fn = $fn) {
    fudge = 1/cos(180/fn);
    rotate([0, 0, 180/fn])
    if (r == 0) circle(d = d*fudge, $fn=fn);
    else circle(r = r*fudge, $fn=fn);
}

/* rectangular array */

module rect_array(rows = 1 , cols = 1, layers = 1, pitch = 1.0) {
    for (i = [0:1:rows-1])
        for (j = [0:1:cols-1])
            for (k = [0:1:layers-1])
                translate([pitch*i, pitch*j, pitch*k]) 
                children();
}

/* circular array - create n copies, rotated over 360/n degrees */

module circ_array(r = 0.0, d = 0.0, n = 1) {
    for (i = [0:1:n-1])
        rotate([0, 0, 360/n * i])
        translate([r ==0 ? d/2.0 : r, 0, 0])
        children();
}

// not truncated
