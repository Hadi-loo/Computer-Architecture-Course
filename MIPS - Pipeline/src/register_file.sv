
module register_file (input clk, rst, RegWrite, 
		input [4:0] reg1, reg2, write_reg, input [31:0] write_data,
		output [31:0] data1, output [31:0] data2);

	reg [31:0] regs [31:0];

	assign data1 = (reg1 == 5'd0) ? 32'd0 : regs[reg1];
    	assign data2 = (reg2 == 5'd0) ? 32'd0 : regs[reg2];

	integer i;
	always @(posedge clk, posedge rst) begin

		if (rst)
            		for (i=0; i<32 ; i=i+1)
                		regs[i] <= 32'd0;

		else if (RegWrite)
			if (write_reg != 5'd0)
				regs[write_reg] <= write_data;
	end

endmodule