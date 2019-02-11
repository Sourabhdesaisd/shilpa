module forwarding_mux (
    input [31:0] rs_data,
    input [31:0] ex_data,
    input [31:0] wb_data,
    input [1:0]  sel,
    output reg [31:0] forw_out
);
 
always @( rs_data or ex_data or wb_data or sel)
begin
    case(sel)
        2'b00:forw_out = rs_data;
        2'b01:forw_out = ex_data;
        2'b10:forw_out = wb_data;
        default:forw_out = 32'h0000;
    endcase
end
endmodule




