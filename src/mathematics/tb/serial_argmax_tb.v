`include "serial_argmax.v"
`include "../tasks.v"

module serial_argmax_tb;
    localparam WIDTH = 4;
    localparam ARGMAX_WIDTH = 5;

    localparam MIN = -2 ** (WIDTH - 1);

    /* Make a regular pulsing clock. */
    reg clk = 0;
    always #5 clk = !clk;

    reg rst = 1;

    reg signed [WIDTH-1:0] in;
    wire unsigned [ARGMAX_WIDTH-1:0] argmax;

    serial_argmax  #(.WIDTH(WIDTH), .ARGMAX_WIDTH(ARGMAX_WIDTH)) serial_argmax_inst
    (
        .clk(clk),
        .rst(rst),
        .in(in),
        .argmax(argmax)
    );

    initial
    begin
        $dumpfile("serial_argmax.vcd");
        $dumpvars(0,clk,rst,in,argmax);
    end

    integer i = MIN;

    initial
    begin
        #6; rst <= 0;
    end

    always @ (posedge clk) begin
        #1;

        if (i < 2 ** (WIDTH-1)) begin
            in <= i;
            i = i + 1;
        end else begin
            $finish;
        end
    end

    always @ (negedge clk) begin
        if (i == MIN + 1)
            tasks.print_if_failed(0, argmax);
        else
            tasks.print_if_failed(i - 2 - MIN, argmax);
    end

endmodule
