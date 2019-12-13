
module sdram_w9825g6kh(

	REF_CLK,
	RST_N,

	SDRAM_INIT_DONE,
	
	SDRAM_WR_REQ,
	SDRAM_WR_DATA,
	SDRAM_RD_REQ,
	SDRAM_RD_DATA,
	
	SDRAM_ADDR,
	SDRAM_BURST_LEN,
	
	CLK,
	CKE,
	CS_N,
	RAS_N,
	CAS_N,
	WE_N,
	A,
	BS,
	DQM,
	DQ
		
);


input REF_CLK;
input RST_N;

input SDRAM_WR_REQ;
input SDRAM_WR_DATA;
input SDRAM_RD_REQ;
input SDRAM_RD_DATA;
input SDRAM_BURST_LEN;
input [23:0]SDRAM_ADDR;

output SDRAM_INIT_DONE;
output CLK;
output CKE;
output CS_N;
output RAS_N;
output CAS_N;
output WE_N;
output reg [12:0]A;
output reg [1:0]BS;
output [1:0]DQM;
output [15:0]DQ;

//****************************************************************
//**  MAIN CODE
//****************************************************************


reg [4:0]  CMD; 						    //命令寄存器
reg [15:0] init_200us;
reg [9:0]  cnt;
reg [3:0]  af_cnt;
reg 		  cnt_rst;  					//计数器复位信号，低电平计数器清零

reg [12:0]ref_cnt;						//刷新计数器 8192/64ms  7812ns刷新一次							
reg ref_req;
reg ref_req_ack;

reg sdram_rd_wr;

reg [3:0]st_init;
reg [3:0]st_work;

wire done_200us;

parameter INIT_CMD   = 5'b01111;
parameter NOP_CMD    = 5'b10111;
parameter PRE_CMD 	= 5'b10010;
parameter SMR_CMD    = 5'b10000;
parameter AF_CMD		= 5'b10001;
parameter ACT_CMD		= 5'b10011;
parameter RD_CMD 		= 5'b10101;
parameter WR_CMD		= 5'b10100;


//100MHZ
parameter INIT_200US  = 20_000;  
parameter INIT_AF_CNT = 8;
parameter tRP         = 2;			 // MIN:15ns
parameter tRSC        = 4;  		 // 2tck tck min = 7.5 取值20 2tck = 40ns
parameter tRC		    = 8;        // min = 60ns  取值80 
parameter tRCD 		 = 3;			 // min = 15ns 取值30
parameter tCL 		    = 3;        // CL = 3  
parameter tREAD       = SDRAM_BURST_LEN;	//读数据时间
parameter tWRITE 		 = SDRAM_BURST_LEN; //写数据时间  
parameter tWR 			 = 2;


// 初始化状态机定义
parameter INIT_200US_PAUSE    = 4'd0;
parameter INIT_PRE 			   = 4'd1;
parameter INIT_PRE_DELAY		= 4'd2;
parameter INIT_SMR   		   = 4'd3;
parameter INIT_SMR_DELAY	   = 4'd4;
parameter INIT_AF  		      = 4'd5;
parameter INIT_AF_DELAY		   = 4'd6;
parameter INIT_DONE				= 4'd7;

//*********************************************************************** 
//** 工作状态机定义
//** 采用不带自动预充电的突发读写，每次读写完成需要执行预充电动作
//***********************************************************************

parameter  WORK_IDLE			   = 4'd0; 			//就绪状态，等待 刷新/写/读请求
parameter  WORK_AF				= 4'd1;			//自动刷新状态,发送自动刷新命令 
parameter  WORK_AF_DELAY      = 4'd2;			//等待自动刷新结束
parameter  WORK_ACT				= 4'd3;			//激活行状态
parameter  WORK_ACT_DELAY	   = 4'd4;			//激活行延时 
parameter  WORK_RD_CMD			= 4'd5;			//发送读命令
parameter  WORK_RD_DELAY		= 4'd6;			//读命令延时
parameter  WORK_RD_DATA       = 4'd7;			//读数据
parameter  WORK_WR_CMD		   = 4'd8;			//发送写命令
parameter  WORK_WR_DATA		   = 4'd9;			//写数据
parameter  WORK_WR_DELAY      = 4'd10;			//写延时
parameter  WORK_PRE				= 4'd11;			//预充电
parameter  WORK_PRE_DELAY		= 4'd12; 		//预充电延时


