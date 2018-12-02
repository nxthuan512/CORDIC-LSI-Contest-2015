module cordic_fixedpoint_anglenormalize_cmp
(		
		input  	[23:0] 	iPhase_input,		
		output 	[7:0]	oAngle_range_cmp,
		output	[23:0]	oRom_180,
		output	[23:0]	oRom_90
);
     
// Store the information used to reduce the range of angle 
reg [23:0] rom [0:7];    // # of nibbles
initial 
begin 
	$readmemh("cordic_fixedpoint_anglenormalize_cmp_rom_value.txt", rom);
end

assign oRom_180 = rom[5];
assign oRom_90 = rom[7];

assign oAngle_range_cmp[0] = (iPhase_input 	<= rom[0]) 	&& 	(iPhase_input 	>=	24'h0);					//[0,45]
assign oAngle_range_cmp[1] = (iPhase_input[23]) 			&& 	(iPhase_input 	>= 	rom[1]);				//[-45,0)
assign oAngle_range_cmp[2] = (iPhase_input 	<	rom[1])	&&	(iPhase_input 	>= 	rom[2]);				//[-90,-45)
assign oAngle_range_cmp[3] = (iPhase_input	<	rom[2])	&& 	(iPhase_input 	>= 	rom[3]);				//[-135,-90)
assign oAngle_range_cmp[4] = (iPhase_input	<	rom[3])	&&	(iPhase_input	>= 	rom[4]);				//[-180,-135)
assign oAngle_range_cmp[5] = (iPhase_input 	<	rom[5])	&&	(iPhase_input	>=	rom[6]);				//[180,135)
assign oAngle_range_cmp[6] = (iPhase_input	< 	rom[6])	&&	(iPhase_input	>=	rom[7]);				//[135,90)
assign oAngle_range_cmp[7] = (iPhase_input 	<= 	rom[7])	&&	(iPhase_input	>	rom[0]);				//[90,45)
 
	
endmodule
