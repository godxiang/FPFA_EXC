
`timescale 1ns/1ns

`define clk_period 20

module uart_rx_byte_tb();

reg clk;
reg rst_n;
reg en;
reg [2:0]baud_sel;
reg [7:0]data_byte;

wire uart_tx;
wire uart_tx_done;
wire uart_state_tx;


wire [7:0]Uart_rx_byte;
wire Uart_rx_done;
wire Uart_state_rx;


initial clk = 1'b0;
always #(`clk_period / 2) clk = ~clk;

initial begin
	rst_n 	 = 1'b0;
	en 		 = 1'b0;
	baud_sel  = 3'd4;
	data_byte = 8'd0;
	
	#(10 * `clk_period) rst_n = 1'b1;
	#3000
		
	data_byte = 8'b1111_1110;	
	en = 1'b1;
	#(`clk_period) en = 1'b0;	
	
	@(posedge uart_tx_done)
	#3000;	
	data_byte = 8'b1010_1010;	
	en = 1'b1;
	#(`clk_period) en = 1'b0;
	
	@(posedge uart_tx_done)	
	#3000;
	data_byte = 8'b0101_0101;	
	en = 1'b1;
	#(`clk_period) en = 1'b0;
			
	@(posedge uart_tx_done)	
	#3000;
	data_byte = 8'b0111_0111;	
	en = 1'b1;
	#(`clk_period) en = 1'b0;
	
	@(posedge uart_tx_done)	
	#300000;
	$stop;
	
end

uart_tx_byte u_uart_tx_byte(
	.Clk			 (clk),
	.Rst_n		 (rst_n),
	
	.En			 (en),
	.Baud_sel	 (baud_sel),
	.Data_byte	 (data_byte),
	
	.Uart_tx		 (uart_tx),
	.Uart_tx_done(uart_tx_done),
	.Uart_state	 (uart_state_tx)
);

uart_rx_byte u_uart_rx_byte(
	.Clk			  (clk),
	.Rst_n		  (rst_n),
	
	.Uart_rx		  (uart_tx),	
	.Baud_sel	  (baud_sel),
	
	.Uart_rx_byte (Uart_rx_byte),
	.Uart_rx_done (Uart_rx_done),
	.Uart_state   (Uart_state_rx)
);


endmodule

