`include "right_shift_register_base.v"

module right_shift_register_base_tb;
    parameter DEPTH = 8;

    reg enable = 0;
    reg reset = 0;

    reg in = 0;
    wire [8-1:0] out;

    task print_if_failed;
        input [DEPTH-1:0] expected;
        input [DEPTH-1:0] actual;
        begin
            if (actual !== expected) begin
                $display("Failed. Expected: %b, actual: %b", expected, actual);
                $stop;
            end
        end
    endtask

    initial
    begin
        $dumpfile("right_shift_register_base_tb.vcd");
        $dumpvars(0,enable,reset,in,out,clk);
    end

    initial begin
        # 0 reset = 1; enable = 1;
        # 6 reset = 0; print_if_failed(8'b0, out);

        # 9 in = 1; # 1; print_if_failed(8'b10000000, out);
        # 9 in = 0; # 1; print_if_failed(8'b01000000, out);
        # 9 in = 1; # 1; print_if_failed(8'b10100000, out);
        # 9 in = 0; # 1; print_if_failed(8'b01010000, out);
        # 9 reset = 1; # 1; print_if_failed(8'b0, out);
        // Try the sequence 11010110
        # 9 reset = 0; in = 1; # 1; print_if_failed(8'b10000000, out);
        # 9 in = 1; # 1;  print_if_failed(8'b11000000, out);
        # 9 in = 0; # 1; print_if_failed(8'b01100000, out);
        # 9 in = 1; # 1; print_if_failed(8'b10110000, out);
        # 9 in = 0; # 1; print_if_failed(8'b01011000, out);
        # 9 in = 1; # 1; print_if_failed(8'b10101100, out);
        # 9 in = 1; # 1; print_if_failed(8'b11010110, out);
        // Try writing without enabling
        # 9 reset = 1; # 1; print_if_failed(8'b0, out);
        # 9 reset = 0; in = 1; enable = 0; # 1; print_if_failed(8'b0, out);
        # 0 $finish;
    end

    /* Make a regular pulsing clock. */
    reg clk = 0;
    always #5 clk = !clk;

    right_shift_register_base #(.DEPTH(DEPTH)) right_shift_register_base_inst
    (
        .clk(clk),
        .reset(reset),
        .in(in),
        .enable(enable),
        .out(out)
    );
    
endmodule // right_shift_register_base_tb
