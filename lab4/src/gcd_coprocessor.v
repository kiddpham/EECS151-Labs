//=========================================================================
// Template for GCD coprocessor
//-------------------------------------------------------------------------
//

module gcd_coprocessor #( parameter W = 16 ) (
  input clk,
  input reset,
  input operands_val,
  input [W-1:0] operands_bits_A,
  input [W-1:0] operands_bits_B,
  output operands_rdy,
  output result_val,
  output [W-1:0] result_bits,
  input result_rdy
);

  // Request FIFO signals
  wire             req_deq_val, req_deq_rdy;
  wire [2*W-1:0]   req_deq_bits;

  // Response FIFO signals
  wire             resp_deq_val;
  wire [W-1:0]     resp_deq_bits;

  // GCD datapath <-> control wires
  wire [W-1:0] gcd_A, gcd_B;
  wire [W-1:0] gcd_result_bits;
  wire         B_zero, A_lt_B;
  wire [1:0]   A_mux_sel;
  wire         B_mux_sel, A_en, B_en;
  wire         gcd_result_val, gcd_result_rdy;

  // Request FIFO (stores packed operands A||B)
  fifo #( .WIDTH(2*W), .LOGDEPTH(2) ) req_fifo (
    .clk(clk),
    .reset(reset),
    .enq_val(operands_val),
    .enq_data({operands_bits_A, operands_bits_B}),
    .enq_rdy(operands_rdy),

    .deq_val(req_deq_val),
    .deq_data(req_deq_bits),
    .deq_rdy(req_deq_rdy)
  );

  assign gcd_A = req_deq_bits[2*W-1:W];
  assign gcd_B = req_deq_bits[W-1:0];

  // Datapath
  gcd_datapath #( .W(W) ) datapath (
    .operands_bits_A(gcd_A),
    .operands_bits_B(gcd_B),
    .result_bits_data(gcd_result_bits),
    .clk(clk),
    .reset(reset),
    .B_mux_sel(B_mux_sel),
    .A_en(A_en),
    .B_en(B_en),
    .A_mux_sel(A_mux_sel),
    .B_zero(B_zero),
    .A_lt_B(A_lt_B)
  );

  // Control
  gcd_control control (
    .clk(clk),
    .reset(reset),
    .operands_val(req_deq_val),
    .result_rdy(gcd_result_rdy),
    .B_zero(B_zero),
    .A_lt_B(A_lt_B),
    .result_val(gcd_result_val),
    .operands_rdy(req_deq_rdy),
    .A_mux_sel(A_mux_sel),
    .B_mux_sel(B_mux_sel),
    .A_en(A_en),
    .B_en(B_en)
  );

  // Response FIFO (stores GCD result)
  fifo #( .WIDTH(W), .LOGDEPTH(2) ) resp_fifo (
    .clk(clk),
    .reset(reset),
    .enq_val(gcd_result_val),
    .enq_data(gcd_result_bits),
    .enq_rdy(gcd_result_rdy),

    .deq_val(result_val),
    .deq_data(result_bits),
    .deq_rdy(result_rdy)
  );

endmodule
