include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

$fn = 36;

fwd(75)
linear_extrude(1.8, center = true) {
    circles_distance = 8.5;
    d1_inner = 11;
    d2_inner = 5.5;
    d1_outer = 17; 
    d2_outer = 21; 
    difference() {
        hulling("hull")
        oval(d = d1_outer, $tags = "hull")
        move(y = circles_distance) oval(d = d2_outer);

        // hole
        union() {
            hulling("hull")
            oval(d = d2_inner, $tags = "hull")
            move(y = circles_distance) oval(d = d2_inner);
        
            move(y = circles_distance) oval(d = d1_inner);
        }
    }
}

module blade_profile(center_width) {
    xrot(90)
    linear_extrude(1, center = true)
    hulling("hull")
    rect([center_width, 1.8], anchor = CENTER, $tags = "hull")
    attach([LEFT, RIGHT], FRONT)
    trapezoid(angle = 55, w1 = 1.8, w2 = 0);
}


zrot(180)
chain_hull() {
    back(60)
    blade_profile(15);

    back(40)
    blade_profile(7);

    back(20)
    blade_profile(5.5);

    blade_profile(4.5);
}



