
module datapath (	input clk, rst, 
			input PC_load,			// controller
			input [1:0] PC_src,		// controller
			input flush, 			// controller
			input RegWrite,			// controller
			input [1:0] RegDst,		// controller 
			input [2:0] ALU_control,	// controller
			input ALU_src,			// controller
			input MemRead, MemWrite,	// controller
			input [1:0] write_data_src,	// controller
			output ops_equal,
			output zero,
			output [5:0] IFID_opcode, IFID_func);


	// Instruction Fetch

	wire [31:0] PC_out;	
	wire [31:0] PC_in;
	reg_32b PC_reg (clk, rst, PC_load, PC_in, PC_out);	// done

	wire [31:0] PC_4;
	adder_32b Adder_1 (PC_out, 32'd4, PC_4);		// done

	wire [31:0] inst;
	inst_mem IM (PC_out, inst);				// khode module takmil nist

	
	// IF/ID

	wire [31:0] IFID_inst;
	wire [31:0] IFID_PC_4;
	wire IFID_load;									// az hazard
	IFID IFID_reg (clk, rst, IFID_load, flush, inst, PC_4, IFID_inst, IFID_PC_4);	// done

	assign IFID_opcode = IFID_inst [31:26];
    	assign IFID_func = IFID_inst [5:0];


	// Instruction Decode

	wire [31:0] extended_inst16;
	assign extended_inst16 = { {16{IFID_inst[15]}}, IFID_inst[15:0] };	// done

	wire [31:0] shl2_extended_inst16;
	assign shl2_extended_inst16 = { extended_inst16[29:0], 2'b00 };		// done
	
	wire [27:0] shl2_inst26;
	assign shl2_inst26 = { IFID_inst[25:0], 2'b00 };			// done

	wire [31:0] Adder2_out;
	adder_32b Adder_2 (shl2_extended_inst16, IFID_PC_4, Adder2_out);	// done. IFID_PC_4 ya PC_4?

	wire [4:0]  write_reg;					// check. az MEMWB miad
	wire [31:0] write_data;					// check. az MUX_7 miad
	wire [31:0] data1, data2;
	wire MEMWB_RegWrite;					// check. az MEMWB miad
	register_file RF (clk, rst, MEMWB_RegWrite, 
			IFID_inst [25:21], IFID_inst [20:16], 
			write_reg, write_data,
			data1, data2);  			

	assign ops_equal = (data1 == data2) ? 1'b1 : 1'b0;	// done

	mux4_32b MUX_1 (PC_4, Adder2_out, {IFID_PC_4[31:28], shl2_inst26}, data1, PC_src, PC_in); 	// done. IFID_PC_4 ya PC_4?

	wire [4:0] mux2_out;				// hamoone ke tahesh mishe write_reg
	wire [1:0] IDEX_RegDst;				// RegDst ke az IDEX miad
	mux3_5b MUX_2 (IFID_inst[20:16], IFID_inst[15:11], 5'd31, RegDst, mux2_out);		// done. IDEX_RegDst ya RegDst?
	
	// Rt = [20:16], Rd = [15:11], Rs = [25:21]	


	// ID/EX

	wire [31:0] IDEX_data1, IDEX_data2, IDEX_extended_inst16;
	wire [4:0] IDEX_Rt, IDEX_Rd, IDEX_Rs;
	wire [31:0] IDEX_PC_4;
	wire [4:0] IDEX_mux2_out;

	wire [2:0] IDEX_ALU_control_in, IDEX_ALU_control;
    	wire IDEX_ALU_src_in, IDEX_ALU_src;
    	wire IDEX_RegWrite_in, IDEX_RegWrite;
   	wire [1:0] IDEX_RegDst_in;
    	wire IDEX_MemRead_in, IDEX_MemRead;
    	wire IDEX_MemWrite_in, IDEX_MemWrite;
    	wire [1:0] IDEX_write_data_src_in, IDEX_write_data_src;

	wire [10:0] mux3_in, mux3_out;
	assign mux3_in  = {ALU_control, ALU_src, RegWrite, RegDst, MemRead, MemWrite, write_data_src};	// check
	//assign mux3_out = {IDEX_ALU_control_in, IDEX_ALU_src_in, IDEX_RegWrite_in, IDEX_RegDst_in,
	//			 IDEX_MemRead_in, IDEX_MemWrite_in, IDEX_write_data_src_in};		// check
	wire sel_signal;
	//mux2_11b MUX_3 (11'b0, mux3_in , sel_signal, mux3_out);		// done
	
	mux2_11b MUX_3 (11'b0, mux3_in , sel_signal, {IDEX_ALU_control_in, IDEX_ALU_src_in, IDEX_RegWrite_in, IDEX_RegDst_in,
				 IDEX_MemRead_in, IDEX_MemWrite_in, IDEX_write_data_src_in});

	IDEX IDEX_reg (	clk, rst,
			data1, data2, extended_inst16, 
			IFID_inst[20:16], IFID_inst[15:11], IFID_inst[25:21], 
			IFID_PC_4, mux2_out,
        		IDEX_data1, IDEX_data2, IDEX_extended_inst16, 
			IDEX_Rt, IDEX_Rd, IDEX_Rs, 
			IDEX_PC_4, IDEX_mux2_out);			// done. mux2_out, IDEX_mux2_out


	IDEX_control IDEX_reg_control (	clk, rst,
					IDEX_ALU_control_in, IDEX_ALU_src_in,
					IDEX_RegWrite_in, IDEX_RegDst_in,
					IDEX_MemRead_in, IDEX_MemWrite_in,
					IDEX_write_data_src_in,
					IDEX_ALU_control, IDEX_ALU_src,
					IDEX_RegWrite, IDEX_RegDst,
					IDEX_MemRead, IDEX_MemWrite,
					IDEX_write_data_src);	// done


	// Execution

	wire [31:0] ALU_A_in;
	wire [31:0] EXMEM_ALU_res;
	wire [1:0] forwardA;
	mux3_32b MUX_4 (IDEX_data1, write_data, EXMEM_ALU_res, forwardA, ALU_A_in);	// done

	wire [31:0] mux5_out;
	wire [1:0] forwardB;
	mux3_32b MUX_5 (IDEX_data2, write_data, EXMEM_ALU_res, forwardB, mux5_out);	// done
	
	wire [31:0] ALU_B_in;
	mux2_32b MUX_6 (mux5_out, IDEX_extended_inst16, IDEX_ALU_src, ALU_B_in);	// done

	wire [31:0] ALU_res;
	ALU ALU_1 (ALU_A_in, ALU_B_in, IDEX_ALU_control, ALU_res, zero);		// done


	// EX/MEM

	wire [31:0] EXMEM_PC_4;
	wire EXMEM_zero;
	wire [31:0] EXMEM_mux5_out;
	wire [4:0]  EXMEM_mux2_out;
	EXMEM EXMEM_reg(clk, rst,
			IDEX_PC_4,
			zero,				// outpute in bayad wire she
			ALU_res,
			mux5_out,			// check
			IDEX_mux2_out,			// check
			EXMEM_PC_4,
			EXMEM_zero, 
			EXMEM_ALU_res,
			EXMEM_mux5_out, 
			EXMEM_mux2_out);		// done


	wire EXMEM_MemWrite, EXMEM_MemRead;
        wire [1:0] EXMEM_write_data_src;		
        wire EXMEM_RegWrite;
	EXMEM_control EXMEM_reg_control (clk, rst,
                  			IDEX_MemWrite, IDEX_MemRead,
                  			IDEX_write_data_src,			// check
                  			IDEX_RegWrite,
                  			EXMEM_MemWrite, EXMEM_MemRead,
                  			EXMEM_write_data_src,			// check
                  			EXMEM_RegWrite);			// done

	
	// MEM
	
	wire [31:0] mem_data;
	data_memory DM (clk, EXMEM_ALU_res, EXMEM_mux5_out, EXMEM_MemRead, EXMEM_MemWrite, mem_data);	// done
	
	
	// MEM_WB
	
	wire [31:0] MEMWB_mem_data;
	wire [31:0] MEMWB_ALU_res;
	wire [4:0] MEMWB_mux2_out;		// check
	wire [31:0] MEMWB_PC_4;
	MEMWB MEMWB_reg (clk, rst,
			 mem_data, EXMEM_ALU_res, EXMEM_mux2_out, EXMEM_PC_4,
			 MEMWB_mem_data, MEMWB_ALU_res, MEMWB_mux2_out, MEMWB_PC_4);	// done

	wire [1:0] MEMWB_write_data_src;
	MEMWB_control MEMWB_reg_control (clk, rst,
                  			EXMEM_write_data_src, EXMEM_RegWrite,
                  			MEMWB_write_data_src, MEMWB_RegWrite);		// done

	assign write_reg = MEMWB_mux2_out;


	// WB 
	mux3_32b MUX_7 (MEMWB_ALU_res, MEMWB_mem_data, MEMWB_PC_4, MEMWB_write_data_src, write_data);	// done


	// Forwarding Unit

	forwarding_unit FU(IDEX_Rs, IDEX_Rt, 
			EXMEM_RegWrite, EXMEM_mux2_out, 
			MEMWB_RegWrite, MEMWB_mux2_out,
			forwardA, forwardB);


	// Hazard Detection Unit
	
	hazard_detection_unit HU(IDEX_MemRead, 
				IDEX_Rt, IFID_Rs, IFID_Rt,
				sel_signal, IFID_load, PC_load);
	

endmodule