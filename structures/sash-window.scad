/*
OpenSCAD configurable sash window window
Author: Glenn Butcher
License: CC-BY-4.0
*/


//Width of the wall opening into which the window will be inserted
opening_width=24+12;
//Height of the wall opening into which the window will be inserted
opening_height=48+48+18;
//Overall depth of the window
window_depth=4;

//Width of the boards used to make the window frame
board_width=4;
//Thickness of the boards used to make the window frame and sashes
board_thickness=1;

//Width of the muntins, the frame pieces that make up the sash
muntin_width=1;
//Depth of the sash frames
sash_depth=1;

//Number of sashes, max 3
number_sashes=3;

//Number of rows of panes in the upper sash
upper_sash_layout_rows=4;
//Number of columns of panes in the upper sash
upper_sash_layout_columns=4;

//Number of rows of panes in the middle sash
middle_sash_layout_rows=3;
//Number of columns of panes in the middle sash
middle_sash_layout_columns=4;

//Number of rows of panes in the lower sash
lower_sash_layout_rows=2;
//Number of columns of panes in the lower sash
lower_sash_layout_columns=4;

//Use this to change the depth of the upper sash
upper_sash_offset=0;
//Use this to change the depth of the lower sash
lower_sash_offset=0;


//Use this to print the window with/without the spacing to allow inserting a printed window into a separate wall
inset=1;
//The modeling scale of the .stl file.  Specifies the denominator of the scale, e.g., 1/87 for HO scale, the default.  Assumes the dimensions specified in the previous parameters are prototype, e.g. 1:1.
modeling_scale=87;
//Scales the model for printing.  Default is 25.4, the multiplier to convert decimal inches to millimeters.
printing_scale=25.4;





upper_sash_layout=[upper_sash_layout_rows,upper_sash_layout_columns]*1;
middle_sash_layout=[middle_sash_layout_rows,middle_sash_layout_columns]*1;
lower_sash_layout=[lower_sash_layout_rows,lower_sash_layout_columns]*1;


//draws a sash with the defined pane layout
module sash(width, height, thickness, depth, panelayout=[2,2]) {
	muntinsh = thickness*2 + thickness*(panelayout[0]-1); //accumulate muntins in height
	muntinsw = thickness*2 + thickness*(panelayout[1]-1); //accumulate muntins in width
	paneheight = (height-muntinsh)/(panelayout[0]);
	panewidth = (width-muntinsw)/(panelayout[1]);
	translate([depth,-width/2,0]) {
		rotate([0,-90,0]) {
			difference() {
				//base sash:
				cube([height, width, depth]);
		
				//subtract panes:
				for (r = [1:1:panelayout[0]]) { //rows
					for (c = [1:1:panelayout[1]]) {  //columns
						translate([thickness*r+paneheight*(r-1),thickness*c+panewidth*(c-1),-depth/2]) 
							cube([paneheight, panewidth, depth*2]);
					}
				}
			}
		}
	}
}

//draws a board in the x direction:
module board(length, width, thickness) {
		translate([0,-width/2,0]) cube([length, width, thickness]);
}

module windowframe(opening_width, opening_height, depth, board_width, board_thickness, inset=0) {
	difference() {
		union() {
			difference() {
				translate([0,-(opening_width+board_width)/2,0])
					cube([opening_height+board_width,opening_width+board_width,depth]);
				translate([-0.01,-(opening_width-board_thickness*2)/2,-depth*2]) //main opening
					cube([opening_height,opening_width-board_thickness*2,depth*4]);
			}
			translate([0,-(opening_width+board_width*2)/2,0])
				cube([board_thickness,opening_width+board_width*2,depth+board_width/2]);
		}
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


//draws a double-hung window anchored to an opening width and height with the specified sash layout:
module doublehung_window(opening_width, opening_height, depth, board_width, board_thickness, sashthickness, sash_depth, uppersash, middlesash, lowersash, inset) {
	rotate([0,-90,90])
	translate([0,-opening_width/2,-depth+board_thickness]) {
		windowframe(opening_width, opening_height, depth, board_width, board_thickness, inset);
		
		if (number_sashes == 2) {
			sh = ((opening_height-board_thickness)/2);
			//lower sash:
			translate([board_thickness+sh,0,sash_depth+sashthickness])			
				rotate([0,90,0]) 
					sash(opening_width-board_thickness*2,sh,sashthickness,sash_depth,uppersash);
			//upper sash:
			translate([board_thickness,0,sash_depth])			
				rotate([0,90,0]) 
					sash(opening_width-board_thickness*2,sh,sashthickness,sash_depth, lowersash);
		}
		else if (number_sashes == 3) {
			sh = ((opening_height-board_thickness)/3);
			//upper sash:
			translate([board_thickness+sh*2,0,sash_depth+sashthickness*2])			
				rotate([0,90,0]) 
					sash(opening_width-board_thickness*2,sh,sashthickness,sash_depth,uppersash);
			//middle sash:
			translate([board_thickness+sh,0,sash_depth+sashthickness])			
				rotate([0,90,0]) 
					sash(opening_width-board_thickness*2,sh,sashthickness,sash_depth,middlesash);
			//lower sash:
			translate([board_thickness,0,sash_depth])			
				rotate([0,90,0]) 
					sash(opening_width-board_thickness*2,sh,sashthickness,sash_depth, lowersash);
		}
		else {  // one sash, default
			sh = (opening_height-board_thickness);
			//only sash, uses lower sash numbers:
			translate([board_thickness,0,sash_depth+sashthickness])			
				rotate([0,90,0]) 
					sash(opening_width-board_thickness*2,sh,sashthickness,sash_depth,lowersash);
		}
	}
}

scale(printing_scale)
	scale(1/modeling_scale)
		doublehung_window(opening_width, opening_height, window_depth, board_width, board_thickness, muntin_width, sash_depth, upper_sash_layout, middle_sash_layout, lower_sash_layout, inset);

