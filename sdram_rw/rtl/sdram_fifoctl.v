//************************************************************
//	-SDRAM FIFO CONTROL MODULE 
// -2019-7-19,first implement 
//************************************************************

module sdram_fifoctl(
	input  clk_ref,						//SDRAM CONTROL CLK
	input  rst_n,							//SYSTEM RESET

	//- user write port
	input    	wr_clk,					// user write clk
	input    	wr_en						// user write enable
	input [15:0]wr_data,					// user write data
	input	[23:0]wr_minaddr,				// user write min addr
	input [23:0]wr_maxaddr,				// user write max addr
	input       wr_len,					// user write len 
	input       wr_load,					// user write reset	reset write addr and write fifo
	
	//- user read port
	input    	rd_clk,					// user read clk
	input    	rd_en,					// user read enable
	output [15:0]rd_data,				// user read data
	input	[23:0]rd_minaddr,				// user read min addr
	input [23:0]rd_maxaddr,				// user read max addr
	input       rd_len,					// user read len 
	input       rd_load,					// user read reset	reset read addr and read fifo

	//用户控制端口	                     
	input       sdram_read_valid,     //SDRAM 读使能
	input       sdram_init_done,      //SDRAM 初始化完成标志
	
   //SDRAM 控制器写端口                 
	output reg		   sdram_wr_req,	 //sdram 写请求
	input             sdram_wr_ack,	 //sdram 写响应
	output reg [23:0] sdram_wr_addr,	 //sdram 写地址
	output	  [15:0] sdram_din,		 //写入SDRAM中的数据 
                                         
    //SDRAM 控制器读端口                 
	output reg        sdram_rd_req,	 //sdram 读请求
	input             sdram_rd_ack,	 //sdram 读响应
	output reg [23:0] sdram_rd_addr,	 //sdram 读地址 
	input      [15:0] sdram_dout 		 //从SDRAM中读出的数据 
	
	
	);

	
wire [9:0] wr_use;
wire [9:0] rd_use;


//- 产生读写信号
always @(posedge clk_ref or negedge rst_n) begin
	if (!rst_n) begin
		sdram_wr_req <= 1'b0;
		sdram_rd_req <= 1'b0;
	end
	else if (sdram_init_done) begin	//SDRAM init done
		//write FIFO's data more than burst length
		if (wr_use >= wr_len) begin
			sdram_wr_req <= 1'b1;
			sdram_rd_req <= 1'b0;
		end
		else if ((rd_use < rd_len) && )
		
	end
	else begin
		sdram_wr_req <= 1'b0;
		sdram_rd_req <= 1'b0;
	end
	
end

	
	
//- write fifo inst 
wr_fifo	u_ wr_fifo(
	.wrclk 	( wr_clk ),
	.wrreq 	( wr_en ),
	.data 	( wr_data ),
	
	.rdclk 	( clk_ref ),
	.rdreq 	( sdram_wr_ack ),
	.q 		( sdram_din ),
	
	.rdusedw ( wr_use ),
	.aclr 	( ~rst_n | wr_load)
	);

//- read fifo inst 
rd_fifo	u_rd_fifo (
	.wrclk 	( clk_ref ),
	.wrreq 	( sdram_rd_ack ),
	.data 	( sdram_dout ),
	
	.rdclk 	( rd_clk ),
	.rdreq 	( rd_en ),
	.q 		( rd_data ),
	
	.wrusedw ( rd_use ),
	.aclr 	(  ~rst_n | rd_load )
	);
	
	
	
endmodule
