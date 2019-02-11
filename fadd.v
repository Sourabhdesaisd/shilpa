module float_add(
  input  [31:0] operand_A,
  input  [31:0] operand_B,
  output [31:0] add_res
);

wire            pr_enc_en_w;
wire [31:0]     add_res_w;
wire [23:0]     mantissa_add_w;
wire            carry_w;

wire            interrupt_en_w;
wire [31:0]     out_res_w;

floating_add floating_add_instance(
  .operand_A     (operand_A),
  .operand_B     (operand_B),
  .enc_out_res   (out_res_w),
  .interrupt_en  (interrupt_en_w),
  .pr_enc_en     (pr_enc_en_w),
  .add_res       (add_res_w),
  .mantissa_add  (mantissa_add_w),
  .carry         (carry_w),
  .final_add_res (add_res)
);

pr_encoder pr_encoder_instance(
  .in_res        (add_res_w),
  .mantissa_add_en (mantissa_add_w),
  .carry         (carry_w),
  .en            (pr_enc_en_w),
  .interrupt_en  (interrupt_en_w),
  .out_res       (out_res_w)
);

endmodule

module floating_add(
  input  [31:0] operand_A,
  input  [31:0] operand_B,
  input  [31:0] enc_out_res,
  input         interrupt_en,
  output reg    pr_enc_en,
  output reg [31:0] add_res,
  output reg [23:0] mantissa_add,
  output reg    carry,
  output reg [31:0] final_add_res
);

wire sign_bit_a, sign_bit_b;
wire [7:0] exponent_a, exponent_b;
wire [22:0] mantissa_a, mantissa_b;
wire [1:0] operation;

reg [7:0] exponent_diff;
reg [23:0] mantissa_a_hidd, mantissa_b_hidd;

assign sign_bit_a = operand_A[31];
assign exponent_a = operand_A[30:23];
assign mantissa_a = operand_A[22:0];

assign sign_bit_b = operand_B[31];
assign exponent_b = operand_B[30:23];
assign mantissa_b = operand_B[22:0];

assign operation = {sign_bit_a, sign_bit_b};

always @(*) begin
  mantissa_a_hidd = {(|exponent_a), mantissa_a};
  mantissa_b_hidd = {(|exponent_b), mantissa_b};

  if (exponent_a > exponent_b)
    exponent_diff = exponent_a - exponent_b;
  else
    exponent_diff = exponent_b - exponent_a;

  if (exponent_a > exponent_b) begin
    mantissa_b_hidd = mantissa_b_hidd >> exponent_diff;
    add_res[30:23]  = exponent_a;
  end else begin
    mantissa_a_hidd = mantissa_a_hidd >> exponent_diff;
    add_res[30:23]  = exponent_b;
  end

  case (operation)

    2'b00, 2'b11: begin
      add_res[31] = sign_bit_a;
      {carry, mantissa_add[22:0]} =
        mantissa_a_hidd[22:0] + mantissa_b_hidd[22:0];

      if (carry) begin
        add_res[22:0]  = mantissa_add[22:0] >> 1;
        add_res[30:23] = add_res[30:23] + 1;
      end else begin
        add_res[22:0] = mantissa_add[22:0];
      end

      final_add_res = add_res;
      pr_enc_en = 1'b0;
    end

    2'b01, 2'b10: begin
      if (operand_A[30:0] == operand_B[30:0]) begin
        final_add_res = 32'd0;
        pr_enc_en = 1'b0;
      end else begin
        pr_enc_en = 1'b1;
        final_add_res = interrupt_en ? enc_out_res : add_res;
      end
    end

    default: final_add_res = 32'd0;

  endcase
end

endmodule


