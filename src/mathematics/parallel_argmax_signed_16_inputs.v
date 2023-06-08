module parallel_argmax_signed_16_inputs
    #(parameter WIDTH = 8)
    (
        input signed [WIDTH-1:0] in [16-1:0],
        output signed [WIDTH-1:0] max,
        output [4-1:0] argmax
    );

	wire signed [WIDTH-1:0] layer_0 [8-1:0];
    wire [4-1:0] layer_0_indices [8-1:0];

    assign layer_0_indices[0] = (in[0] > in[1]) ? 0 : 1;
    assign layer_0_indices[1] = (in[2] > in[3]) ? 2 : 3;
    assign layer_0_indices[2] = (in[4] > in[5]) ? 4 : 5;
    assign layer_0_indices[3] = (in[6] > in[7]) ? 6 : 7;
    assign layer_0_indices[4] = (in[8] > in[9]) ? 8 : 9;
    assign layer_0_indices[5] = (in[10] > in[11]) ? 10 : 11;
    assign layer_0_indices[6] = (in[12] > in[13]) ? 12 : 13;
    assign layer_0_indices[7] = (in[14] > in[15]) ? 14 : 15;

    genvar i0;
    generate 
        for (i0 = 0; i0 < 8; i0 = i0 + 1) begin
            assign layer_0[i0] = in[layer_0_indices[i0]];
        end
    endgenerate

	wire signed [WIDTH-1:0] layer_1 [4-1:0];
    wire [4-1:0] layer_1_indices [4-1:0];
    wire [4-1:0] larger_thans_1;

    assign larger_thans_1[0] = (layer_0[0] > layer_0[1]) ? 1 : 0;
    assign larger_thans_1[1] = (layer_0[2] > layer_0[3]) ? 1 : 0;
    assign larger_thans_1[2] = (layer_0[4] > layer_0[5]) ? 1 : 0;
    assign larger_thans_1[3] = (layer_0[6] > layer_0[7]) ? 1 : 0;

    assign layer_1_indices[0] = larger_thans_1[0] ? layer_0_indices[0] : layer_0_indices[1];
    assign layer_1_indices[1] = larger_thans_1[1] ? layer_0_indices[2] : layer_0_indices[3];
    assign layer_1_indices[2] = larger_thans_1[2] ? layer_0_indices[4] : layer_0_indices[5];
    assign layer_1_indices[3] = larger_thans_1[3] ? layer_0_indices[6] : layer_0_indices[7];

    assign layer_1[0] = larger_thans_1[0] ? layer_0[0] : layer_0[1];
    assign layer_1[1] = larger_thans_1[1] ? layer_0[2] : layer_0[3];
    assign layer_1[2] = larger_thans_1[2] ? layer_0[4] : layer_0[5];
    assign layer_1[3] = larger_thans_1[3] ? layer_0[6] : layer_0[7];

	wire signed [WIDTH-1:0] layer_2 [2-1:0];
    wire [4-1:0] layer_2_indices [2-1:0];
    wire [2-1:0] larger_thans_2;

    assign larger_thans_2[0] = (layer_1[0] > layer_1[1]) ? 1 : 0;
    assign larger_thans_2[1] = (layer_1[2] > layer_1[3]) ? 1 : 0;

    assign layer_2_indices[0] = larger_thans_2[0] ? layer_1_indices[0] : layer_1_indices[1];
    assign layer_2_indices[1] = larger_thans_2[1] ? layer_1_indices[2] : layer_1_indices[3];

    assign layer_2[0] = larger_thans_2[0] ? layer_1[0] : layer_1[1];
    assign layer_2[1] = larger_thans_2[1] ? layer_1[2] : layer_1[3];

	wire signed [WIDTH-1:0] layer_3 [1-1:0];
    wire [4-1:0] layer_3_indices [1-1:0];
    wire [1-1:0] larger_thans_3;

    assign larger_thans_3[0] = (layer_2[0] > layer_2[1]) ? 1 : 0;

    assign layer_3_indices[0] = larger_thans_3[0] ? layer_2_indices[0] : layer_2_indices[1];

    assign layer_3[0] = larger_thans_3[0] ? layer_2[0] : layer_2[1];

	assign max = layer_3[0];
    assign argmax = layer_3_indices[0];

endmodule
