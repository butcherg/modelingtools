module panel_door(width=3*12, height=8*12, transom_height=1*12, transomwindow_quantity=3, boardwidth=3, boardthickness=2, number_panels=4) {
	//door core:
	translate([0,boardthickness/2,0])
		cube([width, boardthickness, height-transom_height]);

	//horizontal door border:
	translate([0,0,0]) 
		cube([width,boardthickness,boardwidth]);
	translate([0,0,height-transom_height]) 
		cube([width,boardthickness,boardwidth]);
	translate([0,0,height-boardwidth-boardthickness]) 
		cube([width,boardthickness,boardwidth+boardthickness]);

	//vertical door border
	translate([0,0,0]) 
		cube([boardwidth+boardthickness,boardthickness,height]);
	translate([width-boardwidth-boardthickness,0,0]) 	
		cube([boardwidth+boardthickness,boardthickness,height]);
	
	//transom windows:
	transomwindow_width = (width-boardwidth-boardthickness*2)/ transomwindow_quantity;
	for (i = [1:1:transomwindow_quantity])
		translate([(i*transomwindow_width)+boardthickness,0,height-transom_height]) 
			cube([boardwidth,boardthickness,transom_height]);
	
	for (i = [1:1:number_panels-1])
		translate([0,0,((height-transom_height)/number_panels)*i]) 
			cube([width,boardthickness,boardwidth*2]);

	//door frame:
	translate([-boardwidth/2,-boardwidth/2,height-boardwidth/2])
		cube([width+boardwidth,boardthickness,boardwidth]);
	translate([0,-boardwidth/2,0])
		rotate([0,-90,0])
			cube([height+boardwidth/2,boardthickness,boardwidth]);
	translate([width+boardthickness,-boardwidth/2,0])
		rotate([0,-90,0])
			cube([height+boardwidth/2,boardthickness,boardwidth]);
}

panel_door();