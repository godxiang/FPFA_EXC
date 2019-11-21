
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
	Adc_channel,
	
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
input  [2:0]Adc_channel;			//ADC通道地址
	                  
output reg Convert_done;			//输出脉冲，ADC转换结束
output reg Adc_state;				//转换标志，转换过程中一直为高 ne;	
output reg [11:0] Adc_result;		//输出ADC转换结果 4BIT0 + 12BIT 转换结果

output reg ADC_CS;					//ADC片选信号
output reg ADC_SCLK;					//ADC时钟信号 0.5~3.2MHZ, 此处操作频率设置为1.92MHZ，操作周期为520ns
output reg ADC_DI;					//ADC信号输入
input  ADC_DO;							//ADC信号输出


//localparam ADC_PERIOD  = 12'd520; //ADC时钟周期

reg [3:0]sclk2x_cnt;
reg sclk2x;								//ADC两倍操作时钟
reg [7:0]sclk2x_poscnt;
reg [2:0]rADC_CHAN;

/****************************************************************/

//每次使能转化时，寄存ADC通道地址
always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		rADC_CHAN <= 3'd0;
	end else if (En_convert) begin
		rADC_CHAN <= Adc_channel;
	end else begin
		rADC_CHAN <= rADC_CHAN;
	end
end


//Adc_state 标志一次转换的开始和结束
always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		Adc_state <= 1'b0;
	end else if (En_convert) begin
		Adc_state <= 1'b1;
	end else if (Convert_done) begin
		Adc_state <= 1'b0;
	end else begin
		Adc_state <= Adc_state;
	end
end

//Convert_done
always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		Convert_done <= 1'b0;
	end else if (sclk2x_poscnt == 8'd33 && sclk2x) begin
		Convert_done <= 1'b1;
	end else begin
		Convert_done <= 1'b0;
	end
end

//由系统时钟得到ADC操作频率两倍的时钟SCLK2X 20ns->260ns
always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		sclk2x_cnt <= 4'd0;
	end else if (Adc_state && sclk2x_cnt < 4'd13) begin
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
	end else if (sclk2x) begin	
		if (sclk2x_poscnt == 8'd33) begin
			sclk2x_poscnt <= 8'd0;
		end else begin
			sclk2x_poscnt <= sclk2x_poscnt + 1'b1;
		end	
	end else begin
		sclk2x_poscnt <= sclk2x_poscnt;
	end	
end


//由sclk2x的计数输出/输入ADC信号
always @(posedge Clk or negedge Rst_n) begin
	if (!Rst_n) begin
		ADC_CS   <= 1'b1;
		ADC_SCLK <= 1'b1;
		ADC_DI   <= 1'b1;
	end else if (sclk2x) begin
		case (sclk2x_poscnt) 
			8'd0: ADC_CS <= 1'b0;
			8'd1: ADC_SCLK <= 1'b0;
			8'd2: ADC_SCLK <= 1'b1;
			8'd3: ADC_SCLK <= 1'b0;
			8'd4: ADC_SCLK <= 1'b1;
			8'd5: begin ADC_SCLK <= 1'b0; ADC_DI <= rADC_CHAN[2]; end
			8'd6: ADC_SCLK <= 1'b1;
			8'd7: begin ADC_SCLK <= 1'b0; ADC_DI <= rADC_CHAN[1]; end
			8'd8: ADC_SCLK <= 1'b1;
			8'd9: begin ADC_SCLK <= 1'b0; ADC_DI <= rADC_CHAN[0]; end
			8'd10,8'd12,8'd14,8'd16,8'd18,8'd20,8'd22,8'd24,8'd26,8'd28,8'd30,8'd32:  begin 
					ADC_SCLK <= 1'b1;
					Adc_result <= {Adc_result[10:0],ADC_DO};
			end
			8'd11,8'd13,8'd15,8'd17,8'd19,8'd21,8'd23,8'd25,8'd27,8'd29,8'd31: ADC_SCLK <= 1'b0;
			8'd33: ADC_CS <= 1'b1;
			default: ADC_CS <= 1'b1;
		endcase
	end
end


endmodule
