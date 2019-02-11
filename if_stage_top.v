module top_fetch (
    input  wire        clk,
    input  wire        rst,
    output wire [31:0] instruction,
    output wire [31:0] pc
);

    // Instantiate PC block
    pc_block u_pc (
        .clk(clk),
        .rst(rst),
        .pc(pc)
    );

    // Instantiate Instruction Memory
    instruction_memory u_imm (
        .pc(pc),
        .instruction(instruction)
    );

endmodule

