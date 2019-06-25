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


//波特率计数值计算	
parameter  CLK_FREQ =  50000000;
parameter  UART_BPS =  9600;
localparam BPS_CNT  = CLK_FREQ/UART_BPS;
	

reg current_state;			//当前状态
reg next_state;				//下个状态

parameter IDLE 	  = 0;   //就绪状态
parameter SEND 	  = 1; 	//发送数据状态
parameter SEND_DONE = 2;   //发送一帧数据完成标志
	
//第一段 当前状态
always @(posedge clk or negedge rst_n) begin
	if (!rst_n)
		current_state <= IDLE;
	else 
		current_state <= next_state;
end


//第二段 下一个状态
always @(posedge clk or negedge rst_n) begin
	if (!rst_n)
		next_state <= IDLE;
	else begin
		case (current_state)
			IDLE: begin
				//检测到uart_done拉高进入发送状态
				if (uart_done) begin
					next_state <= SEND;
				end
				else begin
					next_state <= IDLE;
				end
			end
			SEND: begin
				if (send_cnt == 4'd9) begin
					next_state <= SEND_DONE;
				end
				else begin
					next_state <= SEND;
				end
			end
			SEND_DONE: begin
				if (uart_done) begin
					next_state <= IDLE;
				end
				else begin
					next_state <= SEND_DONE;
				end
			end
			default:;
		endcase
	end
end
	

endmodule	