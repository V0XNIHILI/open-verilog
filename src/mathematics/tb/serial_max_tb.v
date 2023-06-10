`include "serial_max.v"
`include "../tasks.v"

module serial_max_tb;
    localparam WIDTH = 4;
    localparam MIN = -2 ** (WIDTH - 1);

    /* Make a regular pulsing clock. */
    reg clk = 0;
    always #5 clk = !clk;

    reg rst = 1;

    reg signed [WIDTH-1:0] in;
    wire signed [WIDTH-1:0] max;

    serial_max #(.WIDTH(WIDTH)) serial_max_inst
    (
        .clk(clk),
        .rst(rst),
        .enable(1),
        .in(in),
        .max(max)
    );

    initial
    begin
        $dumpfile("serial_max_tb.vcd");
        $dumpvars(0,clk,rst,in,max);
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
            tasks.print_if_failed(MIN, max);
        else if (i > MIN + 1)
            tasks.print_if_failed(i - 2, max);
    end

endmodule
