include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

c = 0.01;

$fn = 36;

wall_thickness = 1.8;
hole_thickness = 1.2;
hole_size = 8;
cs_size = hole_size + 2 * wall_thickness;
height = hole_size / 2;

// Print tolerance
print_tolerance = 0.15; // [0.0:0.05:0.5]

// Wall thickness
th = 1.8; // [1:0.1:3]

// Width of ends overhang
ear_width = 0.5; // [0.1:0.05:1]

// Height of ears and top
pieces_height = 1.8; // [1:0.1:3]


module ch_rect(dim, cut = 0) {
    region([round_corners(rect(dim), method="chamfer", cut=cut)]);
}

// cube
module hole(height_multiplier = 1, inside = false, anchor = BOTTOM, pt = 0) {
    chamfer = 0.2;
    diff("hole")
    cuboid(
        [hole_size + pt, hole_size + pt, height * height_multiplier], 
        chamfer=-chamfer,
        edges=[TOP,BOT],
        $fn=24,
        anchor = anchor 
    ) {
        if (inside) {
            cylinder(r = (hole_size - hole_thickness * 2) / 2, h = height * height_multiplier + c, $tags="hole", anchor = CENTER);
            position(CENTER) cube([hole_size / 2 + chamfer, hole_thickness, height * height_multiplier + c], $tags="hole", anchor = LEFT); 
        }
    };
}

// cs
module cs() {
    // todo here is the sun
    segments_count = 5;
    hole_anchor = FRONT + LEFT + BOTTOM;
    difference() {
        linear_extrude(height)
        ch_rect([cs_size * segments_count, cs_size], 1);

        move([wall_thickness - print_tolerance / 2, wall_thickness  - print_tolerance / 2]) {
            hole(anchor = hole_anchor, pt = print_tolerance);
            move([cs_size, 0]) {
                hole(anchor = hole_anchor, pt = print_tolerance);
                move([cs_size, 0]) {
                    hole(anchor = hole_anchor, pt = print_tolerance);
                        move([cs_size, 0]) {
                            hole(anchor = hole_anchor, pt = print_tolerance);
                            move([cs_size, 0]) {
                                hole(anchor = hole_anchor, pt = print_tolerance);
                            }
                        }
                    }
            }
        }
    }
}

module joiner(height_multiplier = 2) {
    difference() {
        linear_extrude(hole_size - print_tolerance * 2)
        difference() {
            union() {
                body_height = height * height_multiplier + print_tolerance * 2;
                // body
                rect([
                    hole_size - print_tolerance * 2, 
                    body_height + pieces_height + pieces_height], 
                    anchor=FRONT);
                // ears
                rect([
                    hole_size + ear_width * 2, 
                    pieces_height], 
                    anchor=FRONT,
                    chamfer=[0,0,0.7,0.7]);
                // top
                back(body_height + pieces_height)
                rect([
                    cs_size, 
                    pieces_height], 
                    anchor=FRONT);
            }

            union() {
                // center cut
                rect([hole_size - th * 2, height * height_multiplier + pieces_height], anchor=FRONT);
            }
        }
        chamfer_mask_x(l=hole_size + ear_width * 2, chamfer=2);
    }
}

// cube([3, 3, hole_size - print_tolerance * 2], anchor = RIGHT + FWD + BOTTOM, );
// mirror_copy([1,1,0])
// left(cs_size/2 - pieces_height)
// fwd(height + print_tolerance * 2 + pieces_height * 2)
// joiner(1);

cs();



