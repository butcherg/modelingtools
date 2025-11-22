
module brickpattern(width, height, brickwidth, brickheight, brickthickness, mortarwidth, headerinterval, patternreverse=1) {
	
	for (y = [1:1:height/(brickheight+mortarwidth)+1]) {
		if (headerinterval > 0 && y % headerinterval == 0) {
			for (x = [0:1:width/(brickthickness+mortarwidth)+1]) {
				t = (brickthickness+mortarwidth)/2;
				translate([(x*(brickthickness+mortarwidth))-t,(y-1)*(brickheight+mortarwidth),0]) 
					cube([brickthickness, brickheight, brickthickness]);
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

module brickwall(width, height, brickwidth, brickheight, brickthickness, mortarwidth, mortarthickness, headerinterval) {
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

width=127; height=64; brickwidth=7.0+(5.0/8.0); brickheight=2.0+(1.0/4.0); brickthickness=3.0+(5.0/8.0); mortarwidth=3.0/8.0; mortarthickness=brickthickness/2.0;
headerinterval=6;

//width=900; height=600; brickwidth=7.0+(5.0/8.0); brickheight=2.0+(1.0/4.0); brickthickness=3.0+(5.0/8.0); mortarwidth=3.0/8.0; mortarthickness=brickthickness/2.0;
//headerinterval=6;


brickwall(width, height, brickwidth, brickheight, brickthickness, 
	mortarwidth, mortarthickness, headerinterval);
