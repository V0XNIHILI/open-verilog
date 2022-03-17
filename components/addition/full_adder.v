module full_adder 
	(
		input a,
		input b,
		input carry_in,
		output sum,
		output carry_out
	);

	wire a_xor_b;
		
	assign a_xor_b = a ^ b;

	assign sum = a_xor_b ^ carry_in;
	assign carry_out = (a_xor_b & carry_in) | (a & b);
	
endmodule