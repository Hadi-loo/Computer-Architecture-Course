
module mux2_32b (input [31:0] a, b, input s, output [31:0] y);

    assign y = 	(s == 1'b0) ? a :
		(s == 1'b1) ? b : 32'd0;
    
endmodule
