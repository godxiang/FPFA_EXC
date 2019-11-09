
`timescale 1ns/1ns

`define clk_period 20

module key_filter_tb;

reg clk;
reg rst_n;

wire key_in;
wire key_flag;
wire key_state;
	
//- 产生时钟
initial clk = 0;
always #(`clk_period / 2) clk = ~clk;

/*
//- 引入random随机数函数，用法为:$random % b 产生-b到b的随机数。若只产生正数
//- 则{$random} % b
//- 此处产生20ms以内的按键抖动。节省仿真时间，产生16'd65535以内的抖动即0~65535
//- 使用关键字task，不用复制长段激励
 
reg [15:0]my_rand;
 
task press_key;
	begin
		repeat(50) begin	//- 50次随机按下抖动
			my_rand = {$random} % 16'd65535;
			#my_rand key_in = ~key_in;
		end
		key_in = 1'b0;
		#50_000_000;  //- 按下稳定
			
		repeat(50) begin //- 50次随机释放抖动
			my_rand = {$random} % 16'd65535;
			#my_rand key_in = ~key_in;
		end
		key_in = 1'b1;
		#50_000_000; //- 释放稳定			
					
	end
 
endtask
*/

//- 调用仿真模型
key_model u_key_model(
		.key(key_in) 		
		);


//- 调用按键仿真模型，就只需要产生时钟和复位信号就可以了
initial begin
	rst_n  = 0;
	#(10 * `clk_period) rst_n = 1;
	#30000;
	
/*	
	//- 任务调用的方式产生按键抖动 
	
	press_key; #10000;
	press_key; #10000
	press_key; #10000
	
	$stop;
*/
	
/*	
	//- 人为产生按键抖动，产生3次按键松开动作
	
	key_in = 1'b1;
	#1000 key_in = 1'b0;
	#2000 key_in = 1'b1;
	#1500 key_in = 1'b0;
	#2800 key_in = 1'b1;
	#1200 key_in = 1'b0;
	#3000 key_in = 1'b1;
	#1000 key_in = 1'b0;
	#20_000_000;
	
	key_in = 1'b0;
	#1000 key_in = 1'b1;
	#2000 key_in = 1'b0;
	#1500 key_in = 1'b1;
	#2800 key_in = 1'b0;
	#1200 key_in = 1'b1;
	#3000 key_in = 1'b0;
	#1000 key_in = 1'b1;
	#20_500_000; 
		
	key_in = 1'b1;
	#1000 key_in = 1'b0;
	#2000 key_in = 1'b1;
	#1500 key_in = 1'b0;
	#2800 key_in = 1'b1;
	#1200 key_in = 1'b0;
	#3000 key_in = 1'b1;
	#1000 key_in = 1'b0;
	#20_500_000;
	
	key_in = 1'b0;
	#1000 key_in = 1'b1;
	#2000 key_in = 1'b0;
	#1500 key_in = 1'b1;
	#2800 key_in = 1'b0;
	#1200 key_in = 1'b1;
	#3000 key_in = 1'b0;
	#1000 key_in = 1'b1;
	#20_500_000; 
	
	key_in = 1'b1;
	#1000 key_in = 1'b0;
	#2000 key_in = 1'b1;
	#1500 key_in = 1'b0;
	#2800 key_in = 1'b1;
	#1200 key_in = 1'b0;
	#3000 key_in = 1'b1;
	#1000 key_in = 1'b0;
	#20_500_000;
	
	key_in = 1'b0;
	#1000 key_in = 1'b1;
	#2000 key_in = 1'b0;
	#1500 key_in = 1'b1;
	#2800 key_in = 1'b0;
	#1200 key_in = 1'b1;
	#3000 key_in = 1'b0;
	#1000 key_in = 1'b1;
	#20_500_000;

	$stop;

*/	
end	
	
//- 按键消抖模块例化	
key_filter u_key_filter(
		.Clk		 	 (clk),
		.Rst_n		 (rst_n),
		.key_in	 	 (key_in),
		.key_flag	 (key_flag),
		.key_state 	 (key_state)
		);
	



endmodule
