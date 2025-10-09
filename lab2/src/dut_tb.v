// Kidd Pham
// dut_tb.v
// 18 September 2025

module dut_tb();

    reg A, B, clk, rst;
    wire X, Z;

    initial clk = 0;
    always #5 clk = ~clk;

    dut myDUT (.A(A), .B(B), .clk(clk), .rst(rst), .X(X), .Z(Z));
    initial begin
	 $vcdpluson;
         A = 0; B = 0; rst = 1;
    
         #15 rst = 0;
	 #5 B = 1;
	 #2 A = 1;

	 #8 A = 0;

	 #10 B = 0;

         #40;
         $vcdplusoff;
         $finish;
    end 
endmodule
