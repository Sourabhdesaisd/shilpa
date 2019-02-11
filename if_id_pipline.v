/*module if_id_pipeline (
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] pc_plus4_in,
    input  wire [31:0] instr_in,
    output reg  [31:0] pc_plus4_out,
    output reg  [31:0] instr_out
);

    always @(posedge clk or posedge rst)
    begin

        if (rst) begin
            pc_plus4_out <= 32'd0;
            instr_out   <= 32'd0;end 
        else begin
            pc_plus4_out <= pc_plus4_in;
            instr_out   <= instr_in;
        end
    end

endmodule*/


module if_id_pipeline (
    input  wire        clk,
    input  wire        rst,

    // Inputs from IF stage
    input  wire [31:0] if_pc_plus4,
    input  wire [31:0] if_instruction,

    // Outputs to ID stage
    output reg  [31:0] id_pc_plus4,
    output reg  [31:0] id_instruction
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            id_pc_plus4   <= 32'd0;
            id_instruction <= 32'd0;
        end else begin
            id_pc_plus4   <= if_pc_plus4;
            id_instruction <= if_instruction;
        end
    end

endmodule


