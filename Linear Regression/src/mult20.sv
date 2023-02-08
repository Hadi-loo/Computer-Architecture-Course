`timescale 1ns/1ns
module mult20(a,b,res);
	input [19:0] a,b;
	output [39:0] res;
	assign res = a * b;
endmodule
