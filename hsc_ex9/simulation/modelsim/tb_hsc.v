// Copyright (C) 1991-2013 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

// *****************************************************************************
// This file contains a Verilog test bench template that is freely editable to  
// suit user's needs .Comments are provided in each section to help the user    
// fill out necessary details.                                                  
// *****************************************************************************
// Generated on "06/06/2016 14:48:48"
                                                                                
// Verilog Test Bench template for design : hsc
// 
// Simulation tool : ModelSim-Altera (Verilog)
// 

`timescale 1 ns/ 1 ps
module tb_hsc();
// constants                                           

// test vector input registers
reg ext_clk;
reg ext_rst_n;
reg [31:0] treg_fx3_db;
reg fx3_flaga;
reg fx3_flagb;
reg fx3_flagc;
reg fx3_flagd;

// wires                                               
wire [1:0]  fx3_a;
wire [31:0]  fx3_db;
wire fx3_pclk;
wire fx3_pktend_n;
wire fx3_slcs_n;
wire fx3_sloe_n;
wire fx3_slrd_n;
wire fx3_slwr_n;
wire led;

hsc uut_hsc (
// port map - connection between master ports and signals/registers   
	.ext_clk(ext_clk),
	.ext_rst_n(ext_rst_n),
	.fx3_a(fx3_a),
	.fx3_db(fx3_db),
	.fx3_flaga(fx3_flaga),
	.fx3_flagb(fx3_flagb),
	.fx3_flagc(fx3_flagc),
	.fx3_flagd(fx3_flagd),
	.fx3_pclk(fx3_pclk),
	.fx3_pktend_n(fx3_pktend_n),
	.fx3_slcs_n(fx3_slcs_n),
	.fx3_sloe_n(fx3_sloe_n),
	.fx3_slrd_n(fx3_slrd_n),
	.fx3_slwr_n(fx3_slwr_n),
	.led(led)
);

reg dlink; //1--fx3_db as output; 0--fx3_db as input

assign fx3_db = dlink ? treg_fx3_db:32'hzzzzzzzz;

initial begin
	ext_clk = 0;
	ext_rst_n = 0;
	dlink = 0;
	
	fx3_flaga = 1'b0;
	fx3_flagb = 1'b0;
	fx3_flagc = 1'b0;
	fx3_flagd = 1'b0;
	treg_fx3_db = 32'd0;
	
	$display("Simulation Start...\n");	
	#1000;
	@(posedge ext_clk); #5;
	ext_rst_n = 1;
	
	#10000;	
	
	usb2fpga_data_transmit(64);
	
	fpga2usb_data_transmit();
	#10000;	
	
	$display("Simulation Finish.\n");
	$stop;	
	
	
end

always #20 ext_clk = ~ext_clk;

integer i;

//usb controller transmit data to fpga，传输数据值从1开始递增
task usb2fpga_data_transmit;
	input[15:0] data_num;	//传输数据数量
	begin
		@(posedge fx3_pclk) #3;		//有数据需要传输，拉高标志位
		fx3_flaga = 1;
		fx3_flagb = 1;
		@(negedge (fx3_slcs_n | fx3_sloe_n | fx3_slrd_n));
		
		dlink = 1;		
		repeat(3) begin
			@(posedge fx3_pclk) #3;	
		end
		
		for(i=1;i<=data_num;i=i+1) begin
			@(posedge fx3_pclk) #3;			
			treg_fx3_db = i;
			if(i>data_num-6) fx3_flaga = 0;
			if(i>data_num-6) fx3_flagb = 0;
		end
		
		@(posedge fx3_pclk) #3;	
		dlink = 0;
		
	end
endtask

//fpga transmit data to usb controller
task fpga2usb_data_transmit;
	//input[15:0] data_num;	//传输数据数量
	begin
		@(posedge fx3_pclk) #3;		//有数据需要传输，拉高标志位
		fx3_flaga = 1;
		fx3_flagb = 1;
		@(negedge (fx3_slcs_n | fx3_slwr_n));
		@(posedge (fx3_slcs_n | fx3_slwr_n));
		//dlink = 1;		
	/*	repeat(3) begin
			@(posedge fx3_pclk) #3;	
		end
		
		for(i=1;i<=data_num;i=i+1) begin
			@(posedge fx3_pclk) #3;			
			treg_fx3_db = i;
			if(i>data_num-6) fx3_flaga = 0;
			if(i>data_num-6) fx3_flagb = 0;
		end
		
		@(posedge fx3_pclk) #3;	*/
		//dlink = 0;
		
	end
endtask
                                                   
endmodule

