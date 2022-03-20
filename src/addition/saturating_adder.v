module saturating_adder
    #(parameter WIDTH = 8, parameter MAX = 2**WIDTH - 1)
    (
        input [WIDTH-1:0] sum,
        input overflow,
        output [WIDTH-1:0] saturated_sum
    );

    assign saturated_sum = (overflow == 1'b1) ? MAX : sum;
    
endmodule