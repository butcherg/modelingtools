use <Round-Anything/polyround.scad>

//panel width:
panel_width = 32;
//panel height:
panel_height = 48;
//corrugation period, the width of one sequence of up-rib-down-rib:
corr_period = 2.6875;
//corrugation crown height, measured from the center of the undulations:
corr_height = 0.4375;
//corrugation crown radius, how rounded is the crown peak:
corr_radius = 0.7;
//corrugation peak rounding quality, how many points are used to make the curve.  Set to 1, makes flat peaks.  0 is invalid, reverts to 1:
corr_rounding=10;
//corrugation thickness (if 0, then panel_thick is used to make a backing:
corr_thick = 0.2;
//panel thickness (0 =  no panel, just corrugation):
panel_thick = 2;
//The modeling scale of the .stl file.  Specifies the denominator of the scale, e.g., 1/87 for HO scale, the default.  Assumes the dimensions specified in the previous parameters are prototype, e.g. 1:1.
modeling_scale=87;
//Scales the model for printing.  Default is 25.4, the multiplier to convert decimal inches to millimeters:
printing_scale=25.4;

module corrugated_panel(panel_width=panel_width, panel_height=panel_height, corr_period=corr_period, corr_height=corr_height, corr_radius=corr_radius, corr_rounding=corr_rounding, corr_thick=corr_thick, panel_thick=panel_thick) {
	peaks = panel_width / corr_period;

	corr_poly = [
		for (i= [0:corr_period/4:(peaks+1)*corr_period]) 
			if (i % corr_period ==  0) 						[i,0,0] 
			else if (i % corr_period == corr_period*0.75) 	[i,-corr_height,corr_radius]
			else if (i % corr_period == corr_period*0.50) 	[i,0,0]
			else if (i % corr_period == corr_period*0.25) 	[i,corr_height,corr_radius]
			,
	];
	
	r = corr_rounding < 1 ? 1 : corr_rounding; //0 is invalid, so hard-bound lower limit to 1
	
	translate([0,panel_height,panel_thick])
	rotate([90,0,0]) 
		if (corr_thick == 0) {  //make a solid wall with a corrugated surface
			c = concat(corr_poly, [[panel_width,-panel_thick,0], [0,-panel_thick,0], [0,0,0] ]);
			difference() {  //cut the right-hand side to panel_width
				linear_extrude(panel_height) polygon(polyRound(c,r));
				translate([panel_width,-panel_thick*20,-panel_height/2])
					cube([panel_thick*40,panel_thick*40,panel_height*2]);
			}
		}
		else {  //make a corrougated shape of corr_thick thickness
			po = [  //reverse-order corr_poly
				for (i= [len(corr_poly)-1:-1:0]) [corr_poly[i][0],corr_poly[i][1]+corr_thick,corr_poly[i][2]], 
			];
			c = concat(corr_poly, po);
			difference() { //cut the right-hand side to panel_width
				linear_extrude(panel_height) polygon(polyRound(c,r));
				translate([panel_width,-panel_thick*20,-panel_height/2])
					cube([panel_thick*40,panel_thick*40,panel_height*2]);
			}
		}
}

scale(printing_scale)
	scale(1/modeling_scale)
		corrugated_panel(panel_width=panel_width, panel_height=panel_height, corr_period=corr_period, corr_height=corr_height, corr_radius=corr_radius, corr_rounding=corr_rounding, corr_thick=corr_thick, panel_thick=panel_thick);