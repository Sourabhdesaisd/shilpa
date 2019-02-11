
module fp_normalize_round_32bit (
    input  wire [31:0] alu_out,   // 32-bit IEEE-754 result from ALU
    input  wire [2:0]  rm,        // rounding mode
    input  wire [4:0]  alu_op,    // operation select
    output reg  [31:0] fp_out
);

    // --------------------------------------------------
    // Extract IEEE fields
    // --------------------------------------------------
    wire        sign_in;
    wire [7:0]  exp_in;
    wire [22:0] frac_in;

    assign sign_in = alu_out[31];
    assign exp_in  = alu_out[30:23];
    assign frac_in = alu_out[22:0];

    // --------------------------------------------------
    // Internal registers
    // --------------------------------------------------
    reg [27:0] mant_ext;   // [26:3]=mantissa, [2]=G, [1]=R, [0]=S
    reg [23:0] mant;       // hidden + 23 fraction
    reg [7:0]  exp;
    reg        round_up;

    // --------------------------------------------------
    // Combinational normalize + round
    // --------------------------------------------------
    always @(*) begin
        // Default (pass-through)
        fp_out   = alu_out;
        mant_ext = 28'b0;
        mant     = 24'b0;
        exp      = exp_in;
        round_up = 1'b0;

        // Apply rounding ONLY for FP arithmetic ops
        if (alu_op == 5'b00001 ||  // ADD
            alu_op == 5'b00010 ||  // SUB
            alu_op == 5'b00011 ||  // MUL
            alu_op == 5'b00100 ||  // DIV
            alu_op == 5'b00101 ||  // SQRT
            alu_op == 5'b01110)    // CONV
        begin
            // ------------------------------------------
            // Step 1: Add hidden bit, GRS = 000
            // ------------------------------------------
            mant_ext = {1'b1, frac_in, 3'b000};
            mant     = mant_ext[26:3];
            exp      = exp_in;

            // ------------------------------------------
            // Step 2: Rounding decision
            // ------------------------------------------
            case (rm)
                // RNE: Round to Nearest, ties to Even
                3'b000: round_up = mant_ext[2] &
                                   (mant_ext[1] | mant_ext[0] | mant[0]);

                // RTZ: Round toward Zero
                3'b001: round_up = 1'b0;

                // RDN: Round toward -Infinity
                3'b010: round_up = sign_in & (|mant_ext[2:0]);

                // RUP: Round toward +Infinity
                3'b011: round_up = ~sign_in & (|mant_ext[2:0]);

                // RMM: Round to Nearest, Max Magnitude
                3'b100: round_up = mant_ext[2];

                default: round_up = 1'b0;
            endcase

            // ------------------------------------------
            // Step 3: Apply rounding
            // ------------------------------------------
            if (round_up) begin
                mant = mant + 1'b1;

                // Mantissa overflow ? renormalize
                if (mant == 24'hFFFFFF) begin
                    mant = 24'h800000;
                    exp  = exp + 1'b1;
                end
            end

            // ------------------------------------------
            // Step 4: Pack IEEE-754 output
            // ------------------------------------------
            fp_out = {sign_in, exp, mant[22:0]};
        end
        else 
            fp_out = {sign_in,exp,mant[22:0]};
    end

endmodule    
