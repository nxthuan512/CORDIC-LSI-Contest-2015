module cordic_fixedpoint_updatephase_rom_theta
(
	iAddr_theta, 
	oTheta_value
);

// ================================================================
// Input, output
// ================================================================
input 	[3:0] 		iAddr_theta;        
output 	[20:0] 		oTheta_value;   

// ================================================================
// Memory store theta value
// ================================================================
reg [20:0] rom_theta[0:15];    		// # of nibbles

assign oTheta_value = rom_theta[iAddr_theta];

initial 
begin
	$readmemb("cordic_fixedpoint_updatephase_rom_theta.txt", rom_theta);
end 

endmodule