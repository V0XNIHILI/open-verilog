`include "full_adder.v"

module three_to_two_compressor 
	(
		input a,
		input b,
		input carry_in,
		output sum,
		output carry_out
	);

	full_adder full_adder_inst
	( 
		.a(a),
		.b(b),
		.carry_in(carry_in),
		.sum(sum),
		.carry_out(carry_out)
	);

endmodule
