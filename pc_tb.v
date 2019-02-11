
module tb_pc_block;

    reg clk;
    reg rst;
    wire [31:0] pc;
    pc_block dut (
        .clk(clk),
        .rst(rst),
        .pc(pc)
    );

    // 10 ns clock
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;

        // Hold reset for 2 cycles
        #20 rst = 0;

        // Run long enough to see all 20 PC values
        #500 $finish;
    end

    initial begin
        $display("Time(ns)\tPC,next_pc");
        $monitor("%0t\t\t%0d", $time, pc);
    end
    initial begin
    
$shm_open("pc.shm") ;
$shm_probe("ACTMF");
end

endmodule

