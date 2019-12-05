`timescale 1ns/1ns

`define clk_period 20

module eeprom_rw_tb();


reg Clk;
reg Rst_n;
reg  [7:0]Eeprom_wr_data;
reg 	    Eeprom_wr_en;
reg 	    Eeprrom_rd_en;
reg [15:0]Eeprom_addr;

wire      Eeprom_done;
wire		 Eeprom_clk;
wire[7:0] Eeprrom_rd_data;
wire 	    IIC_SCL;
wire 	    IIC_SDA;


initial Clk = 1'b0;
always #(`clk_period / 2) Clk = ~Clk;

integer i;

initial begin

	Eeprom_wr_data = 8'd0;
	Eeprom_wr_en   = 1'b0;
	Eeprrom_rd_en  = 1'b0;
	Eeprom_addr		= 16'd0;	
	Rst_n = 1'b0;
	
	#(10 * `clk_period) Rst_n = 1'b1;
	
	@(posedge Eeprom_clk)
	@(posedge Eeprom_clk)
	
	for (i = 0; i < 3; i = i + 1) begin
		Eeprom_wr_data = 8'd255 - i;
		//Eeprom_wr_data = 8'haa;
		Eeprom_addr    = i;
		
		Eeprom_wr_en = 1'b1;
		@(posedge Eeprom_clk);
		Eeprom_wr_en = 1'b0;
		@(posedge Eeprom_done);		
		@(posedge Eeprom_clk);	
	end
	
	#3000;
	
	@(posedge Eeprom_clk)
	@(posedge Eeprom_clk)
	
	for (i = 0; i < 3; i = i + 1) begin
		Eeprom_addr    = i;
		
		Eeprrom_rd_en = 1'b1;
		@(posedge Eeprom_clk)
		Eeprrom_rd_en = 1'b0;
		@(posedge Eeprom_done);		
		@(posedge Eeprom_clk);
	end
	
	#3000;

	$stop;
	
end


eeprom_rw u_eeprom_rw(
	.Clk(Clk),
	.Rst_n(Rst_n),

	.Eeprom_wr_data(Eeprom_wr_data),
	.Eeprom_wr_en(Eeprom_wr_en),
	.Eeprrom_rd_data(Eeprrom_rd_data),
	.Eeprrom_rd_en(Eeprrom_rd_en),
	.Eeprom_addr(Eeprom_addr),
	.Eeprom_done(Eeprom_done),
	.Eeprom_clk(Eeprom_clk),

	.IIC_SCL(IIC_SCL),
	.IIC_SDA(IIC_SDA)
	
);

M24LC64 u_M24LC64(
	.A0(1'b0), 
	.A1(1'b0), 
	.A2(1'b0), 
	.WP(1'b0), 
	.SDA(IIC_SDA), 
	.SCL(IIC_SCL), 
	.RESET(!Rst_n)
);


endmodule
