module ex_stage (
    // Inputs from ID/EX
    input  wire [31:0] int_rs1_data,
    input  wire [31:0] fp_rs1_data,
    input  wire [31:0] fp_rs2_data,
    input  wire [31:0] imm,
    input  wire [4:0]  rd,
    input  wire [1:0]  ir_mux,
    input  wire [2:0]  rm,
    input  wire [4:0]  alu_op,
    input  wire        move_en,
    input  wire        move_dir,

    // Outputs to EX/MEM
    output wire [31:0] ex_result,
    output wire [31:0] addr_result,
    output wire [4:0]  rd_out
);

    /* ---------- Address Calculation ---------- */
    wire [31:0] addr_sum;
    ripplecarryadder_32bit u_addr_add (
        .a   (int_rs1_data),
        .b   (imm),
        .cin (1'b0),
        .sum (addr_sum)
    );

    /* ---------- ALU ---------- */
    wire [31:0] alu_out;
    final_top_alu u_alu (
        .read_data1 (fp_rs1_data),
        .read_data2 (fp_rs2_data),
        .clk        (1'b0),          // combinational usage
        .conv_out   (32'b0),
        .rm         (rm),
        .alu_op_top (alu_op),
        .out_alu    (alu_out)
    );

    /* ---------- Move Unit ---------- */
    wire [31:0] move_fp_out, move_int_out;
    fp_move_unit u_move (
        .Fmove_en (move_en),
        .move_dir (move_dir),
        .int_rs1  (int_rs1_data),
        .fp_rs1   (fp_rs1_data),
        .fp_rd    (move_fp_out),
        .int_rd   (move_int_out)
    );

    /* ---------- Result Select ---------- */
    reg [31:0] result_sel;
    always @(*) begin
        case (ir_mux)
            2'b00: result_sel = alu_out;
            2'b01: result_sel = addr_sum;
            2'b10: result_sel = move_fp_out;
            default: result_sel = 32'b0;
        endcase
    end

    assign ex_result   = result_sel;
    assign addr_result = addr_sum;
    assign rd_out      = rd;

endmodule

