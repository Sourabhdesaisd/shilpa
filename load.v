module load_fp_datapath (
    input  wire [31:0] mem_addr,    // from ripple-carry adder (rs1 + imm)
    input  wire [31:0] mem_rdata,    // data read from memory
    input  wire [2:0]  width,        // W field from ISA
    output reg  [31:0] load_data     // to FP register rd
);
/////  Use address LSBs to know which byte to pick /////
    wire [1:0] addr;
    assign addr = mem_addr[1:0];
///// Split memory word into bytes (Little-Endian)////
    wire [7:0] byte0 = mem_rdata[7:0];
    wire [7:0] byte1 = mem_rdata[15:8];
    wire [7:0] byte2 = mem_rdata[23:16];
    wire [7:0] byte3 = mem_rdata[31:24];

    wire [15:0] half0 = {byte1, byte0};
    wire [15:0] half1 = {byte3, byte2};
//////Select byte and half-word using address///////
    wire [7:0] selected_byte =
        (addr == 2'b00) ? byte0 :
        (addr == 2'b01) ? byte1 :
        (addr == 2'b10) ? byte2 :
                         byte3;

    wire [15:0] selected_half =
        (addr[1] == 1'b0) ? half0 : half1;
//////////width field (W)//////////////////////////
    always @(*) begin
        case (width)

            3'b000:   // LB  (signed byte)
                load_data = {{24{selected_byte[7]}}, selected_byte};

            3'b011:   // LBU (unsigned byte)
                load_data = {24'b0, selected_byte};

            3'b001:   // LH  (signed half)
                load_data = {{16{selected_half[15]}}, selected_half};

            3'b100:   // LHU (unsigned half)
                load_data = {16'b0, selected_half};

            3'b010:   // LW / FLW (32-bit FP)
                load_data = mem_rdata;

            default:
                load_data = 32'b0;
        endcase
    end

endmodule

//////////////////////////////////////// for lint //////////////////////////////////

/*module load_fp_datapath (
    input  wire [31:0] mem_addr,    // from ripple-carry adder (rs1 + imm)
    input  wire [31:0] mem_rdata,    // data read from memory
    input  wire [2:0]  width,        // W field from ISA
    output reg  [31:0] load_data     // to FP register rd
);

        // Byte offset inside the 32-bit word
        wire [1:0] addr;
    assign addr = mem_addr[1:0];

       // Split memory word into bytes
        wire [7:0] byte0 = mem_rdata[7:0];
    wire [7:0] byte1 = mem_rdata[15:8];
    wire [7:0] byte2 = mem_rdata[23:16];
    wire [7:0] byte3 = mem_rdata[31:24];

        // Form half-words (little-endian)
        wire [15:0] half0 = {byte1, byte0};   // bytes [1:0]
    wire [15:0] half1 = {byte3, byte2};   // bytes [3:2]

        // Select byte and half-word
        wire [7:0] selected_byte;
    wire [15:0] selected_half;

    assign selected_byte =
        (addr == 2'b00) ? byte0 :
        (addr == 2'b01) ? byte1 :
        (addr == 2'b10) ? byte2 :
                         byte3;

    assign selected_half =
        (addr[1] == 1'b0) ? half0 : half1;

        // LOAD logic
    
    always @(*) begin
        // Default assignment (prevents latch)
        load_data = 32'b0;

        case (width)

                        // Load signed byte
            3'b000:
                load_data = {{24{selected_byte[7]}}, selected_byte};

                        // Load unsigned byte
            
            3'b011:
                load_data = {24'b0, selected_byte};

                        // Load signed half-word
            
            3'b001:
                load_data = {{16{selected_half[15]}}, selected_half};

                        // Load unsigned half-word
            
            3'b100:
                load_data = {16'b0, selected_half};

                        // Load word (32-bit FP)
            
            3'b010:
                load_data = mem_rdata;

                        // Invalid width
            
            default:
                load_data = 32'b0;
        endcase
    end

endmodule*/


