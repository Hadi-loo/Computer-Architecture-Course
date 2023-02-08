`timescale 1ns/1ns

module controller (input [5:0] opcode, input [5:0] func, input zero, 
			output reg ALUSrc, MemRead, MemWrite, RegWrite, Jalr, branch, PCSrc, 
			output reg [1:0] ALUop, RegDst, RegData);
    
    always @(opcode, func, zero) begin
        {ALUSrc, MemRead, MemWrite, RegWrite, Jalr, branch, PCSrc, ALUop, RegDst, RegData} = 14'd0;
        case (opcode)

            	// RT
            	6'b000000 : case (func)
				// add
				6'b100000 : {ALUop, ALUSrc, MemRead, MemWrite, RegDst, RegWrite, RegData, PCSrc} = 11'b00000011000;
				// sub
				6'b100010 : {ALUop, ALUSrc, MemRead, MemWrite, RegDst, RegWrite, RegData, PCSrc} = 11'b01000011000;
				// slt
				6'b101010 : {ALUop, ALUSrc, MemRead, MemWrite, RegDst, RegWrite, RegData, PCSrc} = 11'b01000011100;
				// and
				6'b100100 : {ALUop, ALUSrc, MemRead, MemWrite, RegDst, RegWrite, RegData, PCSrc} = 11'b10000011000;
				// or
				6'b100101 : {ALUop, ALUSrc, MemRead, MemWrite, RegDst, RegWrite, RegData, PCSrc} = 11'b11000011000;
				// jr
				6'b001000 : {MemRead, MemWrite, RegWrite, Jalr, branch, PCSrc} = 6'b000101;
			endcase

	    	// addi
            	6'b001000 : {ALUop, ALUSrc, MemRead, MemWrite, RegDst, RegWrite, RegData, PCSrc} = 11'b00100001000;

		// slti
            	6'b001010 : {ALUop, ALUSrc, MemRead, MemWrite, RegDst, RegWrite, RegData, PCSrc} = 11'b01100001100;
	
            	// lw
            	6'b100011 : {ALUop, ALUSrc, MemRead, MemWrite, RegWrite, RegData, PCSrc} = 9'b001101010;
            
            	// sw
            	6'b101011 : {ALUop, ALUSrc, MemRead, MemWrite, RegWrite, PCSrc} = 7'b0010100;

            	// beq
            	6'b000100 : {ALUop, ALUSrc, MemRead, MemWrite, RegWrite, branch, PCSrc} = {7'b0100001,zero};
            
            	// j
            	6'b000010: {MemRead, MemWrite, RegWrite, Jalr, branch, PCSrc} = 6'b000001;
            
            	// jal
            	6'b000011 : {MemRead, MemWrite, RegDst, RegWrite, RegData, Jalr, branch, PCSrc} = 10'b0010111001;
        endcase
    end

endmodule
