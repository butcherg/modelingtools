

module clapboard(width=10, height=5, boardwidth=1, boardthickness=.1, pitch=.01)
{
	translate([0,0,boardthickness]) //move the whole thing up above Z=0
		for (board = [0:1:height-1]) // number of boards, given by height
			translate ([0,board*boardwidth,0]) rotate([-pitch,0,0]) color("white") cube ([width, boardwidth, boardthickness]);
	
}


module planksiding(width=10, height=5, boardwidth=1, boardthickness=.1, notch=.1)
{	
	difference() {
		color("white") cube([width, height*boardwidth, boardthickness]);
		union() {
			for (board = [0:1:height])
				translate ([-width/2,board*boardwidth,boardthickness-(boardthickness * notch)]) 
					rotate([45,0,0]) cube (size=[width*2, boardthickness*3, boardthickness*3]);
		}
	}
}

clapboard();
planksiding();
