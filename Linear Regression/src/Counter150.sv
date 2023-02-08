`timescale 1ns/1ns
module counter150(rst,clk,clr,cnt, co,q);
	input rst,clk,clr,cnt;
	output co;
	output reg [7:0] q;
	
	assign co = (q == 149) ? 1:0;

	always @(rst, posedge clk) begin
		if (rst) 
			q <= 0;
		else if (clr)
			q <= 0;
		else if (cnt)
			q <= q + 1; 
	end	

endmodule
