`timescale 1ns/1ps

module cordic_floatingpoint (
			// Global signals
			input			iClk,
			input			iRst_n,
			// Inputs
			input			iFifo_empty,
			input	[10:0]	iFifo_q,
			output			oFifo_rdreq,
			// Outputs
			output			oData_valid,
			output	[3:0]	oRecovery_info,
			output	[31:0]	oPre_cos,
			output	[31:0]	oPre_sin
);


// ========================================================================
// Wire/Reg
// ========================================================================
wire	[23:0]	X;
wire	[23:0]	Y;
wire	[23:0]	K;
wire	[31:0]	pre_cos;
wire	[31:0]	pre_sin;
wire			no_rotation;
wire			start;
wire			last;
wire	[3:0]	shift;
wire			signz;
wire	[1:0]	last_rotation;	// bit 1: no rotation, bit 0: last rotation
wire	[3:0]	recovery_info;

// ========================================================================
// Combinational Logic
// ========================================================================
assign {recovery_info, last_rotation, signz, shift} = iFifo_q;
assign oPre_cos = (no_rotation) ? 32'h3f800000 : pre_cos;
assign oPre_sin = (no_rotation) ? 32'h0 : pre_sin;

// ========================================================================
// PRE-CALCULATION
// ========================================================================
cordic_floatingpoint_control_logic FLP_CONTROL_LOGIC(
			.iClk				(iClk),
			.iReset_n			(iRst_n),
			//
			.iLast_rotation		(last_rotation),
			.iRecovery_info		(recovery_info),
			.iFifo_empty		(iFifo_empty),
			.oFifo_rdreq		(oFifo_rdreq),
			//
			.oNo_rotation		(no_rotation),
			.oRecovery_info		(oRecovery_info),
			.oStart				(start),
			.oLast				(last),
			.oData_valid		(oData_valid)
);

// ========================================================================
// PRE-CALCULATION
// ========================================================================
cordic_floatingpoint_addsub FLP_ADDSUB (
			.iClk		(iClk),
			.iRst_n		(iRst_n & start),
			.start		(start),
			.shift		(shift),
			.signZ		(signz),
			.oX			(X),
			.oY			(Y)
);

cordic_floatingpoint_mul_ki FLP_MULT_KI(
			//	Global Signals
			.iClk		(iClk),
			.iRst_n		(iRst_n & start),	
			//	Inputs
			.start		(start),
			.i			(shift),	
			//	Outputs
			.K			(K)
);

// ========================================================================
// POST-CALCULATION
// ========================================================================
cordic_floatingpoint_mul_K FLP_MULT_K(
			//	Global Signals
			.iClk		(iClk),
			.iRst_n		(iRst_n),
			
			//	Inputs
			.last		(last),			//	last bat len 2 ck roi ha xuong
			.iX			({1'b0, X}),	//	[sign-bit][24-bit mantisa]
			.iY			({1'b0, Y}),	//	[sign-bit][24-bit mantisa]
			.iK			(K),			//	[24-bit mantisa]
			
			//	Outputs
			.oX			(pre_cos),		//	[sign-bit][8-bit exp][23-bit man]
			.oY			(pre_sin)		//	[sign-bit][8-bit exp][23-bit man]
);


endmodule
