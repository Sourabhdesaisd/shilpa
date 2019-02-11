module if_id_pipeline (
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

endmodule

