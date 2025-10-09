`timescale 1 ns / 100 ps

module divider_testbench;

  localparam integer WIDTH = 4;

  reg  clk = 0;
  always #5 clk = ~clk;

  reg  start;
  reg  [WIDTH-1:0] dividend, divisor;
  wire [WIDTH-1:0] quotient, remainder;
  wire done;

  divider #(.WIDTH(WIDTH)) div_dut (
    .clk(clk),
    .start(start),
    .done(done),
    .dividend(dividend),
    .divisor(divisor),
    .quotient(quotient),
    .remainder(remainder)
  );

  always @(posedge clk) begin
    $display("t=%0t  start=%0b done=%0b  dividend=%0d divisor=%0d  q=%0d r=%0d",
             $time, start, done, dividend, divisor, quotient, remainder);
  end

  initial begin
    $vcdpluson;

    start = 0; 
    dividend = 0;
    divisor = 1;

    repeat (2) @(posedge clk);
    start = 1; 
    dividend = 7; 
    divisor = 2;
    @(posedge clk) start = 0;
    @(posedge done);
    if (quotient !== (7/2) || remainder !== (7%2)) begin
      $display("FAIL: 7/2  got q=%0d r=%0d", quotient, remainder); $stop;
    end

    @(posedge clk);
    start = 1; 
    dividend = 7; 
    divisor = 7;
    @(posedge clk) start = 0;
    @(posedge done);
    if (quotient !== (7/7) || remainder !== (7%7)) begin
      $display("FAIL: 7/7 got q=%0d r=%0d", quotient, remainder); $stop;
    end

    @(posedge clk);
    $vcdplusoff;
    $finish;
  end

endmodule