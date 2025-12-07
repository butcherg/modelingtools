
include <brickstyles.scad>

module brickpattern(width, height, brickwidth, brickheight, brickthickness, mortarwidth, headerinterval=0, headerstyle=0, patternreverse=0) {
	
	for (y = [1:1:height/(brickheight+mortarwidth)+1]) {
		if (headerinterval > 0 && y % headerinterval == 0) {
			if (headerstyle == 0) { //regular headers
				for (x = [0:1:width/(brickthickness+mortarwidth)+1]) {
					t = (brickthickness+mortarwidth)/2;
					translate([(x*(brickthickness+mortarwidth))-t,(y-1)*(brickheight+mortarwidth),0]) 
						cube([brickthickness, brickheight, brickthickness]);
				}
			}
			else {  //flemish headers
				for (x = [0:1:width/(brickthickness+brickwidth+mortarwidth*2)+1]) {
					t = (brickthickness+brickwidth+mortarwidth*2)/2;
					translate([(x*(brickthickness+brickwidth+mortarwidth*2))-t,(y-1)*(brickheight+mortarwidth),0]) 
						cube([brickthickness, brickheight, brickthickness]);
					translate([(x*(brickthickness+brickwidth+mortarwidth*2))+brickthickness+mortarwidth-t,(y-1)*(brickheight+mortarwidth),0]) 
						cube([brickwidth, brickheight, brickthickness]);
				}
			}
		}
		else {
			if (patternreverse == 0) {
				for (x = [0:1:width/(brickwidth+mortarwidth)+1]) {
					t = y % 2 ? 0 : brickwidth/2;
					translate([(x*(brickwidth+mortarwidth))-t,(y-1)*(brickheight+mortarwidth),0]) 
						cube([brickwidth, brickheight, brickthickness]);
				}
			}
			else {
				for (x = [0:1:width/(brickwidth+mortarwidth)+1]) {
					t = y % 2 ? brickwidth/2 : 0 ;
					translate([(x*(brickwidth+mortarwidth))-t,(y-1)*(brickheight+mortarwidth),0]) 
						cube([brickwidth, brickheight, brickthickness]);
				}
			}
		}
	}
}

module brickwall_manual(width, height, brickwidth, brickheight, brickthickness, mortarwidth, mortarthickness, headerinterval, patternreverse) {
	difference() {
		brickpattern(width, height, brickwidth, brickheight, brickthickness, mortarwidth, headerinterval);
		translate([-brickwidth,-height/2,-brickthickness/2]) 
			cube([brickwidth,height*2,brickthickness*2]);
		translate([width,-height/2,-brickthickness/2]) 
			cube([brickwidth*2,height*2,brickthickness*2]);	
		translate([-width/2,height,-brickthickness/2]) 
			cube([width*2, brickheight*2, brickthickness*2]);
	}
	cube([width, height, mortarthickness]);
}

module brickwall(width, height, brickstyle, mortarthickness, headerinterval, headerstyle,  patternreverse, mortar=1) {
	brickwidth=bricksizes[brickstyle][0];
	brickheight=bricksizes[brickstyle][1];
	brickthickness=bricksizes[brickstyle][2];
	mortarwidth=bricksizes[brickstyle][3];
	difference() {
		color("red") brickpattern(width, height, brickwidth, brickheight, brickthickness, mortarwidth, headerinterval, headerstyle, patternreverse);
		translate([-brickwidth,-height/2,-brickthickness/2])	//left cutter
			cube([brickwidth,height*2,brickthickness*2]);
		translate([width,-height/2,-brickthickness/2]) 			// right cutter
			cube([brickwidth*4,height*2,brickthickness*2]);	
		translate([-width/2,height,-brickthickness/2]) 			// top cutter
			cube([width*2, brickheight*2, brickthickness*2]);
	}
	if (mortarthickness) translate([0,0,-0.01]) color("white") cube([width, height, brickthickness*0.90]);
}

module soldiercourse(width, brickstyle, vertical=1, mortar=1)
{
	brickwidth=bricksizes[brickstyle][0];
	brickheight=bricksizes[brickstyle][1];
	brickthickness=bricksizes[brickstyle][2];
	mortarwidth=bricksizes[brickstyle][3];
	
	for (x = [0:brickheight+mortarwidth:width])
		translate([x,0,0]) 
			if (vertical)
				color("red") cube([brickheight, brickwidth, brickthickness]);
			else
				color("red") cube([brickheight, brickthickness, brickwidth]);
}

module brick(header=0) {
	brickwidth=bricksizes[brickstyle][0];
	brickheight=bricksizes[brickstyle][1];
	brickthickness=bricksizes[brickstyle][2];
	if (header) 
		color("red") cube([brickthickness, brickheight, brickwidth]);
	else
		color("red") cube([brickwidth, brickheight, brickthickness]);
}

width=127.5; height=65.5; 

//modular, 3/8" joints:
//brickwidth=7.625;	brickheight=2.25; brickthickness=3.625; mortarwidth=0.375;

//modular, 1/2" joints:
brickwidth=7.5; brickheight=2.25; brickthickness=3.5; mortarwidth=0.5;

brickstyle=1;
mortarthickness=brickthickness/2.0;
headerinterval=6;
headerstyle=1;
patternreverse=0;
vertical=0;

brickwall(width, height,  brickstyle, mortarthickness, headerinterval, headerstyle, patternreverse);
//soldiercourse(width, brickstyle, vertical, mortarthickness);