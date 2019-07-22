
//******************************************************
// - sdram controller module 
// first implement at 2019-7-20
//******************************************************

module sdram_controller(
	input		clk,			//sdram operate clk 100M
	input    rst_n,		//system reset
	
	//sdram write port
	input			 sdram_wr_req,	 	 //sdram 写请求
	output   	 sdram_wr_ack,	 	 //sdram 写响应
	input [23:0] sdram_wr_addr,	 //sdram 写地址
	input	[15:0] sdram_din,		 	 //写入SDRAM中的数据 
                                         
    //SDRAM 控制器读端口                 
	input        sdram_rd_req,	 	  //sdram 读请求
	output       sdram_rd_ack,	 	  //sdram 读响应
	input [23:0] sdram_rd_addr,	  //sdram 读地址 
	output[15:0] sdram_dout 		  //从SDRAM中读出的数据 
	
	output	    sdram_init_done,   //SDRAM 初始化完成标志		 	
	
	//sdrma chip interface
	output 		 sdram_clk,	   	  //SDRAM clk
	output 		 sdram_cke,	   	  //SDRAM clk valid
	output 		 sdram_cs_n,		  //SDRAM cs
	output 		 sdram_ras_n,  	  //SDRAM row valid
	output 		 sdram_cas_n,		  //SDRAM coloum valid
	output 		 sdram_we_n,		  //SDRAM write enable
	output [1:0] sdram_ba,			  //SDRAM write bank
	output [12:0]sdram_addr,		  //SDRAM addr
	inout  [15:0]sdram_data,		  //SDRAM data
	output [1:0] sdram_dqm			  //SDRAM data mask
		
	);


//- sdram state control module

//- sdram command control module 

//- sdram data rd/wr module 
	
endmodule	
