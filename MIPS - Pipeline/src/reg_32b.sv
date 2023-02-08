
module reg_32b (input clk, rst, load, input [31:0] in, output reg [31:0] out);

	initial out = 32'd0;

	always @(posedge clk, posedge rst) begin
		if (rst) out <= 32'd0;
		else if (load) out <= in;
	end
        
endmodule
