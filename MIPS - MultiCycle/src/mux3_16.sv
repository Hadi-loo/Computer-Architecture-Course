
module mux3_16 (input [15:0] a, b, c, input [1:0] s, output [15:0] y);

    assign y =  (s == 2'b00) ? a :
		(s == 2'b01) ? b :
		(s == 2'b10) ? c : 16'd0;
    
endmodule
