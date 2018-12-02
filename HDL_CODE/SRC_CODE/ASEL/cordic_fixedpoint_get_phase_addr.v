module cordic_fixedpoint_get_phase_addr
(
	input 	[20:0]	iPhase_abs,
	output	[3:0]	oPhase_addr
);

//	=================================================================
//	Reg/wire
//	=================================================================
wire	[15:0]	phase_cmp_C;

//	=================================================================
//	Call modules
//	=================================================================
cordic_fixedpoint_get_phase_addr_rom_C_cmp			CORDIC_FIXEDPOINT_GET_PHASE_ADDR_ROM_C_CMP
(		
		.iPhase_abs			(iPhase_abs),		
		.oPhase_cmp_C		(phase_cmp_C)
);
cordic_fixedpoint_get_phase_addr_priority_16to4		CORDIC_FIXEDPOINT_GET_PHASE_ADDR_PRIORITY_16TO4
(			
		.iPhase_cmp_C		(phase_cmp_C),					//iPhase_cmp_C,
		.oTheta_addr		(oPhase_addr)					//oPhase_addr,
);

endmodule