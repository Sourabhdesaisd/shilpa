module control_unit(
			input [6:0] opcode,
			input [4:0] func5,
			output reg [1:0]  ir_mux,
			output reg mwr,
		    output reg b_mux,
			output reg werf,
			output reg move_en,
			output reg move_dir,
			output reg cvt_en,
			output reg is_unsigned,
            output reg wb_sel,
            output reg wb_fp_en,
            output reg wb_int_en
            
			
		   );


always@(opcode or func5)


			begin
					
				 mwr = 1'b0;
                                 b_mux = 1'b0;
                                 werf = 1'b0;
                                 move_en = 1'b0;
                                 move_dir = 1'b0;
                                 cvt_en = 1'b0;
                                 is_unsigned =1'b0;
                                 wb_sel = 1'b0;
                                 wb_fp_en  = 1'b0;
                                 wb_int_en = 1'b0;
                                 

			      case(opcode)
				   7'b1010011 : ////////////////////////////////////////////////////////R TYPE , MOVE,
						begin
						ir_mux = 2'b10; ////after alu mux
						mwr    = 1'b0;  ///data_mux_write_en
						b_mux  = 1'b0;  ///after_data_memory_data_move to register file
						werf   = 1'b1; // register write enable
						case(func5)
						     5'b11101 : begin move_en = 1'b1; //////////////////////////Move//////////////////////
								      move_dir = 1'b1;
								      cvt_en   = 1'b0;
								      is_unsigned = 1'b0;
                                      wb_fp_en  = 1'b0;
                                      wb_int_en = 1'b1;
                                  end
						     5'b11110 : begin move_en = 1'b1;
								      move_dir = 1'b0; 
									cvt_en   = 1'b0;
								      is_unsigned = 1'b0;
                                       wb_fp_en  = 1'b1;
                                      wb_int_en = 1'b0;
                                  
                               end
						     5'b11100 : begin cvt_en = 1'b1; ////////////////////conversion/////////////
								      move_dir = 1'b0; 
								      move_en =1'b0;
								      is_unsigned = 1'b0;
                                   wb_fp_en  = 1'b1;
                                 wb_int_en = 1'b0;end
						     5'b11111 : begin cvt_en =1'b1;								      	
									is_unsigned = 1'b1;
									move_en = 1'b0;
									move_dir =1'b0; 
                                 wb_fp_en  = 1'b0;
                                 wb_int_en = 1'b1;end 
							default : begin
									move_en = 1'b0;
									move_dir =1'b0;
									cvt_en=1'b0;
									is_unsigned =1'b0;
                                wb_sel = 1'b0;
                                   wb_fp_en  = 1'b1;
                                   wb_int_en = 1'b0;end
                                

						endcase
						end
				  7'b0000111 : begin
	
						ir_mux = 2'b01; ////after alu mux
						mwr    = 1'b1;  ///data_mux_write_en
						b_mux  = 1'b1;  ///after_data_memory_data_move to register file
						werf   = 1'b1; // register write enable
                        wb_sel = 1'b1;
                         wb_fp_en  = 1'b1;
                         wb_int_en = 1'b0;

					      end
				 7'b0100111 : begin
						ir_mux = 2'b00; ////after alu mux
						mwr    = 1'b1;  ///data_mux_write_en
						b_mux  = 1'b0;  ///after_data_memory_data_move to register file
						werf   = 1'b0; // register write enable
                        wb_sel = 1'b0;
                         wb_fp_en  = 1'b0;
                        wb_int_en = 1'b0;
					      end 
					default : begin
								   	mwr = 1'b0;
									b_mux = 1'b0;
									werf = 1'b0;
									ir_mux=2'b00;
                                    wb_sel = 1'b0;
                                    wb_fp_en  = 1'b0;
                                    wb_int_en = 1'b0;
						   end
				
				endcase
			end
endmodule
