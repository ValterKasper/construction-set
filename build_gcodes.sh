#!/bin/sh

cat pieces_list | sed s/$/.gcode/ | sed s/^/output\\// | xargs make
