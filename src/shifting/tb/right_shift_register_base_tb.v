`include "../right_shift_register_base.v"

module right_shift_register_base_tb;
    reg enable = 0;
    reg reset = 0;

    reg in = 0;
    wire [8-1:0] out;

    initial
    begin
        $dumpfile("right_shift_register_base_tb.vcd");
        $dumpvars(0,enable,reset,in,out,clk);
    end

    initial begin
        # 0 reset = 1; enable = 1;
        # 6 reset = 0;
        if (out !== 8'b00000000) $display("00000000 failed.");

        # 9 in = 1; # 1;
        if (out !== 8'b10000000) $display("10000000 failed.");
        # 9 in = 0; # 1;
        if (out !== 8'b01000000) $display("01000000 failed.");
        # 9 in = 1; # 1;
        if (out !== 8'b10100000) $display("10100000 failed.");
        # 9 in = 0; # 1;
        if (out !== 8'b01010000) $display("01010000 failed.");
        # 9 reset = 1; # 1;
        if (out !== 8'b00000000) $display("00000000 failed.");
        // Try the sequence 11010110
        # 9 reset = 0; in = 1; # 1;
        if (out !== 8'b10000000) $display("10000000 failed.");
        # 9 in = 1; # 1;
        if (out !== 8'b11000000) $display("11000000 failed.");
        # 9 in = 0; # 1;
        if (out !== 8'b01100000) $display("01100000 failed.");
        # 9 in = 1; # 1;
        if (out !== 8'b10110000) $display("10110000 failed.");
        # 9 in = 0; # 1;
        if (out !== 8'b01011000) $display("01011000 failed.");
        # 9 in = 1; # 1;
        if (out !== 8'b10101100) $display("10101100 failed.");
        # 9 in = 1; # 1;
        if (out !== 8'b11010110) $display("11010110 failed.");
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

    right_shift_register_base right_shift_register_base_inst (in, clk, enable, reset, out);
endmodule // right_shift_register_base_tb
