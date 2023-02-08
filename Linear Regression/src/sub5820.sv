`timescale 1ns/1ns
module sub5820(a,b,s);
	input [57:0] a;
	input [19:0] b;
	output [57:0] s;
	assign s = b - a;
endmodule