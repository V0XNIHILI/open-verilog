module relu
    #(parameter WIDTH = 8)
	(
		input sign,
		input [WIDTH-1:0] a,
		output [WIDTH-1:0] z,
	);

	assign z = (sign == 1'b1) ? 0 : a;
	
endmodule
