module left_shift_register_base
    #(parameter DEPTH=8)
    (
        input clk,
        input reset,
        input in,                                    
        input enable,                                   
        output reg [DEPTH-1:0] out
    );  

   always@(posedge clk)
        if (reset)
            out <= 0;
        else begin
            if (enable)
                out <= {out[DEPTH-2:0], in};
            else
                out <= out;
        end
        
endmodule