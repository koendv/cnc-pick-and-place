/*
 * Raspberry Pi4 case
 *
 * Author: Leonard Broman
 */

/* [Main] */

// Which part to render
part = "base"; // [ lid: Lid, base: Base, both: Box ]

// Make slot for the camera cable
camera_slot = "true"; // [ true: Yes, false: No ]

// Make slot for the video cable
video_slot = "false"; // [ true: Yes, false: No ]

// Make slot for the gpio_connector (not implemented)
gpio_slot = "true"; // [ true: Yes, false: No ]

// Prusa i3 Mk3 mount
mk3_mount = "false"; // [ true: Yes, false: No ]

// 3018 Woodpecker CNC mount
woodpecker_mount = "horizontal"; // [ none: No, vertical: Vertical, horizontal: Horizontal ]

// Show RPi 4 board
show_board = "false"; // [ true: Yes, false: No ]

/* [Hidden] */

_show_board = show_board == "true" ? true : false;

board = [85, 56 , 1.3 ];  //dimension of rasp pi
t     = 1.40;             //Thickness of rasp pi board
p     = 3;              //Thickness of plastic case

_t_wall    = 2;              // Thickness of outer walls
_t_b  = 2;              // Thickness of top and bottom
_rpi_w = 56;
_rpi_l = 85;
_rpi_padding = 0.2;
_rpi_t = 1.4;
_rpi_hole_l_offset = 58;

_inner_h = 12.8; // Just guessing here

_h_rpi_offset = 4 + _t_b;

// This cannot be fiddle with too much as it will break the stereo jack hole
_split_offset = 10;

_hole_offset = 3.5;

_outer_l = _t_wall*2 + _rpi_padding*2 + _rpi_l;
_outer_w = _t_wall*2 + _rpi_padding*2 + _rpi_w;
_outer_h = _t_b*2+_inner_h+_h_rpi_offset;

_usbc_offset = _rpi_l-3.5-7.7;
_mhdmi_1_offset = _usbc_offset - 14.8;
_mhdmi_2_offset = _mhdmi_1_offset - 13.5;
_camera_offset = _mhdmi_2_offset - 7;
_audio_offset = _camera_offset-7.5;

cnc_mount_hole_y_offset = 76;
cnc_mount_hole_r = 5/2;


if ($preview) {
    translate([_t_wall+_rpi_padding,_t_wall+_rpi_padding,_h_rpi_offset]) rpi();
}

$fn=20;

//base();
//lid();
//box();

show();

module show() {
    if (part == "lid") {
        rotate([0,180,0]) translate([1,0,-_outer_h]) lid();
    } else if (part == "base") {
        base();
    } else {
        lid();
        base();
    }
}

