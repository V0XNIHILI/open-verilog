`include "left_shift_register_base.v"

module left_shift_register_base_tb;
    parameter DEPTH = 8;

    reg enable = 0;
    reg reset = 0;

    reg in = 0;
    wire [8-1:0] out;

    task print_if_failed;
        input [DEPTH-1:0] expected;
        input [DEPTH-1:0] actual;
        begin
            if (actual !== expected)
                $display("Failed. Expected: %b, actual: %b", expected, actual);
        end
    endtask

    initial
    begin
        $dumpfile("left_shift_register_base_tb.vcd");
        $dumpvars(0,enable,reset,in,out,clk);
    end

    initial begin
        # 0 reset = 1; enable = 1;
        # 6 reset = 0; print_if_failed(8'b0, out);

        # 9 in = 1; # 1; print_if_failed(8'b00000001, out);
        # 9 in = 0; # 1; print_if_failed(8'b00000010, out);
        # 9 in = 1; # 1; print_if_failed(8'b00000101, out);
        # 9 in = 0; # 1; print_if_failed(8'b00001010, out);
        # 9 reset = 1; # 1; print_if_failed(8'b0, out);
        // Try the sequence 11010110
        # 9 reset = 0; in = 1; # 1; print_if_failed(8'b00000001, out);
        # 9 in = 1; # 1; print_if_failed(8'b00000011, out);
        # 9 in = 0; # 1; print_if_failed(8'b00000110, out);
        # 9 in = 1; # 1; print_if_failed(8'b00001101, out);
        # 9 in = 0; # 1; print_if_failed(8'b00011010, out);
        # 9 in = 1; # 1; print_if_failed(8'b00110101, out);
        # 9 in = 1; # 1; print_if_failed(8'b01101011, out);
        // Try writing without enabling
        # 9 reset = 1; # 1; print_if_failed(8'b0, out);
        # 9 reset = 0; in = 1; enable = 0; # 1; print_if_failed(8'b0, out);
        # 0 $stop;
    end

    /* Make a regular pulsing clock. */
    reg clk = 0;
    always #5 clk = !clk;

    left_shift_register_base #(.DEPTH(DEPTH)) left_shift_register_base_inst 
    (
        .clk(clk),
        .reset(reset),
        .in(in),
        .enable(enable),
        .out(out)
    );

endmodule // left_shift_register_base_tb
