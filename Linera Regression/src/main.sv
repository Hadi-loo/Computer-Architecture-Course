`timescale 1ns/1ns
module main(rst,clk, error);

	input rst,clk;
	
	output [19:0] error;

	wire co,cnt,clr_counter;
	wire clr_psumx,clr_psumy,clr_meanx,clr_meany,clr_sumxx,clr_sumxy,clr_B0,clr_B1;
	wire ld_psumx,ld_psumy,ld_sumxy,ld_sumxx,ld_meanx,ld_meany,ld_B0,ld_B1;

	datapath DP(rst,clk, clr_counter,cnt, ld_psumx,clr_psumx, ld_meanx,clr_meanx,
			ld_psumy,clr_psumy, ld_meany,clr_meany, ld_sumxy,clr_sumxy, ld_sumxx,clr_sumxx,
			ld_B0,clr_B0, ld_B1,clr_B1,	co,error);

	controller CU(clk,rst,co,cnt,clr_counter,
			clr_psumx,clr_psumy,clr_meanx,clr_meany,clr_sumxx,clr_sumxy,clr_B0,clr_B1,
			ld_psumx,ld_psumy,ld_sumxy,ld_sumxx,ld_meanx,ld_meany,ld_B0,ld_B1);

endmodule

module main_TB();
	
	reg rst = 0;
	reg clk = 0;
	wire [19:0] error;
	main UUT(rst,clk, error);
	always #5 clk = ~clk;

endmodule
