module encryptor(
    input clk,
    input encrypt_enable,
    input [9:0] data_in,
    output reg [7:0] data_out = 8'b00000000,
    output reg cy_status = 1'b0
);

localparam READY = 2'b00;
localparam CRYPT = 2'b01;
localparam SEND  = 2'b10;
localparam LFSR  = 2'b11;
reg [1:0] state;

reg [7:0] lfsr_reg = 8'b10111011;     // key
reg [7:0] prev_output = 8'b10101110;   // previous block encrypt output


always@(posedge clk) begin 
    case (state)
        READY : begin cy_status = 1'b0; if (encrypt_enable) state <= LFSR; end 
        LFSR : state <= CRYPT;
        CRYPT : state <= SEND;
        SEND  : begin state <= READY; cy_status = 1'b1; end
        default : state <= READY;            
    endcase
end

// add any encryption here
always @(posedge clk) begin
    if(state == CRYPT) begin
        data_out <= lfsr_reg ^ prev_output ^ data_in;
        prev_output <= data_out;
    end  
end


always @(posedge clk) begin
    if(state == LFSR) begin
        lfsr_reg <= {lfsr_reg[6:0], lfsr_reg[7] ^ lfsr_reg[5] ^ lfsr_reg[4] ^ lfsr_reg[3] };
    end  
end

endmodule