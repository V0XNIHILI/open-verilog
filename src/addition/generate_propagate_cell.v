`ifndef __GENERATE_PROPAGATE_CELL_V__
`define __GENERATE_PROPAGATE_CELL_V__

module generate_propagate_cell
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

`endif
