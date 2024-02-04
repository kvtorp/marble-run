$fn = 256;

use <path.scad>;

width = 30/2;
length = 130;

*Finish2();
*FinishSupport();


*Straight();
*StraightSupport();

*Input();
*PostSupport();

*Wavy();


GravityWell();

module GravityWell() {
    difference() {
        translate([0, 0, 10])
        rotate_extrude(angle = 360, convexity = 10)
        Path(concat([[width, -10, 0], [width, 3, 0], [width + 1, 5, 0], [width + 1, -10, 0], [width - 1, -10, 0]], bezierCurve(0.01, [width-1, 0, 0], [width-1, 20, 0], [length/2, 10, 0], [length/2, 20, 0]))) square(1);

        translate([0, 0, -45])
        cylinder(50, width + 2.1, width + 0.1);
}

    difference() {
translate([0, 0, 30])
cylinder(8, r = length/2 + 1);
translate([0, 0, 29])
cylinder(10, r = length/2);
}
}

module Wavy() {
    difference() {
        union() {
            translate([-length/2, 0]) Post();

            ReceiverLane(-37.5);
            WavyLane();
            translate([length/2, 0]) Post();
            
        }
    
        WavyCutout();
    }

}


module Input() {
    difference() {
        union() {
            Post();
            cylinder(50, 0, 30);
        }
        
        translate([0, 0, -1])
        cylinder(60, r = width - 1);
        translate([0, 0, 2])
            cylinder(50, 0, 30);
    }
}

module Finish() {
    difference() {
        union() {
            translate([-length/2, 0]) Post();
            ReceiverLane();
            FinishLane();
        }
        LaneCutout();
    }

}

module Finish2() {
    difference() {
        union() {
            translate([-length/2, 0]) BottomPost();
            LowReceiverLane();
            FinishLane2();
        }
        
        translate([0, 0, -14.05340]) LaneCutout();
    }
    
    difference() {
        cylinder(10, r = length/2);
        translate([-length/2, 0, -1]) cylinder(20, r = width - 1);

        translate([0, 0, 1]) cylinder(10, r = length/2 - 1);
        translate([0, 0, -1]) cylinder(10, r = length/2 - 6);
    }
    
    w = 6.5;
    translate([-length/2-1, -w/2])
    cube([length-2, w, 1]);

}


module Straight() {
    difference() {
        union() {
            translate([-length/2, 0]) Post();
            ReceiverLane();
            Lane();
            translate([length/2, 0]) Post();
            
        }
        LaneCutout();
    }

}


module StraightSupport() {

    translate([-length/2, 0]) PostSupport();
    translate([length/2, 0]) PostSupport();

}

module FinishSupport() {

    translate([-length/2, 0]) PostSupport();

}

module ReceiverLane(angle = 0) {
    positions = [[-0.5, width*2], [-0.5, 3.5], [-20.5, -17.5], [-0.5, 3.5], [3.5, -0.5], [-17.5, -20.5], [3.5, -0.5], [width*2, -0.5]];

    
    translate([-length/2, 0, 0])
    rotate([0, 0, angle])
    translate([length/2, 0, 0])
    intersection() {
            rotate([0, 5, 0])
            translate([0, 0, 14])
            rotate([90, 0, 90])
            translate([0, 0, -length])
            linear_extrude(2*length, convexity = 10)
            rotate([0, 0, 45])
            translate([-1.5 + sqrt(2)/4, -1.5 + sqrt(2)/4])
            Path(positions) circle(0.5);
                

        difference() {
            translate([-length/2, 0, -1])
            cylinder(52, r = width);

            translate([-length/2, 0, 5])
            sphere(width-1);

            translate([-length/2, 0, -45])
            cylinder(50, width + 2.1, width + 0.1);

        }
    
    }

}

module LowReceiverLane() {
    positions = [[-0.5, width*2], [-0.5, 3.5], [-20.5, -17.5], [-0.5, 3.5], [3.5, -0.5], [-17.5, -20.5], [3.5, -0.5], [width*2, -0.5]];

    
    intersection() {
            rotate([0, 5, 0])
            translate([0, 0, 0])
            rotate([90, 0, 90])
            translate([0, 0, -length])
            linear_extrude(2*length, convexity = 10)
            rotate([0, 0, 45])
            translate([-1.5 + sqrt(2)/4, -1.5 + sqrt(2)/4])
            Path(positions) circle(0.5);
                

            translate([-length/2, 0, 0])
            cylinder(52, r = width+1);
    
    }

}


module Lane() {
    positions = [[-0.5, 12.5], [-0.5, 3.5], [-20.5, -17.5], [-0.5, 3.5], [3.5, -0.5], [-17.5, -20.5], [3.5, -0.5], [12.5, -0.5]];

    
    difference() {
        rotate([0, 5, 0])
        translate([0, 0, 14])
        rotate([90, 0, 90])
        translate([0, 0, -length / 2])
        linear_extrude(length, convexity = 10)
        rotate([0, 0, 45])
        translate([-1.5 + sqrt(2)/4, -1.5 + sqrt(2)/4])
        Path(positions) circle(0.5);
                

        translate([length/2, 0, -1])
        cylinder(52, r = width - 1);
        translate([-length/2, 0, -1])
        cylinder(52, r = width - 1);

        translate([-length/2, 0, -45])
        cylinder(50, width + 2.1, width + 0.1);
        translate([length/2, 0, -45])
        cylinder(50, width + 2.1, width + 0.1);
        
        translate([0, 0, -2*length])
        cube(4*length, center = true);
    
    }
        
}

