/*module Flt(
input [31:0] read_data1,
input [31:0] read_data2,
output reg [31:0] ltdata_out,
input Flt_en
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

always@(*)
begin

case(Flt_en)
1'b1:

if(read_data1==read_data2)
   begin
   ltdata_out=32'b0;
   end

else if(sign1==0 && sign2==0)
begin
   if(exponent1<exponent2)
   	ltdata_out=32'b1;         //or 32'b0_01111111_00000000000000000000000
   else if(exponent1==exponent2)
     begin
       if(mantissa1<mantissa2)
         ltdata_out=32'b1;
       else
         ltdata_out=32'b0;
     end
   else
   ltdata_out=32'b0;
end
 
else if(sign1==1 && sign2==1)
begin
   if(exponent1<exponent2)                       
   ltdata_out=32'b0;
   else if(exponent1==exponent2)
     begin
       if(mantissa1<mantissa2)
         ltdata_out=32'b0;
       else
         ltdata_out=32'b1;
     end
   else
   ltdata_out=32'b1;
end

else if(sign1==0 && sign2==1)
   ltdata_out=32'b0;

else if(sign1==1 && sign2==0)
   ltdata_out=32'b1;

else
begin
     if(exponent1<exponent2)
   	ltdata_out=32'b1;
     else if(exponent1==exponent2)
     begin
       if(mantissa1<mantissa2)
         ltdata_out=32'b1;
       else
         ltdata_out=32'b0;
     end
     else
        ltdata_out=32'b0;
end
         
default:
    ltdata_out=32'b0;
endcase
end
endmodule*/

///////////////////////////////////////////////////////
module Flt(
    input  [31:0] read_data1,
    input  [31:0] read_data2,
    output reg [31:0] ltdata_out
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

always @(*) begin
    // default
    ltdata_out = 32'b0;

    if (read_data1 == read_data2) begin
        ltdata_out = 32'b0;
    end
    else if (sign1 == 0 && sign2 == 0) begin
        // both positive
        if (exponent1 < exponent2)
            ltdata_out = 32'b1;
        else if (exponent1 == exponent2) begin
            if (mantissa1 < mantissa2)
                ltdata_out = 32'b1;
            else
                ltdata_out = 32'b0;
        end
        else
            ltdata_out = 32'b0;
    end
    else if (sign1 == 1 && sign2 == 1) begin
        // both negative
        if (exponent1 < exponent2)
            ltdata_out = 32'b0;
        else if (exponent1 == exponent2) begin
            if (mantissa1 < mantissa2)
                ltdata_out = 32'b0;
            else
                ltdata_out = 32'b1;
        end
        else
            ltdata_out = 32'b1;
    end
    else if (sign1 == 0 && sign2 == 1) begin
        // positive < negative ? false
        ltdata_out = 32'b0;
    end
    else if (sign1 == 1 && sign2 == 0) begin
        // negative < positive ? true
        ltdata_out = 32'b1;
    end
end

endmodule
