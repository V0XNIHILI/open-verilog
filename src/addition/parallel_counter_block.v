`include "three_to_two_compressor.v"

module parallel_counter_block
    #(parameter SIZE = 10, parameter NUMBER_OF_COUNTERS = SIZE / 3, parameter RIGHT_COLUMN_SIZE = NUMBER_OF_COUNTERS + (SIZE % 3))
	(
		input [SIZE - 1:0] a,
		output [RIGHT_COLUMN_SIZE - 1:0] right_column,
        output [NUMBER_OF_COUNTERS - 1:0] left_column
	);

    genvar i;
    generate 
        for (i = 0; i < NUMBER_OF_COUNTERS; i = i + 1)
            begin
                three_to_two_compressor three_to_two_compressor_inst
                ( 
                    .a(a[3 * i]),
                    .b(a[3 * i + 1]),
                    .carry_in(a[3 * i + 2]),
                    .sum(right_column[i]),
                    .carry_out(left_column[i]),
                );
            end
    endgenerate

    genvar j;
    generate 
        for (j = NUMBER_OF_COUNTERS; j < RIGHT_COLUMN_SIZE; j = j + 1)
            begin
                assign right_column[j] = a[3 * NUMBER_OF_COUNTERS + j - NUMBER_OF_COUNTERS];
            end
    endgenerate
	
endmodule