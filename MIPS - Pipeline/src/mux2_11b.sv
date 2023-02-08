
module mux2_11b (input [10:0] a, b, input s, output [10:0] y);

    assign y = 	(s == 1'b0) ? a :
		(s == 1'b1) ? b : 11'd0;
    
endmodule
