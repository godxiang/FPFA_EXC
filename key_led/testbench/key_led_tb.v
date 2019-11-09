`timescale 1ns/1ns

`define time_period 20

module key_led_tb;

reg clk;
reg rst_n;
reg key_press_0;
reg key_press_1;

wire key_in_0;
wire key_in_1;
wire [3:0] led;


initial clk = 1'b0;
always #(`time_period / 2) clk = ~clk;


//- 调用仿真模型
key_model u_key_model_0(
		.press(key_press_0),
		.key  (key_in_0) 		
		);

key_model u_key_model_1(
		.press(key_press_1),
		.key  (key_in_1) 		
		);		


//- 例化key_led顶层模块
key_led u_key_led(

	  .clk	 	(clk),
	  .rst_n  	(rst_n),
 
	  .key_in0	(key_in_0),
	  .key_in1  (key_in_1),

	  .led		(led)
);
		
		
initial begin
	key_press_0 = 1'b0;
	key_press_1 = 1'b0;
	rst_n = 1'b0;
	#(10 * `time_period) rst_n = 1'b1;
	#3000;
	
	//- 进行1次按键0的按下和松开	
	key_press_0 = 1'b1;
	#(2 * `time_period) key_press_0 = 1'b0;
	
	#100_100_000;
	
	//- 进行1次按键1的按下和松开	
	key_press_1 = 1'b1;
	#(2 * `time_period) key_press_1 = 1'b0;
	
	#100_100_000;
	
	$stop;
end

endmodule

