module floating_point_cpu_top (
    input wire clk,
    input wire rst
);

////////////////////////////////////////////////////////////
// IF STAGE
////////////////////////////////////////////////////////////
wire [31:0] pc, instruction, pc_plus4;

assign pc_plus4 = pc + 32'd4;

pc_block PC (
    .clk(clk),
    .rst(rst),
    .pc(pc)
);

instruction_memory IM (
    .pc(pc),
    .instruction(instruction)
);

////////////////////////////////////////////////////////////
// IF/ID PIPELINE
////////////////////////////////////////////////////////////
wire [31:0] id_instr, id_pc4;

if_id_pipeline IF_ID (
    .clk(clk),
    .rst(rst),
    .pc_plus4_in(pc_plus4),
    .instr_in(instruction),
    .pc_plus4_out(id_pc4),
    .instr_out(id_instr)
);

////////////////////////////////////////////////////////////
// DECODE
////////////////////////////////////////////////////////////
wire [4:0] rs1, rs2, rd, func5, falu_opcode;
wire [6:0] opcode;
wire [31:0] load_imm, store_imm;
wire [2:0] load_width, store_width;

decoder DEC (
    .instruction(id_instr),
    .rs1_addr(rs1),
    .rs2_addr(rs2),
    .rd_addr(rd),
    .falu_opcode(falu_opcode),
    .func5(func5),
    .opcode(opcode),
    .load_imm(load_imm),
    .load_width(load_width),
    .store_width(store_width),
    .store_imm(store_imm),
    .rm(),
    .fmt()
);

////////////////////////////////////////////////////////////
// CONTROL
////////////////////////////////////////////////////////////
wire [1:0] ir_mux, wb_sel;
wire mwr, werf, b_mux;
wire move_en, move_dir, cvt_en, is_unsigned;
wire wb_fp_en, wb_int_en;

control_unit CTRL (
    .opcode(opcode),
    .func5(func5),
    .ir_mux(ir_mux),
    .mwr(mwr),
    .b_mux(b_mux),
    .werf(werf),
    .move_en(move_en),
    .move_dir(move_dir),
    .cvt_en(cvt_en),
    .is_unsigned(is_unsigned),
    .wb_sel(wb_sel[0]),
    .wb_fp_en(wb_fp_en),
    .wb_int_en(wb_int_en)
);

////////////////////////////////////////////////////////////
// REGISTER FILES
////////////////////////////////////////////////////////////
wire [31:0] int_rs1_data, int_rs2_data;
wire [31:0] fp_rs1_data, fp_rs2_data;

wire [31:0] int_wdata, fp_wdata;
wire int_we, fp_we;

int_regfile INT_RF (
    .clk(clk),
    .we(int_we),
    .rs1(rs1),
    .rs2(rs2),
    .write_address(rd),
    .data_in(int_wdata),
    .rdata1(int_rs1_data),
    .rdata2(int_rs2_data)
);

fp_regfile FP_RF (
    .clk(clk),
    .we(fp_we),
    .rs1f(rs1),
    .rs2f(rs2),
    .write_addressf(rd),
    .data_inf(fp_wdata),
    .rdata1f(fp_rs1_data),
    .rdata2f(fp_rs2_data)
);

////////////////////////////////////////////////////////////
// ID/EX PIPELINE
////////////////////////////////////////////////////////////
wire [31:0] ex_int1, ex_fp1, ex_fp2, ex_imm;
wire [4:0]  ex_rd;
wire        ex_mwr, ex_werf, ex_bmux, ex_wbsel;

id_ex_pipeline ID_EX (
    .clk(clk),
    .rst(rst),

    .int_rs1_data_in(int_rs1_data),
    .fp_rs1_data_in(fp_rs1_data),
    .fp_rs2_data_in(fp_rs2_data),
    .imm_in(load_imm),
    .rd_in(rd),

    .werf_in(werf),
    .mwr_in(mwr),
    .b_mux_in(b_mux),
    .ir_mux_in(ir_mux),
    .wb_sel_in(wb_sel[0]),

    .int_rs1_data_out(ex_int1),
    .fp_rs1_data_out(ex_fp1),
    .fp_rs2_data_out(ex_fp2),
    .imm_out(ex_imm),
    .rd_out(ex_rd),

    .werf_out(ex_werf),
    .mwr_out(ex_mwr),
    .b_mux_out(ex_bmux),
    .ir_mux_out(),
    .wb_sel_out(ex_wbsel)
);

