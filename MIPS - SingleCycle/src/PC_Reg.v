`timescale 1ns/1ns

module PC_Reg (input clk, rst, input [31:0] in, output reg [31:0] out);

	initial out = 32'd0;

	always @(posedge clk, posedge rst) begin
		if (rst) out <= 32'd0;
		else out <= in;
	end
        
endmodule