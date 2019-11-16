module key_filter(Clk,Rst_n,key_in,key_flag,key_state);

input Clk;
input Rst_n;
input key_in;

output reg key_flag;	 //- 表示按键按下或者松开，一个脉冲
output reg key_state; //- 按键的状态。为0表示按键按下

	
localparam  IDLE 				=	4'b0001;
localparam  FILTER_DOWN		=	4'b0010;
localparam  DOWN				=	4'b0100;
localparam  FILTER_RELEASE	=	4'b1000;


reg key_in_s0;
reg key_in_s1;	
reg [3:0] state;	
reg key_in_r1;
reg key_in_r2;
reg cnt_full;	//计数满标志信号	
reg [19:0] cntr;
reg en_cnt;

wire pos_dge,neg_dge;

always @(posedge Clk or negedge Rst_n) 
	if (!Rst_n) begin
		key_in_s0 <= 1'b1;
		key_in_s1 <= 1'b1;
	end
	else begin
		key_in_s0 <= key_in;		
		key_in_s1 <= key_in_s0;
	end


always @(posedge Clk or negedge Rst_n) 
	if (!Rst_n) begin
		key_in_r1 <= 1'b1;
		key_in_r2 <= 1'b1;
	end
	else begin
		key_in_r1 <= key_in_s1;		
		key_in_r2 <= key_in_r1;
	end

assign neg_dge = ~key_in_r1 & key_in_r2;
assign pos_dge =  key_in_r1 & ~key_in_r2;	
	
always @(posedge Clk or negedge Rst_n)
	if (!Rst_n) begin
		state <= IDLE;
		en_cnt <= 1'b0;
		key_flag  <= 1'b0;
		key_state <= 1'b1; 
	end
	else begin
		case (state)
			IDLE : begin					
				key_flag <= 1'b0;
				if (neg_dge) begin
					state  <= FILTER_DOWN;
					en_cnt <= 1'b1;
				end
				else begin
					state  <= IDLE;
					en_cnt <= 1'b0;
				end
			end
			FILTER_DOWN : begin
				if (pos_dge) begin
					state  <= IDLE;
					en_cnt <= 1'b0;
				end
				else if(cnt_full == 1'b1) begin
					key_flag  <= 1'b1;
					key_state <= 1'b0; 
					state  	 <= DOWN;
					en_cnt 	 <= 1'b0;
				end
				else begin
					state  <= FILTER_DOWN;
					en_cnt <= 1'b1;
				end
			end
			DOWN  : begin
				key_flag <= 1'b0;
				if (pos_dge) begin
					state  <= FILTER_RELEASE;
					en_cnt <= 1'b1;					
				end
				else begin
					state  <= DOWN;
					en_cnt <= 1'b0;
				end
			end
			FILTER_RELEASE: begin
				if (neg_dge) begin
					state  <= DOWN;
					en_cnt <= 1'b0;
				end
				else if(cnt_full == 1'b1) begin
					key_flag  <= 1'b1;
					key_state <= 1'b1; 
					state  	 <= IDLE;
					en_cnt 	 <= 1'b0;
				end
				else begin
					state  <= FILTER_RELEASE;
					en_cnt <= 1'b1;
				end
			end
			default: begin
					state <= IDLE;
					en_cnt <= 1'b0;
					key_flag  <= 1'b0;
					key_state <= 1'b1;					
				end				
		endcase
	end


always @(posedge Clk or negedge Rst_n)
	if (!Rst_n)
		cntr <= 20'd0;
	else if (en_cnt)
		cntr <= cntr + 1'b1;
	else 
		cntr <= 20'd0;
		
always @(posedge Clk or negedge Rst_n)
	if (!Rst_n)
		cnt_full <= 1'b0;
	else if (cntr == 20'd999_999)  //- 999_999 
		cnt_full <= 1'b1;
	else 
		cnt_full <= 1'b0;

	
endmodule
