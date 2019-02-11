module id_ex_pipeline (
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

endmodule

