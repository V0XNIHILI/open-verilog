module full_subtractor 
	(
		input a,
		input b,
        input borrow_in,
		output difference,
		output borrow
	);

	assign difference = a ^ b ^ borrow_in;
	assign borrow = (~a & b) | (~a & borrow_in) | b & borrow_in;
	
endmodule