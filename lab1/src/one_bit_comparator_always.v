module one_bit_comparator_always (
    input a,
    input b,
    output reg greater,
    output reg less,
    output reg equal
);
    always @(*) begin
        if (a > b) begin // TODO
            greater = 1'b1;
	        less = 1'b0;
	        equal = 1'b0;
        end else if (a < b) begin // TODO
            greater = 1'b0;
	        less = 1'b1;
	        equal = 1'b0;
        end else begin
            greater = 1'b0;
	        less = 1'b0;
	        equal = 1'b1;
        end
    end
endmodule
