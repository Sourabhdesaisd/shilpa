module F_alu(clk,read_data1,read_data2,Fadd_en,Fsub_en,Fmul_en,Fdiv_en,
Fsqrt_en,Fmax_en,Fmin_en,Feq_en,Flt_en,Fleq_en,data_out);

input wire [31:0]read_data1,read_data2;
input wire Fsqrt_en,Fmax_en,Fmin_en,Feq_en,Flt_en,Fleq_en,Fadd_en,Fsub_en,Fmul_en,Fdiv_en;
input clk;

output reg [31:0] data_out;


wire sign1,sign2;
wire [7:0] exponent1,exponent2;
wire [22:0] mantissa1,mantissa2;

assign sign1     = read_data1[31]; 
assign sign2     = read_data2[31];
assign exponent1 = read_data1[30:23];
assign exponent2 = read_data2[30:23];
assign mantissa1 = read_data1[22:0];
assign mantissa2 = read_data2[22:0];

wire [31:0] sqrtdata_out,maxdata_out,mindata_out,eqdata_out,ltdata_out,leqdata_out,adddata_out,subdata_out,divdata_out,muldata_out;


float_add add(
              .operand_A(read_data1),
              .operand_B(read_data2),
              .add_en(Fadd_en),
              .add_res(adddata_out)        

              ); 

float_sub sub(
              .operand_A(read_data1), 
              .operand_B(read_data2),
              .sub_en(Fsub_en),
              .sub_res(subdata_out)        

             ); 


floatingmultiplication mul(.A(read_data1),
                           .B(read_data2),
                           .Fmul_en(Fmul_en),
                           .result(muldata_out)
                           );

FloatingDivision div(.A(read_data1),
                     .B(read_data2),
                     .clk(clk),
                     .result(divdata_out)
                     );
                    
FloatingSqrt sqrt(
             .clk(clk),
             .A(read_data1),
             .Fsqrt_en(Fsqrt_en),
             .result(sqrtdata_out)
             );

fmax max (
           .read_data1(read_data1),
           .read_data2(read_data2),
           .maxdata_out(maxdata_out),
           .Fmax_en(Fmax_en)
            );

fmin min(
          .read_data1(read_data1),
          .read_data2(read_data2),
          .mindata_out(mindata_out),
          .Fmin_en(Fmin_en)
          );

Feq    equal(
              .read_data1(read_data1),
              .read_data2(read_data2),
              .eqdata_out(eqdata_out),
              .Feq_en(Feq_en)
             );

Flt  less_than(
               .read_data1(read_data1),
               .read_data2(read_data2),
               .ltdata_out(ltdata_out),
               .Flt_en(Flt_en)
               );

Fleq  less_or_equal(
                    .read_data1(read_data1),
                    .read_data2(read_data2),
                    .leqdata_out(leqdata_out),
                    .Fleq_en(Fleq_en)
                    );

always@(posedge clk)
begin
case({Fadd_en,Fsub_en,Fmul_en,Fdiv_en,Fsqrt_en,Fmax_en,Fmin_en,Feq_en,Flt_en,Fleq_en})   

10'b1000000000 : data_out<=adddata_out;
10'b0100000000 : data_out<=subdata_out;
10'b0010000000 : data_out<=muldata_out;
10'b0001000000 : data_out<=divdata_out;
10'b0000100000 : data_out<=sqrtdata_out;
10'b0000010000 : data_out<=maxdata_out;
10'b0000001000 : data_out<=mindata_out;
10'b0000000100 : data_out<=eqdata_out;
10'b0000000010 : data_out<=ltdata_out;
10'b0000000001 : data_out<=leqdata_out;
default: data_out<=0;

