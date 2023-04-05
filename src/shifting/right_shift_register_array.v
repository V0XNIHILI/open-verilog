`ifndef __RIGHT_SHIFT_REGISTER_ARRAY_V__
`define __RIGHT_SHIFT_REGISTER_ARRAY_V__

`include "right_shift_register.v"

module right_shift_register_array
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
            right_shift_register #(.DEPTH(DEPTH)) right_shift_register_inst
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
