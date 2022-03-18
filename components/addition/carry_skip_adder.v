`include "full_adder_generation_propagation.v"

module carry_skip_adder
    #(parameter WIDTH = 8)
    (
        input carry_in,
        input [WIDTH-1:0] a,
        input [WIDTH-1:0] b,
        output [WIDTH-1:0] sum,
        output carry_out,
        output p
    );

    wire p;
    
    wire [WIDTH:0] carry;
    wire [WIDTH-1:0] propagate;

    assign carry[0] = carry_in;

    genvar i;
    generate 
        for (i = 0; i < WIDTH; i = i + 1) 
            begin
                full_adder_generation_propagation full_adder_generation_propagation_inst
                ( 
                    .a(a[i]),
                    .b(b[i]),
                    .carry_in(carry[i]),
                    .sum(sum[i]),
                    .p(propagate[i]),
                    .g(),
                    .carry_out(carry[i+1])
                );
            end
    endgenerate

    assign p = &propagate;

    assign carry_out = (p == 1'b1) ? carry_in : carry[WIDTH];
    
endmodule