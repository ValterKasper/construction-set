include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <liftarm_dimensions.scad>
include <constants.scad>

$fn = 36;

wall_thickness = 1.8;
hole_thickness = 1.2;
hole_size = 8;
cs_size = hole_size + 2 * wall_thickness;
height = hole_size / 2;
liftarm_chamfer = 1;

// Wall thickness
th = 1.8; // [1:0.1:3]

// Width of ends overhang
ear_width = 0.5; // [0.1:0.05:1]

// Height of ears and top
pieces_height = 1.8; // [1:0.1:3]

module hole_mask(height_multiplier = 1, anchor = CENTER) {
    cuboid(
        [
            hole_size + print_tolerance, 
            hole_size + print_tolerance, 
            height * height_multiplier + nothing
        ], 
        chamfer = -0.2,
        edges = [TOP,BOT],
        $fn = 24,
        anchor = anchor 
    );
}

module liftarm_component(
    chamfer = [0, 0, 0, 0], 
    anchor = CENTER, 
    spin = 0, 
    orient = UP
) {
    attachable(anchor, spin, orient, size = size) {
        size = [cs_size, cs_size, height];
        chamfer_values = [
            liftarm_chamfer * chamfer[0], 
            liftarm_chamfer * chamfer[1], 
            liftarm_chamfer * chamfer[2], 
            liftarm_chamfer * chamfer[3]
        ];
        difference() {
            union() {
                linear_extrude(height, center=true)
                rect([cs_size, cs_size], anchor = CENTER, chamfer = chamfer_values);
            }

            hole_mask(anchor = CENTER);
        }
        children();
    }
}


liftarm_start_chamfer = [0, 1, 1, 0];
liftarm_end_chamfer = [1, 0, 0, 1];
module liftarm_8() {
    liftarm_component(chamfer = liftarm_start_chamfer)
    position(RIGHT) liftarm_component(anchor = LEFT)
    position(RIGHT) liftarm_component(anchor = LEFT)
    position(RIGHT) liftarm_component(anchor = LEFT)
    position(RIGHT) liftarm_component(anchor = LEFT)
    position(RIGHT) liftarm_component(anchor = LEFT)
    position(RIGHT) liftarm_component(anchor = LEFT)
    position(RIGHT) liftarm_component(anchor = LEFT, chamfer = liftarm_end_chamfer);
}

module liftarm_3() {
    liftarm_component(chamfer = liftarm_start_chamfer)
    position(RIGHT) liftarm_component(anchor = LEFT)
    position(RIGHT) liftarm_component(anchor = LEFT, chamfer = liftarm_end_chamfer);
}

module liftarm_2() {
    liftarm_component(chamfer = liftarm_start_chamfer)
    position(RIGHT) liftarm_component(anchor = LEFT, chamfer = liftarm_end_chamfer);
}

module liftarm_corner_9() {
    liftarm_component(chamfer = [0, 0, 1, 0]) {
        position(BACK) liftarm_component(anchor = FRONT)
        position(BACK) liftarm_component(anchor = FRONT)
        position(BACK) liftarm_component(anchor = FRONT)
        position(BACK) liftarm_component(anchor = FRONT)
        position(BACK) liftarm_component(anchor = FRONT)
        position(BACK) liftarm_component(anchor = FRONT)
        position(BACK) liftarm_component(anchor = FRONT)
        position(BACK) liftarm_component(anchor = FRONT, chamfer = [1, 1, 0, 0]);

        position(RIGHT) liftarm_component(anchor = LEFT)
        position(RIGHT) liftarm_component(anchor = LEFT)
        position(RIGHT) liftarm_component(anchor = LEFT)
        position(RIGHT) liftarm_component(anchor = LEFT)
        position(RIGHT) liftarm_component(anchor = LEFT)
        position(RIGHT) liftarm_component(anchor = LEFT)
        position(RIGHT) liftarm_component(anchor = LEFT)
        position(RIGHT) liftarm_component(anchor = LEFT, chamfer = liftarm_end_chamfer);
    }
}

module liftarm_corner_5() {
    liftarm_component(chamfer = [0, 0, 1, 0]) {
        position(BACK) liftarm_component(anchor = FRONT)
        position(BACK) liftarm_component(anchor = FRONT)
        position(BACK) liftarm_component(anchor = FRONT)
        position(BACK) liftarm_component(anchor = FRONT, chamfer = [1, 1, 0, 0]);

        position(RIGHT) liftarm_component(anchor = LEFT)
        position(RIGHT) liftarm_component(anchor = LEFT)
        position(RIGHT) liftarm_component(anchor = LEFT)
        position(RIGHT) liftarm_component(anchor = LEFT, chamfer = liftarm_end_chamfer);
    }
}

module liftarm_corner_3() {
    liftarm_component(chamfer = [0, 0, 1, 0]) {
        position(BACK) liftarm_component(anchor = FRONT)
        position(BACK) liftarm_component(anchor = FRONT, chamfer = [1, 1, 0, 0]);

        position(RIGHT) liftarm_component(anchor = LEFT)
        position(RIGHT) liftarm_component(anchor = LEFT, chamfer = liftarm_end_chamfer);
    }
}

// todo move
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
