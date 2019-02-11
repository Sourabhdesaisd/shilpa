module int_regfile (
    input  wire        clk,
    input  wire        we,           // write enable
    input  wire [4:0]  rs1,          // source register 1 (used for address in FLW/FSW)
    input  wire [4:0]  rs2,          // optional second read port
    input  wire [4:0]  write_address,           // destination register for writes
    input  wire [31:0] data_in,        // data to write
    output wire [31:0] rdata1,       // read data 1
    output wire [31:0] rdata2        // read data 2
);

initial
begin 
     $readmemh ("data.hex",mem_reg);
end

    // 32 integer registers
    reg [31:0] mem_reg [0:31];

    // Reads (combinational)
    assign rdata1 = mem_reg[rs1];
    assign rdata2 = mem_reg[rs2];

    // Writes (synchronous)
    always @(posedge clk) 
    begin
        if (we)
        begin
            mem_reg[write_address] <= data_in;
        end
    end
endmodule
