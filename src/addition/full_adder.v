`ifndef __FULL_ADDER_V__
`define __FULL_ADDER_V__

`include "full_adder_generation_propagation.v"

module full_adder 
	(
		input a,
		input b,
		input carry_in,
		output sum,
		output carry_out
	);

	full_adder_generation_propagation full_adder_generation_propagation_inst
	( 
		.a(a),
		.b(b),
		.carry_in(carry_in),
		.p(),
		.g(),
		.sum(sum),
		.carry_out(carry_out)
	);

endmodule
`endif
