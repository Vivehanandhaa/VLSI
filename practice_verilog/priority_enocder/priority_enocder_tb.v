module tb();
  reg [7:0]in;
  wire [2:0]out;
  wire valid;
  p_e dut(.in(in), .out(out), .valid(valid));
  
  initial begin
	in = 8'b00000000;
  end
  
  initial begin
    in = 8'b00000000;
  #10 in = 8'b00111100;
   #10in = 8'b01000000;
   #10 in = 8'b10100100;
   #10 in = 8'b00000010;
  #10  in = 8'b00001000;
  end
  
  initial 
    $monitor ("time=%d, in =%b, out=%b, valid=%b",$time, in, out, valid);
    
    endmodule
    
