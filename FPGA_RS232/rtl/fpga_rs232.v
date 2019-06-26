
module fpga_rs232 (
	
	input  clk,
	input  rst_n,
	
	input  uart_rxd,
	output uart_txd
	);

wire [7:0]data;
wire uart_done;
parameter CLK_FREQ = 50000000; //定义系统时钟频率
parameter UART_BPS = 115200; //定义串口波特率
	
	
 uart_recv #(
	.CLK_FREQ    (CLK_FREQ), 
	.UART_BPS    (UART_BPS)	
 )u1_uart_recv(
	
	.clk			(clk),			//时钟
	.rst_n		(rst_n),			//复位

	.uart_rxd   (uart_rxd),		//串口接收
	.data			(data),		   //接收的一帧数据 8bit
	.uart_done  (uart_done)		//接收一阵数据完成标志
	
	);

	
 uart_send #(
	.CLK_FREQ    (CLK_FREQ), 
	.UART_BPS    (UART_BPS)	
 )u2_uart_send(
	
	.clk			(clk),			//时钟
	.rst_n		(rst_n),			//复位

	.uart_txd   (uart_txd),		//串口接收
	.data			(data),		   //接收的一帧数据 8bit
	.uart_done  (uart_done)		//接收一阵数据完成标志
	
	);

	
	
endmodule	
