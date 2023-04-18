module circular_counter
    /*
     This module adds 1 to its current state every clock cycle, 
     when its enable pin is high. It is a circular adder, so if
     it reaches its maximum value, it will reset to 0.
     The maximum value is also an input to the module.
     */
    #(parameter WIDTH = 8)
    (
        input clk,
        input rst,
        input enable,
        input unsigned [WIDTH-1:0] max,
        output reg unsigned [WIDTH-1:0] out
    );

    always @(posedge clk) begin
        if (rst) begin
            out <= 0;
        end else begin
            if (enable) begin
                if (out == max) begin
                    out <= 0;
                end else begin
                    out <= out + 1;
                end
            end
        end
    end

endmodule
