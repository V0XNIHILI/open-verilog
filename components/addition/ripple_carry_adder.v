`include "full_adder.v"

module ripple_carry_adder
    #(parameter WIDTH = 8)
    (
        input [WIDTH-1:0] a,
        input [WIDTH-1:0] b,
        output [WIDTH-1:0] sum,
        output carry_out
    );
    
    wire [WIDTH:0] carry;

    assign carry[0] = 1'b0;

    genvar i;
    generate 
        for (i = 0; i < WIDTH; i = i + 1) 
            begin
                full_adder full_adder_inst
                ( 
                    .a(a[i]),
                    .b(b[i]),
                    .carry_in(carry[i]),
                    .sum(sum[i]),
                    .carry_out(carry[i+1])
                );
            end
    endgenerate

    assign carry_out = carry[WIDTH];
    
endmodule