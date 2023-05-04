`include "unsigned_pot_shift.v"
`include "../tasks.v"

module pot_shift_tb;
    parameter OUTPUT_BIT_WIDTH = 12;
    parameter WEIGHT_BIT_WIDTH = 4;
    parameter INPUT_BIT_WIDTH = 4;

    reg unsigned [INPUT_BIT_WIDTH-1:0] in = 4'b0000;
    reg [WEIGHT_BIT_WIDTH-1:0] weight = 4'b1000;
    wire signed [OUTPUT_BIT_WIDTH-1:0] out;

    unsigned_pot_shift #(.WEIGHT_BIT_WIDTH(WEIGHT_BIT_WIDTH), .INPUT_BIT_WIDTH(INPUT_BIT_WIDTH)) unsigned_pot_shift_inst
    (
        .in(in),
        .weight(weight),
        .out(out)
    );

    initial begin
        for (integer i = 0; i < 2 ** INPUT_BIT_WIDTH; i = i + 1) begin
            for (integer w_sign = -1; w_sign <= 1; w_sign = w_sign + 2) begin
                for (integer w = 0; w < 2 ** (WEIGHT_BIT_WIDTH-1); w = w + 1) begin
                    in = i;
                    weight = w + (w_sign == -1 ? 2 ** (WEIGHT_BIT_WIDTH-1) : 0);
                    # 0;
                    tasks.print_if_failed(w_sign * in * (2 ** w), out);
                end
            end
        end
    end
endmodule
