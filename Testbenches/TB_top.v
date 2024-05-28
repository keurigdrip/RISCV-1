`timescale 1ns / 1ps

module TB_top(
    );
    reg clk;
    reg read_enable;
    reg uart_rx;
    wire uart_tx;
    wire status;
    
    top tp (clk, read_enable, uart_rx, uart_tx, status);
    
    always
        begin
            clk = 1'b0; #5;
            clk = 1'b1; #5;
        end
        
    initial
        begin
            read_enable = 1'b1;
            // idle
            uart_rx = 1'b1;   #104166;
            // start bit
            uart_rx = 1'b0;   #104166;
            // 8 data bits
            uart_rx = 1'b1;   #104166;
            uart_rx = 1'b0;   #104166;
            uart_rx = 1'b1;   #104166;
            uart_rx = 1'b0;   #104166;
            uart_rx = 1'b1;   #104166;
            uart_rx = 1'b0;   #104166;
            uart_rx = 1'b1;   #104166;
            uart_rx = 1'b0;   #104166;
            // stop bit
            uart_rx = 1'b1;   #104166;
            // idle
            uart_rx = 1'b1;   #104166;
            uart_rx = 1'b1;   #104166;
            uart_rx = 1'b1;   #104166;
            
            //data2
            
            uart_rx = 1'b1;   #104166;
            // start bit
            uart_rx = 1'b0;   #104166;
            // 8 data bits
            uart_rx = 1'b0;   #104166;
            uart_rx = 1'b0;   #104166;
            uart_rx = 1'b1;   #104166;
            uart_rx = 1'b1;   #104166;
            uart_rx = 1'b1;   #104166;
            uart_rx = 1'b1;   #104166;
            uart_rx = 1'b1;   #104166;
            uart_rx = 1'b0;   #104166;
            // stop bit
            uart_rx = 1'b1;   #104166;
            // idle
            uart_rx = 1'b1;   #104166;
            uart_rx = 1'b1;   #104166;
            uart_rx = 1'b1;   #104166;
            
        end
    
endmodule