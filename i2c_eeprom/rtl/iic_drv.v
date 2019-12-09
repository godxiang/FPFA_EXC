
module iic_drv(
	Clk,
	Rst_n,

	IIC_en,
	IIC_done,

	IIC_slave_addr,
	IIC_dev_addr,
	IIC_bit_sel,

	IIC_rh_wl,
	IIC_write_data,
	IIC_read_data,
	
	Scl4x,
	
	IIC_SCL,
	IIC_SDA

);


input Clk;								// 输入时钟 50MHZ
input Rst_n;							// 外部复位信号
input IIC_en;							// IIC 使能信号
input [6:0]IIC_slave_addr;			// IIC从机地址
input [15:0]IIC_dev_addr;			// IIC设备内地址
input IIC_bit_sel;					// IIC设备内地址位选择  8/16  0:8  1:16
input IIC_rh_wl;						// IIC读写控制位 0：读 1：写
input [7:0]IIC_write_data;			// IIC写入的数据

output reg Scl4x; 					// IIC clk 4x频率时钟	
output reg [7:0]IIC_read_data;	// IIC读出的数据
output reg IIC_done;					// IIC读取结束信号
output reg IIC_SCL;					// IIC时钟线   
inout IIC_SDA;						   // IIC数据线 双向
	
	
//***************************************************************************
//** MAIN CODE
//***************************************************************************	

parameter IIC_CLK_FRQ  = 250_000; 		//IIC 时钟频率为250K
parameter MAIN_CLK_FRQ = 50_000_000;	//晶振频率为50M 

localparam ST_IDLE      = 4'd0;			// IIC就绪状态
localparam ST_SLADDR    = 4'd1;			// IIC写从设备地址状态
localparam ST_DEV16ADDR = 4'd2;			// IIC写16位设备内地址状态
localparam ST_DEV8ADDR  = 4'd3;			// IIC写8位设备内地址状态
localparam ST_WRDATA    = 4'd4;			// IIC写数据状态
localparam ST_RDADDR    = 4'd5;			// IIC发送读地址
localparam ST_RDDATA    = 4'd6;			// IIC读数据状态
localparam ST_DONE	   = 4'd7;			// IIC操作完成状态

wire [7:0]clk_divide;
wire sda_in;									// SDA数据输入


reg iic_start;
reg [7:0]div_cnt; 	
reg st_done;  	  	  							// 状态结束
reg sda_dir;		  							// IIC_SDA方向
reg sda_out;	  	  							// SDA输出信号
reg [7:0]scl4x_cnt; 						   // IIC clk 4X倍频计数器	
reg [3:0] cur_state;							// 状态机当前状态
reg [3:0] nex_state;							// 状态机下一各状态


