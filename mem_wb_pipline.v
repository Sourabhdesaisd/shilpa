/*module mem_wb_pipeline (
    input  wire        clk,
    input  wire        rst,

    // Inputs from MEM stage
    input  wire [31:0] mem_data_in,
    input  wire [31:0] ex_result_in,
    input  wire [4:0]  rd_in,
    input  wire        werf_in,
    input  wire wb_sel_in,
    

    // Outputs to WB stage
    output reg  [31:0] mem_data_out,
    output reg  [31:0] ex_result_out,
    output reg  [4:0]  rd_out,
    output reg         werf_out,
    output reg  wb_sel_out
    
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mem_data_out  <= 32'b0;
            ex_result_out <= 32'b0;
            rd_out        <= 5'b0;
            werf_out      <= 1'b0;
            wb_sel_out <= 1'b0;
            
        end 
        else begin
            mem_data_out  <= mem_data_in;
            ex_result_out <= ex_result_in;
            rd_out        <= rd_in;
            werf_out      <= werf_in;
            wb_sel_out <= wb_sel_in;
            
        end
    end
endmodule*/


module mem_wb_pipeline (
    input  wire        clk,
    input  wire        rst,

    // ===== Inputs from MEM stage =====
    input  wire [31:0] mem_load_data,
    input  wire [31:0] mem_alu_result,
    input  wire [31:0] mem_fp_result,
    input  wire [4:0]  mem_rd_addr,

    // ===== Control =====
    input  wire        mem_wb_sel,
    input  wire        mem_wb_fp_en,
    input  wire        mem_wb_int_en,

    // ===== Outputs to WB =====
    output reg  [31:0] wb_load_data,
    output reg  [31:0] wb_alu_result,
    output reg  [31:0] wb_fp_result,
    output reg  [4:0]  wb_rd_addr,

    output reg         wb_wb_sel,
    output reg         wb_fp_en,
    output reg         wb_int_en
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        wb_load_data <= 0;
        wb_alu_result <= 0;
        wb_fp_result <= 0;
        wb_rd_addr <= 0;

        wb_wb_sel <= 0;
        wb_fp_en  <= 0;
        wb_int_en <= 0;
    end else begin
        wb_load_data <= mem_load_data;
        wb_alu_result <= mem_alu_result;
        wb_fp_result <= mem_fp_result;
        wb_rd_addr <= mem_rd_addr;

        wb_wb_sel <= mem_wb_sel;
        wb_fp_en  <= mem_wb_fp_en;
        wb_int_en <= mem_wb_int_en;
    end
end

endmodule


