module instruction_memory (

        input  wire [31:0] pc,
        output  [31:0] instruction
);

      reg [31:0] imem [0:255];

      assign  instruction = imem[pc[31:2]];
    
      initial begin
        $readmemh("im_program.hex", imem);
    end

endmodule

