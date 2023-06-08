module unsigned_pot_shift
    // Output bit width is the sum of input bit width and 1 sign bit and the maximum
    // possible, left shift, which is equal to (2^WEIGHT_BIT_WIDTH)/2-1 
    #(parameter WEIGHT_BIT_WIDTH = 4, parameter INPUT_BIT_WIDTH = 4, localparam OUTPUT_BIT_WIDTH = INPUT_BIT_WIDTH + (2**WEIGHT_BIT_WIDTH)/2)
    (
        input [INPUT_BIT_WIDTH-1:0] in,
        input [WEIGHT_BIT_WIDTH-1:0] weight,
        output signed [OUTPUT_BIT_WIDTH-1:0] out
    );

    wire weight_sign = weight[WEIGHT_BIT_WIDTH-1];
    wire [WEIGHT_BIT_WIDTH-2:0] weight_abs = weight[WEIGHT_BIT_WIDTH-2:0];

    // Can make this OUTPUT_BIT_WIDTH-2 as we know that the sign doesnt matter here yets
    wire signed [OUTPUT_BIT_WIDTH-2:0] out_abs = in <<< weight_abs;

    assign out = weight_sign == 1'b1 ? -out_abs : out_abs;

endmodule
