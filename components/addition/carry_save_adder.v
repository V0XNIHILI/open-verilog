`include "full_adder.v"

module carry_save_adder
    #(parameter WIDTH = 4)
    (
        input [WIDTH-1:0] a,
        input [WIDTH-1:0] b,
        input [WIDTH-1:0] c,
        output [WIDTH-1:0] sum,
        output [WIDTH-1:0] carry_out
    );
    
    wire [WIDTH-1:0] carry;
    wire [WIDTH-1:0] result;

    genvar i;
    generate 
        for (i = 0; i < WIDTH; i = i + 1) 
            begin
                full_adder full_adder_inst
                ( 
                    .a(a[i]),
                    .b(b[i]),
                    .carry_in(c[i]),
                    .sum(result[i]),
                    .carry_out(carry[i])
                );
            end
    endgenerate

    assign carry_out = carry;

    assign sum = result;
    
endmodule