module rpi() {
    difference() {
        union() {
            _cr = 3;
            color("green")
            hull()
            for(x = [_cr,_rpi_w-_cr])
                for(y = [_cr,_rpi_l-_cr])
                    translate([x,y,0]) cylinder(r=_cr,h=_rpi_t);
            //cube([_rpi_w,_rpi_l,_rpi_t]);


            // SD card
            _sd_width = 11;
            _sd_depth = 3;
            translate([_rpi_w/2-_sd_width/2,_rpi_l-_t_wall,-_rpi_t-1])
                cube([_sd_width,_sd_depth+_rpi_padding+_t_wall,1]);

            // USB 1
            //usb1  =  [[70   ,21.4 ,0] ,[17.4 ,15.3  , 17.4] ,[0,   -2,    0] , [0,   4, 10  ]];
            translate([9,-2,_rpi_t]) {
                usb(padding=0);
            }


            // USB 2
            //usb2  =  [[70   ,39   ,0] ,[17.4 ,15.3  , 17.4] ,[0,   -2,    0] , [0,   4, 10  ]];
            translate([27,-2,_rpi_t]) {
                usb(padding=0);
            }


            // Ethernet
            translate([45.75,-2,_rpi_t])
                ether(padding=0);

            // Audio
            translate([0,_audio_offset,_rpi_t])
                audio(padding=0);

            // HDMI
            //translate([0,45.75,_rpi_t])
              //  hdmi();

             // Micro HDMI
            translate([0,_mhdmi_2_offset,_rpi_t])
                mhdmi();
            
            // Micro HDMI
            translate([0,_mhdmi_1_offset,_rpi_t])
                mhdmi();
            
            // USB C
            translate([-1,_usbc_offset,_rpi_t])
                usbc();


            // Camera
            translate([0,_camera_offset-2.95/2,_rpi_t])
                color("#262626") cube([22.5,2.95,5.7]);

            // Video
            translate([_rpi_w/2-22.5/2,79.55,_rpi_t])
                color("#262626") cube([22.5,2.95,5.7]);

       }


        // holes
       /*
        translate([_hole_offset,_rpi_l-_hole_offset,-1]) cylinder(r=2.75/2,h=_rpi_t+2);
        translate([_rpi_w-_hole_offset,_rpi_l-_hole_offset,-1]) cylinder(r=2.75/2,h=_rpi_t+2);
        translate([_hole_offset,_rpi_l-3.5-_rpi_hole_l_offset,-1]) cylinder(r=2.75/2,h=_rpi_t+2);
        translate([_rpi_w-_hole_offset,_rpi_l-_hole_offset-_rpi_hole_l_offset,-1]) cylinder(r=2.75/2,h=_rpi_t+2);
       */
        for (x = [_hole_offset,_rpi_w-_hole_offset])
            for (y= [_rpi_l-_hole_offset,_rpi_l-_hole_offset-_rpi_hole_l_offset]) {
                translate([x,y,-1]) color("orange") cylinder(r=2.7/2,h=_rpi_t+2);
                translate([x,y,_rpi_t-0.1]) color("orange") cylinder(r=3,h=1);
            }
       
    }
}

module usb(padding=0.2,extends=0.2) {
    _extra_width = (14.7-13.14);
    _w = 13.14+2*padding;
    _f_w = 14.7+2*padding;
    color("gray")
    translate([-_w/2,0,0]) {
        cube([_w,17.4+2*padding,15.3+padding]);
        translate([-(_f_w-_w)/2,-extends+0.2,-_extra_width/2]) cube([_f_w,extends,15.3+padding+_extra_width]);
    }
}

module ether(padding=0.2,extends=0) {
    _w =  15.51+2*padding;
    translate([-_w/2,-extends,0])
    color("gray") cube([_w,21.45+extends,13.9+padding]);
}

module audio(padding=0.4,extends=0,hole=true) {
    $fn=20;
    difference() {
        color("#262626") union() {
            translate([0,0,3]) rotate([0,-90,0]) cylinder(r=3+padding,h=2+extends);
            translate([0,-3,0]) cube([11,6,6]);
        }
        if (hole) {
            translate([5,0,3]) rotate([0,-90,0]) cylinder(r=1.5,h=11);
        }
    }
}

module hdmi() {
    difference() {
        union() {
            translate([1,0,0]) cube([10.7,14.5,6.4]);
            hull() {
                translate([-1,0,2]) cube([10.7,14.5,4.4]);
                translate([-1,1,1]) cube([10.7,12.5,5.4]);
            }
        }
        hull() {
            translate([-2,0.5,2.3]) cube([10.7,13.5,3.6]);
            translate([-2,1.6,1.5]) cube([10.7,11.7,2]);
        }
    }
}

module hdmi_hole(padding=0.6,extends=5,outer_padding=2) {
    union() {
        translate([-1-0.1,-padding,-padding])
            cube([10.7+0.1,14.5+padding*2,6.4+padding*2]);

        translate([-1-extends,-outer_padding,-outer_padding])
            cube([extends,14.5+outer_padding*2,6.4+outer_padding*2]);
    }
}

module mhdmi_hole(padding=0.6,extends=5,outer_padding=2) {
    _w = 6.5;
    _h = 3;
    union() {
        translate([-1-0.1,-_w/2-padding,-padding])
            cube([10.7+0.1,_w+padding*2,_h+padding*2]);

        translate([-1-extends,-_w/2-outer_padding,-outer_padding])
            cube([extends,_w+outer_padding*2,_h+outer_padding*2]);
    }
}

