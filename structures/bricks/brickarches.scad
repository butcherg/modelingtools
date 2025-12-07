include <brickstyles.scad>


//dimension of the arch span
//span=96;
span=50;
//dimension of the arch's inner radius
rise=10;
//width of each brick, 
brickwidth=8;
//height of brick, edge on the radius
brickheight=3;
//depth of brick, edge on the radius
brickdepth=3;
//mortarwidth between bricks, edge on the radius
mortarwidth=1;


//Useful functions

//arcpoly produces a arc polygon dimensioned by the inner and outerradius and the angle.  
//polygons are started at 0 degrees, along the X axis out at the inner radius.  Up to 
//the user to rotate/translate them to suit.
function arcpoly( innerradius, outerradius, angle, segments) = 
	[	for (i = [0:angle/segments:angle]) [outerradius * cos(i), outerradius * sin(i) ],
		for (i = [angle:-angle/segments:0]) [innerradius * cos(i), innerradius * sin(i) ]
	];

function arc_halfpoly( innerradius, outerradius, angle, segments) = 
	[	for (i = [0:angle/segments:angle]) [outerradius * cos(i), outerradius * sin(i) ],
		[innerradius * cos(angle), innerradius * sin(angle) ],
		[innerradius * cos(0), innerradius * sin(0) ]
	];
		

//arcangle tells the angle of an arc from a circle, where the arc is defined by the chord, 
//which is the straignt line between the two endpoints of the arc.
function arcangle(chord, radius) = 2*asin(chord/(2*radius));

//arcradius tells the radius from the center-to-edge of a circle that contains a particular
//arc.  The arc is defined by its chord and saggital; the latter is the measure between the
//chord and the circle at the center of the chord.
//There's more than one way to skin a saggital, uncomment the one you like.  They both 
//yield the same answer, based on my limited testing:
//function arcradius(chord, sagittal) = ((sagittal*sagittal)+((chord/2)*(chord/2))) / (2*sagittal);
function arcradius(chord, sagittal) = (sagittal/2) + (chord*chord)/(8*sagittal);


//Brick pattern modules


module brick_pattern(brickstyle=0, pattern=0, sequence=0, reverse=0) {
	brickwidth=bricksizes[brickstyle][0];
	brickheight=bricksizes[brickstyle][1];
	brickdepth=bricksizes[brickstyle][2];
	mortarwidth=bricksizes[brickstyle][3];
	
	if (pattern == bpsimple) {
		cube([brickwidth, brickheight, brickdepth]);
	}
	else if (pattern == bpdoubleheader) {
		cube([brickdepth, brickheight, brickdepth]);
		translate([brickdepth+mortarwidth,0,0]) cube([brickdepth, brickheight, brickdepth]);
	}
	else if (pattern == bpornate) {
		if (reverse) {
			if (sequence % 2 == 0) {
				cube([brickwidth, brickheight, brickdepth]);
			}
			else {
				cube([brickdepth, brickheight, brickdepth]);
				translate([brickdepth+mortarwidth,0,0]) cube([brickdepth, brickheight, brickdepth]);
			}
		}
		else {
			if (sequence % 2 == 0) {
				cube([brickdepth, brickheight, brickdepth]);
				translate([brickdepth+mortarwidth,0,0]) cube([brickdepth, brickheight, brickdepth]);
			}
			else {
				cube([brickwidth, brickheight, brickdepth]);
			}
		}
	}
}


//Arch modules

//All arch modules render their object with the lower left corner of the arch anchored
//on the origin, to facilitate easy integration of them into a wall with a minimum of 
//(hopefully, no) "scooching".


//arch_brick: make a brick arch with the specfied span and rise, and put its 
//lower-left-hand corner on the origin for easy locating on a brick wall rendered 
//with other code.  Maximum rise should be less than or equal to span/2, which will 
//render a 180-degree arch.  This module makes straight bricks.
//module arch_brick(span, rise, brickwidth, brickheight, brickdepth, mortarwidth) {
module arch_brick(span, rise, brickstyle, pattern, reverse) {
	brickwidth=bricksizes[brickstyle][0];
	brickheight=bricksizes[brickstyle][1];
	brickdepth=bricksizes[brickstyle][2];
	mortarwidth=bricksizes[brickstyle][3];

	radius = arcradius(span, rise);
	sweepangle = arcangle(span, radius);
	brickangle = arcangle(brickheight, radius);
	mortarangle = arcangle(mortarwidth, radius);

	totalbricks = floor(sweepangle / (brickangle+mortarangle));
	totalbrickangle = brickangle * totalbricks;
	totalmortarangle = mortarangle * (totalbricks-1);
	residualmortar = sweepangle - (totalbrickangle+totalmortarangle);
	realmortarangle = mortarangle+(residualmortar/totalbricks);
				
	//positions the arch with the bottom touching the X axis, centered on the Y axis.  Facilitates
	//psitioning the arch referenced to the window center
	rotate([0,0,90])
		translate([-radius+rise,0,0])
			rotate([0,0,-sweepangle/2])
				
