`timescale 1ns/1ns
module sub38(a,b,s);
	input [37:0] a,b;
	output [37:0] s;
	assign s = a - b;
endmodule
