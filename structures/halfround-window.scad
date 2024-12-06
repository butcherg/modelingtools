//Window diameter
diameter=36;
//Width of the frame components
framewidth=4; 
//Number of muntins
numbermuntins=3;
//Width of the muntins
muntinwidth=2;

//The modeling scale of the .stl file.  Specifies the denominator of the scale, e.g., 1/87 for HO scale, the default.  Assumes the dimensions specified in the previous parameters are prototype, e.g. 1:1.
modeling_scale=87;
//Scales the model for printing.  Default is 25.4, the multiplier to convert decimal inches to millimeters.
printing_scale=25.4;


module halfround_window(diameter=36, framewidth=4, numbermuntins=3, muntinwidth=2) {
	rotate([0,-90,0]) {

		difference() {
			cylinder(d=diameter);
			translate([0,0,-5]) cylinder(d=diameter-framewidth, h=10);
			translate([-(diameter+muntinwidth)/2,0,0]) cube([(diameter+muntinwidth/2),(diameter+muntinwidth/2),diameter], center=true);
		}
		translate([0,0,-1])
		difference() {
			cylinder(d=diameter-framewidth/2);
			translate([0,0,-diameter/2]) cylinder(d=diameter-framewidth, h=diameter);
			translate([-diameter/2,0,0]) cube([diameter+1,diameter+1,diameter], center=true);
		}
		translate([-framewidth/2+1,-diameter/2,0])
			cube([framewidth/2,diameter,1]);
		translate([-framewidth/2+2,-(diameter-2)/2,-muntinwidth/2])
			cube([framewidth/4,diameter-2,muntinwidth/2]);

		for (i = [1:1:numbermuntins]) {
			rotate([0,0,270+(180/(numbermuntins+1))*i]) 
				translate([muntinwidth/2,-muntinwidth/2,-muntinwidth/2])
					cube([diameter/2-framewidth/2, muntinwidth, muntinwidth]);
		}
	}
}

scale(printing_scale)
	scale(1/modeling_scale)
		halfround_window(diameter, framewidth, numbermuntins, muntinwidth);