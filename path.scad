$fn = 256;

width = 30/2;
length = 130;

*Sweep(bezierCurve(0.025, [-length/2, 0, 0], [0, -length/2, 0], [0, length/2, 0], [length/2, 0, 0]), 13/sqrt(2) + 0.5)
Profile();

*Sweep(bezierCurve(0.025, [-length/2, 0, 0], [0, -length/2, 0], [0, length/2, 0], [length/2, 0, 0]), 13/sqrt(2) + 0.5)
CutOut();



function turnOffset(angle) = abs((13/sqrt(2) + 0.5) * tan(angle/2));
function sumTo(a, n) = ( n == 0 ? a[0] : a[n] + sumTo(a, n-1) );

module Sweep(points, halfWidth) {

start = points[0];
vectors = [ for ( i = [1 : 1: len(points)-1] ) points[i] - points[i-1] ];
angles = concat(
    atan2(vectors[0].y, vectors[0].x), 
    [ for ( i = [1 : 1 : len(vectors)-1] ) 
        atan2(vectors[i].y * vectors[i-1].x - vectors[i].x * vectors[i-1].y, vectors[i].x * vectors[i-1].x + vectors[i].y * vectors[i-1].y) ] );
        
norms = [ for ( i = [0 : 1 : len(vectors) - 1] ) norm(vectors[i]) ];

for ( i = [0 : 1 : len(vectors) - 1 ] ) {
angle = sumTo(angles, i);
length = norms[i] - ( i > 0 ? turnOffset(angles[i]) - 0.1 : 0 ) - (i < len(vectors) - 1 ? turnOffset(angles[i+1]) - 0.1 : 0 );

    start = points[i] + ( i > 0 ? turnOffset(angles[i]) * vectors[i] / norms[i] : [0, 0] );
    straightStart = points[i] + ( i > 0 ? (turnOffset(angles[i]) - 0.1) * vectors[i] / norms[i] : [0, 0] );

    
    translate(straightStart)
    rotate([0, 0, angle])
        translate([0, -halfWidth, 0])
    rotate([90, 0, 90])
    linear_extrude(length, convexity = 10) 
        intersection() {
            children(0);
            translate([0, -100])
            square([2*halfWidth, 200]);
        }

    if (i > 0) {
    if (angles[i] != 0) {
        translate(start)
        rotate([0, 0, -90*sign(angles[i]) + angle])
        translate([-halfWidth, 0, 0])
        rotate_extrude(angle = -angles[i])
        intersection() {
            children(0);
            translate([0, -100])
            square([2*halfWidth, 200]);
        }
    }
    }
    }


}

module Path(points) {
    for ( i = [0 : 1 : len(points) - 2 ] )
        hull() {
            translate(points[i])
            children(0);
            translate(points[i+1])
            children(0);
        }
}

module Profile() {
    positions = [[-0.5, 12.5], [-0.5, 3.5], [-20.5, -17.5], [-0.5, 3.5], [3.5, -0.5], [-17.5, -20.5], [3.5, -0.5], [12.5, -0.5]];

    translate([13/sqrt(2) + 0.5, 0, 0])
    rotate([0, 0, 45])
        translate([-1.5 + sqrt(2)/4, -1.5 + sqrt(2)/4])
    for ( i = [0 : 1 : len(positions) - 2 ] )
        hull() {
            translate(positions[i])
            circle(0.5);
            translate(positions[i+1])
            circle(0.5);
        }

}

module CutOut() {
    bracket = [[-0.5, 16.5], [-0.5, 3.5], [3.5, -0.5], [16.5, -0.5], [20.5, 3.5], [20.5, 16.5], [16.5, 20.5], [3.5, 20.5], [-0.5, 16.5]];

    translate([13/sqrt(2) + 0.5, 0, 0])
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


function bezierCoordinate(t, n0, n1, n2, n3) = 
    n0 * pow((1 - t), 3) + 3 * n1 * t * pow((1 - t), 2) + 
        3 * n2 * pow(t, 2) * (1 - t) + n3 * pow(t, 3);

function bezierPoint(t, p0, p1, p2, p3) = 
    [
        bezierCoordinate(t, p0[0], p1[0], p2[0], p3[0]),
        bezierCoordinate(t, p0[1], p1[1], p2[1], p3[1]),
        bezierCoordinate(t, p0[2], p1[2], p2[2], p3[2])
    ];


function bezierCurve(t_step, p0, p1, p2, p3) = 
    [for(t = [0 : t_step : 1]) bezierPoint(t, p0, p1, p2, p3)];