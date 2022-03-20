module xnor
    (
        input  a,
        input  b,
        output z
    );

   assign z = (a & b) | (~a & ~b);

endmodule