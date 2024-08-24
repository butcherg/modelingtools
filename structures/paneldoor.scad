//Width of the wall opening into which the door will be inserted
opening_width=36;
//Height of the wall opening into which the door will be inserted
opening_height=96;
//Height of the transom, subtracted from the opening height
transom_height=12;
//Number of transom windows
transomwindow_quantity=3;
//Width of the boards used to make the door frame
board_width=3;
//Thickness of the boards used to make the door frame
board_thickness=2;
//Number of panels in the door
number_panels=4;
//Use this to print the window with/without the spacing to allow inserting a printed window into a separate wall
inset=1;
//The modeling scale of the .stl file.  Specifies the denominator of the scale, e.g., 1/87 for HO scale, the default.  Assumes the dimensions specified in the previous parameters are prototype, e.g. 1:1.
modeling_scale=87;
//Scales the model for printing.  Default is 25.4, the multiplier to convert decimal inches to millimeters.
printing_scale=25.4;

module doorframe(opening_width, opening_height, depth, board_width, board_thickness, inset=0) {
	difference() {
		//union() {
			difference() {
				translate([0,-(opening_width+board_width)/2,0])
					cube([opening_height+board_width,opening_width+board_width,depth]);
				translate([-0.01,-(opening_width-board_thickness*2)/2,-depth*2]) //main opening
					cube([opening_height,opening_width-board_thickness*2,depth*4]);
			}
			//translate([0,-(opening_width+board_width*2)/2,0])
			//	cube([board_thickness,opening_width+board_width*2,depth+board_width/2]);
		//}
		if (inset) {  //cutouts to support inserting a printed window into a hole
			translate([-opening_height,opening_width/2,-0.01])
				cube([opening_height*3,board_width*2,depth-board_thickness]);
			translate([-opening_height,-(opening_width/2)-board_width*2,-0.01])
				cube([opening_height*3,board_width*2,depth-board_thickness]);
			translate([opening_height+board_thickness,-opening_width,-0.01])
				cube([board_width,opening_width*2,depth-board_thickness]);
		}
	}
}

module panel_door(opening_width=3*12, opening_height=8*12, transom_height=1*12, transomwindow_quantity=3, board_width=3, board_thickness=2, number_panels=4) {
	//door core:
	translate([0,board_thickness/2,0])
		cube([opening_width, board_thickness, opening_height-transom_height]);

	//horizontal door border:
	translate([0,0,0]) 
		cube([opening_width,board_thickness,board_width]);
	translate([0,0,opening_height-transom_height]) 
		cube([opening_width,board_thickness,board_width]);
	//top transom frame, commented out because it eats into transom height:
	//translate([0,0,opening_height-board_width-board_thickness]) 
	//	cube([opening_width,board_thickness,board_width+board_thickness]);

	//vertical door border
	translate([0,0,0]) 
		cube([board_width+board_thickness,board_thickness,opening_height]);
	translate([opening_width-board_width-board_thickness,0,0]) 	
		cube([board_width+board_thickness,board_thickness,opening_height]);
	
	//transom windows:
	transomwindow_width = (opening_width-board_width-board_thickness*2)/ transomwindow_quantity;
	for (i = [1:1:transomwindow_quantity-1])
		translate([(i*transomwindow_width)+board_thickness,0,opening_height-transom_height]) 
			cube([board_width,board_thickness,transom_height]);
	
	for (i = [1:1:number_panels-1])
		translate([0,0,((opening_height-transom_height)/number_panels)*i]) 
			cube([opening_width,board_thickness,board_width*2]);

	//door frame:
	translate([opening_width/2,board_thickness,0])
		rotate([90,-90,0])
			doorframe(opening_width, opening_height, board_thickness*2, board_width, board_thickness, inset);
}

scale(printing_scale)
	scale(1/modeling_scale)
		panel_door(opening_width=opening_width, opening_height=opening_height, transom_height=transom_height, transomwindow_quantity=transomwindow_quantity, board_width=board_width, board_thickness=board_thickness, number_panels=number_panels);