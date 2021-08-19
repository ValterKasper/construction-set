BASE_FILE_NAME=lift_arm
SLICER_CONFIG_FILE=config.ini
GEOM_EXT=stl
PRINTING_PLATE_FILE_NAME=plate
RENDER_SCENE_FILE=render_plate.scad

# generate gcode for 3d printing
$(BASE_FILE_NAME).gcode: $(BASE_FILE_NAME).$(GEOM_EXT) $(SLICER_CONFIG_FILE)
	prusa_slicer $(BASE_FILE_NAME).$(GEOM_EXT) --export-gcode --duplicate 2 --load $(SLICER_CONFIG_FILE) -o $@

preview_gcode: $(BASE_FILE_NAME).gcode
	prusa_slicer --gcodeviewer $^

preview_slicer: $(BASE_FILE_NAME).$(GEOM_EXT)
	prusa_slicer --load $(SLICER_CONFIG_FILE) $^

preview_scad: $(BASE_FILE_NAME).scad
	openscad $^

# generate geometry file
$(BASE_FILE_NAME).$(GEOM_EXT): $(BASE_FILE_NAME).scad
	openscad $^ -o $@

# generate geometry on plate for render
$(PRINTING_PLATE_FILE_NAME).$(GEOM_EXT): $(BASE_FILE_NAME).$(GEOM_EXT) $(SLICER_CONFIG_FILE)
	prusa_slicer $(BASE_FILE_NAME).$(GEOM_EXT) --export-stl --duplicate 2 --load $(SLICER_CONFIG_FILE) -o $@

# render plate
$(PRINTING_PLATE_FILE_NAME).png: $(PRINTING_PLATE_FILE_NAME).$(GEOM_EXT) $(RENDER_SCENE_FILE)
	openscad $(RENDER_SCENE_FILE) -o $@ --render --colorscheme "Tomorrow Night" -D file_name=\"$(PRINTING_PLATE_FILE_NAME).$(GEOM_EXT)\"

clear: 
	rm *.$(GEOM_EXT)
	rm *.gcode
	rm *.png