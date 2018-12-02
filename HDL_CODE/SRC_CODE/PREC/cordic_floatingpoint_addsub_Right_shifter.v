module cordic_floatingpoint_addsub_Right_shifter (
	//	Inputs
	input	[3:0]	shift,
	input	[23:0]	in,
	
	//	Outputs
	output	[23:0]	out
);

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
 
 //	Stage 1 >>8
 wire	[23:0]	stage1;
 
 //	Stage 2 >>4
 wire	[23:0]	stage2;
 
 //	Stage 3 >>2
 wire	[23:0]	stage3;
 
 //	Stage 4 >>1
 wire	[23:0]	stage4;
 
/*****************************************************************************
 *                            Stage 1 shift 8                                *
 *****************************************************************************/
 
 assign stage1[23] = !shift[3] & in[23];
 assign stage1[22] = !shift[3] & in[22];
 assign stage1[21] = !shift[3] & in[21];
 assign stage1[20] = !shift[3] & in[20];
 assign stage1[19] = !shift[3] & in[19];
 assign stage1[18] = !shift[3] & in[18];
 assign stage1[17] = !shift[3] & in[17];
 assign stage1[16] = !shift[3] & in[16];
 assign stage1[15:0] = (shift[3]) ? in[23:8] : in[15:0];
 
/*****************************************************************************
 *                            Stage 2 shift 4                                *
 *****************************************************************************/
 
 assign stage2[23] = !shift[2] & stage1[23];
 assign stage2[22] = !shift[2] & stage1[22];
 assign stage2[21] = !shift[2] & stage1[21];
 assign stage2[20] = !shift[2] & stage1[20];
 assign stage2[19:0] = (shift[2]) ? stage1[23:4] : stage1[19:0];
 
/*****************************************************************************
 *                            Stage 3 shift 2                                *
 *****************************************************************************/
 
 assign stage3[23] = !shift[1] & stage2[23];
 assign stage3[22] = !shift[1] & stage2[22];
 assign stage3[21:0] = (shift[1]) ? stage2[23:2] : stage2[21:0];
 
/*****************************************************************************
 *                            Stage 4 shift 1                                *
 *****************************************************************************/
 
 assign stage4[23] = !shift[0] & stage3[23];
 assign stage4[22:0] = (shift[0]) ? stage3[23:1] : stage3[22:0];
 
 assign out = stage4;
 
endmodule
