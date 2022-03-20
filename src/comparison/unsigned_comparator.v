module unsigned_comparator
    #(parameter WIDTH = 8)
	(
        input [WIDTH-1:0] a,
        input [WIDTH-1:0] b,
        output a_smaller_than_b,
		output equal,
        output a_larger_than_b
	);

    wire [WIDTH-1:0] x;
    wire [WIDTH-1:0] not_a;
    wire [WIDTH-1:0] not_b;
    wire [WIDTH-1:0] a_smaller_bits;
    wire [WIDTH-1:0] a_larger_bits;

    assign not_a = ~a;
    assign not_b = ~b;

    genvar i;
    generate 
        for (i = 0; i < WIDTH; i = i + 1) 
            begin
                assign x[i] = (a[i] & b[i]) | (not_a[i] & not_b[i]);

                wire not_a_and_b = not_a[i] & b[i];
                wire a_and_not_b = a[i] & not_b[i];

                if (i > 0) begin
                    wire and_x = &(x[WIDTH-1:WIDTH-i]);
                    assign a_smaller_bits[i] = not_a_and_b & and_x;
                    assign a_larger_bits[i] = a_and_not_b & and_x;
                end else begin
                    assign a_smaller_bits[i] = not_a_and_b;
                    assign a_larger_bits[i] = a_and_not_b;
                end
            end
    endgenerate

    assign a_smaller_than_b = &a_smaller_bits;
    assign equal = &x;
    assign a_larger_than_b = &a_larger_bits;
	
endmodule