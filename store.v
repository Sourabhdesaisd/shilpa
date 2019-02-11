module store_fp_datapath (
    input  wire [31:0] mem_addr,     // from ripple adder (rs1 + imm)
    input  wire [31:0] rs2_data,      // data from FP source register
    input  wire [2:0]  width,         // W field from ISA

    output reg  [31:0] mem_wdata,     // data written to memory
    output reg  [3:0]  mem_wstrb      // byte write enable
);
  ////////Extract byte offset///////////////
    wire [1:0] addr;
    assign addr = mem_addr[1:0];
 ////Byte lanes of source register///////    
    wire [7:0] b0 = rs2_data[7:0];
    wire [7:0] b1 = rs2_data[15:8];
    wire [7:0] b2 = rs2_data[23:16];
    wire [7:0] b3 = rs2_data[31:24];
    
  ////// Store logic (based on width)///////
    always @(*) begin
        mem_wdata = 32'b0;
        mem_wstrb = 4'b0000;

        case (width)

      ////////////// STORE BYTE ///////////            
            3'b000, 3'b011: begin
                case (addr)
                    2'b00: begin mem_wdata = {24'b0, b0}; mem_wstrb = 4'b0001; end
                    2'b01: begin mem_wdata = {16'b0, b0, 8'b0}; mem_wstrb = 4'b0010; end
                    2'b10: begin mem_wdata = {8'b0, b0, 16'b0}; mem_wstrb = 4'b0100; end
                    2'b11: begin mem_wdata = {b0, 24'b0}; mem_wstrb = 4'b1000; end
                endcase
            end

      ////////// STORE HALF WORD //////////////////
                        3'b001, 3'b100: begin
                if (addr[1] == 1'b0) begin
                    mem_wdata = {16'b0, b1, b0};   // lower half
                    mem_wstrb = 4'b0011;
                end else begin
                    mem_wdata = {b1, b0, 16'b0};   // upper half
                    mem_wstrb = 4'b1100;
                end
            end
    ///////// STORE WORD /////////////////////////
                        3'b010: begin
                mem_wdata = rs2_data;
                mem_wstrb = 4'b1111;
            end

            default: begin
                mem_wdata = 32'b0;
                mem_wstrb = 4'b0000;
            end
        endcase
    end

endmodule


//////////////////////////////////////// for lint /////////////////////////////////////////////////////////////

/*module store_fp_datapath (
    input  wire [31:0] mem_addr,     // from ripple adder (rs1 + imm)
    input  wire [31:0] rs2_data,      // data from FP source register
    input  wire [2:0]  width,         // W field from ISA

    output reg  [31:0] mem_wdata,     // data written to memory
    output reg  [3:0]  mem_wstrb      // byte write enable
);

    // Address offset inside 32-bit word
        wire [1:0] addr;
    assign addr = mem_addr[1:0];

    // Split rs2 data into bytes
    wire [7:0] b0 = rs2_data[7:0];
    wire [7:0] b1 = rs2_data[15:8];
    wire [7:0] b2 = rs2_data[23:16];
    wire [7:0] b3 = rs2_data[31:24];

        // Combinational STORE logic
        always @(*) begin
        // default assignments (prevents latches)
        mem_wdata = 32'b0;
        mem_wstrb = 4'b0000;

        case (width)

                        // STORE BYTE (SB)
                        3'b000, 3'b011: begin
                case (addr)
                    2'b00: begin
                        mem_wdata = {24'b0, b0};
                        mem_wstrb = 4'b0001;
                    end
                    2'b01: begin
                        mem_wdata = {16'b0, b0, 8'b0};
                        mem_wstrb = 4'b0010;
                    end
                    2'b10: begin
                        mem_wdata = {8'b0, b0, 16'b0};
                        mem_wstrb = 4'b0100;
                    end
                    2'b11: begin
                        mem_wdata = {b0, 24'b0};
                        mem_wstrb = 4'b1000;
                    end
                    default: begin
                        mem_wdata = 32'b0;
                        mem_wstrb = 4'b0000;
                    end
                endcase
            end

                        // STORE HALF WORD (SH)
                        3'b001, 3'b100: begin
                if (addr[1] == 1'b0) begin
                    // lower 16 bits
                    mem_wdata = {16'b0, b1, b0};
                    mem_wstrb = 4'b0011;
                end else begin
                    // upper 16 bits
                    mem_wdata = {b1, b0, 16'b0};
                    mem_wstrb = 4'b1100;
                end
            end

            
            // STORE WORD (SW)
                        3'b010: begin
                mem_wdata = rs2_data;
                mem_wstrb = 4'b1111;
            end

                        // INVALID WIDTH
                        default: begin
                mem_wdata = 32'b0;
                mem_wstrb = 4'b0000;
            end
        endcase
    end

endmodule*/


