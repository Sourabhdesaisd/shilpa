module fp_move_unit (
    input  wire        Fmove_en,
    input  wire        move_dir,   // 0 = INT?FP, 1 = FP?INT
    input  wire [31:0] int_rs1,
    input  wire [31:0] fp_rs1,
    output reg  [31:0] fp_rd,
    output reg  [31:0] int_rd
);

    always @(*) begin
        fp_rd  = 32'b0;
        int_rd = 32'b0;

        if (Fmove_en) begin
            if (move_dir == 1'b0) begin
                // FMV.W.X ? Integer to Float (bitwise copy)
                fp_rd = int_rs1;
            end else begin
                // FMV.X.W ? Float to Integer (bitwise copy)
                int_rd = fp_rs1;
            end
        end
    end

endmodule

