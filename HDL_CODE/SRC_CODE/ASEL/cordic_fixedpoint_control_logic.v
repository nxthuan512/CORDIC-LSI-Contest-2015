module cordic_fixedpoint_control_logic
(
	input			iClk,
	input			iReset_n,
	input	[1:0]	iCheck_last_rotation,
	input			iFifo_almost_full,
	input			iPhase_normalize_data_valid,
	output 			oReady,
	output			oFifo_write_request,
	output		oPhase_init_flag				//control mux
);

wire	check_last_rotation_eq_1;
wire	s1_check_last_rotation_eq_0;

reg 			phase_last_check;
reg  			s1_phase_init_flag;
reg		[1:0]	s1_check_last_rotation;



//	==============================================================
//	Combinational circuits
//	==============================================================
assign check_last_rotation_eq_1 = |iCheck_last_rotation;
assign	s1_check_last_rotation_eq_0	 = ~|s1_check_last_rotation;

//	===================	oReady	==================================
// (< threshold) or last rotation
assign	oPhase_init_flag	=	check_last_rotation_eq_1 & (phase_last_check | iPhase_normalize_data_valid);

assign 	oFifo_write_request = 	(s1_phase_init_flag)	| ~check_last_rotation_eq_1 | 
								(s1_check_last_rotation_eq_0 & ~iCheck_last_rotation[1] & iCheck_last_rotation[0]);

//	==============================================================
//	Sequential circuits
//	==============================================================
always @ (posedge iClk)
begin
	if(~iReset_n)							phase_last_check <=	1'b0;	
	else if (oPhase_init_flag)				phase_last_check <= 1'b0;
	else if (iPhase_normalize_data_valid)	phase_last_check <= 1'b1;
end


always	@(posedge	iClk)
begin
	if(~iReset_n)	s1_phase_init_flag		<=	1'b0;
	else			s1_phase_init_flag		<=	oPhase_init_flag;
end


always	@(posedge	iClk)
begin
	if(~iReset_n)	s1_check_last_rotation		<=	2'b0;
	else			s1_check_last_rotation		<=	iCheck_last_rotation;
end

assign oReady		=	~iFifo_almost_full & ~iPhase_normalize_data_valid & check_last_rotation_eq_1;


endmodule