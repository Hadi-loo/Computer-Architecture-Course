
module ALU (	input [31:0] a, b,
            	input [2:0] ALUop,
		output [31:0] res,
            	output zero);

	assign zero = (res == 32'd0) ? 1'b1 : 1'b0;

	wire [31:0] subtract;
    	assign subtract = a - b;
	
    	assign res = 	(ALUop == 3'b000) ? (a & b) :
    			(ALUop == 3'b001) ? (a | b) :
    			(ALUop == 3'b010) ? (a + b) :
    			(ALUop == 3'b110) ? (a - b) : 
			(ALUop == 3'b111) ? (subtract[31] ? 32'd1 : 32'd0) : 32'd0;

endmodule

