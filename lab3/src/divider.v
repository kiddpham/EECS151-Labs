`include "/home/ff/eecs151/verilog_lib/EECS151.v"

module divider #(
    parameter WIDTH = 4
) (
  input clk,

  input start,
  output reg done,

  input [WIDTH-1:0] dividend,
  input [WIDTH-1:0] divisor,
  output reg [WIDTH-1:0] quotient,
  output reg [WIDTH-1:0] remainder
);

  reg [WIDTH-1:0] dividend_reg;
  reg [WIDTH-1:0] divisor_reg;
  reg [WIDTH:0] remainder_work;
  reg [WIDTH-1:0] quotient_work;
  localparam integer CW = $clog2(WIDTH+1);
  reg [CW-1:0] count;
  reg busy;

  reg [WIDTH:0] cat;
  reg [WIDTH:0] trial;
  
  // Initialize registers to make sure there is no unknown state
  initial begin
    busy = 1'b0;
    done = 1'b0;
    dividend_reg = {WIDTH{1'b0}};
    divisor_reg = {WIDTH{1'b0}};
    remainder_work = {(WIDTH+1){1'b0}};
    quotient_work = {WIDTH{1'b0}};
    count = {CW{1'b0}};
    quotient = {WIDTH{1'b0}};
    remainder = {WIDTH{1'b0}};
  end

  always @(posedge clk) begin
    done <= 1'b0;
    if (!busy) begin
      if (start) begin
	      dividend_reg   <= dividend;
        divisor_reg <= divisor;
        remainder_work <= {(WIDTH+1){1'b0}};
        quotient_work <= {WIDTH{1'b0}};
        count <= WIDTH;
        busy <= 1'b1;
      end
    end else begin
      if ( {remainder_work[WIDTH-1:0], dividend_reg[WIDTH-1]} >= {1'b0, divisor_reg} ) begin
        remainder_work <= ({remainder_work[WIDTH-1:0], dividend_reg[WIDTH-1]} - {1'b0, divisor_reg});
        quotient_work <= {quotient_work[WIDTH-2:0], 1'b1};
      end else begin
        remainder_work <= {remainder_work[WIDTH-1:0], dividend_reg[WIDTH-1]};
        quotient_work <= {quotient_work[WIDTH-2:0], 1'b0};
      end

      dividend_reg <= {dividend_reg[WIDTH-2:0], 1'b0};
      count <= count - 1'b1;

      if (count == 1) begin
        cat = {remainder_work[WIDTH-1:0], dividend_reg[WIDTH-1]};
        if (cat >= {1'b0, divisor_reg} ) begin
          quotient <= {quotient_work[WIDTH-2:0], 1'b1};
          trial = cat - {1'b0, divisor_reg};
          remainder <= trial[WIDTH-1:0];
        end else begin
          quotient <= {quotient_work[WIDTH-2:0], 1'b0};
          remainder <= cat[WIDTH-1:0];
        end
        busy <= 1'b0;
        done <= 1'b1;
      end
    end
  end
endmodule
