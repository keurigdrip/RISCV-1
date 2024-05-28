module transmitter(
    input clk,
    input send_enable,
    input [7:0] data,
    output reg uart_tx = 1'b1,
    output reg tx_status = 1'b0
);

// counter reload value for 9600 baud rate
parameter BIT_TIMER_MAX = 14'd10416;
// 1 start bit, 8 data bits, 1 stop bit
parameter BIT_INDEX_MAX = 10;

reg [13:0] bittimer = 14'b0;
wire bitdone;
integer bitindex;
reg [9:0] txdata;
reg [1:0] state;

localparam READY    = 2'b00;
localparam LOAD_BIT = 2'b01;
localparam SEND_BIT = 2'b10;

// FSM for the transmit algorithm states
always@(posedge clk) begin 
    case (state)
        READY    : begin   
            tx_status <= 1'b0;
            if(send_enable == 1'b1)
                begin
                    tx_status <= 1'b0;
                    state <= LOAD_BIT;
                end
            end         
        LOAD_BIT : state <= SEND_BIT;
        SEND_BIT : begin
            if(bitdone) begin 
                if(bitindex == BIT_INDEX_MAX) 
                    begin
                        state <= READY;
                        tx_status <= 1'b1;
                    end
                else
                    state <= LOAD_BIT;
                end
            end
        default : state <= READY;            
    endcase
end

// counter for delay between each bit
always@(posedge clk) begin
    if(state == READY) 
        bittimer <= 14'b0;
    else begin
        if(bitdone)
            bittimer <= 14'b0;
        else 
            bittimer <= bittimer + 1;
    end        
end 
assign bitdone = (bittimer == BIT_TIMER_MAX)? 1'b1 : 1'b0 ;

// create the data packet and save it into txdata
always @(posedge clk) begin
    if(send_enable) 
        txdata <= {1'b1, data, 1'b0};
    end

// setting the bit to transfer from the txdata array
always @(posedge clk) begin
    if(state == READY) begin
        uart_tx <= 1'b1;
        bitindex <= 0;
    end 
    else if (state == LOAD_BIT) begin
        uart_tx <= txdata[bitindex];
        bitindex <= bitindex +1;
    end 
end

endmodule
