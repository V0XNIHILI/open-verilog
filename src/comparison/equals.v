module equals
    #(parameter WIDTH = 8)
	(
        input [WIDTH-1:0] a,
        input [WIDTH-1:0] b,
		output equal
	);

    assign equal = a == b;
	
endmodule