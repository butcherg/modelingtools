

//Width of roof sheet
sheet_width=144;
//Height of roof sheet
sheet_height=48;
//Shingle width
shingle_width=8;
//Shingle height
shingle_height=8;
//Shingle gap
shingle_gap=0.5;
//Shingle thickness
shingle_thickness=0.5;
//Shingle slant
shingle_slant=3;
//Roof thickness
roof_thickness=1;

//The modeling scale of the .stl file.  Specifies the denominator of the scale, e.g., 1/87 for HO scale, the default.  Assumes the dimensions specified in the previous parameters are prototype, e.g. 1:1.
modeling_scale=87;
//Scales the model for printing.  Default is 25.4, the multiplier to convert decimal inches to millimeters.
printing_scale=25.4;


module shingle(width, height, thickness, gap, slant=2) {
	rotate([-slant,0,0]) cube([width-gap, height, thickness]);
}

module shingle_pattern(sheet_width, sheet_height, shingle_gap, shingle_thickness, shingle_slant) {
	for (j = [0:shingle_width:sheet_height]) {
		for (i = [0:shingle_width:sheet_width]) {
			t = (j/shingle_width) % 2 ? 0: shingle_width/2;
			translate([i-t,j,0])
				shingle(shingle_width,shingle_height,shingle_thickness,shingle_gap, shingle_slant);
		}
	}
}
module shingle_sheet(width, height, shingle_gap, shingle_thickness, shingle_slant, roof_thickness) {
	maxrot = atan(shingle_thickness/shingle_height);
	rot = maxrot > shingle_slant ? shingle_slant : maxrot;
	difference() {
		union() {
			shingle_pattern(width,height,shingle_gap,shingle_thickness, rot);
			translate([0,0,-roof_thickness]) cube([width,height,roof_thickness]);
		}
		translate([-shingle_width*2,0,-shingle_thickness*5]) cube([shingle_width*2,height,shingle_thickness*10]);
		translate([width,0,-shingle_thickness*5]) cube([shingle_width*2,height,shingle_thickness*10]);
		translate([-shingle_width,height-0.001,-shingle_thickness*5]) cube([width+shingle_width*2,shingle_height*2,shingle_thickness*10]);
	}
}

scale(printing_scale)
	scale(1/modeling_scale)
		//shingle(8,8,0.5,0.5,shingle_slant);
		shingle_sheet(sheet_width,sheet_height,shingle_gap, shingle_thickness, shingle_slant, roof_thickness);