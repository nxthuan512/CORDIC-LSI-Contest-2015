module cordic_floatingpoint_mul_ki_rom (
	input [3:0] 		address,
	input				rden,
	input 				clock, 
	output reg [23:0] 	q
);

	// Declare the ROM variable
	reg [23:0] rom[15:0];

	initial
	begin
		$readmemh("cordic_floatingpoint_mul_ki_rom.txt", rom);
	end

	always @ (posedge clock)
	begin
		if (rden)
			q <= rom[address];
		else
			q <= q;
	end

endmodule
