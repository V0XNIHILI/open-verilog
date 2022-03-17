module inh
    (
        input  a,
        input  b,
        output z
    );

   assign z =  (a & ~b);

endmodule