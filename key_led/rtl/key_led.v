
//*********************************************
// - 按键消抖学习例程序
// - 目的是为了学习，仿真的相关技术。
// - time: 2019-10-9,auther:wangxiang  
//---------------------------------------------
// - 实验现象：两个按键，按下按键0，4个LED显示状态
//   以二进制格式加1.按下按键1，4个LED显示状态以二进制
//   格式减1
//---------------------------------------------
// - 知识点：1.testbench中随机数发生函数$random的使用
//				2.仿真模型的概念
//*********************************************


module key_led(

	input 	    clk,
	input 	    rst_n,
	
	input 	    key_in0,
	input 	  	 key_in1,

	output [3:0] led
);


wire key_flag0;
wire key_state0;

wire key_flag1;
wire key_state1;

//- 按键消除抖动

key_filter u_key_filter0(
	.Clk			(clk),	
	.Rst_n		(rst_n),
	.key_in		(key_in0),
	.key_flag	(key_flag0),
	.key_state	(key_state0)
);

key_filter u_key_filter1(
	.Clk			(clk),	
	.Rst_n		(rst_n),
	.key_in		(key_in1),
	.key_flag	(key_flag1),
	.key_state	(key_state1)
);

//- led 控制
led_ctrl u_led_ctrl(
	 .clk			(clk),
	 .rst_n		(rst_n),

	 .key_flag0	(key_flag0),
	 .key_state0(key_state0),
	
	 .key_flag1	(key_flag1),
	 .key_state1(key_state1),

	 .led			(led)
);

	
endmodule







