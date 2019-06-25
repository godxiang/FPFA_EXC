//************************************************************************
// uart_send为串口发送模块，以uart_done
// 为发送使能信号，将接收到的数据uart_data通过串口发送端口uart_txd发送出去。
//************************************************************************

module uart_send(
	
	input clk,					//时钟
	input rst_n,				//复位
	
	output uart_txd,			//uart发送信号
	input [7:0]data,			//输入uart等待输出的数据
	input uart_done			//接收一阵数据完成标志
	
	);

	
	
	

endmodule	