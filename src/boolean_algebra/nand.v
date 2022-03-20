module nand
    (
        input  a,
        input  b,
        output z
    );

   assign z =  ~(a & b);

endmodule