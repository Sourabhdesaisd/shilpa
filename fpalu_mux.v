module fp_norm_mux (
    input  wire        sel,          // 1 = normalize path, 0 = bypass
    input  wire [31:0] alu_out,       // direct ALU result
    input  wire [31:0] norm_out,      // normalized + rounded output
    output wire [31:0] wb_out         // to write-back stage
);

    assign wb_out = sel ? norm_out : alu_out;

endmodule
