module cordic_fixedpoint_get_phase_addr_priority_4_to_2(
		input in0,
		input in1,
		input in2,
		input in3,
		output [1:0] out
		);
assign out[0] = (~in0 & in1 & in2 & in3) | (~in0 & ~in1 & ~in2 & in3);
assign out[1] = ~in0 & ~in1 & in3;
endmodule
