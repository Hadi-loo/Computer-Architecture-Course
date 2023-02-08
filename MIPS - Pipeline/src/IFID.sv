
module IFID (	input clk, rst, ld, flush, 
		input [31:0] inst, PC_4, 
		output reg [31:0] inst_out, PC_4_out);

	always @(posedge clk) begin
        	if (flush) begin
            		//inst_out <= {6'b111111, 26'b0}; //nop
            		inst_out <= 32'b0;
        	end
        	
		else if (rst) begin
            		PC_4_out <= 32'b0;
            		inst_out <= 32'b0;
        	end

        	else begin
            		if (ld) begin
                		inst_out <= inst;
                		PC_4_out <= PC_4;    
            		end
        	end
    	end
endmodule
