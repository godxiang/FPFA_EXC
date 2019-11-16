
//- 仿真模型概念。即将一系列的仿真语句封装成一个整体
//	 例如按键仿真，将一系列的按键抖动动作封装成一个整体，就输出一个按键的状态给其他模块使用

`timescale 1ns/1ns

module key_model(press,key);

	output reg key;
	input press;
	
always @(posedge press) begin
	press_key;	
end
	
	initial begin
		key = 1'b1;	
	/*	
		press_key;
		#10000;
		press_key;
		#10000;		
		$stop;
	*/
	end

	
	reg [15:0]my_rand;
	
	task press_key;
		begin
			repeat(50) begin
				my_rand = {$random} % 16'd65535;
				#my_rand key = ~key;				
			end
			key = 1'b0;
			#50_000_000;	
			
			repeat(50) begin
			my_rand = {$random} % 16'd65535;
			#my_rand key = ~key;				
			end
			key = 1'b1;
			#50_000_000;				
		end
	
	endtask
	
endmodule	