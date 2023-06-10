module serial_max
    #(parameter WIDTH = 8)
    (
        input clk,
        input rst,
        input enable,
        input signed [WIDTH-1:0] in,
        output reg signed [WIDTH-1:0] max
    );

    always @(posedge clk) begin
        if (rst) begin
            max = -2**(WIDTH-1);
        end else if (enable) begin
            if (in > max) begin
                max = in;
            end
        end
    end

endmodule
