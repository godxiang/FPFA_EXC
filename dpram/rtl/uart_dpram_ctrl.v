
module uart_dpram_ctrl(
	Clk,
	Rst_n,

	Uart_rx_done,	
	wraddress,
	
	key_flag,
	key_state,
		
	rdaddress,
	
	Uart_send_en,
	Uart_tx_done	
);


input Clk;
input Rst_n;
input Uart_rx_done;
input key_flag;
input key_state;
input Uart_tx_done;
	
output reg [7:0] wraddress;
output reg [7:0] rdaddress;
output reg Uart_send_en;

reg do_send;


//-产生写RAM的地址	
always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		wraddress <= 8'd0;
	end else if (Uart_rx_done) begin
		wraddress <= wraddress + 1'b1;
	end else begin
		wraddress <= wraddress;
	end	
end

//按下按键启动读取，再次按下停止读取
always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		do_send <= 1'b0;
	end else if (key_flag && !key_state) begin
		do_send <= ~do_send;
	end

end
//-产生发送使能信号
always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		Uart_send_en <= 1'b0;	
	end else if (key_flag && !key_state) begin
		Uart_send_en <= 1'b1;
	end else if (do_send && Uart_tx_done) begin
		Uart_send_en <= 1'b1;
	end else begin
		Uart_send_en <= 1'b0;
	end
end
	
//- 产生读地址	
always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		rdaddress <= 8'd0;
	end else if (do_send && Uart_tx_done) begin
		rdaddress <= rdaddress + 1'b1;
	end else begin
		rdaddress <= rdaddress;
	end
end
	
endmodule
