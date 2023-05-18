`include "adder_tree_signed_16_inputs_po.v"

module adder_tree_signed_16_inputs_po_tb;
    localparam WIDTH = 4;
    localparam N_INPUTS = 16;

    reg signed [WIDTH-1:0] in [N_INPUTS-1:0];
    wire signed [$clog2(N_INPUTS)+WIDTH-1:0] out;

    adder_tree_signed_16_inputs_po #(.WIDTH(WIDTH)) adder_tree_signed_16_inputs_po_inst
    (
        .in(in),
        .out(out)
    );

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

    initial
    begin
        $dumpfile("adder_tree_tb.vcd");
        $dumpvars(0,out);
    end

    initial begin
        // We input the numbers 0,1...6,7 and -8,-7...-1 -> sum = -8
        // For example, 13 = 1101 in binary, in 2s complement that is -3
        for (integer i = 0; i < N_INPUTS; i = i + 1) begin
            in[i] = i;
            # 1;
        end
        
        print_if_failed(-8, out);
        #1;

        // 16 * -8 = -128
        for (integer i = 0; i < N_INPUTS; i = i + 1) begin
            // 8 is -8 in 2s complement with 4 bits
            in[i] = 8;
            # 1;
        end

        print_if_failed(-128, out);
        #1;

        // Inputs 0s only
        for (integer i = 0; i < N_INPUTS; i = i + 1) begin
            in[i] = 0;
            # 1;
        end

        print_if_failed(0, out);
        #1;

        $finish;
    end
endmodule