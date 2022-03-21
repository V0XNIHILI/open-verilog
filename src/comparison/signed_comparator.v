`include "unsigned_comparator.v"

module signed_comparator
    #(parameter WIDTH = 8)
    (
        input  [WIDTH-1:0] a,
        input  [WIDTH-1:0] b,
        output a_smaller_than_b,
        output equal,
        output a_larger_than_b
    );

    wire local_a_smaller_than_b;
    wire local_equal;
    wire local_a_larger_than_b;

    unsigned_comparator unsigned_comparator_inst
    (
        .a(a[WIDTH-2:0]),
        .b(b[WIDTH-2:0]),
        .a_smaller_than_b(local_a_smaller_than_b),
        .equal(local_equal),
        .a_larger_than_b(local_a_larger_than_b)
    );

    defparam unsigned_comparator_inst.WIDTH = WIDTH - 1;

    assign a_smaller_than_b = local_a_smaller_than_b & (b[WIDTH-1] == 1'b0) | local_a_larger_than_b & (a[WIDTH-1] == 1'b1);
    assign equal = local_equal & (a[WIDTH-1] == b[WIDTH-1]);
    assign a_larger_than_b = local_a_larger_than_b & (a[WIDTH-1] == 1'b0) | local_a_smaller_than_b & (b[WIDTH-1] == 1'b1);

endmodule

// a_larger_than_b (A = a_larger, B = b_larger, C = a_negative, D = b_negative)
// 	A	B	C	D	Y
// 0	0	0	0	0	0
// 1	0	0	0	1	0
// 2	0	0	1	0	0
// 3	0	0	1	1	0
// 4	0	1	0	0	0
// 5	0	1	0	1	1
// 6	0	1	1	0	0
// 7	0	1	1	1	1
// 8	1	0	0	0	1
// 9	1	0	0	1	1
// 10	1	0	1	0	0
// 11	1	0	1	1	0
// 12	1	1	0	0	x
// 13	1	1	0	1	x
// 14	1	1	1	0	x
// 15	1	1	1	1	x

// a_smaller_than_b
// 	A	B	C	D	Y
// 0	0	0	0	0	0
// 1	0	0	0	1	0
// 2	0	0	1	0	0
// 3	0	0	1	1	0
// 4	0	1	0	0	1
// 5	0	1	0	1	0
// 6	0	1	1	0	1
// 7	0	1	1	1	0
// 8	1	0	0	0	0
// 9	1	0	0	1	0
// 10	1	0	1	0	1
// 11	1	0	1	1	1
// 12	1	1	0	0	x
// 13	1	1	0	1	x
// 14	1	1	1	0	x
// 15	1	1	1	1	x
