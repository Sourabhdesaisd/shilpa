module decoder ( 
		input [31:0] instruction,
		output reg [4:0] rs1_addr,
		output reg [4:0] rs2_addr,
		output reg [4:0] rd_addr,
		output reg [4:0] falu_opcode,
		output reg [4:0] func5,
		output reg [6:0] opcode,
		output reg [31:0] load_imm,
		output reg [2:0] load_width,
		output reg [2:0] store_width,
		output reg [31:0] store_imm,
		output reg [2:0] rm,
		output reg [1:0] fmt
		);

	always@(instruction)
	begin
			
		rs1_addr=5'b0000; 	
                rs2_addr = 5'b0;
                rd_addr = 5'b0;
                falu_opcode = 5'b0;
                func5 = 5'b0;
                opcode = 7'b0;
                 load_imm = 32'b0;
                load_width = 3'b0;
                store_width = 3'b0;
                 store_imm = 32'b0;
		rm = 3'b0;
		fmt = 2'b0;

			case({instruction[6:0]})
				
				7'b1010011 : begin  //////////////////////////////////////////R-Type,MOVE,COMAPARE,CONVER//////////////////////////////////
						//	rs1_addr = instruction[19:15];
						//	rs2_addr = instruction[24:20];
						//	rd_addr  = instruction[11:7];
						//	func5    = instruction[31:27];
						//	opcode 	 = instruction[6:0];
						//	rm 	 = instruction[14:12];
						//	fmt      = instruction[26:25];      
							
						    case(instruction[31:27])
							 5'b00000 : begin falu_opcode = 5'b00001; end ///////////////Fadd///////////////
							 5'b00001 : begin falu_opcode = 5'b00010; end ///////////////Fsub///////////////
							 5'b00010 : begin falu_opcode = 5'b00011; end ///////////////Fmul///////////////
							 5'b00011 : begin falu_opcode = 5'b00100; end ///////////////Fdiv//////////////
							 5'b00100 : begin falu_opcode = 5'b00101; end ///////////////Fsqt//////////////
							 5'b00101 : begin falu_opcode = 5'b00110; end ///////////////Fmin/////////////
							 5'b00110 : begin falu_opcode = 5'b00111; end ///////////////Fmax//////////////
							 5'b10100 : begin falu_opcode = 5'b01000; end ///////////////Feq//////////////
							 5'b10101 : begin falu_opcode = 5'b01001; end ///////////////Flt//////////////
							 5'b10110 : begin falu_opcode = 5'b01010; end///////////////u/Fle/////////////
									default : begin falu_opcode = 5'bxxxxx;end
						    endcase														    					   end
				7'b0000111 : begin   //////////////////////////////////////////Load/////////////////////////////////////////////////////////////
						
						//	rs1_addr = instruction[19:15];
						//	rd_addr  = instruction[11:7];
						//	opcode   = instruction[6:0];
							load_imm = {{20{instruction[31]}},instruction[31:20]};
							load_width = instruction[14:12];   
					     end 
				7'b0100111 : begin  /////////////////////////////////////////Store///////////////////////////////////////////////////////////////
						//	rs2_addr = instruction[24:20];
						//	rs1_addr = instruction[19:15];
							store_width = instruction[14:12];
							store_imm = {{20{instruction[31]}},{instruction[31:25],instruction[11:7]}};
						//	opcode = instruction[6:0];
					
					     end
						default :begin //rs1_addr  = 5'd0;
			                                  //     rs2_addr =  5'd0;
		                            		   	//rd_addr  = 5'd0;
		                                               falu_opcode = 5'd0;
	                                              //    	 func5 = 5'd0;
                                                    // 		opcode= 7'd0;
                                                                load_imm = 32'd0;
                                                               load_width = 3'd0;
                                                               store_width = 3'd0;
                                                                store_imm  = 32'd0;
							 end
				endcase
		end
endmodule
