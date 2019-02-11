/*module id_ex_pipeline (
    input  wire        clk,
    input  wire        rst,

    input  wire [31:0] int_rs1_data_in,
    input  wire [31:0] fp_rs1_data_in,
    input  wire [31:0] fp_rs2_data_in,
    input  wire [31:0] imm_in,
    input  wire [4:0]  rd_in,

    input  wire        werf_in,
    input  wire        mwr_in,
    input  wire        b_mux_in,
    input  wire [1:0]  ir_mux_in,
    input  wire wb_sel_in,
    

    output reg  [31:0] int_rs1_data_out,
    output reg  [31:0] fp_rs1_data_out,
    output reg  [31:0] fp_rs2_data_out,
    output reg  [31:0] imm_out,
    output reg  [4:0]  rd_out,

    output reg         werf_out,
    output reg         mwr_out,
    output reg         b_mux_out,
    output reg  [1:0]  ir_mux_out,
    output reg  wb_sel_out
    
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            int_rs1_data_out <= 32'd0;
            fp_rs1_data_out  <= 32'd0;
            fp_rs2_data_out  <= 32'd0;
            imm_out          <= 32'd0;
            rd_out           <= 5'd0;
            werf_out         <= 1'b0;
            mwr_out          <= 1'b0;
            b_mux_out        <= 1'b0;
            ir_mux_out       <= 2'b0;
            wb_sel_out <= 1'b0;
            
        end else begin
            int_rs1_data_out <= int_rs1_data_in;
            fp_rs1_data_out  <= fp_rs1_data_in;
            fp_rs2_data_out  <= fp_rs2_data_in;
            imm_out          <= imm_in;
            rd_out           <= rd_in;
            werf_out         <= werf_in;
            mwr_out          <= mwr_in;
            b_mux_out        <= b_mux_in;
            ir_mux_out       <= ir_mux_in;
            wb_sel_out <= wb_sel_in;
            
        end
    end

endmodule*/

/////////////////////////////////////////////////////////////////////////

module id_ex_pipeline (
    input  wire        clk,
    input  wire        rst,

    // ===== DATA from ID stage =====
    input  wire [31:0] id_int_rdata1,
    input  wire [31:0] id_int_rdata2,
    input  wire [31:0] id_fp_rdata1,
    input  wire [31:0] id_fp_rdata2,
    input  wire [31:0] id_load_imm,
    input  wire [31:0] id_store_imm,
    input  wire [31:0] id_pc_plus4,
    input  wire [4:0]  id_rd_addr,

    // ===== CONTROL from ID stage =====
    input  wire [4:0]  id_falu_opcode,
    input  wire [1:0]  id_ir_mux,
    input  wire        id_b_mux,
    input  wire        id_mwr,
    input  wire        id_move_en,
    input  wire        id_move_dir,
    input  wire        id_cvt_en,
    input  wire        id_is_unsigned,
    input  wire        id_wb_sel,
    input  wire        id_wb_fp_en,
    input  wire        id_wb_int_en,
    input  wire [2:0]  id_rm,

    // ===== OUTPUTS to EX stage =====
    output reg [31:0] ex_int_rdata1,
    output reg [31:0] ex_int_rdata2,
    output reg [31:0] ex_fp_rdata1,
    output reg [31:0] ex_fp_rdata2,
    output reg [31:0] ex_load_imm,
    output reg [31:0] ex_store_imm,
    output reg [31:0] ex_pc_plus4,
    output reg [4:0]  ex_rd_addr,

    output reg [4:0]  ex_falu_opcode,
    output reg [1:0]  ex_ir_mux,
    output reg        ex_b_mux,
    output reg        ex_mwr,
    output reg        ex_move_en,
    output reg        ex_move_dir,
    output reg        ex_cvt_en,
    output reg        ex_is_unsigned,
    output reg        ex_wb_sel,
    output reg        ex_wb_fp_en,
    output reg        ex_wb_int_en,
    output reg [2:0]  ex_rm
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        ex_int_rdata1 <= 0;
        ex_int_rdata2 <= 0;
        ex_fp_rdata1  <= 0;
        ex_fp_rdata2  <= 0;
        ex_load_imm   <= 0;
        ex_store_imm  <= 0;
        ex_pc_plus4   <= 0;
        ex_rd_addr    <= 0;

        ex_falu_opcode <= 0;
        ex_ir_mux      <= 0;
        ex_b_mux       <= 0;
        ex_mwr         <= 0;
        ex_move_en     <= 0;
        ex_move_dir    <= 0;
        ex_cvt_en      <= 0;
        ex_is_unsigned <= 0;
        ex_wb_sel      <= 0;
        ex_wb_fp_en    <= 0;
        ex_wb_int_en   <= 0;
    end else begin
        ex_int_rdata1 <= id_int_rdata1;
        ex_int_rdata2 <= id_int_rdata2;
        ex_fp_rdata1  <= id_fp_rdata1;
        ex_fp_rdata2  <= id_fp_rdata2;
        ex_load_imm   <= id_load_imm;
        ex_store_imm  <= id_store_imm;
        ex_pc_plus4   <= id_pc_plus4;
        ex_rd_addr    <= id_rd_addr;

        ex_falu_opcode <= id_falu_opcode;
        ex_ir_mux      <= id_ir_mux;
        ex_b_mux       <= id_b_mux;
        ex_mwr         <= id_mwr;
        ex_move_en     <= id_move_en;
        ex_move_dir    <= id_move_dir;
        ex_cvt_en      <= id_cvt_en;
        ex_is_unsigned <= id_is_unsigned;
        ex_wb_sel      <= id_wb_sel;
        ex_wb_fp_en    <= id_wb_fp_en;
        ex_wb_int_en   <= id_wb_int_en;
        ex_rm          <= id_rm;
    end
end

endmodule


