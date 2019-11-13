
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
	Uart_tx_done,
	Uart_state
);

input Clk;
input Rst_n;

input En;						//uart发送使能信号
input [2:0]Baud_sel;			//波特率选择	0: 9600  1:19200  2: 38400 3:57600  4:115200   period_time = 20ns
input [7:0]Data_byte;		//待发送的数据 1个字节

output reg Uart_tx; 			//uart串行发送数据线
output reg Uart_state;		//uart传输标志  为1，表示处于发送状态
output reg Uart_tx_done;

localparam UART_START_BIT = 1'b0;
localparam UART_STOP_BIT  = 1'b1;

reg[3:0]bps_cnt;
reg baud_div_clk;
reg [12:0]baud_div_cnt;
reg [7:0]data_byte_r;

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
		endcase
	end
end

// Uart_state 标记传输过程
always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		Uart_state <= 1'b0;
	end else if (En) begin
		Uart_state <= 1'b1;
	end else if (bps_cnt == 4'd11) begin
		Uart_state <= 1'b0;
	end else begin
		Uart_state <= Uart_state;
	end
end 

//由波特率计数值产生波特率分频时钟
always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		baud_div_cnt <= 13'd0;
	end else if (Uart_state && (baud_div_cnt < baud_cnt)) begin
		baud_div_cnt <= baud_div_cnt + 1'b1;	
	end else begin
		baud_div_cnt <= 13'd0;
	end
end

always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		baud_div_clk <= 1'b0;
	end else if (baud_div_cnt == baud_cnt) begin
		baud_div_clk <= 1'b1;
	end else begin
		baud_div_clk <= 1'b0;
	end
end

//计算分频时钟的数目
always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		bps_cnt <= 4'd0;
	end else if (bps_cnt < 4'd11) begin
		if (baud_div_clk) begin
			bps_cnt <= bps_cnt + 1'b1;
		end else begin
			bps_cnt <= bps_cnt;
		end
	end else begin
		bps_cnt <= 4'd0;
	end
end


//寄存要发送的字节
always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		data_byte_r <= 8'd0;
	end else begin
		data_byte_r <= Data_byte;	
	end	
end


//由bps_cnt将要发送的数据串行发送tx线上 
always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		Uart_tx <= 1'b1;
	end else begin
		case (bps_cnt)
			0: Uart_tx <= 1'b1;
			1: Uart_tx <= UART_START_BIT;
			2: Uart_tx <= data_byte_r[0];
			3: Uart_tx <= data_byte_r[1];
			4: Uart_tx <= data_byte_r[2];
			5: Uart_tx <= data_byte_r[3];
			6: Uart_tx <= data_byte_r[4];
			7: Uart_tx <= data_byte_r[5];
			8: Uart_tx <= data_byte_r[6];
			9: Uart_tx <= data_byte_r[7];
			10: Uart_tx <= UART_STOP_BIT;
			default : Uart_tx <= 1'b1;
		endcase
	end
end


always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		Uart_tx_done <= 1'b0;
	end else if (bps_cnt == 4'd11) begin
		Uart_tx_done <= 1'b1;
	end else begin
		Uart_tx_done <= 1'b0;
	end
end

endmodule
	
	
