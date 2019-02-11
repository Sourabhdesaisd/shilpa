module top_with_conv(
    input        cvt_en,
    input        is_unsigned,
    input [31:0] fp_rs1,
    input [31:0] read_data1,
    input [31:0] read_data2,
    input [4:0]  alu_op_top,
    input        clk,
    output [31:0] out_alu1,
    input [2:0]  rm
);

    wire [31:0] conv_out_w;

    // Float to int conversion block
    float_to_int_cvt coner(
        .cvt_en(cvt_en),
        .is_unsigned(is_unsigned),
        .fp_rs1(fp_rs1),
        .int_rd(conv_out_w)
    );

    // Final ALU (enable pin removed)

    final_top_alu alu (
        .read_data1(read_data1),
        .read_data2(read_data2),
        .out_alu(out_alu1),
        .alu_op_top(alu_op_top),
        .clk(clk),
        .rm(rm),
        .conv_out(conv_out_w)
    );

endmodule

