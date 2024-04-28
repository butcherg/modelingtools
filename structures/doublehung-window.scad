/*
OpenSCAD double-hung window
Author: Glenn Butcher
License: CC-BY-4.0

Builds a double-hung window designed to fit in a specific wall opening. 
The pane layout of each sash can be specified as a pair of row,column 
values, e.g., [2,2] for a four-pane sash, two rows, two columns.

Instructions:

1. Install OpenSCAD.
2. Run OpenSCAD and load this script.
3. Change the below values to define your needed window.  The whole script
	works on the basis of a defined opening width and opening height in the 
	receiving wall.  The sash layout values are row,column pairs, tells the
	script to lay out sash panes in the number of rows and columns specified.
4. Render the window in the preview pane with the F5 key.
5. Repeat #3 and #4 until satisfied.
6. Render the final mesh with the F6 key.  Depending on your computer, this
	may take a few seconds.
7. Save the .stl file with the menu, File->Export...->Export as STL

Hacking:

The window frame is drawn as a set of calls to board(), so the boards aren't
too fancy.  You can define your own board_*() module(s) and replace the 
appropriate board calls in the windowframe() module.

The two sashes are placed like they would be in a real window, staggered
in depth.  You can change that by modifying the z parameter in the translate()
call before each sash() call in the doublehung_window() module.


*/

//Modify these values to suit your window requirements:
openingwidth=24;
openingheight=48;
windowdepth=5;
boardwidth=4;
boardthickness=1;
sashmuntinwidth=2;
sashdepth=2;
uppersashlayout=[2,2];
lowersashlayout=[2,2];
lowersashoffset=0;
uppersashoffset=0;

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

module windowframe(openingwidth, openingheight, depth, boardwidth, boardthickness, inset=0) {
	difference() {
		union() {
			difference() {
				translate([0,-(openingwidth+boardwidth)/2,0])
					cube([openingheight+boardwidth,openingwidth+boardwidth,depth]);
				translate([-0.01,-(openingwidth-boardthickness*2)/2,-depth*2]) //main opening
					cube([openingheight,openingwidth-boardthickness*2,depth*4]);
			}
			translate([0,-(openingwidth+boardwidth*2)/2,0])
				cube([boardthickness,openingwidth+boardwidth*2,depth+boardwidth/2]);
		}
		if (inset) {  //cutouts to support inserting a printed window into a hole
			translate([-openingheight,openingwidth/2,-0.01])
				cube([openingheight*3,boardwidth*2,depth-boardthickness]);
			translate([-openingheight,-(openingwidth/2)-boardwidth*2,-0.01])
				cube([openingheight*3,boardwidth*2,depth-boardthickness]);
			translate([openingheight+boardthickness,-openingwidth,-0.01])
				cube([boardwidth,openingwidth*2,depth-boardthickness]);
		}
	}
}


//draws a double-hung window anchored to an opening width and height with the specified sash layout:
module doublehung_window(openingwidth, openingheight, depth, boardwidth, boardthickness, sashthickness, sashdepth, uppersash, lowersash, inset) {
	translate([0,0,-depth+boardthickness]) {
		windowframe(openingwidth, openingheight, depth, boardwidth, boardthickness, inset);
		sh = ((openingheight-boardthickness)/2);
		translate([boardthickness+sh,0,sashdepth+sashthickness])			
			rotate([0,90,0]) 
				sash(openingwidth-boardthickness*2,sh,sashthickness,sashdepth,uppersash);
		translate([boardthickness,0,sashdepth])			
			rotate([0,90,0]) 
				sash(openingwidth-boardthickness*2,sh,sashthickness,sashdepth, lowersash);

	}
}

//scale(1/87)		//HO scale
//	scale(25.4) //inches to millimeters
		doublehung_window(openingwidth, openingheight, windowdepth, boardwidth, boardthickness, sashmuntinwidth, sashdepth, lowersashlayout, uppersashlayout, inset=1);

