
module brickpattern(width, height, brickwidth, brickheight, brickthickness, mortarwidth) {
	for (x = [0:1:width/brickwidth]) 
		for (y = [0:1:height/(brickheight+mortarwidth)]) {
			t = y % 2 ? 0 : brickwidth/2;
			translate([(x*(brickwidth+mortarwidth))-t,y*(brickheight+mortarwidth),0]) 
				cube([brickwidth, brickheight, brickthickness]);
		}
}

module brickwall(width, height, brickwidth, brickheight, brickthickness, mortarwidth, mortarthickness) {
	difference() {
		brickpattern(width, height, brickwidth, brickheight, brickthickness, mortarwidth);
		translate([-brickwidth,-height/2,-brickthickness/2]) 
			cube([brickwidth,height*2,brickthickness*2]);
		translate([width,-height/2,-brickthickness/2]) 
			cube([brickwidth*2,height*2,brickthickness*2]);	
		translate([-width/2,height,-brickthickness/2]) 
			cube([width*2, brickheight*2, brickthickness*2]);
	}
	cube([width, height, mortarthickness]);
}

brickwall(width=96, height=49, brickwidth=8, brickheight=4, brickthickness=4, 
	mortarwidth=0.5, mortarthickness=2);