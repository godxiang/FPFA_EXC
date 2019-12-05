`timescale 1ns/1ns

`define clk_period 20

module iic_drv_tb();

reg  Clk;								// 输入时钟 50MHZ
reg  Rst_n;								// 外部复位信号
reg  IIC_en;							// IIC 使能信号
reg  [6:0]IIC_slave_addr;			// IIC从机地址
reg  [15:0]IIC_dev_addr;			// IIC设备内地址
reg  IIC_bit_sel;						// IIC设备内地址位选择  8/16  0:8  1:16
reg  IIC_rh_wl;						// IIC读写控制位 0：读 1：写
reg  [7:0]IIC_write_data;			// IIC写入的数据

wire [7:0]IIC_read_data;			// IIC读出的数据
wire IIC_done;							// IIC读取结束信号
wire IIC_SCL;							// IIC时钟线  
 
wire IIC_SDA;						   // IIC数据线 双向

wire Scl4x;

initial Clk = 1'b0;
always #(`clk_period / 2) Clk = ~Clk;

initial begin

	IIC_en = 1'b0;
	IIC_slave_addr = 7'b1010000;
	IIC_dev_addr = 16'd0;
	IIC_bit_sel  = 1'b0;
	IIC_rh_wl    = 1'b0;
	IIC_write_data = 8'd0;
	Rst_n = 1'b0;
	#(10 * `clk_period) Rst_n = 1'b1;
	#3000;
	
	IIC_bit_sel  = 1'b1;
	IIC_dev_addr = 16'b_0000_1010_0101_1010;
	IIC_rh_wl    = 1'b0; //写
	IIC_write_data = 8'h5a;
	IIC_en       = 1'b1;
	@(posedge Scl4x) IIC_en = 1'b0;
	@(posedge IIC_done);
	
	#3000;
	
	IIC_bit_sel  = 1'b1;
	IIC_dev_addr = 16'b_0000_1010_1101_1010;
	IIC_rh_wl    = 1'b1; //读
	IIC_en       = 1'b1;
	@(posedge Scl4x) IIC_en = 1'b0;
	@(posedge IIC_done);
	
	#3000;
	
	$stop;
	
end


iic_drv u_iic_drv(
	.Clk(Clk),
	.Rst_n(Rst_n),

	.IIC_en(IIC_en),
	.IIC_done(IIC_done),

	.IIC_slave_addr(IIC_slave_addr),
	.IIC_dev_addr(IIC_dev_addr),
	.IIC_bit_sel(IIC_bit_sel),

	.IIC_rh_wl(IIC_rh_wl),
	.IIC_write_data(IIC_write_data),
	.IIC_read_data(IIC_read_data),
	
	.Scl4x(Scl4x),
	
	.IIC_SCL(IIC_SCL),
	.IIC_SDA(IIC_SDA)
);



endmodule



