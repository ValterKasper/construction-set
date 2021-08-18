include <BOSL2/std.scad>
include <tracks.scad>


module raindrop(r, thick, anchor=CENTER, spin=0, orient=UP) {
    anchors = [
        anchorpt("cap", [0,r/sin(45),0], BACK, 0)
    ];
    attachable(anchor,spin,orient, r=r, l=thick, anchors=anchors) {
        linear_extrude(height=thick, center=true) {
            circle(r=r);
            // back(r*sin(45)) zrot(45) square(r, center=true);
        }
        children();
    }
}

// raindrop(r=25, thick=20) show_anchors();;