module WavyLane() {
    difference() {
        rotate([0, 5, 0])
        translate([0, 0, 14])
        Sweep(bezierCurve(0.025, [-length/2, 0, 0], [0, -length/2, 0], [0, length/2, 0], [length/2, 0, 0]), 13/sqrt(2) + 0.5)
        Profile();

        translate([length/2, 0, -1])
        cylinder(52, r = width - 1);
        translate([-length/2, 0, -1])
        cylinder(52, r = width - 1);

        translate([-length/2, 0, -45])
        cylinder(50, width + 2.1, width + 0.1);
        translate([length/2, 0, -45])
        cylinder(50, width + 2.1, width + 0.1);
        
        translate([0, 0, -2*length])
        cube(4*length, center = true);
    
    }
}

module FinishLane() {
    positions = [[-0.5, 12.5], [-0.5, 3.5], [-20.5, -17.5], [-0.5, 3.5], [3.5, -0.5], [-17.5, -20.5], [3.5, -0.5], [12.5, -0.5]];
    endStop = [[-0.5, 12.5], [-0.5, 3.5], [-20.5, -17.5], [-17.5, -20.5], [3.5, -0.5], [12.5, -0.5], [-0.5, 12.5]];

    
    difference() {
        rotate([0, 5, 0])
        translate([0, 0, 14])
        rotate([90, 0, 90]) {
        translate([0, 0, -length / 2])
        linear_extrude(length, convexity = 10)
        rotate([0, 0, 45])
        translate([-1.5 + sqrt(2)/4, -1.5 + sqrt(2)/4])
            Path(positions) circle(0.5);
        translate([0, 0, length / 2])
        linear_extrude(1, convexity = 10)
        rotate([0, 0, 45])
        translate([-1.5 + sqrt(2)/4, -1.5 + sqrt(2)/4])
            hull() Path(endStop) circle(0.5);
        }

        translate([-length/2, 0, -1])
        cylinder(52, r = width - 1);

        translate([-length/2, 0, -45])
        cylinder(50, width + 2.1, width + 0.1);
        
        translate([0, 0, -2*length])
        cube(4*length, center = true);
    
    }
        
}

module FinishLane2() {
    positions = [[-0.5, 12.5], [-0.5, 3.5], [-20.5, -17.5], [-0.5, 3.5], [3.5, -0.5], [-17.5, -20.5], [3.5, -0.5], [12.5, -0.5]];

    
    difference() {
        rotate([0, 5, 0])
        translate([0, 0, 0])
        rotate([90, 0, 90]) {
        translate([0, 0, -length / 2])
        linear_extrude(length/4, convexity = 10)
        rotate([0, 0, 45])
        translate([-1.5 + sqrt(2)/4, -1.5 + sqrt(2)/4])
        Path(positions) circle(0.5);
        }

        translate([-length/2, 0, -1])
        cylinder(52, r = width - 1);

        translate([-length/2, 0, -45])
        cylinder(50, width + 2.1, width + 0.1);
        
        translate([0, 0, -2*length])
        cube(4*length, center = true);
    
    }
        
}

module WavyCutout() {
    difference() {
        rotate([0, 5, 0])
        translate([0, 0, 14])
        Sweep(bezierCurve(0.025, [-length/2, 0, 0], [0, -length/2, 0], [0, length/2, 0], [length/2, 0, 0]), 13/sqrt(2) + 0.5)
        CutOut();

        translate([-length/2, 0, -1])
        cylinder(52, r = width - 1.1);
    }

}

module LaneCutout() {
    bracket = [[-0.5, 16.5], [-0.5, 3.5], [3.5, -0.5], [16.5, -0.5], [20.5, 3.5], [20.5, 16.5], [16.5, 20.5], [3.5, 20.5], [-0.5, 16.5]];

            rotate([0, 5, 0])
            translate([0, 0, 14])
    rotate([90, 0, 90])
    translate([0, 0, -length / 2])
    linear_extrude(length, convexity = 10)
    rotate([0, 0, 45])
    translate([-1.5 + sqrt(2)/4, -1.5 + sqrt(2)/4])
    difference() {
        polygon(bracket);

        for ( i = [0 : 1 : len(bracket) - 2 ] )
            hull() {
                translate(bracket[i])
                circle(0.5);
                translate(bracket[i+1])
                circle(0.5);
            }

    }              
}

module Post() {
    difference() {
        cylinder(50, width + 2, width);
    
        translate([0, 0, -1])
        cylinder(52, r = width - 1);

        translate([0, 0, -45])
        cylinder(50, width + 2.1, width + 0.1);
    }
}

module BottomPost() {
    difference() {
        cylinder(50, width + 2, width);
    
        translate([0, 0, 1])
        cylinder(52, r = width - 1);

    }
}

module PostSupport() {

    difference() {
        cylinder(5, r = width);
        translate([0, 0, -1])
        cylinder(7, r = width - 3);
    }
}
module ReceiverSupport() {
        translate([-length/2, 0]) cylinder(5, r = width);

    difference() {
        translate([-length/2, 0]) cylinder(35, r = width - 2);
        hull() {
            ReceiverLane();
            translate([-length/2, 0, 50]) cylinder(1, r = width);
        }
    }
}
