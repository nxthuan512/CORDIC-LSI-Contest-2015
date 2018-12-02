module cordic_floatingpoint_mul_K (
	//	Global Signals
	input				iClk,
	input				iRst_n,
	
	//	Inputs
	input				last,	//	last bat len 2 ck roi ha xuong
	input		[24:0]	iX,		//	[sign-bit][24-bit mantisa]
	input		[24:0]	iY,		//	[sign-bit][24-bit mantisa]
	input		[23:0]	iK,		//	[24-bit mantisa]
	
	//	Outputs
	output	reg	[31:0]	oX,		//	[sign-bit][8-bit exp][23-bit man]
	output	reg	[31:0]	oY		//	[sign-bit][8-bit exp][23-bit man]
);

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
 
 //	Buffer data in
 reg	[24:0]	X;
 reg	[24:0]	Y;
 reg			sX;
 reg			sY;
 
 reg			last_shifted;
 reg			phase;
 
 //	Multiplier
 wire	[23:0]	A;
 wire	[23:0]	B;
 reg	[47:0]	Mul;
 
 //	Shifter
 wire	[4:0]	shift;
 wire	[7:0]	e;
 wire	[22:0]	m;
 
 //	Result out
 wire			X_en;
 wire			Y_en;
 
/*****************************************************************************
 *                              Buffer Data in                               *
 *****************************************************************************/
 
 always@(posedge iClk)
 begin
	X <= iX;
	Y <= iY;
 end
 
 always@(posedge iClk)
 begin
	sX <= X[24];
	sY <= Y[24];
 end
 
/*****************************************************************************
 *                              Enable Signal                                *
 *****************************************************************************/
 
 always@(posedge iClk)
 begin
	last_shifted <= last;
 end
 
 always@(posedge iClk)
 begin
	if(!iRst_n)
		phase <= 1'b0;
	else if(last)
		phase <= !phase;
	else
		phase <= phase;
 end

/*****************************************************************************
 *                                Multiplier                                 *
 *****************************************************************************/
 
 assign A = (phase) ? Y[23:0] : X[23:0];
 assign B = iK;
 always@(posedge iClk)
 begin
	Mul <= A*B;
 end

/*****************************************************************************
 *                                  Shifter                                  *
 *****************************************************************************/
 
 cordic_floatingpoint_mul_K_Shift_count Count_shift (
	.in		(Mul),
	.shift	(shift),
	.e		(e)
 );
 
 cordic_floatingpoint_mul_K_Left_shifter Shifter (
	.shift	(shift),
	.in		(Mul),
	.out	(m)
 );

/*****************************************************************************
 *                                  Output                                   *
 *****************************************************************************/
 
 assign X_en = last_shifted & phase;
 assign Y_en = last_shifted & !phase;
 
 always@(posedge iClk)
 begin
	if(X_en)
		oX <= {sX, e, m};
	else
		oX <= oX;
 end
 
 always@(posedge iClk)
 begin
	if(Y_en)
		oY <= {sY, e, m};
	else
		oY <= oY;
 end

endmodule
