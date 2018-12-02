module cordic_fixedpoint_input_phase_rom
(
	iClk,
	iAddr_phase, 
	oPhase_initital
);

// ================================================================
// Input, output
// ================================================================
input					iClk;
input 		[4:0] 		iAddr_phase;        
output reg	[23:0] 		oPhase_initital;   

// ================================================================
// Memory
// ================================================================
// Store initial input angle in ROM
reg [23:0] phase_initial_rom[0:31];    		// # of nibbles

initial 
begin
	$readmemh("file_input_angle.txt", phase_initial_rom);
end 

always @ (posedge iClk)
	oPhase_initital <= phase_initial_rom[iAddr_phase];

endmodule
