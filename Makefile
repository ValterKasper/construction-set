SLICER_CONFIG_FILE = config.ini
PRINT_BED_CONTENT = print_bed_content
PRINT_BED_SCENE_FILE = print_bed_scene.scad
GEOMS = liftarm_2.stl liftarm_3.stl liftarm_8.stl liftarm_8.stl

$(PRINT_BED_CONTENT).stl: $(GEOMS) $(SLICER_CONFIG_FILE)
	prusa_slicer \
		$(GEOMS) \
		--merge --export-stl --load $(SLICER_CONFIG_FILE) -o $@

$(PRINT_BED_CONTENT).gcode: $(PRINT_BED_CONTENT).stl $(SLICER_CONFIG_FILE)
	prusa_slicer \
		$< \
		--export-gcode --load $(SLICER_CONFIG_FILE) -o $(PRINT_BED_CONTENT).gcode

$(PRINT_BED_CONTENT).png: $(PRINT_BED_CONTENT).stl $(PRINT_BED_SCENE_FILE)
	openscad \
		$(PRINT_BED_SCENE_FILE) \
		-o $@ \
		--preview \
		--imgsize=2048,2048 \
		--colorscheme "Tomorrow Night" \
		-D file_name=\"$(PRINT_BED_CONTENT).stl\"

print_bed_preview: $(PRINT_BED_CONTENT).stl
	prusa_slicer --load $(SLICER_CONFIG_FILE) $<

# generate gcode
%.gcode: %.stl $(SLICER_CONFIG_FILE)
	prusa_slicer $< --export-gcode --load $(SLICER_CONFIG_FILE) -o $@

# generate geometry
%.stl: %.scad
	openscad $< -o $@

clear: 
	rm -f *.stl
	rm -f *.gcode
	rm -f *.png