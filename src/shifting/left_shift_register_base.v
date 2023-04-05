module left_shift_register_base
    #(parameter SIZE=8)
    (
        input in,                      
        input clk,                   
        input enable,                    
        input reset,                  
        output reg [SIZE-1:0] out
    );  

   always@(posedge clk)
        if (reset)
            out <= 0;
        else begin
            if (enable)
                out <= {out[SIZE-2:0], in};
            else
                out <= out;
        end
        
endmodule