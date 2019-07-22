
//******************************************************
// - sdram param define 
// first implement at 2019-7-20
//******************************************************

`define I_NOP   3'd0
`define I_PRE   3'd1
`define I_TRP   3'd2
`define I_AR    3'd3
`define I_TRF   3'd4
`define I_MRS   3'd5
`define I_TRSC  3'd6
`define I_DONE  3'd7



`define W_IDLE   4'd0
`define W_AR	  4'd1
`define W_ACTIVE 4'd2	
`define W_TRFC   4'd3
`define W_TRCD   4'd4
`define W_READ   4'd5
`define W_WRITE  4'd6
`define W_CL     4'd7
`define W_RD	  4'd8
`define W_PRE    4'd9
`define W_TRP    4'd10
`define W_WD     4'd11
`define W_TWR    4'd12


`define end_trp  cnt_clk == TRP_CLK		//end of prechaging effective cycle
`define end_trfc cnt_clk == TRC_CLK
`define end_trsc cnt_clk == TRSC_CLK
`define end_trcd cnt_clk == TRCD_CLK
`define end_tcl  cnt_clk == TCL_CLK
`define end_tread  cnt_clk == sdram_rd_burst + 2
`define end_twrite cnt_clk == sdram_wr_burst - 1
`define end_twr    cnt_clk == TWR_CLK


