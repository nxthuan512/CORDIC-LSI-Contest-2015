module cordic_floatingpoint_mul_ki (
	//	Global Signals
	input				iClk,
	input				iRst_n,
	
	//	Inputs
	input				start,
	input		[3:0]	i,
	
	//	Outputs
	output	reg	[23:0]	K
);

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

 wire			rom_en;
 reg			phase;
 reg			En;
 
 //	ROM
 wire	[23:0]	rom_q;
 
 //	RegK
 wire	[47:0]	Mul;
 wire	[23:0]	regK_wire;
 reg	[23:0]	regK;
 
/*****************************************************************************
 *                              Enable Signal                                *
 *****************************************************************************/
 
 assign rom_en = start;
 
 always@(posedge iClk)
 begin
	if(!iRst_n)
		phase <= 1'b0;
	else if(rom_en)
		phase <= !phase;
	else
		phase <= phase;
 end
 
 always@(posedge iClk)
 begin
	En <= rom_en & phase;
 end

/*****************************************************************************
 *                                   ROM                                     *
 *****************************************************************************/

 cordic_floatingpoint_mul_ki_rom ROM (
	.address	(i),
	.clock		(iClk),
	.rden		(rom_en),
	.q			(rom_q)
 );

/*****************************************************************************
 *                                Multiplier                                 *
 *****************************************************************************/
 
 assign Mul = rom_q*regK;
 
 assign regK_wire = (regK[23]) ? Mul[47:24] : rom_q;
 
 always@(posedge iClk)
 begin
	if(!iRst_n)
		regK <= 24'b0;
	else if(En)
		regK <= regK_wire;
	else
		regK <= regK;
 end
 
 always@(posedge iClk)
 begin
	if(En)
		K <= regK_wire;
	else
		K <= K;
 end

endmodule
