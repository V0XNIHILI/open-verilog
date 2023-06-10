`include "serial_parallel_argmax.v"

module serial_argmax
    /**
     * This module finds the index of the maximum value in a stream of values.
     * It is a serial implementation of the argmax function.
     *
     * Inputs:
     *  - clk: Clock
     *  - rst: Reset
     *  - enable: Enable
     *  - in: Input value
     *
     * Outputs:
     *  - argmax: Index of the maximum value
     */
    #(parameter WIDTH = 8, parameter ARGMAX_WIDTH = 3)
    (
        input clk,
        input rst,
        input enable,
        input signed [WIDTH-1:0] in,
        output reg [ARGMAX_WIDTH-1:0] argmax
    );

    serial_parallel_argmax #(
        .WIDTH(WIDTH),
        .ARGMAX_WIDTH(ARGMAX_WIDTH),
        .IN_ARGMAX_WIDTH(1),
        .MAX_IN_ARGMAX(1)
    ) serial_parallel_argmax_inst (
        .clk(clk),
        .rst(rst),

        .enable(enable),

        .in(in),
        .in_argmax(1'b0),

        .argmax(argmax)
    );

endmodule
