
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
output [12:0]A;
output [1:0]BS;
output [1:0]DQM;
output [15:0]DQ;

//****************************************************************
//**  MAIN CODE
//****************************************************************

//100MHZ
parameter INIT_200US = 20_000;  
parameter tRP        = 2;			//MIN:15ns

wire done_200us;

assign done_200us = (init_200us == INIT_200US - 1);
assign {CS_N,RAS_N,CAS_N,WE_N}  = CMD;

reg [3:0]CMD; 							//命令寄存器
reg [15:0] init_200us;

reg [9:0]cnt;


reg [3:0]st_init;

localparam INIT_200US_PAUSE   = 4'd0;
localparam INIT_PRE 			   = 4'd1;
localparam INIT_PRE_DELAY		= 4'd2;
localparam INIT_SMR   		   = 4'd3;
localparam INIT_SMR_DELAY	   = 4'd4;
localparam INIT_AF  		      = 4'd5;
localparam INIT_AF_DELAY		= 4'd6;
localparam INIT_DONE				= 4'd7;


always @(posedge REF_CLK or negedge RST_N) begin
	if (!RST_N) begin
		init_200us <= 16'd0;
	end else if (init_200us < INIT_200US - 1) begin
		init_200us <= init_200us + 1'b1;
	end else begin
		init_200us <= init_200us;
	end
end

reg cnt_rst;

always @(posedge REF_CLK or negedge RST_N) begin
	if (!RST_N) begin
		cnt <= 10'd0;
	end else if (cnt_rst == 1'b1) begin
		cnt <= 10'd0;
	end else begin
		cnt <= cnt + 1'b1;
	end	
end

always @(posedge REF_CLK or negedge RST_N) begin
	if (!RST_N) begin
		st_init <= INIT_200US_PAUSE;
	end else begin
		case (st_init)
			INIT_200US_PAUSE: begin
				if (done_200us) begin
					st_init <= INIT_PRE;
				end else begin
					st_init <= INIT_200US_PAUSE；
				end
			end
			INIT_PRE：begin
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
				if ()
			
			end
			
	end
end


always @(*) begin
	case (st_init)
		INIT_200US_PAUSE: cnt_rst <= 1'b1;
		
		INIT_PRE: cnt_rst <= 1'b1;
		
		INIT_PRE_DELAY: cnt_rst <= (cnt == tRP) ?1'b0 : 1'b1;
		
		
end

endmodule