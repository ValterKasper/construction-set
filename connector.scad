include <BOSL2/std.scad>
include <dimensions.scad>
include <constants.scad>

// Width of ends overhang
ear_width = 0.5;

// Height of ears and top
pieces_height = wall_thickness;

extrusion = hole_size - print_tolerance * 2;

module connector_component(    
    anchor = DOWN, 
    spin = 0, 
    orient = UP,
    height_multiplier = 2) {
        body_height = height * height_multiplier + print_tolerance * 2;
        connector_height = body_height + pieces_height + pieces_height;

        attachable(anchor, spin, orient, size = [cs_size, connector_height, extrusion]) {
            move(y = -connector_height / 2, z = -extrusion / 2)
            difference() {
                linear_extrude(extrusion)
                diff("hole")
                union() {
                    // ears
                    rect([hole_size + ear_width * 2, pieces_height], anchor = FRONT, chamfer = [0, 0, 0.7, 0.7]) {
                        // body
                        position(BACK) rect([hole_size - print_tolerance * 2, body_height], anchor = FRONT)
                        // top
                        position(BACK) rect([cs_size, pieces_height], anchor = FRONT) {
                            tags("hole") 
                            position(FRONT) rect([hole_size - wall_thickness * 2, body_height + pieces_height + nothing], anchor = BACK);
                        }
                    }
                }

                zflip_copy(z = extrusion / 2)
                chamfer_mask_x(l = hole_size + ear_width * 2, chamfer = 2);
            }
            children();
    }
}

module connector_2h() {
    connector_component(height_multiplier = 2);
}

module connector_corner() {
    overlap = sqrt(wall_thickness * wall_thickness * 2);
    connector_component(height_multiplier = 2, anchor = DOWN + BACK + RIGHT) {
        attach(BACK + RIGHT, BACK + LEFT, overlap = overlap) 
        connector_component(height_multiplier = 2);

        linear_extrude(extrusion, center = true)
        position(BACK + RIGHT) left(wall_thickness) trapezoid(angle = 45, w1 = hole_size / 2, w2 = 0, anchor = BACK, spin = -135);
    }
}