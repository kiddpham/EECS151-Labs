module shift_register_structural (
    input in,
    input clk,
    output [3:0] out
);
    wire Q1, Q2, Q3, Q4;
    wire Q1n, Q2n, Q3n, Q4n;

    d_flip_flop dff_1(in, clk, Q1, Q1n); // TODO
    d_flip_flop dff_2(Q1, clk, Q2, Q2n); // TODO
    d_flip_flop dff_3(Q2, clk, Q3, Q3n); // TODO
    d_flip_flop dff_4(Q3, clk, Q4, Q4n); // TODO

    assign out = {Q4, Q3, Q2, Q1}; // TODO
endmodule
