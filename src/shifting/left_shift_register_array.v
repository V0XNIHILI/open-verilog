`ifndef __LEFT_SHIFT_REGISTER_ARRAY_V__
`define __LEFT_SHIFT_REGISTER_ARRAY_V__

`include "left_shift_register.v"

module left_shift_register_array
    #(parameter BIT_WIDTH = 8, parameter DEPTH = 8)
    (
        input clk,
        input reset,
        input [BIT_WIDTH-1:0] in,                                     
        input enable,                                  
        output [BIT_WIDTH-1:0] out
    );

    genvar i;
    generate
        for (i = 0; i < BIT_WIDTH; i = i + 1)
        begin
            left_shift_register #(.DEPTH(DEPTH)) left_shift_register_inst
            (
                .clk(clk),
                .reset(reset),
                .in(in[i]),
                .enable(enable),
                .out(out[i])
            );
        end
    endgenerate

endmodule

`endif
