module conditional_sum_adder 
	(
		input a,
		input b,
        input carry_in,
		output sum,
		output carry_out
	);

    wire carry_out_carry_in_0;
    wire carry_out_carry_in_1;

    wire sum_carry_in_0;
    wire sum_carry_in_1;

    wire sum_carry [2:0];

    assign carry_out_carry_in_0 = a & b;
    assign carry_out_carry_in_1 = a | b;

    assign sum_carry_in_0 = a ^ b;
    assign sum_carry_in_1 = ~sum_carry_in_0;

    // TODO: write this nicely into using one if-statement
    assign sum = (carry_in == 1'b1) ? sum_carry_in_1 : sum_carry_in_0;
    assign carry_out = (carry_in == 1'b1) ? carry_out_carry_in_1 : carry_out_carry_in_0;

endmodule