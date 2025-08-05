`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.07.2025 10:50:53
// Design Name: 
// Module Name: tb
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

/*module tlc(t,clkdiv,R,G,O);

input [3:0]t;
input clkdiv;
output reg[3:0] R,G,O;*/
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.07.2025 10:50:53
// Design Name: 
// Module Name: tb
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

/*module tlc(t,clkdiv,R,G,O);

input [3:0]t;
input clkdiv;
output reg[3:0] R,G,O;*/
   /* 
   
   
    module tb();
    reg [3:0]t;
    reg clk;
    reg reset;
    wire [3:0]R,G,O;
    tlc dut(t,clk,reset,R,G,O);
    
    initial 
    clk = 0;
    initial
    forever #1 clk= ~clk;
    
    initial begin
    reset=1;
    t=4'b0100;
    reset=0;
    //#5 t=4'b0001;
    #102 t=4'b0010;
    #100 t=4'b0110;
    #5 reset =1;
    #500 reset =0;
    #105 t=4'b1000;
    #106 t=4'b1001;
    //t=4'b0001;
    end
    
   always @(posedge clk) begin
        $display("T=%0t | t=%b |Reset =%b| state=%b | count=%d | next=%b | g=%b | o=%b | G=%b | O=%b | R=%b",
                  $time, t,dut.reset, dut.state_side, dut.count, dut.next, dut.g, dut.o, G, O, R);
    end
    initial #50000 $finish;
    endmodule


*/
module tb;
    reg [3:0] t;
    reg clk;
    reg reset;
    wire [3:0] R, G, O;

    // Instantiate DUT
    tlc dut (.t(t), .clk_div(clk), .reset(reset), .R(R), .G(G), .O(O));

    // Clock generation (10ns period)
    initial clk = 0;
    always #1 clk = ~clk;  

    // Reset sequence
    initial begin
        reset = 1;
        #5 reset = 0;
    end

    // Traffic input stimulus
    initial begin
        t = 4'b0001;
        repeat (20) begin
            #($urandom_range(20,200)) t = $urandom_range(1,15); // Random traffic input
        end
        #1000 $finish;
    end

    // Random reset assertion mid-operation
    initial begin
        #500 reset = 1;
        #10 reset = 0;
    end

    // Monitor outputs
    always @(posedge clk) begin
        $display("T=%0t | t=%b | Reset=%b | State=%b | Count=%d | next=%b | g=%b | o=%b | G=%b | O=%b | R=%b",
                  $time, t, reset, dut.state_side, dut.count, dut.next, dut.g, dut.o, G, O, R);
    end

    // Assertions for correctness
    always @(posedge clk) begin
        // Only one Green or Orange at a time
        if ((G & O) != 4'b0000)
            $display("ERROR: Green and Orange overlap at time %0t", $time);

        // Red must be complement of (G | O)
        if (R != ~(G | O))
            $display("ERROR: Red mismatch at time %0t", $time);
    end
endmodule

