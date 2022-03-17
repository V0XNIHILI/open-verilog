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

    wire initial_gs [WIDTH-2:0];
    wire initial_ps [WIDTH-2:0];

    wire final_gs [WIDTH-1:0];
    wire final_ps [WIDTH-1:0];

    genvar i;
    generate 
        for (i = 0; i < WIDTH; i = i + 1)
            begin
                half_adder half_adder_inst
                ( 
                    .a(a[i]),
                    .b(b[i]),
                    .sum(i == 0 ? final_ps[i] : initial_ps[i-1]),
                    .carry_out(i == 0 ? final_gs[i] : initial_gs[i-1])
                );
            end
    endgenerate

    genvar j;
    generate 
        for (j = 0; j < HEIGHT; j = j + 1) 
            begin: stage
                parameter LEVEL_OFFSET = $rtoi($pow(2, j));
                parameter LEVEL_WIDTH = WIDTH - LEVEL_OFFSET;

                wire intermediate_gs [LEVEL_WIDTH-1:0];
                wire intermediate_ps [LEVEL_WIDTH-1:0];     

                genvar i;
                for (i = 0; i < LEVEL_WIDTH; i = i + 1) 
                begin
                    kogge_stone_cell kogge_stone_cell_inst
                    ( 
                        .p_i(j == 0 ? initial_ps[i+LEVEL_OFFSET-1] : stage[j-1].intermediate_ps[i+LEVEL_OFFSET/2]),
                        .g_i(j == 0 ? initial_gs[i+LEVEL_OFFSET-1] : stage[j-1].intermediate_gs[i+LEVEL_OFFSET/2]),
                        .p_i_prev(j == 0 ? (i == 0 ? final_ps[i] : initial_ps[i+LEVEL_OFFSET-2]) : (i-LEVEL_OFFSET/2 < 0 ? final_ps[i] : stage[j-1].intermediate_ps[i-LEVEL_OFFSET/2])),
                        .g_i_prev(j == 0 ? (i == 0 ? final_gs[i] : initial_gs[i+LEVEL_OFFSET-2]) : (i-LEVEL_OFFSET/2 < 0 ? final_gs[i] : stage[j-1].intermediate_gs[i-LEVEL_OFFSET/2])),
                        .p(j == HEIGHT - 1 ? final_ps[i+LEVEL_OFFSET] : (i - LEVEL_OFFSET < 0 ? final_ps[i+LEVEL_OFFSET] : intermediate_ps[i])),
                        .g(j == HEIGHT - 1 ? final_gs[i+LEVEL_OFFSET] : (i - LEVEL_OFFSET < 0 ? final_gs[i+LEVEL_OFFSET]: intermediate_gs[i]))
                    );
                end
            end
    endgenerate

    assign sum[0] = final_ps[0]; // Same as  initial_ps[0] ^ 0. No carry in is assumed

    genvar i;
    generate 
        for (i = 1; i < WIDTH; i = i + 1) 
            begin
                assign sum[i] = initial_ps[i-1] ^ final_gs[i-1];
            end
    endgenerate

    assign carry_out = final_gs[WIDTH-1];
    
endmodule