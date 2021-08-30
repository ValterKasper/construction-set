include <BOSL2/std.scad>

file_name = "print_bed_content.stl";
import(file_name);

color("DimGray")
cube([180, 180, 3], anchor = CENTER + TOP);