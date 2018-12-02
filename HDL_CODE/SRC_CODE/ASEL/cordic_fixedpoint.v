module	cordic_fixedpoint
(
	//	Global signals
	input			iClk,
	input			iReset_n,
	//	Input signals 

	input			iData_valid,
	input	[23:0]	iData,
	input			iFifo_almost_full,

	//	Output signals
	output			oReady,
	output	[10:0]	oFifo_data,
	output			oFifo_write_request
);

//	================================================
//	Reg/wire
//	================================================
	wire	[3:0]	phase_normalize_info;
	wire	[1:0]	phase_check_last_rotation;
	wire			phase_sign;
	wire	[3:0]	phase_addr;
	
	wire			phase_init_flag;
	wire	[20:0]	phase_reg_abs;
	wire	[21:0]	phase_normalize;
	wire			phase_valid;

	reg		[3:0]	s1_phase_normalize_info;
//	================================================
//	Combinational circuits
//	================================================
assign	oFifo_data	= {s1_phase_normalize_info,phase_check_last_rotation,phase_sign,phase_addr};

//	================================================
//	Sequential circuits
//	================================================
always @ (posedge iClk)
begin
	if (~iReset_n)				s1_phase_normalize_info <= 4'h0;
	else if (phase_init_flag)	s1_phase_normalize_info <= phase_normalize_info;
end

//	================================================
//	Call modules
//	================================================
cordic_fixedpoint_anglenormalize	CORDIC_FIXEDPOINT_ANGLENORMALIZE
(
		.iClk					(iClk),
		.iReset_n				(iReset_n),
		.iPhase_valid			(iData_valid),
		.iPhase_data			(iData),
		.oPhase_valid			(phase_valid),
		.oPhase_normalize		(phase_normalize),
		.oPhase_normalize_info	(phase_normalize_info)
);

cordic_fixedpoint_control_logic		CORDIC_FIXEDPOINT_CONTROL_LOGIC
(
		.iClk					(iClk),
		.iReset_n				(iReset_n),
		.iCheck_last_rotation	(phase_check_last_rotation),
		.iFifo_almost_full		(iFifo_almost_full),
		.iPhase_normalize_data_valid			(phase_valid),
		.oReady					(oReady),
		.oFifo_write_request	(oFifo_write_request),
		.oPhase_init_flag		(phase_init_flag)
);

cordic_fixedpoint_updatephase		CORDIC_FIXEDPOINT_UPDATEPHASE
(
		.iClk				(iClk),
		.iReset_n			(iReset_n),
		.iPhase_init_flag	(phase_init_flag),
		.iPhase_addr		(phase_addr),
		.iPhase_normalize	(phase_normalize),
		.oPhase_reg_abs		(phase_reg_abs),
		.oPhase_sign		(phase_sign)
);

cordic_fixedpoint_get_phase_addr	CORDIC_FIXEDPOINT_GET_PHASE_ADDR
(
		.iPhase_abs				(phase_reg_abs),
		.oPhase_addr			(phase_addr)
);

cordic_fixedpoint_check_last_rotation	CORDIC_FIXEDPOINT_CHECK_LAST_ROTATION
(		
		.iPhase_abs					(phase_reg_abs),
		.oPhase_check_last_rotation	(phase_check_last_rotation)
		
);


endmodule