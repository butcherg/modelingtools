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
		mortar=0.3  // width of mortar lines between bricks
	);
	
The numbers given above are the defaults if you just do
brickpattern();
Define them to suit your scale and intended brick style.
	
This routine just draws the bricks; you need to add a
cube of "mortar" in the dimensions of your wall into which
to embed the pattern.abs

To use in other programs, create your brick pattern in the 
required dimensions and export as a .STL file.  Note that
this will lose the color definition.


*/

module brickpattern(layers=6, run=10, brickwidth=4, brickheight=2, brickthickness=1, mortar=.3) {
	translate ([-(brickwidth/2), 0, 0]) //moves the whole thing back over to the y axis for the half-brick width
	for (layer = [0:1:layers]) {
		shift = layer %2; //staggers every other layer
		for (brick = [0:1:run]) {
			if ((brick == 0) && (!shift) ) {  //half-brick for left side
				translate([brick*(brickwidth+mortar)+(shift*(brickwidth/2))+brickwidth/2, layer*(brickheight+mortar), 0]) 
					color("Red") cube([brickwidth/2, brickheight, brickthickness]);
			}
			else if ((brick == run) && (shift)) { //half-brick for right side
				translate([brick*(brickwidth+mortar)+(shift*(brickwidth/2)), layer*(brickheight+mortar), 0]) 
					color("Red") cube([brickwidth/2, brickheight, brickthickness]);
			}
			else { //full brick
				translate([brick*(brickwidth+mortar)+(shift*(brickwidth/2)), layer*(brickheight+mortar), 0]) 
						color("Red") cube([brickwidth, brickheight, brickthickness]);
			}
		}
	}
}

brickpattern();
