module int_float_cvt (
    input  wire        cvt_en,
    input  wire        wb_fp_en,    // selects INT->FLOAT
    input  wire        wb_int_en,   // selects FLOAT->INT
    input  wire        is_unsigned,
    input  wire [31:0] rs1,
    output reg  [31:0] rd
);

    integer i;

    // INT -> FLOAT
    reg sign_i2f;
    reg [31:0] abs_val;
    reg [7:0]  exponent;
    reg [22:0] mantissa;
    reg [31:0] shifted;
    reg found;

    // FLOAT -> INT
    reg sign_f2i;
    reg [7:0] exp;
    reg [22:0] frac;
    reg [31:0] mantissa_f2i;
    reg [63:0] value;
    integer shift;

    always @(*) begin
        rd = 32'b0;
        found = 0;

        if (cvt_en) begin

            //----------------------------
            // INT -> FLOAT
            //----------------------------
            if (wb_fp_en) begin
                if (rs1 == 0) begin
                    rd = 32'b0;
                end else begin
                    if (!is_unsigned && rs1[31]) begin
                        sign_i2f = 1'b1;
                        abs_val  = -rs1;
                    end else begin
                        sign_i2f = 1'b0;
                        abs_val  = rs1;
                    end

                    for (i = 31; i >= 0; i = i - 1) begin
                        if (!found && abs_val[i]) begin
                            exponent = i + 127;
                            shifted  = abs_val << (31 - i);
                            found = 1;
                        end
                    end

                    mantissa = shifted[30:8];
                    rd = {sign_i2f, exponent, mantissa};
                end
            end

            //----------------------------
            // FLOAT -> INT
            //----------------------------
            else if (wb_int_en) begin
                sign_f2i = rs1[31];
                exp      = rs1[30:23];
                frac     = rs1[22:0];

                if (exp == 0 && frac == 0) begin
                    rd = 32'b0;
                end else begin
                    mantissa_f2i = {1'b1, frac};
                    shift = exp - 127;

                    if (shift >= 23)
                        value = mantissa_f2i << (shift - 23);
                    else if (shift >= 0)
                        value = mantissa_f2i >> (23 - shift);
                    else
                        value = 0;

                    if (!is_unsigned)
                        rd = sign_f2i ? -value[31:0] : value[31:0];
                    else
                        rd = sign_f2i ? 32'b0 : value[31:0];
                end
            end
        end
    end
endmodule


