use <wainscotting.scad>

//Width of the wall opening into which the door will be inserted
opening_width=96;
//Height of the wall opening into which the door will be inserted
opening_height=120;
//Height of the transom, subtracted from the opening height
transom_height=24;
//Number of transom windows
transomwindow_quantity=3;
//Width of the boards used to make the door frame
board_width=4;
//Thickness of the boards used to make the door frame
board_thickness=2;


//opening_width=8*12;
//height=10*12;
//transom_height=2*12;
//transomwindow_quantity=8;
//boardwidth=4;
//boardthickness=2;
doorinset=2;
rotation=0;
//Use this to print the window with/without the spacing to allow inserting a printed window into a separate wall
inset=1;
//The modeling scale of the .stl file.  Specifies the denominator of the scale, e.g., 1/87 for HO scale, the default.  Assumes the dimensions specified in the previous parameters are prototype, e.g. 1:1.
modeling_scale=87;
//Scales the model for printing.  Default is 25.4, the multiplier to convert decimal inches to millimeters.
printing_scale=25.4;


module freight_door(opening_width=8*12, height=10*12, transom_height=2*12, transomwindow_quantity=8, boardwidth=4, boardthickness=2, doorinset=2, rotation=0) {
	//door core:
	translate([0,boardthickness/2,0])
		wainscotting(width=opening_width, height=height-transom_height, boardwidth=3, rotation=rotation);

	//horizontal door border:
	translate([0,0,0]) 
		cube([opening_width,boardthickness,boardwidth]);
	translate([0,0,height-transom_height]) 
		cube([opening_width,boardthickness,boardwidth]);
	translate([0,0,height-boardwidth-boardthickness]) 
		cube([opening_width,boardthickness,boardwidth+boardthickness]);

	//vertical door border
	translate([0,0,0]) 
		cube([boardwidth+boardthickness,boardthickness,height]);
	translate([opening_width-boardwidth-boardthickness,0,0]) 	
		cube([boardwidth+boardthickness,boardthickness,height]);
	
	//transom windows:
	transomwindow_width = (opening_width-boardwidth-boardthickness*2)/ transomwindow_quantity;
	for (i = [1:1:transomwindow_quantity])
		translate([(i*transomwindow_width)+boardthickness,0,height-transom_height]) 
			cube([boardwidth,boardthickness,transom_height]);

	//door frame:
	translate([-boardwidth/2,-boardwidth/2,height-boardwidth/2])
		cube([opening_width+boardwidth,boardthickness,boardwidth]);
	translate([0,-boardwidth/2,0])
		rotate([0,-90,0])
			cube([height+boardwidth/2,boardthickness,boardwidth]);
	translate([opening_width+boardthickness,-boardwidth/2,0])
		rotate([0,-90,0])
			cube([height+boardwidth/2,boardthickness,boardwidth]);

}

scale(printing_scale)
	scale(1/modeling_scale)
		freight_door();