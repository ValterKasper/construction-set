BASE_FILE_NAME=liftarm
SLICER_CONFIG_FILE=config.ini
GEOM_EXT=stl
PRINT_BED_CONTENT_FILE_NAME=print_bed_content
PRINT_BED_SCENE_FILE=print_bed_scene.scad

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

# generate geometry on plate for render
$(PRINT_BED_CONTENT_FILE_NAME).$(GEOM_EXT): $(BASE_FILE_NAME).$(GEOM_EXT) $(SLICER_CONFIG_FILE)
	prusa_slicer $(BASE_FILE_NAME).$(GEOM_EXT) --export-stl --duplicate 2 --load $(SLICER_CONFIG_FILE) -o $@

# render plate
$(PRINT_BED_CONTENT_FILE_NAME).png: $(PRINT_BED_CONTENT_FILE_NAME).$(GEOM_EXT) $(PRINT_BED_SCENE_FILE)
	openscad $(PRINT_BED_SCENE_FILE) -o $@ --preview --imgsize=2048,2048 --colorscheme "Tomorrow Night" -D file_name=\"$(PRINT_BED_CONTENT_FILE_NAME).$(GEOM_EXT)\"

clear: 
	rm *.$(GEOM_EXT)
	rm *.gcode
	rm *.png