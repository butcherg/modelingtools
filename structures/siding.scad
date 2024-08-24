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

This module just presents the clapboard planks; to make a 
complete wall with a smooth back, union it with a cube of 
the width, height, and boardwidth of the clapboard pattern.
The example use code at the bottom of this file demonstrates this;
uncomment the cube() line by removing the two forward slashes 
(//).
	
To use in other programs, create your clapboard pattern in the 
required dimensions and export as a .STL file.  Note that
this will lose the color definition.

*/

//Lays out the pattern without consideration of height:
module clapboard_pattern(width, height, boardwidth, boardthickness, pitch) {
	for (board = [0:1:height/boardwidth]) // number of boards, given by height
		translate ([0,board*boardwidth,0]) rotate([-pitch,0,0]) cube ([width, boardwidth, boardthickness]);
}

module clapboard(width=96, height=43, boardwidth=4, boardthickness=1, pitch=5, wallthickness=1)
{
	difference()  {
		clapboard_pattern(width, height, boardwidth, boardthickness, pitch);
		translate([-width/2,height,-boardwidth/2]) cube([width*2, boardwidth*2, boardwidth*2]);
	}
	translate([0,0,-wallthickness]) cube([width, height, wallthickness]);
}

/* planksiding_old - makes plank walls

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
planksiding();  define them to suit your scale and clapboard 
style.
	
To use in other programs, create your planksiding in the 
required dimensions and export as a .STL file.  Note that
this will lose the color definition.

*/

module planksiding_old(width=10, height=5, boardwidth=1, boardthickness=0.1, notch=0.4)
{	
	difference() {
		cube([width, height*boardwidth, boardthickness]);
		union() {
			for (board = [0:1:height])
				translate ([-width/2,board*boardwidth,boardthickness-(boardthickness * notch)]) 
					rotate([45,0,0]) cube (size=[width*2, boardthickness*3, boardthickness*3]);
		}
	}
}


/* planksiding - makes plank walls

Usage:
	use <path/to/siding.scad>
	...
	planksiding(
		width=10, //how wide, in units
		height=5, //how tall, in units
		boardwidth=4, //individual board width
		boardthickness=1, //individual board thickness
		notch=0.3,  //depth of the notch in the board interfaces,
					// 0=no notch, 1=notch is full depth of board.
	);
	
The numbers given above are the defaults if you just do
planksiding();  define them to suit your scale and clapboard 
style.
	
To use in other programs, create your planksiding in the 
required dimensions and export as a .STL file.

*/


module planksiding(width=10*12, height=5*12, boardwidth=4, boardthickness=1, notch=0.3, wallthickness=1)
{	
	difference() {
		cube([width, height, boardthickness]);
		union() {
			for (board = [0:1:height/boardwidth])
				translate ([-width/2,board*boardwidth,boardthickness-(boardthickness * notch)]) 
					rotate([45,0,0]) cube (size=[width*2, boardthickness*3, boardthickness*3]);
		}
	}
	translate([0,0,-wallthickness]) cube([width, height, wallthickness]);
}

//clapboard();
//planksiding();

