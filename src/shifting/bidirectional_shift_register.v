module bidirectional_shift_register
    #(parameter SIZE=8)
    (
        input data_in,                      
        input clk,                   
        input enable,                    
        input direction, // 0: shift left, 1: shift right
        input reset,                  
        output reg [SIZE-1:0] out
    );  

   always@(posedge clk)
        if (!reset)
            out <= 0;
        else begin
            if (enable)
                case (direction)
                    0 :  out <= {out[SIZE-2:0], data_in};
                    1 :  out <= {data_in, out[SIZE-1:1]};
                endcase
            else
                out <= out;
        end
        
endmodule