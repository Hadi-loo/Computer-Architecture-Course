`timescale 1ns/1ns
module datapath(rst,clk, clr_counter,cnt, ld_sumx,clr_sumx, ld_meanx,clr_meanx,
		ld_sumy,clr_sumy, ld_meany,clr_meany, ld_sumxy,clr_sumxy, ld_sumxx,clr_sumxx,
		ld_B0,clr_B0, ld_B1,clr_B1,
		co,error);
	
	input rst,clk;
	input clr_counter,cnt;
	input ld_sumx,clr_sumx;
	input ld_meanx,clr_meanx; 
	input ld_sumy,clr_sumy, ld_meany,clr_meany;
	input ld_sumxy,clr_sumxy, ld_sumxx,clr_sumxx;
	input ld_B0,clr_B0, ld_B1,clr_B1;

	wire [7:0] q;
	wire [19:0] x,y;
	wire en_coefficent, en_error;
	wire [47:0] B1;
	wire [57:0] B0;

	output co;
	output [19:0] error;

	counter150 cnt150(rst,clk,clr_counter,cnt, co,q);
	dataloader dataldr(q, x,y);
	coefficentcalculator cocalc(en_coefficent,clk,rst, x,y, 
				ld_sumx,clr_sumx, ld_meanx,clr_meanx, 
				ld_sumy,clr_sumy, ld_meany,clr_meany,
				ld_sumxy,clr_sumxy, ld_sumxx,clr_sumxx,
				ld_B0,clr_B0, ld_B1,clr_B1, B0,B1);
	errorchecker errchkr(en_error,clk,rst,B0,B1,x,y, error);

endmodule