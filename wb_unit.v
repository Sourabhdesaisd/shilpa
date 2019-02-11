module fp_writeback (
    input  wire        clk,

    // Data inputs
    input  wire [31:0]  dm_out,
    input  wire [31:0]  mov_out,
    input  wire [31:0]  norm_out,

    // Control
    input  wire [1:0]   wb_sel,
    input  wire        wb_fp_en,
    input  wire        wb_int_en,

    // Outputs to register files
    output reg  [31:0]  fp_wdata,
    output reg  [31:0]  int_wdata
);

    reg [31:0] wb_data;

    always @(*) begin
        case (wb_sel)
            2'b00: wb_data = dm_out;
            2'b01: wb_data = mov_out;
            2'b10: wb_data = norm_out;
            default: wb_data = 32'b0;
        endcase
    end

    always @(*) begin
        fp_wdata  = 32'b0;
        int_wdata = 32'b0;

        if (wb_fp_en)
            fp_wdata = wb_data;

        if (wb_int_en)
            int_wdata = wb_data;
    end

endmodule
