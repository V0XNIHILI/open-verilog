`include "square_lut_4_bit.v"
`include "../tasks.v"

module square_lut_4_bit_tb;
    localparam WIDTH = 4;

    reg signed [WIDTH-1:0] in;
    wire signed [2*WIDTH-1:0] out;

    square_lut_4_bit square_lut_4_bit_inst
    (
        .in(in),
        .out(out)
    );

    initial
    begin
        $dumpfile("square_lut_4_bit_tb.vcd");
        $dumpvars(0,in,out);
    end

    initial begin
        for (integer i = -2 ** (WIDTH - 1); i < 2 ** (WIDTH-1); i = i + 1) begin
            in = i;
            # 1;
            tasks.print_if_failed(i * i, out);
        end
    end
endmodule
