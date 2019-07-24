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
	//input          wr_len,		//user write burst len
	input          wr_load,			//user write port reset ,reset write address and fifo			
	
	//- user read port
	input    		rd_clk,			//user read clk
	input				rd_req,			//user read request
	output  [31:0] rd_data,			//user read data 
	input   [23:0] rd_maxaddr,		//user read max address
	input   [23:0]	rd_minaddr,		//user read min address
	//input          rd_len,		//user read burst len
	input          rd_load,			//user read port reset ,reset read address and fifo	
	
	input   [6:0]  wr_rd_burst,	//read/write burst length 
		
	//- ddr2 controller port	
	output	[23:0]local_address,
	output			local_write_req,
	output	[31:0]local_wdata,	
	output			local_read_req,
//	output			local_burstbegin,
	input				local_ready,
	input		[31:0]local_rdata,
	input				local_rdata_valid,
	input				local_init_done
	
	);

wire [9:0]wr_useddw;
wire [9:0]rd_useddw;	


//- read /write address Generation Module
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) 
		local_address <= 24'd0;
	else begin
		
	end




//- Read and Write Signal Generation Module
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		local_write_req <= 1'b0;
		local_read_req  <= 1'b0; 
	end
	else begin
		if (local_init_done) begin
			if (wr_useddw >= wr_rd_burst) begin
				local_write_req <= 1'b1;
				local_read_req  <= 1'b0;
			end
			else if (rd_useddw < wr_rd_burst) begin
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


	
//- write fifo inst
wr_fifo	wr_fifo_inst (
	.wrclk 	( wr_clk ),
	.wrreq 	( wr_req ),
	.data 	( wr_data ),
	
	.rdclk 	( clk ),
	.rdreq 	( local_write_req ),
	.q 		( local_wdata ),
	
	.rdusedw ( wr_useddw ),
	.aclr 	( ~rst_n | wr_load )
	);
	

//- read fifo inst	
rd_fifo	rd_fifo_inst (
	.wrclk 	( clk ),
	.wrreq	( local_read_req ),
	.data  	( local_rdata ),
	
	.rdclk 	( rd_clk ),
	.rdreq 	( rd_req ),
	.q 		( rd_data ),
	
	.wrusedw ( rd_useddw ),
	.aclr 	(  ~rst_n | rd_load  )
	);
			
	
endmodule	