module id_stage (
    input  wire        clk,
    input  wire        rst,

    // From IF/ID pipeline
    input  wire [31:0] id_instruction,
    input  wire [31:0] id_pc_plus4,

    // From WB stage (later)
    input  wire        wb_fp_we,
    input  wire        wb_int_we,
    input  wire [4:0]  wb_rd_addr,
    input  wire [31:0] wb_fp_data,
    input  wire [31:0] wb_int_data,

    // Outputs to ID/EX pipeline (DATA)
    output wire [31:0] int_rdata1,
    output wire [31:0] int_rdata2,
    output wire [31:0] fp_rdata1,
    output wire [31:0] fp_rdata2,
    output wire [31:0] load_imm,
    output wire [31:0] store_imm,
    output wire [31:0] pc_plus4,
    output wire [4:0]  rd_addr,

    // Outputs to ID/EX pipeline (CONTROL)
    output wire [4:0]  falu_opcode,
    output wire [1:0]  ir_mux,
    output wire        b_mux,
    output wire        mwr,
    output wire        move_en,
    output wire        move_dir,
    output wire        cvt_en,
    output wire        is_unsigned,
    output wire        wb_sel,
    output wire        wb_fp_en,
    output wire        wb_int_en,
    output wire [2:0] rm
);

    // Internal wires
    wire [4:0] rs1_addr, rs2_addr;
    wire [6:0] opcode;
    wire [4:0] func5;

    assign pc_plus4 = id_pc_plus4;

    // ================= DECODER =================
    decoder dec (
        .instruction(id_instruction),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(rd_addr),
        .falu_opcode(falu_opcode),
        .func5(func5),
        .opcode(opcode),
        .load_imm(load_imm),
        .load_width(),
        .store_width(),
        .store_imm(store_imm),
        .rm(rm),
        .fmt()
    );

    // ================= CONTROL UNIT =================
    control_unit cu (
        .opcode(opcode),
        .func5(func5),
        .ir_mux(ir_mux),
        .mwr(mwr),
        .b_mux(b_mux),
        .werf(),   // not needed directly here
        .move_en(move_en),
        .move_dir(move_dir),
        .cvt_en(cvt_en),
        .is_unsigned(is_unsigned),
        .wb_sel(wb_sel),
        .wb_fp_en(wb_fp_en),
        .wb_int_en(wb_int_en)
    );

    // ================= INTEGER REGISTER FILE =================
    int_regfile int_rf (
        .clk(clk),
        .we(wb_int_we),
        .rs1(rs1_addr),
        .rs2(rs2_addr),
        .write_address(wb_rd_addr),
        .data_in(wb_int_data),
        .rdata1(int_rdata1),
        .rdata2(int_rdata2)
    );

    // ================= FLOAT REGISTER FILE =================
    fp_regfile fp_rf (
        .clk(clk),
        .we(wb_fp_we),
        .rs1f(rs1_addr),
        .rs2f(rs2_addr),
        .write_addressf(wb_rd_addr),
        .data_inf(wb_fp_data),
        .rdata1f(fp_rdata1),
        .rdata2f(fp_rdata2)
    );

endmodule









