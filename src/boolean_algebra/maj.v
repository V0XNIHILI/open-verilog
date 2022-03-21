`include "nand3.v"

module maj
    (
        input a,
        input b,
        input c,
        output z
    );

    wire a_nand_b;
    wire b_nand_c;
    wire c_nand_a;

    nand (a_nand_b, a, b);
    nand (b_nand_c, b, c);
    nand (c_nand_a, c, a);

    nand3 nand3_inst
    (
        .a(a_nand_b),
        .b(b_nand_c),
        .c(c_nand_a),
        .z(z)
    );

endmodule