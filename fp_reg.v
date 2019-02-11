module fp_regfile (
    input  wire        clk,
    input  wire        we,            // write enable
    input  wire [4:0]  rs1f,          // FP source register 1
    input  wire [4:0]  rs2f,          // FP source register 2
    input  wire [4:0]  write_addressf,           // FP destination register
    input  wire [31:0] data_inf,        // data to write (float stored in 32 bits)
    output wire [31:0] rdata1f,       // read data 1
    output wire [31:0] rdata2f        // read data 2
);

initial
begin
    $readmemh ("fdata.hex",fmem_reg);
end

    // 32 floating-point registers
    reg [31:0] fmem_reg [0:31];

    // Combinational reads
    assign rdata1f = fmem_reg[rs1f];
    assign rdata2f = fmem_reg[rs2f];

    // Synchronous writes
    always @(posedge clk) begin
        if (we) begin
            fmem_reg[write_addressf] <= data_inf;
        end
    end
endmodule

