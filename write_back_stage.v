module wb_stage (
    // ===== Inputs from MEM/WB pipeline =====
    input  wire        clk,

    input  wire [31:0] wb_load_data,
    input  wire [31:0] wb_alu_result,
    input  wire [31:0] wb_fp_result,

    input  wire [1:0]  wb_sel,
    input  wire        wb_fp_en,
    input  wire        wb_int_en,

    input  wire [4:0]  wb_rd_addr,

    // ===== Outputs to Register Files =====
    output wire [31:0] wb_fp_wdata,
    output wire [31:0] wb_int_wdata,
    output wire        wb_fp_we,
    output wire        wb_int_we,
    output wire [4:0]  wb_waddr
);

    // -----------------------------
    // Internal wires
    // -----------------------------
    wire [31:0] fp_wdata;
    wire [31:0] int_wdata;

    // -----------------------------
    // WRITEBACK DATAPATH (your module)
    // -----------------------------
    fp_writeback wb_unit (
        .clk        (clk),
        .dm_out     (wb_load_data),
        .mov_out    (wb_alu_result),
        .norm_out   (wb_fp_result),
        .wb_sel     (wb_sel),
        .wb_fp_en   (wb_fp_en),
        .wb_int_en  (wb_int_en),
        .fp_wdata   (fp_wdata),
        .int_wdata  (int_wdata)
    );

    // -----------------------------
    // Assign outputs to regfiles
    // -----------------------------
    assign wb_fp_wdata  = fp_wdata;
    assign wb_int_wdata = int_wdata;

    assign wb_fp_we  = wb_fp_en;
    assign wb_int_we = wb_int_en;

    assign wb_waddr = wb_rd_addr;

endmodule
