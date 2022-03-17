`include "inh.v"

module imp
    (
        input  a,
        input  b,
        output z
    );

    wire z_temp;

    inh inh_inst
    (
        .a(a),
        .b(b),
        .z(z_temp)
    );

    assign z = ~z_temp;

endmodule