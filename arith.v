module FloatingAddition (
    input [31:0] A,
    input [31:0] B,
    input clk,
    output reg [31:0] result
);

reg Sign;
reg [7:0] Exponent;
reg [22:0] Mantissa;
reg A_sign,B_sign;
reg [7:0] A_Exponent,B_Exponent,diff_Exponent;
reg [23:0] A_Mantissa,B_Mantissa,Temp_Mantissa;
reg carry;
reg [7:0] exp_adjust;

always @(*) begin
    A_Mantissa = {1'b1,A[22:0]};
    A_Exponent = A[30:23];
    A_sign = A[31];

    B_Mantissa = {1'b1,B[22:0]};
    B_Exponent = B[30:23];
    B_sign = B[31];

    diff_Exponent = A_Exponent - B_Exponent;
    B_Mantissa = B_Mantissa >> diff_Exponent;

    {carry,Temp_Mantissa} =
        (A_sign ~^ B_sign) ? (A_Mantissa + B_Mantissa) :
                             (A_Mantissa - B_Mantissa);

    exp_adjust = A_Exponent;
    if(carry) begin
        Temp_Mantissa = Temp_Mantissa >> 1;
        exp_adjust = exp_adjust + 1'b1;
    end else begin
        while(Temp_Mantissa[23]==0 && exp_adjust>0) begin
            Temp_Mantissa = Temp_Mantissa << 1;
            exp_adjust = exp_adjust - 1'b1;
        end
    end

    Sign     = A_sign;
    Mantissa = Temp_Mantissa[22:0];
    Exponent = exp_adjust;
    result   = {Sign,Exponent,Mantissa};
end
endmodule


module FloatingMultiplication (
    input [31:0] A,
    input [31:0] B,
    input clk,
    output reg [31:0] result
);

reg Sign;
reg [7:0] Exponent;
reg [22:0] Mantissa;
reg A_sign,B_sign;
reg [7:0] A_Exponent,B_Exponent,Temp_Exponent;
reg [23:0] A_Mantissa,B_Mantissa;
reg [47:0] Temp_Mantissa;

always @(*) begin
    A_Mantissa = {1'b1,A[22:0]};
    A_Exponent = A[30:23];
    A_sign = A[31];

    B_Mantissa = {1'b1,B[22:0]};
    B_Exponent = B[30:23];
    B_sign = B[31];

    Temp_Exponent = A_Exponent + B_Exponent - 8'd127;
    Temp_Mantissa = A_Mantissa * B_Mantissa;

    Mantissa = Temp_Mantissa[47] ? Temp_Mantissa[46:24] :
                                   Temp_Mantissa[45:23];
    Exponent = Temp_Mantissa[47] ? Temp_Exponent + 1'b1 :
                                   Temp_Exponent;
    Sign = A_sign ^ B_sign;

    result = {Sign,Exponent,Mantissa};
end
endmodule

