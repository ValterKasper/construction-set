include <BOSL2/std.scad>

file_name = "plate.stl";
import(file_name);

color("DimGray")
cube([180, 180, 3], anchor=FRONT+LEFT+TOP);