module mhdmi() {
    _w = 6.5;
    translate([0,-_w/2,0])
    difference() {
        color("gray") union() {
            translate([1,0,0]) cube([5.7,_w,3]);
            hull() {
                translate([-1,0,1]) cube([5.7,_w,2]);
                translate([-1,1,0.5]) cube([5.7,_w-2,2]);
            }
        }
        hull() {
            translate([-1.1,0.2,1.2]) cube([5.7,_w-0.4,1.6]);
            translate([-1.1,1.2,0.7]) cube([5.7,_w-2.4,2]);
        }
    }
}

module usbc() {
    _cr=0.8;
    _t=3;
    _w=9;
    _d=7.2;
    //hull()
    //for(x=[_cr,
    translate([0,-_w/2,0]) {
        difference() {
            color("gray") union() {
                hull()
                for(y = [_cr,_w-_cr])
                    for(z = [_cr,_t-_cr])
                        translate([0,y,z]) rotate([0,90,0]) cylinder(r=_cr,h=_d);
                translate([_d-2,0,0]) cube([2,_w,_t/2]);
                translate([_d-6,0,0]) cube([2,_w,_t/2]);
            }
            hull()
            for(y = [_cr,_w-_cr])
                for(z = [_cr,_t-_cr])
                    translate([-1,y,z]) rotate([0,90,0]) cylinder(r=_cr-0.2,h=_d);
        }
        color("black") translate([1,-(_w-4)/2+_w/2,-1/2+_t/2]) cube([_d-1,_w-4,1]);
    }
}


module usbc_hole(padding=0.6,extends=5,outer_padding=2) {
    _w = 9;
    _h = 3;
    union() {
        translate([-1-0.1,-_w/2-padding,-padding])
            cube([5.7+0.1,_w+padding*2,3+padding*2]);

        translate([-1-extends,-_w/2-outer_padding,-outer_padding])
            cube([extends,_w+outer_padding*2,3+outer_padding*2]);
    }
}


module musb_hole(padding=0.6,extends=5,outer_padding=2) {
    union() {
        translate([-1-0.1,-padding,-padding])
            cube([5.7+0.1,7.5+padding*2,3+padding*2]);

        translate([-1-extends,-outer_padding,-outer_padding])
            cube([extends,7.5+outer_padding*2,3+outer_padding*2]);
    }
}


module box() {
    
    _sd_width = 12;
    _sd_depth = 3;
    _sd_inset = 4;

