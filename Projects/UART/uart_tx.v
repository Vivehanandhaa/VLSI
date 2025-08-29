`timescale 1ns / 100ps

module uart_tx(in,start,clk,reset,o,busy); 
  input [9:0]in;
  input clk, start, reset; //start should be pulse minimum for a clock duration
  output reg o, busy;  // o is output pin, busy is flag will be high throughout transmission 
  reg [3:0]count;//counter to track no of bits transmitted
  reg [2:0]state; //holds state of the UART 
  reg parity; //even parity not configurable
  parameter IDLE=3'b000,START=3'b001,DATA=3'b010,STOP=3'b100, PARITY=3'b011; 
  parameter data_size = 8; //configure upto size 10
  reg [9:0]data; 
  reg baud_tick;
  reg [23:0]baud_count;
  
  //clk = 10kHz

  parameter baud_rate = 2000; //baud rate
  parameter div = 10000/baud_rate; //clk/baud rate
  always @(posedge clk)
    begin
      if(!reset)
        begin
          baud_tick<=0;
          baud_count<=0;
        end
      else
        begin
          baud_count<= baud_count+1;
          if(baud_count==div-1)
            begin
              baud_tick<=1;
              baud_count<=0;
            end
          else
            baud_tick<=0;
        end
    end
    
  
  always @(posedge clk) 
    begin 
      if(!reset) 
        begin 
          count<=4'b0000; state<=3'b000; data<=0; o<=1; busy<=0; parity<=0;
        end 
      else if(baud_tick)
        begin 
          case(state) 
            IDLE: 
              begin 
                o<=1; 
                busy<=0; 
                if(start&!busy) 
                  state<=START;
                else 
                  state<=IDLE; 
              end 
            START: 
              begin 
                o<=0; 
                data<=in;
                busy<=1; 
                parity<=^(in[data_size-1:0]); 
                state<=DATA; 
              end 
            DATA: 
              begin 
                if (count==data_size-1)
                  begin 
                    o<=data[0]; 
                    count<=4'b0000; 
                    state<=PARITY; 
                  end 
                else 
                  begin o<=data[0]; 
                    data<=data>>1; 
                    count<=count+1;
                    state<=DATA; 
                  end 
              end 
            PARITY: 
              begin 
                o<=parity; 
                state<=STOP; 
              end 
            STOP: 
              begin 
                o<=1; 
                state<=IDLE;
              end 
            default:state<=IDLE; 
          endcase 
        end 
    end 
endmodule
