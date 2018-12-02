// Compare abs(z) with C
module cordic_fixedpoint_get_phase_addr_rom_C_cmp
(		
		input  	[20:0] 	iPhase_abs,		
		output 	[15:0]	oPhase_cmp_C
);
//	=======================================================
// Store value of C 
//	=======================================================     
reg [20:0] rom_C [0:15];    // # of nibbles

	initial 
	begin 
		$readmemb("cordic_fixedpoint_get_phase_addr_rom_C.txt", rom_C);
	end 
//	=======================================================
// Combinational Circuits
//	=======================================================     	
assign oPhase_cmp_C[0] = (iPhase_abs > rom_C[0]);
assign oPhase_cmp_C[1] = (iPhase_abs > rom_C[1]);
assign oPhase_cmp_C[2] = (iPhase_abs > rom_C[2]);
assign oPhase_cmp_C[3] = (iPhase_abs > rom_C[3]);
assign oPhase_cmp_C[4] = (iPhase_abs > rom_C[4]);
assign oPhase_cmp_C[5] = (iPhase_abs > rom_C[5]);
assign oPhase_cmp_C[6] = (iPhase_abs > rom_C[6]);
assign oPhase_cmp_C[7] = (iPhase_abs > rom_C[7]);
assign oPhase_cmp_C[8] = (iPhase_abs > rom_C[8]);
assign oPhase_cmp_C[9] = (iPhase_abs > rom_C[9]);
assign oPhase_cmp_C[10] = (iPhase_abs > rom_C[10]);
assign oPhase_cmp_C[11] = (iPhase_abs > rom_C[11]);
assign oPhase_cmp_C[12] = (iPhase_abs > rom_C[12]);
assign oPhase_cmp_C[13] = (iPhase_abs > rom_C[13]);
assign oPhase_cmp_C[14] = (iPhase_abs > rom_C[14]);
assign oPhase_cmp_C[15] = (iPhase_abs > rom_C[15]);

	
endmodule