////////////////////////////////////////////////////////////
// EXECUTE
////////////////////////////////////////////////////////////
wire [31:0] fp_alu_out;
wire [31:0] mov_fp_out, mov_int_out;

final_top_alu FALU (
    .read_data1(ex_fp1),
    .read_data2(ex_fp2),
    .clk(clk),
    .conv_out(32'd0),
    .rm(3'd0),
    .alu_op_top(falu_opcode),
    .out_alu(fp_alu_out)
);

fp_move_unit MOVE (
    .Fmove_en(move_en),
    .move_dir(move_dir),
    .int_rs1(ex_int1),
    .fp_rs1(ex_fp1),
    .fp_rd(mov_fp_out),
    .int_rd(mov_int_out)
);

////////////////////////////////////////////////////////////
// EX/MEM PIPELINE
////////////////////////////////////////////////////////////
wire [31:0] mem_addr_exmem, mem_data_exmem;
wire [4:0]  mem_rd;
wire        mem_mwr, mem_werf, mem_bmux, mem_wbsel;

ex_mem_pipeline EX_MEM (
    .clk(clk),
    .rst(rst),

    .ex_result_in(fp_alu_out),
    .addr_result_in(ex_imm),
    .rd_in(ex_rd),
    .mwr_in(ex_mwr),
    .werf_in(ex_werf),
    .b_mux_in(ex_bmux),
    .wb_sel_in(ex_wbsel),

    .ex_result_out(mem_data_exmem),
    .addr_result_out(mem_addr_exmem),
    .rd_out(mem_rd),
    .mwr_out(mem_mwr),
    .werf_out(mem_werf),
    .b_mux_out(mem_bmux),
    .wb_sel_out(mem_wbsel)
);

////////////////////////////////////////////////////////////
// MEMORY STAGE
////////////////////////////////////////////////////////////
wire [31:0] mem_rdata, mem_load_data;
wire [31:0] mem_wdata;
wire [3:0]  mem_wstrb;

store_fp_datapath STORE_DP (
    .mem_addr(mem_addr_exmem),
    .rs2_data(ex_fp2),
    .width(store_width),
    .mem_wdata(mem_wdata),
    .mem_wstrb(mem_wstrb)
);

data_memory DM (
    .clk(clk),
    .mem_read(~mem_mwr),
    .mem_write(mem_mwr),
    .addr(mem_addr_exmem),
    .write_data(mem_wdata),
    .mem_wstrb(mem_wstrb),
    .read_data(mem_rdata)
);

load_fp_datapath LOAD_DP (
    .mem_addr(mem_addr_exmem),
    .mem_rdata(mem_rdata),
    .width(load_width),
    .load_data(mem_load_data)
);

////////////////////////////////////////////////////////////
// MEM/WB PIPELINE
////////////////////////////////////////////////////////////
wire [31:0] wb_mem_data, wb_ex_data;
wire        wb_werf_pipe, wb_sel_pipe;

mem_wb_pipeline MEM_WB (
    .clk(clk),
    .rst(rst),

    .mem_data_in(mem_load_data),
    .ex_result_in(mem_data_exmem),
    .rd_in(mem_rd),
    .werf_in(mem_werf),
    .wb_sel_in(mem_wbsel),

    .mem_data_out(wb_mem_data),
    .ex_result_out(wb_ex_data),
    .rd_out(),
    .werf_out(wb_werf_pipe),
    .wb_sel_out(wb_sel_pipe)
);

////////////////////////////////////////////////////////////
// WRITEBACK
////////////////////////////////////////////////////////////
fp_writeback_stage WB (
    .dm_out(wb_mem_data),
    .mov_out(mov_fp_out),
    .norm_out(wb_ex_data),
    .wb_sel({1'b0, wb_sel_pipe}),
    .wb_fp_en(wb_fp_en),
    .wb_int_en(wb_int_en),
    .fp_wdata(fp_wdata),
    .int_wdata(int_wdata),
    .fp_we(fp_we),
    .int_we(int_we)
);

endmodule

