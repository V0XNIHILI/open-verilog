`include "left_shift_register_array.v"
`include "right_shift_register_array.v"

module left_right_shift_register_array_tb;
    parameter BIT_WIDTH = 8;
    parameter DEPTH = 8;

    reg enable = 0;
    reg reset = 0;

    reg [BIT_WIDTH-1:0] in = 0;
    wire [BIT_WIDTH-1:0] l_out;
    wire [BIT_WIDTH-1:0] r_out;

    task print_if_failed;
        input [BIT_WIDTH-1:0] expected;
        input [BIT_WIDTH-1:0] actual_right;
        input [BIT_WIDTH-1:0] actual_left;
        begin
            if (actual_right !== expected || actual_left !== expected)
                $display("Failed. Expected: %b, actual right: %b, actual left: %b", expected, actual_right, actual_left);
        end
    endtask

    initial
    begin
        $dumpfile("left_right_shift_register_array_tb.vcd");
        $dumpvars(0,enable,reset,in,l_out,r_out,clk);
    end

    initial begin
        # 0 reset = 1; enable = 1;
        # 6 reset = 0; print_if_failed(8'b0, r_out, l_out);

        # 9 in = 8'h6F; # 1; print_if_failed(8'b0, r_out, l_out);
        # 9 in = 8'h7E; # 1; print_if_failed(8'b0, r_out, l_out);
        # 9 in = 8'h0A; # 1; print_if_failed(8'b0, r_out, l_out);
        # 9 in = 8'h3B; # 1; print_if_failed(8'b0, r_out, l_out);
        # 9 in = 8'h2C; # 1; print_if_failed(8'b0, r_out, l_out);
        # 9 in = 8'h99; # 1; print_if_failed(8'b0, r_out, l_out);
        # 9 in = 8'h05; # 1; print_if_failed(8'b0, r_out, l_out);
        # 9 in = 8'h33; # 1; print_if_failed(8'h6F, r_out, l_out);
        # 9 in = 8'b0; # 1; print_if_failed(8'h7E, r_out, l_out);
        # 9 in = 8'b0; # 1; print_if_failed(8'h0A, r_out, l_out);
        # 9 in = 8'b0; # 1; print_if_failed(8'h3B, r_out, l_out);
        # 9 in = 8'b0; # 1; print_if_failed(8'h2C, r_out, l_out);
        # 9 in = 8'b0; # 1; print_if_failed(8'h99, r_out, l_out);
        # 9 in = 8'b0; # 1; print_if_failed(8'h05, r_out, l_out);
        # 9 in = 8'b0; # 1; print_if_failed(8'h33, r_out, l_out);
        # 9 in = 8'b0; reset = 1; # 1; print_if_failed(8'b0, r_out, l_out);
        # 0 $stop;
    end

    /* Make a regular pulsing clock. */
    reg clk = 0;
    always #5 clk = !clk;

    left_shift_register_array #(.DEPTH(DEPTH), .BIT_WIDTH(BIT_WIDTH)) left_shift_register_array_inst
    (
        .clk(clk),
        .reset(reset),
        .in(in),
        .enable(enable),
        .out(l_out)
    );
    
    right_shift_register_array #(.DEPTH(DEPTH), .BIT_WIDTH(BIT_WIDTH)) right_shift_register_array_inst
    (
        .clk(clk),
        .reset(reset),
        .in(in),
        .enable(enable),
        .out(r_out)
    );
endmodule // left_right_shift_register_array_tb
