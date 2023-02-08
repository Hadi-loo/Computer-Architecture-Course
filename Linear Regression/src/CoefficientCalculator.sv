`timescale 1ns/1ns
module coefficentcalculator(en,clk,rst, x,y, 
				ld_sumx,clr_sumx, ld_meanx,clr_meanx, 
				ld_sumy,clr_sumy, ld_meany,clr_meany,
				ld_sumxy,clr_sumxy, ld_sumxx,clr_sumxx,
				ld_B0,clr_B0, ld_B1,clr_B1,
				B0_out,B1_out);

	input en,clk,rst;
	input ld_sumx,clr_sumx, ld_meanx,clr_meanx;
	input ld_sumy,clr_sumy, ld_meany,clr_meany;
	input ld_sumxy,clr_sumxy, ld_sumxx,clr_sumxx;
	input ld_B0,clr_B0, ld_B1,clr_B1;
	input [19:0] x,y;

	wire [37:0] in_sumx,out_sumx, in_sumy,out_sumy;
	wire [19:0] in_meanx,out_meanx, in_meany,out_meany;
	wire [37:0] in_sumxy,out_sumxy, in_sumxx,out_sumxx;
	wire [39:0] xy,xx, meanxmeany,meanxmeanx;
	wire [37:0] nmeanxmeany,nmeanxmeanx;
	wire [37:0] ssxy,ssxx;
	wire [67:0] i;
	wire [47:0] B1,out_B1;
	wire [57:0] B0,out_B0;

	output [47:0] B1_out;
	output [57:0] B0_out;

	assign B0_out = out_B0;
	assign B1_out = out_B1;
	
	reg38 sumx(clk,rst,ld_sumx,clr_sumx,in_sumx, out_sumx);
	adder38 adder1(out_sumx,{{18{x[19]}},x}, in_sumx);
	divider150 divider1(out_sumx, in_meanx);
	reg20 meanx(clk,rst,ld_meanx,clr_meanx,in_meanx, out_meanx);

	reg38 sumy(clk,rst,ld_sumy,clr_sumy,in_sumy, out_sumy);
	adder38 adder2(out_sumy,{{18{y[19]}},y}, in_sumy);
	divider150 divider2(out_sumy, in_meany);
	reg20 meany(clk,rst,ld_meany,clr_meany,in_meany, out_meany);

	reg38 sumxy(clk,rst,ld_sumxy,clr_sumxy,in_sumxy, out_sumxy);
	mult20 multxy(x,y, xy);
	adder38 adder3(out_sumxy,{{8{xy[39]}},xy[39:10]}, in_sumxy);

	reg38 sumxx(clk,rst,ld_sumxx,clr_sumxx,in_sumxx, out_sumxx);
	mult20 multxx(x,x, xx);
	adder38 adder4(out_sumxx,{{8{xx[39]}},xx[39:10]}, in_sumxx);

	mult20 multmeanxmeany(out_meanx,out_meany, meanxmeany);
	multn multn1(meanxmeany[39:10], nmeanxmeany);
	sub38 sub1(out_sumxy,nmeanxmeany, ssxy);

	mult20 multmeanxmeanx(out_meanx,out_meanx, meanxmeanx);
	multn multn2(meanxmeanx[39:10], nmeanxmeanx);
	sub38 sub2(out_sumxx,nmeanxmeanx, ssxx);

	dividerss divss(ssxy,ssxx, B1);
	mult4820 mult1(B1,out_meanx, i);
	sub58 sub3(i[67:10],out_meany, B0);

	reg48 regB1(clk,rst,ld_B1,clr_B1,B1, out_B1);
	reg58 regB0(clk,rst,ld_B0,clr_B0,B0, out_B0);	

endmodule
