`ifndef  __SINGLE_PORT_SRAM_V__
`define  __SINGLE_PORT_SRAM_V__

// Based on: https://www.chipverify.com/verilog/verilog-single-port-ram

module single_port_sram
    #(parameter WIDTH = 32, parameter DEPTH = 16, parameter ADDR_WIDTH = $clog2(DEPTH))
    (
        input clk,
        input [ADDR_WIDTH-1:0] address,
        inout [WIDTH-1:0] data,
        input chip_select,
        input write_enable,
        input output_enable
    );

    reg [WIDTH-1:0] memory [DEPTH-1:0];
    reg [WIDTH-1:0] tmp_data;

    always @(posedge clk) begin
        if (chip_select)
        begin
            if (write_enable)
                memory[address] <= data;
            else if (!write_enable)
                tmp_data <= memory[address];
        end
    end

    assign data = chip_select & output_enable & !write_enable ? tmp_data : 'hz;

endmodule

`endif
