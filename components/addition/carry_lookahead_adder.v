`include "full_adder.v"
`include "lookahead_carry_unit.v"
 
module carry_lookahead_adder
    #(parameter WIDTH = 8)
    (
        input carry_in,
        input [WIDTH-1:0] a,
        input [WIDTH-1:0] b,
        output [WIDTH-1:0] sum,
        output carry_out
    );
        
    wire [WIDTH:0] carry;
    wire [WIDTH-1:0] generate_bits; // Called generate_bits because generate is a reserved keyword in Verilog
    wire [WIDTH-1:0] propagate;

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
                    .carry_out()
                );
            end
    endgenerate

    lookahead_carry_unit lookahead_carry_unit_inst
    ( 
        .a(a),
        .b(b),
        .carry_in(carry_in),
        .carry(carry),
        .carry_out(carry_out)
    );

endmodule