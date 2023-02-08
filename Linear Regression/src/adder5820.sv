`timescale 1ns/1ns
module adder5820(a,b, s);
	input [57:0] a;
	input [19:0] b;
	output [60:0] s;
	assign s = a + b;
endmodule
