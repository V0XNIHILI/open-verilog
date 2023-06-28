`include "parallel_argmax_signed_16_inputs.v"
`include "serial_parallel_argmax.v"

module serial_parallel_argmax_signed_16_inputs
    #(parameter WIDTH = 8, parameter ARGMAX_WIDTH = 8)
    (
        input clk,
        input rst,

        input enable,

        input signed [WIDTH-1:0] in [16-1:0],

        output signed [WIDTH-1:0] max,
        output [ARGMAX_WIDTH-1:0] argmax
    );

    wire signed [WIDTH-1:0] parallel_max;
    wire [4-1:0] parallel_argmax;

    parallel_argmax_signed_16_inputs #(.WIDTH(WIDTH)) parallel_argmax_signed_16_inputs_inst
    (
        .in(in),

        .max(parallel_max),
        .argmax(parallel_argmax)
    );

    serial_parallel_argmax #(
        .WIDTH(WIDTH),
        .ARGMAX_WIDTH(ARGMAX_WIDTH),
        .IN_ARGMAX_WIDTH(4),
        .MAX_IN_ARGMAX(16)
    ) serial_parallel_argmax_inst (
        .clk(clk),
        .rst(rst),

        .enable(enable),

        .in(parallel_max),
        .in_argmax(parallel_argmax),

        .argmax(argmax),
        .max(max)
    );

endmodule