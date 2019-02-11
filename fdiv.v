/*module floating_div(
                       input  [31:0]operand_A           ,
                       input  [31:0]operand_B           ,
                       input        en                  ,
                       output reg   div_by_zero         , 
                       output reg   overflow            ,
                       output reg   underflow           ,
                       output reg [31:0]div_res  
                    );
  
  
   //// creating a sign , [7:0]exponent , [22:0]mantissa  bits for operand_A
  
  wire          sign_bit_a                 ;
  wire     [7:0]exponent_a                 ;
  wire     [22:0]mantissa_a                ;
  
  //// creating a sign , [7:0]exponent , [22:0]mantissa  bits for operand_B
  
  wire          sign_bit_b                 ;
  wire     [7:0]exponent_b                 ;
  wire     [22:0]mantissa_b                ;
  
  ////  reg to store hidden bit 
  reg      [23:0]mantissa_a_hidd           ;
  reg      [23:0]mantissa_b_hidd           ;
  
  /////  taking a parameter constant BIAS 
  parameter [7:0]bias = 8'd127             ;
  
   /////  register to store subtraction of exponents
  reg      [7:0]exponent_sub               ;
  reg           carry                      ;
  

  
  /////   to store mantissa division   
  reg      [23:0]mantissa_div              ;
  
  
   //// operand_A - extraction of sign , [7:0]exponent , [22:0]mantissa  bits
  
  assign sign_bit_a = operand_A[31]        ;
  assign exponent_a = operand_A[30:23]     ;
  assign mantissa_a = operand_A[22:0]      ;
  
   //// operand_B - extraction of sign , [7:0]exponent , [22:0]mantissa  bits
  
  assign sign_bit_b = operand_B[31]        ;
  assign exponent_b = operand_B[30:23]     ;
  assign mantissa_b = operand_B[22:0]      ;
  
  
  always@(*)
    begin
    // DEFAULT VALUES (fixes X / red lines)
    div_res     = 32'd0;
    div_by_zero = 1'b0;
    overflow    = 1'b0;
    underflow   = 1'b0; 
        
      
      if(en)
        begin
          
           /////  considering the hidden bit 1 for multiplication 
          mantissa_a_hidd = {1'b1 , mantissa_a};
          mantissa_b_hidd = {1'b1 , mantissa_b};
          
          if(operand_A == 32'd0)        ///////   if numerator is zero o/p is zero
            begin
              div_res = 32'd0 ;
            end
          
          else if(operand_B == 32'd0)   /////     if denominator is zero reporting div_by_zero error
            begin
              div_by_zero = 1'b1    ;
            end
          
          else                          /////     if none of the operands are zero normal division operation
            begin
              
              ///////////   doing sign bit 
              div_res[31] = sign_bit_a ^ sign_bit_b                      ;
              
              //////////    calculating exponent result  
              /////////     subtracting the exponents and adding bias value
                    
              exponent_sub = (exponent_a + (~exponent_b + 1'b1) )   ;
              
              if(exponent_a > exponent_b)
                begin
                  exponent_sub = bias + exponent_sub                ;
                end
              else 
                begin
                  exponent_sub = ( bias - (~exponent_sub + 1'b1) )  ;
                end
              
              
              
              
              ////////       reporting any overflow or underflow happening 
              if(exponent_a > exponent_b)
                begin
                  if(exponent_sub == 8'b11111111)
                    begin
                      overflow = 1'b1                                     ;
                    end
                  else
                    begin
                      overflow = 1'b0                                     ;
                    end
                end
              else if(exponent_a < exponent_b)
                begin
                  if(exponent_sub == 8'b11111111)
                    begin
                      underflow = 1'b1                                     ;
                    end
                  else
                    begin
                      underflow = 1'b0                                     ;
                    end
                end
                           
      /////////////   dividing the mantissa         
              
      mantissa_div = mantissa_a_hidd % mantissa_b_hidd                     ;
              
              
      //////////      final result        
              if(mantissa_div[23] == 1'b0)
                begin
              div_res = {div_res[31],exponent_sub,mantissa_div[22:0]}                    ;
                end 
              else 
                begin
                  div_res = {div_res[31],exponent_sub,mantissa_div[23:1]}                    ;  
                end
              
               
              
              
            end //// else block
          
        end    //// if block (en)
else
     div_res=32'b0;
      
    end        //// always block
  
endmodule*/


/////////////////////////////////////////////////
module FloatingAddition (input [31:0]A,
                         input [31:0]B,
                         input clk,
                         output reg  [31:0] result);

reg Sign;
reg [7:0] Exponent;
reg [22:0] Mantissa;

reg A_sign,B_sign,Temp_sign;
reg [7:0] A_Exponent,B_Exponent,Temp_Exponent,diff_Exponent;
reg [23:0] A_Mantissa,B_Mantissa,Temp_Mantissa;

reg carry,comp;
reg [7:0] exp_adjust;

always @(*)
begin
  
