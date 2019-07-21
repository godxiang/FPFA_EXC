//************************************************************
//	-SDRAM FIFO CONTROL MODULE 
// -2019-7-19,first implement 
//************************************************************

module sdram_fifoctl(
	input  clk_ref,						//SDRAM CONTROL CLK
	input  rst_n,							//SYSTEM RESET

	//- user write port
	input    	wr_clk,					// user write clk
	input    	wr_en,					// user write enable
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

reg sdram_read_valid1;
reg sdram_read_valid2;

reg wr_load_r1;
reg wr_load_r2;
wire wr_load_flag;

reg rd_load_r1;
reg rd_load_r2;
wire rd_load_flag;

reg sdram_wr_ack_r1;
reg sdram_wr_ack_r2;
wire sdram_wr_ack_flag;

reg sdram_rd_ack_r1;
reg sdram_rd_ack_r2;
wire sdram_rd_ack_flag;

//- check ack falling edge
assign sdram_wr_ack_flag = ~sdram_wr_ack_r1 & sdram_wr_ack_r2;
assign sdram_rd_ack_flag = ~sdram_rd_ack_r1 & sdram_rd_ack_r2;

//- check load signal rising edge
assign wr_load_flag = wr_load_r1 & ~wr_load_r2;
assign rd_load_flag = rd_load_r1 & ~rd_load_r2;


//- 同步读使能信号
always @(posedge clk_ref or negedge rst_n) begin
	if (!rst_n) begin
		sdram_read_valid1 <= 1'b0;
		sdram_read_valid2 <= 1'b0;
	end
	else begin
		sdram_read_valid1 <= sdram_read_valid;
		sdram_read_valid2 <= sdram_read_valid1;
	end	
end


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
		else if ((rd_use < rd_len) && sdram_read_valid2) begin
			sdram_wr_req <= 1'b0;
			sdram_rd_req <= 1'b1;
		end		
	end
	else begin
		sdram_wr_req <= 1'b0;
		sdram_rd_req <= 1'b0;
	end
	
end


//- sync write port reset signal and capture rising edge
always @(posedge clk_ref or negedge rst_n) begin
	if (!rst_n) begin
		wr_load_r1 <= 1'b0;
		wr_load_r2 <= 1'b0;
	end
	else begin
		wr_load_r1 <= wr_load;
		wr_load_r2 <= wr_load_r1;
	end
end


//- sync read port reset signal and capture rising edge
always @(posedge clk_ref or negedge rst_n) begin
	if (!rst_n) begin
		rd_load_r1 <= 1'b0;
		rd_load_r2 <= 1'b0;
	end
	else begin
		rd_load_r1 <= rd_load;
		rd_load_r2 <= rd_load_r1;
	end
end


always @(posedge clk_ref or negedge rst_n) begin
	if (!rst_n) begin
		sdram_wr_ack_r1 <= 1'b0;
		sdram_wr_ack_r2 <= 1'b0;
	end
	else begin
		sdram_wr_ack_r1 <= sdram_wr_ack;
		sdram_wr_ack_r2 <= sdram_wr_ack_r1;
	end
end


always @(posedge clk_ref or negedge rst_n) begin
	if (!rst_n) begin
		sdram_rd_ack_r1 <= 1'b0;
		sdram_rd_ack_r2 <= 1'b0;
	end
	else begin
		sdram_rd_ack_r1 <= sdram_rd_ack;
		sdram_rd_ack_r2 <= sdram_rd_ack_r1;
	end
end


//- 产生写地址信号
always @(posedge clk_ref or negedge rst_n) begin
	if (!rst_n) begin
		sdram_wr_addr <= 24'd0;
	end
	else begin
		if (wr_load_flag) begin
			sdram_wr_addr <= wr_minaddr;
		end
		else begin
			if (sdram_wr_addr < wr_maxaddr - wr_len) begin
				if (sdram_wr_ack_flag) begin
					sdram_wr_addr <= sdram_wr_addr + wr_len;
				end
				else 
					sdram_wr_addr <= sdram_wr_addr;
			end
			else begin
					sdram_wr_addr <= wr_minaddr;
			end
		end
	end
	
end


//- 产生读地址信号
always @(posedge clk_ref or negedge rst_n) begin
	if (!rst_n) begin
		sdram_rd_addr <= 24'd0;
	end
	else begin
		if (rd_load_flag) begin
			sdram_rd_addr <= rd_minaddr;
		end
		else begin
			if (sdram_rd_addr < rd_maxaddr - rd_len) begin
				if (sdram_rd_ack_flag) begin
					sdram_rd_addr <= sdram_rd_addr + rd_len;
				end
				else begin
					sdram_rd_addr <= sdram_rd_addr;
				end
			end
			else begin
					sdram_rd_addr <= rd_minaddr;
			end
		end
	end
	
end

	
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
	

//- write fifo inst 
wr_fifo	u_wr_fifo (
	.wrclk 	( wr_clk ),
	.wrreq 	( wr_en ),
	.data 	( wr_data ),
	
	.rdclk 	( clk_ref ),
	.rdreq 	( sdram_wr_ack ),
	.q 		( sdram_din ),
	
	.rdusedw ( wr_use ),
	.aclr 	( ~rst_n | wr_load)
	);

	
endmodule
