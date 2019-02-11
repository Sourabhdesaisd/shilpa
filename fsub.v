module float_sub(
    input  [31:0] operand_A,
    input  [31:0] operand_B,
    output [31:0] sub_res
);

wire           pr_enc_en_w;
wire   [31:0]  sub_res_w;
wire   [23:0]  mantissa_add_w;
wire           carry_w;

wire           interrupt_en_w;
wire   [31:0]  out_res_w;

floating_sub floating_sub_instance(
    .operand_A(operand_A),
    .operand_B(operand_B),
    .enc_out_res(out_res_w),
    .interrupt_en(interrupt_en_w),
    .pr_enc_en(pr_enc_en_w),
    .sub_res(sub_res_w),
    .mantissa_add(mantissa_add_w),
    .carry(carry_w),
    .final_sub_res(sub_res)
);

pr_encoder pr_encoder_instance(
    .in_res(sub_res_w),
    .mantissa_add_en(mantissa_add_w),
    .carry(carry_w),
    .en(pr_enc_en_w),
    .interrupt_en(interrupt_en_w),
    .out_res(out_res_w)
);

endmodule

module floating_sub(
    input  [31:0] operand_A,
    input  [31:0] operand_B,
    input  [31:0] enc_out_res,
    input         interrupt_en,
    output reg    pr_enc_en,
    output reg [31:0] sub_res,
    output reg [23:0] mantissa_add,
    output reg    carry,
    output reg [31:0] final_sub_res
);

wire sign_bit_a = operand_A[31];
wire [7:0] exponent_a = operand_A[30:23];
wire [22:0] mantissa_a = operand_A[22:0];

wire sign_bit_b = operand_B[31];
wire [7:0] exponent_b = operand_B[30:23];
wire [22:0] mantissa_b = operand_B[22:0];

wire [1:0] operation = {sign_bit_a, sign_bit_b};

reg [7:0] exponent_diff;
reg [23:0] mantissa_a_hidd;
reg [23:0] mantissa_b_hidd;

always @(*) begin
    pr_enc_en = 1'b0;
    carry = 1'b0;
    mantissa_add = 24'b0;
    sub_res = 32'b0;
    final_sub_res = 32'b0;

    // Hidden bit
    mantissa_a_hidd = {(|exponent_a), mantissa_a};
    mantissa_b_hidd = {(|exponent_b), mantissa_b};

    // Exponent difference
    if (exponent_a > exponent_b)
        exponent_diff = exponent_a - exponent_b;
    else
        exponent_diff = exponent_b - exponent_a;

    // Alignment
    if (exponent_a > exponent_b) begin
        mantissa_b_hidd = mantissa_b_hidd >> exponent_diff;
        sub_res[30:23] = exponent_a;
    end else begin
        mantissa_a_hidd = mantissa_a_hidd >> exponent_diff;
        sub_res[30:23] = exponent_b;
    end

    case (operation)

        // +A - B
        2'b01, 2'b10: begin
            sub_res[31] = sign_bit_a ^ sign_bit_b;
            {carry, mantissa_add[22:0]} =
                mantissa_a_hidd[22:0] + mantissa_b_hidd[22:0];

            if (carry) begin
                sub_res[22:0] = mantissa_add[22:0] >> 1;
                sub_res[30:23] = sub_res[30:23] + 1'b1;
            end else begin
                sub_res[22:0] = mantissa_add[22:0];
            end

            final_sub_res = sub_res;
        end

        // +A - +B or -A - -B
        2'b00, 2'b11: begin
            mantissa_b_hidd = ~mantissa_b_hidd + 1'b1;
            {carry, mantissa_add} =
                mantissa_a_hidd + mantissa_b_hidd;

            if (operand_A[30:0] == operand_B[30:0]) begin
                final_sub_res = 32'b0;
                pr_enc_en = 1'b0;
            end else begin
                sub_res[22:0] = mantissa_add[22:0];
                sub_res[31] = sign_bit_a;
                pr_enc_en = 1'b1;
                final_sub_res = sub_res;
            end
        end

        default: final_sub_res = 32'b0;

    endcase

    if (interrupt_en)
        final_sub_res = enc_out_res;
