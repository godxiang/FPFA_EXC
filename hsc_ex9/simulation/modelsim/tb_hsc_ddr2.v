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
// Generated on "07/25/2019 13:51:15"
                                                                                
// Verilog Test Bench template for design : hsc
// 
// Simulation tool : ModelSim-Altera (Verilog)
// 

`timescale 1 ns/ 1 ps
module hsc_vlg_tst();
// constants                                           
// general purpose registers
reg eachvec;
// test vector input registers
reg ext_clk;
reg ext_rst_n;
reg [0:0] treg_mem_clk;
reg [0:0] treg_mem_clk_n;
reg [15:0] treg_mem_dq;
reg [1:0] treg_mem_dqs;
// wires                                               
wire led;
wire [12:0]  mem_addr;
wire [1:0]  mem_ba;
wire mem_cas_n;
wire [0:0]  mem_cke;
wire [0:0]  mem_clk;
wire [0:0]  mem_clk_n;
wire [0:0]  mem_cs_n;
wire [1:0]  mem_dm;
wire [15:0]  mem_dq;
wire [1:0]  mem_dqs;
wire [0:0]  mem_odt;
wire mem_ras_n;
wire mem_we_n;

// assign statements (if any)                          
assign mem_clk = treg_mem_clk;
assign mem_clk_n = treg_mem_clk_n;
assign mem_dq = treg_mem_dq;
assign mem_dqs = treg_mem_dqs;
hsc i1 (
// port map - connection between master ports and signals/registers   
	.ext_clk(ext_clk),
	.ext_rst_n(ext_rst_n),
	.led(led),
	.mem_addr(mem_addr),
	.mem_ba(mem_ba),
	.mem_cas_n(mem_cas_n),
	.mem_cke(mem_cke),
	.mem_clk(mem_clk),
	.mem_clk_n(mem_clk_n),
	.mem_cs_n(mem_cs_n),
	.mem_dm(mem_dm),
	.mem_dq(mem_dq),
	.mem_dqs(mem_dqs),
	.mem_odt(mem_odt),
	.mem_ras_n(mem_ras_n),
	.mem_we_n(mem_we_n)
);
initial                                                
begin                                                  
	ext_clk = 0;
	ext_rst_n = 0;

	#1000;
	@(posedge ext_clk); #5;
	ext_rst_n = 1;
	
	#10000;	
	
	$stop;	    
	 
$display("Running testbench");                       
end 


always #20 ext_clk = ~ext_clk;
                                                   
always                                                 
// optional sensitivity list                           
// @(event1 or event2 or .... eventn)                  
begin                                                  
// code executes for every event on sensitivity list   
// insert code here --> begin                          
                                                       
@eachvec;                                              
// --> end                                             
end                                                    
endmodule

