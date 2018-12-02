module cordic_fixedpoint_check_last_rotation
(		
		input  	[20:0] 	iPhase_abs,
		output	[1:0]	oPhase_check_last_rotation
		
);
//	================================================================================
//	Parameters
//	=================================================================================

//	================================================================================
//	reg/wire
//	=================================================================================
wire	[15:0]	phase_add_sub_threshold_cmp;
wire			phase_threshold_cmp;

//	=================================================================================
// Store the theta add threshold
//	==================================================================================
reg [20:0] add_threshold_rom [0:15];    // # of nibbles
initial 
begin 
	$readmemb("cordic_fixedpoint_check_last_rotation_add_threshold_rom.txt", add_threshold_rom);
end
//	==================================================================================
// Store the theta subtract threshold
//	==================================================================================
reg [20:0] sub_threshold_rom [0:15];    // # of nibbles
initial 
begin 
	$readmemb("cordic_fixedpoint_check_last_rotation_sub_threshold_rom.txt", sub_threshold_rom);
end


// ============================================================================
// Combinational Circuits
// ============================================================================
assign phase_add_sub_threshold_cmp[0] = (iPhase_abs 	>= sub_threshold_rom[0]);													//compare with 45 - threshold				

assign phase_add_sub_threshold_cmp[1] = (iPhase_abs	>=	sub_threshold_rom[1]) 	&& 	(iPhase_abs 	<= 	add_threshold_rom[1]);//26-thresh <= abs(z)<=26 +thresh			
assign phase_add_sub_threshold_cmp[2] = (iPhase_abs	>=	sub_threshold_rom[2]) 	&& 	(iPhase_abs 	<= 	add_threshold_rom[2]);				
assign phase_add_sub_threshold_cmp[3] = (iPhase_abs	>=	sub_threshold_rom[3]) 	&& 	(iPhase_abs 	<= 	add_threshold_rom[3]);			
assign phase_add_sub_threshold_cmp[4] = (iPhase_abs	>=	sub_threshold_rom[4]) 	&& 	(iPhase_abs 	<= 	add_threshold_rom[4]);				
assign phase_add_sub_threshold_cmp[5] = (iPhase_abs	>=	sub_threshold_rom[5]) 	&& 	(iPhase_abs 	<= 	add_threshold_rom[5]);
assign phase_add_sub_threshold_cmp[6] = (iPhase_abs	>=	sub_threshold_rom[6]) 	&& 	(iPhase_abs 	<= 	add_threshold_rom[6]);
assign phase_add_sub_threshold_cmp[7] = (iPhase_abs	>=	sub_threshold_rom[7]) 	&& 	(iPhase_abs 	<= 	add_threshold_rom[7]);

assign phase_add_sub_threshold_cmp[8] = (iPhase_abs	>=	sub_threshold_rom[8]) 	&& 	(iPhase_abs 	<= 	add_threshold_rom[8]);				
assign phase_add_sub_threshold_cmp[9] = (iPhase_abs	>=	sub_threshold_rom[9]) 	&& 	(iPhase_abs 	<= 	add_threshold_rom[9]);			
assign phase_add_sub_threshold_cmp[10] = (iPhase_abs	>=	sub_threshold_rom[10]) 	&& 	(iPhase_abs 	<= 	add_threshold_rom[10]);				
assign phase_add_sub_threshold_cmp[11] = (iPhase_abs	>=	sub_threshold_rom[11]) 	&& 	(iPhase_abs 	<= 	add_threshold_rom[11]);
assign phase_add_sub_threshold_cmp[12] = (iPhase_abs	>=	sub_threshold_rom[12]) 	&& 	(iPhase_abs 	<= 	add_threshold_rom[12]);
assign phase_add_sub_threshold_cmp[13] = (iPhase_abs	>=	sub_threshold_rom[13]) 	&& 	(iPhase_abs 	<= 	add_threshold_rom[13]);
assign phase_add_sub_threshold_cmp[14] = (iPhase_abs	>=	sub_threshold_rom[14]) 	&& 	(iPhase_abs 	<= 	add_threshold_rom[14]);
assign phase_add_sub_threshold_cmp[15] = (iPhase_abs	>	sub_threshold_rom[15]) 	&& 	(iPhase_abs 	<= 	add_threshold_rom[15]);	

assign phase_threshold_cmp			   = 	iPhase_abs	<= add_threshold_rom[0];

assign	oPhase_check_last_rotation[0]			= 	(|phase_add_sub_threshold_cmp[3:0])  | 	(|phase_add_sub_threshold_cmp[7:4]) |	
													(|phase_add_sub_threshold_cmp[11:0]) |	(|phase_add_sub_threshold_cmp[15:0]);
assign	oPhase_check_last_rotation[1]			= 	phase_threshold_cmp;

endmodule