module cordic_fixedpoint_get_phase_addr_priority_16to4
(			
			input			[15:0]	iPhase_cmp_C,			//iPhase_cmp_C,
			output wire 	[3:0] 	oTheta_addr					//oPhase_addr,
//			output					oPhase_valid//oValid
);
//	===========================================================================
//	reg/wire
//	===========================================================================
wire	[1:0] 	cmp_0_3,	cmp_4_7,	cmp_8_11,	cmp_12_to_16;

wire 	[3:0] 	phase_cmp_0_3, phase_cmp_4_7,	phase_cmp_8_11, phase_cmp_12_16;

//	===========================================================================
//	Combinational circuits
//	===========================================================================

assign 	phase_cmp_0_3 		= 	{iPhase_cmp_C[0],iPhase_cmp_C[1],iPhase_cmp_C[2],iPhase_cmp_C[3]};
assign 	phase_cmp_4_7 		= 	{iPhase_cmp_C[4],iPhase_cmp_C[5],iPhase_cmp_C[6],iPhase_cmp_C[7]};
assign 	phase_cmp_8_11 		= 	{iPhase_cmp_C[8],iPhase_cmp_C[9],iPhase_cmp_C[10],iPhase_cmp_C[11]};
assign 	phase_cmp_12_16 	= 	{iPhase_cmp_C[12],iPhase_cmp_C[13],iPhase_cmp_C[14],iPhase_cmp_C[15]};

assign 	oTheta_addr 	= 	(|phase_cmp_0_3)? {2'b00, cmp_0_3} :
							(|phase_cmp_4_7)? {2'b01, cmp_4_7} :
							(|phase_cmp_8_11)? {2'b10, cmp_8_11} :
							(|phase_cmp_12_16)? {2'b11, cmp_12_to_16} : 	4'h0;					
//assign	oPhase_valid	= 	(|iPhase_cmp_C);					//this variable used to remove value 0000 if input angles = 0. It do not need in new system						
				

//	===========================================================================
//	Call modules
//	===========================================================================

cordic_fixedpoint_get_phase_addr_priority_4_to_2	CMP_0_3
(
			.in0(iPhase_cmp_C[0]),
			.in1(iPhase_cmp_C[1]),
			.in2(iPhase_cmp_C[2]),
			.in3(iPhase_cmp_C[3]),
			.out(cmp_0_3)
);
cordic_fixedpoint_get_phase_addr_priority_4_to_2	CMP_4_7
(
			.in0(iPhase_cmp_C[4]),
			.in1(iPhase_cmp_C[5]),
			.in2(iPhase_cmp_C[6]),
			.in3(iPhase_cmp_C[7]),
			.out(cmp_4_7)
);		
cordic_fixedpoint_get_phase_addr_priority_4_to_2	CMP_8_11
(
			.in0(iPhase_cmp_C[8]),
			.in1(iPhase_cmp_C[9]),
			.in2(iPhase_cmp_C[10]),
			.in3(iPhase_cmp_C[11]),
			.out(cmp_8_11)
);	
cordic_fixedpoint_get_phase_addr_priority_4_to_2	CMP_12_TO_16
(
			.in0(iPhase_cmp_C[12]),
			.in1(iPhase_cmp_C[13]),
			.in2(iPhase_cmp_C[14]),
			.in3(iPhase_cmp_C[15]),
			.out(cmp_12_to_16)
);

endmodule