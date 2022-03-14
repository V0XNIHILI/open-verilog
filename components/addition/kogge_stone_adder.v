`include "half_adder.v"

module kogge_stone_cell
    (
        input p_i,
        input g_i,
        input p_i_prev,
        input g_i_prev,
        output p,
        output g
    );
    
    assign p = p_i & p_i_prev;
    assign g = (p_i & g_i_prev) | g_i;
    
endmodule

module kogge_stone_adder
    #(parameter WIDTH = 8)
    (
        input [WIDTH-1:0] a,
        input [WIDTH-1:0] b,
        output [WIDTH-1:0] sum,
        output carry_out
    );

    parameter HEIGHT = $clog2(WIDTH);

    wire intermediate_gs [HEIGHT+1:0] [WIDTH-1:0];
    wire intermediate_ps [HEIGHT+1:0] [WIDTH-1:0];

    genvar i;
    generate 
        for (i = 0; i < WIDTH; i = i + 1) 
            begin
                half_adder half_adder_inst
                ( 
                    .a(a[i]),
                    .b(b[i]),
                    .sum(intermediate_ps[0][i]),
                    .carry_out(intermediate_ps[0][i])
                );
            end
    endgenerate

    genvar j;
    generate 
        for (j = 0; j < HEIGHT; j = j + 1) 
            begin
                parameter LEVEL_WIDTH = $pow(2, j);

                genvar i;
                for (i = 0; i < WIDTH; i = i + 1) 
                begin
                    if (i < LEVEL_WIDTH) begin
                        assign intermediate_ps[j+1][i] = intermediate_ps[j][i];
                        assign intermediate_gs[j+1][i] = intermediate_gs[j][i];
                    end else
                        kogge_stone_cell kogge_stone_cell_inst
                        ( 
                            .p_i(intermediate_ps[j][i]),
                            .g_i(intermediate_gs[j][i]),
                            .p_i_prev(intermediate_ps[j][i-1]),
                            .g_i_prev(intermediate_gs[j][i-1]),
                            .p(intermediate_ps[j+1][i]),
                            .g(intermediate_gs[j+1][i])
                        );
                end
            end
    endgenerate

    assign sum[0] = intermediate_ps[0][0] ^ 0; // No carry in is assumed

    genvar i;
    generate 
        for (i = 1; i < WIDTH; i = i + 1) 
            begin
                assign sum[i] = intermediate_ps[HEIGHT][i] ^ intermediate_gs[0][i-1];
            end
    endgenerate

    assign carry_out = intermediate_gs[0][WIDTH-1];
    
endmodule