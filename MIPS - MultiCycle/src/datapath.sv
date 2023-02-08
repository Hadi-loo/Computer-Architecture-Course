
module datapath(input clk, rst,
		input [1:0] PCSrc,
		input PCWrite,
		input IorD,
		input MemRead, MemWrite,
		input Reg1Src, RegDst,
		input [1:0] writeSrc,
		input RegWrite,
		input ALUSrcA, 
		input [1:0] ALUSrcB,
		input [2:0] ALUop,
		input IRWrite,
		output [15:0] instruction,
		output zero);

	wire [11:0] PC_in, PC_out;
	wire [11:0] mem_address;
	wire [15:0] mem_write_data, mem_read_data;
	wire [15:0] inst;
	wire [15:0] mem_data;
	wire [2:0]  Reg1_in, writeReg_in;
	wire [15:0] writeData_in;
	wire [15:0] data1, data2;
	wire [15:0] A_out, B_out;
	wire [15:0] ALU_in_A, ALU_in_B;
	wire [15:0] ALU_res;
	wire [15:0] ALU_out;

	assign instruction = inst;
	assign mem_write_data = A_out;

	PC_Reg PC (clk, rst, PCWrite, PC_in, PC_out);
	
	mux2_12 MUX2 (PC_out, inst[11:0], IorD, mem_address);

	memory Mem (clk, MemRead, MemWrite, mem_address, mem_write_data, mem_read_data);

	IR_Reg IR (clk, rst, IRWrite, mem_read_data, inst);
	reg16 MDR (clk, rst, mem_read_data, mem_data);

	mux2_3 MUX3 (3'b000, inst[11:9], Reg1Src, Reg1_in);
	mux2_3 MUX4 (3'b000, inst[11:9], RegDst, writeReg_in);
	mux3_16 MUX5 (A_out, ALU_out, mem_data, writeSrc, writeData_in);

	RegisterFile RF (clk, rst, RegWrite, 
			Reg1_in, inst[11:9], writeReg_in, writeData_in,
			data1, data2);

	reg16 A (clk, rst, data1, A_out);
	reg16 B (clk, rst, data2, B_out);

	mux3_16 MUX6 (B_out, 16'd1, { {4{inst[11]}} , inst[11:0] }, ALUSrcB, ALU_in_B);
	mux2_16 MUX7 ({ 4'b0000 , PC_out }, A_out, ALUSrcA, ALU_in_A); // extendesh signede ya unsigned?

	ALU ALU1 (ALUop, ALU_in_A, ALU_in_B, zero, ALU_res);

	reg16 ALU_Result (clk, rst, ALU_res, ALU_out);

	mux3_12 MUX1 (inst[11:0], ALU_out[11:0], { ALU_out[11:9] , inst[8:0] }, ALU_res, PCSrc, PC_in); // concatesho motmaen nistam

endmodule