
`timescale 1ns/1ns

`define clk_period 20

module uart_dpram_tb();

reg clk;
reg rst_n;
reg en;
reg [2:0]baud_sel;
reg [7:0]data_byte;

wire uart_tx;
wire uart_tx_done;
wire uart_state_tx;

reg press;
wire key_in;


initial clk = 1'b0;
always #(`clk_period / 2) clk = ~clk;

initial begin
	rst_n 	 = 1'b0;
	en 		 = 1'b0;
	baud_sel  = 3'd0;
	data_byte = 8'd0;
	
	press = 1'b0;
	
	#(10 * `clk_period) rst_n = 1'b1;
	#3000
		
	data_byte = 8'b0101_1010;	
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
	
	press = 1;
	#(2*`clk_period) press = 0;
	
	#120_000_000;
	
/*
	press = 1;
	#(2*`clk_period) press = 0;
	
	#120_000_000;
	
	press = 1;
	#(2*`clk_period) press = 0;
	
	#120_000_000;
	
	press = 1;
	#(2*`clk_period) press = 0;
	
	#120_000_000;
*/
	$stop;
	
end


key_model u_key_model(
	.press(press),
	.key  (key_in)
);


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

uart_dpram  u_uart_dpram(
	.Clk			  (clk),
	.Rst_n		  (rst_n),
	
	.Key_in		  (key_in),
	
	.Uart_tx		  (),
	.Uart_rx		  (uart_tx)
);


endmodule


