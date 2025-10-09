module decoder_4_to_16 (
    input [3:0] addr,
    output [15:0] one_hot
);
    generate
        genvar i;
        for (i = 0; i < 16; i = i + 1) begin // TODO
            line_decoder ld (
                .select(i[3:0]), // TODO
                .addr(addr), // TODO
                .single_wire(one_hot[i]) // TODO
            );
        end
    endgenerate
endmodule
