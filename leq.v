/*module Fleq(
input [31:0]read_data1,
input [31:0]read_data2,
input Fleq_en,
output reg [31:0]leqdata_out
);

wire sign1,sign2;
wire [7:0] exponent1,exponent2;
wire [22:0] mantissa1,mantissa2;

assign sign1     = read_data1[31]; 
assign sign2     = read_data2[31];
assign exponent1 = read_data1[30:23];
assign exponent2 = read_data2[30:23];
assign mantissa1 = read_data1[22:0];
assign mantissa2 = read_data2[22:0];

parameter epsilon = 32'b0_01111000_01000111101011100001010;  //0.01    

always@(*)
begin

case(Fleq_en)
1'b1:

if(read_data1==read_data2)
   begin
   leqdata_out=32'b1;
   end

else if(sign1==0 && sign2==0)
begin
   if(exponent1 == exponent2)
      leqdata_out = (((mantissa1 - mantissa2) || (mantissa2 - mantissa1))<=epsilon)? 32'b1 : 32'b0;
   else if(exponent1 < exponent2)
      leqdata_out = 32'b1;
   else
      leqdata_out = 32'b0;        
end
 
else if(sign1==1 && sign2==1)
begin
   if(exponent1 == exponent2)
      leqdata_out = (((mantissa1 - mantissa2) || (mantissa2 - mantissa1))<=epsilon)? 32'b0 : 32'b1;
   else if(exponent1 < exponent2)
      leqdata_out = 32'b0;
   else
      leqdata_out = 32'b1;        
end

else if(sign1==0 && sign2==1)
   leqdata_out=32'b0;

else if(sign1==1 && sign2==0)
   leqdata_out = 32'b1;

else
begin
   if(exponent1 <= exponent2)
   	leqdata_out = (((mantissa1 - mantissa2) || (mantissa2 - mantissa1))<=epsilon)? 32'b1 : 32'b0;
   else
   leqdata_out=32'b0;
end
      
default:
    leqdata_out=32'b0;
endcase
end
endmodule*/



module Fleq (
    input  [31:0] read_data1,
    input  [31:0] read_data2,
    output reg [31:0] leqdata_out
);

wire        sign1, sign2;
wire [7:0]  exponent1, exponent2;
wire [22:0] mantissa1, mantissa2;

assign sign1     = read_data1[31];
assign sign2     = read_data2[31];
assign exponent1 = read_data1[30:23];
assign exponent2 = read_data2[30:23];
assign mantissa1 = read_data1[22:0];
assign mantissa2 = read_data2[22:0];

parameter epsilon = 32'b0_01111000_01000111101011100001010; // 0.01

always @(*) begin
    // default
    leqdata_out = 32'b0;

    if (read_data1 == read_data2) begin
        leqdata_out = 32'b1;
    end
    else if (sign1 == 0 && sign2 == 0) begin
        // both positive
        if (exponent1 == exponent2)
            leqdata_out =
                (((mantissa1 - mantissa2) || (mantissa2 - mantissa1)) <= epsilon)
                ? 32'b1 : 32'b0;
        else if (exponent1 < exponent2)
            leqdata_out = 32'b1;
        else
            leqdata_out = 32'b0;
    end
    else if (sign1 == 1 && sign2 == 1) begin
        // both negative
        if (exponent1 == exponent2)
            leqdata_out =
                (((mantissa1 - mantissa2) || (mantissa2 - mantissa1)) <= epsilon)
                ? 32'b0 : 32'b1;
        else if (exponent1 < exponent2)
            leqdata_out = 32'b0;
        else
            leqdata_out = 32'b1;
    end
    else if (sign1 == 0 && sign2 == 1) begin
        // positive <= negative ? false
        leqdata_out = 32'b0;
    end
    else if (sign1 == 1 && sign2 == 0) begin
        // negative <= positive ? true
        leqdata_out = 32'b1;
    end
    else begin
        if (exponent1 <= exponent2)
            leqdata_out =
                (((mantissa1 - mantissa2) || (mantissa2 - mantissa1)) <= epsilon)
                ? 32'b1 : 32'b0;
        else
            leqdata_out = 32'b0;
    end
end

endmodule
