`include "parallel_argmax_signed_16_inputs.v"
`include "../tasks.v"

module parallel_argmax_signed_16_inputs_tb;
    localparam WIDTH = 5;
    localparam NUM_INPUTS = 16;

    reg signed [WIDTH-1:0] in [16-1:0];
    wire signed [WIDTH-1:0] max;
    wire [4-1:0] argmax;

    parallel_argmax_signed_16_inputs #(.WIDTH(WIDTH)) parallel_argmax_signed_16_inputs_inst
    (
        .in(in),
        .max(max),
        .argmax(argmax)
    );

    initial begin
        for (integer i = 0; i < NUM_INPUTS; i = i + 1) begin
            in[i] = 15-i;
        end

        #1;

        tasks.print_if_failed(15, max);
        tasks.print_if_failed(0, argmax);

        in[0] = 0; in[1] = 0; in[2] = 0; in[3] = 0; in[4] = 0; in[5] = 0; in[6] = 0; in[7] = 0; in[8] = 0; in[9] = 0; in[10] = 0; in[11] = 0; in[12] = 0; in[13] = 0; in[14] = 0; in[15] = 0;

        #1;

        tasks.print_if_failed(0, max);
        tasks.print_if_failed(15, argmax);

        in[0] = -12; in[1] = 2; in[2] = 11; in[3] = 9; in[4] = 8; in[5] = -14; in[6] = -8; in[7] = -13; in[8] = -1; in[9] = 8; in[10] = -2; in[11] = -1; in[12] = 4; in[13] = -4; in[14] = 9; in[15] = -10;

        #1;

        tasks.print_if_failed(11, max);
        tasks.print_if_failed(2, argmax);

        in[0] = -2; in[1] = 9; in[2] = 6; in[3] = 6; in[4] = 13; in[5] = 1; in[6] = -16; in[7] = 8; in[8] = -8; in[9] = -3; in[10] = 11; in[11] = -13; in[12] = 14; in[13] = 7; in[14] = -4; in[15] = 10;

        #1;

        tasks.print_if_failed(14, max);
        tasks.print_if_failed(12, argmax);

        in[0] = -15; in[1] = 12; in[2] = -16; in[3] = 1; in[4] = -1; in[5] = 1; in[6] = -9; in[7] = -5; in[8] = 6; in[9] = 2; in[10] = -12; in[11] = -6; in[12] = -6; in[13] = 0; in[14] = -6; in[15] = 1;

        #1;

        tasks.print_if_failed(12, max);
        tasks.print_if_failed(1, argmax);

    end
endmodule
