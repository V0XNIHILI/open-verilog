`include "../left_shift_register.v"
`include "../right_shift_register.v"

module left_right_shift_register_tb;
    reg enable = 0;
    reg reset = 0;

    reg in = 0;
    wire l_out;
    wire r_out;

    initial
    begin
        $dumpfile("left_right_shift_register_tb.vcd");
        $dumpvars(0,enable,reset,in,l_out,r_out,clk);
    end

    initial begin
        # 0 reset = 1; enable = 1;
        # 6 reset = 0;
        if (r_out !== 1'b0 || l_out !== 1'b0) $display("0 failed. r_out: %b, l_out: %b", r_out, l_out);

        # 9 in = 1; # 1;
        if (r_out !== 1'b0) $display("0 failed. r_out: %b, l_out: %b", r_out, l_out);
        # 9 in = 0; # 1;
        if (r_out !== 1'b0) $display("0 failed. r_out: %b, l_out: %b", r_out, l_out);
        # 9 in = 0; # 1;
        if (r_out !== 1'b0) $display("0 failed. r_out: %b, l_out: %b", r_out, l_out);
        # 9 in = 1; # 1;
        if (r_out !== 1'b0) $display("0 failed. r_out: %b, l_out: %b", r_out, l_out);
        # 9 in = 0; # 1;
        if (r_out !== 1'b0) $display("0 failed. r_out: %b, l_out: %b", r_out, l_out);
        # 9 in = 1; # 1;
        if (r_out !== 1'b0) $display("0 failed. r_out: %b, l_out: %b", r_out, l_out);
        # 9 in = 0; # 1;
        if (r_out !== 1'b0) $display("0 failed. r_out: %b, l_out: %b", r_out, l_out);
        # 9 in = 1; # 1;
        if (r_out !== 1'b1) $display("1 failed. r_out: %b, l_out: %b", r_out, l_out);
        # 9 in = 0; # 1;
        if (r_out !== 1'b0) $display("0 failed. r_out: %b, l_out: %b", r_out, l_out);
        # 9 in = 0; # 1;
        if (r_out !== 1'b0) $display("0 failed. r_out: %b, l_out: %b", r_out, l_out);
        # 9 in = 0; # 1;
        if (r_out !== 1'b1) $display("1 failed. r_out: %b, l_out: %b", r_out, l_out);
        # 9 in = 0; # 1;
        if (r_out !== 1'b0) $display("0 failed. r_out: %b, l_out: %b", r_out, l_out); 
        # 9 in = 0; # 1;
        if (r_out !== 1'b1) $display("1 failed. r_out: %b, l_out: %b", r_out, l_out);
        # 9 in = 0; # 1;
        if (r_out !== 1'b0) $display("0 failed. r_out: %b, l_out: %b", r_out, l_out); 
        # 9 in = 0; # 1;
        if (r_out !== 1'b1) $display("1 failed. r_out: %b, l_out: %b", r_out, l_out);
        # 9 in = 0; reset = 1; # 1;
        if (r_out !== 1'b0) $display("0 failed. r_out: %b, l_out: %b", r_out, l_out);
        # 0 $stop;
    end

    /* Make a regular pulsing clock. */
    reg clk = 0;
    always #5 clk = !clk;

    left_shift_register left_shift_register_inst (in, clk, enable, reset, l_out);
    right_shift_register right_shift_register_inst (in, clk, enable, reset, r_out);
endmodule // left_right_shift_register_tb