    difference() {

        union() {
            cube([_outer_w,_outer_l,_outer_h]);
            if (woodpecker_mount == "horizontal") {
                translate([-(cnc_mount_hole_y_offset-_outer_w)/2,10,0]) {
                    difference() {
                        union() {
                             hull() {
                                translate([0,0,0]) cylinder(r=cnc_mount_hole_r+4,h=4);
                                translate([cnc_mount_hole_y_offset,0,0]) cylinder(r=cnc_mount_hole_r+4,h=4);
                            }
                            hull() {
                                translate([0,_outer_l-20,0]) cylinder(r=cnc_mount_hole_r+4,h=4);
                                translate([cnc_mount_hole_y_offset,_outer_l-20,0]) cylinder(r=cnc_mount_hole_r+4,h=4);
                            }
                        }
                        translate([0,0,-1]) squarey(x=cnc_mount_hole_y_offset,y=_outer_l-20) cylinder(r=cnc_mount_hole_r,h=6);
                        translate([0,0,2]) squarey(x=cnc_mount_hole_y_offset,y=_outer_l-20) cylinder(r=5.2,h=6);
                    }
                }
             
            }
            
            if (woodpecker_mount == "vertical") {
                translate([-(cnc_mount_hole_y_offset-_outer_w)/2,-(cnc_mount_hole_y_offset-_outer_l)/2,0]) {
                    difference() {
                        union() {
                             hull() {
                                translate([0,0,0]) cylinder(r=cnc_mount_hole_r+4,h=4);
                                translate([cnc_mount_hole_y_offset,0,0]) cylinder(r=cnc_mount_hole_r+4,h=4);
                            }
                            hull() {
                                translate([0,cnc_mount_hole_y_offset,0]) cylinder(r=cnc_mount_hole_r+4,h=4);
                                translate([cnc_mount_hole_y_offset,cnc_mount_hole_y_offset,0]) cylinder(r=cnc_mount_hole_r+4,h=4);
                            }
                        }
                        translate([0,0,-1]) squarey(x=cnc_mount_hole_y_offset,y=cnc_mount_hole_y_offset) cylinder(r=cnc_mount_hole_r,h=6);
                        translate([0,0,2]) squarey(x=cnc_mount_hole_y_offset,y=cnc_mount_hole_y_offset) cylinder(r=5.2,h=6);
                    }
                }
             
            }
        }

        difference() {
            translate([_t_wall,_t_wall,_t_b])
                cube([_rpi_padding*2+_rpi_w,_rpi_padding*2+_rpi_l,_outer_h-2*_t_b]);

            translate([-1,_t_wall,_outer_h-_t_b])
            rotate([0,90,0])
            linear_extrude(height=_outer_w+2)
                polygon([[-0.1,-0.1],[-0.1,(_outer_h-_split_offset-_t_b)*0.8],[_outer_h-_split_offset-_t_b,-0.1]]);
            
            translate([_t_wall+(27-9)-3/2,_t_wall-1,_outer_h-_t_b-2]) cube([3,21,3]);

        }
        $fn=60;
        
        if (!$preview) {
            translate([_t_wall*2,_t_wall*2,_t_b-0.2]) linear_extrude(height=1) text("rpi4",size=8,$fn=20);
            translate([_t_wall*2+40,_t_wall*2+_rpi_l-17,_outer_h-_t_b+0.4]) rotate([0,180,0]) linear_extrude(height=1) text("rpi4",size=8,$fn=20);
        }


        _hole_padding=0.2;

        // SD card slot
        // We assume the slot is "almost" centered
        translate([_t_wall + _rpi_padding + _rpi_w/2 - _sd_width/2, _outer_l-_t_wall-_rpi_padding-_sd_inset,-1])
            cube([_sd_width,_sd_depth+_rpi_padding+_t_wall+_sd_inset+1,_h_rpi_offset+1]);

        translate([_t_wall+_rpi_padding,_t_wall+_rpi_padding,_h_rpi_offset+_rpi_t]) {

            // USB 1 _w = 13.14
            translate([9-_hole_padding/2,-2,1.2]) {
                usb(padding=_hole_padding,extends=_t_wall);
            }

            // USB 2
            translate([27-_hole_padding/2,-2,1.2]) {
                usb(padding=_hole_padding,extends=_t_wall);
            }

            // Ether
            _ether_padding = _hole_padding + 0.2;
            translate([45.75-_ether_padding/2,-2,0])
                ether(padding=_ether_padding,extends=_t_wall);

            // Audio
            translate([0,31,0])
                audio(padding=0.5,extends=2,hole=false);

            // HDMI 1
            translate([0.1,_mhdmi_1_offset,0])
                mhdmi_hole(extends=_t_wall*2);
            
            // HDMI 2
            translate([0.1,_mhdmi_2_offset,0])
                mhdmi_hole(extends=_t_wall*2);

            // USB_C
            translate([0.1,_usbc_offset,0])
                usbc_hole();

        }

        // Camera
        if (camera_slot == "true") {
            translate([_t_wall+_rpi_padding,_t_wall+_rpi_padding+_camera_offset,_t_b+_inner_h])
                rounded_slot(22.5,2.95,20);
        }

        if (video_slot == "true") {
            // Video
            translate([_t_wall+_rpi_padding+_rpi_w/2-22.5/2,_t_wall+_rpi_padding+79.55,,_t_b+_inner_h])
                rounded_slot(22.5,2.95,20);
        }

        if (gpio_slot == "true") {
            translate([_t_wall+_rpi_padding+49.9,_t_wall+_rpi_padding+27,5]) cube([5.1,51,20]);
        }

        // Cooling
        translate([_t_wall+_rpi_padding+16,_t_wall+_rpi_padding+20,_t_b+_inner_h]) {
            translate([0,0,0]) rotate([0,0,45]) rounded_slot(22.5,2.95,20);
            translate([8,0,0]) rotate([0,0,45]) rounded_slot(22.5,2.95,20);
            translate([16,0,0]) rotate([0,0,45]) rounded_slot(22.5,2.95,20);
            if (gpio_slot == "true") {
               translate([24,0,0]) rotate([0,0,45]) rounded_slot(22.5/2,2.95,20);
            } else {
               translate([24,0,0]) rotate([0,0,45]) rounded_slot(22.5,2.95,20);
            }

        }

        translate([_t_wall+_rpi_padding+18,_t_wall+_rpi_padding+50,_t_b+_inner_h]) {
            translate([0,0,0]) rotate([0,0,125]) rounded_slot(22.5,2.95,20);
            translate([8,0,0]) rotate([0,0,125]) rounded_slot(22.5,2.95,20);
            translate([16,0,0]) rotate([0,0,125]) rounded_slot(22.5,2.95,20);
            translate([24,0,0]) rotate([0,0,125]) rounded_slot(22.5,2.95,20);
            if (gpio_slot == "true") {
                translate([32,0,0]) rotate([0,0,125]) translate([22.5/2,0,0]) rounded_slot(22.5/2,2.95,20);
            } else {
                translate([32,0,0]) rotate([0,0,125]) rounded_slot(22.5,2.95,20);
            }
        }

    }
    
