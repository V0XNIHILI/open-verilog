`include "parallel_argmax_signed_16_inputs.v"

module serial_parallel_argmax_signed_16_inputs
    #(parameter WIDTH = 8, parameter INDEX_WIDTH = 8)
    (
        input clk,
        input rst,

        input enable,

        input signed [16-1:0][WIDTH-1:0] in,

        output reg signed [WIDTH-1:0] max,
        output reg [INDEX_WIDTH-1:0] argmax
    );

    wire signed [WIDTH-1:0] parallel_max;
    wire [4-1:0] parallel_argmax;

    localparam COUNTER_WIDTH = $clog2(2**INDEX_WIDTH/16);

    reg [COUNTER_WIDTH-1:0] input_counter;

    parallel_argmax_signed_16_inputs #(.WIDTH(WIDTH)) parallel_argmax_signed_16_inputs_inst
    (
        .in(in),

        .max(parallel_max),
        .argmax(parallel_argmax)
    );

    always @(posedge clk) begin
        if (rst) begin
            max <= -2**(WIDTH-1);
            input_counter <= 0;
        end else if (enable) begin
            if (parallel_max > max) begin
                max <= parallel_max;
                // << 4 is the same as multiplying by 16
                argmax <= parallel_argmax + (input_counter << 4);
            end

            input_counter <= input_counter + 1;
        end
    end

endmodule