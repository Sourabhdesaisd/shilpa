module data_memory (
    input  wire        clk,
    input  wire        mem_read,
    input  wire        mem_write,
    input  wire [31:0] addr,
    input  wire [31:0] write_data,
    output reg  [31:0] read_data
);

    reg [31:0] mem [0:255];   // 256 words

    initial begin
        $readmemh("memory.hex", mem);
    end

    wire [31:0] word_addr = addr[9:2]; // word aligned

    always @(*) begin
        if (mem_read)
            read_data = mem[word_addr];
        else
            read_data = 32'b0;
    end

    always @(posedge clk) begin
        if (mem_write)
            mem[word_addr] <= write_data;
    end

endmodule

