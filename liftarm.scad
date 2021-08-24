include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <dimensions.scad>
include <constants.scad>

$fn = 36;

liftarm_chamfer = 1;

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
