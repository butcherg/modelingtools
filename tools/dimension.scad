function roundoff(n) = round(n*1000.0) / 1000.0;

//global variables, used by all modules:
linewidth=0.005;  //change to suit application
fontsize=0.05;	//change to suit application
fontdepth=fontsize/80; //make font really thin, so it looks flat as the render is rotated
ticksize = 0.001;
turnsize = 50;

/* dimension() - draws a dimension line

	start: start position of the dimension on the X axis
	end: end position of the dimension on the X axis
	height: height on the Z axis to position the dimension
	lines: length of the bound lines of the dimension
	handwheel: set to 1 to show the turns/ticks along with the label
	
*/
module dimension(start=0.01, end=0.2, height=0.05, lines=0.05, handwheel=false) {
	thous = roundoff((end-start) / ticksize);
	turns = floor(thous / turnsize);
	ticks = floor(thous % turnsize);
	nbr = end-start;
	txt = handwheel ? str(nbr," (",turns,"/",ticks,")") : str(nbr);
	textlen=fontsize*len(txt);
	color("black") {
		//end lines
		translate([start,0,height-(lines/2)])
			cylinder(d=linewidth, h=lines);
		translate([start+(end-start),0,height-(lines/2)])
			cylinder(d=linewidth, h=lines);
		
		if (textlen > end-start) { // put label to right of dimension
			translate([start, 0, height]) 
				rotate([0,90,0]) 
					cylinder(d=linewidth, h=end-start);
			//translate([start+(end-start)/2,0,height]) 
			translate([end+textlen/2,0,height]) 
				rotate([90,0,0]) 
					linear_extrude(fontdepth) text(text=txt, size=fontsize, halign="center", valign="center");
		}
		else {
		
			translate([start, 0, height]) 
				rotate([0,90,0]) 
					cylinder(d=linewidth, h=((end-start)/2)-textlen/2);
			translate([start+(((end-start)/2)+textlen/2), 0, height]) 
				rotate([0,90,0]) 
					cylinder(d=linewidth, h=((end-start)/2)-textlen/2);

			translate([start+(end-start)/2,0,height]) 
			//translate([end+textlen/2,0,height]) 
				rotate([90,0,0]) 
					linear_extrude(fontdepth) text(text=txt, size=fontsize, halign="center", valign="center");
		}
	}
}

/*
line_dash() - draws a vertical dashed line at 'at' on the X axis

	at: where to draw the line
	length: how tall is the line in the Z axis
	labelatbottom: set to 1 to move the label to the line bottom
	handwheel: set to 1 to show the turns/ticks along with the label
	
*/

module line_dash(at=0, length=1, labelatbottom=0, handwheel=0) {
	thous = roundoff((at) / ticksize);
	turns = floor(thous / turnsize);
	ticks = floor(thous % turnsize);
	txt = handwheel ? str(at," (",turns,"/",ticks,")") : str(at);
	textlen=fontsize*len(txt);
	translate([at,0,0])
	for (i=[0:fontsize/2:length]) {
		color("black") translate([0,0,i]) cylinder(d=linewidth, h=fontsize/3);
	}
	labelpos = labelatbottom ? -fontsize*1.2 : length+fontsize*1.2;
	translate([at,0,labelpos])
		rotate([90,0,0]) 
			color("black") linear_extrude(fontdepth) text(text=txt, size=fontsize, halign="center", valign="center");
}

/*
radial_line_dash() - draws a line rotated x degrees from the -X axis

	deg: degrees to rotate
	length: length of line
	
*/
module radial_line_dash(deg=0, length=1) {
	txt = str(deg, " deg");
	textlen=fontsize*len(txt);
	rotate([0,deg-90,0]) {
		for (i=[0:fontsize/2:length]) {
			color("black") translate([0,0,i]) cylinder(d=linewidth, h=fontsize/3);
		}
		translate([-textlen/3,0,length+fontsize]) 
			rotate([90,0,0]) 
				color("black") linear_extrude(fontdepth)text(text=txt, size=fontsize);
	}
}

/* examples:

//horizontal
dimension(start=0, end=2.675, height=0.35, lines=0.06);
dimension(start=0, end=0.83, height=0.45, lines=0.06);

//vertical:
translate([-0.35,0,2.275]) rotate([0,90,0]) dimension(start=0, end=2.275, lines=0.06);
translate([-0.15,0,0.275-1/16]) rotate([0,90,0]) dimension(start=0, end=0.275-1/16, lines=0.06);


//zero-datum:
line_dash(at=1, length=1.2);

*/