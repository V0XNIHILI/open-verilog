module serial_parallel_argmax
    #(parameter WIDTH = 8, parameter ARGMAX_WIDTH = 3, parameter IN_ARGMAX_WIDTH = 3, parameter MAX_IN_ARGMAX = 16)
    (
        input clk,
        input rst,
        input enable,
        input signed [WIDTH-1:0] in,
        input [IN_ARGMAX_WIDTH-1:0] in_argmax,
        output reg [ARGMAX_WIDTH-1:0] argmax,
        output reg signed [WIDTH-1:0] max
    );

    reg [ARGMAX_WIDTH-1:0] input_counter;

    always @(posedge clk) begin
        if (rst) begin
            max <= -2**(WIDTH-1);
            input_counter <= 0;
            
            argmax <= 0;
        end else if (enable) begin
            if (in > max) begin
                max <= in;

                argmax <= in_argmax + (input_counter * MAX_IN_ARGMAX);
            end

            input_counter <= input_counter + 1;            
        end
    end

endmodule
