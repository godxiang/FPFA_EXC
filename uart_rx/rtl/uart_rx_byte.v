
/**********************************************************\
	Filename		:	 uart_rx_byte.v
	Author  	   :   eric_xiang
	Description :   uart recv byte
	Revision		:   2019-11-13
	Company		:   personal
\**********************************************************/


module uart_rx_byte(
	Clk,
	Rst_n,
	
	Uart_rx,	
	Baud_sel,
	
	Uart_rx_byte,
	Uart_rx_done,
	Uart_state
);

input Clk;
input Rst_n;

input 	  Uart_rx; 					//uart串行发送数据线
input [2:0]Baud_sel;					//波特率选择	0: 9600  1:19200  2: 38400 3:57600  4:115200   period_time = 20ns

output reg [7:0]Uart_rx_byte;		//接收的数据
output reg 		 Uart_rx_done;		//uart接收完成标志
output reg 		 Uart_state;		//uart传输标志  为1，表示处于发送状态


reg [7:0] bps_cnt;
reg 		 baud_div_clk;
reg [12:0]baud_div_cnt;

reg s0_uart_rx;
reg s1_uart_rx;

reg s1_uart_rx_r0;
reg s1_uart_rx_r1;

reg [2:0] START_BIT;
reg [2:0] STOP_BIT;
reg [2:0] uart_byte_r[7:0];  


reg [12:0]baud_cnt;

//捕获下降沿
wire uart_nedg = ~s1_uart_rx_r0 & s1_uart_rx_r1;


//由波特率选择计数值
always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
	baud_cnt <= 13'd324;  //初始波特率为9600 将每一位接收的数据进行16分频，即分频时钟的频率为原来的16倍，则计数值为1/16
	end else begin
		case (Baud_sel)
			0: baud_cnt <= 13'd324;
			1: baud_cnt <= 13'd162;
			2: baud_cnt <= 13'd80;
			3: baud_cnt <= 13'd53;
			4: baud_cnt <= 13'd26;
			default: baud_cnt <= 13'd324;
		endcase
	end
end


