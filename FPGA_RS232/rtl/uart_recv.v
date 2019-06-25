
//************************************************************************
// uart_recv为串口接收模块，从串口接收端口uart_rxd接收上位机发送的串行数据，并在
// 一帧数据（8位）接收结束后给出通知信号uart_done；
//************************************************************************

module uart_recv(
	
	input clk,					//时钟
	input rst_n,				//复位
	
	input uart_rxd,			//串口接收
	output reg [7:0]data,	//接收的一帧数据 8bit
	output reg uart_done		//接收一阵数据完成标志
	
	);

	
reg  uart_rxd1;	
wire  start_flag;

reg  [3:0]recv_cnt;			//接收计数
reg  [15:0]clk_cnt;			//波特率计数器

	
//波特率计数值计算	
parameter  CLK_FREQ =  50000000;
parameter  UART_BPS =  9600;
localparam BPS_CNT  = CLK_FREQ/UART_BPS;

reg current_state;			//当前状态
reg next_state;				//下个状态

parameter IDLE 	  = 0; 
parameter RECV 	  = 1; 	
parameter RECV_DONE = 2;

//***********************************************************************
// 三段式状态机
// 第一段描述当前状态
// 第二段描述下一个状态
// 第三段描述输出
//***********************************************************************

//第一段 当前状态
always @(posedge clk or negedge rst_n) begin
	if (!rst_n)
		current_state <= IDLE;
	else 
		current_state <= next_state;
end

//BPS_CNT计数
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		clk_cnt  <= 16'd0;
	end
	else begin
		if (current_state == RECV) begin
			if (clk_cnt < BPS_CNT) begin
				clk_cnt <= clk_cnt + 1'b1;
			end
			else begin
				clk_cnt <= clk_cnt;
			end
		end
		else begin
			clk_cnt <= 16'd0;
		end		
	end
	
end


//recv_cnt接收数据个数计数
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		recv_cnt <= 4'd0;
	end
	else begin
		if (current_state == RECV) begin
			if (clk_cnt == BPS_CNT) begin
				recv_cnt <= recv_cnt + 1'b1;
			end
			else begin
				recv_cnt <= recv_cnt;
			end
		end
		else begin
			recv_cnt <= 4'd0;
		end
	end
end

//第二段 下一个状态
always @(posedge clk or negedge rst_n) begin
	if (!rst_n)
		next_state <= IDLE;
	else begin
		case (current_state)
			IDLE: begin
				//检测到RXD的起始位(下降沿)则进入接收状态
				if (start_flag) begin
					next_state <= RECV;
				end
				else begin
					next_state <= IDLE;
				end
			end
			RECV: begin
				if ((recv_cnt == 4'd9) && (clk_cnt == BPS_CNT/2) ) begin
					next_state <= RECV_DONE;
				end
				else begin
					next_state <= RECV;
				end
			end
			RECV_DONE: begin
				if (uart_done) begin
					next_state <= IDLE;
				end
				else begin
					next_state <= RECV_DONE;
				end
			end
			default:;
		endcase
	end
end


//检测rxd的下降沿
assign start_flag =(current_state == IDLE)?(~uart_rxd & uart_rxd1):0;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		uart_rxd1 <= 1'b0;
	end
	else begin
		uart_rxd1 <= uart_rxd;
	end
end

reg [7:0]data_rev;

//第三段数据输出
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		data_rev  <= 8'd0;
		data      <= 8'd0;
		uart_done <= 1'b0;
	end
	else begin
		case (current_state)
			IDLE: begin
				data_rev  <= 8'd0;
				data      <= 8'd0;
				uart_done <= 1'b0;
			end
			RECV: begin
				if (clk_cnt == BPS_CNT/2) begin
					case (recv_cnt)
					4'd1: data_rev[0] <= uart_rxd;
					4'd2: data_rev[1] <= uart_rxd;
					4'd3: data_rev[2] <= uart_rxd;
					4'd4: data_rev[3] <= uart_rxd;
					4'd5: data_rev[4] <= uart_rxd;
					4'd6: data_rev[5] <= uart_rxd;
					4'd7: data_rev[6] <= uart_rxd;
					4'd8: data_rev[7] <= uart_rxd;								
				 endcase
				end
			end
			RECV_DONE: begin
					data <= data_rev;
					uart_done <= 1'b1;
			end
			default:;
		endcase
	end
	
end
	
endmodule


