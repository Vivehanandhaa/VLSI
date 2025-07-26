module tb();

reg clk;
wire [2:0]light;

design_TLC dut(clk,light);

initial begin
  clk = 0; 
  #100 $finish;
end
always
  #5 clk= ~clk;

initial
  $monitor("Time=%d , Light=%b ", $time, light); 

endmodule
