/*module id_stage (
    input  wire        clk,

    // From IF/ID pipeline
    input  wire [31:0] instr_out,
    input  wire [31:0] pc_plus4_out,

    // Outputs to ID/EX pipeline
    output wire [31:0] int_rs1_data,
    output wire [31:0] fp_rs1_data,
    output wire [31:0] fp_rs2_data,
    output wire [31:0] imm,

    output wire [4:0]  rd,
    output wire [4:0]  rs1,
    output wire [4:0]  rs2,

    // Control signals
    output wire        werf,
    output wire        mwr,
    output wire        b_mux,
    output wire [1:0]  ir_mux
    );

    // Control unit unused outputs
wire move_en;
wire move_dir;
wire cvt_en;
wire is_unsigned;

    /* ---------------- Decoder outputs ---------------- */
   /* wire [6:0] opcode;
    wire [4:0] func5;
    wire [31:0] load_imm;

                             // Decoder unused outputs (declare wires)wire [4:0] falu_opcode;
wire [4:0] falu_opcode;
wire [2:0] load_width;
wire [2:0] store_width;
wire [31:0] store_imm;
wire [2:0] rm;
wire [1:0] fmt;

decoder u_decoder (
    .instruction (instruction),
    .rs1_addr    (rs1),
    .rs2_addr    (rs2),
    .rd_addr     (rd),
    .falu_opcode (falu_opcode),
    .load_imm    (load_imm),
    .load_width  (load_width),
    .store_width (store_width),
    .store_imm   (store_imm),
    .rm          (rm),
    .fmt         (fmt),
    .opcode      (opcode),
    .func5       (func5)
);


    assign imm = load_imm;

    /* ---------------- Integer Register File ---------------- */
   /* int_regfile u_int_rf (
        .clk          (clk),
        .we           (1'b0),          // no write in ID stage
        .rs1          (rs1),
        .rs2          (rs2),
        .write_address(5'd0),
        .data_in      (32'd0),
        .rdata1       (int_rs1_data),
        .rdata2       ()
    );

    /* ---------------- Floating Point Register File ---------------- */
    /*fp_regfile u_fp_rf (
        .clk           (clk),
        .we            (1'b0),          // no write in ID stage
        .rs1f          (rs1),
        .rs2f          (rs2),
        .write_addressf(5'd0),
        .data_inf      (32'd0),
        .rdata1f       (fp_rs1_data),
        .rdata2f       (fp_rs2_data)
    );

    /* ---------------- Control Unit ---------------- */
   /*control_unit u_ctrl (
    .opcode      (opcode),
    .func5       (func5),
    .werf        (werf),
    .mwr         (mwr),
    .b_mux       (b_mux),
    .ir_mux      (ir_mux),
    .move_en     (move_en),
    .move_dir    (move_dir),
    .cvt_en      (cvt_en),
    .is_unsigned (is_unsigned)
);


endmodule*/

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module id_stage(
    // Decoder //
    input [31:0] instruction,
    //control unit//
  //  input [6:0] opcode,
    //input [4:0]func5,
    //int reg//
    input  wire        clk,
    input  wire        we,           
   // input  wire [4:0]  rs1,          
   // input  wire [4:0]  rs2,          
    //input  wire [4:0]  write_address,           
    //input  wire [31:0] data_in,
    //fp reg//
    //input  wire        clk,
    //nput  wire        we,            
   // input  wire [4:0]  rs1f,          
   // input  wire [4:0]  rs2f,          
    ///input  wire [4:0]  write_addressf,           
   // input  wire [31:0] data_inf,
    input  wire reg_wb,

       // output reg [4:0] rs1_addr,
		//output reg [4:0] rs2_addr,
		output reg [4:0] rd_addr,
		output reg [4:0] falu_opcode,
		output reg [4:0] func5,
		output reg [6:0] opcode,
		output reg [31:0] load_imm,
		output reg [2:0] load_width,
		output reg [2:0] store_width,
		output reg [31:0] store_imm,
		output reg [2:0] rm,
		output reg [1:0] fmt,

        output reg [1:0]  ir_mux,
		output reg mwr,
		output reg b_mux,
	    output reg werf,
	    output reg move_en,
	    output reg move_dir,
	    output reg cvt_en,
		output reg is_unsigned,
        output reg wb_sel,

        output wire [31:0] rdata1,       
        output wire [31:0] rdata2, 

        output wire [31:0] rdata1f,       
        output wire [31:0] rdata2f 
 );


 wire ;

decoder_unit u_decoder(
    .instruction(instruction),
    .rs1_addr(),
    .rs2_addr(),
    .rd_addr(),
    .falu_opcode(),
    .func5(),
    .opcode(),
    .load_imm(),
    .load_width(),
    .store_imm(),
    .store_width(),
    .rm(),
    .fmt() );

assign rs1_addr = rs1_addr_w;
control_unit u_control(
    .opcode(inst),
    .func5(inst),
    .ir_mux(),
    .mwr(),
    .b_mux(),
    .werf(),
    .move_en(),
    .move_dir(),
    .cvt_en(),
    .is_unsigned(),
    .wb_sel());


int_reg u_int_reg(
    .clk(),
    .we(),
    .rs1(instruction[19:15]),
    .rs2(instruction[24:20]),
    .write_address(),
    .data_in(),
    .rdata1(),
    .rdata2());


float_reg u_float_reg (
        .clk(),
        .we(),
        .rs1f(),
        .rs2f(),
        .write_addressf(),
       .data_inf(),
       .rdata1f(),
      .rdata2f());













