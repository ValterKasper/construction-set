include <BOSL/constants.scad>
use <BOSL/transforms.scad>

module hearth() {
    module hearth_sub() {
        radius = 10;
        diameter = radius * 2;
        angle = 45;

        translate([-radius * cos(angle), 0, 0])
        rotate([0, 0, angle])
        union() {
            circle(r=radius);
            translate([0, -radius, 0])
                square(size=[diameter, diameter], center=true);
        }
    }

    hearth_sub();

    $fn = 100;

    mirror([1, 0, 0]) {
        hearth_sub();
    }
    
}

shell2d([-2,2], or=2, fill=2) {
    hearth();
}