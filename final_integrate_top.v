module final_integrate_top (
    input  wire clk,
    input  wire rst
);

    // =====================================================
    // IF / IF-ID
    // =====================================================
    wire [31:0] if_instruction;

    if_stage IF (
        .clk(clk),
        .rst(rst),
        .if_instruction(if_instruction)
    );

    wire [31:0] id_instruction;

    if_id_pipeline IF_ID (
        .clk(clk),
        .rst(rst),
        .if_instruction(if_instruction),
        .id_instruction(id_instruction)
    );

    // =====================================================
    // ID STAGE
    // =====================================================
    wire [31:0] id_int_rdata1, id_int_rdata2;
    wire [31:0] id_fp_rdata1,  id_fp_rdata2;
    wire [31:0] id_load_imm,   id_store_imm;
    wire [4:0]  id_rd_addr;

    wire [4:0]  id_falu_opcode;
    wire [1:0]  id_ir_mux;
    wire        id_b_mux, id_mwr;
    wire        id_move_en, id_move_dir;
    wire        id_cvt_en, id_is_unsigned;
    wire        id_wb_sel, id_wb_fp_en, id_wb_int_en;
    wire [2:0]  id_rm;                 // ? rm from decoder

    // WB feedback
    wire [31:0] wb_fp_wdata, wb_int_wdata;
    wire        wb_fp_we, wb_int_we;
    wire [4:0]  wb_waddr;

    id_stage ID (
        .clk(clk),
        .rst(rst),
        .id_instruction(id_instruction),

        .wb_fp_we(wb_fp_we),
        .wb_int_we(wb_int_we),
        .wb_rd_addr(wb_waddr),
        .wb_fp_data(wb_fp_wdata),
        .wb_int_data(wb_int_wdata),

        .int_rdata1(id_int_rdata1),
        .int_rdata2(id_int_rdata2),
        .fp_rdata1(id_fp_rdata1),
        .fp_rdata2(id_fp_rdata2),
        .load_imm(id_load_imm),
        .store_imm(id_store_imm),
        .rd_addr(id_rd_addr),

        .falu_opcode(id_falu_opcode),
        .ir_mux(id_ir_mux),
        .b_mux(id_b_mux),
        .mwr(id_mwr),
        .move_en(id_move_en),
        .move_dir(id_move_dir),
        .cvt_en(id_cvt_en),
        .is_unsigned(id_is_unsigned),
        .wb_sel(id_wb_sel),
        .wb_fp_en(id_wb_fp_en),
        .wb_int_en(id_wb_int_en),
        .rm(id_rm)                 // ? CONNECTED
    );

    // =====================================================
    // ID / EX PIPELINE
    // =====================================================
    wire [31:0] ex_int_rdata1, ex_int_rdata2;
    wire [31:0] ex_fp_rdata1,  ex_fp_rdata2;
    wire [31:0] ex_load_imm,   ex_store_imm;
    wire [4:0]  ex_rd_addr;

    wire [4:0]  ex_falu_opcode;
    wire [1:0]  ex_ir_mux;
    wire        ex_b_mux, ex_mwr;
    wire        ex_move_en, ex_move_dir;
    wire        ex_cvt_en, ex_is_unsigned;
    wire        ex_wb_sel, ex_wb_fp_en, ex_wb_int_en;
    wire [2:0]  ex_rm;                 // ? pipelined rm

    id_ex_pipeline ID_EX (
        .clk(clk),
        .rst(rst),

        .id_int_rdata1(id_int_rdata1),
        .id_int_rdata2(id_int_rdata2),
        .id_fp_rdata1(id_fp_rdata1),
        .id_fp_rdata2(id_fp_rdata2),
        .id_load_imm(id_load_imm),
        .id_store_imm(id_store_imm),
        .id_rd_addr(id_rd_addr),

        .id_falu_opcode(id_falu_opcode),
        .id_ir_mux(id_ir_mux),
        .id_b_mux(id_b_mux),
        .id_mwr(id_mwr),
        .id_move_en(id_move_en),
        .id_move_dir(id_move_dir),
        .id_cvt_en(id_cvt_en),
        .id_is_unsigned(id_is_unsigned),
        .id_wb_sel(id_wb_sel),
        .id_wb_fp_en(id_wb_fp_en),
        .id_wb_int_en(id_wb_int_en),
        .id_rm(id_rm),               // ? CONNECTED

        .ex_int_rdata1(ex_int_rdata1),
        .ex_int_rdata2(ex_int_rdata2),
        .ex_fp_rdata1(ex_fp_rdata1),
        .ex_fp_rdata2(ex_fp_rdata2),
        .ex_load_imm(ex_load_imm),
        .ex_store_imm(ex_store_imm),
        .ex_rd_addr(ex_rd_addr),

        .ex_falu_opcode(ex_falu_opcode),
        .ex_ir_mux(ex_ir_mux),
        .ex_b_mux(ex_b_mux),
        .ex_mwr(ex_mwr),
        .ex_move_en(ex_move_en),
        .ex_move_dir(ex_move_dir),
        .ex_cvt_en(ex_cvt_en),
        .ex_is_unsigned(ex_is_unsigned),
        .ex_wb_sel(ex_wb_sel),
        .ex_wb_fp_en(ex_wb_fp_en),
        .ex_wb_int_en(ex_wb_int_en),
        .ex_rm(ex_rm)                // ? CONNECTED
    );

    // =====================================================
    // EX STAGE
    // =====================================================
    wire [31:0] ex_alu_result;
    wire [31:0] ex_fp_result;
    wire [31:0] ex_mem_address;
    wire [31:0] ex_store_data;

    ex_stage EX (
        .ex_int_rdata1(ex_int_rdata1),
        .ex_int_rdata2(ex_int_rdata2),
        .ex_fp_rdata1(ex_fp_rdata1),
        .ex_fp_rdata2(ex_fp_rdata2),
        .ex_load_imm(ex_load_imm),
        .ex_store_imm(ex_store_imm),
        .ex_falu_opcode(ex_falu_opcode),
        .ex_ir_mux(ex_ir_mux),
        .ex_b_mux(ex_b_mux),
        .ex_move_en(ex_move_en),
        .ex_move_dir(ex_move_dir),
        .ex_cvt_en(ex_cvt_en),
        .ex_is_unsigned(ex_is_unsigned),
        .ex_rm(ex_rm),               // ? CONNECTED
        .clk(clk),

        .alu_result(ex_alu_result),
        .fp_result(ex_fp_result),
        .mem_address(ex_mem_address),
        .store_data(ex_store_data)
    );
    
    // =========================================================
    // MEM STAGE
    // =========================================================
    wire [31:0] mem_load_data;

    mem_stage MEM (
        .clk           (clk),
        .mem_read      (~mem_mwr),
        .mem_write     (mem_mwr),
        .mem_address   (mem_address),
        .store_data    (mem_store_data),
        .load_width    (3'b010),
        .store_width   (3'b010),
        .alu_result    (mem_alu_result),
        .fp_alu_result (mem_fp_result),
        .mem_load_data (mem_load_data),
        .mem_alu_result(),
        .mem_fp_result ()
    );

    // =========================================================
    // MEM / WB PIPELINE
    // =========================================================
    wire [31:0] wb_load_data, wb_alu_result, wb_fp_result;
    wire [1:0]  wb_sel;

    mem_wb_pipeline MEM_WB (
        .clk            (clk),
        .rst            (rst),
        .mem_load_data  (mem_load_data),
        .mem_alu_result (mem_alu_result),
        .mem_fp_result  (mem_fp_result),
        .mem_rd_addr    (mem_rd_addr),
        .mem_wb_sel     (mem_wb_sel),
        .mem_wb_fp_en   (mem_wb_fp_en),
        .mem_wb_int_en  (mem_wb_int_en),

        .wb_load_data   (wb_load_data),
        .wb_alu_result  (wb_alu_result),
        .wb_fp_result   (wb_fp_result),
        .wb_rd_addr     (wb_waddr),
        .wb_wb_sel      (wb_sel),
        .wb_fp_en       (wb_fp_we),
        .wb_int_en      (wb_int_we)
    );

    // =========================================================
    // WB STAGE
    // =========================================================
    fp_writeback WB (
        .clk        (clk),
        .dm_out     (wb_load_data),
        .mov_out    (wb_alu_result),
        .norm_out   (wb_fp_result),
        .wb_sel     (wb_sel),
        .wb_fp_en   (wb_fp_we),
        .wb_int_en  (wb_int_we),
        .fp_wdata   (wb_fp_wdata),
        .int_wdata  (wb_int_wdata)
    );

endmodule