end

endmodule

module pr_encoder(
  input        [31:0]in_res           ,
  input        [23:0]mantissa_add_en  ,
  input              carry            ,
  input        en                     ,
  output  reg  interrupt_en           ,
  output  reg  [31:0]out_res
                 )                    ;

  wire [22:0]In_res_mantissa          ;
  wire  [7:0]In_res_exponent          ;
  
  assign  In_res_mantissa = in_res[22:0]               ;
  assign  In_res_exponent = in_res[30:23]              ;
  
  always@(*)
    begin
      
  
  if(en)
    begin
      
      casex({carry,mantissa_add_en[23],In_res_mantissa})
            
         25'b111xxxxxxxxxxxxxxxxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 0         ;
            out_res[30:23] = in_res[30:23] - 0        ;
            
          end
        
        25'b101xxxxxxxxxxxxxxxxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 1        ;
            out_res[30:23] = in_res[30:23] - 1        ;
            
          end
              
        25'b1001xxxxxxxxxxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 2         ;
            out_res[30:23] = in_res[30:23] - 2        ;
           
          end
              
        25'b10001xxxxxxxxxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 3         ;
            out_res[30:23] = in_res[30:23] - 3        ;
           
          end
              
        25'b100001xxxxxxxxxxxxxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 4         ;
            out_res[30:23] = in_res[30:23] - 4        ;
            
          end
              
        25'b1000001xxxxxxxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 5         ;
            out_res[30:23] = in_res[30:23] - 5        ;
            
          end
              
        25'b10000001xxxxxxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 6         ;
            out_res[30:23] = in_res[30:23] - 6        ;
            
          end
              
        25'b100000001xxxxxxxxxxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 7         ;
            out_res[30:23] = in_res[30:23] - 7        ;
            
          end
              
        25'b1000000001xxxxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 8         ;
            out_res[30:23] = in_res[30:23] - 8        ;
            
          end
              
        25'b10000000001xxxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 9         ;
            out_res[30:23] = in_res[30:23] - 9        ;
                 
          end
              
        25'b100000000001xxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 10        ;
            out_res[30:23] = in_res[30:23] - 10       ;
            
          end
              
        25'b1000000000001xxxxxxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 11        ;
            out_res[30:23] = in_res[30:23] - 11       ;
            
          end
              
        25'b10000000000001xxxxxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 12       ;
            out_res[30:23] = in_res[30:23] - 12      ;
           
          end
              
        25'b100000000000001xxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 13       ;
            out_res[30:23] = in_res[30:23] - 13      ;
            
          end
              
        25'b1000000000000001xxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 14       ;
            out_res[30:23] = in_res[30:23] - 14      ;
           
          end
              
        25'b10000000000000001xxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 15       ;
            out_res[30:23] = in_res[30:23] - 15      ;
            
          end
              
        25'b100000000000000001xxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 16       ;
            out_res[30:23] = in_res[30:23] - 16      ;
                                   
          end
              
        25'b1000000000000000001xxxxxx    :  
          begin
            out_res[22:0] = in_res[22:0] << 17       ;
            out_res[30:23] = in_res[30:23] - 17      ;
            
          end
              
        25'b10000000000000000001xxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 18       ;
            out_res[30:23] = in_res[30:23] - 18      ; 
         
          end
              
        25'b100000000000000000001xxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 19       ;
            out_res[30:23] = in_res[30:23] - 19      ;
           
          end
              
        25'b1000000000000000000001xxx    :
          begin
            out_res[22:0] = in_res[22:0] << 20       ;
            out_res[30:23] = in_res[30:23] - 20      ;
           
          end
              
        25'b10000000000000000000001xx    :
          begin
            out_res[22:0] = in_res[22:0] << 21       ;
            out_res[30:23] = in_res[30:23] - 21      ;
           
          end
              
        25'b100000000000000000000001x    : 
          begin
            out_res[22:0] = in_res[22:0] << 22       ;
            out_res[30:23] = in_res[30:23] - 22      ;
          
          end
              
        25'b1000000000000000000000001    :
          begin
            out_res[22:0] = in_res[22:0] << 23       ;
            out_res[30:23] = in_res[30:23] - 23      ;
           
          end
        
         
         25'b00xxxxxxxxxxxxxxxxxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 0        ;
            out_res[30:23] = in_res[30:23] - 0       ;
            
          end
        
        
        25'b011xxxxxxxxxxxxxxxxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 1         ;
            out_res[30:23] = in_res[30:23] - 1        ;
            
          end
              
        25'b0101xxxxxxxxxxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 2         ;
            out_res[30:23] = in_res[30:23] - 2        ;
           
          end
              
        25'b01001xxxxxxxxxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 3         ;
            out_res[30:23] = in_res[30:23] - 3        ;
           
          end
              
              
        25'b0100001xxxxxxxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 5         ;
            out_res[30:23] = in_res[30:23] - 5        ;
            
          end
              
        25'b01000001xxxxxxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 6         ;
            out_res[30:23] = in_res[30:23] - 6        ;
            
          end
              
        25'b010000001xxxxxxxxxxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 7         ;
            out_res[30:23] = in_res[30:23] - 7        ;
            
          end
              
        25'b0100000001xxxxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 8         ;
            out_res[30:23] = in_res[30:23] - 8        ;
            
          end
              
        25'b01000000001xxxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 9         ;
            out_res[30:23] = in_res[30:23] - 9        ;
                 
          end
              
        25'b010000000001xxxxxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 10        ;
            out_res[30:23] = in_res[30:23] - 10       ;
            
          end
              
        25'b0100000000001xxxxxxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 11        ;
            out_res[30:23] = in_res[30:23] - 11       ;
            
          end
              
        25'b01000000000001xxxxxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 12       ;
            out_res[30:23] = in_res[30:23] - 12      ;
           
          end
              
        25'b010000000000001xxxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 13       ;
            out_res[30:23] = in_res[30:23] - 13      ;
            
          end
              
        25'b0100000000000001xxxxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 14       ;
            out_res[30:23] = in_res[30:23] - 14      ;
           
          end
              
        25'b01000000000000001xxxxxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 15       ;
            out_res[30:23] = in_res[30:23] - 15      ;
            
          end
              
        25'b010000000000000001xxxxxxx    :
          begin
            out_res[22:0] = in_res[22:0] << 16       ;
            out_res[30:23] = in_res[30:23] - 16      ;
                                   
          end
              
        25'b0100000000000000001xxxxxx    :  
          begin
            out_res[22:0] = in_res[22:0] << 17       ;
            out_res[30:23] = in_res[30:23] - 17      ;
            
          end
              
        25'b01000000000000000001xxxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 18       ;
            out_res[30:23] = in_res[30:23] - 18      ; 
         
          end
              
        25'b010000000000000000001xxxx    : 
          begin
            out_res[22:0] = in_res[22:0] << 19       ;
            out_res[30:23] = in_res[30:23] - 19      ;
           
          end
              
        25'b0100000000000000000001xxx    :
          begin
            out_res[22:0] = in_res[22:0] << 20       ;
            out_res[30:23] = in_res[30:23] - 20      ;
           
          end
              
        25'b01000000000000000000001xx    :
          begin
            out_res[22:0] = in_res[22:0] << 21       ;
            out_res[30:23] = in_res[30:23] - 21      ;
           
          end
              
        25'b010000000000000000000001x    : 
          begin
            out_res[22:0] = in_res[22:0] << 22       ;
            out_res[30:23] = in_res[30:23] - 22      ;
          
          end
              
        25'b0100000000000000000000001    :
          begin
            out_res[22:0] = in_res[22:0] << 23       ;
            out_res[30:23] = in_res[30:23] - 23      ;
           
          end
        
        25'b0100000000000000000000000    :
          begin
            out_res[22:0] = in_res[22:0] << 24      ;
            out_res[30:23] = in_res[30:23] - 24     ;
           
          end
              
              default 
              
              out_res = in_res                       ;                                         
                  
                  
      endcase
      out_res[31] = in_res[31]                       ;
      interrupt_en = 1'b1                            ;
    end
      
    end
  
endmodule


