`include "serial_parallel_argmax_signed_16_inputs.v"
`include "../tasks.v"

module serial_parallel_argmax_signed_16_inputs_tb;
    localparam WIDTH = 8;
    localparam INDEX_WIDTH = 8;

    /* Make a regular pulsing clock. */
    reg clk = 0;
    always #5 clk = !clk;

    reg rst = 1;

    reg signed [16-1:0][WIDTH-1:0] in;
    wire signed [WIDTH-1:0] max;
    wire [INDEX_WIDTH-1:0] argmax;

    wire signed [WIDTH-1:0] in15;

    integer num_inputs = 16;

    serial_parallel_argmax_signed_16_inputs #(.WIDTH(WIDTH), .INDEX_WIDTH(INDEX_WIDTH)) serial_parallel_argmax_signed_16_inputs_inst
    (
        .clk(clk),
        .rst(rst),

        .enable(1),

        .in(in),

        .max(max),
        .argmax(argmax)
    );

    initial
    begin
        #7; rst <= 0;
    end

    integer cycle_count = 0;
    integer max_cycle_count = 16;

    // Dump to VCD file.
    initial begin
        $dumpfile("serial_parallel_argmax_signed_16_inputs_tb.vcd");
        $dumpvars(0,clk,rst,cycle_count,max,argmax,in15);
    end


    assign in15 = in[15];

    always @ (posedge clk) begin
        #1;
        $display("x!\n");

        for (integer i = 0; i < num_inputs; i = i + 1) begin
            in[i] = cycle_count+i;
        end

        #0;
        cycle_count = cycle_count + 1;
    end

    always @ (negedge clk) begin
        #4;
        $display("max index: %d", argmax);

        if (cycle_count == max_cycle_count + 1) begin
            $finish;
        end
    end
    
endmodule
