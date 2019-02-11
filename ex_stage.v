module ex_stage (
    // ===== DATA from ID/EX =====
    input  wire [31:0] ex_int_rdata1,
    input  wire [31:0] ex_int_rdata2,
    input  wire [31:0] ex_fp_rdata1,
    input  wire [31:0] ex_fp_rdata2,
    input  wire [31:0] ex_load_imm,
    input  wire [31:0] ex_store_imm,
    input  wire [31:0] ex_pc_plus4,
    input  wire [4:0]  ex_rd_addr,

    // ===== CONTROL =====
    input  wire [4:0]  ex_falu_opcode,
    input  wire [1:0]  ex_ir_mux,
    input  wire        ex_b_mux,
    input  wire        ex_move_en,
    input  wire        ex_move_dir,
    input  wire        ex_cvt_en,
    input  wire        ex_is_unsigned,
    input  wire        ex_wb_sel,
    input  wire        ex_wb_fp_en,
    input  wire        ex_wb_int_en,
    input  wire [2:0]  rm,
    input  wire        clk,

    // ===== OUTPUTS to EX/MEM =====
    output wire [31:0] alu_result,
    output wire [31:0] store_data,
    output wire [4:0]  rd_out,

    // Control forward
    output wire        wb_sel_out,
    output wire        wb_fp_en_out,
    output wire        wb_int_en_out
);

    // -------------------------------
    // Address calculation (INT ALU)
    // -------------------------------
    wire [31:0] addr_calc;

    ripplecarryadder_32bit addr_adder (
        .a   (ex_int_rdata1),
        .b   (ex_load_imm),
        .cin (1'b0),
        .sum (addr_calc)
    );

    // -------------------------------
    // FP ALU
    // -------------------------------
    wire [31:0] fp_alu_out;

    final_top_alu fp_alu (
        .read_data1 (ex_fp_rdata1),
        .read_data2 (ex_fp_rdata2),
        .clk        (clk),
        .conv_out   (32'b0),
        .rm         (rm),
        .alu_op_top (ex_falu_opcode),
        .out_alu    (fp_alu_out)
    );

    // -------------------------------
    // MOVE unit
    // -------------------------------
    wire [31:0] move_fp_out, move_int_out;

    fp_move_unit move_unit (
        .Fmove_en (ex_move_en),
        .move_dir (ex_move_dir),
        .int_rs1  (ex_int_rdata1),
        .fp_rs1   (ex_fp_rdata1),
        .fp_rd    (move_fp_out),
        .int_rd   (move_int_out)
    );

    // -------------------------------
    // CONVERSION unit
    // -------------------------------
    wire [31:0] conv_out;

    int_float_cvt cvt_unit (
        .cvt_en      (ex_cvt_en),
        .wb_fp_en    (ex_wb_fp_en),
        .wb_int_en   (ex_wb_int_en),
        .is_unsigned (ex_is_unsigned),
        .rs1         (ex_fp_rdata1),
        .rd          (conv_out)
    );

    // -------------------------------
    // FINAL RESULT MUX
    // -------------------------------
    assign alu_result =
        ex_move_en ? (ex_wb_fp_en ? move_fp_out : move_int_out) :
        ex_cvt_en  ? conv_out :
        ex_ir_mux == 2'b01 ? addr_calc :   // load/store
        fp_alu_out;

    assign store_data = ex_fp_rdata2;
    assign rd_out     = ex_rd_addr;

    // Forward WB control
    assign wb_sel_out     = ex_wb_sel;
    assign wb_fp_en_out  = ex_wb_fp_en;
    assign wb_int_en_out = ex_wb_int_en;

endmodule

