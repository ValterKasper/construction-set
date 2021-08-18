include <BOSL2/std.scad>

$fn=36;

final_diameter = 5;
shell_width = 0.18;
radius = 1;
c = 0.01;
angle = 25;
height = 4 / final_diameter; // 4mm
print_clearance = 0.2 / final_diameter; // 0.2mm

center_path=turtle(state = [0, radius], commands = [
    "arcright", 1, angle, 
    "turn", 90,
    "untily", radius * 2.5,
    "turn", angle * 2,
    "untilx", sin(angle),
    "turn", 90,
    "arcright", 1, angle,
    "ymove", -3
]);

outer_path = turtle(state = [-radius, -radius], commands = [
    "move",
    "arcright", 1, -180 + angle, 
    "turn", -90,
    "untily", radius * 2.5,
    "turn", angle * 2,
    "untilx", sin(angle),
    "turn", -90,
    "arcright", 1, -180 + angle, 
    "move",
]);

module center() {
    linear_extrude(height=height, center=true, convexity=10, twist=0)
    union() {
        shell2d([-shell_width, 0], or=0, ir=shell_width) {
            polygon(center_path);
        }
    }
}

module end() {
    linear_extrude(height=height, center=true, convexity=10, twist=0)
    difference() {
        circle(r=radius + c);
        circle(r=radius - shell_width);
    }
}

module outline_right() {
    right_half()
    linear_extrude(height=height, center=true, convexity=10, twist=0)
    shell2d([-c, shell_width], or=shell_width, ir=0) {
        polygon(outer_path);
    }
}

module component() {
    xflip_copy()
    center();

    end();
    translate([0, 5, 0]) {
        end();
    }

    xflip_copy(-c)
    outline_right();
}

module three_hole() {
    union() {
        component();
        fwd(5)
        component();
    }
}

// stroke(outer_path, width=shell_width);