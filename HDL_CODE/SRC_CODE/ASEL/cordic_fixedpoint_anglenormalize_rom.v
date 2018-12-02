module cordic_fixedpoint_anglenormalize_rom
(
	iClk,
	iAddr_fixedpoint_normalize, 
	iAddr_fixedpoint_normalize_valid,
	oSign_sine_cos_normalize
);

// ================================================================
// Input, output
// ================================================================
input						iClk;
input 	[2:0] 		iAddr_fixedpoint_normalize;  
input				iAddr_fixedpoint_normalize_valid;      
output reg	[3:0] 		oSign_sine_cos_normalize;   

// ================================================================
// Memory
// ================================================================
// Store the information used to recover the sine/cosine values 
reg [3:0] sine_cosine_normalize_rom[0:7];    		// # of nibbles

initial 
begin
	$readmemb("cordic_fixedpoint_anglenormalize_rom_value.txt", sine_cosine_normalize_rom);
end 

always @ (posedge iClk)
begin
	//if (iAddr_fixedpoint_normalize_valid)
		oSign_sine_cos_normalize <= sine_cosine_normalize_rom[iAddr_fixedpoint_normalize];
end

endmodule
