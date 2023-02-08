`timescale 1ns/1ns
module mult4820(a,b,res);
	input [47:0] a;
	input [19:0] b;
	output [67:0] res;
	assign res = a * b;
endmodule
