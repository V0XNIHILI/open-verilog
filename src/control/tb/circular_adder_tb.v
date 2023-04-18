`include "circular_adder.v"
`include "../tasks.v"

module circular_adder_tb;
    localparam WIDTH = 4;

    reg unsigned [WIDTH-1:0] a;
    reg unsigned [WIDTH-1:0] b;
    reg unsigned [WIDTH-1:0] max;
    wire unsigned [WIDTH-1:0] sum;

    circular_adder #(.WIDTH(WIDTH)) circular_adder_inst
    (
        .a(a),
        .b(b),
        .max(max),
        .sum(sum)
    );

    initial
    begin
        $dumpfile("circular_adder_tb.vcd");
        $dumpvars(0,a,b,max,sum);
    end

    initial
    begin
        for(integer max_value = 0; max_value < 2 ** WIDTH; max_value = max_value + 1) begin
            max <= max_value;
            #1;

            for(integer i = 0; i < 2 ** WIDTH; i = i + 1) begin
                for(integer j = 0; j < 2 ** WIDTH; j = j + 1) begin
                    a <= i;
                    b <= j;
                    #1;
                    tasks.print_if_failed(i + j > max_value ? 0 : i + j, sum);
                end
            end
        end
    end

endmodule
