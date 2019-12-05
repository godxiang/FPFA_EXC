
module eeprom_rw(
	Clk,
	Rst_n,
	
	//用户接口
	Eeprom_wr_data,
	Eeprom_wr_en,
	Eeprrom_rd_data,
	Eeprrom_rd_en,
	Eeprom_addr,
	Eeprom_done,
	Eeprom_clk,
	
	//IIC接口
	IIC_SCL,
	IIC_SDA
	
);

input Clk;
input Rst_n;

input  [7:0]Eeprom_wr_data;
input 	   Eeprom_wr_en;
output [7:0]Eeprrom_rd_data;
input 	   Eeprrom_rd_en;
input [15:0]Eeprom_addr;
output      Eeprom_done;
output		Eeprom_clk;

output  IIC_SCL;
output  IIC_SDA;

//***************************************************************************
//** MAIN CODE
//***************************************************************************	

parameter SLAVE_ADDR    = 7'b101_0000; //EEPROM 地址
parameter DEVADDR_16BIT = 1'b1;		   //16bit

reg  IIC_rh_wl;	//IIC读写bit

//***************************************************************************
//** MAIN CODE
//***************************************************************************	

//读写位赋值
always @(posedge Eeprom_clk or negedge Rst_n) begin
	if (!Rst_n) begin
		IIC_rh_wl <= 1'b0;
	end else if (Eeprrom_rd_en) begin
		IIC_rh_wl <= 1'b1;
	end else if (Eeprom_wr_en) begin
		IIC_rh_wl <= 1'b0;
	end else begin
		IIC_rh_wl <= IIC_rh_wl;
	end

end


//IIC_DRV模块
 iic_drv u_iic_drv(
	.Clk(Clk),
	.Rst_n(Rst_n),

	.IIC_en(Eeprrom_rd_en | Eeprom_wr_en),
	.IIC_done(Eeprom_done),

	.IIC_slave_addr(SLAVE_ADDR),
	.IIC_dev_addr(Eeprom_addr),
	.IIC_bit_sel(DEVADDR_16BIT),

	.IIC_rh_wl(IIC_rh_wl),
	.IIC_write_data(Eeprom_wr_data),
	.IIC_read_data(Eeprrom_rd_data),

	.Scl4x(Eeprom_clk),

	.IIC_SCL(IIC_SCL),
	.IIC_SDA(IIC_SDA)

);




endmodule


