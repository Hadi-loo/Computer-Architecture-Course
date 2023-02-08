
module ALU (input [2:0] ALUop, input [15:0] a, b, output zero, output reg [15:0] out);

	assign out = 	(ALUop == 3'b000) ? (a+b) :
			(ALUop == 3'b001) ? (a-b) :
			(ALUop == 3'b010) ? (a&b) :
			(ALUop == 3'b011) ? (a|b) : 
			(ALUop == 3'b100) ? (~b)  : 16'd0;

	assign zero = (out == 16'd0) ? 1'b1 : 1'b0;

endmodule
