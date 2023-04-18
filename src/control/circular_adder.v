module circular_adder
    #(parameter WIDTH = 8)
    (
        input unsigned [WIDTH-1:0] a,
        input unsigned [WIDTH-1:0] b,
        input unsigned [WIDTH-1:0] max,
        output unsigned [WIDTH-1:0] sum
    );

    wire [WIDTH:0] temp_sum = a + b;

    assign sum = temp_sum > max ? 0 : temp_sum[WIDTH-1:0];

endmodule
