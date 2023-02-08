`timescale 1ns/1ns
module errorchecker(en,clk,rst,B0,B1,x,y, error);
	input en,clk,rst;
	input [47:0] B1;
	input [57:0] B0;
	input [19:0] x,y;

	wire [67:0] i;
	wire [57:0] j;
	wire [57:0] k;

	output [19:0] error;

	assign error = k[19:0];

	mult4820 mult1(B1,x, i);
	adder58 adder1(i[67:10],B0, j);
	sub5820 sub1(j,y, k);

endmodule
