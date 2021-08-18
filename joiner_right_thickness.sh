#!/bin/sh

echo "hello"

openscad -D joiner_width=0.1 joiner.scad -o joiner_thickness_0_1.stl
openscad -D joiner_width=0.2 joiner.scad -o joiner_thickness_0_2.stl
openscad -D joiner_width=0.3 joiner.scad -o joiner_thickness_0_3.stl
openscad -D joiner_width=0.4 joiner.scad -o joiner_thickness_0_4.stl

prusa_slicer joiner_thickness_0_1.stl joiner_thickness_0_2.stl joiner_thickness_0_3.stl joiner_thickness_0_4.stl