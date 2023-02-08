
module memory (input clk, MemRead, MemWrite, input [11:0] adr, input [15:0] data_in, 
		output [15:0] data_out);
    
    	reg [15:0] mem [0:4095];
    
    	initial begin
        	$readmemb("nums16b.mem", mem);
    	end
    
    	always @(posedge clk) begin
        	if (MemWrite) 
			mem[adr] <= data_in;
        end
    
    	assign data_out = (MemRead == 1'b1) ? mem[adr] : 32'd0;

endmodule