    // SD card slot support
    // We assume the slot is "almost" centered
    
    translate([_t_wall + _rpi_padding + _rpi_w/2 - _sd_width/2, _outer_l-_t_wall-_rpi_padding-11-_sd_inset,0])
        cube([_sd_width,11,_h_rpi_offset-2]);



}

module rounded_slot(l,t,h) {
    translate([t/2,t/2,0])
    hull() {
        cylinder(r=t/2,h=h);
        translate([l-t,0,0]) cylinder(r=t/2,h=h);
    }
}


module lid_cut() {
    difference() {
        box();
        translate([-_rpi_w,-_rpi_l,_split_offset-200])
            cube([_rpi_w*3,_rpi_l*3,200]);
    }
}

module lid() {




    _standoff_r=3.5;
    // Screw standoffs
    _height_start = _h_rpi_offset+_rpi_t+0.5;
    _height = _outer_h - _height_start;
    _hole_inset_r=3;

    difference() {
        union() {
            lid_cut();

            // Flap out for the SD card
            _sd_width = 11;
            _sd_depth = 3;
            translate([_t_wall + _rpi_padding + _rpi_w/2 - _sd_width/2, _t_wall+_rpi_padding*2 + _rpi_l,_h_rpi_offset])
                cube([_sd_width,_t_wall,_h_rpi_offset+1]);

            // Standoffs
            translate([0,0,_h_rpi_offset+_rpi_t+0.5]) {
                translate([_t_wall+_rpi_padding+_hole_offset,_t_wall+_rpi_padding+_rpi_l-_hole_offset,0])
                {
                    hull() {
                        translate([-0.1,-0.1,0]) cylinder(r=_standoff_r-1.2,h=_height);
                        translate([0,0,_height-4]) cylinder(r=_standoff_r,h=3);
                        translate([-_standoff_r,_hole_offset+_rpi_padding-1,0]) cube([_standoff_r*2-1.4,1,_height]);
                        translate([-_hole_offset-_rpi_padding,-_standoff_r+1.4,0]) cube([1,_standoff_r*2-1.4,_height]);
                        translate([-_rpi_padding-_hole_offset,0,0])  cube([_rpi_padding+_hole_offset,_rpi_padding+_hole_offset,_height]);
                    }
                }


                translate([_t_wall+_rpi_padding+_rpi_w-_hole_offset,_t_wall+_rpi_padding+_rpi_l-_hole_offset,0])
                {
                    hull() {
                        cylinder(r=_standoff_r,h=_height);
                        translate([-_standoff_r,_hole_offset+_rpi_padding-1,0]) cube([_standoff_r*2,1,_height]);
                        translate([_hole_offset+_rpi_padding-1,-_standoff_r,0]) cube([1,_standoff_r*2,_height]);
                        translate([0,0,0])  cube([_rpi_padding+_hole_offset,_rpi_padding+_hole_offset,_height]);
                    }
                }

                translate([_t_wall+_rpi_padding+_hole_offset,_t_wall+_rpi_padding+_rpi_l-_hole_offset-_rpi_hole_l_offset,0])
                {
                    hull() {
                        cylinder(r=_standoff_r,h=_height);
                        translate([-_hole_offset-_rpi_padding,-_standoff_r,0]) cube([1,_standoff_r*2,_height]);
                    }
                }

                translate([_t_wall+_rpi_padding+_rpi_w-_hole_offset,_t_wall+_rpi_padding+_rpi_l-_hole_offset-_rpi_hole_l_offset,0])
                {
                    hull() {
                        cylinder(r=_standoff_r,h=_height);
                        translate([_hole_offset+_rpi_padding-1,-_standoff_r,0]) cube([1,_standoff_r*2,_height]);
                    }
                }
            }
        }

        // Screw holes

        _standoff_hole_r=1.6;
        _standoff_screw_head_depth = 5;
        translate([_t_wall+_rpi_padding,_t_wall+_rpi_padding,0]) {
            translate([_hole_offset,_rpi_l-_hole_offset,0])
            {
               translate([0,0,-1]) cylinder(r=_standoff_hole_r,h=_height*2);
               translate([0,0,_outer_h-_standoff_screw_head_depth]) cylinder_top_cut(r=_hole_inset_r,inner_r=_standoff_hole_r,h=_standoff_screw_head_depth+1,up=false,down=true);
            }

            translate([_rpi_w-_hole_offset,_rpi_l-_hole_offset,0])
            {
               translate([0,0,-1]) cylinder(r=_standoff_hole_r,h=_height*2);
                translate([0,0,_outer_h-_standoff_screw_head_depth]) cylinder_top_cut(r=_hole_inset_r,inner_r=_standoff_hole_r,h=_standoff_screw_head_depth+1,up=false,down=true);
            }

            translate([_hole_offset,_rpi_l-_hole_offset-_rpi_hole_l_offset,0])
            {
               translate([0,0,-1]) cylinder(r=_standoff_hole_r,h=_height*2);
               translate([0,0,_outer_h-_standoff_screw_head_depth]) cylinder_top_cut(r=_hole_inset_r,inner_r=_standoff_hole_r,h=_standoff_screw_head_depth+1,up=false,down=true);
            }

            translate([_rpi_w-_hole_offset,_rpi_l-_hole_offset-_rpi_hole_l_offset,0])
            {
                translate([0,0,-1]) cylinder(r=_standoff_hole_r,h=_height*2);
                translate([0,0,_outer_h-_standoff_screw_head_depth]) cylinder_top_cut(r=_hole_inset_r,inner_r=_standoff_hole_r,h=_standoff_screw_head_depth+1,up=false,down=true);
            }
        }


    }

}

