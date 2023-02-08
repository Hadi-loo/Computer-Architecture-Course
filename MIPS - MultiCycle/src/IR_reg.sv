
module IR_Reg (input clk, rst, input IRWrite, input [15:0] in, output reg [15:0] out);

	initial out = 32'd0;

	always @(posedge clk, posedge rst) begin
		if (rst) out <= 32'd0;
		else if (IRWrite) out <= in;
	end
        
endmodule
