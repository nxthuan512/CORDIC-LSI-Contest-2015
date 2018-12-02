module	cordic_system
(
	//	Global signals
	input			iClk,
	input			iReset_n,
	//	Input signals 
	input			iData_valid,
	input	[23:0]	iData,
	//	Output signals
	output			oReady,
	output			oData_valid,
	output	[31:0]	oData_cos, 
	output	[31:0]	oData_sin
);

//	=================================================================
//	Reg/wire
//	=================================================================

wire		[10:0]	fifo_data;
wire		[10:0]	fifo_q;
wire				fifo_write_request;
wire				fifo_read_request;
wire				fifo_almost_full;
wire				fifo_empty;
wire				data_valid_flp_to_recovery;
wire		[31:0]	pre_sin;
wire		[31:0]	pre_cos;
wire		[3:0]	recovery_info;
//	=================================================================
//	Call modules
//	=================================================================
cordic_fixedpoint CORDIC_FIXEDPOINT
(
		.iClk					(iClk),
		.iReset_n				(iReset_n),
		.iData_valid			(iData_valid),
		.iData					(iData),
		.iFifo_almost_full		(fifo_almost_full),
		.oReady					(oReady),
		.oFifo_data				(fifo_data),
		.oFifo_write_request	(fifo_write_request)
);


cordic_fifo	CORDIC_FIFO 
	(
		.clock					(iClk),
		.data					(fifo_data),
		.rdreq					(fifo_read_request),
		.wrreq					(fifo_write_request),
		.almost_full			(fifo_almost_full),
		.empty					(fifo_empty),
		.q						(fifo_q)
);


cordic_floatingpoint CORDIC_FLOATINGPOINT (
		// Global signals
		.iClk					(iClk),
		.iRst_n					(iReset_n),
		// Inputs
		.iFifo_empty			(fifo_empty),
		.iFifo_q				(fifo_q),
		.oFifo_rdreq			(fifo_read_request),
		// Outputs
		.oData_valid			(data_valid_flp_to_recovery),
		.oRecovery_info			(recovery_info),
		.oPre_cos				(pre_cos),
		.oPre_sin				(pre_sin)
);
cordic_recovery_sin_cos		CORDIC_RECOVERY_SIN_COS
(
		.iClk					(iClk),
		.iReset_n				(iReset_n),
		.iData_valid			(data_valid_flp_to_recovery),
		.iPre_cos				(pre_cos),
		.iPre_sin				(pre_sin),
		.iRecovery_info			(recovery_info),
		.oData_valid			(oData_valid),
		.oSin					(oData_sin),
		.oCos					(oData_cos)
);

endmodule
