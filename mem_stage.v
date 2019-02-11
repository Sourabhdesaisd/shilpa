module mem_stage (
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

endmodule

