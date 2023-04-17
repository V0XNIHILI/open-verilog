module serial_argmax
    #(parameter WIDTH = 8, parameter ARGMAX_WIDTH = 3)
    (
        input clk,
        input rst,
        input signed [WIDTH-1:0] in,
        output reg unsigned [ARGMAX_WIDTH-1:0] argmax
    );

    reg signed [WIDTH-1:0] max;
    reg was_reset;

    always @(posedge clk) begin
        if (rst) begin
            max <= -2**(WIDTH-1);
            argmax <= 0;
            was_reset <= 1;
        end else begin
            if (was_reset) begin
                was_reset <= 0;
            end else if (in > max) begin
                max = in;

                argmax <= argmax + 1;
            end
        end
    end

endmodule
