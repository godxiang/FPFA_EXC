
/**********************************************************\
	Filename		:	 uart_tx_byte.v
	Author  	   :   eric_xiang
	Description :   uart send byte
	Revision		:   2019-11-12
	Company		:   personal
\**********************************************************/
	
module uart_tx_byte(
	Clk,
	Rst_n,
	
	En,
	Baud_sel,
	Data_byte,
	
	Uart_tx,
	Uart_state
);

input Clk;
input Rst_n;

input En;						//uart发送使能信号
input [2:0]Baud_sel;			//波特率选择	0: 9600  1:19200  2: 38400 3:57600  4:115200   period_time = 20ns
input [7:0]Data_byte;		//待发送的数据 1个字节

output Uart_tx; 				//uart串行发送数据线
output Uart_state;			//uart传输标志  为1，表示处于发送状态


//由波特率选择计数值
reg [12:0]baud_cnt;

always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		baud_cnt <= 13'd5207;  //初始波特率为9600
	end else begin
		case (Baud_sel)
			0: baud_cnt <= 13'd5207;
			1: baud_cnt <= 13'd2603;
			2: baud_cnt <= 13'd1301;
			3: baud_cnt <= 13'd867;
			4: baud_cnt <= 13'd433;
			default: baud_cnt <= 13'd5207;
	end
end

//由波特率计数值产生波特率分频时钟
wire baud_div_clk;

always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		baud_div_clk <= 1'b0;
	end else 
end

endmodule
	
	
