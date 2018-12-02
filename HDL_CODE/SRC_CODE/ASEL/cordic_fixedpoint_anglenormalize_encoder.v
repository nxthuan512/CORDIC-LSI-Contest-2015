module cordic_fixedpoint_anglenormalize_encoder
(	input	[7:0] 	iAngle_range_cmp,
	output	[2:0]	oAngle_position_addr
);

assign 	oAngle_position_addr[0]	= iAngle_range_cmp[1] | iAngle_range_cmp[3] | iAngle_range_cmp[5]	| iAngle_range_cmp[7];

assign 	oAngle_position_addr[1]	= iAngle_range_cmp[2] | iAngle_range_cmp[3] | iAngle_range_cmp[6]	| iAngle_range_cmp[7];

assign 	oAngle_position_addr[2]	= iAngle_range_cmp[4] | iAngle_range_cmp[5] | iAngle_range_cmp[6]	| iAngle_range_cmp[7];

endmodule