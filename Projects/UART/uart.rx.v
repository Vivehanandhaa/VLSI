`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.08.2025 15:36:50
// Design Name: 
// Module Name: uart_rx
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

module uart_rx(clk,in,reset,parity,busy,data);
  input in, clk, reset; 
  output reg [9:0]data;
  output reg parity;
  output reg busy;  //busy is flag will be high throughout reception 
  reg [3:0]count;//counter to track no of bits transmitted
  reg [2:0]state; //holds state of the UART 
  parameter IDLE=3'b000,START=3'b001,DATA=3'b010,STOP=3'b011, PARITY=3'b100; 
  parameter data_size =8; //configure upto size 10
   
  reg baud_tick;
  reg half_baud;
  reg [23:0]baud_count;
    
  parameter baud_rate = 1000; //baud rate
  parameter div = 10000/baud_rate; //clk/baud rate
  always @(posedge clk)
    begin
      if(!reset)
        begin
          baud_tick<=0;
          baud_count<=0;
          half_baud<=0;
        end
      else
        begin
          baud_count<= baud_count+1;
          if(baud_count==div-1)
            begin
              baud_tick<=1;
              baud_count<=0;
            end
          else if(baud_count==div/2-1)
            half_baud<=1;
          else
            begin
              baud_tick<=0;
              half_baud<=0;
            end        	
        end
    end
    
  always @(posedge clk) 
    begin 
      if(!reset) 
        begin 
          count<=4'b0000; state<=3'b000; data<=0; busy<=0; parity<=0;
        end 
      else 
        begin 
          case(state) 
            IDLE:
                begin
                  busy<=0;
                  if(in==0)
                    state<=START;
                  else
                    state<=IDLE;
                end 
            START: 
              begin 
                if(half_baud)
                  begin
                    if(in==0)
                      begin
                        state<=DATA;
                        busy<=1;
                      end
                    else
                      state<=IDLE;
                  end                
              end 
            DATA:
              if(baud_tick) 
              begin
              //  data<=data>>1;
                if(count<data_size+1)
                  begin
                    data[count-1]<=in; //data_size-1
                    state<=DATA;
                    count<=count+1;
                  end
                else
                  begin
                    state<= PARITY;
                    //data<=data>>1;
                  end
              end
            PARITY:
              if(baud_tick)
              begin
                parity<=in;
                state<=STOP;            
              end 
            STOP:
              if(baud_tick)
              begin
                state<=IDLE;
              end 
            default:state<=IDLE; 
          endcase 
        end 
    end
endmodule
