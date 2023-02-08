`timescale 1ns/1ns

module DataPath(input clk, rst, Jalr, Branch, PCSrc, RegWrite, ALUSrc, MemRead, MemWrite, input [1:0] ALUop,
		input [1:0] RegDst, input [1:0] RegData, output zero, output [5:0] opc, output [5:0] func);

	wire [31:0] inst;
	wire [31:0] data1;
	wire [31:0] data2;
	wire [31:0] data3;
	wire [31:0] ALU_out;

	wire [31:0] PC_in;
	wire [31:0] PC_out;

	wire [31:0] PC_4;
	wire [31:0] adder2_out;
	wire [31:0] Jalr_out;
	wire [31:0] Branch_out;
	wire [4 :0] RegDst_out;
	wire [31:0] ALUSrc_out;
	wire [31:0] RegData_out;
	wire [31:0] Extended_inst;
	wire Zero;

	assign Extended_inst = {{16{inst[15]}}, inst[15:0]};
	assign zero = Zero;
	assign opc = inst[31:26];
	assign func = inst[5:0];
	
	mux2_32 mux1 ({PC_out[31:28],inst[25:0],2'b00}, data1, Jalr, Jalr_out);
	mux2_32 mux2 (Jalr_out, adder2_out, Branch, Branch_out);
	mux2_32 mux3 (PC_4, Branch_out, PCSrc, PC_in);
	mux3_5  mux4 (inst[20:16], inst[15:11], 5'd31, RegDst, RegDst_out);
	mux2_32 mux5 (data2, Extended_inst, ALUSrc, ALUSrc_out);
	mux4_32 mux6 (ALU_out, data3, {{31{1'b0}},ALU_out[31]}, PC_4, RegData, RegData_out);

	adder32 adder1 (32'd4, PC_out, PC_4);
	adder32 adder2 (PC_4, {Extended_inst[29:0],2'b00}, adder2_out);

	PC_Reg pc_reg (clk, rst, PC_in, PC_out);

	RegisterFile RF (clk, rst, RegWrite, inst[25:21], inst[20:16], RegDst_out, RegData_out, data1, data2);

	ALU alu (ALUop, data1, ALUSrc_out, Zero, ALU_out);

	inst_mem IM (PC_out, inst);

	data_mem DM (ALU_out, data2, MemRead, MemWrite, clk, data3);

endmodule