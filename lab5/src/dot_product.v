// Implement a vector dot product of a and b
// using a single-port SRAM of 5-bit address width, 16-bit data width
module dot_product #(
  parameter ADDR_WIDTH = 5,
  parameter WIDTH = 32
) (
  input clk,
  input rst,
  input [ADDR_WIDTH:0] len,
  // input vector a
  input [WIDTH-1:0] a_data,
  input a_valid,
  output reg a_ready,
  // input vector b
  input [WIDTH-1:0] b_data,
  input b_valid,
  output reg b_ready,
  // dot product result c
  output [WIDTH-1:0] c_data,
  output reg c_valid,
  input c_ready
);
localparam STATE_READ = 2'd0;
localparam STATE_CALC_LOAD_A = 2'd1;
localparam STATE_CALC_LOAD_B = 2'd2;
localparam STATE_CALC_DONE = 2'd3;

wire a_fire, b_fire, c_fire;
assign a_fire = a_valid && a_ready;
assign b_fire = b_valid && b_ready;
assign c_fire = c_valid && c_ready;

reg we;
wire [3:0] wmask = 4'b1111;
reg [ADDR_WIDTH:0] addr;
reg [WIDTH-1:0] din;
wire [WIDTH-1:0] dout;

sram22_64x32m4w8 sram (
  .clk(clk),
  .we(we),
  .wmask(wmask),
  .addr(addr),
  .din(din),
  .dout(dout)
);

// TODO: fill in the rest of this module.

reg [1:0] state, next_state;
reg [ADDR_WIDTH:0] a_count, b_count;
reg [ADDR_WIDTH:0] calc_index;
reg [WIDTH-1:0] accumulator;
reg [WIDTH-1:0] a_reg;

assign c_data = accumulator;

always @(posedge clk) begin
  if (rst) begin
    state <= STATE_READ;
    a_count <= 0;
    b_count <= 0;
    calc_index <= 0;
    accumulator <= 0;
    a_reg <= 0;
    c_valid <= 1'b0;
  end else begin
    state <= next_state;
    
    case (state)
      STATE_READ: begin
        c_valid <= 1'b0;
        if (a_fire) a_count <= a_count + 1;
        if (b_fire) b_count <= b_count + 1;
        if (next_state == STATE_CALC_LOAD_A) begin
          calc_index <= 0;
          accumulator <= 0;
        end
      end
      
      STATE_CALC_LOAD_A: begin
        if (calc_index > 0) begin
          accumulator <= accumulator + (a_reg * dout);
        end
      end
      
      STATE_CALC_LOAD_B: begin
        a_reg <= dout;
        if (next_state == STATE_CALC_LOAD_A) begin
          calc_index <= calc_index + 1;
        end
      end
      
      STATE_CALC_DONE: begin
        if (!c_valid) begin
          accumulator <= accumulator + (a_reg * dout);
          c_valid <= 1'b1;
        end else if (c_fire) begin
          a_count <= 0;
          b_count <= 0;
          c_valid <= 1'b0;
        end
      end
    endcase
  end
end

always @(*) begin
  next_state = state;
  
  case (state)
    STATE_READ: begin
      if (a_count == len && b_count == len) begin
        next_state = STATE_CALC_LOAD_A;
      end
    end
    
    STATE_CALC_LOAD_A: begin
      next_state = STATE_CALC_LOAD_B;
    end
    
    STATE_CALC_LOAD_B: begin
      if (calc_index == len - 1) begin
        next_state = STATE_CALC_DONE;
      end else begin
        next_state = STATE_CALC_LOAD_A;
      end
    end
    
    STATE_CALC_DONE: begin
      if (c_fire) begin
        next_state = STATE_READ;
      end
    end
  endcase
end

always @(*) begin
  we = 1'b0;
  addr = 0;
  din = 0;
  a_ready = 1'b0;
  b_ready = 1'b0;

  case (state)
    STATE_READ: begin
      if (a_valid && a_count < len) begin
        we = 1'b1;
        addr = a_count;
        din = a_data;
        a_ready = 1'b1;
      end else if (b_valid && b_count < len) begin
        we = 1'b1;
        addr = (1 << ADDR_WIDTH) + b_count;
        din = b_data;
        b_ready = 1'b1;
      end
    end

    STATE_CALC_LOAD_A: begin
      addr = calc_index;
    end

    STATE_CALC_LOAD_B: begin
      addr = (1 << ADDR_WIDTH) + calc_index;
    end

    STATE_CALC_DONE: begin
      addr = 0;
    end
  endcase
end

// no writing during calcs
assert property (@(posedge clk) disable iff (rst)
  (state == STATE_CALC_LOAD_A || state == STATE_CALC_LOAD_B) |-> (we == 1'b0)
);

// output only good after calc done
assert property (@(posedge clk) disable iff (rst)
  c_valid |-> (state == STATE_CALC_DONE)
);

endmodule