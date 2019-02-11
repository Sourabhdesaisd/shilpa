module mem_wb_pipeline (
    input  wire        clk,
    input  wire        rst,

    // Inputs from MEM stage
    input  wire [31:0] mem_data_in,
    input  wire [31:0] ex_result_in,
    input  wire [4:0]  rd_in,
    input  wire        werf_in,
    input  wire wb_sel_in,
    

    // Outputs to WB stage
    output reg  [31:0] mem_data_out,
    output reg  [31:0] ex_result_out,
    output reg  [4:0]  rd_out,
    output reg         werf_out,
    output reg  wb_sel_out
    
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mem_data_out  <= 32'b0;
            ex_result_out <= 32'b0;
            rd_out        <= 5'b0;
            werf_out      <= 1'b0;
            wb_sel_out <= 1'b0;
            
        end 
        else begin
            mem_data_out  <= mem_data_in;
            ex_result_out <= ex_result_in;
            rd_out        <= rd_in;
            werf_out      <= werf_in;
            wb_sel_out <= wb_sel_in;
            
        end
    end
endmodule

