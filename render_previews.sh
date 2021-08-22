#!/bin/sh

cat pieces_list | sed s/$/.png/ | sed s/^/output\\// | xargs make