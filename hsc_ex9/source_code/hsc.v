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
module hsc(
				//外部输入时钟和复位接口
			input ext_clk,		//外部25MHz输入时钟	
			input ext_rst_n,	//外部低电平复位信号输入
				//FX3 Slave FIFO接口
			input fx3_flaga,	//地址00时，slave fifo写入满标志位
			input fx3_flagb,	//地址00时，slave fifo写入快满标志位，该位拉低后还可以写入6个Byte数据
			input fx3_flagc,	//ctl[8]，地址11时，slave fifo读空标志位
			input fx3_flagd,	//ctl[9]，地址11时，slave fifo读快空标志位，该位拉低后还可以写入6个Byte数据（该信号处上电为高电平）
			output fx3_pclk,		//Slave FIFO同步时钟信号
			output fx3_slcs_n,		//Slave FIFO片选信号，低电平有效
			output fx3_slwr_n,		//Slave FIFO写使能信号，低电平有效
			output fx3_slrd_n,		//Slave FIFO读使能信号，低电平有效
			output fx3_sloe_n,		//Slave FIFO输出使能信号，低电平有效
			output fx3_pktend_n,
			output[1:0] fx3_a,
			inout[31:0] fx3_db,			
				//LED指示灯接口
			output led	//用于测试的LED指示灯			
		);

		

////////////////////////////////////////////////////		
//系统内部时钟和复位产生模块例化
	//PLL输出复位和时钟，用于FPGA内部系统
wire sys_rst_n;	//系统复位信号，低电平有效
wire clk_25m;		//PLL输出25MHz	
//wire clk_33m;		//PLL输出33MHz
wire clk_50m;		//PLL输出50MHz
wire clk_65m;		//PLL输出65MHz
wire clk_100m;	//PLL输出100MHz		

sys_ctrl	u1_sys_ctrl(
				.ext_clk(ext_clk),
				.ext_rst_n(ext_rst_n),
				.sys_rst_n(sys_rst_n),
				.clk_25m(clk_25m),
				.fx3_pclk(fx3_pclk),
				.clk_50m(clk_50m),
				.clk_65m(clk_65m),
				.clk_100m(clk_100m)
			);
		
////////////////////////////////////////////////////
//LED闪烁逻辑产生模块例化

led_controller		u2_led_controller(
						.clk(clk_25m),
						.rst_n(sys_rst_n),
						.led(led)
					);
					
////////////////////////////////////////////////////	
//FX3 Slave FIFO读写操作控制模块

usb_controller		u3_usb_controller(
						.clk(clk_100m),
						.rst_n(sys_rst_n),
						.fx3_flaga(fx3_flaga),
						.fx3_flagb(fx3_flagb),
						.fx3_flagc(fx3_flagc),
						.fx3_flagd(fx3_flagd),
						//.fx3_pclk(fx3_pclk),
						.fx3_slcs_n(fx3_slcs_n),
						.fx3_slwr_n(fx3_slwr_n),
						.fx3_slrd_n(fx3_slrd_n),
						.fx3_sloe_n(fx3_sloe_n),
						.fx3_pktend_n(fx3_pktend_n),
						.fx3_a(fx3_a),
						.fx3_db(fx3_db)
					);

//- ddr2 top module			
			

endmodule


