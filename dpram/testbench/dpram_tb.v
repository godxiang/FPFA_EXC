
`timescale 1ns/1ns

`define clk_period 20

module dpram_tb();

reg	  		 clock;
reg	[7:0]  data;
reg	[7:0]  rdaddress;
reg	[7:0]  wraddress;
reg	  		 wren;
wire	[7:0]  q;

reg [7:0] i;

initial clock = 0;
always #(`clk_period/2) clock = ~clock;

initial begin
	data = 8'd0;
	rdaddress = 8'd0;
	wraddress = 8'd0;
	wren      = 8'd0;
   i = 8'd0;
	
	#(20 * `clk_period + 1);
	
	for (i = 0; i < 16; i = i + 1) begin
		wren = 1'b1;
		data = 255 - i;
		wraddress = i;
		#`clk_period;
	end	
	wren = 1'b0;
	
	#(20 * `clk_period );
	
	for (i = 0; i < 16; i = i + 1'b1) begin
		rdaddress = i;
		#`clk_period;
	end	
	
	#(20 * `clk_period );
	
	$stop;
	
end


ip_dpram  u_ip_dpram(

	.clock		(clock),
	.data			(data),
	.rdaddress	(rdaddress),
	.wraddress	(wraddress),
	.wren			(wren),
	.q				(q)
);


endmodule