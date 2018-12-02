module cordic_floatingpoint_addsub (
	//	Global signals
	input				iClk,
	input				iRst_n,
	
	//	Input i signal
	input				start,
	input		[3:0]	shift,
	input				signZ,
	
	//	Output signals
	output	reg	[24:0]	oX,	//	[sign-bit][24-bit mantisa]
	output	reg	[24:0]	oY	//	[sign-bit][24-bit mantisa]
);

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
 
 wire	[23:0]	mX;
 reg	[23:0]	mY;
 wire			sX;
 reg			sY;
 
 reg			phase;
 wire			EnX, EnY;
 
 reg	[24:0]	regX_result;
 reg	[24:0]	regY_result;
 
 //	Shifter
 wire	[23:0]	Shifter_in;
 wire	[23:0]	Shifter_out;
 
 //	data selection
 wire	[23:0]	preA;
 wire	[23:0]	preB;
 
 wire	[23:0]	A;
 wire	[23:0]	B;
 
 //	sign decision
 wire			sA;
 wire			sB;
 wire			temp;
 
 wire			sel_data;
 wire			addsub;
 wire			control_2s;
 wire			sign;
 
 //	CLA Adder
 wire	[23:0]	S;
 wire			C;
	// 2's complement
	wire	[23:0]	ret;
	
/*****************************************************************************
 *                              Output Signals                               *
 *****************************************************************************/
 
 always@(posedge iClk)
 begin
	if(EnX)
		oX <= {sign, ret};
	else
		oX <= oX;
 end
 
 always@(posedge iClk)
 begin
	if(EnY)
		oY <= {sign, ret};
	else
		oY <= oY;
 end

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/
 
 assign {sX, mX} = regX_result;
 
 assign EnX = start & phase;
 assign EnY = start & !phase;

/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/
 
 always@(posedge iClk)
 begin
	if(!iRst_n)
		phase <= 1'b0;
	else if(start)
		phase <= !phase;
	else
		phase <= phase;
 end
 
 always@(posedge iClk)
 begin
	if(!iRst_n)
		regX_result <= {1'b0, 1'b1, 23'b0};
	else if(EnX)
		regX_result <= {sign, ret};
	else
		regX_result <= regX_result;
 end
 
 always@(posedge iClk)
 begin
	if(!iRst_n)
		regY_result <= 25'b0;
	else if(EnY)
		regY_result <= {sign, ret};
	else
		regY_result <= regY_result;
 end
 
 always@(posedge iClk)
 begin
	if(!iRst_n)
		{sY, mY} <= 25'b0;
	else
		{sY, mY} <= regY_result;
 end

/*****************************************************************************
 *                                  Shifter                                  *
 *****************************************************************************/
 
 assign Shifter_in = (phase) ? mY : mX;
 
 cordic_floatingpoint_addsub_Right_shifter Shifter (
	.shift	(shift),
	.in		(Shifter_in),
	.out	(Shifter_out)
 );
 
/*****************************************************************************
 *                              Data Selection                               *
 *****************************************************************************/
 
 assign preA = (phase) ? mX : mY;
 assign preB = Shifter_out;
 
 assign A = (sel_data) ? preB : preA;
 assign B = (sel_data) ? preA : preB;
 
/*****************************************************************************
 *                               Sign Decision                               *
 *****************************************************************************/
 
 assign sA = (phase) ? sX : sY;
 assign sB = (phase) ? sY : sX;
 
 assign temp = phase ^ signZ ^ sB;
 
 assign sel_data = sA;
 
 assign addsub = sA ^ temp;
 
 assign control_2s = addsub & C;
 
 assign sign = control_2s | (!addsub & temp);
 
/*****************************************************************************
 *                         CLA Adder & 2's complement                        *
 *****************************************************************************/
 
 cordic_floatingpoint_addsub_CLA_adder Adder (
	.iA		(A),
	.iB		(B),
	.addsub	(addsub),
	.oS		(S),
	.oC		(C)
 );
 
 cordic_floatingpoint_addsub_Complement_2s Complement (
	.in			(S),
	.control	(control_2s),
	.out		(ret)
 );
 
endmodule
