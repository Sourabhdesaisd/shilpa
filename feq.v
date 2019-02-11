/*module Feq(
    input [31:0] read_data1,
    input [31:0] read_data2,
    input Feq_en,
    output reg [31:0] eqdata_out
);

parameter epsilon = 32'b0_01111000_01000111101011100001010;  //0.01    

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
    if (Feq_en)
    begin
        if (read_data1 == read_data2)
            eqdata_out = 32'b1;
        else
        begin
            if (sign1 == sign2)
            begin
                if (exponent1 == exponent2)
                    eqdata_out = (((mantissa1 - mantissa2) || (mantissa2 - mantissa1)) <= epsilon) ? 32'b1 : 32'b0;
                else
                    eqdata_out = 32'b0;
                 
             end
            else
                eqdata_out = 32'b0;
        end
    end
    else
        eqdata_out = 32'b0;
end
endmodule*/

module Feq(
    input  [31:0] read_data1,
    input  [31:0] read_data2,
    output reg [31:0] eqdata_out
);

parameter epsilon = 32'b0_01111000_01000111101011100001010; // 0.01

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
    if (read_data1 == read_data2) begin
        eqdata_out = 32'b1;
    end
    else begin
        if (sign1 == sign2) begin
            if (exponent1 == exponent2) begin
                eqdata_out = (((mantissa1 - mantissa2) ||
                               (mantissa2 - mantissa1)) <= epsilon)
                               ? 32'b1 : 32'b0;
            end
            else begin
                eqdata_out = 32'b0;
            end
        end
        else begin
            eqdata_out = 32'b0;
        end
    end
end

endmodule




