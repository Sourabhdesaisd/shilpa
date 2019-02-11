/*module mem_stage (
    // Inputs from EX/MEM pipeline
    input  wire        clk,
    input  wire        mem_read,
    input  wire        mem_write,
    input  wire        werf,          // write enable for WB
    input  wire [31:0] addr,
    input  wire [31:0] store_data,
    input  wire [31:0] ex_result,
    input  wire [4:0]  rd_in,

    // Outputs to MEM/WB pipeline
    output wire [31:0] mem_data_out,
    output wire [31:0] ex_result_out,
    output wire [4:0]  rd_out,
    output wire        werf_out
);

    // Data memory instance
    data_memory u_dmem (
        .clk        (clk),
        .mem_read   (mem_read),
        .mem_write  (mem_write),
        .addr       (addr),
        .write_data (store_data),
        .read_data  (mem_data_out)
    );

    // Pass-through signals
    assign ex_result_out = ex_result;
    assign rd_out        = rd_in;
    assign werf_out      = werf;

endmodule*/


module mem_stage (
    // ===== Inputs from EX/MEM =====
    input  wire        clk,
    input  wire        mem_read,
    input  wire        mem_write,
    input  wire [31:0] mem_address,
    input  wire [31:0] store_data,
    input  wire [2:0]  load_width,
    input  wire [2:0]  store_width,

    input  wire [31:0] alu_result,
    input  wire [31:0] fp_alu_result,

    // ===== Outputs to MEM/WB =====
    output wire [31:0] mem_load_data,
    output wire [31:0] mem_alu_result,
    output wire [31:0] mem_fp_result
);

    // ================= STORE PATH =================
    wire [31:0] mem_wdata;
    wire [3:0]  mem_wstrb;

    store_fp_datapath store_dp (
        .mem_addr  (mem_address),
        .rs2_data  (store_data),
        .width     (store_width),
        .mem_wdata (mem_wdata),
        .mem_wstrb (mem_wstrb)
    );

    // ================= DATA MEMORY =================
    wire [31:0] mem_rdata;

    data_memory dmem (
        .clk        (clk),
        .mem_read   (mem_read),
        .mem_write  (mem_write),
        .addr       (mem_address),
        .write_data (mem_wdata),
        .read_data  (mem_rdata)
    );

    // ================= LOAD PATH =================
    load_fp_datapath load_dp (
        .mem_addr  (mem_address),
        .mem_rdata (mem_rdata),
        .width     (load_width),
        .load_data (mem_load_data)
    );

    // ================= PASS-THROUGH =================
    assign mem_alu_result = alu_result;
    assign mem_fp_result  = fp_alu_result;

endmodule


