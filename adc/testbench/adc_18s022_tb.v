
`timescale 1ns/1ns

`define Clk_period 20

module adc_18s022_tb;


reg  Clk;								//输入系统操作时钟，50M
reg  Rst_n;								//输入系统复位
              
reg  En_convert;						//输入脉冲，使能ADC转换
reg  [2:0]Adc_channel;				//ADC通道地址
	                  
wire Convert_done;					//输出脉冲，ADC转换结束
wire Adc_state;						//转换标志，转换过程中一直为高 ne;	
wire [11:0] Adc_result;				//输出ADC转换结果 4BIT0 + 12BIT 转换结果
 
wire ADC_CS;							//ADC片选信号
wire ADC_SCLK;							//ADC时钟信号 0.5~3.2MHZ, 此处操作频率设置为1.92MHZ，操作周期为520ns
wire ADC_DI;							//ADC信号输入

reg  ADC_DO;							//ADC信号输出
		

initial Clk = 0;		
always #(`Clk_period / 2)	Clk = ~Clk;

initial begin
	
	En_convert  = 1'b0;
	Adc_channel = 3'b0;
	Rst_n = 1'b0;
	#(10*`Clk_period)Rst_n = 1'b1;
	
	#(20 * `Clk_period + 1);
	Adc_channel = 5;
	En_convert = 1'b1;
	#(`Clk_period );
	En_convert = 1'b0;
	@(posedge Convert_done);
	
	#3000;
	Adc_channel = 3;
	En_convert = 1'b1;
	#(`Clk_period );
	En_convert = 1'b0;
	@(posedge Convert_done);
	
	#3000;
	$stop;

end	
		
adc_18s022 u_adc_18s022(
	.Clk(Clk),					
	.Rst_n(Rst_n),				
	
	.En_convert(En_convert),	
	.Adc_channel(Adc_channel),
	
	.Convert_done(Convert_done),		
	.Adc_state(Adc_state),				
	.Adc_result(Adc_result),			
	
	.ADC_CS(ADC_CS),
	.ADC_SCLK(ADC_SCLK),
	.ADC_DI(ADC_DI),
	.ADC_DO(ADC_DO)		
);





endmodule



