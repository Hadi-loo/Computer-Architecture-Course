
module controller (	input [5:0] opcode, func,
                   	input zero,
                   	output reg [1:0] reg_dst,
                   	output reg [1:0] mem_to_reg,
                   	output reg reg_write, alu_src, mem_read, mem_write,
                   	output reg [1:0] pc_src,
                   	output reg [2:0] operation,
                   	output reg IFflush,
                   	input operands_equal);
        
    reg [1:0] alu_op;
    reg branch;
    
    alu_controller ALU_CTRL(alu_op, func, operation);
    
    always @(opcode) begin
        {reg_dst, mem_to_reg, reg_write, alu_src, mem_read, mem_write, pc_src, alu_op, IFflush} = {2'b00, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 2'b00, 1'b0};
        case (opcode)
            // RType instructions
            6'b000000 : {reg_dst, reg_write, alu_op} = {2'b01, 1'b1, 2'b10};

            // Load Word (lw) instruction
            6'b100011 : {alu_src, mem_to_reg, reg_write, mem_read} = {1'b1, 2'b01, 1'b1, 1'b1};
            
            // Store Word (sw) instruction
            6'b101011 : {alu_src, mem_write} = 2'b11;

            // Branch on equal (beq) instruction
            6'b000100 : {pc_src, IFflush} = {1'b0, operands_equal, operands_equal}; //operands_equal ? 2'b01 : 2'b00
            
            // Add immediate (addi) instruction
            6'b001000: {reg_write, alu_src} = 2'b11;
            
            // Jump (j) instruction
            6'b000010: {pc_src, IFflush} = {2'b10, 1'b1};
            
            // Jump and link (jal) instruction
            6'b000011: {reg_dst, mem_to_reg, pc_src} = {2'b10, 2'b10, 2'b10};
            
            // Jump Register (JR) instruction
            6'b000110: {pc_src} = {2'b11};
            
            // Set Less Than immediate (SLTi) instruction
            6'b001010: {alu_src, reg_dst, reg_write, alu_op, mem_to_reg} = {1'b1, 2'b00, 1'b1, 2'b11, 2'b00}; 

            //NOP (No Operation) 
            //6'b111111: hame 0 mimoonan
        endcase
    end
    
    //assign pc_src = branch & zero;
    
endmodule


module alu_controller (input [1:0] alu_op,
                       input [5:0] func,
                       output reg [2:0] operation);
    
    always @(alu_op, func) begin
        operation = 3'b000;
        if (alu_op == 2'b00)        // lw or sw
            operation = 3'b010;
        else if (alu_op == 2'b01)   // beq
            operation = 3'b110;
        else if (alu_op == 2'b11)
            operation = 3'b111; //slti
        else
        begin
            case (func)
                6'b100000: operation = 3'b010;  // add
                6'b100010: operation = 3'b110;  // sub
                6'b100100: operation = 3'b000;  // and
                6'b100101: operation = 3'b001;  // or
                6'b101010: operation = 3'b111;  // slt
                default:   operation = 3'b000;
            endcase
        end
        
    end
    
endmodule
