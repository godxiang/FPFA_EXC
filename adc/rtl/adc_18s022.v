
/**********************************************************\
	Filename		:	 adc_18s022.v
	Author  	   :   eric_xiang
	Description :   adc18s022 drive source code
	Revision		:   2019-11-18
	Company		:   personal
\**********************************************************/

module adc_18s022(
	Clk,					
	Rst_n,				
	
	En_convert,	
	
	Convert_done,		
	Adc_state,				
	Adc_result,			
	
	ADC_CS,
	ADC_SCLK,
	ADC_DI,
	ADC_DO		
);


input  Clk;								//输入系统操作时钟，50M
input  Rst_n;							//输入系统复位
                     
input  En_convert;					//输入脉冲，使能ADC转换
	                  
output reg Convert_done				//输出脉冲，ADC转换结束
output reg Adc_state;				//转换标志，转换过程中一直为高 ne;	
output reg [11:0] Adc_result;		//输出ADC转换结果

output reg ADC_CS;					//ADC片选信号
output reg ADC_SCLK;					//ADC时钟信号 0.5~3.2MHZ, 此处操作频率设置为1.92MHZ，操作周期为520ns
output reg ADC_DO;					//ADC信号写
input      ADC_DI;					//ADC信号读


//localparam ADC_PERIOD  = 12'd520; //ADC时钟周期

reg [3:0]sclk2x_cnt;
reg sclk2x;								//ADC两倍操作时钟
reg [7:0]sclk2x_poscnt;

/****************************************************************/

//Adc_state 标志一次转换的开始和结束
always @(posedge Clk or negedge Rst_n) begin
	if (!RST_n) begin
		Adc_state <= 1'b0;
	end else if (En_convert) begin
		Adc_state <= 1'b1;
	end else if () begin
	
	end else begin
		Adc_state <= Adc_state;
	end
end

//由系统时钟得到ADC操作频率两倍的时钟SCLK2X 20ns->260ns
always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		sclk2x_cnt <= 4'd0;
	end else if (Adc_state && sclk2x_cnt < 4'd12) begin
		sclk2x_cnt <= sclk2x_cnt + 1'b1;
	end else begin
		sclk2x_cnt <= 4'd0;
	end

end


always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		sclk2x <= 1'b0;
	end else if (sclk2x_cnt == 4'd12) begin
		sclk2x <= 1'b1;
	end else begin
		sclk2x <= 1'b0;
	end

end


// 对sclk2x上升沿进行计数
always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		sclk2x_poscnt <= 8'd0;
	end else if (sclk2x_poscnt <= 8'd33) begin
		if (sclk2x) begin
			sclk2x_poscnt <= sclk2x_poscnt + 1'b1;
		end else begin
			sclk2x_poscnt <= sclk2x_poscnt;
		end
	end else begin
		sclk2x_poscnt <= 8'd0;
	end	
end

endmodule
