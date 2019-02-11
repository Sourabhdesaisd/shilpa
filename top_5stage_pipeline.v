//================ IF/ID PIPELINE ==================
module if_id_pipeline (
    input wire clk,
    input wire rst,
    input wire [31:0] pc_plus4_in,
    input wire [31:0] instr_in,
    output reg [31:0] pc_plus4_out,
    output reg [31:0] instr_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_plus4_out <= 32'd0;
            instr_out   <= 32'd0;
        end else begin
            pc_plus4_out <= pc_plus4_in;
            instr_out   <= instr_in;
        end
    end
endmodule

//================ ID/EX PIPELINE ==================
module id_ex_pipeline (
    input wire clk,
    input wire rst,

    input wire [31:0] int_rs1_data_in,
    input wire [31:0] fp_rs1_data_in,
    input wire [31:0] fp_rs2_data_in,
    input wire [31:0] imm_in,
    input wire [4:0]  rd_in,
    input wire werf_in,
    input wire mwr_in,
    input wire b_mux_in,
    input wire [1:0] ir_mux_in,
    input wire wb_sel_in,

    output reg [31:0] int_rs1_data_out,
    output reg [31:0] fp_rs1_data_out,
    output reg [31:0] fp_rs2_data_out,
    output reg [31:0] imm_out,
    output reg [4:0]  rd_out,
    output reg werf_out,
    output reg mwr_out,
    output reg b_mux_out,
    output reg [1:0] ir_mux_out,
    output reg wb_sel_out
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
            wb_sel_out       <= 1'b0;
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
            wb_sel_out       <= wb_sel_in;
        end
    end
endmodule

//================ EX/MEM PIPELINE ==================
module ex_mem_pipeline (
    input wire clk,
    input wire rst,
    input wire [31:0] ex_result_in,
    input wire [31:0] addr_result_in,
    input wire [4:0] rd_in,
    input wire mwr_in,
    input wire werf_in,
    input wire b_mux_in,
    input wire wb_sel_in,

    output reg [31:0] ex_result_out,
    output reg [31:0] addr_result_out,
    output reg [4:0] rd_out,
    output reg mwr_out,
    output reg werf_out,
    output reg b_mux_out,
    output reg wb_sel_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ex_result_out   <= 32'b0;
            addr_result_out <= 32'b0;
            rd_out          <= 5'b0;
            mwr_out         <= 1'b0;
            werf_out        <= 1'b0;
            b_mux_out       <= 1'b0;
            wb_sel_out      <= 1'b0;
        end else begin
            ex_result_out   <= ex_result_in;
            addr_result_out <= addr_result_in;
            rd_out          <= rd_in;
            mwr_out         <= mwr_in;
            werf_out        <= werf_in;
            b_mux_out       <= b_mux_in;
            wb_sel_out      <= wb_sel_in;
        end
    end
endmodule

//================ MEM/WB PIPELINE ==================
module mem_wb_pipeline (
    input wire clk,
    input wire rst,
    input wire [31:0] mem_data_in,
    input wire [31:0] ex_result_in,
    input wire [4:0] rd_in,
    input wire werf_in,
    input wire wb_sel_in,

    output reg [31:0] mem_data_out,
    output reg [31:0] ex_result_out,
    output reg [4:0] rd_out,
    output reg werf_out,
    output reg wb_sel_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mem_data_out  <= 32'b0;
            ex_result_out <= 32'b0;
            rd_out        <= 5'b0;
            werf_out      <= 1'b0;
            wb_sel_out    <= 1'b0;
        end else begin
            mem_data_out  <= mem_data_in;
            ex_result_out <= ex_result_in;
            rd_out        <= rd_in;
            werf_out      <= werf_in;
            wb_sel_out    <= wb_sel_in;
        end
    end
endmodule

//================ FORWARDING UNIT ==================
module forwarding_unit (
    input [4:0] ID_EX_rs1,
    input [4:0] ID_EX_rs2,
    input [4:0] EX_MEM_rd,
    input EX_MEM_regwrite,
    input [4:0] MEM_WB_rd,
    input MEM_WB_regwrite,
    output reg [1:0] forwardA,
    output reg [1:0] forwardB
);
    always @(*) begin
        forwardA = 2'b00;
        forwardB = 2'b00;

        if (EX_MEM_regwrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs1))
            forwardA = 2'b10;
        else if (MEM_WB_regwrite && (MEM_WB_rd != 0) && (MEM_WB_rd == ID_EX_rs1))
            forwardA = 2'b01;

        if (EX_MEM_regwrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs2))
            forwardB = 2'b10;
        else if (MEM_WB_regwrite && (MEM_WB_rd != 0) && (MEM_WB_rd == ID_EX_rs2))
            forwardB = 2'b01;
    end
endmodule

//================ FORWARDING MUX ==================
module forwarding_mux (
    input [31:0] rs_data,
    input [31:0] ex_data,
    input [31:0] wb_data,
    input [1:0] sel,
    output reg [31:0] forw_out
);
    always @(*) begin
        case(sel)
            2'b00: forw_out = rs_data;
            2'b01: forw_out = ex_data;
            2'b10: forw_out = wb_data;
            default: forw_out = 32'b0;
        endcase
    end
endmodule

//================ TOP 5-STAGE PIPELINE ==================
module five_stage_pipeline_top (
    input wire clk,
    input wire rst,

    input wire [31:0] pc_plus4_in,
    input wire [31:0] instr_in,

    input wire [31:0] int_rs1_data,
    input wire [31:0] fp_rs1_data,
    input wire [31:0] fp_rs2_data,
    input wire [31:0] imm,
    input wire [4:0]  rd,

    input wire werf,
    input wire mwr,
    input wire b_mux,
    input wire [1:0] ir_mux,
    input wire wb_sel,

    input wire [31:0] ex_result,
    input wire [31:0] addr_result,
    input wire [31:0] mem_data
);

    // IF/ID wires
    wire [31:0] if_pc4_out, if_instr_out;

    // ID/EX wires
    wire [31:0] id_int_rs1_out, id_fp_rs1_out, id_fp_rs2_out, id_imm_out;
    wire [4:0] id_rd_out;
    wire id_werf_out, id_mwr_out, id_b_mux_out;
    wire [1:0] id_ir_mux_out;
    wire id_wb_sel_out;

    // EX/MEM wires
    wire [31:0] ex_ex_result_out, ex_addr_result_out;
    wire [4:0] ex_rd_out;
    wire ex_mwr_out, ex_werf_out, ex_b_mux_out, ex_wb_sel_out;

    // MEM/WB wires
    wire [31:0] wb_mem_data_out, wb_ex_result_out;
    wire [4:0] wb_rd_out;
    wire wb_werf_out, wb_wb_sel_out;

    // Instantiate pipelines
    if_id_pipeline IF_ID (clk, rst, pc_plus4_in, instr_in, if_pc4_out, if_instr_out);
    id_ex_pipeline ID_EX (clk, rst, int_rs1_data, fp_rs1_data, fp_rs2_data, imm, rd,
                          werf, mwr, b_mux, ir_mux, wb_sel,
                          id_int_rs1_out, id_fp_rs1_out, id_fp_rs2_out, id_imm_out,
                          id_rd_out, id_werf_out, id_mwr_out, id_b_mux_out, id_ir_mux_out, id_wb_sel_out);

    ex_mem_pipeline EX_MEM (clk, rst, ex_result, addr_result, id_rd_out,
                            id_mwr_out, id_werf_out, id_b_mux_out, id_wb_sel_out,
                            ex_ex_result_out, ex_addr_result_out, ex_rd_out,
                            ex_mwr_out, ex_werf_out, ex_b_mux_out, ex_wb_sel_out);

    mem_wb_pipeline MEM_WB (clk, rst, mem_data, ex_ex_result_out, ex_rd_out,
                            ex_werf_out, ex_wb_sel_out,
                            wb_mem_data_out, wb_ex_result_out, wb_rd_out,
                            wb_werf_out, wb_wb_sel_out);

endmodule

