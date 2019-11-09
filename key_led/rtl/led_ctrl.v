
module led_ctrl(
	input clk,
	input rst_n,

	input key_flag0,
	input key_state0,
	
	input key_flag1,
	input key_state1,

	output [3:0] led
);


reg [3:0]led_r;

assign led = ~led_r;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		led_r <= 4'b0000;
	end else if (key_flag0 && !key_state0) begin
		led_r <= led_r + 1'b1;
	end else if (key_flag1 && !key_state1) begin
		led_r <= led_r - 1'b1;
	end else begin
		led_r <= led_r; 
	end
end


endmodule