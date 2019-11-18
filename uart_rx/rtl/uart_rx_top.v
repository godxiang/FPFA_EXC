module uart_rx_top(

	Clk,
	Rst_n,
	
	Uart_rx,
	
);

input Clk;
input Rst_n;

input Uart_rx;


wire Uart_rx_done;
wire [7:0]Uart_rx_byte;

reg [7:0]Uart_rx_byte_r;


issp_uart_recv  u_issp_uart_recv(
	.probe		(Uart_rx_byte_r),
	.source		()
);


// 串口接收
uart_rx_byte u_uart_rx_byte(
	.Clk				(Clk),
	.Rst_n			(Rst_n),	
	
	.Uart_rx			(Uart_rx),	
	.Baud_sel		(3'd0),
	
	.Uart_rx_byte	(Uart_rx_byte),
	.Uart_rx_done	(Uart_rx_done),
	.Uart_state		()
);

always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		Uart_rx_byte_r <= 8'd0;
	end else if (Uart_rx_done) begin
		Uart_rx_byte_r <= Uart_rx_byte;
	end else begin
		Uart_rx_byte_r <= Uart_rx_byte_r;
	end
end

endmodule