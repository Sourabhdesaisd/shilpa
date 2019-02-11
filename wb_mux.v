module wb_stage (
    // Inputs from MEM/WB pipeline
    input  wire [31:0] mem_data,
    input  wire [31:0] ex_result,
    input  wire [4:0]  rd,
    input  wire        werf,
    input  wire        wb_sel,

    // Outputs to Register File
    output wire [31:0] wb_data,
    output wire [4:0]  wb_rd,
    output wire        wb_we
);

    // Write-back data select
    assign wb_data = (wb_sel) ? mem_data : ex_result;

    // Pass-through signals
    assign wb_rd   = rd;
    assign wb_we   = werf;

endmodule

