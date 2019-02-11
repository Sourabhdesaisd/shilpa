/*module pc_block (
    input  wire        clk,
    input  wire        rst,
    output reg  [31:0] pc
);

    reg [31:0] pc_next;

    // Next PC logic (combinational)
    always @(*) begin
        pc_next = pc + 32'd4;
    end

    // PC register (sequential)
    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 32'd0;      // Start at PC = 0
        else
            pc <= pc_next;   // PC = PC + 4
    end

endmodule*/


module pc_block (
    input  wire        clk,
    input  wire        rst,
    output reg  [31:0] pc,
    output wire [31:0] pc_plus4
);

    assign pc_plus4 = pc + 32'd4;

    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 32'd0;      // Start at PC = 0
        else
            pc <= pc_plus4;  // PC = PC + 4
    end

endmodule

