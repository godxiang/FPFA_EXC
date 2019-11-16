
/**********************************************************\
	Filename		:	 uart_dpram.v
	Author  	   :   eric_xiang
	Description :   为了实现通过串口发送数据到 FPGA 中，FPGA 接收到数据后将数据存储在
						 双口 ram 的一段连续空间中，当需要时，按下按键 S0，则 FPGA 将 RAM 中存储
						 的数据通过串口发送出去。
	Revision		:   2019-11-12
	Company		:   personal
\**********************************************************/


module uart_dpram(
	Clk,
	Rst_n,
	
	Key_in,
	
	Uart_tx,
	Uart_rx
);

input Clk;
input Rst_n;

input Key_in;

output Uart_tx;
input Uart_rx;


wire key_flag;
wire key_state;

wire [2:0]Baud_sel = 3'd4;

wire [7:0]Uart_rx_byte;
wire 		 Uart_rx_done;

wire [7:0]q;

wire [7:0]wraddress;
wire [7:0]rdaddress;

wire Uart_send_en;
wire Uart_tx_done;



//- dpram
ip_dpram  u_ip_dpram(
	.clock		(Clk),
	.data			(Uart_rx_byte),
	.rdaddress	(rdaddress),
	.wraddress	(wraddress),
	.wren			(Uart_rx_done),
	.q				(q)	
);


//-串口发送
uart_tx_byte u_uart_tx_byte(
	.Clk(Clk),
	.Rst_n(Rst_n),
	
	.En(Uart_send_en),
	.Baud_sel(Baud_sel),
	.Data_byte(q),
	
	.Uart_tx(Uart_tx),
	.Uart_tx_done(Uart_tx_done),
	.Uart_state()
);

//-串口接收
uart_rx_byte u_uart_rx_byte(
	.Clk(Clk),
	.Rst_n(Rst_n),
	
	.Uart_rx(Uart_rx),	
	.Baud_sel(Baud_sel),
	
	.Uart_rx_byte(Uart_rx_byte),
	.Uart_rx_done(Uart_rx_done),
	.Uart_state()
);

//- 按键消抖
key_filter u_key_filter(
	.Clk(Clk),
	.Rst_n(Rst_n),

	.key_in(Key_in),

	.key_flag(key_flag),
	.key_state(key_state)
);

//- 传输控制
uart_dpram_ctrl  u_uart_dpram_ctrl(
	.Clk(Clk),
	.Rst_n(Rst_n),

	.Uart_rx_done(Uart_rx_done),	
	.Uart_send_en(Uart_send_en),
	.Uart_tx_done(Uart_tx_done),	
	
	.wraddress(wraddress),
	.rdaddress(rdaddress),
	
	.key_flag(key_flag),
	.key_state(key_state)	
);




endmodule