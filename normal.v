/*module fp_normalize_round (
    input  wire        sign_in,
    input  wire [7:0]  exp_in,
    input  wire [26:0] mant_in,   // [26:3]=mantissa, [2]=G, [1]=R, [0]=S
    output reg  [31:0] fp_out
);

    reg [7:0]  exp;
    reg [24:0] mant;     // includes hidden bit
    reg guard, round, sticky;
    reg round_up;

    integer i;

    always @(*) begin
        exp  = exp_in;
        mant = mant_in[26:2];   // take main mantissa
        guard  = mant_in[2];
        round  = mant_in[1];
        sticky = mant_in[0];

        // -----------------------------
        // NORMALIZATION
        // -----------------------------

        // Case 1: overflow (e.g., 10.xxxx)
        if (mant[24]) begin
            mant = mant >> 1;
            exp  = exp + 1;
        end

        // Case 2: leading zeros (e.g., 0.0xxxx)
        else begin
            while (mant[23] == 0 && exp > 0) begin
                mant = mant << 1;
                exp  = exp - 1;
            end
        end

        // -----------------------------
        // ROUNDING (RNE)
        // -----------------------------

        round_up = guard & (round | sticky | mant[0]);

        if (round_up) begin
            mant = mant + 1'b1;

            // mantissa overflow due to rounding
            if (mant[24]) begin
                mant = mant >> 1;
                exp  = exp + 1;
            end
        end

        // -----------------------------
        // PACK RESULT
        // -----------------------------
        fp_out = {sign_in, exp, mant[22:0]};
    end
endmodule*/

////////////////////////////////////////////////////////////////

module fp_normalize_round (
    input  wire        sign_in,
    input  wire [7:0]  exp_in,
    input  wire [27:0] mant_in,   // includes GRS bits [26:3]=mant, [2]=G, [1]=R, [0]=S
    input  wire [2:0]  rm,         // rounding mode
    output reg  [31:0] fp_out
);

    reg  [7:0]  exp;
    reg  [23:0] mant;
    reg         round_up;

    always @(*) begin
        exp  = exp_in;
        mant = mant_in[26:3]; // drop GRS initially

        // ---------------------------
        // Rounding decision
        // ---------------------------
        case (rm)
            3'b000: // RNE
                round_up = mant_in[2] & (mant_in[1] | mant_in[0] | mant[0]);

            3'b001: // RTZ
                round_up = 1'b0;

            3'b010: // RDN
                round_up = sign_in & (|mant_in[2:0]);

            3'b011: // RUP
                round_up = ~sign_in & (|mant_in[2:0]);

            3'b100: // RMM
                round_up = mant_in[2];

            default:
                round_up = 1'b0;
        endcase

        // ---------------------------
        // Apply rounding
        // ---------------------------
        if (round_up) begin
            mant = mant + 1'b1;
            if (mant == 24'h1000000) begin
                mant = 24'h800000;
                exp  = exp + 1'b1;
            end
        end

        // ---------------------------
        // Pack IEEE-754
        // ---------------------------
        fp_out = {sign_in, exp, mant[22:0]};
    end
endmodule

