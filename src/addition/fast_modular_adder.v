`include "carry_save_adder.v"
`include "ripple_carry_adder.v"

module fast_modular_adder
	#(parameter WIDTH = 8, M = 127)
	(
		input [WIDTH-1:0] a,
		input [WIDTH-1:0] b,
		output [WIDTH-1:0] sum,
	);

	if (2 ** (WIDTH - 1) < M) begin
        $error("2 ** (WIDTH - 1) <= M");
	end else if (M <= 0) begin
		$error("M <= 0");
	end

	wire [WIDTH-1:0] csa_modulo_sum_1;
	wire [WIDTH-1:0] csa_modulo_sum_2;
	wire [WIDTH-1:0] modular_sum;
	wire [WIDTH-1:0] regular_sum;

	carry_save_adder #(.WIDTH(WIDTH)) carry_save_adder_inst
	( 
		.a(a),
		.b(b),
		.c(~M+1),
		.sum(csa_modulo_sum_1),
		.carry_out(csa_modulo_sum_2)
	);

	ripple_carry_adder #(.WIDTH(WIDTH)) ripple_carry_adder_inst_1
	( 
		.a(a),
		.b(b),
		.sum(regular_sum),
		.carry_in(1'b0),
		.carry_out()
	);

	ripple_carry_adder #(.WIDTH(WIDTH)) ripple_carry_adder_inst_2
	( 
		.a(csa_modulo_sum_1),
		.b(csa_modulo_sum_2),
		.sum(modular_sum),
		.carry_in(1'b0),
		.carry_out()
	);

	assign sum = (modular_sum[WIDTH-1] == 1'b1) ? regular_sum : modular_sum;
	
endmodule