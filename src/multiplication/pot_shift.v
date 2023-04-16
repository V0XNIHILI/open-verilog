module pot_shift
    #(parameter WEIGHT_BIT_WIDTH = 4, parameter INPUT_BIT_WIDTH = 4)
    (
        input signed [INPUT_BIT_WIDTH-1:0] in,
        input [WEIGHT_BIT_WIDTH-1:0] weight,
        output signed [OUTPUT_BIT_WIDTH-1:0] out
    );

    // Output bit width is the sum of input bit width and maximum possible
    // right shift, which is equal to 2^WEIGHT_BIT_WIDTH for each
    localparam OUTPUT_BIT_WIDTH = INPUT_BIT_WIDTH+2**WEIGHT_BIT_WIDTH;

    wire weight_sign = weight[WEIGHT_BIT_WIDTH-1];
    wire [WEIGHT_BIT_WIDTH-2:0] weight_abs = weight[WEIGHT_BIT_WIDTH-2:0];

    wire [OUTPUT_BIT_WIDTH-1:0] in_pushed_to_left = {in, {OUTPUT_BIT_WIDTH-INPUT_BIT_WIDTH{1'b0}}};

    wire signed [OUTPUT_BIT_WIDTH-1:0] out_abs = in_pushed_to_left >>> weight_abs;

    assign out = weight_sign == 1'b1 ? -out_abs : out_abs;

endmodule