A_Mantissa = {1'b1,A[22:0]};
A_Exponent = A[30:23] ;
A_sign = A[31] ;
  
B_Mantissa = {1'b1,B[22:0]} ;
B_Exponent =  B[30:23] ;
B_sign =  B[31] ;

diff_Exponent = A_Exponent-B_Exponent;
B_Mantissa = (B_Mantissa >> diff_Exponent);
{carry,Temp_Mantissa} =  (A_sign ~^ B_sign)? A_Mantissa + B_Mantissa : A_Mantissa-B_Mantissa ; 
exp_adjust = A_Exponent;
if(carry)
    begin
        Temp_Mantissa = Temp_Mantissa>>1;
        exp_adjust = exp_adjust+1'b1;
    end
else
    begin
    while(Temp_Mantissa[23]==0)
        begin
           Temp_Mantissa = Temp_Mantissa<<1;
           exp_adjust =  exp_adjust-1'b1;
        end
    end
Sign = A_sign;
Mantissa = Temp_Mantissa[22:0];
Exponent = exp_adjust;
result = {Sign,Exponent,Mantissa};
end
endmodule

////////////////////////////////////////////////////////////////////////////

module FloatingMultiplication   (input [31:0]A,
                                 input [31:0]B,
                                 input clk,
                                 output reg  [31:0] result);


reg Sign;
reg [7:0] Exponent;
reg [22:0] Mantissa;

reg A_sign,B_sign;
reg [7:0] A_Exponent,B_Exponent,Temp_Exponent,diff_Exponent;
reg [23:0] A_Mantissa,B_Mantissa;
reg [47:0] Temp_Mantissa;

reg [6:0] exp_adjust;

always@(*)
begin
A_Mantissa = {1'b1,A[22:0]};
A_Exponent = A[30:23];
A_sign = A[31];
  
B_Mantissa = {1'b1,B[22:0]};
B_Exponent = B[30:23];
B_sign = B[31];

Temp_Exponent = A_Exponent+B_Exponent-127;
Temp_Mantissa = A_Mantissa*B_Mantissa;
Mantissa = Temp_Mantissa[47] ? Temp_Mantissa[46:24] : Temp_Mantissa[45:23];
Exponent = Temp_Mantissa[47] ? Temp_Exponent+1'b1 : Temp_Exponent;
Sign = A_sign^B_sign;
result = {Sign,Exponent,Mantissa};
end
endmodule


////////////////////////////////////////////////////////////


module FloatingDivision (input [31:0]A,
                         input [31:0]B,
                         input clk,
                         output [31:0] result);
                         
wire overflow,underflow;

reg Sign;
wire [7:0] exp;
reg [22:0] Mantissa;

reg A_sign,B_sign;
reg [23:0] A_Mantissa,B_Mantissa,Temp_Mantissa;
reg [7:0] A_Exponent,B_Exponent,Temp_Exponent,diff_Exponent;
wire [7:0] Exponent;

reg [7:0] A_adjust,B_adjust;

wire [31:0] temp1,temp2,temp3,temp4,temp5,temp6,temp7,debug;
wire [31:0] reciprocal;
wire [31:0] x0,x1,x2,x3;
reg [6:0] exp_adjust; 
reg en1,en2,en3,en4,en5;

//----Initial value----
FloatingMultiplication M1(.A({{1'b0,8'd126,B[22:0]}}),.B(32'h3ff0f0f1),.clk(clk),.result(temp1));
assign debug = {1'b1,temp1[30:0]};
FloatingAddition A1(.A(32'h4034b4b5),.B({1'b1,temp1[30:0]}),.clk(clk),.result(x0));

//----First Iteration----
FloatingMultiplication M2(.A({{1'b0,8'd126,B[22:0]}}),.B(x0),.clk(clk),.result(temp2));
FloatingAddition A2(.A(32'h40000000),.B({!temp2[31],temp2[30:0]}),.clk(clk),.result(temp3));
FloatingMultiplication M3(.A(x0),.B(temp3),.clk(clk),.result(x1));

//----Second Iteration----
FloatingMultiplication M4(.A({1'b0,8'd126,B[22:0]}),.B(x1),.clk(clk),.result(temp4));
FloatingAddition A3(.A(32'h40000000),.B({!temp4[31],temp4[30:0]}),.clk(clk),.result(temp5));
FloatingMultiplication M5(.A(x1),.B(temp5),.clk(clk),.result(x2));

//----Third Iteration----
FloatingMultiplication M6(.A({1'b0,8'd126,B[22:0]}),.B(x2),.clk(clk),.result(temp6));
FloatingAddition A4(.A(32'h40000000),.B({!temp6[31],temp6[30:0]}),.clk(clk),.result(temp7));
FloatingMultiplication M7(.A(x2),.B(temp7),.clk(clk),.result(x3));

//----Reciprocal : 1/B----
assign Exponent = x3[30:23]+8'd126-B[30:23];
assign reciprocal = {B[31],Exponent,x3[22:0]};

//----Multiplication A*1/B----
FloatingMultiplication M8(.A(A),.B(reciprocal),.clk(clk),.result(result));
endmodule



