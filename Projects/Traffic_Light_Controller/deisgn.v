module tlc(t,clkdiv,R,G,O);

input [3:0]t;
input clkdiv;
output reg [3:0] R,G,O;

reg r,g,o;
reg next;

reg [1:0] state_side;
parameter side1=2'b00,side2=2'b01,side3=2'b10,side4=2'b11;

initial begin
state_side= 2'b0; 
next=1; 
r=0; 
g=0; 
o=0;
end
always@(posedge clkdiv)
begin
if(next)
begin
case(state_side)
side1:  if (t[1]==1'b1)
        state_side <= side2;
        else if (t[2]==1'b1)
        state_side <= side3;
        else if (t[3]==1'b1)
        state_side <= side4;
        else if (t[0]==1'b1)
        state_side <= side1;
           
side2:  if (t[2]==1'b1)
        state_side <= side3;
        else if (t[3]==1'b1)
        state_side <= side4;
        else if (t[0]==1'b1)
        state_side <= side1;
        else if (t[1]==1'b1)
        state_side <= side2;
side3:  if (t[3]==1'b1)
        state_side <= side4;
        else if (t[0]==1'b1)
        state_side <= side1;
        else if (t[1]==1'b1)
        state_side <= side2;
        else if (t[2]==1'b1)
        state_side <= side3;
side4:  if (t[0]==1'b1)
        state_side <= side1;
        else if (t[1]==1'b1)
        state_side <= side2;
        else if (t[2]==1'b1)
        state_side <= side3;
        else if (t[3]==1'b1)
        state_side <= side4;
endcase
end
end

reg [5:0]count= 0;

always@(posedge clkdiv)
begin
count <= count+1;
if (count<6'd50)
begin
next<=0;
g<=1;
o<=0;
end
else if(count<6'd55)
begin
g<=0;
o<=1;
next<=0;
end
else if(count>=6'd56)
begin
count <= 0;
next<=1;
g<=1;
o<=0;
end
end

always @(*) begin
    G = g ? (4'b0001 << state_side) : 4'b0000;
    O = o ? (4'b0001 << state_side) : 4'b0000;
    R = ~(G | O);
end


endmodule
