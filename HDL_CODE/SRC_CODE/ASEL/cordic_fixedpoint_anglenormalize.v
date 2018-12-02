module 		cordic_fixedpoint_anglenormalize
(
		// Global signals
		input					iClk,
		input					iReset_n,
		// Inputs
		input					iPhase_valid,
		input	[23:0]			iPhase_data,
		// Outputs
		output  reg				oPhase_valid,
		output	reg	[21:0]		oPhase_normalize,
		output		[3:0]		oPhase_normalize_info
);

// ============================================================================
// Parameters
// ============================================================================


// ============================================================================
// Reg/wire 
// ============================================================================
wire	[7:0] 	angle_range_cmp;
wire	[2:0]	angle_addr;

wire	[3:0]	sign_sine_cos_normalize;

wire	[23:0]	phase_normalize_1_abs;
wire	[23:0]	phase_normalize_2;
wire	[23:0]	phase_normalize_3_abs;
wire	[23:0]	phase_normalize_4;
wire	[23:0]	phase_normalize_5_abs;
wire	[23:0]	phase_normalize_6;
wire	[23:0]	phase_normalize_7_abs;
wire	[23:0]	phase_normalize_output;

wire	[23:0]	mux_0_1;
wire	[23:0]	mux_2_3;
wire	[23:0]	mux_4_5;
wire	[23:0]	mux_6_7;
wire	[23:0]	mux_0_1_2_3;
wire	[23:0]	mux_4_5_6_7;
wire	[23:0]	rom_180;
wire	[23:0]	rom_90;

// ============================================================================
// Call module
// ============================================================================
cordic_fixedpoint_anglenormalize_cmp	CORDIC_FIXEDPOINT_ANGLENORMALIZE_CMP
(		
		.iPhase_input		(iPhase_data),		
		.oAngle_range_cmp	(angle_range_cmp),
		.oRom_180			(rom_180),
		.oRom_90			(rom_90)
);

cordic_fixedpoint_anglenormalize_encoder	CORDIC_FIXEDPOINT_ANGLENORMALIZE_ENCODER
(		.iAngle_range_cmp		(angle_range_cmp),
		.oAngle_position_addr	(angle_addr)
);

cordic_fixedpoint_anglenormalize_rom			CORDIC_FIXEDPOINT_ANGLENORMALIZE_ROM
(
	.iClk										(iClk),
	.iAddr_fixedpoint_normalize		(angle_addr), 
	.iAddr_fixedpoint_normalize_valid	(iPhase_valid),
	.oSign_sine_cos_normalize		(oPhase_normalize_info)
);

// ============================================================================
// Combinational Circuits
// ============================================================================
assign	phase_normalize_2		=	iPhase_data	+ rom_90;
assign	phase_normalize_4		=	iPhase_data	+ rom_180;
assign	phase_normalize_6		=	iPhase_data	- rom_90;
assign	phase_normalize_1_abs	=	(~iPhase_data 	+	1'b1);
assign	phase_normalize_3_abs	=	(~iPhase_data + 1'b1) - rom_90; 			
assign	phase_normalize_5_abs	=	rom_180 	- iPhase_data; 				
assign	phase_normalize_7_abs	=	rom_90	- iPhase_data;					

assign 	mux_0_1					=	angle_range_cmp[0]	? 	iPhase_data			:	phase_normalize_1_abs;
assign	mux_2_3					=	angle_range_cmp[2]	?	phase_normalize_2	:	phase_normalize_3_abs;
assign	mux_4_5					=	angle_range_cmp[4]	?	phase_normalize_4	:	phase_normalize_5_abs;
assign	mux_6_7					=	angle_range_cmp[6]	?	phase_normalize_6	:	phase_normalize_7_abs;

assign	mux_0_1_2_3				=	(angle_range_cmp[0]	| 	angle_range_cmp[1])	?	mux_0_1	: 	mux_2_3;
assign	mux_4_5_6_7				= 	(angle_range_cmp[4]	|	angle_range_cmp[5])	?	mux_4_5	:	mux_6_7;
 
assign	phase_normalize_output	= 	(|angle_range_cmp[3:0])	?	mux_0_1_2_3	:	mux_4_5_6_7;					


// ============================================================================
// Sequential Circuits
// ============================================================================
always @(posedge iClk)
begin
	if (~iReset_n)			oPhase_normalize	<=	22'h0;
	else if (iPhase_valid)	oPhase_normalize	<=	phase_normalize_output[21:0];
end


always	@(posedge	iClk)
begin
	if	(~iReset_n)		oPhase_valid			<=	1'b0;
	else				oPhase_valid			<=	iPhase_valid;
end


endmodule
