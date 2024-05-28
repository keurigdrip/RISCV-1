module receiver(
    input clk,
    input read_enable,
    input uart_rx,
    output reg [9:0] data_out = 10'b0000000000,
    output reg rx_status = 1'b0
);

// counter reload value for 9600 baud rate
parameter BIT_TIMER_MAX = 5860;
parameter BIT_TIMER_MAX_HALF = 2930;

// 1 start bit, 8 data bits, 1 stop bit
parameter BIT_INDEX_MAX = 10;

reg [13:0] bittimer;
wire bitdone;
wire waitdone;
integer bitindex;
wire rxbit;
reg [9:0] rxdata = 10'b0000000000;
reg [1:0] state;

localparam READY     = 2'b00;
localparam WAIT_BIT  = 2'b01;
localparam LOAD_BIT  = 2'b10;
localparam READ_BIT  = 2'b11;

// FSM for the receive algorithm states
always@(posedge clk) begin 
    case (state)
        READY     : begin
            if (read_enable) begin rx_status = 1'b0; if(uart_rx == 1'b0) state <= WAIT_BIT; end end
        WAIT_BIT  : begin if(waitdone) begin if(uart_rx == 1'b0) state <= LOAD_BIT; end end
        LOAD_BIT  : state <= READ_BIT;
        READ_BIT  : begin
            if(bitdone) begin 
                if(bitindex == BIT_INDEX_MAX) 
                    begin data_out <= rxdata; state <= READY; rx_status = 1'b1; end
                else state <= LOAD_BIT;
                end
            end
        default : state <= READY;            
    endcase
end

// counter for delay between each bit
always@(posedge clk) begin
    if(state == READY) 
        bittimer <= "00000000000000";
    else if (state == WAIT_BIT) begin
        if(waitdone)
            bittimer <= "00000000000000";
        else
            bittimer <= bittimer + 1'b1;
    end
    else begin
        if(bitdone)
            bittimer <= "00000000000000";
        else 
            bittimer <= bittimer + 1'b1;
    end        
end
assign bitdone = (bittimer == BIT_TIMER_MAX)? 1'b1 : 1'b0;
assign waitdone = (bittimer == BIT_TIMER_MAX_HALF)? 1'b1 : 1'b0;

// saving each bit received into the rxdata array
always @(posedge clk) begin
    if(state == READY) begin
        bitindex <= 0;
    end
    else if (state == LOAD_BIT) begin
        rxdata[bitindex] <= rxbit;
        bitindex <= bitindex + 1;
    end
end

// get bit from the rx pin
assign rxbit = uart_rx;

endmodule
