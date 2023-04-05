module right_shift_register_base
    #(parameter SIZE=8)
    (
        input in,                      
        input clk,                   
        input enable,                    
        input reset,                  
        output reg [SIZE-1:0] out
    );  

   always@(posedge clk)
        if (reset == 1'b1)
            out <= 0;
        else begin
            if (enable)
                out <= {in, out[SIZE-1:1]};
            else
                out <= out;
        end
        
endmodule