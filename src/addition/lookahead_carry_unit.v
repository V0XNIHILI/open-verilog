module lookahead_carry_unit
    #(parameter WIDTH = 8)
    (
        input carry_in,
        input [WIDTH-1:0] a,
        input [WIDTH-1:0] b,
        output [WIDTH:0] carry,
        output carry_out
    );
        
    wire [WIDTH-1:0] generate_bits; // Called generate_bits because generate is a reserved keyword in Verilog
    wire [WIDTH-1:0] propagate;

    assign carry[0] = carry_in; // no carry input on first adder

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) 
            begin
                assign generate_bits[i] = a[i] & b[i];
                assign propagate[i] = a[i] | b[i];
                assign carry[i+1] = generate_bits[i] | (propagate[i] & carry[i]);
            end
    endgenerate

    assign carry_out = carry[WIDTH];

endmodule