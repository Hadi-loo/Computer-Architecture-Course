`timescale 1ns/1ns

module mux4_32 (input [31:0] a, b, c, d, input [1:0] s, output [31:0] y);

    assign y = 	(s == 2'b00) ? a :
		(s == 2'b01) ? b :
		(s == 2'b10) ? c :
		(s == 2'b11) ? d : 5'd0;
    
endmodule
