`timescale 1ns/1ns

module MIPS_SC(input clk, rst);

	wire Jalr, Branch, PCSrc, RegWrite, ALUSrc, MemRead, MemWrite;
	wire [1:0] ALUop, RegDst, RegData;
	wire zero;
	wire [5:0] opc, func;

	DataPath DP (clk, rst, Jalr, Branch, PCSrc, RegWrite, ALUSrc, MemRead, MemWrite, ALUop,
			RegDst, RegData, zero, opc, func);

	controller CU (opc, func, zero, 
			ALUSrc, MemRead, MemWrite, RegWrite, Jalr, Branch, PCSrc, 
			ALUop, RegDst, RegData);
	
endmodule