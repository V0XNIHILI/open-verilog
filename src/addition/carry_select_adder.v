`include "carry_select_cell.v"

module carry_select_adder
    #(parameter WIDTH = 8)
    (
        input [WIDTH-1:0] a,
        input [WIDTH-1:0] b,
        input carry_in,
        output [WIDTH-1:0] sum,
        output carry_out
    );

    if (WIDTH % 2 !== 0) begin
        $error("WIDTH must be even");
    end

    wire [WIDTH/2-1:0] right_sum;
    wire [WIDTH/2-1:0] left_sum;

    wire carry_out_internal;

    ripple_carry_adder #(.WIDTH(WIDTH/2)) ripple_carry_adder_inst
    (
        .a(a[WIDTH/2-1:0]),
        .b(b[WIDTH/2-1:0]),
        .carry_in(carry_in),
        .sum(right_sum),
        .carry_out(carry_out_internal)
    );

    carry_select_cell #(.WIDTH(WIDTH/2)) carry_select_cell_inst
    (
        .a(a[WIDTH-1:WIDTH/2]),
        .b(b[WIDTH-1:WIDTH/2]),
        .carry_in(carry_out_internal),
        .sum(left_sum),
        .carry_out(carry_out)
    );

    assign sum = {left_sum, right_sum};

endmodule