assign IIC_SDA = (sda_dir) ? sda_out : 1'bz;
assign sda_in  = IIC_SDA;
assign clk_divide = (MAIN_CLK_FRQ / IIC_CLK_FRQ) >> 2'd3;

		
//得到IIC驱动时钟时钟4倍频操作时钟
always @(posedge Clk or negedge Rst_n) begin	
	if (!Rst_n) begin
		Scl4x 	 <= 1'b1;
		div_cnt   <= 8'd0;
	end else if (div_cnt == (clk_divide - 1'b1)) begin
		div_cnt   <= 8'd0;
		Scl4x 	 <= ~Scl4x;
	end else begin
		Scl4x 	 <= Scl4x;
		div_cnt   <= div_cnt + 1'b1;
	end

end


//(三段式状态机)同步时序描述状态的转移
always @(posedge Scl4x or negedge Rst_n) begin
	if (!Rst_n) begin
		cur_state <= ST_IDLE;
	end else begin
		cur_state <= nex_state;
	end
end


// 组合逻辑判断状态转移的条件
always @(*) begin
	case (cur_state) 
		ST_IDLE: begin
			if (iic_start) begin
				nex_state <= ST_SLADDR;
			end else begin
				nex_state <= ST_IDLE;
			end
		end
		ST_SLADDR: begin
			if (st_done) begin
				if (IIC_bit_sel) begin
					nex_state <= ST_DEV16ADDR;
				end else begin
					nex_state <= ST_DEV8ADDR;
				end				
			end else begin
					nex_state <= ST_SLADDR;
			end
		end
		ST_DEV16ADDR: begin
			if (st_done) begin
				nex_state <= ST_DEV8ADDR;
			end else begin
				nex_state <= ST_DEV16ADDR;
			end
		end
		ST_DEV8ADDR: begin
			if (st_done) begin
				if (IIC_rh_wl) begin
					nex_state <= ST_RDADDR;				
				end else begin
					nex_state <= ST_WRDATA;
				end
			end
		end
		ST_WRDATA: begin
			if (st_done) begin
				nex_state <= ST_DONE;
			end else begin
				nex_state <= ST_WRDATA;
			end
		end
		ST_RDADDR: begin
			if (st_done) begin
				nex_state <= ST_RDDATA;				
			end else begin
				nex_state <= ST_RDADDR;				
			end
		end	
		ST_RDDATA: begin
			if (st_done) begin
				nex_state <= ST_DONE;
			end else begin
				nex_state <= ST_RDDATA;
			end
		end
		
		ST_DONE: begin
			if (st_done) begin
				nex_state <= ST_IDLE;
			end else begin
				nex_state <= ST_DONE;
			end
		end
			
		default: ;	
		
	endcase
	
end

//时序电路描述状态的输出
always @(posedge Scl4x or negedge Rst_n) begin
	if (!Rst_n) begin
		scl4x_cnt 	  <= 8'd0;
		st_done   	  <= 1'b0;
		IIC_read_data <= 8'd0;
		IIC_done 	  <= 1'b0;
		IIC_SCL       <= 1'b1;
		sda_dir		  <= 1'b1;
		sda_out		  <= 1'b1;		
	end else begin
		scl4x_cnt <= scl4x_cnt + 1'b1;
		st_done   <= 1'b0;
		case(cur_state)
			ST_IDLE: begin
				scl4x_cnt 	  <= 8'd0;
				st_done   	  <= 1'b0;
				IIC_read_data <= 8'd0;
				IIC_done 	  <= 1'b0;
				IIC_SCL       <= 1'b1;
				sda_dir		  <= 1'b1;
				sda_out		  <= 1'b1;
				if (IIC_en) begin
					iic_start <= IIC_en;
				end else begin
					iic_start <= iic_start;
				end
				
			end
			ST_SLADDR: begin
				case(scl4x_cnt)
					8'd1: sda_out <= 1'b0;
					8'd3,8'd7,8'd11,8'd15,8'd19,8'd23,8'd27,8'd31,8'd35: IIC_SCL <= 1'b0;
					8'd5,8'd9,8'd13,8'd17,8'd21,8'd25,8'd29,8'd33,8'd37: IIC_SCL <= 1'b1;
					8'd4:  sda_out <= IIC_slave_addr[6];			
					8'd8:  sda_out <= IIC_slave_addr[5];	
					8'd12: sda_out <= IIC_slave_addr[4];	
					8'd16: sda_out <= IIC_slave_addr[3];	
					8'd20: sda_out <= IIC_slave_addr[2];	
					8'd24: sda_out <= IIC_slave_addr[1];	
					8'd28: sda_out <= IIC_slave_addr[0];
					8'd32: sda_out <= 1'b0;		//写
					8'd36: begin
							 sda_dir <= 1'b0;
							 sda_out <= 1'b1;
					end
					8'd38: st_done <= 1'b1;
					8'd39: begin
							 IIC_SCL   <= 1'b0;
							 scl4x_cnt <= 8'd0;
					end
					default: ;
				
				endcase
			end
			ST_DEV16ADDR: begin
				case(scl4x_cnt)
					8'd0: begin 
							sda_dir <= 1'b1;
							sda_out <= IIC_dev_addr[15];
					end
					8'd1,8'd5,8'd9,8'd13,8'd17,8'd21,8'd25,8'd29, 8'd33: IIC_SCL <= 1'b1;
					8'd3,8'd7,8'd11,8'd15,8'd19,8'd23,8'd27,8'd31: 		  IIC_SCL <= 1'b0;
					8'd4:  sda_out <= IIC_dev_addr[14];
					8'd8:  sda_out <= IIC_dev_addr[13];
					8'd12: sda_out <= IIC_dev_addr[12];
					8'd16: sda_out <= IIC_dev_addr[11];
					8'd20: sda_out <= IIC_dev_addr[10];
					8'd24: sda_out <= IIC_dev_addr[9];
					8'd28: sda_out <= IIC_dev_addr[8];
					8'd32: begin
							 sda_dir <= 1'b0;
							 sda_out <= 1'b1;
					end
					8'd34: st_done <= 1'b1;
					8'd35: begin
							 IIC_SCL   <= 1'b0;
							 scl4x_cnt <= 8'd0;
					end
					default: ;
				endcase	
			end
			ST_DEV8ADDR: begin
				case(scl4x_cnt)
					8'd0: begin 
							sda_dir <= 1'b1;
							sda_out <= IIC_dev_addr[7];
					end
					8'd1,8'd5,8'd9,8'd13,8'd17,8'd21,8'd25,8'd29, 8'd33: IIC_SCL <= 1'b1;
					8'd3,8'd7,8'd11,8'd15,8'd19,8'd23,8'd27,8'd31: 		  IIC_SCL <= 1'b0;
					8'd4:  sda_out <= IIC_dev_addr[6];
					8'd8:  sda_out <= IIC_dev_addr[5];
					8'd12: sda_out <= IIC_dev_addr[4];
					8'd16: sda_out <= IIC_dev_addr[3];
					8'd20: sda_out <= IIC_dev_addr[2];
					8'd24: sda_out <= IIC_dev_addr[1];
					8'd28: sda_out <= IIC_dev_addr[0];
					8'd32: begin
							 sda_dir <= 1'b0;
							 sda_out <= 1'b1;
					end
					8'd34: st_done <= 1'b1;
					8'd35: begin
							 IIC_SCL   <= 1'b0;
							 scl4x_cnt <= 8'd0;
					end
					default: ;
				endcase
			end
			ST_WRDATA: begin
				case(scl4x_cnt)
					8'd0: begin 
							sda_dir <= 1'b1;
							sda_out <= IIC_write_data[7];
					end
					8'd1,8'd5,8'd9,8'd13,8'd17,8'd21,8'd25,8'd29, 8'd33: IIC_SCL <= 1'b1;
					8'd3,8'd7,8'd11,8'd15,8'd19,8'd23,8'd27,8'd31: 		  IIC_SCL <= 1'b0;
					8'd4:  sda_out <= IIC_write_data[6];
					8'd8:  sda_out <= IIC_write_data[5];
					8'd12: sda_out <= IIC_write_data[4];
					8'd16: sda_out <= IIC_write_data[3];
					8'd20: sda_out <= IIC_write_data[2];
					8'd24: sda_out <= IIC_write_data[1];
					8'd28: sda_out <= IIC_write_data[0];
					8'd32: begin
							 sda_dir <= 1'b0;
							 sda_out <= 1'b1;
					end
					8'd34: st_done <= 1'b1;
					8'd35: begin
							 IIC_SCL   <= 1'b0;
							 scl4x_cnt <= 8'd0;
					end
					default: ;
				endcase	
			end
			ST_RDADDR: begin
				case(scl4x_cnt)
					8'd0: sda_dir <= 1'b1;
					8'd1:	IIC_SCL <= 1'b1;    
					8'd3: sda_out <= 1'b0;
					8'd5,8'd9,8'd13,8'd17,8'd21,8'd25,8'd29,8'd33,8'd37:  IIC_SCL <= 1'b0;
					8'd7,8'd11,8'd15,8'd19,8'd23,8'd27,8'd31,8'd35,8'd39: IIC_SCL <= 1'b1;
					8'd6:  sda_out <= IIC_slave_addr[6];			
					8'd10: sda_out <= IIC_slave_addr[5];	
					8'd14: sda_out <= IIC_slave_addr[4];	
					8'd18: sda_out <= IIC_slave_addr[3];	
					8'd22: sda_out <= IIC_slave_addr[2];	
					8'd26: sda_out <= IIC_slave_addr[1];	
					8'd30: sda_out <= IIC_slave_addr[0];
					8'd34: sda_out <= 1'b1;		//读
					8'd38: begin
							 sda_dir <= 1'b0;
							 sda_out <= 1'b1;
					end
					8'd40: st_done <= 1'b1;
					8'd41: begin
							 IIC_SCL   <= 1'b0;
							 scl4x_cnt <= 8'd0;
					end
					default: ;
				endcase				
			end
			ST_RDDATA: begin
				case(scl4x_cnt)
					8'd0: sda_dir <= 1'd0;
					8'd1,8'd5,8'd9,8'd13,8'd17,8'd21,8'd25,8'd29,8'd33: IIC_SCL <= 1'b1;
					8'd3,8'd7,8'd11,8'd15,8'd19,8'd23,8'd27,8'd31: 		 IIC_SCL <= 1'b0;	
				   8'd2,8'd6,8'd10,8'd14,8'd18,8'd22,8'd26,8'd30:  	 IIC_read_data <= {IIC_read_data[6:0],sda_in};	
					8'd32: begin
							sda_dir <= 1'b1;		//主机非应答
							sda_out <= 1'b1;	
					end
					8'd34: st_done <= 1'b1;
					8'd35: begin
							 IIC_SCL   <= 1'b0;
							 scl4x_cnt <= 8'd0;
					end
					default: ;
				endcase			
			end
			ST_DONE: begin
				case(scl4x_cnt)			
					8'd0: begin
						sda_dir <= 1'b1;
						sda_out <= 1'b0;
					end
					8'd1:  IIC_SCL <= 1'b1;
					8'd3:  sda_out <= 1'b1;
					8'd34: st_done <= 1'b1;
					8'd35: begin 
						scl4x_cnt <= 8'd0;
						IIC_done  <= 1'b1;
					end
					default: ;
				endcase			
			end
			
			default: ;	
			
		endcase
		
	end	
	
end

	
endmodule

