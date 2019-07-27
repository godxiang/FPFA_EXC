/////////////////////////////////////////////////////////////////////////////
//Altera ATPP合作伙伴 至芯科技 携手 特权同学 共同打造 FPGA开发板系列
//工程硬件平台： Altera Cyclone IV FPGA 
//开发套件型号： SF-HSC (USB3.0) 特权打造
//版   权  申   明： 本例程由《深入浅出玩转FPGA》作者“特权同学”原创，
//				仅供SF-HSC开发套件学习使用，谢谢支持
//官方淘宝店铺： http://myfpga.taobao.com/
//最新资料下载： http://pan.baidu.com/s/1pLmZaFx
//公                司： 上海或与电子科技有限公司
/////////////////////////////////////////////////////////////////////////////
//系统内部时钟和复位产生模块
module sys_ctrl(
				//FPGA外部输入时钟和复位	
			input ext_clk,		//外部25MHz输入时钟	
			input ext_rst_n,	//外部低电平复位信号输入
				//PLL输出复位和时钟，用于FPGA内部系统
			output reg sys_rst_n,	//系统复位信号，低电平有效
			output clk_25m,		//PLL输出25MHz	
			output fx3_pclk,	//PLL输出100MHz，与clk_100m有相位差
			output clk_50m,		//PLL输出50MHz
			output clk_65m,		//PLL输出65MHz
			output clk_100m		//PLL输出100MHz
		);

////////////////////////////////////////////////////
//PLL复位信号产生，高有效
//异步复位，同步释放

reg rst_r1,rst_r2;

always @(posedge ext_clk or negedge ext_rst_n)
	if(!ext_rst_n) rst_r1 <= 1'b0;
	else rst_r1 <= 1'b1;

always @(posedge ext_clk or negedge ext_rst_n)
	if(!ext_rst_n) rst_r2 <= 1'b0;
	else rst_r2 <= rst_r1;

////////////////////////////////////////////////////
//PLL模块例化
wire locked;	//PLL输出锁定状态，高电平有效

pll_controller	pll_controller_inst (
					.areset ( !rst_r2 ),
					.inclk0 ( ext_clk ),
					.c0 ( clk_25m ),
					.c1 ( fx3_pclk ),
					.c2 ( clk_50m ),
					.c3 ( clk_65m ),
					.c4 ( clk_100m ),
					.locked ( locked )
				);


//----------------------------------------------
//系统复位处理逻辑
reg sys_rst_nr;

always @(posedge clk_100m)
	if(!locked) sys_rst_nr <= 1'b0;
	else sys_rst_nr <= 1'b1;

always @(posedge clk_100m or negedge sys_rst_nr)
	if(!sys_rst_nr) sys_rst_n <= 1'b0;
	else sys_rst_n <= sys_rst_nr;


endmodule

