
module uart_tx_top(

	Clk,
	Rst_n,
	
	key_in,
	
	Uart_tx
);


input	 Clk;
input	 Rst_n;
	
input	 key_in;
	
output Uart_tx;


wire en;

wire [7:0]Data_byte;

wire key_flag;
wire key_state;


assign en = key_flag & (~key_state);


// ISSP
uart_issp u_uart_issp(
	.probe			(),
	.source			(Data_byte)
);

// 按键消抖模块
key_filter u_key_filter(
	.Clk				(Clk),
	.Rst_n			(Rst_n),
	
	.key_in			(key_in),
	
	.key_flag		(key_flag),
	.key_state		(key_state)
);

//串口发送模块
uart_tx_byte u_uart_tx_byte(
	.Clk				(Clk),
	.Rst_n			(Rst_n),
	
	.En				(en),
	.Baud_sel		(3'd0),
	.Data_byte		(Data_byte),
	
	.Uart_tx			(Uart_tx),
	.Uart_tx_done	(),
	.Uart_state		()
);




endmodule