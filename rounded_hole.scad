include <BOSL2/std.scad>

p1 = [0, 0];
p2 = [15, 15];
p3 = [15, 0];
p4 = [30, 0];
p5 = [45, 15];

t = [4, 0];
c1 = p1 - t;
c2 = [49, 0];
c3 = [49, 15];
c4 = [0, 15] - t;


$fn = 24;
radius = 1.3;
radius2 = 2;

module test_cs() {
    linear_extrude(height=3, center=true, convexity=10, twist=0)
    union() {
        shell2d([-radius,radius], or=radius, fill=radius) {
            polygon([p1, p2, p3]);
        }
        shell2d([-radius,radius], or=radius, fill=radius) {
            polygon([p2, p3, p4]);
        }
        shell2d([-radius,radius], or=radius, fill=radius) {
            polygon([p5, p2, p4]);
        }
        shell2d([-radius,radius], or=radius, fill=radius) {
            polygon([c1, p1, p2, c4]);
        }
        shell2d([-radius,radius], or=radius, fill=radius) {
            polygon([c2,c3, p5, p4]);
        }

        shell2d([-radius,radius2], or=radius2, fill=radius2) {
            polygon([c1, c2, c3, c4]);
        }
    }
}


test_cs();