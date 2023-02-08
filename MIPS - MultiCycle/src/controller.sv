`define   IF      	5'd0
`define   ID      	5'd1
`define   load1   	5'd2
`define   load2   	5'd3
`define   store1      	5'd4
`define   store2      	5'd5
`define   jump1      	5'd6
`define   branchz1      5'd7
`define   branchz2      5'd8
`define   branchz3      5'd9
`define   branchz4     	5'd10
`define   ctype1     	5'd11
`define   ctype2     	5'd12
`define   ctype3    	5'd13
`define   ctype4     	5'd14
`define   dtype1     	5'd15
`define   dtype2     	5'd16
`define	  dtype3	5'd17

module controller (	input clk, rst,
			input [3:0] opc, input [8:0] func,
			input zero,
			output reg [1:0] PCSrc,
			output reg PCWrite,
			output reg IorD,
			output reg MemRead, MemWrite,
			output reg Reg1Src, RegDst,
			output reg [1:0] writeSrc,
			output reg RegWrite,
			output reg ALUSrcA,
			output reg [1:0] ALUSrcB,
			output reg [2:0] ALUop,
			output reg IRWrite);
    
    reg[4:0] ps, ns;
    
    always @(posedge clk) begin
        if (rst)
            ps <= `IF;
        else
            ps <= ns;
    end
    
    always @(ps, opc, func, zero)
        case (ps)

            `IF:  ns = `ID;
            
            `ID: case(opc)
                    4'b0000: ns = `load1; 					// load
                    4'b0001: ns = `store1;					// store
                    4'b0010: ns = `jump1;					// jump
                    4'b0100: ns = `branchz1;					// branchz
                    4'b1000: ns = (func == 9'b010000000) ? `IF : `ctype1;	// c-type
                    4'b1100: ns = `dtype1;					// d-type addi
                    4'b1101: ns = `dtype1;					// d-type subi
                    4'b1110: ns = `dtype1;					// d-type andi
		    4'b1111: ns = `dtype1;					// d-type ori
             	endcase

            `load1: ns = `load2;
            `load2: ns = `IF;

            `store1: ns = `store2;
            `store2: ns = `IF;

            `jump1: ns = `IF;

            `branchz1: ns = `branchz2;
            `branchz2: case (zero)
				1'b0: ns = `IF;
				1'b1: ns = `branchz3;
			endcase
            `branchz3: ns = `branchz4;
            `branchz4: ns = `IF;
            
            `ctype1: case(func)
			9'b000000001: ns = `ctype4;	// MoveTo
			9'b000000010: ns = `ctype4;	// MoveFrom 
			9'b000000100: ns = `ctype2;	// Add
			9'b000001000: ns = `ctype2;	// Sub
			9'b000010000: ns = `ctype2;	// And
			9'b000100000: ns = `ctype2;	// Or
			9'b001000000: ns = `ctype2;	// Not
		endcase
				
            `ctype2: ns = `ctype3;
            `ctype3: ns = `IF;
            `ctype4: ns = `IF;

            `dtype1: ns = `dtype2;
            `dtype2: ns = `dtype3;
	    `dtype3: ns = `IF;
            
        endcase
    
    always @(ps) begin

        {PCSrc, PCWrite, IorD, MemRead, MemWrite, Reg1Src, RegDst} = 8'd0;
	writeSrc = 2'd0;
	{RegWrite, ALUSrcA, IRWrite} = 3'd0;
	ALUSrcB = 2'd0;
	ALUop = 3'd0;
        
        case (ps)
            `IF:    	{MemRead, IorD, ALUSrcA, IRWrite, ALUSrcB, ALUop, PCWrite, PCSrc} = {4'b1001, 2'b01, 3'b000, 3'b111};
            
            `load1:    	{MemRead, IorD} = 2'b11;
            `load2:    	{RegWrite, writeSrc, RegDst} = 4'b1100; 

            `store1:    Reg1Src = 1'b0;                   
            `store2:    {MemWrite, IorD} = 2'b11;             
            
            `jump1: 	{PCWrite, PCSrc} = 3'b100;
 
            `branchz1:	Reg1Src = 1'b0; 
            `branchz2: 	{ALUop, ALUSrcB, ALUSrcA} = 6'b001001;
            `branchz3:	{ALUop, ALUSrcB, ALUSrcA} = 6'b001010;
	    `branchz4: 	{PCWrite, PCSrc} = 3'b110;
            
            `ctype1:  	case (func)
				9'b000000001: Reg1Src = 1'b0;	// MoveTo
				9'b000000010: Reg1Src = 1'b1;	// MoveFrom 
				9'b000000100: Reg1Src = 1'b0;	// Add
				9'b000001000: Reg1Src = 1'b0;	// Sub
				9'b000010000: Reg1Src = 1'b0;	// And
				9'b000100000: Reg1Src = 1'b0;	// Or
				9'b001000000: Reg1Src = 1'b0;	// Not
			endcase

            `ctype2:	begin
				case (func)
					9'b000000100: ALUop = 3'b000;	// Add
					9'b000001000: ALUop = 3'b001;	// Sub
					9'b000010000: ALUop = 3'b010;	// And
					9'b000100000: ALUop = 3'b011;	// Or
					9'b001000000: ALUop = 3'b100;	// Not
				endcase
				
				ALUSrcA = 1'b1;
				ALUSrcB = 2'b00;
			end

            `ctype3:	{RegDst, RegWrite, writeSrc} = 4'b0101;
					
            
            `ctype4: 	begin
				case (func)
					9'b000000001: RegDst = 1'b1;	// MoveTo
					9'b000000010: RegDst = 1'b0;	// MoveFrom 
				endcase
			
				RegWrite = 1'b1;
				writeSrc = 2'b00;
			end
            
            `dtype1:  	Reg1Src = 1'b0;
            
            `dtype2:  	{ALUop, ALUSrcB, ALUSrcA} = {1'b0, opc[1:0], 2'b10, 1'b1};
            
            `dtype3:   	{RegDst, RegWrite, writeSrc} = 4'b0101;
            
        endcase

    end
    
endmodule
