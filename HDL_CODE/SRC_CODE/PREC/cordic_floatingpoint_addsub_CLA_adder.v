module cordic_floatingpoint_addsub_CLA_adder (
	//	Inputs
	input	[23:0]	iA,
	input	[23:0]	iB,
	input			addsub,
	
	//	Outputs
	output	[23:0]	oS,
	output			oC
);

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
 
 wire	[23:0]	B;
 
 wire	C0, C1, C2, C3, C4, C5;
 
/*****************************************************************************
 *                       reversed B (if necessary)                           *
 *****************************************************************************/
 
 assign B[23] = iB[23]^addsub;
 assign B[22] = iB[22]^addsub;
 assign B[21] = iB[21]^addsub;
 assign B[20] = iB[20]^addsub;
 assign B[19] = iB[19]^addsub;
 assign B[18] = iB[18]^addsub;
 assign B[17] = iB[17]^addsub;
 assign B[16] = iB[16]^addsub;
 assign B[15] = iB[15]^addsub;
 assign B[14] = iB[14]^addsub;
 assign B[13] = iB[13]^addsub;
 assign B[12] = iB[12]^addsub;
 assign B[11] = iB[11]^addsub;
 assign B[10] = iB[10]^addsub;
 assign B[9] = iB[9]^addsub;
 assign B[8] = iB[8]^addsub;
 assign B[7] = iB[7]^addsub;
 assign B[6] = iB[6]^addsub;
 assign B[5] = iB[5]^addsub;
 assign B[4] = iB[4]^addsub;
 assign B[3] = iB[3]^addsub;
 assign B[2] = iB[2]^addsub;
 assign B[1] = iB[1]^addsub;
 assign B[0] = iB[0]^addsub;
 
 assign oC = C5 ^ addsub;
 
/*****************************************************************************
 *                                  Adders                                   *
 *****************************************************************************/

 cordic_floatingpoint_addsub_CLA_4bits stage1(
	.iA		(iA[3:0]),
	.iB		(B[3:0]),
	.iC		(addsub),
	.oS		(oS[3:0]),
	.oC		(C0)
 );
 
 cordic_floatingpoint_addsub_CLA_4bits stage2(
	.iA		(iA[7:4]),
	.iB		(B[7:4]),
	.iC		(C0),
	.oS		(oS[7:4]),
	.oC		(C1)
 );
 
 cordic_floatingpoint_addsub_CLA_4bits stage3(
	.iA		(iA[11:8]),
	.iB		(B[11:8]),
	.iC		(C1),
	.oS		(oS[11:8]),
	.oC		(C2)
 );
 
 cordic_floatingpoint_addsub_CLA_4bits stage4(
	.iA		(iA[15:12]),
	.iB		(B[15:12]),
	.iC		(C2),
	.oS		(oS[15:12]),
	.oC		(C3)
 );
 
 cordic_floatingpoint_addsub_CLA_4bits stage5(
	.iA		(iA[19:16]),
	.iB		(B[19:16]),
	.iC		(C3),
	.oS		(oS[19:16]),
	.oC		(C4)
 );
 
 cordic_floatingpoint_addsub_CLA_4bits stage6(
	.iA		(iA[23:20]),
	.iB		(B[23:20]),
	.iC		(C4),
	.oS		(oS[23:20]),
	.oC		(C5)
 );
 
endmodule
