
module RegisterFile(	input clk, rst, RegWrite, 
			input [2:0] reg1, reg2, write_reg, 
			input [15:0] write_data,
			output reg [15:0] data1, data2);

	reg [15:0] regs [7:0];

	assign data1 = regs[reg1];
    	assign data2 = regs[reg2];
	integer i;
	always @(posedge clk, posedge rst) begin

		if (rst)
            		for (i=0; i<8 ; i=i+1)
                		regs[i] <= 16'd0;

		//else if (RegWrite)
		//	if (write_reg == 3'b010) regs[write_reg] <= 16'b1000000000000000;
		//	else regs[write_reg] <= write_data;
		
		else if (RegWrite)
			regs[write_reg] = write_data;
	end

endmodule
