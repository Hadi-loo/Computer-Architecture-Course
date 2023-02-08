`timescale 1ns/1ns
module multn(a,res);
	input [29:0] a;
	reg [7:0] b = 150;
	output [37:0] res;
	assign res = a * b;
endmodule
