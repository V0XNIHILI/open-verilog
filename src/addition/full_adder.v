`ifndef __FULL_ADDER_V__
`define __FULL_ADDER_V__

module full_adder 
	(
		input a,
		input b,
		input carry_in,
		output sum,
		output carry_out
	);

	wire a_xor_b = a ^ b;
	wire carry_in_and_a_xor_b = carry_in & a_xor_b;
	wire a_and_b = a & b;

	assign sum = a_xor_b ^ carry_in;
	assign carry_out = carry_in_and_a_xor_b | a_and_b;

endmodule

`endif
