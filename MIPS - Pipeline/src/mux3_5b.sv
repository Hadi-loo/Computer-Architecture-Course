
module mux3_5b (input [4:0] a, b, c, input [1:0] s, output [4:0] y);

    assign y = 	(s == 2'b00) ? a :
		(s == 2'b01) ? b :
		(s == 2'b10) ? c : 5'd0;
    
endmodule