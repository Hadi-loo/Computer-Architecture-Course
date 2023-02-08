
module mux3_12 (input [11:0] a, b, c, d, input [1:0] s, output [11:0] y);

    assign y =  (s == 2'b00) ? a :
		(s == 2'b01) ? b :
		(s == 2'b10) ? c :
		(s == 2'b11) ? d : 12'd0;
    
endmodule
