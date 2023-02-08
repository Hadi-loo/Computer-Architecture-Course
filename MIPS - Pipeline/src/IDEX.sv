
module IDEX (	input clk, rst, 
		input [31:0] read_data1, read_data2, sgn_ext,
		input [4:0] Rt, Rd, Rs,
		input [31:0] adder1,
        	input [4:0] mux2_out,
		output reg [31:0] read_data1_out, read_data2_out, sgn_ext_out,
		output reg [4:0] Rt_out, Rd_out, Rs_out,
		output reg [31:0] adder1_out,
        	output reg [4:0] mux2_out_out);

    always @(posedge clk) begin
        if (rst) begin
            {read_data1_out, read_data2_out, sgn_ext_out, adder1_out} <= {128'd0};
            {Rt_out, Rd_out, Rs_out} <= {15'd0};
	    mux2_out_out <= 5'd0;
        end

        else begin
            {read_data1_out, read_data2_out, sgn_ext_out, adder1_out} <= {read_data1, read_data2, sgn_ext, adder1};
            {Rt_out, Rd_out, Rs_out} <= {Rt, Rd, Rs};
	    mux2_out_out <= mux2_out;
        end
    end

endmodule


module IDEX_control (	input clk, rst,
			input [2:0] alu_op_in, input alu_src_in,
			input reg_write_in, input [1:0] reg_dst_in,
			input mem_read_in, mem_write_in,
			input [1:0]  mem_to_reg_in,
			output reg [2:0] alu_op, output reg alu_src,
			output reg reg_write, output reg [1:0] reg_dst,
			output reg mem_read, mem_write,
			output reg [1:0] mem_to_reg);

    always @(posedge clk) begin
        if (rst)
            {alu_op, alu_src, reg_write, reg_dst, mem_read, mem_write, mem_to_reg} <= {3'b000, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 2'b00};
        else
            {alu_op, alu_src, reg_write, reg_dst, mem_read, mem_write, mem_to_reg} <= {alu_op_in, alu_src_in, reg_write_in, reg_dst_in, mem_read_in, mem_write_in, mem_to_reg_in};
    end

endmodule
