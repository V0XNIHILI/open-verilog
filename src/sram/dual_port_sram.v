`ifndef  __DUAL_PORT_SRAM_V__
`define  __DUAL_PORT_SRAM_V__

// Based on: https://www.chipverify.com/verilog/verilog-single-port-ram

module dual_port_sram
    #(parameter WIDTH = 2, parameter DEPTH = 3)
    (
        input clk,
        input [ADDR_WIDTH-1:0] read_address,
        input [ADDR_WIDTH-1:0] write_address,
        output [WIDTH-1:0] read_data,
        input [WIDTH-1:0] write_data,
        input chip_select,
        input write_enable,
        input output_enable
    );

    localparam ADDR_WIDTH = $clog2(DEPTH);

    reg [WIDTH-1:0] memory [DEPTH-1:0];
    reg [WIDTH-1:0] tmp_data;

    reg write_after_bypass = 0;
    reg [ADDR_WIDTH-1:0] write_after_bypass_address;

    always @(posedge clk) begin
        if (write_after_bypass) begin
            memory[write_after_bypass_address] = tmp_data;
            write_after_bypass = 0;
        end

        if (chip_select) begin
            if (write_enable & output_enable & (read_address == write_address)) begin
                tmp_data <= write_data;
                write_after_bypass = 1;
                write_after_bypass_address <= write_address;
            end else begin
                if (write_enable)
                    memory[write_address] <= write_data;
                
                if (output_enable)
                    tmp_data <= memory[read_address];
            end
        end
    end

    assign read_data = (chip_select & output_enable) ? tmp_data : 'hz;

endmodule

`endif