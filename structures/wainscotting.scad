use <siding.scad>

module wainscotting(width=5*12, height=3*12, boardwidth=3, boardthickness=2, rotation=45) {
		o = width > height ? width*2 : height*2;
		rotate([90,0,0])
		translate([width/2,height/2,-boardthickness])
		intersection() {
			rotate([0,0,rotation])
				translate([-o/2, -o/2,0]) 
					planksiding(width=o, height=o, boardwidth=boardwidth, boardthickness=boardthickness, notch=0.2);
			translate([-width/2,-height/2,-boardthickness]) 
				cube([width, height, boardthickness*2]);
		}
}

//wainscotting();
wallthick=6;
//wainscotting(width=5*12, height=3*12, boardwidth=3, boardthickness=2, rotation=45);
wainscotting(width=2*12+wallthick*2, height=3*12, boardwidth=3, boardthickness=1,  rotation=-45);