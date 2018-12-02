module cordic_fixedpoint_updatephase
(
		//Global signals
		input				iClk,
		input				iReset_n,
		//	Input signals
		input 				iPhase_init_flag,
		input		[3:0]	iPhase_addr,
		input 		[21:0] 	iPhase_normalize,
		//	Output signals
		output 		[20:0]	oPhase_reg_abs,
		output 				oPhase_sign
);
//	======================================================
//	Reg/wire
//	======================================================
wire	[20:0]	theta_value;
reg 	[21:0] 	phase_reg;
//wire	[22:0] 	phase_reg_abs_tmp;
wire	[21:0]	z_sub_theta;
wire	[21:0]	z_add_theta;
wire	[21:0]	phase_update;	
wire	[22:0]	phase_update_not;

wire	[21:0]	z_sub_theta_not;
wire	[22:0]	z_add_theta_not;
wire	[21:0]	z_add_theta_abs;
wire	[21:0]	z_sub_theta_abs;

wire	[21:0]	phase_update_abs;
//wire	[22:0]	iPhase_normalize_abs;
reg	[21:0]	phase_reg_abs;
//	======================================================
//	Call modules
//	======================================================

cordic_fixedpoint_updatephase_rom_theta		CORDIC_FIXEDPOINT_UPDATEPHASE_ROM_THETA
(
		.iAddr_theta			(iPhase_addr), 
		.oTheta_value			(theta_value)	
);

//	======================================================
//	Combinational Circuits
//	======================================================

assign	z_sub_theta			=	(phase_reg - {1'b0, theta_value});
assign	z_add_theta			=	(phase_reg	+ {1'b0, theta_value});
assign	phase_update			=	oPhase_sign			?	z_add_theta	:	z_sub_theta;
//assign	phase_update_not	=	23'h000000				-	{1'b0,phase_update};
//assign	phase_update_abs	=	phase_update[21] 	?	phase_update_not[21:0]	 : phase_update;

assign	z_sub_theta_not	= 	{1'b0, theta_value}	-	phase_reg;
assign	z_add_theta_not	=	23'h000000				-	{1'b0,z_add_theta};

assign	z_sub_theta_abs	= 	z_sub_theta[21]?	z_sub_theta_not	:	z_sub_theta;
assign	z_add_theta_abs	=	z_add_theta[21]?	z_add_theta_not	:	z_add_theta;
assign	phase_update_abs	=	oPhase_sign		?	z_add_theta_abs	 	: z_sub_theta_abs;



//assign	iPhase_normalize_abs		=	23'h000000	-	{1'b0,iPhase_normalize};

assign	oPhase_sign 		= 	phase_reg[21];	
//assign	phase_reg_abs_tmp	= 	(oPhase_sign)	?	({1'b1, 22'b0} - phase_reg) : phase_reg;	
//assign	phase_reg_abs_tmp	= 	(23'h000000 - {1'b0, phase_reg});	
assign	oPhase_reg_abs		= 	oPhase_sign ? phase_reg_abs[20:0] : phase_reg[20:0];

//	======================================================
//	Sequential Circuits
//	======================================================

always @ (posedge iClk)
begin
	if (~iReset_n)
	begin
		phase_reg		<= 21'h0;
		phase_reg_abs	<= 22'h0;
	end
	else
	begin	
		phase_reg_abs 		<= 		(iPhase_init_flag)	? 	iPhase_normalize 		: phase_update_abs;		
		phase_reg			<=			(iPhase_init_flag)	? 	iPhase_normalize		: phase_update;		
	end
end
endmodule
