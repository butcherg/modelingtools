/* clapboard - makes clapboard walls

Usage:
	use <path/to/siding.scad>
	...
	clapboard(
		width=10, //how wide, in units
		height=5, //how tall, in boards
		boardwidth=1, //individual board width
		boardthickness=0.1, //individual board thickness
		pitch=5, //angle of board pitch, in degrees
	);
	
The numbers given above are the defaults if you just do
clapboard();  define them to suit your scale and clapboard style.
	
To use in other programs, create your clapboard pattern in the 
required dimensions and export as a .STL file.  Note that
this will lose the color definition.

*/

module clapboard(width=10, height=5, boardwidth=1, boardthickness=0.1, pitch=5)
{
	translate([0,0,boardthickness]) //move the whole thing up above Z=0
		for (board = [0:1:height-1]) // number of boards, given by height
			translate ([0,board*boardwidth,0]) rotate([-pitch,0,0]) color("white") cube ([width, boardwidth, boardthickness]);
	
}

/* planksiding - makes plank walls

Usage:
	use <path/to/siding.scad>
	...
	planksiding(
		width=10, //how wide, in units
		height=5, //how tall, in boards
		boardwidth=1, //individual board width
		boardthickness=0.1, //individual board thickness
		notch=0.4,  //depth of the notch in the board interfaces,
					// 0=no notch, 1=notch is full depth of board.
	);
	
The numbers given above are the defaults if you just do
planksiding();  define them to suit your scale and clapboard style.
	
To use in other programs, create your planksiding in the 
required dimensions and export as a .STL file.  Note that
this will lose the color definition.

*/

module planksiding(width=10, height=5, boardwidth=1, boardthickness=0.1, notch=0.4)
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

translate([0,6,0]) clapboard();
planksiding();
