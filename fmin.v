/*module fmin(read_data1,read_data2,Fmin_en,mindata_out);

input [31:0] read_data1,read_data2;
input Fmin_en;
output reg [31:0] mindata_out;


wire sign1,sign2;
wire [7:0] exponent1,exponent2;
wire [22:0] mantissa1,mantissa2;

wire nan_1, nan_2;
wire a_is_zero, b_is_zero;

assign sign1     = read_data1[31]; 
assign sign2     = read_data2[31];
assign exponent1 = read_data1[30:23];
assign exponent2 = read_data2[30:23];
assign mantissa1 = read_data1[22:0];
assign mantissa2 = read_data2[22:0];

    assign nan_1 = (exponent1 == 8'b11111111) && (mantissa1 != 0);
    assign nan_2 = (exponent2 == 8'b11111111) && (mantissa2 != 0);

    assign a_is_zero = (exponent1 == 8'b00000000) && (mantissa1 == 0);
    assign b_is_zero = (exponent2 == 8'b00000000) && (mantissa2 == 0);

always@(*)
begin

case(Fmin_en)
1'b1:

if (nan_1 || nan_2) 
mindata_out = {1'b1, 8'b11111111, 23'bxxxxxxxxxxxxxxxxxxxxxxx};

else if (a_is_zero && b_is_zero)                 
mindata_out = {sign1, 8'b00000000, 23'b00000000000000000000000};

else if(read_data1==read_data2)begin
   mindata_out=read_data1;
   end

else if(sign1==0 && sign2==0)
begin
   if(exponent1<exponent2)
   	mindata_out=read_data1;
   else if(exponent1==exponent2)
     begin
       if(mantissa1<mantissa2)
         mindata_out=read_data1;
       else
         mindata_out=read_data2;
     end
   else
   mindata_out=read_data2;
end
 
else if(sign1==1 && sign2==1)
begin
   if(exponent1<exponent2)                       
   mindata_out=read_data2;
   else if(exponent1==exponent2)
     begin
       if(mantissa1<mantissa2)
         mindata_out=read_data2;
       else
         mindata_out=read_data1;
     end
   else
   mindata_out=read_data1;
end

else if(sign1==0 && sign2==1)
   mindata_out=read_data2;

else if(sign1==1 && sign2==0)
   mindata_out=read_data1;

else
begin
     if(exponent1<exponent2)
   	mindata_out=read_data1;
     else if(exponent1==exponent2)
     begin
       if(mantissa1<mantissa2)
         mindata_out=read_data1;
       else
         mindata_out=read_data2;
     end
     else
        mindata_out=read_data2;
end
         
default:
    mindata_out=0;
endcase
end
endmodule*/


module fmin (
    input  [31:0] read_data1,
    input  [31:0] read_data2,
    output reg [31:0] mindata_out
);

wire        sign1, sign2;
wire [7:0]  exponent1, exponent2;
wire [22:0] mantissa1, mantissa2;

wire nan_1, nan_2;
wire a_is_zero, b_is_zero;

assign sign1     = read_data1[31];
assign sign2     = read_data2[31];
assign exponent1 = read_data1[30:23];
assign exponent2 = read_data2[30:23];
assign mantissa1 = read_data1[22:0];
assign mantissa2 = read_data2[22:0];

assign nan_1 = (exponent1 == 8'b11111111) && (mantissa1 != 0);
assign nan_2 = (exponent2 == 8'b11111111) && (mantissa2 != 0);

assign a_is_zero = (exponent1 == 8'b00000000) && (mantissa1 == 0);
assign b_is_zero = (exponent2 == 8'b00000000) && (mantissa2 == 0);

always @(*) begin
    // default
    mindata_out = 32'b0;

    if (nan_1 || nan_2) begin
        // NaN handling
        mindata_out = {1'b1, 8'b11111111, 23'bxxxxxxxxxxxxxxxxxxxxxxx};
    end
    else if (a_is_zero && b_is_zero) begin
        mindata_out = {sign1, 8'b00000000, 23'b00000000000000000000000};
    end
    else if (read_data1 == read_data2) begin
        mindata_out = read_data1;
    end
    else if (sign1 == 0 && sign2 == 0) begin
        // both positive
        if (exponent1 < exponent2)
            mindata_out = read_data1;
        else if (exponent1 == exponent2) begin
            if (mantissa1 < mantissa2)
                mindata_out = read_data1;
            else
                mindata_out = read_data2;
        end
        else
            mindata_out = read_data2;
    end
    else if (sign1 == 1 && sign2 == 1) begin
        // both negative
        if (exponent1 < exponent2)
            mindata_out = read_data2;
        else if (exponent1 == exponent2) begin
            if (mantissa1 < mantissa2)
                mindata_out = read_data2;
            else
                mindata_out = read_data1;
        end
        else
            mindata_out = read_data1;
    end
    else if (sign1 == 0 && sign2 == 1) begin
        // positive > negative ? negative is min
        mindata_out = read_data2;
    end
    else if (sign1 == 1 && sign2 == 0) begin
        // negative < positive ? negative is min
        mindata_out = read_data1;
    end
    else begin
        // fallback comparison
        if (exponent1 < exponent2)
            mindata_out = read_data1;
        else if (exponent1 == exponent2) begin
            if (mantissa1 < mantissa2)
                mindata_out = read_data1;
            else
                mindata_out = read_data2;
        end
        else
            mindata_out = read_data2;
    end
end

endmodule

