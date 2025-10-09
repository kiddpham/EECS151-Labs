`timescale 1ns/1ps
`include "alu_op.vh"

module alu_testbench;

reg signed [31:0] a, b;
reg [3:0] alu_op;
wire [31:0] out;

integer i;
integer pass_count = 0;
integer fail_count = 0;
reg signed [31:0] expected;

alu dut (
    .a(a),
    .b(b),
    .alu_op(alu_op),
    .out(out)
);

initial begin
    // ADD
    alu_op = `ALU_ADD;
    for (i = 0; i < 100; i = i + 1) begin
        a = $random;
        b = $random;
        expected = a + b;
        #1;
        if (out !== expected) begin
            $display("FAIL ADD: %0d + %0d got=%0d expected=%0d", a, b, out, expected);
            fail_count = fail_count + 1;
        end else pass_count = pass_count + 1;   
    end

    // SUB
    alu_op = `ALU_SUB;
    for (i = 0; i < 100; i = i + 1) begin
        a = $random;
        b = $random;
        expected = a - b;
        #1;
        if (out !== expected) begin
            $display("FAIL SUB: %0d - %0d got=%0d expected=%0d", a, b, out, expected);
            fail_count = fail_count + 1;
        end else pass_count = pass_count + 1;
    end

    // AND
    alu_op = `ALU_AND;
    for (i = 0; i < 100; i = i + 1) begin
        a = $random;
        b = $random;
        expected = a & b;
        #1;
        if (out !== expected) begin
            $display("FAIL AND: %b & %b got=%b expected=%b", a, b, out, expected);
            fail_count = fail_count + 1;
        end else pass_count = pass_count + 1;
    end

    // OR
    alu_op = `ALU_OR;
    for (i = 0; i < 100; i = i + 1) begin
        a = $random;
        b = $random;
        expected = a | b;
        #1;
        if (out !== expected) begin
            $display("FAIL OR: %b | %b got=%b expected=%b", a, b, out, expected);
            fail_count = fail_count + 1;
        end else pass_count = pass_count + 1;
    end

    // XOR
    alu_op = `ALU_XOR;
    for (i = 0; i < 100; i = i + 1) begin
        a = $random;
        b = $random;
        expected = a ^ b;
        #1;
        if (out !== expected) begin
            $display("FAIL XOR: %b ^ %b got=%b expected=%b", a, b, out, expected);
            fail_count = fail_count + 1;
        end else pass_count = pass_count + 1;
    end

    // SLT
    alu_op = `ALU_SLT;
    for (i = 0; i < 100; i = i + 1) begin
        a = $random;
        b = $random;
        expected = (a < b) ? 1 : 0;
        #1;
        if (out !== expected) begin
            $display("FAIL SLT: %0d < %0d got=%0d expected=%0d", a, b, out, expected);
            fail_count = fail_count + 1;
        end else pass_count = pass_count + 1;
    end

    // SLTU
    alu_op = `ALU_SLTU;
    for (i = 0; i < 100; i = i + 1) begin
        a = $random;
        b = $random;
        expected = ($unsigned(a) < $unsigned(b)) ? 1 : 0;
        #1;
        if (out !== expected) begin
            $display("FAIL SLTU: %0d < %0d got=%0d expected=%0d", $unsigned(a), $unsigned(b), out, expected);
            fail_count = fail_count + 1;
        end else pass_count = pass_count + 1;
    end

    // SLL
    alu_op = `ALU_SLL;
    for (i = 0; i < 100; i = i + 1) begin
        a = $random;
        b = $random;
        expected = a << b[4:0];
        #1;
        if (out !== expected) begin
            $display("FAIL SLL: %0d << %0d got=%0d expected=%0d", a, b[4:0], out, expected);
            fail_count = fail_count + 1;
        end else pass_count = pass_count + 1;
    end

    // SRA
    alu_op = `ALU_SRA;
    for (i = 0; i < 100; i = i + 1) begin
        a = $random;
        b = $random;
        expected = $signed(a) >>> b[4:0];
        #1;
        if (out !== expected) begin
            $display("FAIL SRA: %0d >>> %0d got=%0d expected=%0d", a, b[4:0], out, expected);
            fail_count = fail_count + 1;
        end else pass_count = pass_count + 1;
    end

    // SRL
    alu_op = `ALU_SRL;
    for (i = 0; i < 100; i = i + 1) begin
        a = $random;
        b = $random;
        expected = $unsigned(a) >> b[4:0];
        #1;
        if (out !== expected) begin
            $display("FAIL SRL: %0d >> %0d got=%0d expected=%0d", a, b[4:0], out, expected);
            fail_count = fail_count + 1;
        end else pass_count = pass_count + 1;
    end

    // COPY_B
    alu_op = `ALU_COPY_B;
    for (i = 0; i < 100; i = i + 1) begin
        a = $random;
        b = $random;
        expected = b;
        #1;
        if (out !== expected) begin
            $display("FAIL COPY_B: b=%0d got=%0d expected=%0d", b, out, expected);
            fail_count = fail_count + 1;
        end else pass_count = pass_count + 1;
    end

    // XXX
    alu_op = `ALU_XXX;
    for (i = 0; i < 100; i = i + 1) begin
        a = $random;
        b = $random;
        expected = 0;
        #1;
        if (out !== expected) begin
            $display("FAIL XXX: got=%0d expected=0", out);
            fail_count = fail_count + 1;
        end else pass_count = pass_count + 1;
    end

    $display("ALU TESTBENCH COMPLETE: %0d PASS, %0d FAIL", pass_count, fail_count);
    $finish;
end

endmodule
