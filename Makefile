SLICER_CONFIG_FILE = config.ini
OUTPUT_DIR = output

# generate gcode
$(OUTPUT_DIR)/%.gcode: $(OUTPUT_DIR)/%.stl $(SLICER_CONFIG_FILE)
	mkdir -p $(@D)
	prusa_slicer $< --export-gcode --load $(SLICER_CONFIG_FILE) -o $@

# generate geometry
$(OUTPUT_DIR)/%.stl: %.scad liftarm.scad
	mkdir -p $(@D)
	openscad $< -o $@

# render preview
$(OUTPUT_DIR)/%.png: %.scad
	mkdir -p $(@D)
	openscad $< \
		-o $@ \
		--render \
		--imgsize=1024,1024 \
		--colorscheme "Tomorrow Night" \

clear: 
	rm -f $(OUTPUT_DIR)/*.stl
	rm -f $(OUTPUT_DIR)/*.gcode
	rm -f $(OUTPUT_DIR)/*.png