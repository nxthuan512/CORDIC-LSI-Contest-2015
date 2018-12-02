//test cordic fixedpoint part read data from ROM
`timescale	1ns/1ps
module cordic_system_tb();

// ========================================================================
// Wire/Reg
// ========================================================================
parameter N = 17;

reg				iClk;
reg				iReset_n;
reg				iData_valid;

wire			oReady;
wire			oData_valid;	
wire	[23:0]	iData;
wire	[31:0]	oData_cos;
wire	[31:0]	oData_sin;

wire	[4:0]	addr;
reg		[4:0]	addr_tmp;
reg		[4:0]	s1_addr_tmp;
reg		[1:0]	counter;

integer f1, f2,f3;
integer temp, i;


// ========================================================================
// Module
// ========================================================================
cordic_fixedpoint_input_phase_rom	CORDIC_FIXEDPOINT_INPUT_PHASE_ROM
(
		.iClk				(iClk),
		.iAddr_phase		(addr), 
		.oPhase_initital	(iData)
);

cordic_system			CORDIC_SYSTEM
(
		.iClk				(iClk),
		.iReset_n			(iReset_n),
		//
		.iData_valid		(iData_valid),
		.iData				(iData),
		//
		.oReady				(oReady),
		.oData_valid		(oData_valid),
		.oData_cos			(oData_cos),
		.oData_sin			(oData_sin)
);


// ========================================================================
// Simulation
// ========================================================================
initial
begin
	$display ("\n Print result to txt file\n");
	f2 	= 	$fopen("FILE_OUTPUT_RESULT_COS_TEST.txt", "w");
	f3	=	$fopen("FILE_OUTPUT_RESULT_SIN_TEST.txt", "w");
end

// ========================================================================
initial
begin
	iClk			=	1'b0;
end
always	#10	iClk	=	~iClk;

// ========================================================================
initial
begin
	iReset_n		<= 	1'b0;
#90	iReset_n		<= 	1'b1;
end

// ========================================================================
always	@(posedge	iClk)
begin
	if(~iReset_n)	iData_valid		<= 0;
	
	else
	begin
		if(oReady)	iData_valid 	<= 	(addr_tmp < N);
		else		iData_valid		<=	1'b0;
	end
end

///////
always	@(posedge	iClk)
begin
	if 	(~iReset_n)		addr_tmp		<= 5'h0;
	
	else if (addr_tmp < N)	
	begin
		if (oReady)		addr_tmp		<=addr_tmp	+ 1'b1;	
		else			addr_tmp		<=addr_tmp;
	end
end

///////
always	@(posedge	iClk)
begin
	if 	(~iReset_n)						s1_addr_tmp		<= 5'h0;
	else if (oReady)	s1_addr_tmp		<= addr_tmp;		
end

// ========================================================================
assign addr = (oReady) ? addr_tmp : s1_addr_tmp;

// ========================================================================
always	@(posedge	iClk)
begin
	if (~iReset_n)		counter		<=	2'b0;
	else 
	begin
		if	(oData_valid)	counter		<=	counter	+	1'b1;		
		else				counter		<=	2'b0;
	end
end
////////////
always	@(posedge	iClk)
begin
	if	(counter == 2'b1)  $fwrite(f2,"%x \n",oData_cos);		
end
////////////
always	@(posedge	iClk)
begin
	if	(counter == 2'b10)  $fwrite(f3,"%x \n",oData_sin);		
end

endmodule