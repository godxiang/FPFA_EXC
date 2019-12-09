
module sdram_w9825g6kh(

	REF_CLK,
	RST_N,

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

//100MHZ
parameter INIT_200US  = 20_000;  
parameter INIT_AF_CNT = 8;
parameter tRP         = 2;			 // MIN:15ns
parameter tRSC        = 4;  		 // 2tck tck min = 7.5 取值20 2tck = 40ns
parameter tRC		    = 8;        // min = 60ns  取值80 


wire done_200us;

assign done_200us = (init_200us == INIT_200US - 1);

reg [4:0]  CMD; 						//命令寄存器

reg [15:0] init_200us;

reg [9:0] cnt;
reg [3:0] af_cnt;
reg 		 cnt_rst;  					//计数器复位信号，低电平计数器清零

reg [3:0]st_init;

localparam INIT_200US_PAUSE   = 4'd0;
localparam INIT_PRE 			   = 4'd1;
localparam INIT_PRE_DELAY		= 4'd2;
localparam INIT_SMR   		   = 4'd3;
localparam INIT_SMR_DELAY	   = 4'd4;
localparam INIT_AF  		      = 4'd5;
localparam INIT_AF_DELAY		= 4'd6;
localparam INIT_DONE				= 4'd7;


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
	end else if (st_init == INIT_AF_DELAY ) begin
		af_cnt <= af_cnt + 1'b1;
	end else begin
		af_cnt <= af_cnt;
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
				if ( (af_cnt == (INIT_AF_CNT - 1'b1)) && (cnt == tRC) ) begin
					st_init <= INIT_DONE;
				end else if ((af_cnt < (INIT_AF_CNT - 1'b1)) && (cnt == tRC)) begin
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
		
		INIT_DONE:;
		
	endcase
	
end


parameter INIT_CMD   = 5'b01111;
parameter NOP_CMD    = 5'b10111;
parameter PREALL_CMD = 5'b10010;
parameter SMR_CMD    = 5'b10000;
parameter AF_CMD		= 5'b10001;


assign {CKE,CS_N,RAS_N,CAS_N,WE_N}  = CMD;

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
				CMD <= PREALL_CMD;
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
			
			default: ;
			
		endcase
	end
end


endmodule