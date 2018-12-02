module cordic_floatingpoint_control_logic(
			input				iClk,
			input				iReset_n,
			//
			input		[3:0]	iRecovery_info,
			input		[1:0]	iLast_rotation,
			input				iFifo_empty,
			output reg			oFifo_rdreq,
			//
			output reg	[3:0]	oRecovery_info,		
			output reg			oNo_rotation,
			output reg			oStart,
			output reg			oLast,
			output reg			oData_valid	
);

// ===================================================================================
// Wire/reg
// ===================================================================================
reg				last_remainder;
reg				s1_last;
reg				no_rotation;
reg		[3:0]	recovery_info;

reg		[1:0]	start_case;
reg		[1:0]	last_case;

wire			start_case_eq_2;
wire			start_case_eq_1;
wire			last_case_eq_1;
wire			last_rotation_neq_0;

// ===================================================================================
// Combinational Circuits
// ===================================================================================
assign start_case_eq_2 = (start_case[1] &  ~start_case[0]);
assign start_case_eq_1 = (~start_case[1] &  start_case[0]);
assign last_case_eq_1 = (~last_case[1] &  last_case[0]);
assign last_rotation_neq_0 = |iLast_rotation;

// ===================================================================================
// Sequential Circuits
// ===================================================================================
/////// Process FIFO read request ///////
always @ (posedge iClk)
begin
	if (~iReset_n)	oFifo_rdreq <= 1'b0;
	else 			oFifo_rdreq <= (oFifo_rdreq | last_rotation_neq_0 & start_case_eq_1) ? 1'b0 : ~iFifo_empty;
end

/////// To check whether all 'start' are done ///////
always @ (posedge iClk)
begin
	if (~iReset_n)
		last_remainder <= 1'b0;
	else if (start_case_eq_2)
		last_remainder <= 1'b1;
	else if (last_case_eq_1)
		last_remainder <= 1'b0;
end

/////// Because 'start' and 'last' has delay, no_rotation should be stored until oData_valid ///////
always @ (posedge iClk)
begin
	if (~iReset_n)					no_rotation <= 1'b0;
	else if (start_case_eq_2)	no_rotation <= iLast_rotation[1];
end

always @ (posedge iClk)
begin
	if (~iReset_n)					oNo_rotation <= 1'b0;
	else if (s1_last & oLast)		oNo_rotation <= no_rotation;
end

/////// Because 'start' and 'last' has delay, recovery_info should be stored until oData_valid ///////
always @ (posedge iClk)
begin
	if (~iReset_n)					recovery_info <= 1'b0;
	else if (start_case_eq_2)	recovery_info <= iRecovery_info;
end

always @ (posedge iClk)
begin
	if (~iReset_n)					oRecovery_info <= 1'b0;
	else if (s1_last & oLast)		oRecovery_info <= recovery_info;
end

/////// FSM to control 'start' ///////
always @ (posedge iClk)
begin
	if (~iReset_n)	
	begin
		oStart 		<= 1'b0;
		start_case	<= 2'h0;
	end
	else
	begin
		case (start_case)
			2'h0: if (oFifo_rdreq)
			begin
				oStart 		<= 1'b1;
				start_case 	<= 2'h1;
			end
			//
			2'h1: if (last_rotation_neq_0)
				start_case <= 2'h2;
			//
			2'h2: begin
				oStart 		<= 1'b0;
				start_case 	<= 2'h0;
			end
			//
			default:;
		endcase
	end
end

/////// FSM to control 'last' ///////
always @ (posedge iClk)
begin
	if (~iReset_n)	
	begin
		oLast 		<= 1'b0;
		last_case	<= 2'h0;
	end
	else
	begin
		case (last_case)
			2'h0: if (last_remainder)
			begin
				oLast		<= 1'b1;
				last_case 	<= 2'h1;
			end
			//
			2'h1: last_case 	<= 2'h2;
			//			
			2'h2: begin
				oLast 		<= 1'b0;
				last_case  	<= 2'h0;
			end
			//
			default:;
		endcase
	end
end

/////// Control oData_valid ///////
always @ (posedge iClk)
begin
	if (~iReset_n)		{oData_valid, s1_last} <= 2'h0;
	else 				{oData_valid, s1_last} <= {s1_last, oLast};
end

endmodule
