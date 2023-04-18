`include "circular_counter.v"
`include "../tasks.v"

module circular_counter_tb;
    localparam WIDTH = 4;

    localparam MAX = 2;

    /* Make a regular pulsing clock. */
    reg clk = 0;
    always #5 clk = !clk;

    reg rst = 1;
    reg en = 1;

    reg unsigned [WIDTH-1:0] max;
    wire unsigned [WIDTH-1:0] out;

    circular_counter #(.WIDTH(WIDTH)) circular_counter_inst
    (
        .clk(clk),
        .rst(rst),
        .enable(en),
        .max(max),
        .out(out)
    );

    initial
    begin
        $dumpfile("circular_counter_tb.vcd");
        $dumpvars(0,clk,rst,en,max,out);
    end

    initial
    begin
        #6; rst <= 0; max <= MAX;
    end

    integer cycle_count = 0;
    integer max_cycles = 30;

    always @ (posedge clk) begin
        #1;

        if (cycle_count < max_cycles) begin
            cycle_count = cycle_count + 1;
        end else begin
            $finish;
        end
    end

    always @ (negedge clk) begin
        if (cycle_count == 1)
            tasks.print_if_failed(0, out);
        else if (cycle_count > 1)
            tasks.print_if_failed((cycle_count - 1) % (MAX + 1), out);
    end

endmodule
