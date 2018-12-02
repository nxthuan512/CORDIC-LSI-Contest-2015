module	cordic_recovery_sin_cos
(
	//	Global signals
	input				iClk,
	input				iReset_n,
	//	Input signals
	input 				iData_valid,
	input	[31:0]		iPre_cos,
	input	[31:0]		iPre_sin,
	input	[3:0]		iRecovery_info,
	//	Output signals
	output	reg			oData_valid,
	output	reg	[31:0]	oSin,
	output	reg	[31:0]	oCos
);
//	===================================================================
//	Reg/wire
//	===================================================================
wire		[31:0]	sin_0;
wire		[31:0]	sin_1;
wire		[31:0]	sin_2;
wire		[31:0]	sin_3;
wire		[31:0]	sin_0_1;
wire		[31:0]	sin_2_3;
wire		[31:0]	p1_sin;

wire		[31:0]	cos_0;
wire		[31:0]	cos_1;
wire		[31:0]	cos_2;
wire		[31:0]	cos_3;
wire		[31:0]	cos_0_1;
wire		[31:0]	cos_2_3;
wire		[31:0]	p1_cos;

//	===================================================================
//	Combinational Circuits
//	===================================================================
	
assign	sin_0	=	iPre_sin;
assign	cos_0	=	iPre_cos;

assign	sin_1	=	{~iPre_sin[31],iPre_sin[30:0]};
assign	cos_1	=	{~iPre_cos[31],iPre_cos[30:0]};

assign	sin_2	=	iPre_cos;
assign	cos_2	=	iPre_sin;

assign	sin_3	=	{~iPre_cos[31],iPre_cos[30:0]};
assign	cos_3	=	{~iPre_sin[31],iPre_sin[30:0]};

assign	sin_0_1	= 	iRecovery_info[2]	?	sin_1	:	sin_0;
assign	sin_2_3	=	iRecovery_info[2]	?	sin_3	:	sin_2;

assign	cos_0_1	=	iRecovery_info[0]	?	cos_1	:	cos_0;
assign	cos_2_3	=	iRecovery_info[0]	?	cos_3	:	cos_2;

assign	p1_sin	=	iRecovery_info[3]	?	sin_2_3	:	sin_0_1;
assign	p1_cos	=	iRecovery_info[1]	?	cos_2_3	:	cos_0_1;

//	===================================================================
//	Sequential Circuits
//	===================================================================

always	@(posedge	iClk)
begin
	if (~iReset_n) 	oData_valid		<=	1'b0;
	else			oData_valid		<=	iData_valid;
end

always	@(posedge	iClk)
begin
	if (~iReset_n)	oCos			<=	32'h0;
	else			oCos			<=	p1_cos;	
end

always	@(posedge	iClk)
begin
	if	(~iReset_n)	oSin			<=	32'h0;
	else			oSin			<=	p1_sin;	
end

endmodule