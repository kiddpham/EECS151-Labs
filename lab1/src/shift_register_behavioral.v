module shift_register_behavioral (
    input in,
    input clk,
    output [3:0] out
);
    reg [3:0] shift_reg;

    always @(posedge clk) begin
       shift_reg <= {shift_reg[2:0], in}; // TODO: See operators described in literals section
    end

    assign out = shift_reg; // TODO
endmodule
