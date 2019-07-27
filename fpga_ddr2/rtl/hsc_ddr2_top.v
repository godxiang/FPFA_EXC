//*******************************************************************
//- hsc ddr2 top file hsc_ddr2_top
//- first implement at 2019-7-22
//*******************************************************************

module hsc_ddr2_top(
	input 			ref_clk,			//ddr2 reference clk
	input   			rst_n,			//system reset
	output			usr_phyclk,		//output ddr2  operate clk
	
	//- user write port
	input    		wr_clk,			//user write clk
	input				wr_req,			//user write request
	input   [31:0] wr_data,			//user write data 
	input   [23:0] wr_maxaddr,		//user write max address
	input   [23:0]	wr_minaddr,		//user write min address
	input          wr_load,			//user write port reset ,reset write address and fifo			
	
	//- user read port
	input    		rd_clk,			//user read clk
	input				rd_req,			//user read request
	output  [31:0] rd_data,			//user read data 
	input   [23:0] rd_maxaddr,		//user read max address
	input   [23:0]	rd_minaddr,		//user read min address
	input          rd_load,			//user read port reset ,reset read address and fifo	

	input   [6:0]  wr_rd_burst,	//read/write burst length 
	
	//- user control port
	output			local_init_done,
	
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


wire reset_phy_clk_n;
wire local_address;
wire local_write_req;
wire local_wdata;
wire local_read_req;
wire local_ready;
wire local_rdata;
wire local_rdata_valid;


	
//- FIFO controller module 	

hsc_ddr2_fifoctl u_hsc_ddr2_fifoctl (
	.clk 			(usr_phyclk),						//ddr2 operate clk
	.rst_n      (rst_n),								//system reset
	
	.wr_clk     (wr_clk),							//user write clk
	.wr_req     (wr_req),							//user write request
	.wr_data 	(wr_data),							//user write data 
	.wr_maxaddr (wr_maxaddr),						//user write max address
	.wr_minaddr (wr_minaddr),						//user write min address
	.wr_load    (wr_load),							//user write port reset ,reset write address and fifo			
	
	.rd_clk     (rd_clk),							//user read clk
	.rd_req     (rd_req),							//user read request
	.rd_data    (rd_data),							//user read data 
	.rd_maxaddr (rd_maxaddr),						//user read max address
	.rd_minaddr (rd_minaddr),						//user read min address
	.rd_load    (rd_load),							//user read port reset ,reset read address and fifo	
	
	.wr_rd_burst(wr_rd_burst),						//read/write burst length 

	.local_address     (local_address),			//DDR2 read/write addr
	.local_write_req   (local_write_req),		//DDR2 write request 
	.local_wdata       (local_wdata),			//DDR2 write data
	.local_read_req    (local_read_req),		//DDR2 read request 
	.local_ready       (local_ready),			//DDR2 RD/WR ACK
	.local_rdata       (local_rdata),			//DDR2 read data
	.local_rdata_valid (local_rdata_valid),	//DDR2 read data valid signal 
	.local_init_done   (local_init_done)	   //DDR2 init done signal 
	
	);


	
//- ddr2 controller module	
ddr2_controller  u_ddr2_controller(
	.global_reset_n		(rst_n),
	.pll_ref_clk			(ref_clk),
	.soft_reset_n			(1'b1),
	.reset_phy_clk_n		(reset_phy_clk_n),
	.phy_clk					(usr_phyclk),
	.aux_full_rate_clk	(/**/),
	.aux_half_rate_clk	(/**/),
	.reset_request_n		(/**/),
		
	.local_address			(local_address),
	.local_write_req		(local_write_req),
	.local_read_req		(local_read_req),
	.local_burstbegin		(local_write_req | local_read_req),
	.local_wdata			(local_wdata),
	.local_be				(4'b1111),
	.local_size				(wr_rd_burst),
	.local_ready			(local_ready),
	.local_rdata			(local_rdata),
	.local_rdata_valid	(local_rdata_valid),
	.local_init_done		(local_init_done),
	.local_refresh_ack	(/**/),

	.mem_odt					(mem_odt),
	.mem_cs_n				(mem_cs_n),
	.mem_cke					(mem_cke),
	.mem_addr				(mem_addr),
	.mem_ba					(mem_ba),
	.mem_ras_n				(mem_ras_n),
	.mem_cas_n				(mem_cas_n),
	.mem_we_n				(mem_we_n),
	.mem_dm					(mem_dm),
	.mem_clk					(mem_clk),	 
	.mem_clk_n				(mem_clk_n),
	.mem_dq					(mem_dq),
	.mem_dqs					(mem_dqs)
	
);

	
endmodule


