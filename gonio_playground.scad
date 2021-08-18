use <line.scad>

function angle_of_line(p1, p2) = atan((p2[1] - p1[1]) / (p2[0] - p1[0]));

module roundCorner(p1, p2, p3, width = 3) {
    line(p1, p2, width = width);
    line(p3, p2, width = width);

    pn1 = p1;
    pn3 = p3;

    v = [pn1[0] + pn3[0], pn1[1] + pn3[1]];
    echo("xxx", pn1, v, p1 + p3);
    #line(v * 10, width = width);
}

module test_cs() {
    linear_extrude(height=3, center=true, convexity=10, twist=0)
    union() {
        line([0, 0], [15, 15]);
        line([15, 15], [15, 0]);
        line([15, 15], [30, 0]);
        line([30, 0], [45, 15]);

        line([-4, 0], [45 + 4, 0], width = 4);
        line([45 + 4, 0], [45 + 4, 15], width = 4);
        line([-4, 15], [45 + 4, 15], width = 4);
        translate([-4, 0])
            line([0, 15], [0, 0], width = 4);
    }
}

function sec(angle) = sqrt(pow(1, 2) + pow(tan(angle), 2));

p1 = [15,0];
p2 = [0, 0];
p3 = [0, 10];
line(p1, p2);
line(p2, p3);

a1 = angle_of_line(p1, p2);
a2 = angle_of_line(p2, p3);
a = (a1 + a2) / 2;

$fn=36;
s = sec(a / 2) * 1.5;

// todo find triangle
#difference() {
    square([3, 3], center=true);
    circle(p2, d=3, center=true);
}

#polygon(points=[p1, p2, p3]);
rotate([0, 0, 45])    
    translate([2.12 * 2, 0])
        circle([0, 0], d=3);

echo("a1 ", a1, ", a2 ", a2, ", a ", a);
echo(str("sec ", s));