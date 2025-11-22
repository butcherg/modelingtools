
module cutter45() {
	translate([0,0,1]) 
		rotate([0,0,-22.5]) 
			translate([-1,0,0])
				cube([4,2,3]);
	translate([0,0,1]) 
		rotate([0,0,22.5]) 
			translate([-3,0,0]) 
				cube([4,2,3]);

}

module block() {
	difference() {
		#cube([2,2,3.5]);
		//translate([0,0,-0.25]) rotate([0,0,0]) #cube([1,3,3]);
		translate([-0.7,-0.5,1]) cube([1,3,3]);
		translate([-0.5,-0.7,1]) cube([3,1,3]);
	}
}

module template() {
	ofst=1.25;
	difference() {
		translate([-0.25,-0.25,0])
			block();

		translate([ofst,ofst,0]) rotate([0,0,-45]) cutter45();
		translate([0.125,0.125,1]) cylinder(d=0.25, h=4, $fn=90);
		translate([1.2,1.2,1]) cylinder(d=0.25, h=4, $fn=90);
	}
}

scale(25.4)
//difference() {
	template();
//	translate([0.1,0.1,-0.1]) scale([0.85,0.85,0.85]) template();
	//rotate([0,0,45]) #cube([6,6,6]);
//}
