
module mips_pipeline(input clk, rst);
	
	wire PC_load;
	wire [1:0] PC_src;	
	wire flush; 
	wire RegWrite;		
	wire [1:0] RegDst;
	wire [2:0] ALU_control;
	wire ALU_src;			
	wire MemRead, MemWrite;
	wire [1:0] write_data_src;
	wire ops_equal;
	wire zero;
	wire [5:0] IFID_opcode, IFID_func;

 
	datapath DP(	clk, rst, 
			PC_load,			//		
			PC_src,				//
			flush, 				//
			RegWrite,			//	
			RegDst,				//
			ALU_control,			//
			ALU_src,			//		
			MemRead, MemWrite,		//
			write_data_src,			//
			ops_equal,			//
			zero,				//
			IFID_opcode, IFID_func);	//


	controller CU(	IFID_opcode, IFID_func,		//
                   	zero,				//
                   	RegDst,				//
                   	write_data_src,			//
                   	RegWrite, 			//
			ALU_src, 			//
			MemRead, MemWrite,		//
                   	PC_src,				//
                   	ALU_control,			//
                   	flush,				//
                   	ops_equal);			//

	
endmodule
