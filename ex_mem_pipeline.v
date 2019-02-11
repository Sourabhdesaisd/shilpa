module ex_mem_pipeline (
    input  wire        clk,
    input  wire        rst,

    // ===== DATA from EX =====
    input  wire [31:0] ex_alu_result,
    input  wire [31:0] ex_store_data,
    input  wire [4:0]  ex_rd_addr,

    // ===== CONTROL =====
    input  wire        ex_wb_sel,
    input  wire        ex_wb_fp_en,
    input  wire        ex_wb_int_en,

    // ===== OUTPUTS to MEM =====
    output reg  [31:0] mem_alu_result,
    output reg  [31:0] mem_store_data,
    output reg  [4:0]  mem_rd_addr,

    output reg         mem_wb_sel,
    output reg         mem_wb_fp_en,
    output reg         mem_wb_int_en
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        mem_alu_result <= 0;
        mem_store_data <= 0;
        mem_rd_addr    <= 0;
        mem_wb_sel     <= 0;
        mem_wb_fp_en   <= 0;
        mem_wb_int_en  <= 0;
    end else begin
        mem_alu_result <= ex_alu_result;
        mem_store_data <= ex_store_data;
        mem_rd_addr    <= ex_rd_addr;

        mem_wb_sel     <= ex_wb_sel;
        mem_wb_fp_en   <= ex_wb_fp_en;
        mem_wb_int_en  <= ex_wb_int_en;
    end
end

endmodule

