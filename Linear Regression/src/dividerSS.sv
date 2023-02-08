`timescale 1ns/1ns
module dividerss(a,b,res);
	input [37:0] a,b;
	output [47:0] res;
	assign res = {a,10'b0000000000} / {{10{b[37]}},b};
endmodule
