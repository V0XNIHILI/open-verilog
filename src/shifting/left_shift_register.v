module left_shift_register
    #(parameter SIZE=8)
    (
        input data_in,                      
        input clk,                   
        input enable,                    
        input reset,                  
        output reg [SIZE-1:0] out
    );  

   always@(posedge clk)
        if (!reset)
            out <= 0;
        else begin
            if (enable)
                out <= {out[SIZE-2:0], data_in};
            else
                out <= out;
        end
        
endmodule