
module MIPS_MC (input clk, rst);

	wire [1:0] PCSrc;
	wire PCWrite, IorD;
	wire MemRead, MemWrite;
	wire Reg1Src, RegDst;
	wire [1:0] writeSrc;
	wire RegWrite;
	wire ALUSrcA;
	wire [1:0] ALUSrcB;
	wire [2:0] ALUop;
	wire IRWrite;
	wire [15:0] instruction;
	wire zero;
	wire [3:0] opc;
	wire [8:0] func;

	assign opc = instruction [15:12];
	assign func = instruction [8:0];

	datapath DP(	clk, rst,
			PCSrc,
			PCWrite,
			IorD,
			MemRead, MemWrite,
			Reg1Src, RegDst,
			writeSrc,
			RegWrite,
			ALUSrcA, 
			ALUSrcB,
			ALUop,
			IRWrite,
			instruction,
			zero);

	controller CU(	clk, rst,
			opc, func,
			zero,
			PCSrc,
			PCWrite,
			IorD,
			MemRead, MemWrite,
			Reg1Src, RegDst,
			writeSrc,
			RegWrite,
			ALUSrcA,
			ALUSrcB,
			ALUop,
			IRWrite);

endmodule