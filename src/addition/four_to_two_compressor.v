module four_to_two_compressor 
	(
		input a,
		input b,
        input c,
        input d,
        input carry_in,
		output sum,
        output carry,
		output carry_out
	);

    wire a_xor_b = a ^ b;
    wire c_xor_d = c ^ d;
    wire a_xor_b_xor_c_xor_d = a_xor_b ^ c_xor_d;

	assign sum = a_xor_b_xor_c_xor_d ^ carry_in;
	assign carry = (a_xor_b_xor_c_xor_d == 1'b1) ? carry_in : c;
    assign carry_out = (a_xor_b == 1'b1) ? a : d;
	
endmodule