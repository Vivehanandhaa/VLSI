  module tb();
    reg [3:0]t;
    reg clkdiv;
    wire [3:0]R,G,O;
    tlc dut(t,clkdiv,R,G,O);
    
    initial 
    clkdiv = 0;
    initial
    forever #1 clkdiv= ~clkdiv;
    
    initial begin
    t=4'b0100;
    //#5 t=4'b0001;
    #102 t=4'b0010;
    #105 t=4'b0110;
    #105 t=4'b1000;
    #106 t=4'b1001;
    //t=4'b0001;
    end
    
   always @(posedge clkdiv) begin
        $display("T=%0t | t=%b | state=%b | count=%d | next=%b | g=%b | o=%b | G=%b | O=%b | R=%b",
                  $time, t, dut.state_side, dut.count, dut.next, dut.g, dut.o, G, O, R);
    end
    initial #500 $finish;
    endmodule