	{
		//right-hand anchor
		translate([radius,0,0]) 	//translate out to the radius
		brick_pattern(brickstyle=brickstyle, pattern=pattern, reverse=reverse);

		//right-hand segment
		for (i = [1:1:(totalbricks-2)]) 
			rotate([0,0,(brickangle+realmortarangle)*i+brickangle/2]) 	//rotate out to the position
				translate([radius,-brickheight/2,0]) 					//translate out to the radius
					brick_pattern(brickstyle=brickstyle, pattern=pattern, sequence=i, reverse=reverse);

		//left-hand anchor
		rotate([0,0,sweepangle])					//put it on the other end of the arch
			translate([radius,-brickheight,0]) 		//translate out to the radius
				brick_pattern(brickstyle=brickstyle, pattern=pattern, reverse=reverse);
	}
}

//arch_brick_tapered: make a brick arch with the specfied span and rise, and center 
//the arch on the Y axis, resting on the X axis, for easy locating on a brick wall rendered 
//with other code.  Maximum rise should be less than or equal to span/2, which will 
//render a 180-degree arch.  This module makes tapered bricks.
module arch_brick_tapered(span, rise, brickstyle) {
	brickwidth=bricksizes[brickstyle][0];
	brickheight=bricksizes[brickstyle][1];
	brickdepth=bricksizes[brickstyle][2];
	mortarwidth=bricksizes[brickstyle][3];

	radius = arcradius(span, rise);
	sweepangle = arcangle(span, radius);
	brickangle = arcangle(brickheight, radius);
	mortarangle = arcangle(mortarwidth, radius);
	
	totalbricks = floor(sweepangle / (brickangle+mortarangle));
	totalbrickangle = brickangle * totalbricks;
	totalmortarangle = mortarangle * (totalbricks-1);
	residualmortar = sweepangle - (totalbrickangle+totalmortarangle);
	mortarinterval = sweepangle / totalbricks;
	
	echo("totalbricks", totalbricks);
				
	//positions the arch with the bottom touching the X axis, centered on the Y axis.  Facilitates
	//positioning the arch referenced to the window center
	rotate([0,0,90])
		translate([-radius+rise,0,0])
			rotate([0,0,-sweepangle/2])
	{
		poly = arcpoly(radius, radius+brickwidth, sweepangle, 40);
		difference() {
			linear_extrude(brickdepth) polygon(poly);
			for (i = [mortarinterval:mortarinterval:sweepangle])
				rotate([0,0,i])
					translate([0,0,-brickdepth/2])
						cube([radius*2,mortarwidth,brickdepth*2]);
		}

	}
}

//arch_polygon: makes an arc polygon, used for defining difference() cutters 
//and mortar slabs.  extenddegrees adds that number to the ends of the arc.
module arch_polygon(span, rise, width, depth, extenddegrees) {
	radius = arcradius(span, rise);
	sweepangle = arcangle(span, radius);
	poly = arcpoly(radius, radius+width, sweepangle+extenddegrees*2, 90);
				
	//positions the arch with the bottom touching the X axis, centered on the Y axis.  Facilitates
	//positioning the arch referenced to the window center
	rotate([0,0,90])
		translate([-radius+rise,0,0])
			rotate([0,0,-sweepangle/2-extenddegrees])
					linear_extrude(depth) polygon(poly);
}

//arch_halfround: makes a half-circle, used for defining difference() cutters
module arch_halfround(span, depth, segments=90) {
		linear_extrude(depth) 
			polygon(arcpoly(0, span/2, 180, segments));
}

module arch_cutter(span, rise, brickstyle, depthscale) {
	brickwidth=bricksizes[brickstyle][0];
	brickheight=bricksizes[brickstyle][1];
	brickdepth=bricksizes[brickstyle][2];
	mortarwidth=bricksizes[brickstyle][3];
	
	width = brickwidth+mortarwidth*1;
	depth=brickdepth*depthscale;

	radius = arcradius(span, rise);
	sweepangle = arcangle(span, radius);
	mortarangle = arcangle(mortarwidth, radius);
	poly = arc_halfpoly(radius, radius+width, sweepangle+mortarangle*2, 90);
				
	//positions the arch with the bottom touching the X axis, centered on the Y axis.  Facilitates
	//positioning the arch referenced to the window center
	rotate([0,0,90])
		translate([-radius+rise,0,0])
			rotate([0,0,-sweepangle/2-mortarangle])
					linear_extrude(depth) polygon(poly);
}


//Test routines

//scale(25/4)
//scale(1/87) {

color("red")
	arch_brick(span=span, rise=rise, brickstyle=0, pattern=bpdoubleheader, reverse=1);
color("white") 
	arch_cutter(span=span, rise=rise, brickstyle=0, depthscale=0.8);


	//color("red") 
//	arch_brick_tapered(span=span, rise=rise, brickstyle=0);
//color("white") 
//	arch_polygon(span=span, rise=rise, width=brickwidth+mortarwidth*4, depth=brickheight*0.8, 2);

//arch_brick_tapered(span=span, rise=rise, brickwidth=brickwidth, brickheight=brickheight, brickdepth=brickdepth, mortarwidth=mortarwidth);
//arch_halfround(span=span, depth=10);

//} //scales


