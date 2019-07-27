//*******************************************************************
//- hsc ddr2 fifo controller module hsc_ddr2_fifoctl.v
//- first implement at 2019-7-22
//*******************************************************************

module hsc_ddr2_fifoctl(
	input 			clk,				//ddr2 operate clk
	input   			rst_n,			//system reset
	
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
		
	//- ddr2 controller port	
	output		[23:0]local_address,
	output			local_write_req,
	output		[31:0]local_wdata,	
	output			local_read_req,
	input				local_ready,
	input		[31:0]	local_rdata,
	input					local_rdata_valid,
	input					local_init_done
	
	);

	
wire [9:0]wr_useddw;
wire [9:0]rd_useddw;	
wire local_ready_flag; 
wire wr_load_flag;
wire rd_load_flag;

reg local_ready_r1;
reg local_ready_r2; 
reg wr_load_r1;
reg wr_load_r2;
reg rd_load_r1;
reg rd_load_r2;

reg [23:0]ddr2_wr_addr;
reg [23:0]ddr2_rd_addr;

parameter SIDLE = 4'd0;
parameter SWRDB = 4'd1;
parameter SRDDB = 4'd2;
parameter SSTOP = 4'd3;

reg [3:0]cstate;
reg [23:0]num;


//- read/write request
wire wr_req_st;
wire rd_req_st;

//- detect load signal rising edging
assign wr_load_flag = wr_load_r1 & ~wr_load_r2;
assign rd_load_flag = rd_load_r1 & ~rd_load_r2;

//- deal read/write request
assign local_write_req = (cstate == SWRDB);
assign local_read_req  = (cstate == SRDDB);

//- local_address
assign local_address = (cstate == SWRDB)? ddr2_wr_addr : ddr2_rd_addr;

//assign wr_req_st = (local_init_done)?((wr_useddw >= wr_rd_burst)? 1'b1 : 1'b0) : 1'b0; 
assign rd_req_st = (local_init_done)?((rd_useddw < wr_rd_burst)? 1'b1 : 1'b0) : 1'b0; 


//- sync local_ready signal
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		local_ready_r1 <= 1'b0;
		local_ready_r2 <= 1'b0;
	end
	else begin
		local_ready_r1 <= local_ready;
		local_ready_r2 <= local_ready_r1;
	end
end


always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		wr_load_r1 <= 1'b0;
		wr_load_r2 <= 1'b0;
	end
	else begin
		wr_load_r1 <= wr_load;
		wr_load_r2 <= wr_load_r1;
	end
end

//- detect load signal rising edging
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		rd_load_r1 <= 1'b0;
		rd_load_r2 <= 1'b0;
	end
	else begin
		rd_load_r1 <= rd_load;
		rd_load_r2 <= rd_load_r1;
	end
end


//- ddr2 write address generation
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		ddr2_wr_addr <= 24'd0;	
    else if(wr_load_flag)               					   //检测到写端口复位信号时，写地址复位
		ddr2_wr_addr <= wr_minaddr;	
	else if((cstate == SWRDB) && (num == wr_rd_burst - 1)) begin		   						//若突发写SDRAM结束，更改写地址
																		   //若未到达写SDRAM的结束地址，则写地址累加
		if(ddr2_wr_addr < wr_maxaddr - wr_rd_burst)
			ddr2_wr_addr <= ddr2_wr_addr + wr_rd_burst;
      else                        		   					//若已到达写SDRAM的结束地址，则回到写起始地址
         ddr2_wr_addr <= wr_minaddr;
    end
end

//- ddr2 read address generation
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		ddr2_rd_addr <= 24'd0;	
    else if(rd_load_flag)               					   		//检测到写端口复位信号时，写地址复位
		ddr2_rd_addr <= rd_minaddr;	
	else if((cstate == SRDDB) && (num == wr_rd_burst - 1)) begin		//若突发写SDRAM结束，更改写地址
																					//若未到达写SDRAM的结束地址，则写地址累加
		if(ddr2_rd_addr < rd_maxaddr - wr_rd_burst)
			ddr2_rd_addr <= ddr2_rd_addr + wr_rd_burst;
      else                        		   							//若已到达写SDRAM的结束地址，则回到写起始地址
         ddr2_rd_addr <= rd_minaddr;
    end
end


/*
//- Read and Write Signal Generation Module
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		local_write_req <= 1'b0;
		local_read_req  <= 1'b0; 
	end
	else begin
		if (local_init_done) begin
			if ((wr_useddw >= wr_rd_burst) && local_ready_r2) begin
				local_write_req <= 1'b1;
				local_read_req  <= 1'b0;
			end
			else if ((rd_useddw < wr_rd_burst) && local_ready_r2) begin
				local_write_req <= 1'b0;
				local_read_req  <= 1'b1;
			end
			else begin
				local_write_req <= 1'b0;
				local_read_req  <= 1'b0; 
			end			
		end
		else begin
				local_write_req <= 1'b0;
				local_read_req  <= 1'b0; 
		end
	end		
end
*/


//- num计数
always @(posedge clk or negedge rst_n) begin
	if (!rst_n)
		num <= 24'd0;
	else begin
		if ((cstate == SWRDB) || (cstate == SRDDB)) begin
			if (local_ready_r2) 
				num <= num + 1'b1;				
		end
		else
			num <= 24'd0;
	end
end

//- 读写状态状态机
always @(posedge clk or negedge rst_n) begin
	if (!rst_n)
		cstate <= SIDLE;
	else begin
		case (cstate)
			SIDLE: begin
					if (wr_req_st) cstate <= SWRDB;
					else if (rd_req_st) cstate <= SRDDB;
					else cstate <= SIDLE;					
			end
			SWRDB: begin
					if ((num == wr_rd_burst - 1) && local_ready_r2) cstate <= SSTOP;
					else cstate <= SWRDB;
			end
			SRDDB: begin
					if ((num == wr_rd_burst - 1) && local_ready_r2) cstate <= SSTOP;
					else cstate <= SRDDB;			
			end
			SSTOP: begin
					cstate <= SIDLE;
			end
			default: cstate <= SIDLE;
			
		endcase
	end
	
end


	
//- write fifo inst
wr_fifo	wr_fifo_inst (
	.wrclk 	( wr_clk ),
	.wrreq 	( wr_req ),
	.data 	( wr_data ),
	
	.rdclk 	( clk ),
	.rdreq 	( local_write_req  & local_ready_r2),
	.q 		( local_wdata ),
	
	.rdusedw ( wr_useddw ),
	.aclr 	( ~rst_n | wr_load )
	);
	

//- read fifo inst	
rd_fifo	rd_fifo_inst (
	.wrclk 	( clk ),
	.wrreq	( local_rdata_valid & local_ready_r2),
	.data  	( local_rdata ),
	
	.rdclk 	( rd_clk ),
	.rdreq 	( rd_req ),
	.q 		( rd_data ),
	
	.wrusedw ( rd_useddw ),
	.aclr 	(  ~rst_n | rd_load  )
	);
			
	
endmodule	