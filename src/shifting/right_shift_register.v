`include "right_shift_register_base.v"

module right_shift_register
    #(parameter SIZE=8)
    (
        input in,                      
        input clk,                   
        input enable,                    
        input reset,                  
        output out
    );

    wire [SIZE-1:0] full_out;

    right_shift_register_base #(.SIZE(SIZE)) right_shift_register_base_inst
    (
        .in(in),
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .out(full_out)
    );

    assign out = full_out[0];
        
endmodule