module base_cut() {
    difference() {
        box();
        translate([-1,-1,_split_offset])
            cube([_rpi_w*2,_rpi_l*2,(_inner_h+_h_rpi_offset)*2]);
    }
}

module base() {

    difference() {

        union() {

            base_cut();

            _standoff_r=3.5;
            _standoff_hole_r=1.4;


            // Screw standoffs
            translate([_t_wall+_rpi_padding+_hole_offset,_t_wall+_rpi_padding+_rpi_l-_hole_offset,0])
            {
                difference() {
                    hull() {
                        cylinder(r=_standoff_r,h=_h_rpi_offset);
                        translate([-_standoff_r,_hole_offset+_rpi_padding-1,0]) cube([_standoff_r*2,1,_h_rpi_offset]);
                        translate([-_hole_offset-_rpi_padding,-_standoff_r,0]) cube([1,_standoff_r*2,_h_rpi_offset]);
                        translate([-_rpi_padding-_hole_offset,0,0])  cube([_rpi_padding+_hole_offset,_rpi_padding+_hole_offset,_h_rpi_offset]);
                    }
                    translate([0,0,_t_b]) cylinder(r=_standoff_hole_r,h=_h_rpi_offset);
                }
            }


            translate([_t_wall+_rpi_padding+_rpi_w-_hole_offset,_t_wall+_rpi_padding+_rpi_l-_hole_offset,0])
            {
                difference() {
                    hull() {
                        cylinder(r=_standoff_r,h=_h_rpi_offset);
                        translate([-_standoff_r,_hole_offset+_rpi_padding-1,0]) cube([_standoff_r*2,1,_h_rpi_offset]);
                        translate([_hole_offset+_rpi_padding,-_standoff_r,0]) cube([1,_standoff_r*2,_h_rpi_offset]);
                        translate([0,0,0])  cube([_rpi_padding+_hole_offset,_rpi_padding+_hole_offset,_h_rpi_offset]);
                    }
                    translate([0,0,_t_b]) cylinder(r=_standoff_hole_r,h=_h_rpi_offset);
                }
            }

            translate([_t_wall+_rpi_padding+_hole_offset,_t_wall+_rpi_padding+_rpi_l-_hole_offset-_rpi_hole_l_offset,0])
            {
                difference() {
                    hull() {
                        cylinder(r=_standoff_r,h=_h_rpi_offset);
                        translate([-_hole_offset-_rpi_padding,-_standoff_r,0]) cube([1,_standoff_r*2,_h_rpi_offset]);
                    }
                    translate([0,0,_t_b]) cylinder(r=_standoff_hole_r,h=_h_rpi_offset);
                }
            }

            translate([_t_wall+_rpi_padding+_rpi_w-_hole_offset,_t_wall+_rpi_padding+_rpi_l-_hole_offset-_rpi_hole_l_offset,0])
            {
                difference() {
                    hull() {
                        cylinder(r=_standoff_r,h=_h_rpi_offset);
                        translate([_hole_offset+_rpi_padding,-_standoff_r,0]) cube([1,_standoff_r*2,_h_rpi_offset]);
                    }
                    translate([0,0,_t_b]) cylinder(r=_standoff_hole_r,h=_h_rpi_offset);
                }
            }
        }

        // Cut out for the SD card
        _sd_width = 12;
        _sd_depth = 3;
        translate([_t_wall + _rpi_padding + _rpi_w/2 - _sd_width/2, _outer_l-_t_wall-_rpi_padding,4])
            cube([_sd_width,_sd_depth+_rpi_padding+_t_wall+1,_h_rpi_offset+1]);

    }


