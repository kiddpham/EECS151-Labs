`include "alu_op.vh"

module alu(
    input [31:0] a, b,
    input [3:0] alu_op,
    output [31:0] out
);

reg [31:0] result;

always @(*) begin
    case (alu_op)
        `ALU_ADD:   result = a + b;
        `ALU_SUB:   result = a - b;
        `ALU_AND:   result = a & b;
        `ALU_OR:    result = a | b;
        `ALU_XOR:   result = a ^ b;
        `ALU_SLT:   result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
        `ALU_SLTU:  result = (a < b) ? 32'd1 : 32'd0;
        `ALU_SLL:   result = a << b[4:0];
        `ALU_SRA:   result = $signed(a) >>> b[4:0];
        `ALU_SRL:   result = a >> b[4:0];
        `ALU_COPY_B: result = b;
        `ALU_XXX:   result = 32'd0;
        default:    result = 32'd0;
    endcase
end

assign out = result;

endmodule
