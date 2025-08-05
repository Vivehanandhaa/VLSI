    `timescale 1ns / 1ps
    //////////////////////////////////////////////////////////////////////////////////
    // Company: 
    // Engineer: 
    // 
    // Create Date: 26.07.2025 10:50:37
    // Design Name: 
    // Module Name: Design_TLC
    // Project Name: 
    // Target Devices: 
    // Tool Versions: 
    // Description: 
    // 
    // Dependencies: 
    // 
    // Revision:
    // Revision 0.01 - File Created
    // Additional Comments:
    // 
    //////////////////////////////////////////////////////////////////////////////////
    /*
    module clock_divider (
        input wire clk,      // 5 MHz input clock
        output reg clk_div     // 1 Hz output clock
    );
        
        reg [21:0] count = 0;  
    
        always @(posedge clk) begin
            if (count == 2499999) begin
                count <= 0;
                clk_div <= ~clk_div; 
            end else begin
                count <= count + 1;
            end
        end
    endmodule
    */
    module clkdiv(input clk, output reg clk_div);
     reg [22:0] count = 0;  
    
        always @(posedge clk) begin
            if (count == 4999999) begin // assuming 10MHz clock
                count <= 0;
                clk_div <= ~clk_div; 
            end else begin
                count <= count + 1;
            end
        end
    endmodule
    
    
    
    
    module tlc(t,clk_div,reset,R,G,O);
    
    input [3:0]t;
    input clk_div;
    input reset;
    output reg [3:0] R,G,O;
    
    reg g,o;
    reg [1:0] state_side;
    parameter side1=2'b00,side2=2'b01,side3=2'b10,side4=2'b11;
    reg next; 
    reg [5:0] count;
    always@ (posedge clk_div)
    begin 
    if (reset)begin
    g<=0; 
    o<=0;
    next <=0;
    G<=4'b0000;
    O<=4'b0000;
    R<=4'b1111;
    state_side <= 2'b00;
    count<= 0;
    end    
    
    else
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
    else 
    begin
    count <= 0;
    next<=1;
    g<=1;
    o<=0;
    end
    end
    
    if(next)
    begin
    case(state_side)
    side1:  if (t[1]==1'b1)
            state_side <= side2;
            else if (t[2]==1'b1)
            state_side <= side3;
            else if (t[3]==1'b1)
            state_side <= side4;
            else
            state_side <= side1;
    side2:  if (t[2]==1'b1)
            state_side <= side3;
            else if (t[3]==1'b1)
            state_side <= side4;
            else if (t[0]==1'b1)
            state_side <= side1;
            else
            state_side <= side2;
    side3:  if (t[3]==1'b1)
            state_side <= side4;
            else if (t[0]==1'b1)
            state_side <= side1;
            else if (t[1]==1'b1)
            state_side <= side2;
            else
            state_side <= side3;
    side4:  if (t[0]==1'b1)
            state_side <= side1;
            else if (t[1]==1'b1)
            state_side <= side2;
            else if (t[2]==1'b1)
            state_side <= side3;
            else
            state_side <= side4;
    endcase
    end
    end
    
    
    
    always @(*) begin
        G <= g ? (4'b0001 << state_side) : 4'b0000;
        O <= o ? (4'b0001 << state_side) : 4'b0000;
        R <= ~(G | O)  & 4'b1111;
    end
    
    
    endmodule
