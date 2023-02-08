
module PC_Reg (input clk, rst, input PCWrite, input [11:0] in, output reg [11:0] out);

	initial out = 12'd0;

	always @(posedge clk, posedge rst) begin
		if (rst) out <= 12'd0;
		else if (PCWrite) out <= in;
	end
        
endmodule
