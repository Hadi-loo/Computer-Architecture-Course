
module data_memory (input clk, input [31:0] adr, input [31:0] data_in, input MemRead, MemWrite, output [31:0] data_out);
    
    	reg [7:0] mem [0:4095];
    
    	initial begin
        	$readmemb("nums8b_SC.mem", mem);
    	end
    
    	always @(posedge clk) begin
        	if (MemWrite) 
			{ mem[adr[11:0]], mem[adr[11:0]+1], mem[adr[11:0]+2], mem[adr[11:0]+3] } = data_in;
        end
    
    	assign data_out = (MemRead == 1'b1) ? {mem[adr[11:0]], mem[adr[11:0]+1], mem[adr[11:0]+2], mem[adr[11:0]+3]} : 32'd0;

endmodule
