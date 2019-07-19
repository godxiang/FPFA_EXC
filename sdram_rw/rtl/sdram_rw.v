
//*************************************************
//	-sdram读写测试实验
// -2019-7-18,first implement 
//*************************************************

module sdram_rw(
	
	input clk,					//FPGA外部时钟
	input rst_n,		   	//复位，低电平有效
	
	output sdram_clk,	   	//SDRAM芯片时钟
	output sdram_cke,	   	//SDRAM时钟有效信号
	output sdram_cs_n,		//SDRAM片选信号
	output sdram_ras_n,  	//SDRAM行有效
	output sdram_cas_n,		//SDRAM列有效
	output sdram_we_n,		//SDRAM写使能
	output [1:0]sdram_ba,	//SDRAMbank地址
	output [12:0]sdram_addr,//SDRAM行列地址
	inout  [15:0]sdram_data,//SDRAM数据
	output [1:0]sdram_dqm,	//SDRAM数据掩码
	
	//指示信号		
	output led 					//输出LED灯
	
	);


wire        clk_50m;                        //SDRAM 读写测试时钟
wire        clk_100m;                       //SDRAM 控制器时钟
wire        clk_100m_shift;                 //相位偏移时钟	

wire        locked;	



	
//- PLL模块，产生各模块需要时钟
pll_clk	u0_pll_clk (
	.inclk0 ( clk ),
	.c0 ( clk_50m ),
	.c1 ( clk_100m ),
	.c2 ( clk_100m_shift ),
	.locked ( locked )
	);

	
// -SDRAM控制器模块，封装成FIFO接口	



	
	
endmodule	



