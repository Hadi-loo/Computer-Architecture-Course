`timescale 1ns/1ns
module divider150(a,res);
	input [27:0] a;
	output [19:0] res;
	assign res = a / 150;
endmodule

module divider150_TB();
	reg [27:0] a = 28'b000000000000000000_0010010110;
	wire [19:0] res;
	divider150 div(a,res);
endmodule