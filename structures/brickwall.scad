use <C:/msys64/home/glenn/modelingtools/structures/brickpattern.scad>

//define the brick wall dimensions here
l=4;
r=5;
bw=4;
bh=2;
bt=2;
m=.3;

//mortar:
difference() {  //mortar: make a cube, then subtract the brick pattern from it
	color("white") cube([
						r*bw+(r-1)*m, //wall width
						l*bh+(l-1)*m, //wall height
						bt*0.8 //mortar thickness as a percentage of brick height
						]);
	translate([0,0,-bt/2]) //move it down (z-axis) to run through the bottom of the mortar cube
		brickpattern(	layers=l,
						run=r,
						brickwidth=bw, 
						brickheight=bh, 
						brickthickness=bt*2 //make them thick enough to run all the way through the mortar
		);
}

//bricks: 
brickpattern(	layers=l,
				run=r,
				brickwidth=bw, 
				brickheight=bh, 
				brickthickness=bt
);