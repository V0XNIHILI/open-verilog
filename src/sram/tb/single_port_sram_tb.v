`include "single_port_sram.v"

module single_port_sram_tb;
    parameter WIDTH = 32;
    parameter DEPTH = 16;
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
    
    single_port_sram #(.WIDTH(WIDTH), .DEPTH(DEPTH)) single_port_sram_inst
    (
        .clk(clk),
        .address(address),
        .data(data),
        .chip_select(cs),
        .write_enable(we),
        .output_enable(oe)
    );

    initial begin
        $dumpfile("single_port_sram_tb.vcd");
        $dumpvars(0,clk,data,address,cs,we,oe);
    end

    assign data = !oe ? data_reg : 'hz;

    initial begin
        repeat (1) @ (posedge clk);

        // Write random numbers to the SRAM
        for (integer i = 0; i < DEPTH; i = i + 1) begin
            repeat (1) @ (posedge clk) address <= i; we <= 1; cs <= 1; oe <= 0; data_reg <= random_numbers[i];
        end

        // Try to write zeros to the SRAM while chip select is low.
        for (integer i = 0; i < DEPTH; i = i + 1) begin
            repeat (1) @ (posedge clk) address <= i; we <= 1; cs <= 0; oe <= 0; data_reg <= 0;
        end

        // Check that the SRAM still contains the random numbers.
        for (integer i = 0; i < DEPTH + 2; i = i + 1) begin
            if (i < DEPTH) begin
                repeat (1) @ (posedge clk) address <= i; we <= 0; cs <= 1; oe <= 1;
            end else begin
                repeat (1) @ (posedge clk);
            end

            if (i >= 2)
                print_if_failed(random_numbers[i-2], data);
        end

        // Try to write zeros to the SRAM while write enable is low
        for (integer i = 0; i < DEPTH; i = i + 1) begin
            repeat (1) @ (posedge clk) address <= i; we <= 0; cs <= 1; oe <= 0; data_reg <= 0;
        end

        // Check if the original random numbers are still there.
        for (integer i = 0; i < DEPTH + 2; i = i + 1) begin
            if (i < DEPTH) begin
                repeat (1) @ (posedge clk) address <= i; we <= 0; cs <= 1; oe <= 1;
            end else begin
                repeat (1) @ (posedge clk);
            end

            if (i >= 2)
                print_if_failed(random_numbers[i-2], data);
        end

        // Check that read out values are 0 when output enable is low (due to assign data statement in this file)
        for (integer i = 0; i < DEPTH + 2; i = i + 1) begin
            if (i < DEPTH) begin
                repeat (1) @ (posedge clk) address <= i; we <= 0; cs <= 1; oe <= 0;
            end else begin
                repeat (1) @ (posedge clk);
            end

            if (i >= 2)
                print_if_failed(0, data);
        end

        $finish;
    end

endmodule