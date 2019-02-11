module forwarding_unit (
    input [4:0] ID_EX_rs1,
    input [4:0] ID_EX_rs2,
    input [4:0] EX_MEM_rd,
    input       EX_MEM_regwrite,
    input [4:0] MEM_WB_rd,
    input       MEM_WB_regwrite,
    output reg [1:0] forwardA,
    output reg [1:0] forwardB
);
always @(ID_EX_rs1 or ID_EX_rs2 or EX_MEM_rd or EX_MEM_regwrite or MEM_WB_rd or MEM_WB_regwrite )
begin
    //Default:no forwarding
    forwardA = 2'b00;
    forwardB = 2'b00;
   //.....................Forward A.......................//
    if(EX_MEM_regwrite && (EX_MEM_rd !=5'b0) && (EX_MEM_rd == ID_EX_rs1))
        forwardA = 2'b10;       //from EX/MEM

    else if (MEM_WB_regwrite && (MEM_WB_rd !=5'b0) && (MEM_WB_rd == ID_EX_rs1 ))
        forwardA = 2'b01;       //from MEM/WB
        
    //......................Forward B.......................//
    if(EX_MEM_regwrite && (EX_MEM_rd !=5'b0) && (EX_MEM_rd == ID_EX_rs2 ))
        forwardB = 2'b10;       //from EX/MEM

    else if (MEM_WB_regwrite && (MEM_WB_rd !=5'b0) && (MEM_WB_rd == ID_EX_rs2))
        forwardB = 2'b01;       //from MEM/WB
end
endmodule



   
