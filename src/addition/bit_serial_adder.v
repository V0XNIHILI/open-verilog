`ifndef __BIT_SERIAL_ADDER_V__
`define __BIT_SERIAL_ADDER_V__

`include "full_adder.v"

module bit_serial_adder 
    (
        input clk,
        input reset, 
        input a,
        input b, 
        output sum
    );

    reg carry_in;

    wire carry_out;

    full_adder full_adder_inst
    ( 
        .a(a),
        .b(b),
        .carry_in(carry_in),
        .sum(sum),
        .carry_out(carry_out)
    );

    always@(posedge clk)
    begin
        if(reset == 1) begin //active high reset
            carry_in = 1'b0;
        end else begin
            carry_in = carry_out;
        end 
    end

endmodule

`endif
