
`timescale 1ns/1ns

`define CLK100_PERIOD 10

module sdram_init_tb;


reg  REF_CLK;
reg  RST_N;


wire CLK;
wire CKE;
wire CS_N;
wire RAS_N;
wire CAS_N;
wire WE_N;
wire [12:0]A;
wire [1:0]BS;
wire [1:0]DQM;
wire [15:0]DQ;



initial REF_CLK = 1'b0;
always #(`CLK100_PERIOD / 2) REF_CLK = ~REF_CLK;


initial begin

	


end

sdram_w9825g6kh u_sdram_w9825g6kh(

	.REF_CLK(REF_CLK),
	.RST_N(RST_N),

	.CLK(CLK),
	.CKE(CKE),
	.CS_N(CS_N),
	.RAS_N(RAS_N),
	.CAS_N(CAS_N),
	.WE_N(WE_N),
	.A(A),
	.BS(BS),
	.DQM(DQM),
	.DQ(DQ), 
);


sdr u_sdr(
	.Dq(DQ), 
	.Addr(A), 
	.Ba(BS), 
	.Clk(CLK), 
	.Cke(CKE), 
	.Cs_n(CS_N), 
	.Ras_n(RAS_N), 
	.Cas_n(CAS_N),  
	.We_n(WE_N), 
	.Dqm(DQM), 
);