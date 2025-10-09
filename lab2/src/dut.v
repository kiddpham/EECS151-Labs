// Kidd Pham
// dut.v
// 18 September 2025

module dut (
  input A, B, clk, rst,
  output reg X, Z
);
    wire tmp;

    REGISTER_R #(.N(1)) delay_step0 (.clk(clk), .rst(rst), .d(B), .q(X));
    REGISTER_R #(.N(1)) delay_step1 (.clk(clk), .rst(rst), .d(tmp), .q(Z));

    assign tmp = (Z & X) | A;
  
endmodule
