/* brickpattern - makes brick wall patterns

Usage:
	use <path/to/brickpattern.scad>
	...
	brickpattern(
		layers=6, //how many rows of bricks
		run=10, //how many bricks in each row
		brickwidth=4, //individual brick width
		brickheight=2, //individual brick height
		brickthickness=1, //individual brick thickness
		mortar=0.3,  // width of mortar lines between bricks
		shift=0,  // start row has half-bricks on ends
		rand=0  //rotate each brick a random degree between 
				//-rand and rand
	);
	
The numbers given above are the defaults if you just do
brickpattern();  define them to suit your scale and intended 
brick style.
	
This routine just draws the bricks; you need to add a
cube of "mortar" in the dimensions of your wall into which
to embed the pattern.

To use in other programs, create your brick pattern in the 
required dimensions and export as a .STL file.  Note that
this will lose the color definition.

*/

module brickpattern(layers=6, run=10, brickwidth=4, 
brickheight=2, brickthickness=1, mortar=.3, shift=0, rand=0) {
	for (layer = [0:1:layers-1]) {
		reg = shift ? !(layer%2) : layer%2;
		for (brick = [0:1:run-1]) {			
			if (reg) {  //layer with half-bricks on each end
				if (brick == 0) {  //first brick, half-brick
					translate([	0, 
								layer*(brickheight+mortar), 
								0]) 
						color("Red") rotate([0,0,rands(-rand,rand,1)[0]]) cube([(brickwidth-mortar)/2, brickheight, brickthickness]);
				}
				else if (brick == run-1) { //last two bricks, a full one and ending with a half one...
					translate([	(brickwidth/2+mortar/2) + (brick)*(brickwidth+mortar), 
								layer*(brickheight+mortar), 
								0]) 
						color("Red") rotate([0,0,rands(-rand,rand,1)[0]]) cube([(brickwidth-mortar)/2, brickheight, brickthickness]);
					translate([	(brickwidth/2+mortar/2) + (brick-1)*(brickwidth+mortar), 
								layer*(brickheight+mortar), 
								0])
						color("Red") rotate([0,0,rands(-rand,rand,1)[0]]) cube([brickwidth, brickheight, brickthickness]);
				}
				else {  //second and subsequent full bricks
					translate([	(brickwidth/2+mortar/2) + (brick-1)*(brickwidth+mortar), 
								layer*(brickheight+mortar), 
								0]) 
						color("Red") rotate([0,0,rands(-rand,rand,1)[0]]) cube([brickwidth, brickheight, brickthickness]);
				}
			}
			else { // layer that doesn't contain half-bricks
				translate(	[brick*(brickwidth+mortar),
							layer*(brickheight+mortar), 
							0]) 
					color("Red") cube([brickwidth, brickheight, brickthickness]);

			}
		}
	}
}

brickpattern(16,6);