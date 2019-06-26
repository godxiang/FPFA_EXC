//************************************************************************
// uart_send为串口发送模块，以uart_done
// 为发送使能信号，将接收到的数据uart_data通过串口发送端口uart_txd发送出去。
//************************************************************************

module uart_send(
	
	input clk,					//时钟
	input rst_n,				//复位
	
	output reg uart_txd,		//uart发送信号
	input [7:0]data,			//输入uart等待输出的数据
	input uart_done			//接收一阵数据完成标志
	
	);


	
//波特率计数值计算	
parameter  CLK_FREQ =  50000000;
parameter  UART_BPS =  9600;
localparam BPS_CNT  = CLK_FREQ/UART_BPS;
	

wire start_flag;	

reg  [3:0]send_cnt;			//接收计数
reg  [15:0]clk_cnt;			//波特率计数器

reg uart_done1,uart_done2;
	
reg [1:0]current_state;			//当前状态
reg [1:0]next_state;				//下个状态

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

//检测uart_done信号的上升沿
assign start_flag = (current_state == IDLE)?(uart_done1 & (~uart_done2)):1'b0;

// uart_done信号延时2周期
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		uart_done1 <= 1'b0;
		uart_done2 <= 1'b0;
	end
	else begin
		uart_done1 <= uart_done;
		uart_done2 <= uart_done1;		
	end	
end


//BPS_CNT计数
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		clk_cnt  <= 16'd0;
	end
	else begin
		if (current_state == SEND) begin
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


//send_cntt接收数据个数计数
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		send_cnt <= 4'd0;
	end
	else begin
		if (current_state == SEND) begin
			if (clk_cnt == BPS_CNT) begin
				send_cnt <= send_cnt + 1'b1;
			end
			else begin
				send_cnt <= send_cnt;
			end
		end
		else begin
			send_cnt <= 4'd0;
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
				//检测到uart_done上升沿 进入发送状态
				if (start_flag) begin
					next_state <= SEND;
				end
				else begin
					next_state <= IDLE;
				end
			end
			SEND: begin
				if ((send_cnt == 4'd9) && (clk_cnt == BPS_CNT/2)) begin
					next_state <= SEND_DONE;
				end
				else begin
					next_state <= SEND;
				end
			end
			SEND_DONE: begin
				next_state <= IDLE;			
			end
			default:;
		endcase
	end
end

	
//第三段 输出
always @(posedge clk or negedge rst_n) begin	
	if (!rst_n) begin
		uart_txd <= 1'b1;
	end
	else begin
		case (current_state)
			IDLE: begin
			end
			SEND: begin
				case (send_cnt)
					4'b0: uart_txd <= 1'b0;	    	//起始位
					4'd1: uart_txd <= data[0]; 	//数据位最低位
					4'd2: uart_txd <= data[1];
					4'd3: uart_txd <= data[2];
					4'd4: uart_txd <= data[3];
					4'd5: uart_txd <= data[4];
					4'd6: uart_txd <= data[5];
					4'd7: uart_txd <= data[6];
					4'd8: uart_txd <= data[7]; 	//数据位最高位
					4'd9: uart_txd <= 1'b1; 		//停止位
					default:;
				endcase
			end
			SEND_DONE: begin		
			end
			default:;
		endcase
	end	
	
end	
	
endmodule	