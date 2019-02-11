module float_conv_mux(
        input [31:0] add_out,
        input [31:0] sub_out,
        input [31:0] mul_out,
        input [31:0] div_out,
        input [31:0] sqt_out,
        input [31:0] min_out,
        input [31:0] max_out,
        input [31:0] lessthan_out,
        input [31:0] equal_out,
        input [31:0] lessthan_eq_out,
        input [31:0] conv_out,
        input [4:0]  alu_op,
        output reg [31:0] float_out);

    always@(add_out or sub_out or mul_out or div_out or sqt_out or min_out or max_out or lessthan_out or equal_out or lessthan_eq_out or conv_out or alu_op)
     begin
         
          case(alu_op)
             5'b00001 :  begin float_out = add_out; end
             5'b00010 : begin float_out = sub_out; end
             5'b00011 : begin float_out = mul_out; end
                    5'b00100 : begin float_out = div_out; end
                    5'b00101 : begin float_out = sqt_out; end
                    5'b00110 : begin float_out = min_out; end
                    5'b00111 : begin float_out = max_out; end
                    5'b01000 : begin float_out = equal_out; end
                    5'b01001 : begin float_out = lessthan_out; end
                    5'b01010 : begin float_out = lessthan_eq_out; end
                    5'b01110 : begin float_out = conv_out; end
                    default : begin float_out = 32'b0;end
                              endcase
     end
          endmodule
