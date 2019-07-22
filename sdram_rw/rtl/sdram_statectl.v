
//******************************************************
// - sdram state control module 
// first implement at 2019-7-20
//******************************************************

module sdram_statectl(
	input 			 clk,
	input 			 rst_n,
	
	input			 	 sdram_wr_req,	 	 //sdram 写请求
	input        	 sdram_rd_req,	 	 //sdram 读请求
	
	output   	 	 sdram_wr_ack,	 	 //sdram 写响应
	output          sdram_rd_ack,	 	 //sdram 读响应
	
	input    [9:0]  sdram_wr_burst,	//突发写SDRAM字节数（1-512个）
   input    [9:0]  sdram_rd_burst,	//突发读SDRAM字节数（1-256个）
		
   output	    	 sdram_init_done, //SDRAM 初始化完成标志	
	
	output reg[2:0] init_state,	
	output reg[4:0] work_state, 
	output reg 		 sdram_rd_wr;
	
	);

`include "sdram_param.v"


parameter TRP_CLK   = 12'd4;
parameter TRC_CLK   = 12'd6;
parameter TRSC_CLK  = 12'd6;
parameter TRCD_CLK  = 12'd2;
parameter TCL_CLK   = 12'd3;
parameter TWR_CLK   = 12'd2;


reg  cnt_rst;			  // clk counter reset flag low effective
reg [12:0]cnt_clk;	  // clk counter
reg [14:0]count_200us; // 100MHZ count 10ns period
reg [3:0]cnt_ref;		  // auto refresh clk cnt
reg sdram_rf_req;		  // sdram refresh request	
reg sdram_rf_ack		  // sdram refresh ack
reg [9:0]sdram_rf_cnt; // timing 7812ns 	


wire done_200us;

//- timing 200us flag
assign done_200us = (count_200us == 15'd200000);

//- init_done flag
assign sdram_init_done = (init_state == `I_DONE);

