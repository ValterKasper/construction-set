BASE_FILE_NAME=liftarm
SLICER_CONFIG_FILE=config.ini
GEOM_EXT=stl
PRINT_BED_CONTENT_FILE_NAME=print_bed_content
PRINT_BED_SCENE_FILE=print_bed_scene.scad

# generate gcode for 3d printing
liftarm_2.gcode: liftarm_2.$(GEOM_EXT) $(SLICER_CONFIG_FILE)
	prusa_slicer liftarm_2.$(GEOM_EXT) --export-gcode --load $(SLICER_CONFIG_FILE) -o $@

preview_gcode: liftarm_2.gcode
	prusa_slicer --gcodeviewer $^

preview_slicer: liftarm_2.$(GEOM_EXT)
	prusa_slicer --load $(SLICER_CONFIG_FILE) $^

# generate liftarm_2 geometry file
liftarm_2.$(GEOM_EXT): $(BASE_FILE_NAME).scad
	openscad generator.scad -D type=\"liftarm_2\" -o $@

# generate liftarm_3 geometry file
liftarm_3.$(GEOM_EXT): $(BASE_FILE_NAME).scad
	openscad generator.scad -D type=\"liftarm_8\" -o $@

# generate liftarm_8 geometry file
liftarm_3.$(GEOM_EXT): $(BASE_FILE_NAME).scad
	openscad generator.scad -D type=\"liftarm_3\" -o $@

# generate geometry on plate for render
$(PRINT_BED_CONTENT_FILE_NAME).$(GEOM_EXT): liftarm_2.$(GEOM_EXT) liftarm_3.$(GEOM_EXT) liftarm_8.$(GEOM_EXT) $(SLICER_CONFIG_FILE)
	prusa_slicer \
		liftarm_2.$(GEOM_EXT) \
		liftarm_2.$(GEOM_EXT) \
		liftarm_3.$(GEOM_EXT) \
		liftarm_8.$(GEOM_EXT) \
		--merge --export-stl --load $(SLICER_CONFIG_FILE) -o $@

# render plate
$(PRINT_BED_CONTENT_FILE_NAME).png: $(PRINT_BED_CONTENT_FILE_NAME).$(GEOM_EXT) $(PRINT_BED_SCENE_FILE)
	openscad $(PRINT_BED_SCENE_FILE) -o $@ --preview --imgsize=2048,2048 --colorscheme "Tomorrow Night" -D file_name=\"$(PRINT_BED_CONTENT_FILE_NAME).$(GEOM_EXT)\"

render_print_bed: $(PRINT_BED_CONTENT_FILE_NAME).png

clear: 
	rm -f *.$(GEOM_EXT)
	rm -f *.gcode
	rm -f *.png