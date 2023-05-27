`include "parallel_argmax_signed_16_inputs.v"
`include "../tasks.v"

module parallel_argmax_signed_16_inputs_tb;
    localparam WIDTH = 5;

    reg signed [16-1:0][WIDTH-1:0] in;
    wire signed [WIDTH-1:0] max;
    wire [4-1:0] argmax;

    integer num_inputs = 16;

    parallel_argmax_signed_16_inputs #(.WIDTH(WIDTH)) parallel_argmax_signed_16_inputs_inst
    (
        .in(in),
        .max(max),
        .argmax(argmax)
    );

    initial begin
        for (integer i = 0; i < num_inputs; i = i + 1) begin
            in[i] = 15-i;
        end

        #1;

        tasks.print_if_failed(15, max);
        tasks.print_if_failed(0, argmax);
    end
endmodule
