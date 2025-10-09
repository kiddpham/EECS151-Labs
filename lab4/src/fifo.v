//=========================================================================
// FIFO Implementation
//-------------------------------------------------------------------------

module fifo #(parameter WIDTH = 8, parameter LOGDEPTH = 3) (
    input clk,
    input reset,

    input enq_val,
    input [WIDTH-1:0] enq_data,
    output enq_rdy,

    output deq_val,
    output [WIDTH-1:0] deq_data,
    input deq_rdy
);

localparam DEPTH = (1 << LOGDEPTH);

// the buffer itself
reg [WIDTH-1:0] buffer [0:DEPTH-1];
// read pointer, write pointer
reg [LOGDEPTH-1:0] rptr, wptr;
// is the buffer full? This is needed for when rptr == wptr
reg full;

// fire wires
wire enq_fire;
wire deq_fire;

assign enq_fire = enq_val & enq_rdy;
assign deq_fire = deq_val & deq_rdy;

assign enq_rdy  = !full;
assign deq_val  = (rptr != wptr) || full;
assign deq_data = buffer[rptr];

always @(posedge clk or posedge reset) begin
  if (reset) begin
    rptr <= 0;
    wptr <= 0;
    full <= 1'b0;
  end else begin
    if (enq_fire) begin
      buffer[wptr] <= enq_data;
      wptr <= wptr + 1'b1;
    end

    if (deq_fire) begin
      rptr <= rptr + 1'b1;
    end

    if (enq_fire && !deq_fire) begin
      full <= ((wptr + 1'b1) == rptr);
    end else if (deq_fire && !enq_fire) begin
      full <= 1'b0;
    end
  end
end

endmodule