    if (mk3_mount == "true") {

        translate([_outer_w,_outer_l,0])
        difference() {
            union() {
                rotate([0,-90,0])
                linear_extrude(height=4)
                    polygon([[0,-1],[_split_offset,-1],[_split_offset,0.5],[50,0.5],[50,20],[0,20]]);

                linear_extrude(height=_split_offset)
                    polygon([[-24,-1],[-4,20],[-4,20-2],[-22,-1]]);
            }

            translate([-5,10,4]) rotate([0,90,0]) cylinder(r=1.5,h=6);
            translate([-20,10,4]) rotate([0,90,0]) cylinder(r=3,h=12);
            translate([-5,10,50-3]) rotate([0,90,0]) cylinder(r=1.5,h=6);

        }
    }

}
/*
translate([0,-10,0]) cylinder_top_cut(r=3,h=5,inner_r=1);
translate([0,-17,0]) cylinder_top_cut(r=3,h=5,inner_r=1,up=false,down=true);
translate([0,-24,0]) cylinder_top_cut(r=3,h=5,inner_r=1,up=true,down=true);
translate([0,-32,0]) cylinder_top_cut(r=3,h=5,inner_r=1,up=false,down=false);
*/
module cylinder_top_cut(r,h,inner_r,up=true,down=false) {
    top = up ? 0.4 : 0;
    bottom = down ? 0.4 :0;
     translate([0,0,bottom]) cylinder(r=r,h=h-top-bottom);
    if (up) {
       translate([0,0,h-0.6]) {
         intersection() {
            cylinder(r=r,h=0.4);
             translate([-r*1.5,-inner_r,0]) cube([r*3,inner_r*2,0.4]);
         }
         translate([-inner_r,-inner_r,0]) cube([inner_r*2,inner_r*2,0.6]);
       }
     }
     if (down) {
         translate([0,0,0.2])
         intersection() {
            cylinder(r=r,h=0.4);
             translate([-r*1.5,-inner_r,0]) cube([r*3,inner_r*2,0.4]);
         }
         translate([-inner_r,-inner_r,0]) cube([inner_r*2,inner_r*2,0.6]);
     }
     
 }
 
 module squarey(x,y) {
     for(_x = [0,x])
        for(_y = [0,y])
         translate([_x,_y,0]) children();
 }
