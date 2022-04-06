module two_to_one_mux
    #(parameter WIDTH = 3)
    (
        input [WIDTH-1:0] d0,
        input [WIDTH-1:0] d1,
        input select,
        output [WIDTH-1:0] y,
    );

    assign y = (select == 1'b1) ? d1 : d0;

endmodule