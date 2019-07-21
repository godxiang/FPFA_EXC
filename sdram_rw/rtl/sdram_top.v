
//************************************************************
//	-SDRAM顶层模块 SDRAM_TOP
// -2019-7-18,first implement 
// -sdram top file, include FIFO CONTROL AND SDRAM CONTROLLER 
//************************************************************

module sdram_top(	
	input   		ref_clk, 			//reference clk
	output		out_clk,				//output phase offset clk   
	input    	rst_n,				//system reset
	
	//- user write port
	input    	wr_clk,				// user write clk
	input    	wr_en,				// user write enable
	input [15:0]wr_data,				// user write data
	input	[23:0]wr_minaddr,			// user write min addr
	input [23:0]wr_maxaddr,			// user write max addr
	input       wr_len,				// user write len 
	input       wr_load,				// user write reset	reset write addr and write fifo
	
	//- user read port
	input    	rd_clk,				// user read clk
	input    	rd_en,				// user read enable
	output [15:0]rd_data,			// user read data
	input	[23:0]rd_minaddr,			// user read min addr
	input [23:0]rd_maxaddr,			// user read max addr
	input       rd_len,				// user read len 
	input       rd_load,				// user read reset	reset read addr and read fifo
	
	//用户控制端口	                     
	input       sdram_read_valid,  //SDRAM 读使能
	input       sdram_init_done,   //SDRAM 初始化完成标志
	
	//- sdram chip interface
	output sdram_clk,	   			//SDRAM clk
	output sdram_cke,	   			//SDRAM clk valid
	output sdram_cs_n,				//SDRAM cs
	output sdram_ras_n,  			//SDRAM row valid
	output sdram_cas_n,				//SDRAM coloum valid
	output sdram_we_n,				//SDRAM write enable
	output [1:0]sdram_ba,			//SDRAM write bank
	output [12:0]sdram_addr,		//SDRAM addr
	inout  [15:0]sdram_data,		//SDRAM data
	output [1:0]sdram_dqm			//SDRAM data mask
	
	);


//- FIFO control module

//- SDRAM control module

	
endmodule	