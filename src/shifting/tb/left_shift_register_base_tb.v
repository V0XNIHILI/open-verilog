`include "../left_shift_register_base.v"

module left_shift_register_base_tb;
    reg enable = 0;
    reg reset = 0;

    reg in = 0;
    wire [8-1:0] out;

    initial
    begin
        $dumpfile("left_shift_register_base_tb.vcd");
        $dumpvars(0,enable,reset,in,out,clk);
    end

    initial begin
        # 0 reset = 1; enable = 1;
        # 6 reset = 0;
        if (out !== 8'b00000000) $display("00000000 failed.");

        # 9 in = 1; # 1;
        if (out !== 8'b00000001) $display("00000001 failed.");
        # 9 in = 0; # 1;
        if (out !== 8'b00000010) $display("00000010 failed.");
        # 9 in = 1; # 1;
        if (out !== 8'b00000101) $display("00000101 failed.");
        # 9 in = 0; # 1;
        if (out !== 8'b00001010) $display("00001010 failed.");
        # 9 reset = 1; # 1;
        if (out !== 8'b00000000) $display("00000000 failed.");
        // Try the sequence 11010110
        # 9 reset = 0; in = 1; # 1;
        if (out !== 8'b00000001) $display("00000001 failed.");
        # 9 in = 1; # 1;
        if (out !== 8'b00000011) $display("00000011 failed.");
        # 9 in = 0; # 1;
        if (out !== 8'b00000110) $display("00000110 failed.");
        # 9 in = 1; # 1;
        if (out !== 8'b00001101) $display("00001101 failed.");
        # 9 in = 0; # 1;
        if (out !== 8'b00011010) $display("00011010 failed.");
        # 9 in = 1; # 1;
        if (out !== 8'b00110101) $display("00110101 failed.");
        # 9 in = 1; # 1;
        if (out !== 8'b01101011) $display("01101011 failed.");
        // Try writing without enabling
        # 9 reset = 1; # 1;
        if (out !== 8'b00000000) $display("00000000 failed.");
        # 9 reset = 0; in = 1; enable = 0; # 1;
        if (out !== 8'b00000000) $display("00000000 failed.");
        # 0 $stop;
    end

    /* Make a regular pulsing clock. */
    reg clk = 0;
    always #5 clk = !clk;

    left_shift_register_base left_shift_register_base_inst (in, clk, enable, reset, out);
endmodule // left_shift_register_base_tb
