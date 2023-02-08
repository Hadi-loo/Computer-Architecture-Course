`timescale 1ns/1ns

module ALU (input [1:0] ALUop, input [31:0] a, input [31:0]b, output zero, output reg [31:0] out);

	assign out = 	(ALUop == 2'b00) ? (a+b) :
			(ALUop == 2'b01) ? (a-b) :
			(ALUop == 2'b10) ? (a&b) :
			(ALUop == 2'b11) ? (a|b) : 32'd0;

	assign zero = (out == 32'd0) ? 1'b1 : 1'b0;

endmodule
