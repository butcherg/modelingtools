

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


module shingle(width, height, thickness, gap) {
	rotate([-2,0,0]) cube([width-gap, height, thickness]);
}

module shingle_pattern(sheet_width, sheet_height) {
	for (j = [0:shingle_width:sheet_height]) {
		for (i = [0:shingle_width:sheet_width]) {
			t = (j/shingle_width) % 2 ? 0: shingle_width/2;
			translate([i-t,j,0])
				shingle(shingle_width,shingle_height,shingle_thickness,shingle_gap);
		}
	}
}
module shingle_sheet(width, height) {
	difference() {
		union() {
			shingle_pattern(width,height);
			translate([0,0,-1]) cube([width,height,1]);
		}
		translate([-shingle_width*2,0,-shingle_thickness*5]) cube([shingle_width*2,height,shingle_thickness*10]);
		translate([width,0,-shingle_thickness*5]) cube([shingle_width*2,height,shingle_thickness*10]);
		translate([0,height,-shingle_thickness*5]) cube([width+shingle_width,shingle_height*2,shingle_thickness*10]);
	}
}

shingle_sheet(300,200);