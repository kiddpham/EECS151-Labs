module simple_counter (
    input clk,
    input reset,
    output [1:0] counter_out
);
    reg [1:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 2'b00;
        end else begin
            case (count)
                2'b00: count <= 2'b01;
                2'b01: count <= 2'b10;
                2'b10: count <= 2'b11;
                2'b11: count <= 2'b00;
            endcase
        end
    end

    assign counter_out = counter; // TODO
endmodule
