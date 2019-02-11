module ripplecarryadder_32bit (
    input  [31:0] a,
    input  [31:0] b,
    input         cin,
    output [31:0] sum
);

    wire [31:0] c;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : FA_GEN
            if (i == 0) begin
                fulladder FA (
                    .sum(sum[i]),
                    .carry(c[i]),
                    .a(a[i]),
                    .b(b[i]),
                    .cin(cin)
                );
            end else begin
                fulladder FA (
                    .sum(sum[i]),
                    .carry(c[i]),
                    .a(a[i]),
                    .b(b[i]),
                    .cin(c[i-1])
                );
            end
        end
    endgenerate

endmodule



module fulladder(sum, carry, a, b, cin);

output sum;
output carry;
input  a, b, cin;

assign sum   = a ^ b ^ cin;
assign carry = (a & b) | (b & cin) | (a & cin);

endmodule
