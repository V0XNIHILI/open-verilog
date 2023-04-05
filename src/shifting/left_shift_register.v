`include "left_shift_register_base.v"

module left_shift_register
    #(parameter DEPTH=8)
    (
        input clk,    
        input reset,  
        input in,                                     
        input enable,                                    
        output out
    );

    wire [DEPTH-1:0] full_out;

    left_shift_register_base #(.DEPTH(DEPTH)) left_shift_register_base_inst
    (
        .clk(clk),
        .reset(reset),
        .in(in),
        .enable(enable),
        .out(full_out)
    );

    assign out = full_out[DEPTH-1];
        
endmodule
