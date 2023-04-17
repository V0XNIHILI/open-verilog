`include "pot_shift.v"
`include "../tasks.v"

module pot_shift_tb;
    parameter OUTPUT_BIT_WIDTH = 20;
    parameter WEIGHT_BIT_WIDTH = 4;
    parameter INPUT_BIT_WIDTH = 4;

    integer required_shift = OUTPUT_BIT_WIDTH - WEIGHT_BIT_WIDTH;

    integer value2;
    integer value3;

    reg signed [INPUT_BIT_WIDTH-1:0] in = 4'b0000;
    reg [WEIGHT_BIT_WIDTH-1:0] weight = 4'b1000;
    wire signed [OUTPUT_BIT_WIDTH-1:0] out;

    pot_shift #(.WEIGHT_BIT_WIDTH(WEIGHT_BIT_WIDTH), .INPUT_BIT_WIDTH(INPUT_BIT_WIDTH)) pot_shift_inst
    (
        .in(in),
        .weight(weight),
        .out(out)
    );

    initial begin
        // Check zero input handling
        weight = 4'b0000; in = 4'b0000; # 0;
        tasks.print_if_failed(0, out);

        weight = 4'b0001; in = 4'b0000; # 0;
        tasks.print_if_failed(0, out);

        weight = 4'b1001; in = 4'b0000; # 0;
        tasks.print_if_failed(0, out);
        
        // Check identity (weight is 1, so no shift)
        weight = 4'b0000; in = 4'b0001; # 0;
        tasks.print_if_failed(in<<required_shift, out);

        weight = 4'b0000; in = 4'b1101; # 0;
        tasks.print_if_failed(in<<required_shift, out);
    end
endmodule
