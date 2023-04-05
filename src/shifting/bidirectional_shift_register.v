module bidirectional_shift_register
    #(parameter DEPTH=8)
    (
        input clk,
        input reset,
        input in,                                     
        input enable,                    
        input direction, // 0: shift left, 1: shift right                
        output reg [DEPTH-1:0] out
    );  

   always@(posedge clk)
        if (reset)
            out <= 0;
        else begin
            if (enable)
                case (direction)
                    0 :  out <= {out[DEPTH-2:0], in};
                    1 :  out <= {in, out[DEPTH-1:1]};
                endcase
            else
                out <= out;
        end
        
endmodule