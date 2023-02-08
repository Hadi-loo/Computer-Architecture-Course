    
module EXMEM (	input clk, rst,
		input [31:0] PC_4_in,
		input zero_in,
		input [31:0] ALU_res_in,
		input [31:0] mux3_out_in,
		input [4:0] mux5_out_in,
		output reg [31:0] PC_4_out,
		output reg zero_out, 
		output reg [31:0] ALU_res_out,
		output reg [31:0] mux3_out_out, 
		output reg [4:0] mux5_out_out);
        
    always @(posedge clk) begin
        if (rst)
            {PC_4_out, zero_out, ALU_res_out, mux3_out_out, mux5_out_out} <= {32'b0, 1'b0, 32'b0, 32'b0, 5'b0};
        else
            {PC_4_out, zero_out, ALU_res_out, mux3_out_out, mux5_out_out} <= {PC_4_in, zero_in, ALU_res_in, mux3_out_in, mux5_out_in};
    end
endmodule


module EXMEM_control(clk,
                  rst,
                  mem_write_in,
                  mem_read_in,
                  mem_to_reg_in,
                  reg_write_in,
                  mem_write,
                  mem_read,
                  mem_to_reg,
                  reg_write);
    input clk, rst;
    input reg_write_in;
    input mem_read_in, mem_write_in;
    input [1:0] mem_to_reg_in;
    
    output reg reg_write;
    output reg mem_read, mem_write;
    output reg [1:0] mem_to_reg;
    
    always @(posedge clk) begin
        if (rst)
            {mem_write, mem_read, mem_to_reg, reg_write} <= {1'b0, 1'b0, 2'b00, 1'b0};
        else
            {mem_write, mem_read, mem_to_reg, reg_write} <= {mem_write_in, mem_read_in, mem_to_reg_in, reg_write_in};
    end
endmodule
