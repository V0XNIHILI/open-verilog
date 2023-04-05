module right_shift_register_base
    #(parameter DEPTH=8)
    (
        input clk,    
        input reset,    
        input in,                                     
        input enable,                                  
        output reg [DEPTH-1:0] out
    );  

   always@(posedge clk)
        if (reset == 1'b1)
            out <= 0;
        else begin
            if (enable)
                out <= {in, out[DEPTH-1:1]};
            else
                out <= out;
        end
        
endmodule