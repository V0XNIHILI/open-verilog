module half_adder 
	(
		input a,
		input b,
		output sum,
		output carry_out
	);

	assign sum   = a ^ b;
	assign carry_out = a & b;
	
endmodule