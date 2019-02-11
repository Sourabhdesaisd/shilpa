module pc_block (
    input  wire        clk,
    input  wire        rst,
    output reg  [31:0] pc
);
     wire[31:0] pc4=pc+32'd4;

 always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 32'd0;              // Start at PC = 0
        else 
            pc <= pc4  ;       // PC = PC + 4
         end
endmodule

