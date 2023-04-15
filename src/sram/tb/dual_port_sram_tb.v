`include "dual_port_sram.v"

module dual_port_sram_tb;
    localparam WIDTH = 32;
    localparam DEPTH = 16;
    localparam ADDR_WIDTH = $clog2(DEPTH);

    /* Make a regular pulsing clock. */
    reg clk = 0;
    always #5 clk = !clk;

    wire [WIDTH-1:0] read_data;
    reg [WIDTH-1:0] write_data;

    reg [ADDR_WIDTH-1:0] read_address = 0;
    reg [ADDR_WIDTH-1:0] write_address = 0;

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

    task check_data_present;
        input local_we;
        input local_cs;
        input local_oe;
        begin
            // Check if the original random numbers are still there.
            for (integer i = 0; i < DEPTH + 2; i = i + 1) begin
                if (i < DEPTH) begin
                    repeat (1) @ (posedge clk) read_address <= i;  we <= local_we; cs <= local_cs; oe <= local_oe;
                end else begin
                    repeat (1) @ (posedge clk);
                end

                if (i >= 2)
                    print_if_failed(random_numbers[i-2], read_data);
            end
        end
    endtask

    initial begin
        $dumpfile("dual_port_sram_tb.vcd");
        $dumpvars(0,clk,read_data,write_data,read_address,write_address,cs,we,oe);
    end
    
    dual_port_sram #(.WIDTH(WIDTH), .DEPTH(DEPTH)) dual_port_sram
    (
        .clk(clk),
        .read_address(read_address),
        .write_address(write_address),
        .read_data(read_data),
        .write_data(write_data),
        .chip_select(cs),
        .write_enable(we),
        .output_enable(oe)
    );

    initial begin
        repeat (1) @ (posedge clk);

        // Test writing and reading from the same address.
        // Write random numbers to the SRAM
        for (integer i = 0; i < DEPTH; i = i + 1) begin
            repeat (1) @ (posedge clk) read_address <= i; write_address <= i; we <= 1; cs <= 1; oe <= 1; write_data <= random_numbers[i];
        end

        check_data_present(0, 1, 1);

        $finish;
    end

endmodule