`timescale 1ns/1ns
module dataloader(q, x,y);
	input [7:0] q;
	output [19:0] x,y;
	reg [19:0] x_value [149:0];
	reg [19:0] y_value [149:0];
	initial begin
		$readmemb("x_value.txt", x_value);
		$readmemb("y_value.txt", y_value);
	end
	assign x = x_value[q];
	assign y = y_value[q];
endmodule

