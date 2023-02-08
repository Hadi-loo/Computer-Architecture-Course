`timescale 1ns/1ns
module adder58(a,b, s);
	input [57:0] a,b;
	output [57:0] s;
	assign s = a + b;
endmodule
