module p_e (
    input [7:0] in,
    output reg [2:0] out,
    output reg valid
);

always @(*) begin
    valid = |in;  // valid is high if any input is high
    casex (in)
        8'b1xxxxxxx: out = 3'd7;
        8'b01xxxxxx: out = 3'd6;
        8'b001xxxxx: out = 3'd5;
        8'b0001xxxx: out = 3'd4;
        8'b00001xxx: out = 3'd3;
        8'b000001xx: out = 3'd2;
        8'b0000001x: out = 3'd1;
        8'b00000001: out = 3'd0;
        default:     out = 3'd0; // don't care, since valid=0
    endcase
end

endmodule
