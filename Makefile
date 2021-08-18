BASE_FILE_NAME=cs1
SLICER_CONFIG_FILE=config.ini
GEOM_EXT=stl

# generate gcode for 3d printing
$(BASE_FILE_NAME).gcode: $(BASE_FILE_NAME).$(GEOM_EXT) $(SLICER_CONFIG_FILE)
	prusa_slicer $(BASE_FILE_NAME).$(GEOM_EXT) --export-gcode --load $(SLICER_CONFIG_FILE) -o $@

preview_gcode: $(BASE_FILE_NAME).gcode
	prusa_slicer --gcodeviewer $^

preview_slicer: $(BASE_FILE_NAME).$(GEOM_EXT)
	prusa_slicer --load $(SLICER_CONFIG_FILE) $^

preview_scad: $(BASE_FILE_NAME).scad
	openscad $^

# generate geometry file
$(BASE_FILE_NAME).$(GEOM_EXT): $(BASE_FILE_NAME).scad
	openscad $^ -o $@

clear: 
	rm *.$(GEOM_EXT)
	rm *.gcode