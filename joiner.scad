include <BOSL2/std.scad>
include <cs1.scad>

// todo presun konstanty do samostatneho suboru
// todo sprav integracny subor
// todo malo by byt jasne ci sa jedna o mm alebo dp
// todo je radius naozaj velkost diery?

// shell thickness
joiner_width = 0.18; // [0.1, 0.2, 0.3]

cut_width = joiner_width * 1.2;
joiner_radius = radius - shell_width - print_clearance;

// desc
x=5; // [0:10]

function joiner_stop_profile_path() = turtle([
            "move", joiner_width,
            "turn", 45,
            "arcleft", 0.1, 90,
            "xjump", 0,
            "yjump", 0,
        ]);

function joiner_profile(profile_height_multiplier = 2) = 
    let(
        profile_height = height * profile_height_multiplier,
        joiner_base_path = rect([joiner_width, profile_height])
    )
    union(
        yflip(joiner_stop_profile_path()), 
        joiner_base_path
    );

function joiner_profile_double(height_multiplier = 2) = 
    let(
        joiner_height = height_multiplier * height
    )
    union(
        joiner_profile(height_multiplier), 
        back(joiner_height, joiner_stop_profile_path())
    );

function cut_profile() =
    let(
        height_offset = height * 0.4,
        cut_height = 1 // 1 is long enought extension to empty space
    )
    left(
        cut_width / 2, 
        back(
            height - height_offset, 
            yflip([rect([cut_width, cut_height])])
        )
    );


module integration() {
    multiplier = 2;
    scale(final_diameter) {
        // up(height / 2)
        //     union() {
        //         color("Wheat", 0.5)
        //         three_hole();
        //         up(height)
        //             color("Snow", 0.5)
        //             three_hole();
        //     }

        difference() {
            joiner_offset = joiner_radius - joiner_width;
            rotate_extrude($fn = 60)
                region(right(joiner_offset, joiner_profile_double(multiplier)));

            xrot(90)
            linear_extrude(height = radius * 2, center = true) {
                region(cut_profile());
                region(yflip(cut_profile(), height * multiplier / 2));
            }
        }
    }
}

//integration();

// color("red", 0.3)
// region([joiner_stop_profile_path()]);





