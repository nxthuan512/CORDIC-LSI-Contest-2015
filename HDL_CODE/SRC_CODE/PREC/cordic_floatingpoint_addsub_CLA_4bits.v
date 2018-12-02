module cordic_floatingpoint_addsub_CLA_4bits (
	//	Inputs
	input	[3:0]	iA,
	input	[3:0]	iB,
	input			iC,
	
	//	Outputs
	output	[3:0]	oS,
	output			oC
);

wire	C_n;
wire	P1, P2, P3, P4;
wire	G1, G2, G3, G4;

assign C_n = ~iC;

assign P1 = ~(iA[0] | iB[0]);
assign P2 = ~(iA[1] | iB[1]);
assign P3 = ~(iA[2] | iB[2]);
assign P4 = ~(iA[3] | iB[3]);

assign G1 = ~(iA[0] & iB[0]);
assign G2 = ~(iA[1] & iB[1]);
assign G3 = ~(iA[2] & iB[2]);
assign G4 = ~(iA[3] & iB[3]);

assign oS[0] = iC ^ (~P1 & G1);
assign oS[1] = ~( (C_n & G1) | P1 ) ^ (~P2 & G2);
assign oS[2] = ~( (C_n & G1 & G2) | (G2 & P1) | P2 ) ^ (~P3 & G3);
assign oS[3] = ~( (C_n & G1 & G2 & G3) | (G2 & G3 & P1) | (G3 & P2) | P3 ) ^ (~P4 & G4);
assign oC = ~( (C_n & G1 & G2 & G3 & G4) | (G2 & G3 & G4 & P1) | (G3 & G4 & P2) | (G4 & P3) | P4 );

endmodule