endcase
end
endmodule

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*module F_alu (
    input  wire        clk,
    input  wire [31:0] read_data1,
    input  wire [31:0] read_data2,

    input  wire Fadd_en, Fsub_en, Fmul_en, Fdiv_en, Fsqrt_en,
    input  wire Fmax_en, Fmin_en, Feq_en, Flt_en, Fleq_en,

    output reg  [31:0] data_out
);

    // --------------------------------------------------
    // FP operator outputs
    // --------------------------------------------------
    wire [31:0] adddata_out, subdata_out, muldata_out;
    wire [31:0] divdata_out, sqrtdata_out;
    wire [31:0] maxdata_out, mindata_out;
    wire [31:0] eqdata_out, ltdata_out, leqdata_out;

    // --------------------------------------------------
    // Instantiate FP units
    // --------------------------------------------------
    float_add add (.operand_A(read_data1), .operand_B(read_data2),
                   .add_en(Fadd_en), .add_res(adddata_out));

    float_sub sub (.operand_A(read_data1), .operand_B(read_data2),
                   .sub_en(Fsub_en), .sub_res(subdata_out));

    floatingmultiplication mul (.A(read_data1), .B(read_data2),
                                .Fmul_en(Fmul_en), .result(muldata_out));

    FloatingDivision div (.A(read_data1), .B(read_data2),
                          .clk(clk), .result(divdata_out));

    FloatingSqrt sqrt (.clk(clk), .A(read_data1),
                       .Fsqrt_en(Fsqrt_en), .result(sqrtdata_out));

    fmax max (.read_data1(read_data1), .read_data2(read_data2),
               .maxdata_out(maxdata_out), .Fmax_en(Fmax_en));

    fmin min (.read_data1(read_data1), .read_data2(read_data2),
               .mindata_out(mindata_out), .Fmin_en(Fmin_en));

    Feq eq (.read_data1(read_data1), .read_data2(read_data2),
            .eqdata_out(eqdata_out), .Feq_en(Feq_en));

    Flt lt (.read_data1(read_data1), .read_data2(read_data2),
            .ltdata_out(ltdata_out), .Flt_en(Flt_en));

    Fleq leq (.read_data1(read_data1), .read_data2(read_data2),
              .leqdata_out(leqdata_out), .Fleq_en(Fleq_en));

    // --------------------------------------------------
    // RAW ALU output selection (before normalization)
    // --------------------------------------------------
    reg [31:0] fp_alu_raw_out;

    always @(*) begin
        case ({Fadd_en,Fsub_en,Fmul_en,Fdiv_en,Fsqrt_en,
               Fmax_en,Fmin_en,Feq_en,Flt_en,Fleq_en})

            10'b1000000000: fp_alu_raw_out = adddata_out;
            10'b0100000000: fp_alu_raw_out = subdata_out;
            10'b0010000000: fp_alu_raw_out = muldata_out;
            10'b0001000000: fp_alu_raw_out = divdata_out;
            10'b0000100000: fp_alu_raw_out = sqrtdata_out;

            10'b0000010000: fp_alu_raw_out = maxdata_out;
            10'b0000001000: fp_alu_raw_out = mindata_out;
            10'b0000000100: fp_alu_raw_out = eqdata_out;
            10'b0000000010: fp_alu_raw_out = ltdata_out;
            10'b0000000001: fp_alu_raw_out = leqdata_out;

            default:        fp_alu_raw_out = 32'b0;
        endcase
    end

    // --------------------------------------------------
    // Normalization enable
    // --------------------------------------------------
    wire fp_norm_en;
    assign fp_norm_en = Fadd_en | Fsub_en | Fmul_en | Fdiv_en | Fsqrt_en;

    // --------------------------------------------------
    // Normalization & rounding block
    // --------------------------------------------------
    wire [31:0] fp_norm_out;

    fp_normalize_round u_norm (
        .in_fp (fp_alu_raw_out),
        .out_fp(fp_norm_out)
    );

    // --------------------------------------------------
    // NORMALIZATION MUX
    // --------------------------------------------------
    wire [31:0] fp_wb_out;

    fp_norm_mux u_fp_norm_mux (
        .fp_norm_en (fp_norm_en),
        .alu_raw_out(fp_alu_raw_out),
        .norm_out   (fp_norm_out),
        .wb_out     (fp_wb_out)
    );

    // --------------------------------------------------
    // Register output
    // --------------------------------------------------
    always @(posedge clk)
        data_out <= fp_wb_out;

endmodule*/







