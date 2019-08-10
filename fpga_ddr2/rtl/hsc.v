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
			output led,	//用于测试的LED指示灯	
	
				//- ddr2 chip interface
			output	[1:0]	mem_ba,			//The memory bank address bus.	
			output	[12:0]mem_addr,		//The memory row and column address bus.
			output	[0:0]	mem_cke,			//The memory clock enable.
			output	[0:0]	mem_cs_n,		//The memory chip select signal.	
			output		   mem_ras_n,		//The memory row address strobe.	
			output		   mem_cas_n,		//The memory column address strobe.	
			output		   mem_we_n,		//The memory write-enable signal.	
			output	[1:0]	mem_dm,			//The optional memory data mask bus.
			output	[0:0]	mem_odt,			//The memory on-die termination control signal.
			inout		[0:0]	mem_clk,			//The memory clock, positive edge clock. Output is for memory device, and input path is fed back to ALTMEMPHY megafunction for VT tracking.
			inout		[0:0]	mem_clk_n,		//The memory clock, negative edge clock. Output is for memory device, and input path is fed back to ALTMEMPHY megafunction for VT tracking.
			inout		[15:0]mem_dq,			//The memory bidirectional data bus.
			inout		[1:0]	mem_dqs			//The memory bidirectional data strobe bus.	

	
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


wire wr_req;
wire [31:0]wr_data;
wire wr_load;
wire rd_req;
wire [31:0]rd_data;
wire rd_load;
wire init_done;
wire error_flag;
wire usr_phyclk;


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
hsc_ddr2_top u4_hsc_ddr2_top(
		.ref_clk				(clk_100m),				//ddr2 reference clk
		.rst_n				(sys_rst_n),			//system reset
		.usr_phyclk			(usr_phyclk),			//output ddr2  operate clk
				
		.wr_clk				(clk_50m),				//user write clk
		.wr_req				(wr_req),				//user write request
		.wr_data				(wr_data),				//user write data 
		.wr_maxaddr			(24'd1024),				//user write max address
		.wr_minaddr			(24'd0),					//user write min address
		.wr_load				(~sys_rst_n),				//user write port reset ,reset write address and fifo			
				
		.rd_clk				(clk_50m),				//user read clk
		.rd_req				(rd_req),				//user read request
		.rd_data				(rd_data),				//user read data 
		.rd_maxaddr			(24'd1024),				//user read max address
		.rd_minaddr			(24'd0),					//user read min address
		.rd_load				(~sys_rst_n),				//user read port reset ,reset read address and fifo	
		
		.wr_rd_burst		(7'd64),					//read/write burst length 
		
		.local_init_done	(init_done),
		
		.mem_odt				(mem_odt),
		.mem_cs_n			(mem_cs_n),
		.mem_cke				(mem_cke),
		.mem_addr			(mem_addr),
		.mem_ba				(mem_ba),
		.mem_ras_n			(mem_ras_n),
		.mem_cas_n			(mem_cas_n),
		.mem_we_n			(mem_we_n),
		.mem_dm				(mem_dm),
		.mem_clk				(mem_clk),	 
		.mem_clk_n			(mem_clk_n),
		.mem_dq				(mem_dq),
		.mem_dqs				(mem_dqs)
			
	);			

	
/*	
//- ddr2 test module 	
ddr2_test u5_ddr2_test(
		.clk					(clk_50m),
		.rst_n				(sys_rst_n),
		
		.wr_en				(wr_req),        	   //SDRAM 写使能
		.wr_data				(wr_data),         	//SDRAM 写入的数据
		.rd_en				(rd_req),         	//SDRAM 读使能
		.rd_data				(rd_data),           //SDRAM 读出的数据
	 
		.ddr2_init_done	(init_done),  			//SDRAM 初始化完成标志
		.error_flag			(error_flag)        	//SDRAM 读写测试错误标志

	);
	
*/	
			
			
endmodule


