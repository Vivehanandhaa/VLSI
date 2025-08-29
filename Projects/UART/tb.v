`timescale 1ns / 100ps

module tb();
    reg clk;
    reg reset;
    reg [9:0] tx_in;
    reg tx_start;
    wire tx_o;
    wire tx_busy;

    
    wire [9:0] rx_data;
    wire rx_parity;
    wire rx_busy;

   
    uart_tx tx(
        .in(tx_in),
        .start(tx_start),
        .clk(clk),
        .reset(reset),
        .o(tx_o),
        .busy(tx_busy)
    );

  
    uart_rx rx(
        .clk(clk),
        .in(tx_o),
        .reset(reset),
        .data(rx_data),
        .parity(rx_parity),
        .busy(rx_busy)
    );

    
    initial clk = 0;
    always #1clk = ~clk; 
    
    initial begin
        reset = 0;
        tx_start = 0;
        #10;
        reset = 1;
        #10;

        
        tx_in = 8'b01010110;  
        tx_start = 1;
        #100;
        tx_start = 0;
        #10;
        
        tx_in = 8'b01101001;  
        tx_start = 1;
        #100;
        tx_start = 0;
        #10;
        
        tx_in = 8'b01110110;  
        tx_start = 1;
        #100;
        tx_start = 0;
        #10;
        
        tx_in = 8'b01100101;  
        tx_start = 1;
        #100;
        tx_start = 0;
        #10;
        
        tx_in = 8'b01101011;  
        tx_start = 1;
        #100;
        tx_start = 0;
        #10;
    end

    // Monitor RX
   always @(posedge clk) begin
     $display("time=%0t, tx_baud_tick=%b, tx_start=%b, tx_data=%b,tx_busy=%b, tx_state=%b, tx_count=%b, O=%b, rx_baud_tick=%b, rx_half_baud=%b, rx_data=%b, rx_parity=%b, rx_busy=%b,  rx_state=%b, rx_count=%b",
             $time,
             tx.baud_tick,
             tx_start, tx_in,      
             tx_busy, tx.state, tx.count, 
             tx.o,
             rx.baud_tick,rx.half_baud,
             rx_data, rx_parity, rx_busy, 
             rx.state, rx.count         
    );
end

endmodule
