`include "single_port_sram.v"

module single_port_sram_tb;
    localparam WIDTH = 32;
    localparam DEPTH = 16;
    localparam ADDR_WIDTH = $clog2(DEPTH);

    /* Make a regular pulsing clock. */
    reg clk = 0;
    always #5 clk = !clk;

    wire [WIDTH-1:0] data;
    reg [WIDTH-1:0] data_reg;
    reg [ADDR_WIDTH-1:0] address = 0;

    // Prepare list of random numbers to write to the SRAM.
    reg [WIDTH-1:0] random_numbers [DEPTH-1:0];
    initial begin
        for (integer i = 0; i < DEPTH; i = i + 1) begin
            random_numbers[i] = $random;
        end
    end

    reg cs = 0;
    reg we = 0;
    reg oe = 0;

    task print_if_failed;
        input integer expected;
        input integer actual;
        begin
            if (actual !== expected) begin
                $display("Failed. Expected: %d, actual: %d", expected, actual);
                $stop;
            end
        end
    endtask

    task fill_sram;
        input local_we;
        input local_cs;
        input local_oe;
        input write_zeros;
        begin
            for (integer i = 0; i < DEPTH; i = i + 1) begin
                repeat (1) @ (posedge clk) address <= i; we <= local_we; cs <= local_cs; oe <= local_oe; data_reg <= write_zeros ? 0 : random_numbers[i];
            end
        end
    endtask

    task check_data_present;
        input local_we;
        input local_cs;
        input local_oe;
        begin
            // Check if the original random numbers are still there.
            for (integer i = 0; i < DEPTH + 2; i = i + 1) begin
                if (i < DEPTH) begin
                    repeat (1) @ (posedge clk) address <= i;  we <= local_we; cs <= local_cs; oe <= local_oe;
                end else begin
                    repeat (1) @ (posedge clk);
                end

                if (i >= 2)
                    print_if_failed(local_oe ? random_numbers[i-2] : data_reg, data);
            end
        end
    endtask

    initial begin
        $dumpfile("single_port_sram_tb.vcd");
        $dumpvars(0,clk,data,address,cs,we,oe);
    end
    
    single_port_sram #(.WIDTH(WIDTH), .DEPTH(DEPTH)) single_port_sram_inst
    (
        .clk(clk),
        .address(address),
        .data(data),
        .chip_select(cs),
        .write_enable(we),
        .output_enable(oe)
    );

    assign data = !oe ? data_reg : 'hz;

    initial begin
        repeat (1) @ (posedge clk);

        // Write random numbers to the SRAM
        fill_sram(1, 1, 0, 0);

        // Try to write zeros to the SRAM while chip select is low.
        fill_sram(1, 0, 0, 1);

        // Check that the SRAM still contains the random numbers.
        check_data_present(0, 1, 1);

        // Try to write zeros to the SRAM while write enable is low
        fill_sram(0, 1, 0, 1);

        // Check if the original random numbers are still there.
        check_data_present(0, 1, 1);

        // Check that read out values are 0 when output enable is low (due to assign data statement in this file)
        check_data_present(0, 1, 0);

        $finish;
    end

endmodule