//Uart_state标志传输过程
always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		Uart_state <= 1'b0;
	end else if (uart_nedg) begin
		Uart_state <= 1'b1;
	end else if (bps_cnt == 8'd159) begin
		Uart_state <= 1'b0;
	end else begin
		Uart_state <= Uart_state;
	end
end


//输出done信号
always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		Uart_rx_done <= 1'b0;
	end else if (bps_cnt == 8'd159) begin		
		Uart_rx_done <= 1'b1;
	end else begin
		Uart_rx_done <= 1'b0;
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
		bps_cnt <= 8'd0;
	end else if (bps_cnt < 8'd159) begin
		if (baud_div_clk) begin
			bps_cnt <= bps_cnt + 1'b1;
		end else begin
			bps_cnt <= bps_cnt;
		end
	end else if ( bps_cnt == 8'd12 && (START_BIT > 2) ) begin  //检测起始位是否出错
		bps_cnt <= 8'd0;	
	end else begin
		bps_cnt <= 8'd0;
	end
end

//同步uart_rx
always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		s0_uart_rx <= 1'b0;
		s1_uart_rx <= 1'b0;
	end else begin
		s0_uart_rx <= Uart_rx;
		s1_uart_rx <= s0_uart_rx;		
	end

end

//寄存两级s0_uart_rx,用于捕获下降沿
always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		s1_uart_rx_r0 <= 1'b0;
		s1_uart_rx_r1 <= 1'b0;
	end else begin
		s1_uart_rx_r0 <= s1_uart_rx;
		s1_uart_rx_r1 <= s1_uart_rx_r0;		
	end

end


/****************************************************************************\ 
	- 由bps_cnt接收数据
	- 8bit数据，每一bit由3位组成 3：每1位数据16次采样，去掉首段和尾段只取中间6位数据。
     以6位数据累加的方式判断该bit是否输出0还是1.累加值大于3即6位中1的个数大于0的个数
     则该位输出1.	  
\***************************************************************************/	

always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		START_BIT <= 3'd0;
		uart_byte_r[0] <= 3'd0;
		uart_byte_r[1] <= 3'd0;
		uart_byte_r[2] <= 3'd0;
		uart_byte_r[3] <= 3'd0;
		uart_byte_r[4] <= 3'd0;
		uart_byte_r[5] <= 3'd0;
		uart_byte_r[6] <= 3'd0;
		uart_byte_r[7] <= 3'd0;
		STOP_BIT			<= 3'd0;
	end else begin
		if (baud_div_clk) begin
			case (bps_cnt)
				0: begin
					START_BIT	   <= 3'd0;
					uart_byte_r[0] <= 3'd0;
					uart_byte_r[1] <= 3'd0;
					uart_byte_r[2] <= 3'd0;
					uart_byte_r[3] <= 3'd0;
					uart_byte_r[4] <= 3'd0;
					uart_byte_r[5] <= 3'd0;
					uart_byte_r[6] <= 3'd0;
					uart_byte_r[7] <= 3'd0;
					STOP_BIT			<= 3'd0;							
				end
				6,7,8,9,10,11: 			 	START_BIT 		<= START_BIT + s1_uart_rx;
				22,23,24,25,26,27: 		 	uart_byte_r[0] <= uart_byte_r[0] + s1_uart_rx;
				38,39,40,41,42,43: 		 	uart_byte_r[1] <= uart_byte_r[1] + s1_uart_rx;
				54,55,56,57,58,59: 		 	uart_byte_r[2] <= uart_byte_r[2] + s1_uart_rx;
				70,71,72,73,74,75: 		 	uart_byte_r[3] <= uart_byte_r[3] + s1_uart_rx;
				86,87,88,89,90,91: 		 	uart_byte_r[4] <= uart_byte_r[4] + s1_uart_rx;
				102,103,104,105,106,107: 	uart_byte_r[5] <= uart_byte_r[5] + s1_uart_rx;
				118,119,120,121,122,123: 	uart_byte_r[6] <= uart_byte_r[6] + s1_uart_rx;
				134,135,136,137,138,139: 	uart_byte_r[7] <= uart_byte_r[7] + s1_uart_rx;
				150,151,152,153,154,155:   STOP_BIT			<= STOP_BIT + s1_uart_rx;
				default: begin
					START_BIT		<= START_BIT;		
					uart_byte_r[0] <= uart_byte_r[0]; 
					uart_byte_r[1] <= uart_byte_r[1];
					uart_byte_r[2] <= uart_byte_r[2]; 
					uart_byte_r[3] <= uart_byte_r[3]; 
					uart_byte_r[4] <= uart_byte_r[4]; 
					uart_byte_r[5] <= uart_byte_r[5]; 
					uart_byte_r[6] <= uart_byte_r[6]; 
					uart_byte_r[7] <= uart_byte_r[7]; 
					STOP_BIT			<= STOP_BIT;			
				end
			endcase
		end
	end
end

/****************************************************************************\ 
	-由uart_rx接收的8位,每位由3位组成，表示接收每一位时采样的16次中的中间6次采样数据累加
	 之和，再者。只需判断6次采样之和是否大于3即可判断是否输出0/1,3位数据则只需判断最高位
	 是否为1，最高位为1则6位之和大于3，此为为1。即只需将3位的最高位赋值给此位即可表示该位
	 输出0还是1
\***************************************************************************/
	
always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		Uart_rx_byte <= 8'd0;
	end else if (bps_cnt == 8'd159) begin
		Uart_rx_byte[0] <= uart_byte_r[0][2];
		Uart_rx_byte[1] <= uart_byte_r[1][2];
		Uart_rx_byte[2] <= uart_byte_r[2][2];
		Uart_rx_byte[3] <= uart_byte_r[3][2];
		Uart_rx_byte[4] <= uart_byte_r[4][2];
		Uart_rx_byte[5] <= uart_byte_r[5][2];
		Uart_rx_byte[6] <= uart_byte_r[6][2];
		Uart_rx_byte[7] <= uart_byte_r[7][2];	
	end else begin 
		Uart_rx_byte <= Uart_rx_byte;
	end
end


endmodule