//- sdram referesh ack flag
assign sdram_rf_ack = (work_state == `W_AR);

//写SDRAM响应信号
assign sdram_wr_ack = ((work_state == `W_TRCD) & ~sdram_rd_wr) | 
					  ( work_state == `W_WRITE)|
					  ((work_state == `W_WD) & (cnt_clk < sdram_wr_burst - 2'd2));
                      
//读SDRAM响应信号
assign sdram_rd_ack = (work_state == `W_RD) & 
					  (cnt_clk >= 10'd1) & (cnt_clk < sdram_rd_burst + 2'd1);


// -200us count
always @(posedge clk or negedge rst_n) begin
	if (!rst_n)
		count_200us <= 15'd0;
	else begin
		if (count_200us < 15'd20000)
			count_200us <= count_200us + 1'b1;
		else 
			count_200us <= count_200us;
	end	
end
	

// -cnt_clk count 
always @(posedge clk or negedge rst_n) begin
	if (!rst_n)
		cnt_clk <= 13'd0;
	else begin
		if (!cnt_rst)
			cnt_clk <= 13'd0;
		else
			cnt_clk <= cnt_clk + 1'b1;
	end
end


//- auto refresh count
always @(posedge clk or negedge rst_n) begin
	if (!rst_n)
		cnt_ref <= 4'd0;
	else begin
		if (init_state == `I_AR)
			cnt_ref <= cnt_ref + 1'b1;
		else 
			cnt_ref <= cnt_ref;
	end
end


//- sdram refresh counter 
always @(posedge clk or negedge rst_n) begin	
	if (!rst_n)
		sdram_rf_cnt <= 10'd0;
	else begin
		if (sdram_rf_cnt < 10'd781)
			sdram_rf_cnt <= sdram_rf_cnt + 1'b1;
		else 
			sdram_rf_cnt <= 10'd0;
	end
end

//- sdram refresh request
always @(posedge clk or negedge rst_n) begin	
	if (!rst_n)
		sdram_rf_req <= 1'b0;
	else begin
		if (sdram_rf_cnt == 10'd781)		
			sdram_rf_req <= 1'b1;
		else if (sdram_rf_ack == 1'b1)
			sdram_rf_req <= 1'b0;
	end
end	
	
//- sdram init state machine
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		init_state <= I_NOP;
	end
	else begin
		case (init_state)
			`I_NOP: init_state <= (done_200us)? `I_PRE: `I_NOP;								//200us stable period
			
			`I_PRE: init_state <= `I_TRP;																// prechage state
			
			`I_TRP: init_state <= (`end_trp)? `I_AR：`I_TRP;									// wait the end of prechage state
			
			`I_AR:  init_state <= `I_TRF;																// auto referesh
			
			`I_TRF: init_state <= (`end_trfc)?((cnt_ref == 4'd8)? I_MRS: I_AR):I_TRF    // wait referesh done
			
			`I_MRS: init_state <= `I_TRSC;															// mode register set
			
			`I_TRSC: init_state <= (`end_trsc)? `I_DONE： `I_TRSC;							// wait mode register complete
			
			`I_DONE: init_state <= `I_DONE;
			
			default: 
				init_state <= `I_NOP;
			
		endcase
	end
	
end


//- 	work state machine 	
always @(posedge clk or negedge rst_n) begin
	if (!rst_n)
		work_state <= `W_IDLE;
	else begin
		if (init_state == `I_DONE) begin
			case (work_state)
				`W_IDLE: begin
					if (sdram_rf_req) begin
						work_state  <= `W_AR;
						sdram_rd_wr <= 1'b1;
					end
					else if (sdram_wr_req) begin
						work_state  <= `W_ACTIVE;
						sdram_rd_wr <= 1'b0;
					end
					else if (sdram_rd_req) begin
						work_state  <= `W_ACTIVE;
						sdram_rd_wr <= 1'b1;
					end
					else
						work_state <= `W_IDLE;
				end
				`W_ACTIVE:
						work_state <= `W_TRCD;
				`W_TRCD:
						work_state <= (`end_trcd)?((sdram_rd_wr == 1'b1)? `W_READ: `W_WRITE):`W_TRCD;
				`W_READ:
						work_state <= `W_CL;				
				`W_CL:				
						work_state <= (`end_tcl)? `W_RD: `W_CL;
				`W_RD:		
						work_state <= (`end_tread)? `W_PRE: `W_RD;
				`W_WRITE:
						work_state <= `W_WD;
				`W_WD:
						work_state <= (`end_twrite)? `W_TWR: `W_WD;
				`W_TWR:
						work_state <= (`end_twr)? `W_PRE: `W_TWR;
				`W_PRE:
						work_state <= `W_TRP;
				`W_TRP:
						work_state <= (`end_trp)? `W_IDLE: `W_TRP;								
				`W_AR:
						work_state <= `W_TRFC;
				`W_TRFC:
						work_state <= (`end_trfc)? `W_IDLE : `W_TRFC								
				
				default: work_state <= `W_IDLE;
				
			endcase	
		end				
	end
end
	
	
	
//- sdram cnt_clk count
always @(*) begin
	case (init_state)
		`I_NOP: cnt_rst <= 1'b0;	 //don't count
		
		`I_PRE: cnt_rst <= 1'b1;	
		
		`I_TRP: cnt_rst <= (`end_trp)? 1'b0: 1'b1;
		
		`I_AR:  cnt_rst <= 1'b1;
		
		`I_TRF: cnt_rst <= (`end_trfc)? 1'b0: 1'b1;
		
		`I_MRS: cnt_rst <= 1'b1;
		
		`I_TRSC: cnt_rst <= (`end_trsc)? 1'b0: 1'b1;
				
		`I_DONE:
			case (work_state) 
				`W_IDLE:
						cnt_rst <= 1'b0;
				`W_ACTIVE:
						cnt_rst <= 1'b1;
				`W_TRCD:
						cnt_rst <= (`end_trcd)? 1'b0: 1'b1;
				`W_READ:
						cnt_rst <= 1'b1;
				`W_CL:
						cnt_rst <= (`end_tcl): 1'b0: 1'b1;
				`W_RD:
						cnt_rst <= (`end_tread)? 1'b0: 1'b1;
				`W_WRITE:
						cnt_rst <= 1'b1;
				`W_WD:
						cnt_rst <= (`end_twrite)? 1'b0: 1'b1;
				`W_TWR:
						cnt_rst <= (`end_twr)? 1'b0: 1'b1;
				`W_PRE:
						cnt_rst <= 1'b1;
				`W_TRP:
						cnt_rst <= (`end_trp)? 1'b0: 1'b1;
				`W_AR:
						cnt_rst <= 1'b1;
				`W_TRFC:
						cnt_rst <= (`end_trfc)? 1'b0: 1'b1;
			endcase			
				
end
	
		
endmodule	
