/*module top_fetch (
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

endmodule*/



module if_stage (
    input  wire        clk,
    input  wire        rst,
    output wire [31:0] if_pc,
    output wire [31:0] if_pc_plus4,
    output wire [31:0] if_instruction
);

    // PC block
    pc_block pc_inst (
        .clk(clk),
        .rst(rst),
        .pc(if_pc),
        .pc_plus4(if_pc_plus4)
    );

    // Instruction Memory
    instruction_memory imem_inst (
        .pc(if_pc),
        .instruction(if_instruction)
    );

endmodule


