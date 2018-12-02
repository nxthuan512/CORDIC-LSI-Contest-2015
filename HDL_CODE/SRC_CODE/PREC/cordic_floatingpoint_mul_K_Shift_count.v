module cordic_floatingpoint_mul_K_Shift_count (
	//	Inputs
	input	[47:0]	in,
	
	//	Outputs
	output	[4:0]	shift,
	output	[7:0]	e
);

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
 
 //	Stage 1
 wire	or_47_46;
 wire	mux_47_45;
 wire	or_45_44;
 
 wire	or_43_42;
 wire	mux_43_41;
 wire	or_41_40;
 
 wire	or_39_38;
 wire	mux_39_37;
 wire	or_37_36;
 
 wire	or_35_34;
 wire	mux_35_33;
 wire	or_33_32;
 
 wire	or_31_30;
 wire	mux_31_29;
 wire	or_29_28;
 
 wire	or_27_26;
 wire	mux_27_25;
 wire	or_25_24;
 
 //	Stage 2
 wire			or_47_to_44;
 wire	[1:0]	mux_47_to_40;
 wire			or_43_to_40;
 
 wire			or_39_to_36;
 wire	[1:0]	mux_39_to_32;
 wire			or_35_to_32;
 
 wire			or_31_to_28;
 wire	[1:0]	mux_31_to_24;
 wire			or_27_to_24;
 
 //	Stage 3
 wire			or_47_to_40;
 wire	[2:0]	mux_47_to_32;
 wire			or_39_to_32;
 
 wire			or_31_to_24;
 wire	[2:0]	mux_31_to_end;
 
 //	Stage 4
 wire			or_47_to_32;
 wire	[3:0]	mux_47_to_24;
 
 //	Final Stage
 wire			zero;
 
/*****************************************************************************
 *                                  Stage 1                                  *
 *****************************************************************************/
 
 assign or_47_46 = in[47] | in[46];
 assign mux_47_45 = (or_47_46) ? in[47] : in[45];
 assign or_45_44 = in[45] | in[44];
 
 assign or_43_42 = in[43] | in[42];
 assign mux_43_41 = (or_43_42) ? in[43] : in[41];
 assign or_41_40 = in[41] | in[40];
 
 assign or_39_38 = in[39] | in[38];
 assign mux_39_37 = (or_39_38) ? in[39] : in[37];
 assign or_37_36 = in[37] | in[36];
 
 assign or_35_34 = in[35] | in[34];
 assign mux_35_33 = (or_35_34) ? in[35] : in[33];
 assign or_33_32 = in[33] | in[32];
 
 assign or_31_30 = in[31] | in[30];
 assign mux_31_29 = (or_31_30) ? in[31] : in[29];
 assign or_29_28 = in[29] | in[28];
 
 assign or_27_26 = in[27] | in[26];
 assign mux_27_25 = (or_27_26) ? in[27] : in[25];
 assign or_25_24 = in[25] | in[24];
 
/*****************************************************************************
 *                                  Stage 2                                  *
 *****************************************************************************/
 
 assign or_47_to_44 = or_47_46 | or_45_44;
 assign mux_47_to_40 = (or_47_to_44) ? {or_47_46, mux_47_45} : {or_43_42, mux_43_41};
 assign or_43_to_40 = or_43_42 | or_41_40;
 
 assign or_39_to_36 = or_39_38 | or_37_36;
 assign mux_39_to_32 = (or_39_to_36) ? {or_39_38, mux_39_37} : {or_35_34, mux_35_33};
 assign or_35_to_32 = or_35_34 | or_33_32;
 
 assign or_31_to_28 = or_31_30 | or_29_28;
 assign mux_31_to_24 = (or_31_to_28) ? {or_31_30, mux_31_29} : {or_27_26, mux_27_25};
 assign or_27_to_24 = or_27_26 | or_25_24;
 
/*****************************************************************************
 *                                  Stage 3                                  *
 *****************************************************************************/
 
 assign or_47_to_40 = or_47_to_44 | or_43_to_40;
 assign mux_47_to_32 = (or_47_to_40) ? {or_47_to_44, mux_47_to_40} : {or_39_to_36, mux_39_to_32};
 assign or_39_to_32 = or_39_to_36 | or_35_to_32;
 
 assign or_31_to_24 = or_31_to_28 | or_27_to_24;
 assign mux_31_to_end = {or_31_to_28, mux_31_to_24};
 
/*****************************************************************************
 *                                  Stage 4                                  *
 *****************************************************************************/
 
 assign or_47_to_32 = or_47_to_40 | or_39_to_32;
 assign mux_47_to_24 = (or_47_to_32) ? {or_47_to_40, mux_47_to_32} : {or_31_to_24, mux_31_to_end};
 
/*****************************************************************************
 *                                Final Stage                                *
 *****************************************************************************/
 
 assign shift = ~{or_47_to_32, mux_47_to_24};
 assign zero = or_47_to_32 | or_31_to_24;
 
/*****************************************************************************
 *                              Exponent part                                *
 *****************************************************************************/
 
 assign e[7:5] = { 1'b0, {(2){zero}} };
 assign e[4:0] = {or_47_to_32, mux_47_to_24};
 
endmodule
