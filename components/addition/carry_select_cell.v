`include "ripple_carry_adder.v"

module carry_select_cell
    #(parameter WIDTH = 8)
    (
        input [WIDTH-1:0] a,
        input [WIDTH-1:0] b,
        input carry_in,
        output [WIDTH-1:0] sum,
        output carry_out
    );

    wire [WIDTH-1:0] sum_0;
    wire [WIDTH-1:0] sum_1;

    wire carry_out_0;
    wire carry_out_1;

    ripple_carry_adder #(.WIDTH(WIDTH)) full_adder_inst_1
    (
        .a(a),
        .b(b),
        .carry_in(1'b0),
        .sum(sum_0),
        .carry_out(carry_out_0)
    );

    ripple_carry_adder #(.WIDTH(WIDTH)) full_adder_inst_2
    (
        .a(a),
        .b(b),
        .carry_in(1'b1),
        .sum(sum_1),
        .carry_out(carry_out_1)
    );

    // TODO: write this nicely into using one if-statement
    assign sum = (carry_in == 1'b1) ? sum_1 : sum_0;
    assign carry_out = (carry_in == 1'b1) ? carry_out_1 : carry_out_0;
    
endmodule