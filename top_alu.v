module top_alu(
    input  [31:0] read_data1,
    input  [31:0] read_data2,
    input         clk,
    input  [4:0]  alu_op_top,
    input  [31:0] conv_out,
    output [31:0] out_alu
);

wire [31:0] add_out_w;
wire [31:0] sub_out_w;
wire [31:0] mul_out_w;
wire [31:0] div_out_w;
wire [31:0] sqt_out_w;
wire [31:0] min_out_w;
wire [31:0] max_out_w;
wire [31:0] lessthan_out_w;
wire [31:0] equal_out_w;
wire [31:0] lessthan_eq_w;
wire [31:0] conv_out_w;

/* Floating ADD */
float_add add (
    .operand_A(read_data1),
    .operand_B(read_data2),
    .add_res(add_out_w)
);

/* Floating SUB */
float_sub sub (
    .operand_A(read_data1),
    .operand_B(read_data2),
    .sub_res(sub_out_w)
);

/* Floating MUL */
floatingmultiplication mul (
    .A(read_data1),
    .B(read_data2),
    .result(mul_out_w)
);

/* Floating DIV */
FloatingDivision div (
    .A(read_data1),
    .B(read_data2),
    .clk(clk),
    .result(div_out_w)
);

/* Floating SQRT */
FloatingSqrt sqrt (
    .clk(clk),
    .A(read_data1),
    .result(sqt_out_w)
);

/* Floating MAX */
fmax max (
    .read_data1(read_data1),
    .read_data2(read_data2),
    .maxdata_out(max_out_w)
);

/* Floating MIN */
fmin min (
    .read_data1(read_data1),
    .read_data2(read_data2),
    .mindata_out(min_out_w)
);

/* Floating EQUAL */
Feq equal (
    .read_data1(read_data1),
    .read_data2(read_data2),
    .eqdata_out(equal_out_w)
);

/* Floating LESS THAN */
Flt less_than (
    .read_data1(read_data1),
    .read_data2(read_data2),
    .ltdata_out(lessthan_out_w)
);

/* Floating LESS OR EQUAL */
Fleq less_or_equal (
    .read_data1(read_data1),
    .read_data2(read_data2),
    .leqdata_out(lessthan_eq_w)
);

/* ALU Output MUX */
float_conv_mux alu_mux (
    .add_out(add_out_w),
    .sub_out(sub_out_w),
    .mul_out(mul_out_w),
    .div_out(div_out_w),
    .sqt_out(sqt_out_w),
    .min_out(min_out_w),
    .max_out(max_out_w),
    .lessthan_out(lessthan_out_w),
    .equal_out(equal_out_w),
    .lessthan_eq_out(lessthan_eq_w),
    .conv_out(conv_out_w),
    .alu_op(alu_op_top),
    .float_out(out_alu)
);

endmodule

