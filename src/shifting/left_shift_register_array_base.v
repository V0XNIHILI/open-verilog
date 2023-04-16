`ifndef __LEFT_SHIFT_REGISTER_ARRAY_BASE_V__
`define __LEFT_SHIFT_REGISTER_ARRAY_BASE_V__

`include "left_shift_register_base.v"

module left_shift_register_array_base
    #(parameter BIT_WIDTH = 8, parameter DEPTH = 8)
    (
        input clk,
        input reset,
        input [BIT_WIDTH-1:0] in,                                     
        input enable,                                  
        output [DEPTH-1:0] out [BIT_WIDTH-1:0]
    );

    genvar i;
    generate
        for (i = 0; i < BIT_WIDTH; i = i + 1)
        begin
            left_shift_register_base #(.DEPTH(DEPTH)) left_shift_register_base_inst
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
