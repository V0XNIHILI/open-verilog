`include "carry_lookahead_adder.v"

module carry_lookahead_adder_tb;
    localparam WIDTH = 8;

    reg carry_in;
    reg [WIDTH-1:0] a;
    reg [WIDTH-1:0] b;
    wire carry_out;

    wire [WIDTH-1:0] sum;

    carry_lookahead_adder #(.WIDTH(WIDTH)) kogge_stone_adder_inst
    (
        .carry_in(carry_in),
        .a(a),
        .b(b),
        .sum(sum),
        .carry_out(carry_out)
    );

    task print_if_failed;
        input integer expected; 
        input integer actual;
        begin
            if (actual !== expected) begin
                $display("Failed. Expected: %d, actual: %d", expected, actual);
                $stop;
            end
        end
    endtask

    initial
    begin
        $dumpfile("carry_lookahead_adder_tb.vcd");
        $dumpvars(0,a,b,sum,carry_out);
    end

    initial begin
        for (integer i = 0; i < 2 ** WIDTH; i = i + 1) begin
            a = i;

            for (integer j = 0; j < 2 ** WIDTH; j = j + 1) begin
                b = j;
                
                for (integer k = 0; k < 1; k = k + 1) begin
                    carry_in = k;

                    # 1;

                    if (i + j + k >= 2 ** WIDTH) begin
                        print_if_failed(i + j  + k - 2 ** WIDTH, sum);
                        print_if_failed(1, carry_out);
                    end else
                        print_if_failed(i + j + k, sum);
                end
            end
        end

        $finish;
    end

endmodule