// 命令寄存器赋值
assign {CKE,CS_N,RAS_N,CAS_N,WE_N}  = CMD;

// 200us停顿完成标志
assign done_200us = (init_200us == INIT_200US - 1);

// SDRAM 初始化完成标志 
assign SDRAM_INIT_DONE = (st_init == INIT_DONE);


// 200US停顿计数
always @(posedge REF_CLK or negedge RST_N) begin
	if (!RST_N) begin
		init_200us <= 16'd0;
	end else if (init_200us < INIT_200US - 1) begin
		init_200us <= init_200us + 1'b1;
	end else begin
		init_200us <= init_200us;
	end
end

//计数器
always @(posedge REF_CLK or negedge RST_N) begin
	if (!RST_N) begin
		cnt <= 10'd0;
	end else if (cnt_rst == 1'b0) begin
		cnt <= 10'd0;
	end else begin
		cnt <= cnt + 1'b1;
	end	
end

//初始化过程 自动刷新周期计数
always @(posedge REF_CLK or negedge RST_N) begin
	if (!RST_N) begin
		af_cnt <= 4'd0;
	end else if (st_init == INIT_AF ) begin
		af_cnt <= af_cnt + 1'b1;
	end else begin
		af_cnt <= af_cnt;
	end
end


//工作过程，刷新计数
always @(posedge REF_CLK or negedge RST_N) begin
	if (!RST_N) begin
		ref_cnt <= 13'd0;
	end else if (ref_cnt == 13'd781) begin
		ref_cnt <= 13'd0;
	end else begin
		ref_cnt <= ref_cnt+ 1'b1;
	end
	
end

//产生刷新请求
always @(posedge REF_CLK or negedge RST_N) begin
	if (!RST_N) begin
		ref_req <= 1'b0;
	end else if (ref_cnt == 13'd781) begin
		ref_req <= 1'b1;
	end else if (ref_req_ack ) begin
		ref_req <= 1'b0;
	end else begin
		ref_req <= ref_req;
	end
end

//相应刷新请求
always @(posedge REF_CLK or negedge RST_N) begin
	if (!RST_N) begin
		ref_req_ack <= 1'b0;
	end else if (st_work == WORK_AF) begin
		ref_req_ack <= 1'b1;
	end else begin
		ref_req_ack <= ref_req_ack;
	end
end


// 读写标志位
always @(posedge REF_CLK or negedge RST_N) begin
	if (!RST_N) begin
		sdram_rd_wr <= 1'b0;
	end else if (SDRAM_WR_REQ && SDRAM_INIT_DONE) begin
		sdram_rd_wr <= 1'b0;
	end else if (SDRAM_RD_REQ && SDRAM_INIT_DONE) begin
		sdram_rd_wr <= 1'b1;
	end else begin
		sdram_rd_wr <= sdram_rd_wr;
	end
end


//上电初始化状态机
always @(posedge REF_CLK or negedge RST_N) begin
	if (!RST_N) begin
		st_init <= INIT_200US_PAUSE;
	end else begin
		case (st_init)
			INIT_200US_PAUSE: begin
				if (done_200us) begin
					st_init <= INIT_PRE;
				end else begin
					st_init <= INIT_200US_PAUSE;
				end
			end
			INIT_PRE: begin
				st_init <= INIT_PRE_DELAY;
			end
			INIT_PRE_DELAY: begin
				if (cnt == tRP) begin
					st_init <= INIT_SMR;
				end else begin
					st_init <= INIT_PRE_DELAY;
				end
			end
			INIT_SMR: begin
				st_init <= INIT_SMR_DELAY;
			end
			INIT_SMR_DELAY: begin
				if (cnt == tRSC) begin
					st_init <= INIT_AF;
				end else begin
					st_init <= INIT_SMR_DELAY;
				end			
			end
			INIT_AF: begin
				st_init <= INIT_AF_DELAY;
			end
			INIT_AF_DELAY: begin
				if ( (af_cnt == (INIT_AF_CNT )) && (cnt == tRC) ) begin
					st_init <= INIT_DONE;
				end else if ((af_cnt < (INIT_AF_CNT )) && (cnt == tRC)) begin
					st_init <= INIT_AF;
				end else begin
					st_init <= INIT_AF_DELAY;
				end
			end
			INIT_DONE: begin
				st_init <= INIT_DONE;
			end
		
			default: ;
			
		endcase
	end
end


always @(posedge REF_CLK or negedge RST_N) begin
	if (!RST_N) begin
		st_work <= WORK_IDLE;
	end else begin
		case (st_work)
			WORK_IDLE: begin
				if (ref_req && SDRAM_INIT_DONE) begin
					st_work <= WORK_AF;
				end else if (SDRAM_WR_REQ && SDRAM_INIT_DONE ) begin
					st_work <= WORK_ACT;
				end else if (SDRAM_RD_REQ && SDRAM_INIT_DONE ) begin
					st_work <= WORK_ACT;
				end else begin
					st_work <= WORK_IDLE;
				end
			end
			WORK_AF：begin
				st_work <= WORK_AF_DELAY;
			end
			WORK_AF_DELAY: begin
				if (cnt == tRC) begin
					st_work <= WORK_IDLE;
				end else begin
					st_work <= WORK_AF_DELAY;
				end
			end
			WORK_ACT: begin
				st_work <= WORK_ACT_DELAY;
			end
			WORK_ACT_DELAY: begin
				if (cnt == tRCD) begin
					if (sdram_rd_wr) begin
						st_work <= WORK_RD_CMD;
					end else begin
						st_work <= WORK_WR_CMD;
					end
				end else begin
					st_work <= WORK_AF_DELAY;
				end
			end
			WORK_RD_CMD: begin
				st_work <= WORK_RD_DELAY;
			end
			WORK_RD_DELAY: begin
				if (cnt == tCL) begin
					st_work <= WORK_RD_DATA;
				end else begin
					st_work <= WORK_RD_DELAY;
				end
			end
			WORK_RD_DATA: begin
				if (cnt == tREAD) begin
					st_work <= WORK_PRE;
				end else begin
					st_work <= WORK_RD_DATA;
				end
			end
			WORK_WR_CMD: begin
				st_work <= WORK_WR_DATA;
			end
			WORK_WR_DATA: begin
				if (cnt == tWRITE) begin
					st_work <= WORK_WR_DELAY;
				end else begin
					st_work <= WORK_WR_DATA;
				end
			end
			WORK_WR_DELAY: begin
				if (cnt == tWR) begin
					st_work <= WORK_PRE;
				end else begin
					st_work <= WORK_WR_DELAY;
				end
			end
			WORK_PRE: begin
				st_work <= WORK_PRE_DELAY;
			end
			WORK_PRE_DELAY: begin
				if (cnt == tRP) begin
					st_work <= WORK_IDLE;
				end else begin
					st_work <= WORK_PRE_DELAY;
				end
			end
			
			default: st_work <= WORK_IDLE;
			
		endcase
		
	end
end

//- 计数器
always @(*) begin
	case (st_init)
		INIT_200US_PAUSE: cnt_rst <= 1'b0;
		
		INIT_PRE: cnt_rst <= 1'b1;
		
		INIT_PRE_DELAY: cnt_rst <= (cnt == tRP) ? 1'b0 : 1'b1;
		
		INIT_SMR: cnt_rst <= 1'b1;
		
		INIT_SMR_DELAY: cnt_rst <= (cnt == tRSC) ? 1'b0 : 1'b1;
		
		INIT_AF: cnt_rst <= 1'b1;
		
		INIT_AF_DELAY: cnt_rst <= (cnt == tRC) ? 1'b0 : 1'b1;
		
		INIT_DONE: 
			case(st_work)
				WORK_IDLE: begin
					cnt_rst <= 1'b0;
				end
				WORK_AF：begin
					cnt_rst <= 1'b1;
				end
				WORK_AF_DELAY: begin
					cnt_rst <= (cnt == tRC) ? 1'b0 : 1'b1;
				end
				WORK_ACT: begin
					cnt_rst <= 1'b1;
				end
				WORK_ACT_DELAY: begin
					cnt_rst <= (cnt == tRCD) ? 1'b0 : 1'b1;
				end
				WORK_RD_CMD: begin
					cnt_rst <= 1'b1;
				end
				WORK_RD_DELAY: begin
					cnt_rst <= (cnt == tCL) ? 1'b0 : 1'b1;
				end
				WORK_RD_DATA: begin
					cnt_rst <= (cnt == tREAD) ? 1'b0 : 1'b1;
				end
				WORK_WR_CMD: begin
					cnt_rst <= 1'b1;
				end
				WORK_WR_DATA: begin
					cnt_rst <= (cnt == tWRITE) ? 1'b0 : 1'b1;
				end
				WORK_WR_DELAY: begin
					cnt_rst <= (cnt == tWR) ? 1'b0 : 1'b1;
				end
				WORK_PRE: begin
					cnt_rst <= 1'b1;
				end
				WORK_PRE_DELAY: begin
					cnt_rst <= (cnt == tRP) ? 1'b0 : 1'b1;
				end
				default:;			
			endcase
			
		default:;
		
end


//-命令寄存器赋值
always @(posedge REF_CLK or negedge RST_N) begin
	if (!RST_N) begin
		CMD <= INIT_CMD;
		BS  <= 2'b11;
		A   <= 13'h1fff;
	end else begin
		case (st_init)
			INIT_200US_PAUSE, INIT_PRE_DELAY, INIT_SMR_DELAY, INIT_AF_DELAY: begin
				CMD <= NOP_CMD;
				BS  <= 2'b11;
				A   <= 13'h1fff;
			end
			INIT_PRE: begin
				CMD <= PRE_CMD;
				BS  <= 2'b11;
				A   <= 13'h1fff;
			end
			INIT_SMR: begin
				CMD <= SMR_CMD;
				BS  <= 2'b00;
				A   <= {
					3'b000,
					1'b0,  //burst rd/wr
				   2'b00,
					3'b011,
					1'b0,
					3'b111
				};
			end
			INIT_AF: begin
				CMD <= AF_CMD;
				BS  <= 2'b11;
				A   <= 13'h1fff;
			end
			INIT_DONE:
				case (st_work)
					WORK_IDLE, WORK_AF_DELAY, WORK_ACT_DELAY, WORK_RD_DELAY, WORK_WR_DELAY, WORK_PRE_DELAY: begin
						CMD <= NOP_CMD;
						BS  <= 2'b11;
						A   <= 13'h1fff;
					end
					WORK_AF：begin
						CMD <= AF_CMD;
						BS  <= 2'b11;
						A   <= 13'h1fff;
					end
					WORK_ACT: begin
						CMD <= ACT_CMD;
						BS  <= SDRAM_ADDR[23:22];
						A   <= SDRAM_ADDR[21:9];
					end
					WORK_RD_CMD: begin
						CMD <= RD_CMD;
						BS  <= SDRAM_ADDR[23:22];
						A   <= {4'b0000, SDRAM_ADDR[8:0]};
					end
					WORK_RD_DATA: begin
						
					end
					WORK_WR_CMD: begin
						CMD <= WR_CMD;
						BS  <= SDRAM_ADDR[23:22];
						A   <= {4'b0000, SDRAM_ADDR[8:0]};
					end
					WORK_WR_DATA: begin
						
					end
					WORK_PRE: begin
						CMD <= PRE_CMD;
						BS  <= SDRAM_ADDR[23:22];
						A   <= 13'h0fff;
					end					
				   default:;
					
				endcase
	
			default: ;
			
		endcase
	end
end


endmodule