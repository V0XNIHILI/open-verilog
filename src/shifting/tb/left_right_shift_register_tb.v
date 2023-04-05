`include "left_shift_register.v"
`include "right_shift_register.v"

module left_right_shift_register_tb;
    parameter DEPTH = 8;

    reg enable = 0;
    reg reset = 0;

    reg in = 0;
    wire l_out;
    wire r_out;

    task print_if_failed;
        input expected;
        input actual_right;
        input actual_left;
        begin
            if (actual_right !== expected || actual_left !== expected)
                $display("Failed. Expected: %b, actual right: %b, actual left: %b", expected, actual_right, actual_left);
        end
    endtask

    initial
    begin
        $dumpfile("left_right_shift_register_tb.vcd");
        $dumpvars(0,enable,reset,in,l_out,r_out,clk);
    end

    initial begin
        # 0 reset = 1; enable = 1;
        # 6 reset = 0; print_if_failed(1'b0, r_out, l_out);

        # 9 in = 1; # 1; print_if_failed(1'b0, r_out, l_out);      
        # 9 in = 0; # 1; print_if_failed(1'b0, r_out, l_out);      
        # 9 in = 0; # 1; print_if_failed(1'b0, r_out, l_out);       
        # 9 in = 1; # 1; print_if_failed(1'b0, r_out, l_out);      
        # 9 in = 0; # 1; print_if_failed(1'b0, r_out, l_out);       
        # 9 in = 1; # 1; print_if_failed(1'b0, r_out, l_out);     
        # 9 in = 0; # 1; print_if_failed(1'b0, r_out, l_out);   
        # 9 in = 1; # 1; print_if_failed(1'b1, r_out, l_out);
        # 9 in = 0; # 1; print_if_failed(1'b0, r_out, l_out);        
        # 9 in = 0; # 1; print_if_failed(1'b0, r_out, l_out);       
        # 9 in = 0; # 1; print_if_failed(1'b1, r_out, l_out);
        # 9 in = 0; # 1; print_if_failed(1'b0, r_out, l_out);         
        # 9 in = 0; # 1; print_if_failed(1'b1, r_out, l_out);
        # 9 in = 0; # 1; print_if_failed(1'b0, r_out, l_out);
        # 9 in = 0; # 1; print_if_failed(1'b1, r_out, l_out);
        # 9 in = 0; reset = 1; # 1; print_if_failed(1'b0, r_out, l_out);
        # 0 $stop;
    end

    /* Make a regular pulsing clock. */
    reg clk = 0;
    always #5 clk = !clk;

    left_shift_register #(.DEPTH(DEPTH)) left_shift_register_inst
    (
        .clk(clk),
        .reset(reset),
        .in(in),
        .enable(enable),
        .out(l_out)
    );
    
    right_shift_register #(.DEPTH(DEPTH)) right_shift_register_inst
    (
        .clk(clk),
        .reset(reset),
        .in(in),
        .enable(enable),
        .out(r_out)
    );

endmodule // left_right_shift_register_tb
