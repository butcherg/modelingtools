bricksizes = [  //tuples are brickwidth, brickheight, brickthickness, mortarwidth
	[7.625,	2.25, 3.625, 0.375],		//0: modular, 3/8" mortar
	[7.5, 2.25, 3.5, 0.5]			//1: modular, 1/2" mortar
];

//brickstyles, reference rows in bricksizes
modular_3_8 = 0;	//modular, 3/8" mortar
modular_1_2 = 1;	//modular, 1/2" mortar

//arch patterns:
bpsimple = 0;		//single full-width brick
bpdoubleheader = 1;	//two header bricks
bpornate = 2;		//alternating full-width and two-header bricks

