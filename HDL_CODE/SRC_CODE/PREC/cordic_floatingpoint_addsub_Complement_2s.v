module cordic_floatingpoint_addsub_Complement_2s (
	//	Inputs
	input	[23:0]	in,
	input			control,
	
	//	Output
	output	[23:0]	out
);

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
 
wire	[22:0]	comp;
wire	[21:0]	C;

/*****************************************************************************
 *                         2's complement circuit                            *
 *****************************************************************************/
 
assign comp[0] = in[1] ^ in[0];
assign C[0] = in[1] | in[0];

assign comp[1] = in[2] ^ C[0];
assign C[1] = in[2] | C[0];

assign comp[2] = in[3] ^ C[1];
assign C[2] = in[3] | C[1];

assign comp[3] = in[4] ^ C[2];
assign C[3] = in[4] | C[2];

assign comp[4] = in[5] ^ C[3];
assign C[4] = in[5] | C[3];

assign comp[5] = in[6] ^ C[4];
assign C[5] = in[6] | C[4];

assign comp[6] = in[7] ^ C[5];
assign C[6] = in[7] | C[5];

assign comp[7] = in[8] ^ C[6];
assign C[7] = in[8] | C[6];

assign comp[8] = in[9] ^ C[7];
assign C[8] = in[9] | C[7];

assign comp[9] = in[10] ^ C[8];
assign C[9] = in[10] | C[8];

assign comp[10] = in[11] ^ C[9];
assign C[10] = in[11] | C[9];

assign comp[11] = in[12] ^ C[10];
assign C[11] = in[12] | C[10];

assign comp[12] = in[13] ^ C[11];
assign C[12] = in[13] | C[11];

assign comp[13] = in[14] ^ C[12];
assign C[13] = in[14] | C[12];

assign comp[14] = in[15] ^ C[13];
assign C[14] = in[15] | C[13];

assign comp[15] = in[16] ^ C[14];
assign C[15] = in[16] | C[14];

assign comp[16] = in[17] ^ C[15];
assign C[16] = in[17] | C[15];

assign comp[17] = in[18] ^ C[16];
assign C[17] = in[18] | C[16];

assign comp[18] = in[19] ^ C[17];
assign C[18] = in[19] | C[17];

assign comp[19] = in[20] ^ C[18];
assign C[19] = in[20] | C[18];

assign comp[20] = in[21] ^ C[19];
assign C[20] = in[21] | C[19];

assign comp[21] = in[22] ^ C[20];
assign C[21] = in[22] | C[20];

assign comp[22] = in[23] ^ C[21];

/*****************************************************************************
 *                              Output Signal                                *
 *****************************************************************************/

assign out[0] = in[0];
assign out[23:1] = (control) ? comp : in[23:1];

endmodule
