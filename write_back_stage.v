module fp_writeback_stage (
    input  wire        clk,

    // Data inputs
    input  wire [31:0]  dm_out,     // From Data Memory (FLW)
    input  wire [31:0]  mov_out,    // From MOV block
    input  wire [31:0]  norm_out,   // From Conversion + Normalization

    // Control
    input  wire [1:0]   wb_sel,     // Writeback MUX select
    input  wire        wb_fp_en,    // Write FP register enable
    input  wire        wb_int_en,   // Write INT register enable

    // Destination register
   // input  wire [4:0]   rd,

    // Outputs to register files
    output reg  [31:0]  fp_wdata,
    output reg  [31:0]  int_wdata
  //  output reg  [4:0]   fp_waddr,
  //  output reg  [4:0]   int_waddr,
 //   output reg         fp_we,
   // output reg         int_we
);

    // -----------------------------
    // Writeback MUX
    // -----------------------------
    reg [31:0] wb_data;

    always @(*) begin
        case (wb_sel)
            2'b00: wb_data = dm_out;     // FLW
            2'b01: wb_data = mov_out;    // MOV
            2'b10: wb_data = norm_out;   // Conversion / Normalization
            default: wb_data = 32'b0;
        endcase
    end

    // -----------------------------
    // Register file write control
    // -----------------------------
    always @(*) begin
        // Defaults
        fp_wdata  = 32'b0;
        int_wdata = 32'b0;

        if (wb_fp_en) begin
            fp_wdata = wb_data;
        end

        if (wb_int_en) begin
            int_wdata = wb_data;
        end
    end

endmodule

