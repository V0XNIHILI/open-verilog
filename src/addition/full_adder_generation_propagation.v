`ifndef __FULL_ADDER_GENERATION_PROPAGATION_V__
`define __FULL_ADDER_GENERATION_PROPAGATION_V__

module full_adder_generation_propagation 
	(
		input a,
		input b,
		input carry_in,
		output sum,
        output p,
        output g,
		output carry_out
	);
		
	assign p = a ^ b;
    assign g = a & b;

	assign sum = p ^ carry_in;
	assign carry_out = (p & carry_in) | g;
	
endmodule

`endif
