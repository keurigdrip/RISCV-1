module top(
    input clk,
    input read_enable,
    input uart_rx,
    output uart_tx,
    output status
);

wire send_enable;
wire encrypt_enable;
wire [9:0] received_data;
wire [7:0] encrypted_data;

receiver    rx (clk,  read_enable,     uart_rx,         received_data,   encrypt_enable);
encryptor   cy (clk,  encrypt_enable,  received_data,   encrypted_data,  send_enable);
transmitter tx (clk,  send_enable,     encrypted_data,  uart_tx,         status);

endmodule