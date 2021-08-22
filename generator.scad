include <liftarm.scad>
include <BOSL2/std.scad>

type = "";

     if (type == "liftarm_3") liftarm_3();
else if (type == "liftarm_2") liftarm_2();
else if (type == "liftarm_8") liftarm_8();
else echo(str("Unknown type ", type));
