`timescale 1ns/1ns
module reg48(clk,rst,ld,clr,in, out);
	input clk,rst,ld,clr;
	input [47:0] in;
	output reg [47:0] out;
	
	always @(rst, posedge clk) begin
		if (rst)
			out <= 0;
		else begin 
			if (clr)
				out <= 0;
			else if (ld)
				out <= in;	
		end
	end
endmodule