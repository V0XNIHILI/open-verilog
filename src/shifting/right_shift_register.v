`include "right_shift_register_base.v"

module right_shift_register
    #(parameter DEPTH=8)
    (
        input clk, 
        input reset,      
        input in,                                     
        input enable,                                   
        output out
    );

    wire [DEPTH-1:0] full_out;

    right_shift_register_base #(.DEPTH(DEPTH)) right_shift_register_base_inst
    (
        .clk(clk),
        .reset(reset),
        .in(in),
        .enable(enable),
        .out(full_out)
    );

    assign out = full_out[0];
        
endmodule
