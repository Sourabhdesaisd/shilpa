module final_top_alu(
    input  [31:0] read_data1,
    input  [31:0] read_data2,
    input         clk,
    input  [31:0] conv_out,
    input  [2:0]  rm,
    input  [4:0]  alu_op_top,
    output [31:0] out_alu
);

wire [31:0] out_alu_w;

/* ALU */
top_alu alu (
    .read_data1 (read_data1),
    .read_data2 (read_data2),
    .out_alu    (out_alu_w),
    .alu_op_top (alu_op_top),
    .clk        (clk),
    .conv_out   (conv_out)
);

/* Normalize + Round */
fp_normalize_round_32bit normal (
    .alu_out (out_alu_w),
    .rm      (rm),
    .alu_op  (alu_op_top),
    .fp_out  (out_alu)
);
endmodule




