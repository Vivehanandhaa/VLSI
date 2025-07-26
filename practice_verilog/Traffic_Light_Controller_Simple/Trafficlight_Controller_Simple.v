// Code your design here
module design_TLC(
clk, light
    );
 input clk;
 output reg [2:0]light;
 
 parameter s0 =2'b00; //red
 parameter s1 =2'b01; //yellow
 parameter s2 =2'b10; //green
 
 parameter red=3'b001, yellow=3'b010, green=3'b100;
 reg [1:0]state;
 
 always @(posedge clk)
 begin 
 case(state)
    s0: state <= s1;
    s1: state <= s2;
    s2: state <= s0;
    default: state<=s0; 
 endcase
 end
 
 always@(state)
 begin 
 case(state)
 s0: light= red;
 s1: light= yellow;
 s2: light= green;
 
endcase
end

    
endmodule
